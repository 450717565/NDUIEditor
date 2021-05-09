local _, ns = ...
local B, C, L, DB, P = unpack(ns)
local EX = B:GetModule("Extras")
local TT = B:GetModule("Tooltip")
---------------------------------
-- ElvUI_WindTools, by fang2hou
---------------------------------
local cache = {}
local compareGUID, loadedComparison

local tiers = {
	"Castle Nathria",
}

local levels = {
	"Mythic",
	"Heroic",
	"Normal",
	"Raid Finder"
}

local locales = {
	-- 难度
	["Raid Finder"] = PLAYER_DIFFICULTY3,
	["Normal"] = PLAYER_DIFFICULTY1,
	["Heroic"] = PLAYER_DIFFICULTY2,
	["Mythic"] = PLAYER_DIFFICULTY6,

	-- 特殊成就
	["Special Achievement"] = L["Special Achievement"],
	["KM: Season One"] = L["KM: Season One"],			-- 钥石大师：第一赛季
	["AC: Sire Denathrius"] = L["AC: Sire Denathrius"],	-- 引领潮流：德纳修斯大帝
	["CE: Sire Denathrius"] = L["CE: Sire Denathrius"],	-- 千钧一发：德纳修斯大帝

	--团本
	["Castle Nathria"] = L["Castle Nathria"],

	-- 地下城
	["The Necrotic Wake"] = L["The Necrotic Wake"],
	["Plaguefall"] = L["Plaguefall"],
	["Mists of Tirna Scithe"] = L["Mists of Tirna Scithe"],
	["Halls of Atonement"] = L["Halls of Atonement"],
	["Theater of Pain"] = L["Theater of Pain"],
	["De Other Side"] = L["De Other Side"],
	["Spires of Ascension"] = L["Spires of Ascension"],
	["Sanguine Depths"] = L["Sanguine Depths"],
}

local raidAchievements = {
	["Castle Nathria"] = {
		["Mythic"] = {
			14421,
			14425,
			14429,
			14433,
			14437,
			14441,
			14445,
			14449,
			14453,
			14457,
		},
		["Heroic"] = {
			14420,
			14424,
			14428,
			14432,
			14436,
			14440,
			14444,
			14448,
			14452,
			14456,
		},
		["Normal"] = {
			14419,
			14423,
			14427,
			14431,
			14435,
			14439,
			14443,
			14447,
			14451,
			14455,
		},
		["Raid Finder"] = {
			14422,
			14426,
			14430,
			14434,
			14438,
			14442,
			14446,
			14450,
			14454,
			14458,
		}
	}
}

local dungeonAchievements = {
	["The Necrotic Wake"] = 14404,
	["Plaguefall"] = 14398,
	["Mists of Tirna Scithe"] = 14395,
	["Halls of Atonement"] = 14392,
	["Theater of Pain"] = 14407,
	["De Other Side"] = 14389,
	["Spires of Ascension"] = 14401,
	["Sanguine Depths"] = 14205,
}

local specialAchievements = {
	["KM: Season One"] = 14532,
	["CE: Sire Denathrius"] = 14461,
	["AC: Sire Denathrius"] = 14460,
}

local function GetLevelColoredString(level)
	local color = "FFFFFF"

	if level == "Mythic" then
		color = "FF0000"
	elseif level == "Heroic" then
		color = "FFFF00"
	elseif level == "Normal" then
		color = "00FF00"
	end

	return "|cff" .. color .. locales[level] .. "|r"
end

local function GetBossKillTimes(guid, achievementID)
	local func = guid == UnitGUID("player") and GetStatistic or GetComparisonStatistic
	return tonumber(func(achievementID), 10) or 0
end

local function GetAchievementInfoByID(guid, achievementID)
	local completed, month, day, year
	if guid == UnitGUID("player") then
		completed, month, day, year = select(4, GetAchievementInfo(achievementID))
	else
		completed, month, day, year = GetAchievementComparisonInfo(achievementID)
	end
	return completed, month, day, year
end

