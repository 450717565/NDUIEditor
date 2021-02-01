local _, ns = ...
local B, C, L, DB = unpack(ns)
local S = B:GetModule("Skins")

C.LUAThemes["Blizzard_AnimaDiversionUI"] = function()
	local frame = AnimaDiversionFrame
	B.ReskinButton(frame.ReinforceInfoFrame.AnimaNodeReinforceButton)

	local bg = B.ReskinFrame(frame)
	bg:SetOutside(frame.ScrollContainer.Child)

	local currency = frame.AnimaDiversionCurrencyFrame
	B.StripTextures(currency)
	currency:ClearAllPoints()
	currency:SetPoint("TOP", bg)

	local CurrencyFrame = currency.CurrencyFrame
	S.ReplaceIconString(CurrencyFrame.Quantity)
end