local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	F.ReskinFrame(HelpFrame)
	F.StripTextures(HelpFrameMainInset)
	F.StripTextures(HelpBrowser.BrowserInset)

	HelpFrameHeader:Hide()

	local frames = {HelpFrameGM_ResponseScrollFrame1, HelpFrameGM_ResponseScrollFrame2, HelpFrameReportBugScrollFrame, HelpFrameSubmitSuggestionScrollFrame, ReportCheatingDialogCommentFrame}
	for _, frame in next, frames do
		F.StripTextures(frame)
		F.CreateBDFrame(frame, .25)
	end

	local scrolls = {
		HelpFrameKnowledgebaseScrollFrameScrollBar,
		HelpFrameReportBugScrollFrameScrollBar,
		HelpFrameSubmitSuggestionScrollFrameScrollBar,
		HelpFrameGM_ResponseScrollFrame1ScrollBar,
		HelpFrameGM_ResponseScrollFrame2ScrollBar,
		HelpFrameKnowledgebaseScrollFrame2ScrollBar
	}
	for _, scroll in next, scrolls do
		F.ReskinScroll(scroll)
	end

	local buttons = {
		HelpFrameAccountSecurityOpenTicket,
		HelpFrameCharacterStuckStuck,
		HelpFrameOpenTicketHelpOpenTicket,
		HelpFrameKnowledgebaseSearchButton,
		HelpFrameGM_ResponseNeedMoreHelp,
		HelpFrameGM_ResponseCancel,
		HelpFrameReportBugSubmit,
		HelpFrameSubmitSuggestionSubmit
	}
	for _, button in next, buttons do
		F.ReskinButton(button)
	end

	F.StripTextures(HelpFrameKnowledgebase)
	F.ReskinInput(HelpFrameKnowledgebaseSearchBox)

	select(3, HelpFrameReportBug:GetChildren()):Hide()
	select(3, HelpFrameSubmitSuggestion:GetChildren()):Hide()
	select(5, HelpFrameGM_Response:GetChildren()):Hide()
	select(6, HelpFrameGM_Response:GetChildren()):Hide()

	HelpFrameReportBugScrollFrameScrollBar:SetPoint("TOPLEFT", HelpFrameReportBugScrollFrame, "TOPRIGHT", 3, -16)
	HelpFrameSubmitSuggestionScrollFrameScrollBar:SetPoint("TOPLEFT", HelpFrameSubmitSuggestionScrollFrame, "TOPRIGHT", 3, -16)
	HelpFrameGM_ResponseScrollFrame1ScrollBar:SetPoint("TOPLEFT", HelpFrameGM_ResponseScrollFrame1, "TOPRIGHT", 3, -16)
	HelpFrameGM_ResponseScrollFrame2ScrollBar:SetPoint("TOPLEFT", HelpFrameGM_ResponseScrollFrame2, "TOPRIGHT", 3, -16)

	for i = 1, 15 do
		local bu = _G["HelpFrameKnowledgebaseScrollFrameButton"..i]
		bu:DisableDrawLayer("ARTWORK")
		F.CreateBDFrame(bu, .25)
	end

	local function styleTab(bu)
		F.ReskinTexture(bu.selected, bu, true)
		F.ReskinButton(bu)
	end

	for i = 1, 6 do
		styleTab(_G["HelpFrameButton"..i])
	end
	styleTab(HelpFrameButton16)

	HelpFrameCharacterStuckHearthstone:SetSize(56, 56)
	F.CreateBDFrame(HelpFrameCharacterStuckHearthstone)
	HelpFrameCharacterStuckHearthstoneIconTexture:SetTexCoord(.08, .92, .08, .92)

	local btns = {
		HelpBrowserNavHome,
		HelpBrowserNavReload,
		HelpBrowserNavStop,
		HelpBrowserBrowserSettings,
	}
	for _, btn in next, btns do
		btn:SetSize(18, 18)
		F.ReskinButton(btn)
	end

	F.ReskinArrow(HelpBrowserNavBack, "left")
	F.ReskinArrow(HelpBrowserNavForward, "right")

	HelpBrowserNavHome:SetPoint("BOTTOMLEFT", HelpBrowser, "TOPLEFT", 2, 4)
	HelpBrowserBrowserSettings:SetPoint("TOPRIGHT", HelpFrameCloseButton, "BOTTOMLEFT", -4, -1)
	LoadingIcon:ClearAllPoints()
	LoadingIcon:SetPoint("LEFT", HelpBrowserNavStop, "RIGHT")

	F.ReskinFrame(BrowserSettingsTooltip)
	F.ReskinButton(BrowserSettingsTooltip.CacheButton)
	F.ReskinButton(BrowserSettingsTooltip.CookiesButton)
	F.ReskinButton(ReportCheatingDialogReportButton)
	F.ReskinButton(ReportCheatingDialogCancelButton)

	F.ReskinFrame(TicketStatusFrameButton)
	F.ReskinFrame(ReportCheatingDialog)
end)