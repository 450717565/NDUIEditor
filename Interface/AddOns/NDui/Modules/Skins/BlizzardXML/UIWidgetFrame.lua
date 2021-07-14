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
	B.UpdatePoint(LeftBar.Icon, "RIGHT", LeftBar, "LEFT", 0, 0)
	B.UpdatePoint(LeftBar.IconGlow, "RIGHT", LeftBar, "LEFT", 0, 0)

	local RightBar = self.RightBar
	Reskin_StatusBar(RightBar)
	B.UpdatePoint(RightBar.Icon, "LEFT", RightBar, "RIGHT", 0, 0)
	B.UpdatePoint(RightBar.IconGlow, "LEFT", RightBar, "RIGHT", 0, 0)
end

local function Reskin_CaptureBar(self)
	B.StripTextures(self, 0)

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
	self.IconMask:Hide()
	self.CircleMask:Hide()
	B.StripTextures(self, 1)

	if not self.icbg then
		self.icbg = B.ReskinIcon(self.Icon)
	end

	if self.DebuffBorder:IsShown() then
		self.icbg:SetBackdropBorderColor(1, 0, 0)
	else
		self.icbg:SetBackdropBorderColor(0, 0, 0)
	end
end

local function Reskin_UIWidgetLayout(self)
	for _, widgetFrame in pairs(self.widgetFrames) do
		local widgetType = widgetFrame.widgetType
		if widgetType == Type_DoubleStatusBar then
			Reskin_DoubleStatusBar(widgetFrame)
		elseif widgetType == Type_SpellDisplay then
			Reskin_SpellDisplay(widgetFrame.Spell)
		elseif widgetType == Type_CaptureBar then
			Reskin_CaptureBar(widgetFrame)
		elseif widgetType == Type_StatusBar then
			Reskin_StatusBar(widgetFrame.Bar)
		end
	end
end

local function Reskin_UIWidgetStatusBar(self)
	Reskin_StatusBar(self.Bar)
end

C.OnLoginThemes["UIWidgetTemplate"] = function()
	hooksecurefunc(_G.UIWidgetTemplateStatusBarMixin, "Setup", Reskin_UIWidgetStatusBar)
	hooksecurefunc(_G.UIWidgetPowerBarContainerFrame, "UpdateWidgetLayout", Reskin_UIWidgetLayout)
	hooksecurefunc(_G.UIWidgetTopCenterContainerFrame, "UpdateWidgetLayout", Reskin_UIWidgetLayout)
	hooksecurefunc(_G.UIWidgetBelowMinimapContainerFrame, "UpdateWidgetLayout", Reskin_UIWidgetLayout)
	hooksecurefunc(_G.TopScenarioWidgetContainerBlock.WidgetContainer, "UpdateWidgetLayout", Reskin_UIWidgetLayout)
	hooksecurefunc(_G.BottomScenarioWidgetContainerBlock.WidgetContainer, "UpdateWidgetLayout", Reskin_UIWidgetLayout)
end