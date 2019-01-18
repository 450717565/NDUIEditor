local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	local BorderFrame = WorldMapFrame.BorderFrame
	WorldMapFramePortrait:SetAlpha(0)

	F.StripTextures(WorldMapFrame, true)
	F.StripTextures(BorderFrame, true)
	F.ReskinClose(BorderFrame.CloseButton)
	F.SetBD(WorldMapFrame, C.mult, 0, -(C.mult*2), C.mult)

	F.ReskinMinMax(BorderFrame.MaximizeMinimizeFrame)

	local overlayFrames = WorldMapFrame.overlayFrames
	F.ReskinDropDown(overlayFrames[1])
	overlayFrames[2]:DisableDrawLayer("BACKGROUND")
	overlayFrames[2]:DisableDrawLayer("OVERLAY")

	local sideToggle = WorldMapFrame.SidePanelToggle
	F.ReskinArrow(sideToggle.OpenButton, "right")
	F.ReskinArrow(sideToggle.CloseButton, "left")

	F.ReskinNavBar(WorldMapFrame.NavBar)
end)