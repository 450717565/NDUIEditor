-- LightCT by Alza
-- xCT by Dandruff
local B, C, L, DB = unpack(select(2, ...))

local template = "-%s (%s)"
local fadetime = 3
local iconsize = 14
local bigiconsize = 20
local frames = {}

local dmgcolor = {}
dmgcolor[1]  = {  1,  1,  0 }  -- physical
dmgcolor[2]  = {  1, .9, .5 }  -- holy
dmgcolor[4]  = {  1, .5,  0 }  -- fire
dmgcolor[8]  = { .3,  1, .3 }  -- nature
dmgcolor[16] = { .5,  1,  1 }  -- frost
dmgcolor[32] = { .5, .5,  1 }  -- shadow
dmgcolor[64] = {  1, .5,  1 }  -- arcane

local eventframe = CreateFrame("Frame")
eventframe:RegisterEvent("PLAYER_LOGIN")
eventframe:RegisterEvent("COMBAT_TEXT_UPDATE")
eventframe:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
eventframe:SetScript("OnEvent", function(self, event, ...)
	if not NDuiDB["UFs"]["CombatText"] then return end
	self[event](self, ...)
end)

function eventframe:PLAYER_LOGIN()
	SetCVar("enableFloatingCombatText", 0)
	SetCVar("floatingCombatTextCombatDamage", 1)
	SetCVar("floatingCombatTextCombatHealing", 0)
	InterfaceOptionsCombatPanelEnableFloatingCombatText:Hide()

	B.Mover(frames["InputDamage"], "承受伤害", "承受伤害", {"RIGHT", UIParent, "CENTER", -185, 30}, 84, 150)
	B.Mover(frames["InputHealing"], "承受治疗", "承受治疗", {"BOTTOM", UIParent, "BOTTOM", -400, 30}, 84, 150)
	B.Mover(frames["OutputDamage"], "输出伤害", "输出伤害", {"LEFT", UIParent, "CENTER", 110, 5}, 84, 150)
	B.Mover(frames["OutputHealing"], "输出治疗", "输出治疗", {"BOTTOM", UIParent, "BOTTOM", 400, 30}, 84, 150)
end

local GetSpellTextureFormatted = function(spellID, iconSize)
	local msg = ""
	if spellID == PET_ATTACK_TEXTURE then
		msg = " \124T"..PET_ATTACK_TEXTURE..":"..iconSize..":"..iconSize..":0:0:64:64:5:59:5:59\124t"
	else
		local icon = GetSpellTexture(spellID)
		if icon then
			msg = " \124T"..icon..":"..iconSize..":"..iconSize..":0:0:64:64:5:59:5:59\124t"
		else
			msg = " \124T"..ct.blank..":"..iconSize..":"..iconSize..":0:0:64:64:5:59:5:59\124t"
		end
	end
	return msg
end

local function CreateCTFrame(name, justify, a1, parent, a2, x, y)
	local frame = CreateFrame("ScrollingMessageFrame", name, UIParent)

	frame:SetSpacing(3)
	frame:SetMaxLines(20)
	frame:SetSize(84, 150)
	frame:SetFadeDuration(0.2)
	frame:SetJustifyH(justify)
	frame:SetTimeVisible(fadetime)
	frame:SetPoint(a1, parent, a2, x, y)
	frame:SetFont(STANDARD_TEXT_FONT, iconsize, "OUTLINE")

	return frame
end

frames["InputDamage"] = CreateCTFrame("InputDamage", "CENTER", "RIGHT", UIParent, "CENTER", -185, 30)
frames["InputHealing"] = CreateCTFrame("InputHealing", "CENTER", "BOTTOM", UIParent, "BOTTOM", -400, 30)
frames["OutputDamage"] = CreateCTFrame("OutputDamage", "CENTER", "LEFT", UIParent, "CENTER", 110, 5)
frames["OutputHealing"] = CreateCTFrame("OutputHealing", "CENTER", "BOTTOM", UIParent, "BOTTOM", 400, 30)

