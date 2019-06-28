local _, ns = ...
local B, C, L, DB, F, T = unpack(ns)
local S = B:GetModule("Skins")

function S:ReskinRematch()
	if not IsAddOnLoaded("Rematch") then return end
	if not NDuiDB["Skins"]["Rematch"] then return end
	if not F then return end

	local cr, cg, cb = C.r, C.g, C.b

	local settings = RematchSettings
	settings.ColorPetNames = true
	settings.FixedPetCard = true
	RematchLoreFont:SetTextColor(1, 1, 1)

	local function reskinFrame(self)
		F.StripTextures(self)

		local bg = F.CreateBDFrame(self, 0)
		bg:SetPoint("TOPLEFT", 0, -1)
		bg:SetPoint("BOTTOMRIGHT", 0, 1)
	end

	local function reskinFilter(self)
		self.Icon = self.Arrow

		F.ReskinFilter(self)
	end

	local function reskinButton(self)
		if self.styled then return end

		F.CleanTextures(self)

		if self.IconBorder then self.IconBorder:Hide() end
		if self.Background then self.Background:Hide() end

		if self.Icon then
			self.Icon.bg = F.ReskinIcon(self.Icon)

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
			F.ReskinTexed(self, self)
		end

		self.styled = true
	end

	local function reskinInput(self)
		self:DisableDrawLayer("BACKGROUND")
		self:SetBackdrop(nil)

		local bg = F.CreateBDFrame(self, 0)
		bg:SetPoint("TOPLEFT", 2, 0)
		bg:SetPoint("BOTTOMRIGHT", -2, 0)
	end

	local function reskinScroll(self)
		self.Background:Hide()

		local ScrollBar = self.ScrollFrame.ScrollBar
		ScrollBar.thumbTexture = ScrollBar.ScrollThumb
		F.ReskinScroll(ScrollBar)

		local UpButton = ScrollBar.UpButton
		UpButton:ClearAllPoints()
		UpButton:SetPoint("BOTTOM", ScrollBar, "TOP", 0, -2)

		local DownButton = ScrollBar.DownButton
		DownButton:ClearAllPoints()
		DownButton:SetPoint("TOP", ScrollBar, "BOTTOM", 0, 2)

		local TopButton = ScrollBar.TopButton
		if TopButton then
			TopButton:SetWidth(17)
			TopButton:ClearAllPoints()
			TopButton:SetPoint("BOTTOM", UpButton, "TOP", 0, 2)

			F.ReskinButton(TopButton)
			F.SetupArrowTex(TopButton, "top")
		end

		local BottomButton = ScrollBar.BottomButton
		if BottomButton then
			BottomButton:SetWidth(17)
			BottomButton:ClearAllPoints()
			BottomButton:SetPoint("TOP", DownButton, "BOTTOM", 0, -2)

			F.ReskinButton(BottomButton)
			F.SetupArrowTex(BottomButton, "bottom")
		end
	end

	local function reskinDropdown(self)
		self:SetBackdrop(nil)

		F.StripTextures(self)
		F.CreateBDFrame(self, 0)

		if self.Icon then
			self.Icon:SetAlpha(1)
			self.Icon.bg = F.ReskinIcon(self.Icon)
		end

		local arrow = self:GetChildren()
		F.ReskinArrow(arrow, "down")
	end

	local function reskinPetCard(self)
		self:SetBackdrop(nil)

		if self.Source then
			reskinFrame(self.Source)
		end

		if self.Middle.XP then
			F.ReskinStatusBar(self.Middle.XP, true)
		end

		reskinFrame(self.Middle)
		reskinFrame(self.Bottom)
	end

	local function reskinInset(self)
		F.StripTextures(self)

		local bg = F.CreateBDFrame(self, 0)
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
					F.CreateBDFrame(button.Pet, 0)
					if button.Rarity then button.Rarity:SetTexture(nil) end
					if button.LevelBack then button.LevelBack:SetTexture(nil) end
					button.LevelText:SetTextColor(1, 1, 1)

					parent = button.Pet
				end

				if button.Pets then
					for j = 1, 3 do
						local bu = button.Pets[j]
						bu:SetWidth(25)
						F.CreateBDFrame(bu, 0)
					end
					if button.Border then button.Border:SetTexture(nil) end

					parent = button.Pets[3]
				end

				if button.Back then
					button.Back:SetTexture(nil)
					local bg = F.CreateBDFrame(button.Back, 0)
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
		F.StripTextures(self.SelectedOverlay)
		local bg = F.CreateBDFrame(self.SelectedOverlay, 0)
		bg:SetBackdropColor(cr, cg, cb, .5)
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
		F.ReskinTooltip(RematchTooltip)
		F.ReskinTooltip(RematchTableTooltip)

		for i = 1, 3 do
			local menu = Rematch:GetMenuFrame(i, UIParent)
			F.ReskinFrame(menu)

			F.StripTextures(menu.Title)
			local bg = F.CreateBDFrame(menu.Title, 0)
			bg:SetBackdropColor(1, .8, 0, .25)
		end

		F.StripTextures(RematchJournal)
		F.ReskinClose(RematchJournal.CloseButton)

		for _, tab in ipairs(RematchJournal.PanelTabs.Tabs) do
			F.ReskinTab(tab)
		end

		local buttons = {
			RematchHealButton,
			RematchBandageButton,
			RematchToolbar.SafariHat,
			RematchLesserPetTreatButton,
			RematchPetTreatButton,
			RematchToolbar.SummonRandom,
		}
		for _, button in pairs(buttons) do
			reskinButton(button)
		end

		F.StripTextures(RematchToolbar.PetCount)

		-- RematchBottomPanel
		F.ReskinCheck(UseRematchButton)
		F.ReskinCheck(RematchBottomPanel.UseDefault)
		F.ReskinButton(RematchBottomPanel.SummonButton)
		F.ReskinButton(RematchBottomPanel.SaveButton)
		F.ReskinButton(RematchBottomPanel.SaveAsButton)
		F.ReskinButton(RematchBottomPanel.FindBattleButton)

		-- RematchPetPanel
		F.StripTextures(RematchPetPanel.Top)
		F.ReskinButton(RematchPetPanel.Top.Toggle)
		reskinSelectedOverlay(RematchPetPanel)
		reskinInput(RematchPetPanel.Top.SearchBox)
		reskinFilter(RematchPetPanel.Top.Filter)
		reskinScroll(RematchPetPanel.List)
		reskinInset(RematchPetPanel.Results)

		-- RematchLoadoutPanel
		F.StripTextures(RematchLoadedTeamPanel)
		local bg = F.CreateBDFrame(RematchLoadedTeamPanel, 0)
		bg:SetBackdropColor(cr, cg, cb, .25)
		bg:SetPoint("TOPLEFT", 0, -1)
		bg:SetPoint("BOTTOMRIGHT", 0, 1)
		F.StripTextures(RematchLoadedTeamPanel.Footnotes)

		-- RematchLoadoutPanel
		local Target = RematchLoadoutPanel.Target
		reskinFrame(Target)
		F.StripTextures(Target.LoadSaveButton)
		F.ReskinButton(Target.LoadSaveButton)
		F.StripTextures(Target.ModelBorder)
		reskinFilter(Target.TargetButton)
		for i = 1, 3 do
			reskinButton(Target["Pet"..i])
		end

		-- RematchTeamPanel
		F.StripTextures(RematchTeamPanel.Top)
		reskinSelectedOverlay(RematchTeamPanel)
		reskinInput(RematchTeamPanel.Top.SearchBox)
		reskinFilter(RematchTeamPanel.Top.Teams)
		reskinScroll(RematchTeamPanel.List)

		-- RematchQueuePanel
		F.StripTextures(RematchQueuePanel.Top)
		reskinFilter(RematchQueuePanel.Top.QueueButton)
		reskinScroll(RematchQueuePanel.List)
		reskinInset(RematchQueuePanel.Status)

		-- RematchOptionPanel
		reskinScroll(RematchOptionPanel.List)
		for i = 1, 4 do
			reskinButton(RematchOptionPanel.Growth.Corners[i])
		end

		-- RematchPetCard
		F.ReskinFrame(RematchPetCard)
		reskinPetCard(RematchPetCard.Front)
		reskinPetCard(RematchPetCard.Back)

		local Title = RematchPetCard.Title
		F.StripTextures(Title)
		local bg = F.CreateBDFrame(Title, 0)
		bg:SetPoint("TOPLEFT", -1, -1)
		bg:SetPoint("BOTTOMRIGHT", -1, 1)

		local PinButton = RematchPetCard.PinButton
		F.StripTextures(PinButton)
		F.ReskinArrow(PinButton, "up")
		PinButton:ClearAllPoints()
		PinButton:SetPoint("TOPLEFT", 5, -5)

		for i = 1, 6 do
			local button = RematchPetCard.Front.Bottom.Abilities[i]
			select(8, button:GetRegions()):SetTexture(nil)
			button.IconBorder:Hide()
			F.ReskinIcon(button.Icon)
		end

		-- RematchAbilityCard
		F.StripTextures(RematchAbilityCard, 15)
		F.CreateBDFrame(RematchAbilityCard, .25)
		RematchAbilityCard.Hints.HintsBG:Hide()

		-- RematchWinRecordCard
		F.ReskinFrame(RematchWinRecordCard)

		local Content = RematchWinRecordCard.Content
		F.StripTextures(Content)
		local bg = F.CreateBDFrame(Content, 0)
		bg:SetPoint("TOPLEFT", 2, -2)
		bg:SetPoint("BOTTOMRIGHT", -2, 2)

		for _, result in pairs({"Wins", "Losses", "Draws"}) do
			reskinInput(Content[result].EditBox)
			Content[result].Add.IconBorder:Hide()
		end

		local Controls = RematchWinRecordCard.Controls
		F.ReskinButton(Controls.ResetButton)
		F.ReskinButton(Controls.SaveButton)
		F.ReskinButton(Controls.CancelButton)

		-- RematchDialog
		local dialog = RematchDialog
		F.ReskinFrame(dialog)
		F.StripTextures(dialog.Prompt)
		F.ReskinButton(dialog.Accept)
		F.ReskinButton(dialog.Cancel)
		F.ReskinButton(dialog.Other)
		F.ReskinCheck(dialog.CheckButton)
		reskinButton(dialog.Slot)
		reskinButton(dialog.Pet.Pet)
		reskinInput(dialog.EditBox)
		reskinInput(dialog.SaveAs.Name)
		reskinInput(dialog.Send.EditBox)
		reskinDropdown(dialog.SaveAs.Target)
		reskinDropdown(dialog.TabPicker)

		local Preferences = dialog.Preferences
		F.ReskinCheck(Preferences.AllowMM)
		reskinInput(Preferences.MinHP)
		reskinInput(Preferences.MaxHP)
		reskinInput(Preferences.MinXP)
		reskinInput(Preferences.MaxXP)

		local TeamTabIconPicker = dialog.TeamTabIconPicker
		F.ReskinScroll(TeamTabIconPicker.ScrollFrame.ScrollBar)
		F.StripTextures(TeamTabIconPicker)
		F.CreateBDFrame(TeamTabIconPicker, 0)

		local MultiLine = dialog.MultiLine
		F.ReskinScroll(MultiLine.ScrollBar)
		select(2, MultiLine:GetChildren()):SetBackdrop(nil)
		local bg = F.CreateBDFrame(MultiLine, 0)
		bg:SetPoint("TOPLEFT", -5, 5)
		bg:SetPoint("BOTTOMRIGHT", 5, -5)

		local ShareIncludes = dialog.ShareIncludes
		F.ReskinCheck(ShareIncludes.IncludePreferences)
		F.ReskinCheck(ShareIncludes.IncludeNotes)

		local CollectionReport = dialog.CollectionReport
		reskinDropdown(CollectionReport.ChartTypeComboBox)
		F.StripTextures(CollectionReport.Chart)
		F.CreateBDFrame(CollectionReport.Chart, 0)

		local RarityBarBorder = CollectionReport.RarityBarBorder
		RarityBarBorder:Hide()
		local bg = F.CreateBDFrame(RarityBarBorder, 0)
		bg:SetPoint("TOPLEFT", RarityBarBorder, 6, -5)
		bg:SetPoint("BOTTOMRIGHT", RarityBarBorder, -6, 5)

		-- RematchNotes
		F.ReskinFrame(RematchNotes)

		local LockButton = RematchNotes.LockButton
		F.StripTextures(LockButton, 2)
		LockButton:SetPoint("TOPLEFT")
		local bg = F.CreateBDFrame(LockButton, 0)
		bg:SetPoint("TOPLEFT", 7, -7)
		bg:SetPoint("BOTTOMRIGHT", -7, 7)

		local Content = RematchNotes.Content
		F.StripTextures(Content)
		F.ReskinScroll(Content.ScrollFrame.ScrollBar)
		local bg = F.CreateBDFrame(Content.ScrollFrame, 0)
		bg:SetPoint("TOPLEFT", 0, 5)
		bg:SetPoint("BOTTOMRIGHT", 0, -2)

		for _, icon in pairs({"Left", "Right"}) do
			local bu = Content[icon.."Icon"]
			bu:SetMask(nil)
			F.ReskinIcon(bu)
		end

		local Controls = RematchNotes.Controls
		F.ReskinButton(Controls.DeleteButton)
		F.ReskinButton(Controls.UndoButton)
		F.ReskinButton(Controls.SaveButton)

		styled = true
	end)

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
			local bg = F.CreateBDFrame(button.Check, 0)
			bg:SetPoint("TOPLEFT", button.Check, 4, -4)
			bg:SetPoint("BOTTOMRIGHT", button.Check, -4, 4)

			button.styled = true
		end
	end)

	hooksecurefunc(Rematch, "FillCommonPetListButton", function(self, petID)
		local petInfo = Rematch.petInfo:Fetch(petID)
		local parentPanel = self:GetParent():GetParent():GetParent():GetParent()
		if petInfo.isSummoned and parentPanel == Rematch.PetPanel then
			parentPanel.SelectedOverlay:SetPoint("TOPLEFT", self.bg, C.mult, -C.mult)
			parentPanel.SelectedOverlay:SetPoint("BOTTOMRIGHT", self.bg, -C.mult, C.mult)
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
					F.ReskinTexed(bu.Selected, bu.Icon.bg)

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
				F.ReskinStatusBar(HP, true)

				local XP = Loadouts.XP
				XP:SetSize(256, 8)
				F.ReskinStatusBar(XP, true)

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
			F.StripTextures(TypeBar)

			for i = 1, 3 do
				local tab = TypeBar.Tabs[i]
				if not tab.styled then
					F.StripTextures(tab)
					tab.bg = F.CreateBDFrame(tab, 0)
					tab.bg:SetPoint("TOPLEFT", 1, -1)
					tab.bg:SetPoint("BOTTOMRIGHT", -3, 1)

					local r, g, b = tab.Selected.MidSelected:GetVertexColor()
					tab.bg:SetBackdropColor(r, g, b, .5)
					F.StripTextures(tab.Selected)

					tab.styled = true
				end

				tab.bg:SetShown(activeTypeMode == i)
			end

			for i = 1, 10 do
				local button = TypeBar.Buttons[i]
				if not button.styled then
					reskinButton(button)

					local check = button:GetCheckedTexture()
					F.ReskinBorder(check, button.Icon, true)

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
		if teamInfo.key == settings.loadedTeam then
			panel.SelectedOverlay:SetPoint("TOPLEFT", self.bg, C.mult, -C.mult)
			panel.SelectedOverlay:SetPoint("BOTTOMRIGHT", self.bg, -C.mult, C.mult)
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
				local bg = F.CreateBDFrame(checkButton, 0)
				checkButton.bg = bg
				self.HeaderBack:SetTexture(nil)
			end
			checkButton.bg:SetBackdropColor(0, 0, 0, 0)
			checkButton.bg:Show()

			if self.optType == "header" then
				self.headerIndex = opt[3]
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
				local isChecked = settings[opt[2]] == opt[5]
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
end