local F, C = unpack(select(2, ...))

C.themes["Blizzard_Collections"] = function()
	local r, g, b = C.r, C.g, C.b

	-- [[ General ]]
	F.StripTextures(CollectionsJournal, true)

	F.CreateBD(CollectionsJournal)
	F.CreateSD(CollectionsJournal)
	F.ReskinTab(CollectionsJournalTab1)
	F.ReskinTab(CollectionsJournalTab2)
	F.ReskinTab(CollectionsJournalTab3)
	F.ReskinTab(CollectionsJournalTab4)
	F.ReskinTab(CollectionsJournalTab5)
	F.ReskinClose(CollectionsJournalCloseButton)

	CollectionsJournalTab2:SetPoint("LEFT", CollectionsJournalTab1, "RIGHT", -15, 0)
	CollectionsJournalTab3:SetPoint("LEFT", CollectionsJournalTab2, "RIGHT", -15, 0)
	CollectionsJournalTab4:SetPoint("LEFT", CollectionsJournalTab3, "RIGHT", -15, 0)
	CollectionsJournalTab5:SetPoint("LEFT", CollectionsJournalTab4, "RIGHT", -15, 0)

	-- [[ Mounts and pets ]]
	local lists = {PetJournal, PetJournal.PetCount, PetJournal.LeftInset, PetJournal.RightInset, PetJournal.PetCardInset, PetJournal.loadoutBorder, MountJournal, MountJournal.MountCount, MountJournal.LeftInset, MountJournal.RightInset, MountJournal.MountDisplay, MountJournal.MountDisplay.ShadowOverlay}
	for _, list in next, lists do
		F.StripTextures(list, true)
	end

	F.CreateBDFrame(MountJournal.MountCount, .25)
	F.CreateBDFrame(PetJournal.PetCount, .25)
	F.CreateBDFrame(MountJournal.MountDisplay.ModelScene, .25)

	F.Reskin(MountJournalMountButton)
	F.Reskin(PetJournalSummonButton)
	F.Reskin(PetJournalFindBattle)
	F.ReskinScroll(MountJournalListScrollFrameScrollBar)
	F.ReskinScroll(PetJournalListScrollFrameScrollBar)
	F.ReskinInput(MountJournalSearchBox)
	F.ReskinInput(PetJournalSearchBox)
	F.ReskinArrow(MountJournal.MountDisplay.ModelScene.RotateLeftButton, "left")
	F.ReskinArrow(MountJournal.MountDisplay.ModelScene.RotateRightButton, "right")
	F.ReskinFilterButton(PetJournalFilterButton)
	F.ReskinFilterButton(MountJournalFilterButton)

	MountJournalFilterButton:ClearAllPoints()
	MountJournalFilterButton:SetPoint("LEFT", MountJournalSearchBox, "RIGHT", 2, 0)
	PetJournalFilterButton:ClearAllPoints()
	PetJournalFilterButton:SetPoint("LEFT", PetJournalSearchBox, "RIGHT", 2, 0)
	PetJournalTutorialButton:SetPoint("TOPLEFT", -14, 14)

	local scrollFrames = {MountJournal.ListScrollFrame.buttons, PetJournal.listScroll.buttons}
	for _, scrollFrame in pairs(scrollFrames) do
		for i = 1, #scrollFrame do
			local bu = scrollFrame[i]
			local ic = bu.icon

			bu:GetRegions():Hide()
			bu.iconBorder:SetTexture("")
			bu.selectedTexture:SetTexture("")

			local bg = F.CreateBDFrame(bu, .25)
			bg:SetPoint("TOPLEFT", 0, -1)
			bg:SetPoint("BOTTOMRIGHT", 0, 1)
			bu.bg = bg

			local hl = bu:GetHighlightTexture()
			hl:SetColorTexture(r, g, b, .25)
			hl:SetPoint("TOPLEFT", bg, 1, -1)
			hl:SetPoint("BOTTOMRIGHT", bg, -1, 1)

			ic:SetTexCoord(.08, .92, .08, .92)
			ic.bg = F.CreateBDFrame(ic, .25)

			bu.name:SetParent(bg)

			if bu.DragButton then
				bu.DragButton.ActiveTexture:SetTexture(C.media.checked)
				bu.DragButton:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)
				bu.DragButton:GetHighlightTexture():SetAllPoints(ic)
			else
				bu.dragButton.ActiveTexture:SetTexture(C.media.checked)
				bu.dragButton.levelBG:SetAlpha(0)
				bu.dragButton.level:SetFontObject(GameFontNormal)
				bu.dragButton.level:SetTextColor(1, 1, 1)
				bu.dragButton:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)
				bu.dragButton:GetHighlightTexture():SetAllPoints(ic)
			end
		end
	end

	local function updateMountScroll()
		local buttons = MountJournal.ListScrollFrame.buttons
		for i = 1, #buttons do
			local bu = buttons[i]
			if bu.bg then
				if bu.index ~= nil then
					bu.bg:Show()
					bu.icon:Show()
					bu.icon.bg:Show()

					if bu.selectedTexture:IsShown() then
						bu.bg:SetBackdropColor(r, g, b, .25)
					else
						bu.bg:SetBackdropColor(0, 0, 0, .25)
					end
				else
					bu.bg:Hide()
					bu.icon:Hide()
					bu.icon.bg:Hide()
				end
			end
		end
	end

	hooksecurefunc("MountJournal_UpdateMountList", updateMountScroll)
	hooksecurefunc(MountJournalListScrollFrame, "update", updateMountScroll)

	local function updatePetScroll()
		local petButtons = PetJournal.listScroll.buttons
		if petButtons then
			for i = 1, #petButtons do
				local bu = petButtons[i]

				local index = bu.index
				if index then
					local petID, _, isOwned = C_PetJournal.GetPetInfoByIndex(index)

					if petID and isOwned then
						local _, _, _, _, rarity = C_PetJournal.GetPetStats(petID)

						if rarity then
							local color = BAG_ITEM_QUALITY_COLORS[rarity-1]
							bu.name:SetTextColor(color.r, color.g, color.b)
						else
							bu.name:SetTextColor(1, 1, 1)
						end
					else
						bu.name:SetTextColor(.5, .5, .5)
					end

					if bu.selectedTexture:IsShown() then
						bu.bg:SetBackdropColor(r, g, b, .25)
					else
						bu.bg:SetBackdropColor(0, 0, 0, .25)
					end
				end
			end
		end
	end

	hooksecurefunc("PetJournal_UpdatePetList", updatePetScroll)
	hooksecurefunc(PetJournalListScrollFrame, "update", updatePetScroll)

	local ic = MountJournal.MountDisplay.InfoButton.Icon
	ic:SetTexCoord(.08, .92, .08, .92)
	F.CreateBDFrame(ic, .25)

	PetJournalHealPetButtonBorder:Hide()
	PetJournalHealPetButtonIconTexture:SetTexCoord(.08, .92, .08, .92)
	PetJournal.HealPetButton:SetPushedTexture("")
	PetJournal.HealPetButton:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)
	PetJournal.HealPetButton:SetPoint("BOTTOMRIGHT", PetJournalPetCard, "TOPRIGHT", -1, 4)
	F.CreateBDFrame(PetJournal.HealPetButton, .25)

	if AuroraConfig.tooltips then
		for _, f in next, {PetJournalPrimaryAbilityTooltip, PetJournalSecondaryAbilityTooltip} do
			local bg = F.CreateBDFrame(f)
			bg:SetAllPoints()
			bg:SetFrameLevel(0)
		end
	end

	PetJournalLoadoutBorderSlotHeaderText:SetParent(PetJournal)
	PetJournalLoadoutBorderSlotHeaderText:SetPoint("CENTER", PetJournalLoadoutBorderTop, "TOP", 0, 4)

	PetJournalSummonRandomFavoritePetButtonBorder:Hide()
	PetJournalSummonRandomFavoritePetButtonIconTexture:SetTexCoord(.08, .92, .08, .92)
	PetJournalSummonRandomFavoritePetButton:SetPushedTexture("")
	PetJournalSummonRandomFavoritePetButton:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)
	F.CreateBDFrame(PetJournalSummonRandomFavoritePetButton, .25)

	-- Favourite mount button
	MountJournalSummonRandomFavoriteButtonBorder:Hide()
	MountJournalSummonRandomFavoriteButtonIconTexture:SetTexCoord(.08, .92, .08, .92)
	MountJournalSummonRandomFavoriteButton:SetPushedTexture("")
	MountJournalSummonRandomFavoriteButton:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)
	MountJournalSummonRandomFavoriteButton:SetPoint("BOTTOMRIGHT", MountJournal.MountDisplay, "TOPRIGHT", 0, 4)
	F.CreateBDFrame(MountJournalSummonRandomFavoriteButton, .25)

	-- Pet card
	local card = PetJournalPetCard

	F.StripTextures(card, true)
	F.StripTextures(card.PetInfo)
	card.AbilitiesBG1:SetAlpha(0)
	card.AbilitiesBG2:SetAlpha(0)
	card.AbilitiesBG3:SetAlpha(0)

	card.PetInfo.level:SetFontObject(GameFontNormal)
	card.PetInfo.level:SetTextColor(1, 1, 1)

	card.PetInfo.icon:SetTexCoord(.08, .92, .08, .92)
	card.PetInfo.icon.bg = F.CreateBDFrame(card.PetInfo.icon, .25)

	F.CreateBD(card, .25)
	F.CreateSD(card)

	F.ReskinStatusBar(card.xpBar, false, true)
	F.ReskinStatusBar(card.HealthFrame.healthBar, false, true)

	for i = 1, 6 do
		local bu = card["spell"..i]

		bu.icon:SetTexCoord(.08, .92, .08, .92)
		F.CreateBDFrame(bu.icon)
	end

	hooksecurefunc("PetJournal_UpdatePetCard", function(self)
		local border = self.PetInfo.qualityBorder
		local r, g, b = 0, 0, 0

		if border:IsShown() then
			r, g, b = self.PetInfo.qualityBorder:GetVertexColor()
		end
		self.PetInfo.icon.bg:SetBackdropBorderColor(r, g, b)
		self.PetInfo.icon.bg.Shadow:SetBackdropBorderColor(r, g, b)
	end)

	-- Pet loadout
	for i = 1, 3 do
		local bu = PetJournal.Loadout["Pet"..i]
		F.StripTextures(bu)

		local bg = F.CreateBDFrame(bu, .25)
		bg:SetPoint("TOPLEFT", 0, -4)
		bg:SetPoint("BOTTOMRIGHT")

		bu.dragButton:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)
		bu.level:SetFontObject(GameFontNormal)
		bu.level:SetTextColor(1, 1, 1)
		bu.icon:SetTexCoord(.08, .92, .08, .92)
		bu.icon.bg = F.CreateBDFrame(bu.icon, .25)
		bu.setButton:GetRegions():SetPoint("TOPLEFT", bu.icon, -5, 5)
		bu.setButton:GetRegions():SetPoint("BOTTOMRIGHT", bu.icon, 5, -5)

		F.ReskinStatusBar(bu.xpBar, false, true)
		F.ReskinStatusBar(bu.healthFrame.healthBar, false, true)

		for j = 1, 3 do
			local spell = bu["spell"..j]
			spell:SetPushedTexture("")
			spell:GetRegions():Hide()
			spell:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)

			spell.selected:SetTexture(C.media.checked)
			spell.FlyoutArrow:SetTexture(C.media.arrowDown)
			spell.FlyoutArrow:SetSize(8, 8)
			spell.FlyoutArrow:SetTexCoord(0, 1, 0, 1)

			spell.icon:SetTexCoord(.08, .92, .08, .92)
			F.CreateBDFrame(spell.icon, .25)
		end
	end

	hooksecurefunc("PetJournal_UpdatePetLoadOut", function()
		for i = 1, 3 do
			local bu = PetJournal.Loadout["Pet"..i]
			local r, g, b = bu.qualityBorder:GetVertexColor()

			bu.icon.bg:SetShown(not bu.helpFrame:IsShown())
			bu.icon.bg:SetBackdropBorderColor(r, g, b)
			bu.icon.bg.Shadow:SetBackdropBorderColor(r, g, b)

			bu.dragButton:SetEnabled(not bu.helpFrame:IsShown())
		end
	end)

	F.StripTextures(PetJournal.SpellSelect, true)

	for i = 1, 2 do
		local bu = PetJournal.SpellSelect["Spell"..i]

		bu:SetCheckedTexture(C.media.checked)
		bu:SetPushedTexture("")
		bu:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)

		bu.icon:SetDrawLayer("ARTWORK")
		bu.icon:SetTexCoord(.08, .92, .08, .92)
		F.CreateBDFrame(bu.icon, .25)
	end

	-- [[ Toy box ]]
	local icons = ToyBox.iconsFrame
	F.StripTextures(icons, true)
	F.ReskinInput(ToyBox.searchBox)
	F.ReskinFilterButton(ToyBoxFilterButton)
	F.ReskinArrow(ToyBox.PagingFrame.PrevPageButton, "left")
	F.ReskinArrow(ToyBox.PagingFrame.NextPageButton, "right")

	-- Progress bar
	local progressBar = ToyBox.progressBar
	progressBar.text:SetPoint("CENTER")
	F.ReskinStatusBar(progressBar, true, true)

	-- Toys!
	local shouldChangeTextColor = true
	local changeTextColor = function(toyString)
		if shouldChangeTextColor then
			shouldChangeTextColor = false

			local self = toyString:GetParent()
			if PlayerHasToy(self.itemID) then
				local _, _, quality = GetItemInfo(self.itemID)
				if quality then
					toyString:SetTextColor(GetItemQualityColor(quality))
				else
					toyString:SetTextColor(1, 1, 1)
				end
			else
				toyString:SetTextColor(.5, .5, .5)
			end

			shouldChangeTextColor = true
		end
	end

	local buttons = ToyBox.iconsFrame
	for i = 1, 18 do
		local bu = buttons["spellButton"..i]
		F.StripTextures(bu)

		local bg = F.CreateBDFrame(bu, .25)
		bg:SetPoint("TOPLEFT", 2.8, -1.8)
		bg:SetPoint("BOTTOMRIGHT", -2.8, 3.8)

		local ic = bu.iconTexture
		ic:SetTexCoord(.08, .92, .08, .92)

		local cd = bu.cooldown
		cd:SetAllPoints(ic)

		bu:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)
		bu:GetHighlightTexture():SetAllPoints(ic)

		hooksecurefunc(bu.name, "SetTextColor", changeTextColor)
	end

	-- [[ Heirlooms ]]
	local icons = HeirloomsJournal.iconsFrame
	F.StripTextures(icons, true)
	F.ReskinInput(HeirloomsJournalSearchBox)
	F.ReskinDropDown(HeirloomsJournalClassDropDown)
	F.ReskinFilterButton(HeirloomsJournalFilterButton)
	F.ReskinArrow(HeirloomsJournal.PagingFrame.PrevPageButton, "left")
	F.ReskinArrow(HeirloomsJournal.PagingFrame.NextPageButton, "right")

	hooksecurefunc(HeirloomsJournal, "UpdateButton", function(_, button)
		button.level:SetFontObject("GameFontWhiteSmall")
		button.special:SetTextColor(1, .8, 0)
	end)

	-- Progress bar
	local progressBar = HeirloomsJournal.progressBar
	progressBar.text:SetPoint("CENTER")
	F.ReskinStatusBar(progressBar, true, true)

	-- Buttons
	hooksecurefunc("HeirloomsJournal_UpdateButton", function(button)
		if not button.styled then
			local ic = button.iconTexture
			F.StripTextures(button)

			button.levelBackground:SetAlpha(0)
			button:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)
			button:GetHighlightTexture():SetAllPoints(ic)

			button.iconTextureUncollected:SetTexCoord(.08, .92, .08, .92)
			button.bg = F.CreateBDFrame(ic)

			button.level:ClearAllPoints()
			button.level:SetPoint("BOTTOM", 0, 1)

			local newLevelBg = button:CreateTexture(nil, "OVERLAY")
			newLevelBg:SetColorTexture(0, 0, 0, .5)
			newLevelBg:SetPoint("BOTTOMLEFT", button, "BOTTOMLEFT", 4, 5)
			newLevelBg:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -4, 5)
			newLevelBg:SetHeight(11)
			button.newLevelBg = newLevelBg

			button.styled = true
		end

		if button.iconTexture:IsShown() then
			button.name:SetTextColor(1, 1, 1)
			button.bg:SetBackdropBorderColor(0, .8, 1)
			button.bg.Shadow:SetBackdropBorderColor(0, .8, 1)
			button.newLevelBg:Show()
		else
			button.name:SetTextColor(.5, .5, .5)
			button.bg:SetBackdropBorderColor(0, 0, 0)
			button.bg.Shadow:SetBackdropBorderColor(0, 0, 0)
			button.newLevelBg:Hide()
		end
	end)

	hooksecurefunc(HeirloomsJournal, "LayoutCurrentPage", function()
		for i = 1, #HeirloomsJournal.heirloomHeaderFrames do
			local header = HeirloomsJournal.heirloomHeaderFrames[i]
			if not header.styled then
				header.text:SetTextColor(1, 1, 1)
				header.text:SetFont(C.media.font, 16, "OUTLINE")

				header.styled = true
			end
		end

		for i = 1, #HeirloomsJournal.heirloomEntryFrames do
			local button = HeirloomsJournal.heirloomEntryFrames[i]

			if button.iconTexture:IsShown() then
				button.name:SetTextColor(1, 1, 1)
				button.bg:SetBackdropBorderColor(0, .8, 1)
				button.bg.Shadow:SetBackdropBorderColor(0, .8, 1)
				button.newLevelBg:Show()
			else
				button.name:SetTextColor(.5, .5, .5)
				button.bg:SetBackdropBorderColor(0, 0, 0)
				button.bg.Shadow:SetBackdropBorderColor(0, 0, 0)
				button.newLevelBg:Hide()
			end
		end
	end)

	-- [[ WardrobeCollectionFrame ]]
	local ItemsCollectionFrame = WardrobeCollectionFrame.ItemsCollectionFrame
	F.StripTextures(ItemsCollectionFrame, true)
	F.ReskinFilterButton(WardrobeCollectionFrame.FilterButton)
	F.ReskinDropDown(WardrobeCollectionFrameWeaponDropDown)
	F.ReskinInput(WardrobeCollectionFrameSearchBox)

	WardrobeCollectionFrame.FilterButton:ClearAllPoints()
	WardrobeCollectionFrame.FilterButton:SetPoint("LEFT", WardrobeCollectionFrameSearchBox, "RIGHT", 2, 0)

	for index = 1, 2 do
		local tab = _G["WardrobeCollectionFrameTab"..index]
		for i = 1, 6 do
			select(i, tab:GetRegions()):SetAlpha(0)
		end
		tab:SetHighlightTexture("")
		tab.bg = F.CreateBDFrame(tab, .25)
		tab.bg:SetPoint("TOPLEFT", 3, -3)
		tab.bg:SetPoint("BOTTOMRIGHT", -3, -1)
	end

	hooksecurefunc("WardrobeCollectionFrame_SetTab", function(tabID)
		for index = 1, 2 do
			local tab = _G["WardrobeCollectionFrameTab"..index]
			if tabID == index then
				tab.bg:SetBackdropColor(r, g, b, .25)
			else
				tab.bg:SetBackdropColor(0, 0, 0, .25)
			end
		end
	end)

	F.ReskinArrow(ItemsCollectionFrame.PagingFrame.PrevPageButton, "left")
	F.ReskinArrow(ItemsCollectionFrame.PagingFrame.NextPageButton, "right")

	local progressBar = WardrobeCollectionFrame.progressBar
	progressBar.text:SetPoint("CENTER")
	F.ReskinStatusBar(progressBar, true, true)

	-- ItemSetsCollection
	local SetsCollectionFrame = WardrobeCollectionFrame.SetsCollectionFrame
	F.StripTextures(SetsCollectionFrame, true)
	SetsCollectionFrame.LeftInset:Hide()
	SetsCollectionFrame.RightInset:Hide()
	F.CreateBDFrame(SetsCollectionFrame.Model, .25)

	local ScrollFrame = SetsCollectionFrame.ScrollFrame
	F.ReskinScroll(ScrollFrame.scrollBar)
	for i = 1, #ScrollFrame.buttons do
		local bu = ScrollFrame.buttons[i]
		F.StripTextures(bu)

		local hl = bu.HighlightTexture
		hl:SetTexture(C.media.backdrop)
		hl:SetVertexColor(r, g, b, .25)
		hl:SetPoint("TOPLEFT", 1, -2)
		hl:SetPoint("BOTTOMRIGHT", -1, 2)

		local bar = bu.ProgressBar
		bar:SetTexture(C.media.backdrop)
		bar:SetVertexColor(r, g, b, .25)
		bar:SetPoint("TOPLEFT", 1, -2)
		bar:SetPoint("BOTTOMLEFT", -1, 2)

		bu.Icon:SetTexCoord(.08, .92, .08, .92)
		F.CreateBDFrame(bu.Icon)

		bu.SelectedTexture:SetColorTexture(r, g, b, .25)
		bu.SelectedTexture:SetPoint("TOPLEFT", 1, -2)
		bu.SelectedTexture:SetPoint("BOTTOMRIGHT", -1, 2)
		F.CreateBDFrame(bu.SelectedTexture, .25)
	end

	local DetailsFrame = SetsCollectionFrame.DetailsFrame
	F.StripTextures(DetailsFrame, true)
	F.ReskinFilterButton(DetailsFrame.VariantSetsButton, "Down")

	hooksecurefunc(SetsCollectionFrame, "SetItemFrameQuality", function(_, itemFrame)
		local ic = itemFrame.Icon
		if not ic.bg then
			itemFrame.IconBorder:Hide()
			ic:SetTexCoord(.08, .92, .08, .92)
			ic.bg = F.CreateBDFrame(ic)
		end

		if itemFrame.collected then
			local quality = C_TransmogCollection.GetSourceInfo(itemFrame.sourceID).quality
			local color = BAG_ITEM_QUALITY_COLORS[quality or 1]
			ic.bg:SetBackdropBorderColor(color.r, color.g, color.b)
			ic.bg.Shadow:SetBackdropBorderColor(color.r, color.g, color.b)
		else
			ic.bg:SetBackdropBorderColor(0, 0, 0)
			ic.bg.Shadow:SetBackdropBorderColor(0, 0, 0)
		end
	end)

	local SetsTransmogFrame = WardrobeCollectionFrame.SetsTransmogFrame
	F.StripTextures(SetsTransmogFrame, true)
	F.ReskinArrow(SetsTransmogFrame.PagingFrame.PrevPageButton, "left")
	F.ReskinArrow(SetsTransmogFrame.PagingFrame.NextPageButton, "right")

	-- [[ Wardrobe ]]
	F.StripTextures(WardrobeTransmogFrame, true)
	F.StripTextures(WardrobeTransmogFrame.Inset, true)
	F.ReskinPortraitFrame(WardrobeFrame)
	F.Reskin(WardrobeTransmogFrame.ApplyButton)
	F.Reskin(WardrobeTransmogFrame.Model.ClearAllPendingButton)
	F.Reskin(WardrobeOutfitDropDown.SaveButton)
	F.ReskinArrow(WardrobeTransmogFrame.SpecButton, "down")
	F.ReskinDropDown(WardrobeOutfitDropDown)
	F.StripTextures(WardrobeOutfitFrame, true)
	F.CreateBDFrame(WardrobeOutfitFrame, .25)

	WardrobeOutfitDropDown:SetHeight(32)
	WardrobeOutfitDropDown.SaveButton:SetPoint("LEFT", WardrobeOutfitDropDown, "RIGHT", -13, 2)
	WardrobeTransmogFrame.SpecButton:SetPoint("RIGHT", WardrobeTransmogFrame.ApplyButton, "LEFT", -3, 0)

	local slots = {"Head", "Shoulder", "Chest", "Waist", "Legs", "Feet", "Wrist", "Hands", "Back", "Shirt", "Tabard", "MainHand", "SecondaryHand"}
	for i = 1, #slots do
		local slot = WardrobeTransmogFrame.Model[slots[i].."Button"]
		if slot then
			slot.Border:Hide()
			slot.Icon:SetDrawLayer("BACKGROUND", 1)
			slot.Icon:SetTexCoord(.08, .92, .08, .92)
			local bg = F.CreateBDFrame(slot.Icon, .25)

			slot:SetHighlightTexture(C.media.backdrop)
			local hl = slot:GetHighlightTexture()
			hl:SetVertexColor(1, 1, 1, .25)
			hl:SetPoint("TOPLEFT", bg, 1, -1)
			hl:SetPoint("BOTTOMRIGHT", bg, -1, 1)
		end
	end

	-- Edit Frame
	F.StripTextures(WardrobeOutfitEditFrame, true)
	F.StripTextures(WardrobeOutfitEditFrame.EditBox, true)
	F.CreateBD(WardrobeOutfitEditFrame)
	F.CreateSD(WardrobeOutfitEditFrame)
	F.CreateBDFrame(WardrobeOutfitEditFrame.EditBox,.25)
	F.Reskin(WardrobeOutfitEditFrame.AcceptButton)
	F.Reskin(WardrobeOutfitEditFrame.CancelButton)
	F.Reskin(WardrobeOutfitEditFrame.DeleteButton)

	-- HPetBattleAny
	local reskinHPet
	CollectionsJournal:HookScript("OnShow", function()
		if not IsAddOnLoaded("HPetBattleAny") then return end
		if not reskinHPet then
			F.Reskin(HPetInitOpenButton)
			F.Reskin(HPetAllInfoButton)
			for i = 1, 9 do
				select(i, HPetAllInfoButton:GetRegions()):Hide()
			end

			if PetJournalBandageButton then
				PetJournalBandageButton:SetPushedTexture("")
				PetJournalBandageButton:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)
				PetJournalBandageButtonBorder:Hide()
				PetJournalBandageButtonIcon:SetTexCoord(.08, .92, .08, .92)
				PetJournalBandageButton:SetPoint("TOPRIGHT", PetJournalHealPetButton, "TOPLEFT", -3, 0)
				PetJournalBandageButton:SetPoint("BOTTOMLEFT", PetJournalHealPetButton, "BOTTOMLEFT", -35, 0)
				F.CreateBDFrame(PetJournalBandageButtonIcon, .25)
			end
			reskinHPet = true
		end
	end)
