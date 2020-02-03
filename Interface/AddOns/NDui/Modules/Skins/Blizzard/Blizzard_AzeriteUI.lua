local B, C, L, DB = unpack(select(2, ...))

C.themes["Blizzard_AzeriteUI"] = function()
	B.ReskinFrame(AzeriteEmpoweredItemUI)
	AzeriteEmpoweredItemUI.ClipFrame.BackgroundFrame.Bg:Hide()
end