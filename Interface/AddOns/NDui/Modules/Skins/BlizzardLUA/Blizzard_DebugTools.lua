local _, ns = ...
local B, C, L, DB = unpack(ns)

local function Reskin_TableAttribute(self)
	if self.styled then return end

	B.ReskinFrame(self)
	B.StripTextures(self.ScrollFrameArt)
	B.CreateBDFrame(self.ScrollFrameArt)
	B.ReskinCheck(self.VisibilityButton)
	B.ReskinCheck(self.HighlightButton)
	B.ReskinCheck(self.DynamicUpdateButton)
	B.ReskinInput(self.FilterBox)
	B.ReskinScroll(self.LinesScrollFrame.ScrollBar)

	B.ReskinArrow(self.OpenParentButton, "down")
	B.ReskinArrow(self.NavigateBackwardButton, "left")
	B.ReskinArrow(self.NavigateForwardButton, "right")
	B.ReskinArrow(self.DuplicateButton, "up")

	self.OpenParentButton:ClearAllPoints()
	self.OpenParentButton:SetPoint("TOPLEFT", self, "TOPLEFT", 2, -2)
	self.NavigateBackwardButton:ClearAllPoints()
	self.NavigateBackwardButton:SetPoint("LEFT", self.OpenParentButton, "RIGHT", 2, 0)
	self.NavigateForwardButton:ClearAllPoints()
	self.NavigateForwardButton:SetPoint("LEFT", self.NavigateBackwardButton, "RIGHT", 2, 0)
	self.DuplicateButton:ClearAllPoints()
	self.DuplicateButton:SetPoint("LEFT", self.NavigateForwardButton, "RIGHT", 2, 0)

	self.styled = true
end

C.LUAThemes["Blizzard_DebugTools"] = function()
	-- TableAttribute
	Reskin_TableAttribute(TableAttributeDisplay)
	hooksecurefunc(TableInspectorMixin, "InspectTable", Reskin_TableAttribute)

	if DB.isNewPatch then return end
	-- EventTraceFrame
	B.ReskinFrame(EventTraceFrame)

	local bg, bu = EventTraceFrameScroll:GetRegions()
	bg:Hide()
	bu:SetAlpha(0)
	bu:SetWidth(18)
	B.CreateBDFrame(bu)

	for i = 1, 29 do
		local button = _G["EventTraceFrameButton"..i]
		local hide = _G["EventTraceFrameButton"..i.."HideButton"]
		B.ReskinClose(hide)
		hide:ClearAllPoints()
		hide:SetPoint("LEFT", button, "LEFT", 0, 0)
	end
end