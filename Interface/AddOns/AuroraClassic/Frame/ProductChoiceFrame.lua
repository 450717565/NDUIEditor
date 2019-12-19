local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	if C.isNewPatch then return end

	F.ReskinFrame(ProductChoiceFrame)
	F.ReskinButton(ProductChoiceFrame.Inset.ClaimButton)
end)