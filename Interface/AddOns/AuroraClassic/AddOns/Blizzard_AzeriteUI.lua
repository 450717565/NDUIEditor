local F, C = unpack(select(2, ...))

C.themes["Blizzard_AzeriteUI"] = function()
	F.ReskinFrame(AzeriteEmpoweredItemUI)
	AzeriteEmpoweredItemUI.ClipFrame.BackgroundFrame.Bg:Hide()
end