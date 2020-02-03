local B, C, L, DB = unpack(select(2, ...))

tinsert(C.defaultThemes, function()
	local overlayFrames = WorldMapFrame.overlayFrames
	B.ReskinDropDown(overlayFrames[1])
	overlayFrames[2]:DisableDrawLayer("BACKGROUND")
	overlayFrames[2]:DisableDrawLayer("OVERLAY")

	local sideToggle = WorldMapFrame.SidePanelToggle
	B.ReskinArrow(sideToggle.OpenButton, "right")
	B.ReskinArrow(sideToggle.CloseButton, "left")

	local BorderFrame = WorldMapFrame.BorderFrame
	B.ReskinMinMax(BorderFrame.MaximizeMinimizeFrame)
	BorderFrame.Tutorial.Ring:Hide()

	local bg = B.ReskinFrame(BorderFrame)
	bg:SetParent(WorldMapFrame)
	bg:SetPoint("TOPLEFT", C.mult*2, 0)
	bg:SetPoint("BOTTOMRIGHT", 0, C.mult*2)
end)