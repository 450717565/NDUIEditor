local _, ns = ...
local B, C, L, DB = unpack(ns)
local AURA = B:GetModule("Auras")

if DB.MyClass ~= "PRIEST" then return end

local function UpdateCooldown(button, spellID, texture)
	return AURA:UpdateCooldown(button, spellID, texture)
end

local function UpdateBuff(button, spellID, auraID, cooldown, glow)
	return AURA:UpdateAura(button, "player", auraID, "HELPFUL", spellID, cooldown, glow)
end

local function UpdateDebuff(button, spellID, auraID)
	return AURA:UpdateAura(button, "target", auraID, "HARMFUL", spellID, false, "END")
end

function AURA:ChantLumos(self)
	local spec = GetSpecialization()
	if spec == 1 then
		UpdateCooldown(self.lumos[1], 47540, true)
		UpdateCooldown(self.lumos[2], 194509, true)
		UpdateBuff(self.lumos[3], 47536, 47536, true, true)
		UpdateBuff(self.lumos[4], 33206, 33206, true, true)
		UpdateCooldown(self.lumos[5], 62618, true)
	elseif spec == 2 then
		UpdateCooldown(self.lumos[1], 34861, true)
		UpdateCooldown(self.lumos[2], 2050, true)
		UpdateBuff(self.lumos[3], 64843, 64843, true, true)
		UpdateBuff(self.lumos[4], 64901, 64901, true, true)
		UpdateCooldown(self.lumos[5], 47788, true)
	elseif spec == 3 then
		UpdateDebuff(self.lumos[1], 589, 589)
		UpdateDebuff(self.lumos[2], 34914, 34914)
		UpdateCooldown(self.lumos[3], 8092, true)
		UpdateBuff(self.lumos[4], 228260, 194249, true)
		UpdateBuff(self.lumos[5], 47585, 47585, true, true)
	end
end