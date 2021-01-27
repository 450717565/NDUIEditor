local _, ns = ...
local B, C, L, DB = unpack(ns)

local atlasColors = {
	["UI-Frame-Bar-Fill-Blue"] = {.2, .6, 1},
	["UI-Frame-Bar-Fill-Red"] = {.9, .2, .2},
	["UI-Frame-Bar-Fill-Yellow"] = {1, .6, 0},
	["objectivewidget-bar-fill-left"] = {.2, .6, 1},
	["objectivewidget-bar-fill-right"] = {.9, .2, .2}
}

local function Update_BarTexture(self, atlas)
	if atlasColors[atlas] then
		self:SetStatusBarTexture(DB.normTex)
		self:SetStatusBarColor(unpack(atlasColors[atlas]))
	end
end

local Type_DoubleStatusBar = _G.Enum.UIWidgetVisualizationType.DoubleStatusBar
local Type_SpellDisplay = _G.Enum.UIWidgetVisualizationType.SpellDisplay

local function Reskin_WidgetFrames()
	for _, widgetFrame in pairs(_G.UIWidgetTopCenterContainerFrame.widgetFrames) do
		if widgetFrame.widgetType == Type_DoubleStatusBar then
			if not widgetFrame.styled then
				for _, bar in pairs({widgetFrame.LeftBar, widgetFrame.RightBar}) do
					B.CleanTextures(bar)
					B.CreateBDFrame(bar, 0, -C.mult)

					hooksecurefunc(bar, "SetStatusBarAtlas", Update_BarTexture)
				end

				widgetFrame.styled = true
			end
		elseif widgetFrame.widgetType == Type_SpellDisplay then
			if not widgetFrame.styled then
				local widgetSpell = widgetFrame.Spell
				widgetSpell.IconMask:Hide()
				widgetSpell.Border:SetTexture("")

				local icbg = B.ReskinIcon(widgetSpell.Icon)
				B.ReskinSpecialBorder(widgetSpell.DebuffBorder, icbg)

				widgetFrame.styled = true
			end
		end
	end
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
		bg:SetPoint("TOPLEFT", self.LeftBar, -2, 2)
		bg:SetPoint("BOTTOMRIGHT", self.RightBar, 2, -2)

		self.styled = true
	end
end

local function Reskin_StatusBar(self)
	local bar = self.Bar
	local atlas = bar:GetStatusBarAtlas()
	Update_BarTexture(bar, atlas)

	if not bar.styled then
		B.CleanTextures(bar)
		B.CreateBDFrame(bar, 0, -C.mult)

		bar.styled = true
	end
end

local function Reskin_DoubleStatusBar(self)
	local LeftBar = self.LeftBar
	LeftBar.Icon:ClearAllPoints()
	LeftBar.Icon:SetPoint("RIGHT", LeftBar, "LEFT", 0, 0)
	LeftBar.IconGlow:ClearAllPoints()
	LeftBar.IconGlow:SetPoint("RIGHT", LeftBar, "LEFT", 0, 0)

	local RightBar = self.RightBar
	RightBar.Icon:ClearAllPoints()
	RightBar.Icon:SetPoint("LEFT", RightBar, "RIGHT", 0, 0)
	RightBar.IconGlow:ClearAllPoints()
	RightBar.IconGlow:SetPoint("LEFT", RightBar, "RIGHT", 0, 0)
end

local function Reskin_BaseSpell(self)
	B.StripTextures(self, 1)

	if not self.styled then
		B.ReskinIcon(self.Icon)

		self.styled = true
	end
end

tinsert(C.XMLThemes, function()
	B:RegisterEvent("PLAYER_ENTERING_WORLD", Reskin_WidgetFrames)
	B:RegisterEvent("UPDATE_ALL_UI_WIDGETS", Reskin_WidgetFrames)

	--hooksecurefunc(_G.UIWidgetBaseSpellTemplateMixin, "Setup", Reskin_BaseSpell)
	--hooksecurefunc(_G.UIWidgetTemplateStatusBarMixin, "Setup", Reskin_StatusBar)
	hooksecurefunc(_G.UIWidgetTemplateCaptureBarMixin, "Setup", Reskin_CaptureBar)
	hooksecurefunc(_G.UIWidgetTemplateDoubleStatusBarMixin, "Setup", Reskin_DoubleStatusBar)
end)