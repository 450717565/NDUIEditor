local B, C, L, DB = unpack(select(2, ...))

C.themes["Blizzard_DebugTools"] = function()
	B.ReskinFrame(EventTraceFrame)

	local bg, bu = EventTraceFrameScroll:GetRegions()
	bg:Hide()
	bu:SetAlpha(0)
	bu:SetWidth(17)

	local bg = B.CreateBDFrame(EventTraceFrame, 0)
	bg:SetAllPoints(bu)

	-- Table Attribute Display
	local function reskinTableAttribute(frame)
		B.ReskinFrame(frame)
		B.StripTextures(frame.ScrollFrameArt)
		B.CreateBDFrame(frame.ScrollFrameArt, 0)
		B.ReskinCheck(frame.VisibilityButton)
		B.ReskinCheck(frame.HighlightButton)
		B.ReskinCheck(frame.DynamicUpdateButton)
		B.ReskinInput(frame.FilterBox)
		B.ReskinScroll(frame.LinesScrollFrame.ScrollBar)

		B.ReskinArrow(frame.OpenParentButton, "down")
		B.ReskinArrow(frame.NavigateBackwardButton, "left")
		B.ReskinArrow(frame.NavigateForwardButton, "right")
		B.ReskinArrow(frame.DuplicateButton, "up")

		frame.OpenParentButton:ClearAllPoints()
		frame.OpenParentButton:SetPoint("TOPLEFT", frame, "TOPLEFT", 2, -2)
		frame.NavigateBackwardButton:ClearAllPoints()
		frame.NavigateBackwardButton:SetPoint("LEFT", frame.OpenParentButton, "RIGHT", 2, 0)
		frame.NavigateForwardButton:ClearAllPoints()
		frame.NavigateForwardButton:SetPoint("LEFT", frame.NavigateBackwardButton, "RIGHT", 2, 0)
		frame.DuplicateButton:ClearAllPoints()
		frame.DuplicateButton:SetPoint("LEFT", frame.NavigateForwardButton, "RIGHT", 2, 0)
	end

	reskinTableAttribute(TableAttributeDisplay)
	hooksecurefunc(TableInspectorMixin, "InspectTable", reskinTableAttribute)
end