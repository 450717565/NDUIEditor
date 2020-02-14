local _, ns = ...
local B, C, L, DB = unpack(ns)
local oUF = ns.oUF or oUF

local AFK, DND, DEAD, PLAYER_OFFLINE = AFK, DND, DEAD, PLAYER_OFFLINE
local ALTERNATE_POWER_INDEX = Enum.PowerType.Alternate or 10
local UnitAlternatePowerTextureInfo = UnitAlternatePowerTextureInfo
local UnitIsDeadOrGhost, UnitIsConnected, UnitHasVehicleUI, UnitIsTapDenied, UnitIsPlayer = UnitIsDeadOrGhost, UnitIsConnected, UnitHasVehicleUI, UnitIsTapDenied, UnitIsPlayer
local UnitHealth, UnitHealthMax, UnitPower, UnitPowerType, UnitStagger = UnitHealth, UnitHealthMax, UnitPower, UnitPowerType, UnitStagger
local UnitClass, UnitReaction, UnitLevel, UnitClassification = UnitClass, UnitReaction, UnitLevel, UnitClassification
local UnitIsAFK, UnitIsDND, UnitIsDead, UnitIsGhost = UnitIsAFK, UnitIsDND, UnitIsDead, UnitIsGhost
local UnitIsWildBattlePet, UnitIsBattlePetCompanion, UnitBattlePetLevel = UnitIsWildBattlePet, UnitIsBattlePetCompanion, UnitBattlePetLevel
local GetNumArenaOpponentSpecs, GetCreatureDifficultyColor = GetNumArenaOpponentSpecs, GetCreatureDifficultyColor
local strmatch = string.match

oUF.Tags.Methods["health"] = function(unit)
	if UnitIsDeadOrGhost(unit) or not UnitIsConnected(unit) then
		return oUF.Tags.Methods["state"](unit)
	else
		local cur = UnitHealth(unit)
		local per = oUF.Tags.Methods["perhp"](unit)

		if (unit == "player" and not UnitHasVehicleUI(unit)) or unit == "target" or unit == "focus" then
			if per < 100 then
				return B.ColorText(per, false, B.FormatNumb(cur)).." | "..B.ColorText(per)
			else
				return B.FormatNumb(cur)
			end
		elseif strmatch(unit, "arena") or strmatch(unit, "boss") then
			return B.ColorText(per, true)
		elseif UnitInParty(unit) and strmatch(unit, "party") then
			return B.FormatNumb(cur)
		else
			return B.ColorText(per)
		end
	end
end
oUF.Tags.Events["health"] = "UNIT_HEALTH_FREQUENT UNIT_MAXHEALTH UNIT_NAME_UPDATE UNIT_CONNECTION PLAYER_FLAGS_CHANGED UNIT_STATS"

oUF.Tags.Methods["power"] = function(unit)
	local cur = UnitPower(unit)
	local per = oUF.Tags.Methods["perpp"](unit)

	if (unit == "player" and not UnitHasVehicleUI(unit)) or unit == "target" or unit == "focus" then
		if UnitPowerType(unit) == 0 then
			return B.ColorText(per, false, B.FormatNumb(cur))
		else
			return B.FormatNumb(cur)
		end
	elseif strmatch(unit, "arena") or strmatch(unit, "boss") then
		return B.ColorText(per, true)
	else
		return B.ColorText(per)
	end
end
oUF.Tags.Events["power"] = "UNIT_POWER_FREQUENT UNIT_MAXPOWER UNIT_DISPLAYPOWER"

oUF.Tags.Methods["color"] = function(unit)
	local class = select(2, UnitClass(unit))
	local reaction = UnitReaction(unit, "player")

	if UnitIsDeadOrGhost(unit) or not UnitIsConnected(unit) then
		return "|cffC0C0C0"
	elseif UnitIsTapDenied(unit) then
		return B.HexRGB(oUF.colors.tapped)
	elseif UnitIsPlayer(unit) then
		return B.HexRGB(oUF.colors.class[class])
	elseif reaction then
		return B.HexRGB(oUF.colors.reaction[reaction])
	else
		return B.HexRGB(1, 1, 1)
	end
end
oUF.Tags.Events["color"] = "UNIT_HEALTH UNIT_HEALTH_FREQUENT UNIT_MAXHEALTH UNIT_NAME_UPDATE UNIT_FACTION UNIT_CONNECTION PLAYER_FLAGS_CHANGED UNIT_STATS PLAYER_LEVEL_CHANGED UNIT_LEVEL"

oUF.Tags.Methods["flag"] = function(unit)
	if UnitIsAFK(unit) then
		return " |cffFFCC00<"..AFK..">|r"
	elseif UnitIsDND(unit) then
		return " |cffFFCC00<"..DND..">|r"
	end
end
oUF.Tags.Events["flag"] = "PLAYER_FLAGS_CHANGED UNIT_STATS"

oUF.Tags.Methods["state"] = function(unit)
	if not UnitIsConnected(unit) and GetNumArenaOpponentSpecs() <= 0 then
		return "|cffC0C0C0"..PLAYER_OFFLINE.."|r"
	elseif UnitIsGhost(unit) then
		return "|cffC0C0C0"..L["Ghost"].."|r"
	elseif UnitIsDead(unit) then
		return "|cffC0C0C0"..DEAD.."|r"
	end
