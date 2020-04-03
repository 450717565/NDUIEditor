local _, ns = ...
local B, C, L, DB = unpack(ns)
local A = B:GetModule("Auras")

if DB.MyClass ~= "DEMONHUNTER" then return end

local function UpdateCooldown(button, spellID, texture)
	return A:UpdateCooldown(button, spellID, texture)
end

local function UpdateBuff(button, spellID, auraID, cooldown, glow)
	return A:UpdateAura(button, "player", auraID, "HELPFUL", spellID, cooldown, glow)
end

local function UpdateDebuff(button, spellID, auraID, cooldown, glow)
	return A:UpdateAura(button, "target", auraID, "HARMFUL", spellID, cooldown, glow)
end

local function UpdateSpellStatus(button, spellID)
	button.Icon:SetTexture(GetSpellTexture(spellID))
	if IsUsableSpell(spellID) then
		button.Icon:SetDesaturated(false)
	else
		button.Icon:SetDesaturated(true)
	end
end

local function GetUnitAura(unit, spell, filter)
	return A:GetUnitAura(unit, spell, filter)
end

local function UpdateBuffValue(button, spellID)
	button.Icon:SetTexture(GetSpellTexture(spellID))
	local name, _, duration, expire, _, _, value = GetUnitAura("player", spellID, "HELPFUL")
	if name then
		button.Count:SetText(B.FormatNumb(value))
		button.CD:SetCooldown(expire-duration, duration)
		button.CD:Show()
		button.Icon:SetDesaturated(false)
		B.ShowOverlayGlow(button.glowFrame)
	else
		button.Count:SetText("")
		UpdateCooldown(button, spellID)
		B.HideOverlayGlow(button.glowFrame)
	end
	button.Count:SetTextColor(1, 1, 1)
end

function A:ChantLumos(self)
	if GetSpecialization() == 1 then
		do
			local button1 = self.bu[1]
			if IsPlayerSpell(258920) then
				UpdateBuff(button1, 258920, 258920, true)
			elseif IsPlayerSpell(232893) then
				UpdateCooldown(button1, 232893, true)
			else
				UpdateSpellStatus(button1, 162794)
			end
		end

		do
			local button2 = self.bu[2]
			if IsPlayerSpell(258920) or IsPlayerSpell(232893) then
				UpdateSpellStatus(button2, 162794)
			else
				UpdateCooldown(button2, 188499, true)
			end
		end

		do
			local button4 = self.bu[4]
			if IsPlayerSpell(258920) or IsPlayerSpell(232893) then
				UpdateCooldown(button4, 188499, true)
			else
				UpdateCooldown(button4, 179057, true)
			end
		end

		UpdateBuff(self.bu[3], 198013, 273232, true, true)
		UpdateBuff(self.bu[5], 191427, 162264, true, true)
	elseif GetSpecialization() == 2 then
		do
			local button1, spellID = self.bu[1], 228477
			if IsPlayerSpell(247454) then spellID = 247454 end

			UpdateSpellStatus(button1, spellID)
			button1.Count:SetText(GetSpellCount(spellID))
		end

		do
			local button2 = self.bu[2]
			if IsPlayerSpell(263648) then
				UpdateBuffValue(button2, 263648)
			else
				UpdateBuff(button2, 178740, 178740, true)
			end
		end

		UpdateDebuff(self.bu[3], 204021, 207744, true, true)
		UpdateBuff(self.bu[4], 203720, 203819, true, "END")
		UpdateBuff(self.bu[5], 187827, 187827, true, true)
	end
end