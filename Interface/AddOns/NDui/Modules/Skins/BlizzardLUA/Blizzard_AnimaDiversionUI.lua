local _, ns = ...
local B, C, L, DB = unpack(ns)
local S = B:GetModule("Skins")

C.LUAThemes["Blizzard_AnimaDiversionUI"] = function()
	local frame = AnimaDiversionFrame

	B.ReskinFrame(frame)
	B.ReskinButton(frame.ReinforceInfoFrame.AnimaNodeReinforceButton)
	frame.AnimaDiversionCurrencyFrame.Background:SetAlpha(0)

	local CurrencyFrame = frame.AnimaDiversionCurrencyFrame.CurrencyFrame
	S.ReplaceIconString(CurrencyFrame.Quantity)
	hooksecurefunc(CurrencyFrame.Quantity, "SetText", S.ReplaceIconString)
end