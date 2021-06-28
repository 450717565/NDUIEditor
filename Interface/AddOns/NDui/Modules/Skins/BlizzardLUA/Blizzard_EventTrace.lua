local _, ns = ...
local B, C, L, DB = unpack(ns)

local function Reskin_EventTraceButton(self)
	B.ReskinButton(self)
	self.NormalTexture:SetAlpha(0)
	self.MouseoverOverlay:SetAlpha(0)
end

local function Reskin_EventTraceScrollBar(self)
	B.StripTextures(self)
	B.ReskinArrow(self.Back, "up")
	B.ReskinArrow(self.Forward, "down")

	local Thumb = self:GetThumb()
	B.StripTextures(Thumb, 0)
	B.CreateBDFrame(Thumb)
end

local function Reskin_ScrollChild(self)
	local children = {self.ScrollTarget:GetChildren()}
	for _, child in pairs(children) do
		local HideButton = child and child.HideButton
		if HideButton and not HideButton.styled then
			B.ReskinClose(HideButton)
			HideButton:ClearAllPoints()
			HideButton:SetPoint("LEFT", 3, 0)

			local CheckButton = child.CheckButton
			if CheckButton then
				B.ReskinCheck(CheckButton)
				CheckButton:SetSize(22, 22)
			end

			HideButton.styled = true
		end
	end
end

local function Reskin_EventTraceScrollBox(self)
	self:DisableDrawLayer("BACKGROUND")
	B.CreateBDFrame(self)
	hooksecurefunc(self, "Update", Reskin_ScrollChild)
end

local function Reskin_EventTraceFrame(self)
	Reskin_EventTraceScrollBox(self.ScrollBox)
	Reskin_EventTraceScrollBar(self.ScrollBar)
end

C.OnLoadThemes["Blizzard_EventTrace"] = function()
	B.ReskinFrame(EventTrace)

	local logBar = EventTrace.Log.Bar
	local filterBar = EventTrace.Filter.Bar
	local subtitleBar = EventTrace.SubtitleBar

	B.ReskinEditBox(logBar.SearchBox)
	B.ReskinFilter(subtitleBar.OptionsDropDown)

	Reskin_EventTraceFrame(EventTrace.Log.Events)
	Reskin_EventTraceFrame(EventTrace.Log.Search)
	Reskin_EventTraceFrame(EventTrace.Filter)

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