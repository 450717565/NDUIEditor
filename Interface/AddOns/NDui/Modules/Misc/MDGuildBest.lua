local _, ns = ...
local B, C, L, DB = unpack(ns)
local MISC = B:GetModule("Misc")

local format, strsplit, tonumber, pairs, wipe = format, strsplit, tonumber, pairs, wipe
local Ambiguate = Ambiguate
local C_MythicPlus_GetRunHistory = C_MythicPlus.GetRunHistory
local C_ChallengeMode_GetMapUIInfo = C_ChallengeMode.GetMapUIInfo
local C_ChallengeMode_GetGuildLeaders = C_ChallengeMode.GetGuildLeaders
local C_MythicPlus_GetOwnedKeystoneLevel = C_MythicPlus.GetOwnedKeystoneLevel
local C_MythicPlus_GetOwnedKeystoneChallengeMapID = C_MythicPlus.GetOwnedKeystoneChallengeMapID
local CHALLENGE_MODE_POWER_LEVEL = CHALLENGE_MODE_POWER_LEVEL
local CHALLENGE_MODE_GUILD_BEST_LINE = CHALLENGE_MODE_GUILD_BEST_LINE
local CHALLENGE_MODE_GUILD_BEST_LINE_YOU = CHALLENGE_MODE_GUILD_BEST_LINE_YOU
local WEEKLY_REWARDS_MYTHIC_TOP_RUNS = WEEKLY_REWARDS_MYTHIC_TOP_RUNS

local frame
local hasAngryKeystones
local WeeklyRunsThreshold = 10

local mlvl, wlvl
local nameString = "|c%s%s|r"
local mapString = "|cffFFFFFF%s|r (%s)"

function MISC:GuildBest_UpdateTooltip()
	local leaderInfo = self.leaderInfo
	if not leaderInfo then return end

	local mapName = C_ChallengeMode_GetMapUIInfo(leaderInfo.mapChallengeModeID)
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	GameTooltip:AddLine(format(mapString, mapName, leaderInfo.keystoneLevel))
	GameTooltip:AddLine(" ")
	for i = 1, #leaderInfo.members do
		local classColorStr = DB.ClassColors[leaderInfo.members[i].classFileName].colorStr
		GameTooltip:AddLine(format(nameString, classColorStr,leaderInfo.members[i].name));
	end
	GameTooltip:Show()
end

function MISC:GuildBest_Create()
	frame = CreateFrame("Frame", nil, ChallengesFrame)
	frame:SetPoint("BOTTOMRIGHT", -5, 75)
	frame:SetSize(246, 105)
	B.CreateBDFrame(frame)
	B.CreateFS(frame, 16, CHALLENGE_MODE_WEEKLY_BEST , "system", "TOPLEFT", 16, -6)

	frame.entries = {}
	for i = 1, 4 do
		local entry = CreateFrame("Frame", nil, frame)
		entry:SetPoint("LEFT", 10, 0)
		entry:SetPoint("RIGHT", -10, 0)
		entry:SetHeight(18)
		entry.Name = B.CreateFS(entry, 14, "", false, "LEFT", 6, 0)
		entry.Name:SetPoint("RIGHT", -30, 0)
		entry.Level = B.CreateFS(entry, 14, "", "system", "RIGHT", 0, 0)
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

function MISC:GuildBest_SetUp(leaderInfo)
	self.leaderInfo = leaderInfo

	local mapName = C_ChallengeMode_GetMapUIInfo(leaderInfo.mapChallengeModeID)
	local classColorStr = DB.ClassColors[leaderInfo.classFileName].colorStr
	self.Name:SetText(format(nameString, classColorStr, leaderInfo.name))
	self.Level:SetText(format(mapString, mapName, leaderInfo.keystoneLevel))
end

