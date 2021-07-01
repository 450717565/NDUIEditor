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

C.OnLoadThemes["Blizzard_DebugTools"] = function()
	-- TableAttribute
	Reskin_TableAttribute(TableAttributeDisplay)
	hooksecurefunc(TableInspectorMixin, "InspectTable", Reskin_TableAttribute)
end