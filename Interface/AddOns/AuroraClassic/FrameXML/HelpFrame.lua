local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	F.ReskinFrame(HelpFrame)
	F.ReskinFrame(TicketStatusFrame)

	F.ReskinArrow(HelpBrowserNavBack, "left")
	F.ReskinArrow(HelpBrowserNavForward, "right")
	F.ReskinIcon(HelpFrameCharacterStuckHearthstoneIconTexture)
	F.CreateBDFrame(HelpBrowser, 0, true)

	F.ReskinFrame(BrowserSettingsTooltip)
	F.ReskinButton(BrowserSettingsTooltip.CacheButton)
	F.ReskinButton(BrowserSettingsTooltip.CookiesButton)

	F.ReskinFrame(ReportCheatingDialog)
	F.ReskinButton(ReportCheatingDialogReportButton)
	F.ReskinButton(ReportCheatingDialogCancelButton)

	HelpFrameHeader:ClearAllPoints()
	HelpFrameHeader:SetPoint("TOP", HelpFrame, "TOP", 0, 5)
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
		HelpFrameHeader,
		HelpFrameMainInset,
		HelpBrowser.BrowserInset,
	}
	for _, list in pairs(lists) do
		F.StripTextures(list)
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
		F.ReskinScroll(scroll)

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
		F.ReskinButton(button)
	end

	local navbtns = {
		HelpBrowserBrowserSettings,
		HelpBrowserNavHome,
		HelpBrowserNavReload,
		HelpBrowserNavStop,
	}
	for _, navbtn in pairs(navbtns) do
		navbtn:SetSize(18, 18)
		F.ReskinButton(navbtn)
	end

	local frames = {
		HelpFrameGM_ResponseScrollFrame1,
		HelpFrameGM_ResponseScrollFrame2,
		HelpFrameReportBugScrollFrame,
		HelpFrameSubmitSuggestionScrollFrame,
		ReportCheatingDialogCommentFrame,
	}
	for _, frame in pairs(frames) do
		F.StripTextures(frame)
		F.CreateBDFrame(frame, 0)
	end

	local function reskinButton(bu)
		F.ReskinButton(bu)
		F.ReskinTexture(bu.selected, bu, true)
	end

	for i = 1, 6 do
		reskinButton(_G["HelpFrameButton"..i])
	end
	reskinButton(HelpFrameButton16)
end)