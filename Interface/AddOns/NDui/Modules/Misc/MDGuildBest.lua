local _, ns = ...
local B, C, L, DB = unpack(ns)
local M = B:GetModule("Misc")

local CHALLENGE_MODE_WEEKLY_BEST = CHALLENGE_MODE_WEEKLY_BEST
local Ambiguate, GetContainerNumSlots, GetContainerItemInfo = Ambiguate, GetContainerNumSlots, GetContainerItemInfo
local C_ChallengeMode_GetMapUIInfo, C_ChallengeMode_GetGuildLeaders = C_ChallengeMode.GetMapUIInfo, C_ChallengeMode.GetGuildLeaders
local format, strsplit, strmatch, tonumber, pairs, wipe, select = string.format, string.split, string.match, tonumber, pairs, wipe, select

local frame
local nameString = "|c%s%s|r"
local mapString = "|cffFFFFFF%s|r (%s)"

function M:GuildBest_UpdateTooltip()
	local leaderInfo = self.leaderInfo
	if not leaderInfo then return end

	local mapName = C_ChallengeMode_GetMapUIInfo(leaderInfo.mapChallengeModeID)
	local _, suffix = strsplit("-", mapName)
	if suffix then mapName = suffix end
	mapName = gsub(mapName, L["!"], "")

	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	GameTooltip:AddLine(format(mapString, mapName, leaderInfo.keystoneLevel))
	for i = 1, #leaderInfo.members do
		local classColorStr = DB.ClassColors[leaderInfo.members[i].classFileName].colorStr
		GameTooltip:AddLine(format(nameString, classColorStr,leaderInfo.members[i].name));
	end
	GameTooltip:Show()
end

function M:GuildBest_Create()
	frame = CreateFrame("Frame", nil, ChallengesFrame)
	frame:SetPoint("BOTTOMRIGHT", -6, 80)
	frame:SetSize(170, 105)
	B.CreateBDFrame(frame, 0)
	B.CreateFS(frame, 16, CHALLENGE_MODE_WEEKLY_BEST , "system", "TOPLEFT", 16, -6)

	frame.entries = {}
	for i = 1, 4 do
		local entry = CreateFrame("Frame", nil, frame)
		entry:SetPoint("LEFT", 10, 0)
		entry:SetPoint("RIGHT", -10, 0)
		entry:SetHeight(18)
		entry.Name = B.CreateFS(entry, 14, "", false, "LEFT", 6, 0)
		entry.Name:SetJustifyH("LEFT")
		entry.Name:SetPoint("RIGHT", -30, 0)
		entry.Level = B.CreateFS(entry, 14, "", "system", "RIGHT", 0, 0)
		entry.Level:SetJustifyH("RIGHT")
		entry:SetScript("OnEnter", self.GuildBest_UpdateTooltip)
		entry:SetScript("OnLeave", B.HideTooltip)

		if i == 1 then
			entry:SetPoint("TOP", frame, 0, -26)
		else
			entry:SetPoint("TOP", frame.entries[i-1], "BOTTOM")
		end

		frame.entries[i] = entry
	end
end

function M:GuildBest_SetUp(leaderInfo)
	self.leaderInfo = leaderInfo

	local mapName = C_ChallengeMode_GetMapUIInfo(leaderInfo.mapChallengeModeID)
	local classColorStr = DB.ClassColors[leaderInfo.classFileName].colorStr

	local _, suffix = strsplit("-", mapName)
	if suffix then mapName = suffix end
	mapName = gsub(mapName, L["!"], "")

	self.Name:SetText(format(nameString, classColorStr, leaderInfo.name))
	self.Level:SetText(format(mapString, mapName, leaderInfo.keystoneLevel))
end

local resize
function M:GuildBest_Update()
	if not frame then M:GuildBest_Create() end
	if self.leadersAvailable then
		local leaders = C_ChallengeMode_GetGuildLeaders()
		if leaders and #leaders > 0 then
			for i = 1, #leaders do
				M.GuildBest_SetUp(frame.entries[i], leaders[i])
			end
			frame:Show()
		else
			frame:Hide()
		end
	end

	if not resize and IsAddOnLoaded("AngryKeystones") then
		local AffixFrame = AngryKeystones.Modules.Schedule.AffixFrame
		frame:SetWidth(246)
		frame:ClearAllPoints()
		frame:SetPoint("BOTTOMLEFT", AffixFrame, "TOPLEFT", 0, 10)

		self.WeeklyInfo.Child.Label:SetPoint("TOP", -135, -25)
		local affix = self.WeeklyInfo.Child.Affixes[1]
		if affix then
			affix:ClearAllPoints()
			affix:SetPoint("TOPLEFT", 20, -55)
		end

		resize = true
	end
