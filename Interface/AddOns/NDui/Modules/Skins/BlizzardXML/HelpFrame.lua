local _, ns = ...
local B, C, L, DB = unpack(ns)

C.OnLoginThemes["HelpFrame"] = function()
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
end

local function Reskin_HelpTips(self)
	for frame in self.framePool:EnumerateActive() do
		if frame and not frame.styled then
			if frame.OkayButton then B.ReskinButton(frame.OkayButton) end
			if frame.CloseButton then B.ReskinClose(frame.CloseButton) end

			frame.styled = true
		end
	end
end

C.OnLoginThemes["HelpTip"] = function()
	Reskin_HelpTips(HelpTip)
	hooksecurefunc(HelpTip, "Show", Reskin_HelpTips)
end