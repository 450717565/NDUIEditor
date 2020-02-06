local B, C, L, DB = unpack(select(2, ...))

tinsert(C.defaultThemes, function()
	B.ReskinFrame(HelpFrame)
	B.ReskinFrame(TicketStatusFrame)

	B.ReskinArrow(HelpBrowserNavBack, "left")
	B.ReskinArrow(HelpBrowserNavForward, "right")
	B.ReskinIcon(HelpFrameCharacterStuckHearthstoneIconTexture)
	B.CreateBDFrame(HelpBrowser, 0)

	B.ReskinFrame(BrowserSettingsTooltip)
	B.ReskinButton(BrowserSettingsTooltip.CookiesButton)

	B.ReskinFrame(ReportCheatingDialog)
	B.ReskinButton(ReportCheatingDialogReportButton)
	B.ReskinButton(ReportCheatingDialogCancelButton)

	HelpFrameButton6:ClearAllPoints()
	HelpFrameButton6:SetPoint("TOP", HelpFrameButton16, "BOTTOM", 0, -12)
	HelpBrowserNavHome:ClearAllPoints()
	HelpBrowserNavHome:SetPoint("BOTTOMLEFT", HelpBrowser, "TOPLEFT", -1, 5)
	HelpBrowserBrowserSettings:ClearAllPoints()
	HelpBrowserBrowserSettings:SetPoint("RIGHT", HelpFrameCloseButton, "LEFT", -5, 0)

	select(3, HelpFrameReportBug:GetChildren()):Hide()
	select(3, HelpFrameSubmitSuggestion:GetChildren()):Hide()
	select(5, HelpFrameGM_Response:GetChildren()):Hide()
	select(6, HelpFrameGM_Response:GetChildren()):Hide()

	local lists = {
		HelpFrameMainInset,
		HelpBrowser.BrowserInset,
	}
	for _, list in pairs(lists) do
		B.StripTextures(list)
	end

	local scrolls = {
		HelpFrameGM_ResponseScrollFrame1ScrollBar,
		HelpFrameGM_ResponseScrollFrame2ScrollBar,
		HelpFrameKnowledgebaseScrollFrame2ScrollBar,
		HelpFrameKnowledgebaseScrollFrameScrollBar,
		HelpFrameReportBugScrollFrameScrollBar,
		HelpFrameSubmitSuggestionScrollFrameScrollBar,
	}
	for _, scroll in pairs(scrolls) do
		B.ReskinScroll(scroll)

		local parent = scroll:GetParent()
		scroll:SetPoint("TOPLEFT", parent, "TOPRIGHT", 3, -16)
	end

	local buttons = {
		HelpFrameAccountSecurityOpenTicket,
		HelpFrameCharacterStuckStuck,
		HelpFrameGM_ResponseCancel,
		HelpFrameGM_ResponseNeedMoreHelp,
		HelpFrameKnowledgebaseSearchButton,
		HelpFrameOpenTicketHelpOpenTicket,
		HelpFrameReportBugSubmit,
		HelpFrameSubmitSuggestionSubmit,
	}
	for _, button in pairs(buttons) do
		B.ReskinButton(button)
	end

	local navbtns = {
		HelpBrowserBrowserSettings,
		HelpBrowserNavHome,
		HelpBrowserNavReload,
		HelpBrowserNavStop,
	}
	for _, navbtn in pairs(navbtns) do
		navbtn:SetSize(18, 18)
		B.ReskinButton(navbtn)
	end

	local frames = {
		HelpFrameGM_ResponseScrollFrame1,
		HelpFrameGM_ResponseScrollFrame2,
		HelpFrameReportBugScrollFrame,
		HelpFrameSubmitSuggestionScrollFrame,
		ReportCheatingDialogCommentFrame,
	}
	for _, frame in pairs(frames) do
		B.StripTextures(frame)
		B.CreateBDFrame(frame, 0)
	end

	local function reskinButton(bu)
		B.ReskinButton(bu)
		B.ReskinTexture(bu.selected, bu, true)
	end

	for i = 1, 6 do
		reskinButton(_G["HelpFrameButton"..i])
	end
	reskinButton(HelpFrameButton16)
end)