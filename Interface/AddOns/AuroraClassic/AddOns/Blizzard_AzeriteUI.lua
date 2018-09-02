local F, C = unpack(select(2, ...))

C.themes["Blizzard_AzeriteUI"] = function()
	F.StripTextures(AzeriteEmpoweredItemUI, true)
	F.StripTextures(AzeriteEmpoweredItemUI.BorderFrame, true)
	F.CreateBD(AzeriteEmpoweredItemUI)
	F.CreateSD(AzeriteEmpoweredItemUI)
	F.ReskinClose(AzeriteEmpoweredItemUICloseButton)

	AzeriteEmpoweredItemUI.ClipFrame.BackgroundFrame.Bg:Hide()
	AzeriteEmpoweredItemUI.ClipFrame.BackgroundFrame.KeyOverlay.Shadow:Hide()
end