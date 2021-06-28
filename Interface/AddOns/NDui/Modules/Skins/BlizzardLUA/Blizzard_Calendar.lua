local _, ns = ...
local B, C, L, DB = unpack(ns)

local cr, cg, cb = DB.cr, DB.cg, DB.cb
local tL, tR, tT, tB = unpack(DB.TexCoord)

local function Reskin_SetToday(self)
	local frame = CalendarTodayFrame
	frame:SetAllPoints()

	if not self.styled then
		B.StripTextures(frame)

		local bubg = B.CreateBDFrame(frame, 0, 0, true)
		bubg:SetBackdropColor(cr, cg, cb, .25)
		bubg:SetBackdropBorderColor(cr, cg, cb)

		self.styled = true
	end
end

local function Reskin_CalendarEventFrameBlocker()
	local eventFrame = CalendarFrame_GetEventFrame()
	local eventFrameOverlay = B.GetObject(eventFrame, "ModalOverlay")

	if eventFrameOverlay then
		eventFrameOverlay:SetAllPoints()
	end
end

local function Update_FrameAnchor(self)
	self:ClearAllPoints()
	self:SetPoint("BOTTOMLEFT", bg, "BOTTOMRIGHT", 3, 0)
end

C.OnLoadThemes["Blizzard_Calendar"] = function()
	B.StripTextures(CalendarFrame)

	local bg = B.CreateBG(CalendarFrame)
	bg:ClearAllPoints()
	bg:SetPoint("TOPLEFT", CalendarDayButton1, "TOPLEFT", -C.mult, 80)
	bg:SetPoint("BOTTOMRIGHT", CalendarDayButton42, "BOTTOMRIGHT", C.mult, -C.mult)

	B.ReskinClose(CalendarCloseButton, bg)
	B.ReskinArrow(CalendarPrevMonthButton, "left")
	B.ReskinArrow(CalendarNextMonthButton, "right")
	B.ReskinCheck(CalendarCreateEventLockEventCheck)

	B.StripTextures(CalendarFilterFrame)
	B.ReskinArrow(CalendarFilterButton, "down")

	B.StripTextures(CalendarClassTotalsButton)
	B.CreateBDFrame(CalendarClassTotalsButton, 0, -C.mult)

	CalendarEventPickerFrame:HookScript("OnShow", Update_FrameAnchor)

	CalendarViewEventFrame:ClearAllPoints()
	CalendarViewEventFrame:SetPoint("TOPLEFT", bg, "TOPRIGHT", 3, -25)
	CalendarViewHolidayFrame:ClearAllPoints()
	CalendarViewHolidayFrame:SetPoint("TOPLEFT", bg, "TOPRIGHT", 3, -25)
	CalendarViewRaidFrame:ClearAllPoints()
	CalendarViewRaidFrame:SetPoint("TOPLEFT", bg, "TOPRIGHT", 3, -25)
	CalendarCreateEventFrame:ClearAllPoints()
	CalendarCreateEventFrame:SetPoint("TOPLEFT", bg, "TOPRIGHT", 3, -25)
	CalendarClassButton1:ClearAllPoints()
	CalendarClassButton1:SetPoint("TOPLEFT", CalendarViewEventFrame, "TOPRIGHT", 2, -25)
	CalendarMassInviteFrame:ClearAllPoints()
	CalendarMassInviteFrame:SetPoint("TOPLEFT", CalendarClassButton1, "TOPRIGHT", 4, 0)
	CalendarTexturePickerFrame:ClearAllPoints()
	CalendarTexturePickerFrame:SetPoint("TOPLEFT", CalendarClassButton1, "TOPRIGHT", 4, 0)

	CalendarViewEventDivider:Hide()
	CalendarCreateEventDivider:Hide()

	CalendarCreateEventHourDropDown:SetWidth(80)
	CalendarCreateEventMinuteDropDown:SetWidth(80)
	CalendarCreateEventAMPMDropDown:SetWidth(90)
	CalendarCreateEventDifficultyOptionDropDown:SetWidth(150)

	local titles = {
		CalendarCreateEventTitleFrame,
		CalendarMassInviteTitleFrame,
		CalendarTexturePickerTitleFrame,
		CalendarViewEventTitleFrame,
		CalendarViewHolidayTitleFrame,
		CalendarViewRaidTitleFrame,
	}
	for _, title in pairs(titles) do
		B.StripTextures(title)

		local parent = title:GetParent()
		B.ReskinFrame(parent)
	end

	local frames = {
		CalendarCreateEventFrame,
		CalendarEventPickerFrame,
		CalendarMassInviteFrame,
		CalendarTexturePickerFrame,
		CalendarViewEventFrame,
		CalendarViewHolidayFrame,
		CalendarViewRaidFrame,
	}
	for _, frame in pairs(frames) do
		local bg = B.ReskinFrame(frame)

		local overlay = B.GetObject(frame, "ModalOverlay")
		if overlay then overlay:SetInside(bg) end
	end

	local containers = {
		CalendarCreateEventDescriptionContainer,
		CalendarCreateEventInviteList,
		CalendarViewEventDescriptionContainer,
		CalendarViewEventInviteList,
	}
	for _, container in pairs(containers) do
		B.StripTextures(container)
		B.CreateBDFrame(container)
	end

	local buttons = {
		CalendarCreateEventCreateButton,
		CalendarCreateEventInviteButton,
		CalendarCreateEventMassInviteButton,
		CalendarCreateEventRaidInviteButton,
		CalendarEventPickerCloseButton,
		CalendarMassInviteAcceptButton,
		CalendarTexturePickerAcceptButton,
		CalendarTexturePickerCancelButton,
		CalendarViewEventAcceptButton,
		CalendarViewEventDeclineButton,
		CalendarViewEventRemoveButton,
		CalendarViewEventTentativeButton,
	}
	for _, button in pairs(buttons) do
		B.StripTextures(button)
		B.ReskinButton(button)
	end

	local closes = {
		CalendarCreateEventCloseButton,
		CalendarMassInviteCloseButton,
		CalendarViewEventCloseButton,
		CalendarViewHolidayCloseButton,
		CalendarViewRaidCloseButton,
	}
	for _, close in pairs(closes) do
		B.ReskinClose(close)
	end

	local scrolls = {
		CalendarCreateEventDescriptionScrollFrameScrollBar,
		CalendarCreateEventInviteListScrollFrameScrollBar,
		CalendarEventPickerScrollBar,
		CalendarTexturePickerScrollBar,
		CalendarViewEventDescriptionScrollFrameScrollBar,
		CalendarViewEventInviteListScrollFrameScrollBar,
	}
	for _, scroll in pairs(scrolls) do
		B.ReskinScroll(scroll)
	end

	local dropdowns = {
		CalendarCreateEventAMPMDropDown,
		CalendarCreateEventCommunityDropDown,
		CalendarCreateEventDifficultyOptionDropDown,
		CalendarCreateEventHourDropDown,
		CalendarCreateEventMinuteDropDown,
		CalendarCreateEventTypeDropDown,
		CalendarMassInviteCommunityDropDown,
		CalendarMassInviteRankMenu,
	}
	for _, dropdown in pairs(dropdowns) do
		B.ReskinDropDown(dropdown)
	end

	local inputs = {
		CalendarCreateEventInviteEdit,
		CalendarCreateEventTitleEdit,
		CalendarMassInviteMaxLevelEdit,
		CalendarMassInviteMinLevelEdit,
	}
	for _, input in pairs(inputs) do
		B.ReskinInput(input)
	end

	for i, class in pairs(CLASS_SORT_ORDER) do
		local bu = _G["CalendarClassButton"..i]
		bu:GetRegions():Hide()

		local ic = bu:GetNormalTexture()
		ic:SetTexCoord(B.GetClassTexCoord(class))
		B.CreateBDFrame(ic, 0, -C.mult)
	end

	for i = 1, 42 do
		local buttons = "CalendarDayButton"..i

		local button = _G[buttons]
		B.StripTextures(button)
		B.ReskinHLTex(button, button, true)

		local dark = _G[buttons.."DarkFrame"]
		dark:SetAlpha(.5)

		local over = _G[buttons.."OverlayFrame"]
		over:SetInside()

		local eventTT = _G[buttons.."EventTexture"]
		eventTT:SetInside()

		local eventBG = _G[buttons.."EventBackgroundTexture"]
		eventBG:SetInside()

		local event = _G[buttons.."MoreEventsButton"]
		B.ReskinArrow(event, "down")

		local index = 1
		local eventButton = _G[buttons.."EventButton"..index]
		while eventButton do
			B.ReskinHLTex(eventButton)
			eventButton.black:SetTexture("")

			index = index + 1
			eventButton = _G[buttons.."EventButton"..index]
		end
	end

	for i = 1, 6 do
		local vDay = _G["CalendarDayButton"..i]
		local vLine = CalendarFrame:CreateTexture(nil, "OVERLAY")
		vLine:SetColorTexture(0, 0, 0)
		vLine:SetSize(C.mult, 546)
		vLine:ClearAllPoints()
		vLine:SetPoint("TOP", vDay, "TOPRIGHT")
	end

	for i = 1, 36, 7 do
		local hDay = _G["CalendarDayButton"..i]
		local hLine = CalendarFrame:CreateTexture(nil, "OVERLAY")
		hLine:SetColorTexture(0, 0, 0)
		hLine:SetSize(637, C.mult)
		hLine:ClearAllPoints()
		hLine:SetPoint("LEFT", hDay, "TOPLEFT")
	end

	hooksecurefunc("CalendarFrame_SetToday", Reskin_SetToday)
	hooksecurefunc("CalendarEventFrameBlocker_Update", Reskin_CalendarEventFrameBlocker)
end