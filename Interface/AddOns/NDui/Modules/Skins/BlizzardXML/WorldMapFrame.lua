local _, ns = ...
local B, C, L, DB = unpack(ns)
local S = B:GetModule("Skins")

tinsert(C.XMLThemes, function()
	B.ReskinNavBar(WorldMapFrame.NavBar)

	local overlayFrames = WorldMapFrame.overlayFrames
	B.ReskinDropDown(overlayFrames[1])
	for _, frame in pairs(overlayFrames) do
		frame:DisableDrawLayer("BACKGROUND")
		frame:DisableDrawLayer("OVERLAY")
	end

	local SidePanelToggle = WorldMapFrame.SidePanelToggle
	B.ReskinArrow(SidePanelToggle.OpenButton, "right")
	B.ReskinArrow(SidePanelToggle.CloseButton, "left")

	local BorderFrame = WorldMapFrame.BorderFrame
	B.ReskinMinMax(BorderFrame.MaximizeMinimizeFrame)
	S.ReskinTutorialButton(BorderFrame.Tutorial, BorderFrame)

	local bg = B.ReskinFrame(BorderFrame)
	bg:SetParent(WorldMapFrame)
	bg:ClearAllPoints()
	bg:SetPoint("BOTTOMLEFT", WorldMapFrame.ScrollContainer, -C.mult, -C.mult)
	bg:SetPoint("TOPRIGHT", BorderFrame, 0, 0)
end)