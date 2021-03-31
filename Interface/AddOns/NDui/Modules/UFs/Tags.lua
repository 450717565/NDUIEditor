local _, ns = ...
local B, C, L, DB = unpack(ns)
local oUF = ns.oUF

local AFK, DND, DEAD, PLAYER_OFFLINE, LEVEL = AFK, DND, DEAD, PLAYER_OFFLINE, LEVEL
local select, format, strfind, GetCVarBool = select, format, strfind, GetCVarBool
local ALTERNATE_POWER_INDEX = Enum.PowerType.Alternate or 10
local UnitIsDeadOrGhost, UnitIsConnected, UnitHasVehicleUI, UnitIsTapDenied, UnitIsPlayer = UnitIsDeadOrGhost, UnitIsConnected, UnitHasVehicleUI, UnitIsTapDenied, UnitIsPlayer
local UnitHealth, UnitHealthMax, UnitPower, UnitPowerType, UnitStagger = UnitHealth, UnitHealthMax, UnitPower, UnitPowerType, UnitStagger
local UnitClass, UnitReaction, UnitLevel, UnitClassification, UnitEffectiveLevel = UnitClass, UnitReaction, UnitLevel, UnitClassification, UnitEffectiveLevel
local UnitIsAFK, UnitIsDND, UnitIsDead, UnitIsGhost, UnitName, UnitExists = UnitIsAFK, UnitIsDND, UnitIsDead, UnitIsGhost, UnitName, UnitExists
local UnitIsWildBattlePet, UnitIsBattlePetCompanion, UnitBattlePetLevel = UnitIsWildBattlePet, UnitIsBattlePetCompanion, UnitBattlePetLevel
local GetNumArenaOpponentSpecs, GetCreatureDifficultyColor = GetNumArenaOpponentSpecs, GetCreatureDifficultyColor

local function ValueAndPercent(cur, per)
	if per < 100 then
		return B.ColorText(per, B.FormatNumb(cur))..DB.Separator..B.ColorText(per)
	else
		return B.FormatNumb(cur)
	end
end

-- UFs Tags
oUF.Tags.Methods["health"] = function(unit)
	local cur = oUF.Tags.Methods["curhp"](unit)
	local per = oUF.Tags.Methods["perhp"](unit)

	if UnitIsDeadOrGhost(unit) or not UnitIsConnected(unit) then
		return oUF.Tags.Methods["state"](unit)
	else
		if unit == "player" or unit == "target" or unit == "focus" then
			return ValueAndPercent(cur, per)
		else
			return B.ColorText(per)
		end
	end
end
oUF.Tags.Events["health"] = "UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION UNIT_NAME_UPDATE PLAYER_FLAGS_CHANGED"

oUF.Tags.Methods["power"] = function(unit)
	local cur = oUF.Tags.Methods["curpp"](unit)
	local per = oUF.Tags.Methods["perpp"](unit)

	if unit == "player" or unit == "target" or unit == "focus" then
		return B.ColorText(per, B.FormatNumb(cur))
	else
		return B.ColorText(per)
	end
end
oUF.Tags.Events["power"] = "UNIT_MAXPOWER UNIT_DISPLAYPOWER UNIT_POWER_FREQUENT"

oUF.Tags.Methods["color"] = function(unit)
	local class = select(2, UnitClass(unit))
	local reaction = UnitReaction(unit, "player")

	if UnitIsTapDenied(unit) then
		return B.HexRGB(oUF.colors.tapped)
	elseif UnitIsPlayer(unit) then
		return B.HexRGB(oUF.colors.class[class])
	elseif reaction then
		return B.HexRGB(oUF.colors.reaction[reaction])
	else
		return B.HexRGB(1, 1, 1)
	end
end
oUF.Tags.Events["color"] = "UNIT_HEALTH UNIT_MAXHEALTH UNIT_FACTION UNIT_CONNECTION UNIT_LEVEL UNIT_NAME_UPDATE UNIT_CLASSIFICATION_CHANGED PLAYER_LEVEL_CHANGED"

oUF.Tags.Methods["flag"] = function(unit)
	if UnitIsAFK(unit) then
		return "|cffCFCFCF <"..AFK..">|r"
	elseif UnitIsDND(unit) then
		return "|cffCFCFCF <"..DND..">|r"
	end
end
oUF.Tags.Events["flag"] = "PLAYER_FLAGS_CHANGED"

oUF.Tags.Methods["state"] = function(unit)
	if not UnitIsConnected(unit) and GetNumArenaOpponentSpecs() <= 0 then
		return "|cffCFCFCF"..PLAYER_OFFLINE.."|r"
	elseif UnitIsGhost(unit) then
		return "|cffCFCFCF"..L["Ghost"].."|r"
	elseif UnitIsDead(unit) then
		return "|cffCFCFCF"..DEAD.."|r"
	end
end
oUF.Tags.Events["state"] = "UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION UNIT_NAME_UPDATE"

oUF.Tags.Methods["fulllevel"] = function(unit)
	if not UnitIsConnected(unit) then
		return "??"
	end

	local realLevel = UnitLevel(unit)
	local level = UnitEffectiveLevel(unit)
	if UnitIsWildBattlePet(unit) or UnitIsBattlePetCompanion(unit) then
		level = UnitBattlePetLevel(unit)
		realLevel = level
	end

	local color = B.HexRGB(GetCreatureDifficultyColor(level))
	local str
	if level > 0 then
		local realTag = level ~= realLevel and "*" or ""
		str = color..level..realTag.."|r"
	else
		str = "|cffFF0000B|r"
	end

	local class = UnitClassification(unit)
	if class == "worldboss" then
		str = " |cffFF0000B|r"
	elseif class == "rare" then
		str = str.." |cffFF00FFR|r"
	elseif class == "elite" then
		str = str.." |cffFFFF00E|r"
	elseif class == "rareelite" then
		str = str.." |cff00FFFFRE|r"
	end

	return str
