local B, C, L, DB = unpack(select(2, ...))

tinsert(C.defaultThemes, function()
	-- Credit: ShestakUI
	local atlasColors = {
		["UI-Frame-Bar-Fill-Blue"] = {.2, .6, 1},
		["UI-Frame-Bar-Fill-Red"] = {.9, .2, .2},
		["UI-Frame-Bar-Fill-Yellow"] = {1, .6, 0},
		["objectivewidget-bar-fill-left"] = {.2, .6, 1},
		["objectivewidget-bar-fill-right"] = {.9, .2, .2}
	}

	local function updateBarTexture(self, atlas)
		if atlasColors[atlas] then
			self:SetStatusBarTexture(DB.normTex)
			self:SetStatusBarColor(unpack(atlasColors[atlas]))
		end
	end

	local doubleBarType = _G.Enum.UIWidgetVisualizationType.DoubleStatusBar
	local function reskinWidgetFrames()
		for _, widgetFrame in pairs(_G.UIWidgetTopCenterContainerFrame.widgetFrames) do
			if widgetFrame.widgetType == doubleBarType then
				for _, bar in pairs({widgetFrame.LeftBar, widgetFrame.RightBar}) do
					if not bar.styled then
						B.CleanTextures(bar)
						B.CreateBDFrame(bar, 0)
						hooksecurefunc(bar, "SetStatusBarAtlas", updateBarTexture)

						bar.styled = true
					end
				end
			end
		end
	end

	B:RegisterEvent("PLAYER_ENTERING_WORLD", reskinWidgetFrames)
	B:RegisterEvent("UPDATE_ALL_UI_WIDGETS", reskinWidgetFrames)

	hooksecurefunc(_G.UIWidgetTemplateCaptureBarMixin, "Setup", function(self)
		B.StripTextures(bar, 0)
		B.CleanTextures(bar)

		self.LeftBar:SetTexture(DB.normTex)
		self.NeutralBar:SetTexture(DB.normTex)
		self.RightBar:SetTexture(DB.normTex)

		self.LeftBar:SetVertexColor(.2, .6, 1)
		self.NeutralBar:SetVertexColor(.8, .8, .8)
		self.RightBar:SetVertexColor(.9, .2, .2)

		if not self.bg then
			self.bg = B.CreateBDFrame(self, 0)
			self.bg:Point("TOPLEFT", self.LeftBar, -2, 2)
			self.bg:Point("BOTTOMRIGHT", self.RightBar, 2, -2)
		end
	end)

	hooksecurefunc(_G.UIWidgetTemplateStatusBarMixin, "Setup", function(self)
		local bar = self.Bar
		local atlas = bar:GetStatusBarAtlas()
		updateBarTexture(bar, atlas)

		if not bar.styled then
			B.CleanTextures(bar)
			B.CreateBDFrame(bar, 0)

			bar.styled = true
		end
	end)

	hooksecurefunc(_G.UIWidgetTemplateScenarioHeaderCurrenciesAndBackgroundMixin, "Setup", function(self)
		self.Frame:SetAlpha(0)
	end)

	hooksecurefunc(_G.UIWidgetTemplateSpellDisplayMixin, "Setup", function(self)
		local spellFrame = self.Spell

		if spellFrame and not spellFrame.styled then
			local icbg = B.ReskinIcon(spellFrame.Icon)
			B.ReskinBorder(spellFrame.DebuffBorder, icbg)

			spellFrame.styled = true
		end
	end)

	hooksecurefunc(_G.UIWidgetTemplateDoubleStatusBarMixin, "Setup", function(self)
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
	end)
end)