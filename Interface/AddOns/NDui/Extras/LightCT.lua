-- LightCT by Alza
-- NDUI MOD
local B, C, L, DB = unpack(select(2, ...))

local fadetime = 3
local fontsize = 14

local frames = {}

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
	frame:SetSize(90, 150)
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

function eventframe:PLAYER_LOGIN()
	SetCVar("enableFloatingCombatText", 0)
	SetCVar("floatingCombatTextCombatDamage", 1)
	SetCVar("floatingCombatTextCombatHealing", 0)

	B.Mover(frames["InputDamage"], L["InputDamage"], "InputDamage", {"RIGHT", UIParent, "CENTER", -185, 30}, 84, 150)
	B.Mover(frames["InputHealing"], L["InputHealing"], "InputHealing", {"BOTTOM", UIParent, "BOTTOM", -400, 30}, 84, 150)
	B.Mover(frames["OutputDamage"], L["OutputDamage"], "OutputDamage", {"LEFT", UIParent, "CENTER", 110, 5}, 84, 150)
	B.Mover(frames["OutputHealing"], L["OutputHealing"], "OutputHealing", {"BOTTOM", UIParent, "BOTTOM", 400, 30}, 84, 150)
end

function eventframe:COMBAT_LOG_EVENT_UNFILTERED(...)
	local icon, text, info, color, critMark, inputD, inputH, outputD, outputH
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

			color = _G.CombatLog_Color_ColorArrayBySchool(school) or {r = 1, g = 1, b = 1}
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