end
oUF.Tags.Events["fulllevel"] = "UNIT_HEALTH UNIT_MAXHEALTH UNIT_FACTION UNIT_CONNECTION UNIT_LEVEL UNIT_NAME_UPDATE UNIT_CLASSIFICATION_CHANGED PLAYER_LEVEL_CHANGED"

-- RaidFrame Tags
oUF.Tags.Methods["raidhp"] = function(unit)
	local cur = oUF.Tags.Methods["curhp"](unit)
	local loss = oUF.Tags.Methods["missinghp"](unit)
	local per = oUF.Tags.Methods["perhp"](unit)
	local raidHPMode = C.db["UFs"]["RaidHPMode"]

	if UnitIsDeadOrGhost(unit) or not UnitIsConnected(unit) then
		return oUF.Tags.Methods["state"](unit)
	elseif per < 100 and raidHPMode > 1 then
		if raidHPMode == 2 then
			return B.ColorText(per)
		elseif raidHPMode == 3 then
			return B.ColorText(per, B.FormatNumb(cur))
		elseif raidHPMode == 4 then
			return B.ColorText(per, B.FormatNumb(loss))
		end
	end
end
oUF.Tags.Events["raidhp"] = "UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION UNIT_NAME_UPDATE PLAYER_FLAGS_CHANGED"

-- Nameplate Tags
oUF.Tags.Methods["nphp"] = function(unit)
	local cur = oUF.Tags.Methods["curhp"](unit)
	local per = oUF.Tags.Methods["perhp"](unit)

	if per < 100 then
		if C.db["Nameplate"]["NPsHPMode"] == 1 then
			return B.ColorText(per)
		elseif C.db["Nameplate"]["NPsHPMode"] == 2 then
			return B.ColorText(per, B.FormatNumb(cur))
		else
			return ValueAndPercent(cur, per)
		end
	else
		return B.FormatNumb(cur)
	end
end
oUF.Tags.Events["nphp"] = "UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION UNIT_NAME_UPDATE"

oUF.Tags.Methods["nppp"] = function(unit)
	local per = oUF.Tags.Methods["perpp"](unit)

	if per > 0 then
		return B.ColorText(per)
	end
end
oUF.Tags.Events["nppp"] = "UNIT_MAXPOWER UNIT_DISPLAYPOWER UNIT_POWER_FREQUENT"

oUF.Tags.Methods["nplevel"] = function(unit)
	local level = UnitLevel(unit)
	local color = B.HexRGB(GetCreatureDifficultyColor(level))

	if level and level ~= UnitLevel("player") then
		if level > 0 then
			level = color..level.."|r "
		else
			level = "|cffFF0000B|r "
		end
	else
		level = ""
	end

	return level
end
oUF.Tags.Events["nplevel"] = "UNIT_HEALTH UNIT_MAXHEALTH UNIT_FACTION UNIT_CONNECTION UNIT_LEVEL UNIT_NAME_UPDATE UNIT_CLASSIFICATION_CHANGED PLAYER_LEVEL_CHANGED"

oUF.Tags.Methods["npctitle"] = function(unit)
	if UnitIsPlayer(unit) then return end

	B.ScanTip:SetOwner(UIParent, "ANCHOR_NONE")
	B.ScanTip:SetUnit(unit)

	local title = _G[format("NDui_ScanTooltipTextLeft%d", GetCVarBool("colorblindmode") and 3 or 2)]:GetText()
	if title and not strfind(title, "^"..LEVEL) then
		return title
	end
end
oUF.Tags.Events["npctitle"] = "UNIT_NAME_UPDATE"

oUF.Tags.Methods["tarname"] = function(unit)
	local tarUnit = unit.."target"
	if UnitExists(tarUnit) then
		local tarClass = select(2, UnitClass(tarUnit))
		return B.HexRGB(oUF.colors.class[tarClass])..UnitName(tarUnit)
	end
end
oUF.Tags.Events["tarname"] = "UNIT_HEALTH UNIT_MAXHEALTH UNIT_NAME_UPDATE UNIT_THREAT_LIST_UPDATE UNIT_THREAT_SITUATION_UPDATE"

-- AltPower Tags
oUF.Tags.Methods["altpower"] = function(unit)
	local cur = UnitPower(unit, ALTERNATE_POWER_INDEX)
	local max = UnitPowerMax(unit, ALTERNATE_POWER_INDEX)
	local per = cur / max * 100

	if cur > 0 then
		return B.ColorText(per, cur)
	end
end
oUF.Tags.Events["altpower"] = "UNIT_MAXPOWER UNIT_DISPLAYPOWER UNIT_POWER_FREQUENT"

-- Monk Stagger
oUF.Tags.Methods["stagger"] = function(unit)
	if unit ~= "player" then return end

	local cur = UnitStagger(unit) or 0
	local max = UnitHealthMax(unit)
	local per = cur / max * 100
	local stagger = ""

	if per < 50 then
		stagger = format("|cff00FF00%s|r | |cff00FF00%.1f%%|r", B.FormatNumb(cur), per)
	elseif per < 100 then
		stagger = format("|cffFFFF00%s|r | |cffFFFF00%.1f%%|r", B.FormatNumb(cur), per)
	else
		stagger = format("|cffFF0000%s|r | |cffFF0000%.1f%%|r", B.FormatNumb(cur), per)
	end

	return stagger
end
oUF.Tags.Events["stagger"] = "UNIT_MAXHEALTH UNIT_AURA"