-- LightCT by Alza
-- xCT by Dandruff
local B, C, L, DB = unpack(select(2, ...))

local fadetime = 3
local fontsize = 14

local frames = {}

local schoolColors = {
	[SCHOOL_MASK_NONE]		= {r = 1.00, g = 1.00, b = 1.00},	-- 0x00 or 0
	[SCHOOL_MASK_PHYSICAL]	= {r = 1.00, g = 1.00, b = 0.00},	-- 0x01 or 1
	[SCHOOL_MASK_HOLY]		= {r = 1.00, g = 0.90, b = 0.50},	-- 0x02 or 2
	[SCHOOL_MASK_FIRE]		= {r = 1.00, g = 0.50, b = 0.00},	-- 0x04 or 4
	[SCHOOL_MASK_NATURE]	= {r = 0.30, g = 1.00, b = 0.30},	-- 0x08 or 8
	[SCHOOL_MASK_FROST]		= {r = 0.50, g = 1.00, b = 1.00},	-- 0x10 or 16
	[SCHOOL_MASK_SHADOW]	= {r = 0.50, g = 0.50, b = 1.00},	-- 0x20 or 32
	[SCHOOL_MASK_ARCANE]	= {r = 1.00, g = 0.50, b = 1.00},	-- 0x40 or 64
}

local eventFilter = {
	["SWING_DAMAGE"] = {suffix = "DAMAGE", index = 12, iconType = "swing"},
	["RANGE_DAMAGE"] = {suffix = "DAMAGE", index = 15, iconType = "range"},
	["SPELL_DAMAGE"] = {suffix = "DAMAGE", index = 15, iconType = "spell"},
	["SPELL_PERIODIC_DAMAGE"] = {suffix = "DAMAGE", index = 15, iconType = "spell", isPeriod = true},

	["SPELL_HEAL"] = {suffix = "HEAL", index = 15, iconType = "spell"},
	["SPELL_PERIODIC_HEAL"] = {suffix = "HEAL", index = 15, iconType = "spell", isPeriod = true},

	["SWING_MISSED"] = {suffix = "MISS", index = 12, iconType = "swing"},
	["RANGE_MISSED"] = {suffix = "MISS", index = 15, iconType = "range"},
	["SPELL_MISSED"] = {suffix = "MISS", index = 15, iconType = "spell"},
}

local eventframe = CreateFrame("Frame")
eventframe:RegisterEvent("PLAYER_LOGIN")
eventframe:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
eventframe:SetScript("OnEvent", function(self, event, ...)
	if not NDuiDB["UFs"]["CombatText"] then return end
	self[event](self, ...)
end)

function eventframe:PLAYER_LOGIN()
	SetCVar("enableFloatingCombatText", 0)
	SetCVar("floatingCombatTextCombatDamage", 1)
	SetCVar("floatingCombatTextCombatHealing", 0)

	B.Mover(frames["InputDamage"], L["InputDamage"], "InputDamage", {"RIGHT", UIParent, "CENTER", -185, 30}, 84, 150)
	B.Mover(frames["InputHealing"], L["InputHealing"], "InputHealing", {"BOTTOM", UIParent, "BOTTOM", -400, 30}, 84, 150)
	B.Mover(frames["OutputDamage"], L["OutputDamage"], "OutputDamage", {"LEFT", UIParent, "CENTER", 110, 5}, 84, 150)
	B.Mover(frames["OutputHealing"], L["OutputHealing"], "OutputHealing", {"BOTTOM", UIParent, "BOTTOM", 400, 30}, 84, 150)
end

local function GetFloatingIconTexture(iconType, spellID, isPet)
	local texture
	if iconType == "spell" then
		texture = GetSpellTexture(spellID)
	elseif iconType == "swing" then
		if isPet then
			texture = PET_ATTACK_TEXTURE
		else
			texture = GetSpellTexture(6603)
		end
	elseif iconType == "range" then
		texture = GetSpellTexture(75)
	end
	return texture
end

local function CreateCTFrame(name, justify)
	local frame = CreateFrame("ScrollingMessageFrame", name, UIParent)

	frame:SetSpacing(3)
	frame:SetMaxLines(20)
	frame:SetSize(84, 150)
	frame:SetFadeDuration(0.2)
	frame:SetJustifyH(justify)
	frame:SetTimeVisible(fadetime)
	frame:SetFont(STANDARD_TEXT_FONT, fontsize, "OUTLINE")

	return frame
end

frames["InputDamage"] = CreateCTFrame("InputDamage", "CENTER")
frames["InputHealing"] = CreateCTFrame("InputHealing", "CENTER")
frames["OutputDamage"] = CreateCTFrame("OutputDamage", "CENTER")
frames["OutputHealing"] = CreateCTFrame("OutputHealing", "CENTER")

function eventframe:COMBAT_LOG_EVENT_UNFILTERED(...)
	local icon, text, info, critMark , inputD, inputH, outputD, outputH
	local _, eventType, _, sourceGUID, sourceName, sourceFlags, _, destGUID, destName, destFlags, _, spellID, spellName, school = ...

	local showHD = NDuiDB["UFs"]["HotsDots"]

	local isPlayer = UnitGUID("player") == sourceGUID
	local isVehicle = UnitGUID("vehicle") == sourceGUID
	local isPet = UnitGUID("pet") == sourceGUID and NDuiDB["UFs"]["PetCombatText"]

	local atPlayer = UnitGUID("player") == destGUID
	local atTarget = UnitGUID("target") == destGUID

	if ((isPlayer or isVehicle or isPet) and atTarget) or atPlayer then
		local value = eventFilter[eventType]
		if value then
			if value.suffix == "DAMAGE" then
				local amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing, isOffHand = select(value.index, ...)
				if value.isPeriod and not showHD then return end
				if isPlayer or isVehicle or isPet then
					text = B.Numb(amount)
					outputD = true
				else
					text = "-"..B.Numb(amount)
					inputD = true
				end
				if critical or crushing then
					critMark = true
				end
			elseif value.suffix == "HEAL" then
				local amount, overhealing, absorbed, critical = select(value.index, ...)
				if value.isPeriod and not showHD then return end
				if isPlayer or isVehicle or isPet then
					text = B.Numb(amount)
					outputH = true
				else
					text = "+"..B.Numb(amount)
					inputH = true
				end
				if critical then
					critMark = true
				end
			elseif value.suffix == "MISS" then
				local missType, isOffHand, amountMissed = select(value.index, ...)
				text = _G["COMBAT_TEXT_"..missType]
				if isPlayer or isVehicle or isPet then
					outputD = true
				else
					inputD = true
				end
			end

			color = schoolColors[school] or schoolColors[0]
			icon = GetFloatingIconTexture(value.iconType, spellID, isPet)
			info = string.format("%s|T%s:"..fontsize..":"..fontsize..":0:-5:64:64:5:59:5:59|t", (critMark and "*" or "")..text, icon)
		end

		if info then
			if outputD then
				frames["OutputDamage"]:AddMessage(info, color.r, color.g, color.b)
			elseif outputH then
				frames["OutputHealing"]:AddMessage(info, color.r, color.g, color.b)
			elseif inputD then
				frames["InputDamage"]:AddMessage(info, color.r, color.g, color.b)
			elseif inputH then
				frames["InputHealing"]:AddMessage(info, color.r, color.g, color.b)
			end
		end
	end
end