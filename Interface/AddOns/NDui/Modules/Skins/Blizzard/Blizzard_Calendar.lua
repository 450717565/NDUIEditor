local B, C, L, DB = unpack(select(2, ...))

C.themes["Blizzard_Calendar"] = function()
	local cr, cg, cb = DB.r, DB.g, DB.b

	B.StripTextures(CalendarFrame)
	local bg = B.CreateBG(CalendarFrame, 11+C.mult, 0, -9, 3+C.mult)
	B.ReskinClose(CalendarCloseButton, "TOPRIGHT", bg, "TOPRIGHT", -6, -6)

	B.ReskinArrow(CalendarPrevMonthButton, "left")
	B.ReskinArrow(CalendarNextMonthButton, "right")
	B.ReskinCheck(CalendarCreateEventLockEventCheck)

	B.StripTextures(CalendarFilterFrame)
	B.ReskinArrow(CalendarFilterButton, "down")

	B.StripTextures(CalendarClassTotalsButton)
	B.CreateBDFrame(CalendarClassTotalsButton)

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
	CalendarClassButton1:SetPoint("TOPLEFT", CalendarViewEventFrame, "TOPRIGHT", 3, -25)
	CalendarMassInviteFrame:ClearAllPoints()
	CalendarMassInviteFrame:SetPoint("TOPLEFT", CalendarClassButton1, "TOPRIGHT", 4, 0)
	CalendarTexturePickerFrame:ClearAllPoints()
	CalendarTexturePickerFrame:SetPoint("TOPLEFT", CalendarClassButton1, "TOPRIGHT", 4, 0)

	CalendarCreateEventHourDropDown:SetWidth(80)
	CalendarCreateEventMinuteDropDown:SetWidth(80)
	CalendarCreateEventAMPMDropDown:SetWidth(90)
	CalendarCreateEventDifficultyOptionDropDown:SetWidth(150)

	local titles = {CalendarViewEventTitleFrame, CalendarViewHolidayTitleFrame, CalendarViewRaidTitleFrame, CalendarCreateEventTitleFrame, CalendarTexturePickerTitleFrame, CalendarMassInviteTitleFrame}
	for _, title in pairs(titles) do
		B.StripTextures(title)

		local parent = title:GetParent()
		B.ReskinFrame(parent)
	end

	local frames = {CalendarViewHolidayFrame, CalendarCreateEventFrame, CalendarTexturePickerFrame, CalendarEventPickerFrame}
	for _, frame in pairs(frames) do
		B.ReskinFrame(frame)
	end

	local containers = {CalendarViewEventInviteList, CalendarViewEventDescriptionContainer, CalendarCreateEventInviteList, CalendarCreateEventDescriptionContainer}
	for _, container in pairs(containers) do
		B.StripTextures(container)
		B.CreateBDFrame(container, 0)
	end

	local buttons = {CalendarViewEventAcceptButton, CalendarViewEventTentativeButton, CalendarViewEventDeclineButton, CalendarViewEventRemoveButton, CalendarCreateEventMassInviteButton, CalendarCreateEventCreateButton, CalendarCreateEventInviteButton, CalendarCreateEventRaidInviteButton, CalendarTexturePickerAcceptButton, CalendarTexturePickerCancelButton, CalendarMassInviteAcceptButton}
	for _, button in pairs(buttons) do
		B.StripTextures(button)
		B.ReskinButton(button)
	end

	local closes = {CalendarCreateEventCloseButton, CalendarViewEventCloseButton, CalendarViewHolidayCloseButton, CalendarViewRaidCloseButton, CalendarMassInviteCloseButton}
	for _, close in pairs(closes) do
		B.ReskinClose(close)
	end

	local scrolls = {CalendarTexturePickerScrollBar, CalendarViewEventInviteListScrollFrameScrollBar, CalendarViewEventDescriptionScrollFrameScrollBar, CalendarCreateEventInviteListScrollFrameScrollBar, CalendarCreateEventDescriptionScrollFrameScrollBar}
	for _, scroll in pairs(scrolls) do
		B.ReskinScroll(scroll)
	end

	local dropdowns = {CalendarCreateEventCommunityDropDown, CalendarCreateEventTypeDropDown, CalendarCreateEventHourDropDown, CalendarCreateEventMinuteDropDown, CalendarCreateEventAMPMDropDown, CalendarCreateEventDifficultyOptionDropDown, CalendarMassInviteCommunityDropDown, CalendarMassInviteRankMenu}
	for _, dropdown in pairs(dropdowns) do
		B.ReskinDropDown(dropdown)
	end

	local inputs = {CalendarCreateEventTitleEdit, CalendarCreateEventInviteEdit, CalendarMassInviteMinLevelEdit, CalendarMassInviteMaxLevelEdit}
	for _, input in pairs(inputs) do
		B.ReskinInput(input)
	end

	for i, class in pairs(CLASS_SORT_ORDER) do
		local bu = _G["CalendarClassButton"..i]
		bu:GetRegions():Hide()

		local tcoords = CLASS_ICON_TCOORDS[class]
		local ic = bu:GetNormalTexture()
		ic:SetTexCoord(tcoords[1] + .022, tcoords[2] - .025, tcoords[3] + .022, tcoords[4] - .025)
		B.CreateBDFrame(ic)
	end

	for i = 1, 42 do
		local button = "CalendarDayButton"..i

		local bu = _G[button]
		B.StripTextures(bu)
		B.ReskinHighlight(bu, bu, true)

		local df = _G[button.."DarkFrame"]
		df:SetAlpha(.5)

		local index = 1
		local eventButton = _G[button.."EventButton"..index]
		while eventButton do
			B.ReskinHighlight(eventButton)
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
		B.CreateBD(vLine, 1)
	end

	for i = 1, 36, 7 do
		local hDay = _G["CalendarDayButton"..i]
		local hLine = CreateFrame("Frame", nil, hDay)
		hLine:SetFrameLevel(hDay:GetFrameLevel()+1)
		hLine:SetSize(637, C.mult)
		hLine:ClearAllPoints()
		hLine:SetPoint("LEFT", hDay, "TOPLEFT")
		B.CreateBD(hLine, 1)
	end

	hooksecurefunc("CalendarFrame_SetToday", function(self)
		local today = CalendarTodayFrame
		today:SetAllPoints()

		if not self.styled then
			B.StripTextures(today)

			B.CreateBD(today, 0)
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