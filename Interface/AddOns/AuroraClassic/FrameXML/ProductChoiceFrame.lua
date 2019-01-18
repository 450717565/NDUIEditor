local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	F.ReskinFrame(ProductChoiceFrame)
	F.ReskinButton(ProductChoiceFrame.Inset.ClaimButton)
end)