end
oUF.Tags.Events["state"] = "UNIT_HEALTH UNIT_HEALTH_FREQUENT UNIT_MAXHEALTH UNIT_NAME_UPDATE UNIT_CONNECTION PLAYER_FLAGS_CHANGED UNIT_STATS"

-- Level tags
oUF.Tags.Methods["fulllevel"] = function(unit)
	local level = UnitLevel(unit)
	local class = UnitClassification(unit)
	local color = B.HexRGB(GetCreatureDifficultyColor(level))

	if UnitIsWildBattlePet(unit) or UnitIsBattlePetCompanion(unit) then
		level = UnitBattlePetLevel(unit)
	end

	if level ~= UnitLevel("player") then
		if level > 0 then
			level = color..level.."|r"
		else
			level = "|cffFF0000"..BOSS.."|r"
		end
	else
		level = ""
	end

	local str = level
	if class == "elite" then
		str = level.." |cffFFFF00"..ELITE.."|r"
	elseif class == "rare" then
		str = level.." |cffFF00FF"..L["Rare"].."|r"
	elseif class == "rareelite" then
		str = level.." |cff00FFFF"..L["Rare"]..ELITE.."|r"
	elseif class == "worldboss" then
		str = " |cffFF0000"..BOSS.."|r"
	end

	return str
end
oUF.Tags.Events["fulllevel"] = "UNIT_LEVEL PLAYER_LEVEL_UP UNIT_CLASSIFICATION_CHANGED UNIT_NAME_UPDATE PLAYER_LEVEL_CHANGED"

-- RaidFrame tags
oUF.Tags.Methods["raidhp"] = function(unit)
	local cur = UnitHealth(unit)
	local loss = UnitHealthMax(unit) - UnitHealth(unit)
	local per = oUF.Tags.Methods["perhp"](unit)

	if UnitIsDeadOrGhost(unit) or not UnitIsConnected(unit) then
		return oUF.Tags.Methods["state"](unit)
	elseif per < 100 then
		if NDuiDB["UFs"]["RaidHPMode"] == 2 then
			return B.ColorText(per)
		elseif NDuiDB["UFs"]["RaidHPMode"] == 3 then
			return B.ColorText(per, false, B.FormatNumb(cur))
		elseif NDuiDB["UFs"]["RaidHPMode"] == 4 then
			return B.ColorText(per, false, B.FormatNumb(loss))
		end
	end
end
oUF.Tags.Events["raidhp"] = "UNIT_HEALTH_FREQUENT UNIT_MAXHEALTH UNIT_NAME_UPDATE UNIT_CONNECTION PLAYER_FLAGS_CHANGED UNIT_STATS"

-- Nameplate tags
oUF.Tags.Methods["nphp"] = function(unit)
	local cur = UnitHealth(unit)
	local per = oUF.Tags.Methods["perhp"](unit)

	if per < 100 then
		if NDuiDB["Nameplate"]["NPsHPMode"] == 1 then
			return B.ColorText(per, true)
		elseif NDuiDB["Nameplate"]["NPsHPMode"] == 2 then
			return B.ColorText(per, true, B.FormatNumb(cur))
		else
			return B.ColorText(per, true, B.FormatNumb(cur)).." | "..B.ColorText(per, true)
		end
	end
end
oUF.Tags.Events["nphp"] = "UNIT_HEALTH_FREQUENT UNIT_MAXHEALTH UNIT_CONNECTION"

oUF.Tags.Methods["nppp"] = function(unit)
	local per = oUF.Tags.Methods["perpp"](unit)

	if per > 0 then
		return B.ColorText(per, true)
	end
end
oUF.Tags.Events["nppp"] = "UNIT_POWER_FREQUENT UNIT_MAXPOWER"

oUF.Tags.Methods["nplv"] = function(unit)
	local level = UnitLevel(unit)
	local color = B.HexRGB(GetCreatureDifficultyColor(level))

	if level and level ~= UnitLevel("player") then
		if level > 0 then
			level = color..level.."|r "
		else
			level = "|cffFF0000"..BOSS.."|r "
		end
	else
		level = ""
	end

	return level
end
oUF.Tags.Events["nplv"] = "UNIT_LEVEL PLAYER_LEVEL_UP UNIT_CLASSIFICATION_CHANGED UNIT_NAME_UPDATE PLAYER_LEVEL_CHANGED"

-- AltPower value tag
oUF.Tags.Methods["altpower"] = function(unit)
	local cur = UnitPower(unit, ALTERNATE_POWER_INDEX)
	local max = UnitPowerMax(unit, ALTERNATE_POWER_INDEX)
	local per = cur / max * 100

	if cur > 0 then
		return B.ColorText(per, false, cur)
	end
end
oUF.Tags.Events["altpower"] = "UNIT_POWER_UPDATE UNIT_MAXPOWER"

-- Monk stagger
oUF.Tags.Methods["monkstagger"] = function(unit)
	if unit ~= "player" then return end

	local cur = UnitStagger(unit) or 0
	local max = UnitHealthMax(unit)
	local per = cur / max * 100

	return B.ColorText(per, true, cur).." | "..B.ColorText(per, true)
end
oUF.Tags.Events["monkstagger"] = "UNIT_MAXHEALTH UNIT_AURA"