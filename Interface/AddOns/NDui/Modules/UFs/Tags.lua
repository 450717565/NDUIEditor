local _, ns = ...
local B, C, L, DB = unpack(ns)

local oUF = ns.oUF or oUF
local format, floor = string.format, math.floor
local AFK, DND, DEAD, PLAYER_OFFLINE = AFK, DND, DEAD, PLAYER_OFFLINE
local ALTERNATE_POWER_INDEX = ALTERNATE_POWER_INDEX or 10
local strmatch = string.match

oUF.Tags.Methods["health"] = function(unit)
	if UnitIsDeadOrGhost(unit) or not UnitIsConnected(unit) then
		return oUF.Tags.Methods["state"](unit)
	else
		local cur = UnitHealth(unit)
		local per = oUF.Tags.Methods["perhp"](unit)

		if (unit == "player" and not UnitHasVehicleUI(unit)) or unit == "target" or unit == "focus" then
			if per < 100 then
				return B.ColorText(per, false, B.Numb(cur)).." | "..B.ColorText(per)
			else
				return B.Numb(cur)
			end
		elseif strmatch(unit, "arena") or strmatch(unit, "boss") then
			return B.ColorText(per, true)
		elseif UnitInParty(unit) and strmatch(unit, "party") and not NDuiDB["UFs"]["PartyWatcher"] then
			return B.Numb(cur)
		else
			return B.ColorText(per)
		end
	end
end
oUF.Tags.Events["health"] = "UNIT_HEALTH_FREQUENT UNIT_MAXHEALTH UNIT_CONNECTION"

oUF.Tags.Methods["power"] = function(unit)
	local cur = UnitPower(unit)
	local per = oUF.Tags.Methods["perpp"](unit)

	if (unit == "player" and not UnitHasVehicleUI(unit)) or unit == "target" or unit == "focus" then
		if UnitPowerType(unit) == 0 then
			return B.ColorText(per, false, B.Numb(cur))
		else
			return B.Numb(cur)
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
oUF.Tags.Events["color"] = "UNIT_HEALTH UNIT_CONNECTION"

oUF.Tags.Methods["flag"] = function(unit)
	if UnitIsAFK(unit) then
		return " |cffFFCC00<"..AFK..">|r"
	elseif UnitIsDND(unit) then
		return " |cffFFCC00<"..DND..">|r"
	end
end
oUF.Tags.Events["flag"] = "PLAYER_FLAGS_CHANGED"

oUF.Tags.Methods["state"] = function(unit)
	if not UnitIsConnected(unit) and GetNumArenaOpponentSpecs() <= 0 then
		return "|cffC0C0C0"..PLAYER_OFFLINE.."|r"
	elseif UnitIsGhost(unit) then
		return "|cffC0C0C0"..L["Ghost"].."|r"
	elseif UnitIsDead(unit) then
		return "|cffC0C0C0"..DEAD.."|r"
	end
end
oUF.Tags.Events["state"] = "UNIT_HEALTH UNIT_CONNECTION"

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
oUF.Tags.Events["fulllevel"] = "UNIT_LEVEL PLAYER_LEVEL_UP UNIT_CLASSIFICATION_CHANGED"

-- RaidFrame tags
oUF.Tags.Methods["raidhp"] = function(unit)
	local per = oUF.Tags.Methods["perhp"](unit)

	if UnitIsDeadOrGhost(unit) or not UnitIsConnected(unit) then
		return oUF.Tags.Methods["state"](unit)
	else
		return B.ColorText(per)
	end
end
oUF.Tags.Events["raidhp"] = "UNIT_HEALTH_FREQUENT UNIT_MAXHEALTH UNIT_CONNECTION"

-- Nameplate tags
oUF.Tags.Methods["nphp"] = function(unit)
	local cur = UnitHealth(unit)
	local per = oUF.Tags.Methods["perhp"](unit)

	if per < 100 then
		if NDuiDB["Nameplate"]["FullHealth"] then
			return B.ColorText(per, true, B.Numb(cur))
		else
			return B.ColorText(per, true)
		end
	end
end
oUF.Tags.Events["nphp"] = "UNIT_HEALTH_FREQUENT UNIT_MAXHEALTH UNIT_CONNECTION"

oUF.Tags.Methods["nppp"] = function(unit)
	if not C.ShowPowerList[UnitName(unit)] then return end
	local per = oUF.Tags.Methods["perpp"](unit)

	if per > 0 then
		return B.ColorText(per, true)
	end
end
oUF.Tags.Events["nppp"] = "UNIT_POWER_FREQUENT UNIT_MAXPOWER"

oUF.Tags.Methods["nplevel"] = function(unit)
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
oUF.Tags.Events["nplevel"] = "UNIT_LEVEL PLAYER_LEVEL_UP UNIT_CLASSIFICATION_CHANGED"

-- AltPower value tag
oUF.Tags.Methods["altpower"] = function(unit)
	local cur = UnitPower(unit, ALTERNATE_POWER_INDEX)
	local max = UnitPowerMax(unit, ALTERNATE_POWER_INDEX)
	local per = format("%.1f%%", cur / max * 100)

	if max > 0 and not UnitIsDeadOrGhost(unit) then
		return per
	end
end
oUF.Tags.Events["altpower"] = "UNIT_POWER_UPDATE"