local resize
function MISC:GuildBest_Update()
	if not frame then MISC:GuildBest_Create() end

	if self.leadersAvailable then
		local leaders = C_ChallengeMode_GetGuildLeaders()
		if leaders and #leaders > 0 then
			for i = 1, #leaders do
				MISC.GuildBest_SetUp(frame.entries[i], leaders[i])
			end
			frame:Show()
		else
			frame:Hide()
		end
	end

	if not resize and hasAngryKeystones then
		local Child = self.WeeklyInfo.Child
		B.UpdatePoint(Child.ThisWeekLabel, "TOP", Child, "TOP", -135, -25)

		local affix = Child.Affixes[1]
		if affix then
			B.UpdatePoint(affix, "TOPLEFT", Child, "TOPLEFT", 20, -55)
		end

		local WeeklyChest = Child.WeeklyChest
		local Schedule = AngryKeystones.Modules.Schedule
		B.UpdatePoint(frame, "BOTTOMLEFT", Schedule.AffixFrame, "TOPLEFT", 0, 10)
		B.UpdatePoint(Schedule.KeystoneText, "TOP", WeeklyChest, "BOTTOM", 0, -30)
		B.UpdatePoint(Child.DungeonScoreInfo, "CENTER", WeeklyChest, "BOTTOM", 0, 0)
		B.UpdatePoint(WeeklyChest.RunStatus, "BOTTOM", WeeklyChest, "TOP", 0, 30)

		resize = true
	end
end

function MISC.GuildBest_OnLoad(event, addon)
	if addon == "Blizzard_ChallengesUI" then
		hooksecurefunc("ChallengesFrame_Update", MISC.GuildBest_Update)
		MISC:KeystoneInfo_Create()
		ChallengesFrame.WeeklyInfo.Child.WeeklyChest:HookScript("OnEnter", MISC.KeystoneInfo_WeeklyRuns)

		B:UnregisterEvent(event, MISC.GuildBest_OnLoad)
	end
end

local function sortHistory(entry1, entry2)
	if entry1.level == entry2.level then
		return entry1.mapChallengeModeID < entry2.mapChallengeModeID
	else
		return entry1.level > entry2.level
	end
end

function MISC:KeystoneInfo_WeeklyRuns()
	local runHistory = C_MythicPlus_GetRunHistory(false, true)
	local numRuns = runHistory and #runHistory
	if numRuns > 0 then
		GameTooltip:AddLine(" ")
		GameTooltip:AddDoubleLine(format(WEEKLY_REWARDS_MYTHIC_TOP_RUNS, WeeklyRunsThreshold), numRuns, 1,1,1, .6,.8,1)
		sort(runHistory, sortHistory)

		for i = 1, WeeklyRunsThreshold do
			local runInfo = runHistory[i]
			if not runInfo then break end

			local name = C_ChallengeMode_GetMapUIInfo(runInfo.mapChallengeModeID)
			local r,g,b = 0,1,0
			if not runInfo.completed then r,g,b = 1,0,0 end
			GameTooltip:AddDoubleLine(name, "Lv."..runInfo.level, nil,nil,nil, r,g,b)
		end
		GameTooltip:Show()
	end
end

-- Keystone Info
function MISC:KeystoneInfo_Create()
	local texture = select(10, GetItemInfo(158923)) or 525134
	local button = CreateFrame("Frame", "KeystoneInfo", ChallengesFrame)
	button:SetPoint("BOTTOMLEFT", ChallengesFrame.WeeklyInfo.Child.SeasonBest, "TOPLEFT", 0, 3)
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
			local color = B.HexRGB(B.GetClassColor(class))
			local factionColor = faction == "Horde" and "|cffFF5040" or "|cff4080FF"
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

function MISC:KeystoneInfo_UpdateBag()
	local keystoneMapID = C_MythicPlus_GetOwnedKeystoneChallengeMapID()
	if keystoneMapID then
		return keystoneMapID, C_MythicPlus_GetOwnedKeystoneLevel()
	end
end

function MISC:KeystoneInfo_Update()
	local mapID, keystoneLevel = MISC:KeystoneInfo_UpdateBag()
	if mapID then
		NDuiADB["KeystoneInfo"][DB.MyFullName] = mapID..":"..keystoneLevel..":"..DB.MyClass..":"..DB.MyFaction
	else
		NDuiADB["KeystoneInfo"][DB.MyFullName] = nil
	end
end

function MISC:GuildBest()
	if not C.db["Misc"]["MDGuildBest"] then return end

	hasAngryKeystones = IsAddOnLoaded("AngryKeystones")
	B:RegisterEvent("ADDON_LOADED", MISC.GuildBest_OnLoad)

	MISC:KeystoneInfo_Update()
	B:RegisterEvent("BAG_UPDATE", MISC.KeystoneInfo_Update)
end
MISC:RegisterMisc("GuildBest", MISC.GuildBest)