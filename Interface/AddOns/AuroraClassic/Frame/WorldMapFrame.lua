local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	local overlayFrames = WorldMapFrame.overlayFrames
	F.ReskinDropDown(overlayFrames[1])
	overlayFrames[2]:DisableDrawLayer("BACKGROUND")
	overlayFrames[2]:DisableDrawLayer("OVERLAY")

	local sideToggle = WorldMapFrame.SidePanelToggle
	F.ReskinArrow(sideToggle.OpenButton, "right")
	F.ReskinArrow(sideToggle.CloseButton, "left")

	F.ReskinNavBar(WorldMapFrame.NavBar)

	local BorderFrame = WorldMapFrame.BorderFrame
	F.ReskinMinMax(BorderFrame.MaximizeMinimizeFrame)
	BorderFrame.Tutorial.Ring:Hide()

	local bg = F.ReskinFrame(BorderFrame)
	bg:SetParent(WorldMapFrame)
	bg:SetPoint("TOPLEFT", C.pixel, 0)
	bg:SetPoint("BOTTOMRIGHT", 0, C.pixel)
end)