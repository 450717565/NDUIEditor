local F, C = unpack(select(2, ...))

C.themes["Blizzard_DebugTools"] = function()
	-- EventTraceFrame
	F.ReskinFrame(EventTraceFrame)

	select(1, EventTraceFrameScroll:GetRegions()):Hide()
	local bu = select(2, EventTraceFrameScroll:GetRegions())
	bu:SetAlpha(0)
	bu:SetWidth(17)
	bu.bg = F.CreateBDFrame(EventTraceFrame, 0)
	bu.bg:SetPoint("TOPLEFT", bu, 0, 0)
	bu.bg:SetPoint("BOTTOMRIGHT", bu, 0, 0)

	if AuroraConfig.tooltips then
		F.ReskinTooltip(FrameStackTooltip)
		F.ReskinTooltip(EventTraceTooltip)
		FrameStackTooltip:SetScale(UIParent:GetScale())
		EventTraceTooltip:SetParent(UIParent)
		EventTraceTooltip:SetFrameStrata("TOOLTIP")
	end

	-- Table Attribute Display
	local function reskinTableAttribute(frame)
		F.ReskinFrame(frame)
		F.StripTextures(frame.ScrollFrameArt, true)
		F.CreateBDFrame(frame.ScrollFrameArt, 0)
		F.ReskinCheck(frame.VisibilityButton)
		F.ReskinCheck(frame.HighlightButton)
		F.ReskinCheck(frame.DynamicUpdateButton)
		F.ReskinInput(frame.FilterBox)
		F.ReskinScroll(frame.LinesScrollFrame.ScrollBar)

		F.ReskinArrow(frame.OpenParentButton, "up")
		F.ReskinArrow(frame.NavigateBackwardButton, "left")
		F.ReskinArrow(frame.NavigateForwardButton, "right")
		F.ReskinArrow(frame.DuplicateButton, "up")

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

	hooksecurefunc(TableInspectorMixin, "InspectTable", function(self)
		reskinTableAttribute(self)
	end)
end