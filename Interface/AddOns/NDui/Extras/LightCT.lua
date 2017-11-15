-- LightCT by Alza
-- NDUI MOD
local B, C, L, DB = unpack(select(2, ...))

local fadeTime = 3
local fontSize = 14

local frameWidth = 90
local frameHeight = 150

local idPoints = {"RIGHT", UIParent, "CENTER", -175, 30}
local ihPoints = {"BOTTOM", UIParent, "BOTTOM", -400, 30}
local odPoints = {"LEFT", UIParent, "CENTER", 105, 5}
local ohPoints = {"BOTTOM", UIParent, "BOTTOM", 400, 30}

local frames = {}

local eventFilter = {
	["SWING_DAMAGE"] = {suffix = "DAMAGE", index = 12, iconType = "swing", autoAttack = true},
	["RANGE_DAMAGE"] = {suffix = "DAMAGE", index = 15, iconType = "range"},
	["SPELL_DAMAGE"] = {suffix = "DAMAGE", index = 15, iconType = "spell"},
	["SPELL_PERIODIC_DAMAGE"] = {suffix = "DAMAGE", index = 15, iconType = "spell", isPeriod = true},

	["SPELL_HEAL"] = {suffix = "HEAL", index = 15, iconType = "spell"},
	["SPELL_PERIODIC_HEAL"] = {suffix = "HEAL", index = 15, iconType = "spell", isPeriod = true},

	["SWING_MISSED"] = {suffix = "MISS", index = 12, iconType = "swing"},
	["RANGE_MISSED"] = {suffix = "MISS", index = 15, iconType = "range"},
	["SPELL_MISSED"] = {suffix = "MISS", index = 15, iconType = "spell"},

	["ENVIRONMENTAL_DAMAGE"] = {suffix = "ENVIRONMENT", index = 12, iconType = "env"},
}

local envTexture = {
	["Drowning"] = "spell_shadow_demonbreath",
	["Falling"] = "ability_rogue_quickrecovery",
	["Fatigue"] = "ability_creature_cursed_05",
	["Fire"] = "spell_fire_fire",
	["Lava"] = "ability_rhyolith_lavapool",
	["Slime"] = "inv_misc_slime_02",
}

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("PLAYER_LOGIN")
eventFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
eventFrame:SetScript("OnEvent", function(self, event, ...)
	if not NDuiDB["UFs"]["CombatText"] then return end
	self[event](self, ...)
end)

local function GetFloatingIcon(iconType, spellID, isPet)
	local texture, icon

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
	elseif iconType == "env" then
		texture = "Interface\\Icons\\"..envTexture[spellID]
	end

	if not texture then
		texture = GetSpellTexture(195112)
	end

	icon = "|T"..texture..":"..fontSize..":"..fontSize..":0:-5:64:64:5:59:5:59|t"
	return icon
end

local function CreateCTFrame(name, justify, width, height)
	local frame = CreateFrame("ScrollingMessageFrame", name, UIParent)

	frame:SetSpacing(3)
	frame:SetMaxLines(20)
	frame:SetSize(width, height)
	frame:SetFadeDuration(0.2)
	frame:SetJustifyH(justify)
	frame:SetTimeVisible(fadeTime)
	frame:SetFont(STANDARD_TEXT_FONT, fontSize, "OUTLINE")

	return frame
end

frames["InputDamage"] = CreateCTFrame("InputDamage", "LEFT", frameWidth, frameHeight)
frames["InputHealing"] = CreateCTFrame("InputHealing", "LEFT", frameWidth, frameHeight)
frames["OutputDamage"] = CreateCTFrame("OutputDamage", "RIGHT", frameWidth, frameHeight)
frames["OutputHealing"] = CreateCTFrame("OutputHealing", "RIGHT", frameWidth, frameHeight)

function eventFrame:PLAYER_LOGIN()
	SetCVar("enableFloatingCombatText", 0)
	SetCVar("floatingCombatTextCombatDamage", 1)
	SetCVar("floatingCombatTextCombatHealing", 0)

	B.Mover(frames["InputDamage"], L["InputDamage"], "InputDamage", idPoints, frameWidth, frameHeight)
	B.Mover(frames["InputHealing"], L["InputHealing"], "InputHealing", ihPoints, frameWidth, frameHeight)
	B.Mover(frames["OutputDamage"], L["OutputDamage"], "OutputDamage", odPoints, frameWidth, frameHeight)
	B.Mover(frames["OutputHealing"], L["OutputHealing"], "OutputHealing", ohPoints, frameWidth, frameHeight)
end

function eventFrame:COMBAT_LOG_EVENT_UNFILTERED(...)
	local icon, text, color, inputD, inputH, outputD, outputH
	local _, eventType, _, sourceGUID, sourceName, sourceFlags, _, destGUID, destName, destFlags, _, spellID, spellName, school = ...

	local showAA = NDuiDB["UFs"]["AutoAttack"]
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
				if value.autoAttack and not showAA then return end
				if value.isPeriod and not showHD then return end
				if isPlayer or isVehicle or isPet then
					text = B.Numb(amount)
					outputD = true
				else
					text = "-"..B.Numb(amount)
					inputD = true
				end
				if text and (critical or crushing) then
					text = "*"..text
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
				if text and critical then
					text = "*"..text
				end
			elseif value.suffix == "MISS" then
				local missType, isOffHand, amountMissed = select(value.index, ...)
				text = _G["COMBAT_TEXT_"..missType]
				if isPlayer or isVehicle or isPet then
					outputD = true
				else
					inputD = true
				end
			elseif value.suffix == "ENVIRONMENT" then
				local envType, amount, overkill, school = select(value.index, ...)
				text = "-"..B.Numb(amount)
				if isPlayer or isVehicle or isPet then
					outputD = true
				else
					inputD = true
				end
			end

			color = _G.CombatLog_Color_ColorArrayBySchool(school) or {r = 1, g = 1, b = 1}
			icon = GetFloatingIcon(value.iconType, spellID, isPet)
		end

		if text and icon then
			if outputD then
				frames["OutputDamage"]:AddMessage(text..icon, color.r, color.g, color.b)
			elseif outputH then
				frames["OutputHealing"]:AddMessage(text..icon, color.r, color.g, color.b)
			elseif inputD then
				frames["InputDamage"]:AddMessage(icon..text, color.r, color.g, color.b)
			elseif inputH then
				frames["InputHealing"]:AddMessage(icon..text, color.r, color.g, color.b)
			end
		end
	end
end