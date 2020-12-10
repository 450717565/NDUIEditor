local _, ns = ...
local B, C, L, DB = unpack(ns)
local Misc = B:GetModule("Misc")

local format, strsplit, tonumber, pairs, wipe = format, strsplit, tonumber, pairs, wipe
local Ambiguate = Ambiguate
local C_ChallengeMode_GetMapUIInfo = C_ChallengeMode.GetMapUIInfo
local C_ChallengeMode_GetGuildLeaders = C_ChallengeMode.GetGuildLeaders
local C_MythicPlus_GetOwnedKeystoneLevel = C_MythicPlus.GetOwnedKeystoneLevel
local C_MythicPlus_GetOwnedKeystoneChallengeMapID = C_MythicPlus.GetOwnedKeystoneChallengeMapID
local CHALLENGE_MODE_POWER_LEVEL = CHALLENGE_MODE_POWER_LEVEL
local CHALLENGE_MODE_GUILD_BEST_LINE = CHALLENGE_MODE_GUILD_BEST_LINE
local CHALLENGE_MODE_GUILD_BEST_LINE_YOU = CHALLENGE_MODE_GUILD_BEST_LINE_YOU

local hasAngryKeystones
local frame
local nameString = "|c%s%s|r"
local mapString = "|cffFFFFFF%s|r (%s)"

function Misc:GuildBest_UpdateTooltip()
	local leaderInfo = self.leaderInfo
	if not leaderInfo then return end

	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	GameTooltip:AddLine(format(mapString, mapName, leaderInfo.keystoneLevel))
	for i = 1, #leaderInfo.members do
		local classColorStr = DB.ClassColors[leaderInfo.members[i].classFileName].colorStr
		GameTooltip:AddLine(format(nameString, classColorStr,leaderInfo.members[i].name));
	end
	GameTooltip:Show()
end

function Misc:GuildBest_Create()
	frame = CreateFrame("Frame", nil, ChallengesFrame)
	frame:SetPoint("BOTTOMRIGHT", -8, 75)
	frame:SetSize(170, 105)
	B.CreateBDFrame(frame)
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

	if not hasAngryKeystones then
		ChallengesFrame.WeeklyInfo.Child.Description:SetPoint("CENTER", 0, 20)
	end
end

function Misc:GuildBest_SetUp(leaderInfo)
	self.leaderInfo = leaderInfo

	local mapName = C_ChallengeMode_GetMapUIInfo(leaderInfo.mapChallengeModeID)
	local classColorStr = DB.ClassColors[leaderInfo.classFileName].colorStr
	self.Name:SetText(format(nameString, classColorStr, leaderInfo.name))
	self.Level:SetText(format(mapString, mapName, leaderInfo.keystoneLevel))
end

local resize
function Misc:GuildBest_Update()
	if not frame then Misc:GuildBest_Create() end
	if self.leadersAvailable then
		local leaders = C_ChallengeMode_GetGuildLeaders()
		if leaders and #leaders > 0 then
			for i = 1, #leaders do
				Misc.GuildBest_SetUp(frame.entries[i], leaders[i])
			end
			frame:Show()
		else
			frame:Hide()
		end
	end

	if not resize and hasAngryKeystones then
		local AffixFrame = AngryKeystones.Modules.Schedule.AffixFrame
		frame:SetWidth(246)
		frame:ClearAllPoints()
		frame:SetPoint("BOTTOMLEFT", AffixFrame, "TOPLEFT", 0, 10)

		self.WeeklyInfo.Child.ThisWeekLabel:SetPoint("TOP", -135, -25)
		local affix = self.WeeklyInfo.Child.Affixes[1]
		if affix then
			affix:ClearAllPoints()
			affix:SetPoint("TOPLEFT", 20, -55)
		end

		resize = true
	end
end

function Misc.GuildBest_OnLoad(event, addon)
	if addon == "Blizzard_ChallengesUI" then
		hooksecurefunc("ChallengesFrame_Update", Misc.GuildBest_Update)
		Misc:KeystoneInfo_Create()

		B:UnregisterEvent(event, Misc.GuildBest_OnLoad)
	end
end

-- Keystone Info
local mlvl, wlvl
local myFullName = DB.MyFullName

function Misc:KeystoneInfo_Create()
	local texture = select(10, GetItemInfo(158923)) or 525134
	local button = CreateFrame("Frame", nil, ChallengesFrame)
	button:SetPoint("BOTTOMRIGHT", ChallengesFrame, "BOTTOMRIGHT", -3, 48)
	button:SetSize(30, 30)
	B.PixelIcon(button, texture, true)
	button.icbg:SetBackdropBorderColor(0, .8, 1)
	button:SetScript("OnEnter", function(self)
		GameTooltip:ClearLines()
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:AddLine(L["Account Keystones"])
		for fullName, info in pairs(NDuiADB["KeystoneInfo"]) do
			local name = Ambiguate(fullName, "none")
			local mapID, level, class, faction = strsplit(":", info)
			local color = B.HexRGB(B.ClassColor(class))
			local factionColor = faction == "Horde" and "|cffff5040" or "|cff00adf0"
			local dungeon = C_ChallengeMode_GetMapUIInfo(tonumber(mapID))
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

function Misc:KeystoneInfo_UpdateBag()
	local keystoneMapID = C_MythicPlus_GetOwnedKeystoneChallengeMapID()
	if keystoneMapID then
		return keystoneMapID, C_MythicPlus_GetOwnedKeystoneLevel()
	end
end

function Misc:KeystoneInfo_Update()
	local mapID, keystoneLevel = Misc:KeystoneInfo_UpdateBag()
	if mapID then
		NDuiADB["KeystoneInfo"][myFullName] = mapID..":"..keystoneLevel..":"..DB.MyClass..":"..DB.MyFaction
	else
		NDuiADB["KeystoneInfo"][myFullName] = nil
	end
end

function Misc:GuildBest()
	hasAngryKeystones = IsAddOnLoaded("AngryKeystones")
	B:RegisterEvent("ADDON_LOADED", Misc.GuildBest_OnLoad)

	Misc:KeystoneInfo_Update()
	B:RegisterEvent("BAG_UPDATE", Misc.KeystoneInfo_Update)
end
Misc:RegisterMisc("GuildBest", Misc.GuildBest)