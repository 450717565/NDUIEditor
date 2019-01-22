local F, C = unpack(select(2, ...))

C.themes["Blizzard_Calendar"] = function()
	local lists = {CalendarFrame, CalendarFilterFrame, CalendarCreateEventTitleFrame, CalendarViewEventTitleFrame, CalendarViewHolidayTitleFrame, CalendarViewRaidTitleFrame, CalendarEventPickerTitleFrame, CalendarMassInviteTitleFrame, CalendarCreateEventCloseButton, CalendarViewEventCloseButton, CalendarViewHolidayCloseButton, CalendarViewRaidCloseButton, CalendarMassInviteCloseButton, CalendarTexturePickerTitleFrame}
	for _, list in next, lists do
		F.StripTextures(list, true)
	end

	F.SetBD(CalendarFrame, 11, 0, -9, 3)

	for i = 1, 42 do
		_G["CalendarDayButton"..i.."DarkFrame"]:SetAlpha(.5)
		local bu = _G["CalendarDayButton"..i]
		F.StripTextures(bu)
		F.ReskinTexture(bu, bu, true)

		local hl = bu:GetHighlightTexture()
		hl.SetAlpha = F.dummy
	end

	local frames = {CalendarViewEventFrame, CalendarViewHolidayFrame, CalendarViewRaidFrame, CalendarCreateEventFrame, CalendarTexturePickerFrame, CalendarMassInviteFrame, CalendarClassTotalsButton, CalendarViewEventInviteList, CalendarViewEventDescriptionContainer, CalendarCreateEventInviteList, CalendarCreateEventDescriptionContainer, CalendarEventPickerFrame}
	for _, frame in next, frames do
		F.ReskinFrame(frame)
	end

	CalendarViewEventDivider:Hide()
	CalendarCreateEventDivider:Hide()
	CalendarViewRaidFrameModalOverlay:SetAlpha(0)
	CalendarWeekdaySelectedTexture:SetDesaturated(true)
	CalendarWeekdaySelectedTexture:SetVertexColor(r, g, b)

	hooksecurefunc("CalendarFrame_SetToday", function()
		CalendarTodayFrame:SetAllPoints()
	end)

	CalendarTodayFrame:SetScript("OnUpdate", nil)
	F.StripTextures(CalendarTodayFrame, true)
	local bg = F.CreateBDFrame(CalendarTodayFrame, 0)
	bg:SetBackdropBorderColor(r, g, b)

	for i, class in ipairs(CLASS_SORT_ORDER) do
		local bu = _G["CalendarClassButton"..i]
		bu:GetRegions():Hide()
		F.CreateBDFrame(bu)

		local tcoords = CLASS_ICON_TCOORDS[class]
		local ic = bu:GetNormalTexture()
		ic:SetTexCoord(tcoords[1] + .022, tcoords[2] - .025, tcoords[3] + .022, tcoords[4] - .025)
	end

	for i = 1, 6 do
		local vline = F.CreateBDFrame(_G["CalendarDayButton"..i])
		vline:SetFrameLevel(_G["CalendarDayButton"..i]:GetFrameLevel()+1)
		vline:SetHeight(546)
		vline:SetWidth(C.mult)
		vline:ClearAllPoints()
		vline:SetPoint("TOP", _G["CalendarDayButton"..i], "TOPRIGHT")
		vline.Shadow:Hide()
	end

	for i = 1, 36, 7 do
		local hline = F.CreateBDFrame(_G["CalendarDayButton"..i])
		hline:SetFrameLevel(_G["CalendarDayButton"..i]:GetFrameLevel()+1)
		hline:SetWidth(637)
		hline:SetHeight(C.mult)
		hline:ClearAllPoints()
		hline:SetPoint("LEFT", _G["CalendarDayButton"..i], "TOPLEFT")
		hline.Shadow:Hide()
	end

	if AuroraConfig.tooltips then
		F.ReskinTooltip(CalendarContextMenu)
		F.ReskinTooltip(CalendarInviteStatusContextMenu)
	end

	CalendarViewEventFrame:SetPoint("TOPLEFT", CalendarFrame, "TOPRIGHT", -8, -24)
	CalendarViewHolidayFrame:SetPoint("TOPLEFT", CalendarFrame, "TOPRIGHT", -8, -24)
	CalendarViewRaidFrame:SetPoint("TOPLEFT", CalendarFrame, "TOPRIGHT", -8, -24)
	CalendarCreateEventFrame:SetPoint("TOPLEFT", CalendarFrame, "TOPRIGHT", -8, -24)
	CalendarCreateEventInviteButton:SetPoint("TOPLEFT", CalendarCreateEventInviteEdit, "TOPRIGHT", 1, 1)
	CalendarClassButton1:SetPoint("TOPLEFT", CalendarClassButtonContainer, "TOPLEFT", 5, 0)

	CalendarCreateEventHourDropDown:SetWidth(80)
	CalendarCreateEventMinuteDropDown:SetWidth(80)
	CalendarCreateEventAMPMDropDown:SetWidth(90)

	local line = CalendarMassInviteFrame:CreateTexture(nil, "BACKGROUND")
	line:SetSize(240, C.mult)
	line:SetPoint("TOP", CalendarMassInviteFrame, "TOP", 0, -150)
	line:SetTexture(C.media.bdTex)
	line:SetVertexColor(0, 0, 0)

	CalendarMassInviteFrame:ClearAllPoints()
	CalendarMassInviteFrame:SetPoint("BOTTOMLEFT", CalendarCreateEventFrame, "BOTTOMRIGHT", 28, 0)

	CalendarTexturePickerFrame:ClearAllPoints()
	CalendarTexturePickerFrame:SetPoint("TOPLEFT", CalendarCreateEventFrame, "TOPRIGHT", 28, 0)

	local cbuttons = {CalendarViewEventAcceptButton, CalendarViewEventTentativeButton, CalendarViewEventDeclineButton, CalendarViewEventRemoveButton, CalendarCreateEventMassInviteButton, CalendarCreateEventCreateButton, CalendarCreateEventInviteButton, CalendarEventPickerCloseButton, CalendarCreateEventRaidInviteButton, CalendarTexturePickerAcceptButton, CalendarTexturePickerCancelButton, CalendarFilterButton, CalendarMassInviteAcceptButton}
	for _, button in next, cbuttons do
		F.StripTextures(button, true)
		F.ReskinButton(button)
	end

	local downtex = CalendarFilterButton:CreateTexture(nil, "ARTWORK")
	downtex:SetTexture(C.media.arrowDown)
	downtex:SetSize(8, 8)
	downtex:SetPoint("CENTER")
	downtex:SetVertexColor(1, 1, 1)

	F.ReskinCheck(CalendarCreateEventLockEventCheck)
	F.ReskinClose(CalendarCloseButton, "TOPRIGHT", CalendarFrame, "TOPRIGHT", -14, -4)
	F.ReskinClose(CalendarCreateEventCloseButton)
	F.ReskinClose(CalendarViewEventCloseButton)
	F.ReskinClose(CalendarViewHolidayCloseButton)
	F.ReskinClose(CalendarViewRaidCloseButton)
	F.ReskinClose(CalendarMassInviteCloseButton)
	F.ReskinScroll(CalendarTexturePickerScrollBar)
	F.ReskinScroll(CalendarViewEventInviteListScrollFrameScrollBar)
	F.ReskinScroll(CalendarViewEventDescriptionScrollFrameScrollBar)
	F.ReskinScroll(CalendarCreateEventInviteListScrollFrameScrollBar)
	F.ReskinScroll(CalendarCreateEventDescriptionScrollFrameScrollBar)
	F.ReskinDropDown(CalendarCreateEventCommunityDropDown)
	F.ReskinDropDown(CalendarCreateEventTypeDropDown)
	F.ReskinDropDown(CalendarCreateEventHourDropDown)
	F.ReskinDropDown(CalendarCreateEventMinuteDropDown)
	F.ReskinDropDown(CalendarCreateEventAMPMDropDown)
	F.ReskinDropDown(CalendarCreateEventDifficultyOptionDropDown)
	F.ReskinDropDown(CalendarMassInviteCommunityDropDown)
	F.ReskinDropDown(CalendarMassInviteRankMenu)
	F.ReskinInput(CalendarCreateEventTitleEdit)
	F.ReskinInput(CalendarCreateEventInviteEdit)
	F.ReskinInput(CalendarMassInviteMinLevelEdit)
	F.ReskinInput(CalendarMassInviteMaxLevelEdit)
	F.ReskinArrow(CalendarPrevMonthButton, "left")
	F.ReskinArrow(CalendarNextMonthButton, "right")
	CalendarPrevMonthButton:SetSize(19, 19)
	CalendarNextMonthButton:SetSize(19, 19)
	CalendarCreateEventDifficultyOptionDropDown:SetWidth(150)
end