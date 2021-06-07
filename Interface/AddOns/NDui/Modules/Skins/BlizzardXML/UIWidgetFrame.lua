local _, ns = ...
local B, C, L, DB = unpack(ns)

local Type_StatusBar = _G.Enum.UIWidgetVisualizationType.StatusBar
local Type_CaptureBar = _G.Enum.UIWidgetVisualizationType.CaptureBar
local Type_SpellDisplay = _G.Enum.UIWidgetVisualizationType.SpellDisplay
local Type_DoubleStatusBar = _G.Enum.UIWidgetVisualizationType.DoubleStatusBar

local function Reskin_StatusBar(self)
	if self and not self.styled then
		B.ReskinStatusBar(self, true)

		self.styled = true
	end
end

local function Reskin_DoubleStatusBar(self)
	local LeftBar = self.LeftBar
	Reskin_StatusBar(LeftBar)
	LeftBar.Icon:ClearAllPoints()
	LeftBar.Icon:SetPoint("RIGHT", LeftBar, "LEFT", 0, 0)
	LeftBar.IconGlow:ClearAllPoints()
	LeftBar.IconGlow:SetPoint("RIGHT", LeftBar, "LEFT", 0, 0)

	local RightBar = self.RightBar
	Reskin_StatusBar(RightBar)
	RightBar.Icon:ClearAllPoints()
	RightBar.Icon:SetPoint("LEFT", RightBar, "RIGHT", 0, 0)
	RightBar.IconGlow:ClearAllPoints()
	RightBar.IconGlow:SetPoint("LEFT", RightBar, "RIGHT", 0, 0)
end

local function Reskin_CaptureBar(self)
	B.StripTextures(self, 0)
	B.CleanTextures(self)

	self.LeftBar:SetTexture(DB.normTex)
	self.NeutralBar:SetTexture(DB.normTex)
	self.RightBar:SetTexture(DB.normTex)

	self.LeftBar:SetVertexColor(.2, .6, 1)
	self.NeutralBar:SetVertexColor(.8, .8, .8)
	self.RightBar:SetVertexColor(.9, .2, .2)

	if not self.styled then
		local bg = B.CreateBDFrame(self)
		bg:SetOutside(self.LeftBar, 2, 2, self.RightBar)

		self.styled = true
	end
end

local function Reskin_SpellDisplay(self)
	local spell = self.Spell
	B.StripTextures(spell, 1)

	if not self.styled then
		local icbg = B.ReskinIcon(spell.Icon)
		B.ReskinSpecialBorder(spell.DebuffBorder, icbg)

		self.styled = true
	end
end

local function Reskin_UIWidgetLayout(self)
	for _, widgetFrame in pairs(self.widgetFrames) do
		local widgetType = widgetFrame.widgetType
		if widgetType == Type_DoubleStatusBar then
			Reskin_DoubleStatusBar(widgetFrame)
		elseif widgetType == Type_SpellDisplay then
			Reskin_SpellDisplay(widgetFrame)
		elseif widgetType == Type_CaptureBar then
			Reskin_CaptureBar(widgetFrame)
		elseif widgetType == Type_StatusBar then
			Reskin_StatusBar(widgetFrame.Bar)
		end
	end
end

local ignoredWidgetIDs = {
	[3246] = true, -- Torghast progressbar
	[3273] = true, -- Torghast progressbar
}
local function Reskin_UIWidgetStatusBar(self)
	if ignoredWidgetIDs[self.widgetID] then return end
	Reskin_StatusBar(self.Bar)
end

tinsert(C.XMLThemes, function()
	hooksecurefunc(_G.UIWidgetTemplateSpellDisplayMixin, "Setup", Reskin_SpellDisplay)
	hooksecurefunc(_G.UIWidgetTemplateStatusBarMixin, "Setup", Reskin_UIWidgetStatusBar)
	hooksecurefunc(_G.UIWidgetPowerBarContainerFrame, "UpdateWidgetLayout", Reskin_UIWidgetLayout)
	hooksecurefunc(_G.UIWidgetTopCenterContainerFrame, "UpdateWidgetLayout", Reskin_UIWidgetLayout)
	hooksecurefunc(_G.UIWidgetBelowMinimapContainerFrame, "UpdateWidgetLayout", Reskin_UIWidgetLayout)
end)