end

function M.GuildBest_OnLoad(event, addon)
	if addon == "Blizzard_ChallengesUI" then
		hooksecurefunc("ChallengesFrame_Update", M.GuildBest_Update)
		M:KeystoneInfo_Create()

		B:UnregisterEvent(event, M.GuildBest_OnLoad)
	end
end

-- Keystone Info
local mlvl, wlvl
local myFaction = DB.MyFaction
local myFullName = DB.MyName.."-"..DB.MyRealm

function M:KeystoneInfo_Create()
	local texture = select(10, GetItemInfo(158923)) or 525134
	local button = CreateFrame("Frame", nil, ChallengesFrame)
	button:SetPoint("BOTTOMRIGHT", ChallengesFrame, "BOTTOMRIGHT", -3, 48)
	button:SetSize(30, 30)
	B.PixelIcon(button, texture, true)
	button:SetBackdropBorderColor(0, .8, 1)
	button:SetScript("OnEnter", function(self)
		GameTooltip:ClearLines()
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:AddLine(L["Account Keystones"])
		for name, info in pairs(NDuiADB["KeystoneInfo"]) do
			local name = Ambiguate(name, "none")
			local mapID, level, class, faction = strsplit(":", info)
			local color = B.HexRGB(B.ClassColor(class))
			local factionColor = faction == "Horde" and "|cffff5040" or "|cff00adf0"
			local dungeon = C_ChallengeMode_GetMapUIInfo(tonumber(mapID))
			local _, suffix = strsplit("-", dungeon)
			if suffix then dungeon = suffix end
			dungeon = gsub(dungeon, L["!"], "")
			GameTooltip:AddDoubleLine(format(color.."%s|r", name), format("%s%s (%s)|r", factionColor, dungeon, level))
		end
		GameTooltip:AddDoubleLine(" ", DB.LineString)
		GameTooltip:AddDoubleLine(" ", DB.ScrollButton..L["Reset Gold"].." ", 1,1,1, .6,.8,1)
		GameTooltip:AddDoubleLine(" ", L["Mythic Loot Info"], 1,1,1, .6,.8,1)
		if IsShiftKeyDown() then
			GameTooltip:AddDoubleLine(" ", DB.LineString)
			for i = 2, 15 do
				mlvl = DB.MythicLoot[i]
				wlvl = DB.WeeklyLoot[i]
				GameTooltip:AddDoubleLine(format(L["Mythic Level"], DB.MyColor..i.."|r"), format(L["Mythic & Weekly Loot"], DB.MyColor..mlvl.."|r", DB.MyColor..wlvl.."|r"))
			end
		end
		GameTooltip:Show()
	end)
	button:SetScript("OnLeave", B.HideTooltip)
	button:SetScript("OnMouseUp", function(_, btn)
		if btn == "MiddleButton" then
			wipe(NDuiADB["KeystoneInfo"])
		end
	end)
end

function M:KeystoneInfo_UpdateBag()
	for bag = 0, 4 do
		local numSlots = GetContainerNumSlots(bag)
		for slot = 1, numSlots do
			local slotLink = select(7, GetContainerItemInfo(bag, slot))
			local itemString = slotLink and strmatch(slotLink, "|Hkeystone:([0-9:]+)|h(%b[])|h")
			if itemString then
				return slotLink, itemString
			end
		end
	end
end

function M:KeystoneInfo_Update()
	local link, itemString = M:KeystoneInfo_UpdateBag()
	if link then
		local _, mapID, level = strsplit(":", itemString)
		NDuiADB["KeystoneInfo"][myFullName] = mapID..":"..level..":"..DB.MyClass..":"..myFaction
	else
		NDuiADB["KeystoneInfo"][myFullName] = nil
	end
end

function M:GuildBest()
	B:RegisterEvent("ADDON_LOADED", self.GuildBest_OnLoad)

	self:KeystoneInfo_Update()
	B:RegisterEvent("BAG_UPDATE", self.KeystoneInfo_Update)
end