local tbl = {
	["DAMAGE"] = 			{frame = "InputDamage", prefix = "-", 		arg2 = true, 	r = 1, 		g = 0.1, 	b = 0.1},
	["DAMAGE_CRIT"] = 		{frame = "InputDamage", prefix = "*-", 		arg2 = true, 	r = 1, 		g = 0.1, 	b = 0.1},
	["SPELL_DAMAGE"] = 		{frame = "InputDamage", prefix = "-", 		arg2 = true, 	r = 0.79, 	g = 0.3, 	b = 0.85},
	["SPELL_DAMAGE_CRIT"] = {frame = "InputDamage", prefix = "*-", 	arg2 = true, 	r = 0.79, 	g = 0.3, 	b = 0.85},
	["HEAL"] = 				{frame = "InputHealing", prefix = "+",		arg3 = true, 	r = 0.1, 	g = 1, 		b = 0.1},
	["HEAL_CRIT"] = 		{frame = "InputHealing", prefix = "*+", 	arg3 = true, 	r = 0.1, 	g = 1, 		b = 0.1},
	["PERIODIC_HEAL"] = 	{frame = "InputHealing", prefix = "+", 		arg3 = true, 	r = 0.1, 	g = 1, 		b = 0.1},
	["MISS"] = 				{frame = "InputDamage", prefix = "丢失", 					r = 1, 		g = 0.1, 	b = 0.1},
	["SPELL_MISS"] = 		{frame = "InputDamage", prefix = "丢失", 					r = 0.79, 	g = 0.3, 	b = 0.85},
	["SPELL_REFLECT"] = 	{frame = "InputDamage", prefix = "反射", 					r = 1, 		g = 1, 		b = 1},
	["DODGE"] = 			{frame = "InputDamage", prefix = "躲闪", 					r = 1, 		g = 0.1, 	b = 0.1},
	["PARRY"] = 			{frame = "InputDamage", prefix = "招架", 					r = 1, 		g = 0.1, 	b = 0.1},
	["BLOCK"] = 			{frame = "InputDamage", prefix = "格挡", 	spec = true,	r = 1, 		g = 0.1, 	b = 0.1},
	["RESIST"] = 			{frame = "InputDamage", prefix = "抵抗", 	spec = true, 	r = 1, 		g = 0.1, 	b = 0.1},
	["SPELL_RESIST"] = 		{frame = "InputDamage", prefix = "抵抗", 	spec = true, 	r = 0.79, 	g = 0.3, 	b = 0.85},
	["ABSORB"] = 			{frame = "InputDamage", prefix = "吸收", 	spec = true, 	r = 1, 		g = 0.1, 	b = 0.1},
	["SPELL_ABSORBED"] = 	{frame = "InputDamage", prefix = "吸收", 	spec = true, 	r = 0.79, 	g = 0.3, 	b = 0.85},
}

function eventframe:COMBAT_TEXT_UPDATE(spelltype, arg2, arg3)
	local info = tbl[spelltype]
	if info then
		local msg = info.prefix
		if info.spec  then
			if arg3 then
				msg = template:format(arg2, arg3)
			end
		else
			if info.arg2 then msg = msg..B.Numb(arg2) end
			if info.arg3 then msg = msg..B.Numb(arg3) end
		end
		frames[info.frame]:AddMessage(msg, info.r, info.g, info.b)
	end
end

function eventframe:COMBAT_LOG_EVENT_UNFILTERED(...)
	local icon, spellId, amount, critical, spellSchool
	local timestamp, eventType, hideCaster, sourceGUID, sourceName, sourceFlags, sourceFlags2, destGUID, destName, destFlags, destFlags2 = select(1, ...)
	if sourceGUID == UnitGUID("player") or (NDuiDB["UFs"]["PetCombatText"] and sourceGUID == UnitGUID("pet")) or sourceFlags == gflags then
		if eventType == "SPELL_HEAL" or (NDuiDB["UFs"]["HotsDots"] and eventType == "SPELL_PERIODIC_HEAL") then
			spellId = select(12, ...)
			amount = select(15, ...)
			critical = select(18, ...)
			icon = GetSpellTextureFormatted(spellId, critical and bigiconsize or iconsize)
			frames["OutputHealing"]:AddMessage(B.Numb(amount)..icon, 0, 1, 0)
		elseif destGUID ~= UnitGUID("player") then
			if eventType == "SWING_DAMAGE" then
				amount = select(12, ...)
				critical = select(18, ...)
				icon = GetSpellTextureFormatted(6603, critical and bigiconsize or iconsize)
			elseif eventType == "RANGE_DAMAGE" then
				spellId = select(12, ...)
				amount = select(15, ...)
				critical = select(21, ...)
				icon = GetSpellTextureFormatted(spellId, critical and bigiconsize or iconsize)
			elseif eventType == "SPELL_DAMAGE" or (NDuiDB["UFs"]["HotsDots"] and eventType == "SPELL_PERIODIC_DAMAGE") then
				spellId = select(12, ...)
				spellSchool = select(14, ...)
				amount = select(15, ...)
				critical = select(21, ...)
				icon = GetSpellTextureFormatted(spellId, critical and bigiconsize or iconsize)
			elseif eventType == "SWING_MISSED" then
				amount = select(12, ...) -- misstype
				icon = GetSpellTextureFormatted(6603, iconsize)
			elseif eventType == "SPELL_MISSED" or eventType == "RANGE_MISSED" then
				spellId = select(12, ...)
				amount = select(15, ...) -- misstype
				icon = GetSpellTextureFormatted(spellId, iconsize)
			end

			if amount and icon then
				if critical then
					if dmgcolor[spellSchool] then
						frames["OutputDamage"]:AddMessage("*"..B.Numb(amount)..icon, dmgcolor[spellSchool][1], dmgcolor[spellSchool][2], dmgcolor[spellSchool][3])
					else
						frames["OutputDamage"]:AddMessage("*"..B.Numb(amount)..icon, dmgcolor[1][1], dmgcolor[1][2], dmgcolor[1][3])
					end
				else
					if dmgcolor[spellSchool] then
						frames["OutputDamage"]:AddMessage(B.Numb(amount)..icon, dmgcolor[spellSchool][1], dmgcolor[spellSchool][2], dmgcolor[spellSchool][3])
					else
						frames["OutputDamage"]:AddMessage(B.Numb(amount)..icon, dmgcolor[1][1], dmgcolor[1][2], dmgcolor[1][3])
					end
				end
			end
		end
	end
end