end

do
	-- HPetBattleAny
	local f = CreateFrame("Frame")
	f:RegisterEvent("PLAYER_ENTERING_WORLD")
	f:RegisterEvent("PET_BATTLE_OPENING_START")
	f:SetScript("OnEvent", function(_, event)
		if not IsAddOnLoaded("HPetBattleAny") then return end
		if event == "PLAYER_ENTERING_WORLD" then
			HPetOption:HookScript("OnShow", function(self)
				if not self.reskin then
					local bu = {"Reset", "Help", "UpdateStone"}
					for _, v in pairs(bu) do
						F.Reskin(_G["HPetOption"..v])
					end

					local box = {"Message", "OnlyInPetInfo", "MiniTip", "Sound", "FastForfeit", "OtherTooltip", "HighGlow", "AutoSaveAbility", "ShowBandageButton", "ShowHideID", "PetGrowInfo", "BreedIDStyle", "PetGreedInfo", "PetBreedInfo", "ShowBreedID", "EnemyAbility", "LockAbilitys", "ShowAbilitysName", "OtherAbility", "AllyAbility"}
					for _, v in pairs(box) do
						F.ReskinCheck(_G["HPetOption"..v])
					end
					F.ReskinSlider(_G["HPetOptionAbilitysScale"])
					F.ReskinInput(_G["HPetOptionScaleBox"])

					self.reskin = true
				end
			end)
			f:UnregisterEvent(event)
		elseif event == "PET_BATTLE_OPENING_START" then
			C_Timer.After(.01, function()
				if f.styled then return end
				for i = 1, 6 do
					local bu = HAbiFrameActiveEnemy.AbilityButtons[i]
					bu.NormalTexture:SetTexture(nil)
					bu.NormalTexture.SetTexture = F.dummy
					bu.Icon:SetTexCoord(.08, .92, .08, .92)
					local bg = F.CreateBDFrame(bu.Icon, .25)
					F.CreateSD(bg)
				end
				f.styled = true
			end)
			f:UnregisterEvent(event)
		end
	end)
end