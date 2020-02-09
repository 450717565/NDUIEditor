local _, ns = ...
local B, C, L, DB = unpack(ns)
local A = B:GetModule("Auras")

-- Style
local IconSize = C.Auras.IconSize
local IconMargin = 5
local totem = {}
local icons = {
	[1] = GetSpellTexture(120217), -- Fire
	[2] = GetSpellTexture(120218), -- Earth
	[3] = GetSpellTexture(120214), -- Water
	[4] = GetSpellTexture(120219), -- Air
}

local function TotemsGo()
	local Totembar = CreateFrame("Frame", nil, UIParent)
	Totembar:SetSize(IconSize*4 + IconMargin*3, IconSize)
	for i = 1, 4 do
		totem[i] = CreateFrame("Button", nil, Totembar)
		totem[i]:SetSize(IconSize, IconSize)
		if i == 1 then
			totem[i]:SetPoint("LEFT", Totembar, "LEFT", 0, 0)
		else
			totem[i]:SetPoint("LEFT", totem[i-1], "RIGHT", 5, 0)
		end
		B.AuraIcon(totem[i])
		totem[i].Icon:SetTexture(icons[i])
		totem[i]:SetAlpha(.25)

		local defaultTotem = _G["TotemFrameTotem"..i]
		defaultTotem:SetParent(totem[i])
		defaultTotem:SetAllPoints()
		defaultTotem:SetAlpha(0)
		totem[i].parent = defaultTotem
	end

	B.Mover(Totembar, L["Totembar"], "Totems", C.Auras.TotemsPos)
end

function A:UpdateTotems()
	for i = 1, 4 do
		local totem = totem[i]
		local defaultTotem = totem.parent
		local slot = defaultTotem.slot

		local haveTotem, _, start, dur, icon = GetTotemInfo(slot)
		if haveTotem and dur > 0 then
			totem.Icon:SetTexture(icon)
			totem.CD:SetCooldown(start, dur)
			totem.CD:Show()
			totem:SetAlpha(1)
		else
			totem:SetAlpha(.25)
			totem.Icon:SetTexture(icons[i])
			totem.CD:Hide()
		end
	end
end

function A:Totems()
	if not NDuiDB["Auras"]["Totems"] then return end

	TotemsGo()
	B:RegisterEvent("PLAYER_ENTERING_WORLD", self.UpdateTotems)
	B:RegisterEvent("PLAYER_TOTEM_UPDATE", self.UpdateTotems)
end