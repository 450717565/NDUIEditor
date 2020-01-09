local F, C = unpack(select(2, ...))

C.themes["Blizzard_Calendar"] = function()
	if AuroraConfig.tooltips then
		F.ReskinTooltip(CalendarContextMenu)
		F.ReskinTooltip(CalendarInviteStatusContextMenu)
	end

	local cr, cg, cb = C.r, C.g, C.b

	F.StripTextures(CalendarFrame)
	F.SetBDFrame(CalendarFrame, 11+C.mult, 0, -9, 3+C.mult)
	F.ReskinClose(CalendarCloseButton, "TOPRIGHT", CalendarFrame, "TOPRIGHT", -14, -6)
	F.ReskinArrow(CalendarPrevMonthButton, "left")
	F.ReskinArrow(CalendarNextMonthButton, "right")
	F.ReskinCheck(CalendarCreateEventLockEventCheck)

	F.StripTextures(CalendarFilterFrame)
	F.ReskinArrow(CalendarFilterButton, "down")

	F.StripTextures(CalendarClassTotalsButton)
	F.CreateBDFrame(CalendarClassTotalsButton)

	CalendarViewEventDivider:Hide()
	CalendarCreateEventDivider:Hide()

	CalendarViewEventFrame:ClearAllPoints()
	CalendarViewEventFrame:SetPoint("TOPLEFT", CalendarFrame, "TOPRIGHT", 0, -25)
	CalendarViewHolidayFrame:ClearAllPoints()
	CalendarViewHolidayFrame:SetPoint("TOPLEFT", CalendarFrame, "TOPRIGHT", 0, -25)
	CalendarViewRaidFrame:ClearAllPoints()
	CalendarViewRaidFrame:SetPoint("TOPLEFT", CalendarFrame, "TOPRIGHT", 0, -25)
	CalendarCreateEventFrame:ClearAllPoints()
	CalendarCreateEventFrame:SetPoint("TOPLEFT", CalendarFrame, "TOPRIGHT", 0, -25)
	CalendarClassButton1:ClearAllPoints()
	CalendarClassButton1:SetPoint("TOPLEFT", CalendarViewEventFrame, "TOPRIGHT", 4, -25)
	CalendarMassInviteFrame:ClearAllPoints()
	CalendarMassInviteFrame:SetPoint("TOPLEFT", CalendarClassButton1, "TOPRIGHT", 5, 1)
	CalendarTexturePickerFrame:ClearAllPoints()
	CalendarTexturePickerFrame:SetPoint("TOPLEFT", CalendarClassButton1, "TOPRIGHT", 5, 1)

	CalendarCreateEventHourDropDown:SetWidth(80)
	CalendarCreateEventMinuteDropDown:SetWidth(80)
	CalendarCreateEventAMPMDropDown:SetWidth(90)
	CalendarCreateEventDifficultyOptionDropDown:SetWidth(150)

	local frames = {CalendarViewEventTitleFrame, CalendarViewHolidayTitleFrame, CalendarViewRaidTitleFrame, CalendarCreateEventTitleFrame, CalendarTexturePickerTitleFrame, CalendarMassInviteTitleFrame}
	for _, frame in pairs(frames) do
		F.StripTextures(frame)

		local parent = frame:GetParent()
		F.ReskinFrame(parent)
	end

	local containers = {CalendarViewEventInviteList, CalendarViewEventDescriptionContainer, CalendarCreateEventInviteList, CalendarCreateEventDescriptionContainer}
	for _, container in pairs(containers) do
		F.StripTextures(container)
		F.CreateBDFrame(container, 0)
	end

	local buttons = {CalendarViewEventAcceptButton, CalendarViewEventTentativeButton, CalendarViewEventDeclineButton, CalendarViewEventRemoveButton, CalendarCreateEventMassInviteButton, CalendarCreateEventCreateButton, CalendarCreateEventInviteButton, CalendarCreateEventRaidInviteButton, CalendarTexturePickerAcceptButton, CalendarTexturePickerCancelButton, CalendarMassInviteAcceptButton}
	for _, button in pairs(buttons) do
		F.StripTextures(button)
		F.ReskinButton(button)
	end

	local closes = {CalendarCreateEventCloseButton, CalendarViewEventCloseButton, CalendarViewHolidayCloseButton, CalendarViewRaidCloseButton, CalendarMassInviteCloseButton}
	for _, close in pairs(closes) do
		F.ReskinClose(close)
	end

	local scrolls = {CalendarTexturePickerScrollBar, CalendarViewEventInviteListScrollFrameScrollBar, CalendarViewEventDescriptionScrollFrameScrollBar, CalendarCreateEventInviteListScrollFrameScrollBar, CalendarCreateEventDescriptionScrollFrameScrollBar}
	for _, scroll in pairs(scrolls) do
		F.ReskinScroll(scroll)
	end

	local dropdowns = {CalendarCreateEventCommunityDropDown, CalendarCreateEventTypeDropDown, CalendarCreateEventHourDropDown, CalendarCreateEventMinuteDropDown, CalendarCreateEventAMPMDropDown, CalendarCreateEventDifficultyOptionDropDown, CalendarMassInviteCommunityDropDown, CalendarMassInviteRankMenu}
	for _, dropdown in pairs(dropdowns) do
		F.ReskinDropDown(dropdown)
	end

	local inputs = {CalendarCreateEventTitleEdit, CalendarCreateEventInviteEdit, CalendarMassInviteMinLevelEdit, CalendarMassInviteMaxLevelEdit}
	for _, input in pairs(inputs) do
		F.ReskinInput(input)
	end

	if C.isNewPatch then
		local function reskinCalendarPage(self)
			F.ReskinFrame(self)
			F.StripTextures(self.Header)
		end
		reskinCalendarPage(CalendarViewHolidayFrame)
		reskinCalendarPage(CalendarCreateEventFrame)
		reskinCalendarPage(CalendarTexturePickerFrame)
		reskinCalendarPage(CalendarEventPickerFrame)
	else
		F.ReskinFrame(CalendarEventPickerFrame)
		F.StripTextures(CalendarEventPickerTitleFrame)
		F.StripTextures(CalendarEventPickerCloseButton)
		F.ReskinButton(CalendarEventPickerCloseButton)
	end

	for i, class in pairs(CLASS_SORT_ORDER) do
		local bu = _G["CalendarClassButton"..i]
		bu:GetRegions():Hide()

		local tcoords = CLASS_ICON_TCOORDS[class]
		local ic = bu:GetNormalTexture()
		ic:SetTexCoord(tcoords[1] + .022, tcoords[2] - .025, tcoords[3] + .022, tcoords[4] - .025)
		F.CreateBDFrame(ic)
	end

	for i = 1, 42 do
		local button = "CalendarDayButton"..i

		local bu = _G[button]
		F.StripTextures(bu)
		F.ReskinTexture(bu, bu, true)

		local df = _G[button.."DarkFrame"]
		df:SetAlpha(.5)

		local index = 1
		local eventButton = _G[button.."EventButton"..index]
		while eventButton do
			eventButton:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)
			eventButton.black:SetTexture(nil)

			index = index + 1
			eventButton = _G[button.."EventButton"..index]
		end
	end

	for i = 1, 6 do
		local vDay = _G["CalendarDayButton"..i]
		local vLine = CreateFrame("Frame", nil, vDay)
		vLine:SetFrameLevel(vDay:GetFrameLevel()+1)
		vLine:SetSize(C.mult, 546)
		vLine:ClearAllPoints()
		vLine:SetPoint("TOP", vDay, "TOPRIGHT")
		F.CreateBD(vLine, 1)
	end

	for i = 1, 36, 7 do
		local hDay = _G["CalendarDayButton"..i]
		local hLine = CreateFrame("Frame", nil, hDay)
		hLine:SetFrameLevel(hDay:GetFrameLevel()+1)
		hLine:SetSize(637, C.mult)
		hLine:ClearAllPoints()
		hLine:SetPoint("LEFT", hDay, "TOPLEFT")
		F.CreateBD(hLine, 1)
	end

	hooksecurefunc("CalendarFrame_SetToday", function(self)
		local today = CalendarTodayFrame
		today:SetAllPoints()

		if not self.styled then
			F.StripTextures(today)

			F.CreateBD(today, 0)
			today:SetBackdropBorderColor(cr, cg, cb)

			self.styled = true
		end
	end)

	hooksecurefunc("CalendarEventFrameBlocker_Update", function(self)
		local eventFrame = CalendarFrame_GetEventFrame()
		local eventFrameOverlay = _G[eventFrame:GetName().."ModalOverlay"]

		if eventFrameOverlay then
			eventFrameOverlay:SetAllPoints()
		end
	end)
end