function EX:UpdateProgression(guid, faction)
	cache[guid] = cache[guid] or {}
	cache[guid].info = cache[guid].info or {}
	cache[guid].timer = GetTime()

	if C.db["Extras"]["ProgAchievement"] then
		cache[guid].info.special = {}

		for name, achievementID in pairs(specialAchievements) do
			local completed, month, day, year = GetAchievementInfoByID(guid, achievementID)
			local completedString = "|cffFF0000" .. L["Not Completed"] .. "|r"
			if completed then
				completedString = gsub(L["%month%-%day%-%year%"], "%%month%%", month)
				completedString = gsub(completedString, "%%day%%", day)
				completedString = gsub(completedString, "%%year%%", 2000 + year)
				completedString = "|cff00FF00" .. completedString .. "|r"
			end

			cache[guid].info.special[name] = completedString
		end
	end

	if C.db["Extras"]["ProgRaids"] then
		cache[guid].info.raids = {}

		for _, tier in ipairs(tiers) do
			cache[guid].info.raids[tier] = {}
			local bosses = raidAchievements[tier]
			if bosses.separated then
				bosses = bosses[faction]
			end

			for _, level in ipairs(levels) do
				local alreadyKilled = 0
				for _, achievementID in pairs(bosses[level]) do
					if GetBossKillTimes(guid, achievementID) > 0 then
						alreadyKilled = alreadyKilled + 1
					end
				end

				if alreadyKilled > 0 then
					cache[guid].info.raids[tier][level] = format("%d / %d", alreadyKilled, #bosses[level])
					if alreadyKilled == #bosses[level] then
						break
					end
				end
			end
		end
	end

	if C.db["Extras"]["ProgDungeons"] then
		cache[guid].info.mythicDungeons = {}
		cache[guid].info.mythicDungeons.total = 0

		for name, achievementID in pairs(dungeonAchievements) do
			cache[guid].info.mythicDungeons[name] = GetBossKillTimes(guid, achievementID)
			cache[guid].info.mythicDungeons.total = cache[guid].info.mythicDungeons.total + cache[guid].info.mythicDungeons[name]
		end
	end
end

function EX:SetProgressionInfo(guid)
	if not cache[guid] then return end

	local updated = false

	for i = 2, GameTooltip:NumLines() do
		local leftTip = _G["GameTooltipTextLeft" .. i]
		local leftTipText = leftTip:GetText()
		local found = false

		if leftTipText then
			if C.db["Extras"]["ProgAchievement"] then
				for name, achievementID in pairs(specialAchievements) do
					if strfind(leftTipText, locales[name]) then
						local rightTip = _G["GameTooltipTextRight" .. i]
						leftTip:SetText(locales[name] .. "：")
						rightTip:SetText(cache[guid].info.special[name])
						updated = true
						found = true
						break
					end
					if found then
						break
					end
				end
			end

			found = false

			if C.db["Extras"]["ProgRaids"] then
				for _, tier in ipairs(tiers) do
					for _, level in ipairs(levels) do
						if strfind(leftTipText, locales[tier]) and strfind(leftTipText, locales[level]) then
							local rightTip = _G["GameTooltipTextRight" .. i]
							leftTip:SetText(format("%s %s：", locales[tier], GetLevelColoredString(level)))
							rightTip:SetText(cache[guid].info.raids[tier][level])
							updated = true
							found = true
							break
						end
					end

					if found then
						break
					end
				end
			end

			found = false

			if C.db["Extras"]["ProgDungeons"] then
				for name, achievementID in pairs(dungeonAchievements) do
					if strfind(leftTipText, locales[name]) then
						local rightTip = _G["GameTooltipTextRight" .. i]
						leftTip:SetText(locales[name] .. "：")
						rightTip:SetText(cache[guid].info.mythicDungeons[name])
						updated = true
						found = true
						break
					end

					if found then
						break
					end
				end
			end
		end
	end

	if updated then return end

	if C.db["Extras"]["ProgAchievement"] then
		GameTooltip:AddLine(" ")
		GameTooltip:AddLine(L["Special Achievement"].."：")

		for name, achievementID in pairs(specialAchievements) do
			local left = format("%s", locales[name])
			local right = cache[guid].info.special[name]
			GameTooltip:AddDoubleLine(left, right, .6,.8,1, 1,1,1)
		end
	end

	if C.db["Extras"]["ProgRaids"] and cache[guid].info.raids then
		local title = false

		for _, tier in ipairs(tiers) do
			for _, level in ipairs(levels) do
				if (cache[guid].info.raids[tier][level]) then
					if not title then
						GameTooltip:AddLine(" ")
						GameTooltip:AddLine(RAIDS.."：")

						title = true
					end

					local left = format("%s（%s）", locales[tier], GetLevelColoredString(level))
					local right = cache[guid].info.raids[tier][level]
					GameTooltip:AddDoubleLine(left, right, .6,.8,1, 1,1,1)
				end
			end
		end
	end

	if C.db["Extras"]["ProgDungeons"] and cache[guid].info.mythicDungeons then
		GameTooltip:AddLine(" ")
		GameTooltip:AddDoubleLine(MYTHIC_DUNGEONS.."：", cache[guid].info.mythicDungeons.total, nil,nil,nil, 1,1,1)

		for name, achievementID in pairs(dungeonAchievements) do
			local left = format("%s", locales[name])
			local right = cache[guid].info.mythicDungeons[name]
			GameTooltip:AddDoubleLine(left, right, .6,.8,1, 1,1,1)
		end
	end
end

function EX:GetAchievementInfo(GUID)
	if (compareGUID ~= GUID) then return end

	local unit = "mouseover"

	if UnitExists(unit) then
		local race = select(3, UnitRace(unit))
		local faction = race and C_CreatureInfo.GetFactionInfo(race).groupTag
		if faction then
			EX:UpdateProgression(GUID, faction)
			_G.GameTooltip:SetUnit(unit)
		end
	end

	ClearAchievementComparisonUnit()

	B:UnregisterEvent(self, EX.GetAchievementInfo)
end

function EX:AddProgression()
	if not C.db["Extras"]["Progression"] then return end

	if InCombatLockdown() then return end

	local unit = TT.GetUnit(self)
	if not unit or not CanInspect(unit) or not UnitIsPlayer(unit) then return end

	local level = UnitLevel(unit)
	if not (level and level == MAX_PLAYER_LEVEL) then return end

	GameTooltip:AddLine(" ")
	GameTooltip:AddLine(L["ShowByShift"], .6,.8,1)

	if not IsShiftKeyDown() then return end
	if not IsAddOnLoaded("Blizzard_AchievementUI") then
		AchievementFrame_LoadUI()
	end

	local guid = UnitGUID(unit)
	if not cache[guid] or (GetTime() - cache[guid].timer) > 600 then
		if guid == UnitGUID("player") then
			EX:UpdateProgression(guid, UnitFactionGroup("player"))
		else
			ClearAchievementComparisonUnit()

			if not loadedComparison and select(2, IsAddOnLoaded("Blizzard_AchievementUI")) then
				_G.AchievementFrame_DisplayComparison(unit)
				HideUIPanel(_G.AchievementFrame)
				ClearAchievementComparisonUnit()
				loadedComparison = true
			end

			compareGUID = guid

			if SetAchievementComparisonUnit(unit) then
				B:RegisterEvent("INSPECT_ACHIEVEMENT_READY", EX.GetAchievementInfo)
			end

			return
		end
	end

	EX:SetProgressionInfo(guid)
end

do
	if TT.OnTooltipSetUnit then
		hooksecurefunc(TT, "OnTooltipSetUnit", EX.AddProgression)
	end
end

local function loadFunc(event, addon)  -- fix
	if addon == "Blizzard_AchievementUI" then
		local origFunc = AchievementFrameComparison_UpdateStatusBars
		AchievementFrameComparison_UpdateStatusBars = function(id)
			if id and id ~= "summary" then
				origFunc(id)
			end
		end
		B:UnregisterEvent(event, loadFunc)
	end
end
B:RegisterEvent("ADDON_LOADED", loadFunc)