local B, C, L, DB = unpack(select(2, ...))
local S = B:GetModule("Skins")
local TT = B:GetModule("Tooltip")

function S:Rematch()
	if not NDuiDB["Skins"]["BlizzardSkins"] then return end
	if not IsAddOnLoaded("Rematch") then return end

	local cr, cg, cb = DB.r, DB.g, DB.b

	if RematchSettings then
		RematchSettings.ColorPetNames = true
		RematchSettings.FixedPetCard = true
	end
	RematchLoreFont:SetTextColor(1, 1, 1)

	local function reskinFrame(self)
		B.StripTextures(self)

		local bg = B.CreateBDFrame(self, 0)
		bg:SetPoint("TOPLEFT", 0, -1)
		bg:SetPoint("BOTTOMRIGHT", 0, 1)
	end

	local function reskinFilter(self)
		self.Icon = self.Arrow

		B.ReskinFilter(self)
	end

	local function reskinButton(self)
		if self.styled then return end

		B.CleanTextures(self)

		if self.IconBorder then self.IconBorder:Hide() end
		if self.Background then self.Background:Hide() end

		if self.Icon then
			self.Icon.bg = B.ReskinIcon(self.Icon)

			local Highlight = self.GetHighlightTexture and self:GetHighlightTexture() or select(3, self:GetRegions())
			if Highlight then
				Highlight:SetColorTexture(1, 1, 1, .25)
				Highlight:SetAllPoints(self.Icon)
			end
		end
		if self.Level then
			if self.Level.BG then self.Level.BG:Hide() end
			if self.Level.Text then self.Level.Text:SetTextColor(1, 1, 1) end
		end
		if self.GetCheckedTexture then
			B.ReskinTexed(self, self)
		end

		self.styled = true
	end

	local function reskinInput(self)
		self:DisableDrawLayer("BACKGROUND")
		self:SetBackdrop(nil)

		local bg = B.CreateBDFrame(self, 0)
		bg:SetPoint("TOPLEFT", 2, 0)
		bg:SetPoint("BOTTOMRIGHT", -2, 0)
	end

	local function reskinScroll(self)
		self.Background:Hide()

		local ScrollBar = self.ScrollFrame.ScrollBar
		ScrollBar.thumbTexture = ScrollBar.ScrollThumb
		B.ReskinScroll(ScrollBar)

		local UpButton = ScrollBar.UpButton
		UpButton:ClearAllPoints()
		UpButton:SetPoint("BOTTOM", ScrollBar, "TOP", 0, -2)

		local DownButton = ScrollBar.DownButton
		DownButton:ClearAllPoints()
		DownButton:SetPoint("TOP", ScrollBar, "BOTTOM", 0, 2)

		local TopButton = ScrollBar.TopButton
		if TopButton then
			TopButton:SetWidth(18)
			TopButton:ClearAllPoints()
			TopButton:SetPoint("BOTTOM", UpButton, "TOP", 0, 2)

			B.ReskinArrow(TopButton, "top")
		end

		local BottomButton = ScrollBar.BottomButton
		if BottomButton then
			BottomButton:SetWidth(18)
			BottomButton:ClearAllPoints()
			BottomButton:SetPoint("TOP", DownButton, "BOTTOM", 0, -2)

			B.ReskinArrow(BottomButton, "bottom")
		end
	end

	local function reskinDropdown(self)
		self:SetBackdrop(nil)

		B.StripTextures(self)
		B.CreateBDFrame(self, 0)

		if self.Icon then
			self.Icon:SetAlpha(1)
			self.Icon.bg = B.ReskinIcon(self.Icon)
		end

		local arrow = self:GetChildren()
		B.ReskinArrow(arrow, "down")
	end

	local function reskinPetCard(self)
		self:SetBackdrop(nil)

		if self.Source then
			reskinFrame(self.Source)
		end

		if self.Middle.XP then
			B.ReskinStatusBar(self.Middle.XP, true)
		end

		reskinFrame(self.Middle)
		reskinFrame(self.Bottom)
	end

	local function reskinInset(self)
		B.StripTextures(self)

		local bg = B.CreateBDFrame(self, 0)
		bg:SetPoint("TOPLEFT", 3, 0)
		bg:SetPoint("BOTTOMRIGHT", -3, 0)
	end

	local function buttonOnEnter(self)
		self.bg:SetBackdropColor(cr, cg, cb, .25)
	end
	local function buttonOnLeave(self)
		self.bg:SetBackdropColor(0, 0, 0, 0)
	end

	local function reskinPetList(self)
		local buttons = self.ScrollFrame.Buttons
		if not buttons then return end

		for i = 1, #buttons do
			local button = buttons[i]
			if not button.styled then
				local parent
				if button.Pet then
					B.CreateBDFrame(button.Pet, 0)
					if button.Rarity then button.Rarity:SetTexture(nil) end
					if button.LevelBack then button.LevelBack:SetTexture(nil) end
					button.LevelText:SetTextColor(1, 1, 1)

					parent = button.Pet
				end

				if button.Pets then
					for j = 1, 3 do
						local bu = button.Pets[j]
						bu:SetWidth(25)
						B.CreateBDFrame(bu, 0)
					end
					if button.Border then button.Border:SetTexture(nil) end

					parent = button.Pets[3]
				end

				if button.Back then
					button.Back:SetTexture(nil)
					local bg = B.CreateBDFrame(button.Back, 0)
					bg:SetPoint("TOPLEFT", parent, "TOPRIGHT", 4, C.mult)
					bg:SetPoint("BOTTOMRIGHT", 0, C.mult)
					button.bg = bg

					button:HookScript("OnEnter", buttonOnEnter)
					button:HookScript("OnLeave", buttonOnLeave)
				end

				button.styled = true
			end
		end
	end

	function reskinSelectedOverlay(self)
		B.StripTextures(self.SelectedOverlay)
		local bg = B.CreateBDFrame(self.SelectedOverlay, 0)
		bg:SetBackdropColor(cr, cg, cb, .5)
		self.SelectedOverlay.bg = bg
	end

	function reskinTabs(self)
		for _, tab in ipairs(self.PanelTabs.Tabs) do
			B.ReskinTab(tab)
		end
	end

	local function resizeJournal()
		local parent = RematchJournal:IsShown() and RematchJournal or CollectionsJournal
		CollectionsJournal.bg:SetPoint("BOTTOMRIGHT", parent, C.mult, -C.mult)
	end

	local styled
	hooksecurefunc(RematchJournal, "ConfigureJournal", function()
		resizeJournal()

		if styled then return end

		-- Main Elements
		hooksecurefunc("CollectionsJournal_UpdateSelectedTab", resizeJournal)
		TT.ReskinTooltip(RematchTooltip)
		TT.ReskinTooltip(RematchTableTooltip)

		for i = 1, 3 do
			local menu = Rematch:GetMenuFrame(i, UIParent)
			B.ReskinFrame(menu)

			B.StripTextures(menu.Title)
			local bg = B.CreateBDFrame(menu.Title, 0)
			bg:SetBackdropColor(1, .8, 0, .25)
		end

		B.StripTextures(RematchJournal)
		B.ReskinClose(RematchJournal.CloseButton)
		reskinTabs(RematchJournal)

		local buttons = {
			RematchBandageButton,
			RematchHealButton,
			RematchLesserPetTreatButton,
			RematchPetTreatButton,
			RematchToolbar.FindBattle,
			RematchToolbar.SafariHat,
			RematchToolbar.SummonRandom,
		}
		for _, button in pairs(buttons) do
			reskinButton(button)
		end

		B.StripTextures(RematchToolbar.PetCount)

		if ALPTRematchOptionButton then
			ALPTRematchOptionButton:SetPushedTexture(nil)

			local icon = ALPTRematchOptionButton:GetNormalTexture()
			local icbg = B.ReskinIcon(icon)
			B.ReskinTexture(ALPTRematchOptionButton, icbg)
		end

		-- RematchBottomPanel
		B.ReskinCheck(UseRematchButton)
		B.ReskinCheck(RematchBottomPanel.UseDefault)
		B.ReskinButton(RematchBottomPanel.SummonButton)
		B.ReskinButton(RematchBottomPanel.SaveButton)
		B.ReskinButton(RematchBottomPanel.SaveAsButton)
		B.ReskinButton(RematchBottomPanel.FindBattleButton)

		-- RematchPetPanel
		B.StripTextures(RematchPetPanel.Top)
		B.ReskinButton(RematchPetPanel.Top.Toggle)
		reskinSelectedOverlay(RematchPetPanel)
		reskinInput(RematchPetPanel.Top.SearchBox)
		reskinFilter(RematchPetPanel.Top.Filter)
		reskinScroll(RematchPetPanel.List)
		reskinInset(RematchPetPanel.Results)

		-- RematchLoadoutPanel
		B.StripTextures(RematchLoadedTeamPanel)
		local bg = B.CreateBDFrame(RematchLoadedTeamPanel, 0)
		bg:SetBackdropColor(cr, cg, cb, .25)
		bg:SetPoint("TOPLEFT", 0, -1)
		bg:SetPoint("BOTTOMRIGHT", 0, 1)
		B.StripTextures(RematchLoadedTeamPanel.Footnotes)

		-- RematchLoadoutPanel
		local Target = RematchLoadoutPanel.Target
		reskinFrame(Target)
		B.StripTextures(Target.LoadSaveButton)
		B.ReskinButton(Target.LoadSaveButton)
		B.StripTextures(Target.ModelBorder)
		reskinFilter(Target.TargetButton)
		for i = 1, 3 do
			reskinButton(Target["Pet"..i])
		end

		-- RematchTeamPanel
		B.StripTextures(RematchTeamPanel.Top)
		reskinSelectedOverlay(RematchTeamPanel)
		reskinInput(RematchTeamPanel.Top.SearchBox)
		reskinFilter(RematchTeamPanel.Top.Teams)
		reskinScroll(RematchTeamPanel.List)

		-- RematchQueuePanel
		B.StripTextures(RematchQueuePanel.Top)
		reskinFilter(RematchQueuePanel.Top.QueueButton)
		reskinScroll(RematchQueuePanel.List)
		reskinInset(RematchQueuePanel.Status)

		-- RematchOptionPanel
		reskinScroll(RematchOptionPanel.List)
		for i = 1, 4 do
			reskinButton(RematchOptionPanel.Growth.Corners[i])
		end

		-- RematchPetCard
		B.ReskinFrame(RematchPetCard)
		reskinPetCard(RematchPetCard.Front)
		reskinPetCard(RematchPetCard.Back)

		local Title = RematchPetCard.Title
		B.StripTextures(Title)
		local bg = B.CreateBDFrame(Title, 0)
		bg:SetPoint("TOPLEFT", -1, -1)
		bg:SetPoint("BOTTOMRIGHT", -1, 1)

		local PinButton = RematchPetCard.PinButton
		B.StripTextures(PinButton)
		B.ReskinArrow(PinButton, "up")
		PinButton:ClearAllPoints()
		PinButton:SetPoint("TOPLEFT", 5, -5)

		for i = 1, 6 do
			local button = RematchPetCard.Front.Bottom.Abilities[i]
			select(8, button:GetRegions()):SetTexture(nil)
			button.IconBorder:Hide()
			B.ReskinIcon(button.Icon)
		end

		-- RematchAbilityCard
		B.StripTextures(RematchAbilityCard, 15)
		B.CreateBDFrame(RematchAbilityCard, .25)
		RematchAbilityCard.Hints.HintsBG:Hide()

		-- RematchWinRecordCard
		B.ReskinFrame(RematchWinRecordCard)

		local Content = RematchWinRecordCard.Content
		B.StripTextures(Content)
		B.CreateBDFrame(Content, 0, -2)

		for _, result in pairs({"Wins", "Losses", "Draws"}) do
			reskinInput(Content[result].EditBox)
			Content[result].Add.IconBorder:Hide()
		end

		local Controls = RematchWinRecordCard.Controls
		B.ReskinButton(Controls.ResetButton)
		B.ReskinButton(Controls.SaveButton)
		B.ReskinButton(Controls.CancelButton)

		-- RematchDialog
		local dialog = RematchDialog
		B.ReskinFrame(dialog)
		B.StripTextures(dialog.Prompt)
		B.ReskinButton(dialog.Accept)
		B.ReskinButton(dialog.Cancel)
		B.ReskinButton(dialog.Other)
		B.ReskinCheck(dialog.CheckButton)
		B.ReskinSlider(dialog.ScaleSlider)
		reskinButton(dialog.Slot)
		reskinButton(dialog.Pet.Pet)
		reskinInput(dialog.EditBox)
		reskinInput(dialog.SaveAs.Name)
		reskinInput(dialog.Send.EditBox)
		reskinDropdown(dialog.SaveAs.Target)
		reskinDropdown(dialog.TabPicker)

		local Preferences = dialog.Preferences
		B.ReskinCheck(Preferences.AllowMM)
		reskinInput(Preferences.MinHP)
		reskinInput(Preferences.MaxHP)
		reskinInput(Preferences.MinXP)
		reskinInput(Preferences.MaxXP)

		local TeamTabIconPicker = dialog.TeamTabIconPicker
		B.ReskinScroll(TeamTabIconPicker.ScrollFrame.ScrollBar)
		B.StripTextures(TeamTabIconPicker)
		B.CreateBDFrame(TeamTabIconPicker, 0)

		local MultiLine = dialog.MultiLine
		B.ReskinScroll(MultiLine.ScrollBar)
		B.CreateBDFrame(MultiLine, 0, 5)
		select(2, MultiLine:GetChildren()):SetBackdrop(nil)

		local ShareIncludes = dialog.ShareIncludes
		B.ReskinCheck(ShareIncludes.IncludePreferences)
		B.ReskinCheck(ShareIncludes.IncludeNotes)

		local CollectionReport = dialog.CollectionReport
		reskinDropdown(CollectionReport.ChartTypeComboBox)
		B.StripTextures(CollectionReport.Chart)
		B.CreateBDFrame(CollectionReport.Chart, 0)

		local RarityBarBorder = CollectionReport.RarityBarBorder
		RarityBarBorder:Hide()
		local bg = B.CreateBDFrame(RarityBarBorder, 0)
		bg:SetPoint("TOPLEFT", RarityBarBorder, 6, -5)
		bg:SetPoint("BOTTOMRIGHT", RarityBarBorder, -6, 5)

		styled = true
	end)

	-- RematchNotes
	do
		B.ReskinFrame(RematchNotes)

		local LockButton = RematchNotes.LockButton
		B.StripTextures(LockButton, 2)
		B.CreateBDFrame(LockButton, 0, -7)
		LockButton:SetPoint("TOPLEFT")

		local Content = RematchNotes.Content
		B.StripTextures(Content)
		B.ReskinScroll(Content.ScrollFrame.ScrollBar)
		local bg = B.CreateBDFrame(Content.ScrollFrame, 0)
		bg:SetPoint("TOPLEFT", 0, 5)
		bg:SetPoint("BOTTOMRIGHT", 0, -2)

		for _, icon in pairs({"Left", "Right"}) do
			local bu = Content[icon.."Icon"]
			local mask = Content[icon.."CircleMask"]

			if mask then
				mask:Hide()
			else
				bu:SetMask(nil)
			end
			B.ReskinIcon(bu)
		end

		local Controls = RematchNotes.Controls
		B.ReskinButton(Controls.DeleteButton)
		B.ReskinButton(Controls.UndoButton)
		B.ReskinButton(Controls.SaveButton)
	end

	-- Rematch
	hooksecurefunc(Rematch, "MenuButtonSetChecked", function(_, button, isChecked, isRadio)
		if isChecked then
			local x = .5
			local y = isRadio and .5 or .25
			button.Check:SetTexCoord(x, x+.25, y-.25, y)
		else
			button.Check:SetTexCoord(0, 0, 0, 0)
		end

		if not button.styled then
			button.Check:SetVertexColor(cr, cg, cb)
			B.CreateBDFrame(button.Check, 0, -4)

			button.styled = true
		end
	end)

	hooksecurefunc(Rematch, "FillCommonPetListButton", function(self, petID)
		local petInfo = Rematch.petInfo:Fetch(petID)
		local parentPanel = self:GetParent():GetParent():GetParent():GetParent()
		if petInfo.isSummoned and parentPanel == Rematch.PetPanel then
			local bg = parentPanel.SelectedOverlay.bg
			if bg then
				bg:ClearAllPoints()
				bg:SetPoint("TOPLEFT", self.bg, C.mult, -C.mult)
				bg:SetPoint("BOTTOMRIGHT", self.bg, -C.mult, C.mult)
			end
		end
	end)

	hooksecurefunc(Rematch, "DimQueueListButton", function(_, button)
		button.LevelText:SetTextColor(1, 1, 1)
	end)

	-- RematchDialog
	hooksecurefunc(RematchDialog, "FillTeam", function(self, frame)
		for i = 1, 3 do
			local button = frame.Pets[i]
			if not button.styled then
				reskinButton(button)

				for j = 1, 3 do
					reskinButton(button.Abilities[j])
				end

				button.styled = true
			end

			button.Icon.bg:SetBackdropBorderColor(button.IconBorder:GetVertexColor())
		end
	end)

	-- RematchTeamTabs
	hooksecurefunc(RematchTeamTabs, "Update", function(self)
		for _, tab in next, self.Tabs do
			reskinButton(tab)
			tab:SetSize(40, 40)
			tab.Icon:SetPoint("CENTER")
		end

		for _, button in pairs({"UpButton", "DownButton"}) do
			reskinButton(self[button])
			self[button]:SetSize(40, 40)
			self[button].Icon:SetPoint("CENTER")
		end
	end)

	hooksecurefunc(RematchTeamTabs, "TabButtonUpdate", function(self, index)
		local selected = self:GetSelectedTab()
		local button = self:GetTabButton(index)
		if not button.Icon.bg then return end

		if index == selected then
			button.Icon.bg:SetBackdropBorderColor(1, 1, 1)
		else
			button.Icon.bg:SetBackdropBorderColor(0, 0, 0)
		end
	end)

	hooksecurefunc(RematchTeamTabs, "UpdateTabIconPickerList", function()
		local buttons = RematchDialog.TeamTabIconPicker.ScrollFrame.buttons
		for i = 1, #buttons do
			local button = buttons[i]
			if i == 1 then
				button:ClearAllPoints()
				button:SetPoint("TOPLEFT", 3, 0)
			end
			for j = 1, 10 do
				local bu = button.Icons[j]
				if not bu.styled then
					bu:SetSize(24, 24)

					bu.Icon = bu.Texture
					reskinButton(bu)
					B.ReskinTexed(bu.Selected, bu.Icon.bg)

					bu.styled = true
				end
			end
		end
	end)

	-- RematchLoadoutPanel
	hooksecurefunc(RematchLoadoutPanel, "UpdateLoadouts", function(self)
		if not self then return end

		for i = 1, 3 do
			local Loadouts = self.Loadouts[i]
			Loadouts.HP.MiniHP:Hide()

			local Pet = Loadouts.Pet.Pet

			if not Loadouts.styled then
				reskinFrame(Loadouts)
				local HP = Loadouts.HP
				HP:SetSize(64, 8)
				B.ReskinStatusBar(HP, true)

				local XP = Loadouts.XP
				XP:SetSize(256, 8)
				B.ReskinStatusBar(XP, true)

				for j = 1, 3 do
					reskinButton(Loadouts.Abilities[j])
				end
				for k = 1, 2 do
					local Flyout = self.Flyout
					Flyout:SetBackdrop(nil)
					reskinButton(Flyout.Abilities[k])
				end

				reskinButton(Pet)

				Loadouts.styled = true
			end

			if Pet.Icon.bg then
				Pet.Icon.bg:SetBackdropBorderColor(Pet.IconBorder:GetVertexColor())
			end
		end
	end)

	-- RematchPetPanel
	local activeTypeMode = 1
	hooksecurefunc(RematchPetPanel, "SetTypeMode", function(_, typeMode)
		activeTypeMode = typeMode
	end)
	hooksecurefunc(RematchPetPanel, "UpdateTypeBar", function(self)
		local TypeBar = self.Top.TypeBar
		if TypeBar:IsShown() then
			B.StripTextures(TypeBar)

			for i = 1, 3 do
				local tab = TypeBar.Tabs[i]
				if not tab.styled then
					B.StripTextures(tab)
					tab.bg = B.CreateBDFrame(tab, 0)
					tab.bg:SetPoint("TOPLEFT", 1, -1)
					tab.bg:SetPoint("BOTTOMRIGHT", -3, 1)

					local r, g, b = tab.Selected.MidSelected:GetVertexColor()
					tab.bg:SetBackdropColor(r, g, b, .5)
					B.StripTextures(tab.Selected)

					tab.styled = true
				end

				tab.bg:SetShown(activeTypeMode == i)
			end

			for i = 1, 10 do
				local button = TypeBar.Buttons[i]
				if not button.styled then
					reskinButton(button)

					local check = button:GetCheckedTexture()
					B.ReskinBorder(check, button.Icon, true)

					button.styled = true
				end
			end
		end
	end)

	-- PetList
	hooksecurefunc(RematchPetPanel.List, "Update", reskinPetList)
	hooksecurefunc(RematchQueuePanel.List, "Update", reskinPetList)
	hooksecurefunc(RematchTeamPanel.List, "Update", reskinPetList)

	-- RematchTeamPanel
	hooksecurefunc(RematchTeamPanel, "FillTeamListButton", function(self, key)
		local teamInfo = Rematch.teamInfo:Fetch(key)
		if not teamInfo then return end

		local panel = RematchTeamPanel
		if teamInfo.key == RematchSettings.loadedTeam then
			local bg = panel.SelectedOverlay.bg
			if bg then
				bg:ClearAllPoints()
				bg:SetPoint("TOPLEFT", self.bg, C.mult, -C.mult)
				bg:SetPoint("BOTTOMRIGHT", self.bg, -C.mult, C.mult)
			end
		end
	end)

	-- RematchOptionPanel
	hooksecurefunc(RematchOptionPanel, "FillOptionListButton", function(self, index)
		local panel = RematchOptionPanel
		local opt = panel.opts[index]
		if opt then
			self.optType = opt[1]
			local checkButton = self.CheckButton
			if not checkButton.bg then
				local bg = B.CreateBDFrame(checkButton, 0)
				checkButton.bg = bg
				self.HeaderBack:SetTexture(nil)
			end
			checkButton.bg:SetBackdropColor(0, 0, 0, 0)
			checkButton.bg:Show()

			if self.optType == "header" then
				self.headerIndex = opt[3]
				self.Text:ClearAllPoints()
				self.Text:SetPoint("LEFT", checkButton.bg, "LEFT", 2, 0)

				checkButton:SetSize(8, 8)
				checkButton:SetPoint("LEFT", 5, 0)
				checkButton:SetTexture("")
				checkButton.bg:SetBackdropColor(0, 0, 0, 0)
				checkButton.bg:SetPoint("TOPLEFT", 2, -2)
				checkButton.bg:SetPoint("BOTTOMRIGHT", 0, 2)
			elseif self.optType == "check" then
				checkButton:SetSize(22, 22)
				checkButton.bg:SetPoint("TOPLEFT", checkButton, 2, -2)
				checkButton.bg:SetPoint("BOTTOMRIGHT", checkButton, -2, 2)
				if self.isChecked and self.isDisabled then
					checkButton:SetTexCoord(.25, .5, .75, 1)
				elseif self.isChecked then
					checkButton:SetTexCoord(.5, .75, 0, .25)
				else
					checkButton:SetTexCoord(0, 0, 0, 0)
				end
			elseif self.optType == "radio" then
				local isChecked = RematchSettings[opt[2]] == opt[5]
				checkButton:SetSize(22, 22)
				checkButton.bg:SetPoint("TOPLEFT", checkButton, 2, -2)
				checkButton.bg:SetPoint("BOTTOMRIGHT", checkButton, -2, 2)
				if isChecked then
					checkButton:SetTexCoord(.5, .75, .25, .5)
				else
					checkButton:SetTexCoord(0, 0, 0, 0)
				end
			else
				checkButton.bg:Hide()
			end
		end
	end)

	-- RematchFrame
	local styled
	hooksecurefunc(RematchFrame, "ConfigureFrame", function()
		if styled then return end

		B.ReskinFrame(RematchFrame)
		reskinTabs(RematchFrame)

		RematchMiniPanel.Background:Hide()
		RematchFrame.BottomTileStreaks:SetAlpha(0)
		RematchFrame.ShadowCornerBottomLeft:SetAlpha(0)
		RematchFrame.ShadowCornerBottomRight:SetAlpha(0)

		RematchFrame.PanelTabs:ClearAllPoints()
		RematchFrame.PanelTabs:SetPoint("TOP", RematchFrame, "BOTTOM", 0, 2)

		local TitleBar = RematchFrame.TitleBar
		B.StripTextures(TitleBar)
		B.ReskinClose(TitleBar.CloseButton)

		local buttons = {TitleBar.LockButton, TitleBar.SinglePanelButton, TitleBar.MinimizeButton}
		for _, button in pairs(buttons) do
			button:SetSize(18, 18)
			B.StripTextures(button, 2)
			B.ReskinButton(button)
		end

		TitleBar.MinimizeButton:ClearAllPoints()
		TitleBar.MinimizeButton:SetPoint("RIGHT", TitleBar.CloseButton, "LEFT", -2, 0)

		TitleBar.LockButton:ClearAllPoints()
		TitleBar.LockButton:SetPoint("TOPLEFT", TitleBar, "TOPLEFT", 6, -6)

		TitleBar.SinglePanelButton:ClearAllPoints()
		TitleBar.SinglePanelButton:SetPoint("LEFT", TitleBar.LockButton, "RIGHT", 2, 0)

		styled = true
	end)
end