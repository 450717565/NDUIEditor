local _, ns = ...
local B, C, L, DB = unpack(ns)

tinsert(C.XMLThemes, function()
	B.ReskinNavBar(WorldMapFrame.NavBar)

	local overlayFrames = WorldMapFrame.overlayFrames
	B.ReskinDropDown(overlayFrames[1])
	overlayFrames[2]:DisableDrawLayer("BACKGROUND")
	overlayFrames[2]:DisableDrawLayer("OVERLAY")

	local SidePanelToggle = WorldMapFrame.SidePanelToggle
	B.ReskinArrow(SidePanelToggle.OpenButton, "right")
	B.ReskinArrow(SidePanelToggle.CloseButton, "left")

	local BorderFrame = WorldMapFrame.BorderFrame
	B.ReskinMinMax(BorderFrame.MaximizeMinimizeFrame)
	BorderFrame.Tutorial.Ring:Hide()

	local bg = B.ReskinFrame(BorderFrame, "none")
	bg:SetParent(WorldMapFrame)
	bg:SetPoint("TOPLEFT", 1+C.mult, 0)
	bg:SetPoint("BOTTOMRIGHT", 0, C.mult)
end)