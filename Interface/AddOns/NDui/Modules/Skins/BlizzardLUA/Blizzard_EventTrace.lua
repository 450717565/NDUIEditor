local _, ns = ...
local B, C, L, DB = unpack(ns)

local function Reskin_EventTraceButton(self)
	B.ReskinButton(self)
	self.NormalTexture:SetAlpha(0)
	self.MouseoverOverlay:SetAlpha(0)
end

local function Reskin_EventTraceScroll(self)
	B.StripTextures(self)
	B.ReskinArrow(self.Back, "up")
	B.ReskinArrow(self.Forward, "down")

	local Thumb = self.Track.Thumb
	B.StripTextures(Thumb, 0)
	B.CreateBDFrame(Thumb)
end

C.LUAThemes["Blizzard_EventTrace"] = function()
	B.ReskinFrame(EventTrace)

	local logBar = EventTrace.Log.Bar
	local filterBar = EventTrace.Filter.Bar
	local subtitleBar = EventTrace.SubtitleBar

	B.ReskinEditBox(logBar.SearchBox)
	B.ReskinFilter(subtitleBar.OptionsDropDown)

	Reskin_EventTraceScroll(EventTrace.Log.Events.ScrollBar)
	Reskin_EventTraceScroll(EventTrace.Filter.ScrollBar)

	local buttons = {
		subtitleBar.ViewLog,
		subtitleBar.ViewFilter,
		logBar.DiscardAllButton,
		logBar.PlaybackButton,
		logBar.MarkButton,
		filterBar.DiscardAllButton,
		filterBar.UncheckAllButton,
		filterBar.CheckAllButton,
	}
	for _, button in pairs(buttons) do
		Reskin_EventTraceButton(button)
	end
end