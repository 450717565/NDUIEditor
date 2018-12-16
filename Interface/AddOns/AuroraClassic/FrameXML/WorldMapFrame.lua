local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	local WorldMapFrame = WorldMapFrame
	local BorderFrame = WorldMapFrame.BorderFrame

	F.ReskinPortraitFrame(BorderFrame)
	F.SetBD(WorldMapFrame, 1, 0, -3, 1)
	F.ReskinMinMax(BorderFrame.MaximizeMinimizeFrame)
	BorderFrame.Tutorial.Ring:Hide()

	local overlayFrames = WorldMapFrame.overlayFrames
	F.ReskinDropDown(overlayFrames[1])
	overlayFrames[2]:DisableDrawLayer("BACKGROUND")
	overlayFrames[2]:DisableDrawLayer("OVERLAY")

	local sideToggle = WorldMapFrame.SidePanelToggle
	F.ReskinArrow(sideToggle.OpenButton, "right")
	F.ReskinArrow(sideToggle.CloseButton, "left")

	--F.ReskinNavBar(WorldMapFrame.NavBar)
end)