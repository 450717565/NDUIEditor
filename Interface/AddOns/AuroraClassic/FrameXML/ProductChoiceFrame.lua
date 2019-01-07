local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	F.ReskinPortraitFrame(ProductChoiceFrame, true)
	F.Reskin(ProductChoiceFrame.Inset.ClaimButton)
end)