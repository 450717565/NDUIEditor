local _, ns = ...
local B, C, L, DB = unpack(ns)

tinsert(C.XMLThemes, function()
	B.ReskinFrame(HelpFrame)
	B.StripTextures(HelpBrowser.BrowserInset)

	B.ReskinFrame(BrowserSettingsTooltip)
	B.ReskinButton(BrowserSettingsTooltip.CookiesButton)

	B.ReskinFrame(ReportCheatingDialog)
	B.ReskinButton(ReportCheatingDialogReportButton)
	B.ReskinButton(ReportCheatingDialogCancelButton)

	B.StripTextures(TicketStatusFrameButton)
	B.CreateBDFrame(TicketStatusFrameButton)

	B.StripTextures(ReportCheatingDialogCommentFrame)
	B.CreateBDFrame(ReportCheatingDialogCommentFrame)
end)