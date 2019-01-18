local F, C = unpack(select(2, ...))

C.themes["Blizzard_Collections"] = function()
	local r, g, b = C.r, C.g, C.b

	-- [[ General ]]
	F.ReskinFrame(CollectionsJournal)

	for i = 1, 5 do
		local tab = _G["CollectionsJournalTab"..i]
		F.ReskinTab(tab)

		if i ~= 1 then
			tab:SetPoint("LEFT", _G["CollectionsJournalTab"..i-1], "RIGHT", -15, 0)
		end
	end

	F.ReskinFilterButton(HeirloomsJournalFilterButton)
	F.ReskinFilterButton(MountJournalFilterButton)
	F.ReskinFilterButton(PetJournalFilterButton)
	F.ReskinFilterButton(ToyBoxFilterButton)
	F.ReskinFilterButton(WardrobeCollectionFrame.FilterButton)

	F.ReskinInput(HeirloomsJournalSearchBox)
	F.ReskinInput(MountJournalSearchBox)
	F.ReskinInput(PetJournalSearchBox)
	F.ReskinInput(ToyBox.searchBox)
	F.ReskinInput(WardrobeCollectionFrameSearchBox)

	F.ReskinScroll(MountJournalListScrollFrameScrollBar)
	F.ReskinScroll(PetJournalListScrollFrameScrollBar)
	F.ReskinScroll(WardrobeCollectionFrameScrollFrameScrollBar)

	MountJournalFilterButton:ClearAllPoints()
	MountJournalFilterButton:SetPoint("LEFT", MountJournalSearchBox, "RIGHT", 2, 0)
	PetJournalFilterButton:ClearAllPoints()
	PetJournalFilterButton:SetPoint("LEFT", PetJournalSearchBox, "RIGHT", 2, 0)
	WardrobeCollectionFrame.FilterButton:ClearAllPoints()
	WardrobeCollectionFrame.FilterButton:SetPoint("LEFT", WardrobeCollectionFrameSearchBox, "RIGHT", 2, 0)

	local function reskinDrag(drag, point)
		drag.ActiveTexture:SetTexture(C.media.checked)
		drag:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)
		drag:GetHighlightTexture():SetAllPoints(point)
	end

	local scrollFrames = {MountJournal.ListScrollFrame, PetJournal.listScroll, WardrobeCollectionFrame.SetsCollectionFrame.ScrollFrame}
	for _, scrollFrame in pairs(scrollFrames) do
		for i = 1, #scrollFrame.buttons do
			local bu = scrollFrame.buttons[i]
			F.StripTextures(bu)

			local bg = F.CreateBDFrame(bu, .25)
			bg:SetPoint("TOPLEFT", C.mult, -C.mult)
			bg:SetPoint("BOTTOMRIGHT", -C.mult, C.mult)

			F.ReskinTexture(bu, bg, true)
			F.ReskinTexture(bu.HighlightTexture, bg, true)

			local sl = bu.SelectedTexture or bu.selectedTexture
			F.ReskinTexture(sl, bg, true)

			local ic = bu.Icon or bu.icon
			F.ReskinIcon(ic, true)

			if bu.ProgressBar then
				local bar = bu.ProgressBar
				bar:SetTexture(C.media.bdTex)
				bar:SetVertexColor(r, g, b, .25)
				bar:SetPoint("TOPLEFT", bg, C.mult, -C.mult)
				bar:SetPoint("BOTTOMLEFT", bg, -C.mult, C.mult)
			end

			if bu.DragButton then
				reskinDrag(bu.DragButton, ic)

				bu.DragButton.favorites = bu.DragButton:CreateTexture(nil, "ARTWORK")
				bu.DragButton.favorites:SetAtlas("collections-icon-favorites")
				bu.DragButton.favorites:SetSize(30, 30)
				bu.DragButton.favorites:SetPoint("TOPLEFT", -10, 8)
			end

			if bu.dragButton then
				reskinDrag(bu.dragButton, ic)

				bu.dragButton.levelBG:SetAlpha(0)
				bu.dragButton.level:SetTextColor(1, 1, 1)
			end
		end
	end

	-- [[ Mounts and pets ]]
	if AuroraConfig.tooltips then
		F.ReskinTooltip(PetJournalPrimaryAbilityTooltip)
		F.ReskinTooltip(PetJournalSecondaryAbilityTooltip)
	end

	local lists = {PetJournal, PetJournal.PetCount, PetJournal.PetCardInset, PetJournal.loadoutBorder, MountJournal, MountJournal.MountCount, MountJournal.MountDisplay, MountJournal.MountDisplay.ShadowOverlay}
	for _, list in next, lists do
		F.StripTextures(list, true)
	end

	F.CreateBDFrame(MountJournal.MountCount, .25)
	F.CreateBDFrame(PetJournal.PetCount, .25)
	F.CreateBDFrame(MountJournal.MountDisplay.ModelScene, .25)

	F.ReskinButton(MountJournalMountButton)
	F.ReskinButton(PetJournalSummonButton)
	F.ReskinButton(PetJournalFindBattle)

	F.ReskinArrow(MountJournal.MountDisplay.ModelScene.RotateLeftButton, "left")
	F.ReskinArrow(MountJournal.MountDisplay.ModelScene.RotateRightButton, "right")

	F.ReskinIcon(MountJournal.MountDisplay.InfoButton.Icon, true)

	local function reskinButton(button)
		local bu = _G[button]
		bu:SetPushedTexture("")

		local bd = _G[button.."Border"]
		bd:Hide()

		local ic = F.ReskinIcon(_G[button.."IconTexture"], true)
		F.ReskinTexture(bu, ic, false)
	end

	reskinButton("MountJournalSummonRandomFavoriteButton")
	reskinButton("PetJournalHealPetButton")
	reskinButton("PetJournalSummonRandomFavoritePetButton")

	PetJournalTutorialButton:SetPoint("TOPLEFT", -14, 14)
	MountJournalSummonRandomFavoriteButton:SetPoint("BOTTOMRIGHT", MountJournal.MountDisplay, "TOPRIGHT", 0, 4)
	PetJournalLoadoutBorderSlotHeaderText:SetParent(PetJournal)
	PetJournalLoadoutBorderSlotHeaderText:SetPoint("CENTER", PetJournalLoadoutBorderTop, "TOP", 0, 4)

	local function updateMountScroll()
		local buttons = MountJournal.ListScrollFrame.buttons
		for i = 1, #buttons do
			local bu = buttons[i]
			bu.DragButton.favorites:SetShown(bu.favorite:IsShown())
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
				end
			end
		end
	end

	hooksecurefunc("PetJournal_UpdatePetList", updatePetScroll)
	hooksecurefunc(PetJournalListScrollFrame, "update", updatePetScroll)

	-- Pet card
	local card = PetJournalPetCard
	F.StripTextures(card, true)
	F.CreateBDFrame(card, .25)
	F.StripTextures(card.PetInfo)

	card.AbilitiesBG1:SetAlpha(0)
	card.AbilitiesBG2:SetAlpha(0)
	card.AbilitiesBG3:SetAlpha(0)

	card.PetInfo.level:SetTextColor(1, 1, 1)

	card.PetInfo.icon.bg = F.ReskinIcon(card.PetInfo.icon, true)

	F.ReskinStatusBar(card.xpBar, false, true)
	F.ReskinStatusBar(card.HealthFrame.healthBar, false, true)

	for i = 1, 6 do
		local bu = card["spell"..i]
		F.ReskinIcon(bu.icon, true)
	end

	hooksecurefunc("PetJournal_UpdatePetCard", function(self)
		local border = self.PetInfo.qualityBorder
		local r, g, b = 0, 0, 0

		if border:IsShown() then
			r, g, b = self.PetInfo.qualityBorder:GetVertexColor()
		end
		self.PetInfo.icon.bg:SetBackdropBorderColor(r, g, b)
	end)

	-- Pet loadout
	for i = 1, 3 do
		local bu = PetJournal.Loadout["Pet"..i]
		F.StripTextures(bu)

		local bg = F.CreateBDFrame(bu, .25)
		bg:SetPoint("TOPLEFT", 0, -4)
		bg:SetPoint("BOTTOMRIGHT")

		bu.dragButton:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)
		bu.level:SetTextColor(1, 1, 1)
		bu.setButton:GetRegions():SetPoint("TOPLEFT", bu.icon, -5, 5)
		bu.setButton:GetRegions():SetPoint("BOTTOMRIGHT", bu.icon, 5, -5)
		bu.icon.bg = F.ReskinIcon(bu.icon, true)

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

			F.ReskinIcon(spell.icon, true)
		end
	end

	hooksecurefunc("PetJournal_UpdatePetLoadOut", function()
		for i = 1, 3 do
			local bu = PetJournal.Loadout["Pet"..i]
			local r, g, b = bu.qualityBorder:GetVertexColor()

			bu.icon.bg:SetShown(not bu.helpFrame:IsShown())
			bu.icon.bg:SetBackdropBorderColor(r, g, b)

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
		F.ReskinIcon(bu.icon, true)
	end

	-- [[ Toy box ]]
	F.StripTextures(ToyBox.iconsFrame, true)
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

		local ic = F.ReskinIcon(bu.iconTexture, true)
		F.ReskinTexture(bu, ic, false)

		local cd = bu.cooldown
		cd:SetAllPoints(ic)

		hooksecurefunc(bu.name, "SetTextColor", changeTextColor)
	end

	-- [[ Heirlooms ]]
	F.StripTextures(HeirloomsJournal.iconsFrame, true)
	F.ReskinDropDown(HeirloomsJournalClassDropDown)
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
			F.StripTextures(button)

			button.iconTextureUncollected:SetTexCoord(.08, .92, .08, .92)
			button.levelBackground:SetAlpha(0)
			button.level:ClearAllPoints()
			button.level:SetPoint("BOTTOM", 0, 1)

			local bg = F.ReskinIcon(button.iconTexture, true)
			F.ReskinTexture(button, bg, false)

			local newLevelBg = button:CreateTexture(nil, "OVERLAY")
			newLevelBg:SetColorTexture(0, 0, 0, .5)
			newLevelBg:SetPoint("BOTTOMLEFT", button, "BOTTOMLEFT", 4, 5)
			newLevelBg:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -4, 5)
			newLevelBg:SetHeight(11)

			button.bg = bg
			button.newLevelBg = newLevelBg

			button.styled = true
		end

		if button.iconTexture:IsShown() then
			button.name:SetTextColor(1, 1, 1)
			button.bg:SetBackdropBorderColor(0, .8, 1)
			button.newLevelBg:Show()
		else
			button.name:SetTextColor(.5, .5, .5)
			button.bg:SetBackdropBorderColor(0, 0, 0)
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
				if button.bg then
					button.bg:SetBackdropBorderColor(0, .8, 1)
				end
				if button.newLevelBg then button.newLevelBg:Show() end
			else
				button.name:SetTextColor(.5, .5, .5)
				if button.bg then
					button.bg:SetBackdropBorderColor(0, 0, 0)
				end
				if button.newLevelBg then button.newLevelBg:Hide() end
			end
		end
	end)

	-- [[ WardrobeCollectionFrame ]]
	local ItemsCollectionFrame = WardrobeCollectionFrame.ItemsCollectionFrame
	F.StripTextures(ItemsCollectionFrame, true)
	F.ReskinDropDown(WardrobeCollectionFrameWeaponDropDown)

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
	F.CreateBDFrame(SetsCollectionFrame.Model, .25)

	local DetailsFrame = SetsCollectionFrame.DetailsFrame
	F.StripTextures(DetailsFrame, true)
	F.ReskinFilterButton(DetailsFrame.VariantSetsButton, "Down")

	hooksecurefunc(SetsCollectionFrame, "SetItemFrameQuality", function(_, itemFrame)
		local ic = itemFrame.Icon
		if not ic.bg then
			itemFrame.IconBorder:Hide()
			ic.bg = F.ReskinIcon(ic, true)
		end

		if itemFrame.collected then
			local quality = C_TransmogCollection.GetSourceInfo(itemFrame.sourceID).quality
			local color = BAG_ITEM_QUALITY_COLORS[quality or 1]
			ic.bg:SetBackdropBorderColor(color.r, color.g, color.b)
		else
			ic.bg:SetBackdropBorderColor(0, 0, 0)
		end
	end)

	local SetsTransmogFrame = WardrobeCollectionFrame.SetsTransmogFrame
	F.StripTextures(SetsTransmogFrame, true)
	F.ReskinArrow(SetsTransmogFrame.PagingFrame.PrevPageButton, "left")
	F.ReskinArrow(SetsTransmogFrame.PagingFrame.NextPageButton, "right")

	-- [[ Wardrobe ]]
	F.ReskinFrame(WardrobeFrame)
	F.StripTextures(WardrobeTransmogFrame, true)
	F.StripTextures(WardrobeOutfitFrame, true)
	F.CreateBDFrame(WardrobeOutfitFrame, .25)
	F.ReskinButton(WardrobeTransmogFrame.ApplyButton)
	F.ReskinButton(WardrobeTransmogFrame.Model.ClearAllPendingButton)
	F.ReskinButton(WardrobeOutfitDropDown.SaveButton)
	F.ReskinArrow(WardrobeTransmogFrame.SpecButton, "down")
	F.ReskinDropDown(WardrobeOutfitDropDown)

	WardrobeOutfitDropDown:SetHeight(32)
	WardrobeOutfitDropDown.SaveButton:SetPoint("LEFT", WardrobeOutfitDropDown, "RIGHT", -13, 2)
	WardrobeTransmogFrame.SpecButton:SetPoint("RIGHT", WardrobeTransmogFrame.ApplyButton, "LEFT", -3, 0)

	local slots = {"Head", "Shoulder", "Chest", "Waist", "Legs", "Feet", "Wrist", "Hands", "Back", "Shirt", "Tabard", "MainHand", "SecondaryHand"}
	for i = 1, #slots do
		local slot = WardrobeTransmogFrame.Model[slots[i].."Button"]
		if slot then
			slot.Border:Hide()
			slot.Icon:SetDrawLayer("BACKGROUND", 1)
			local bg = F.ReskinIcon(slot.Icon, true)

			F.ReskinTexture(slot, bg, false)
		end
	end

	-- Edit Frame
	F.ReskinFrame(WardrobeOutfitEditFrame)
	F.StripTextures(WardrobeOutfitEditFrame.EditBox, true)
	F.CreateBDFrame(WardrobeOutfitEditFrame.EditBox,.25)
	F.ReskinButton(WardrobeOutfitEditFrame.AcceptButton)
	F.ReskinButton(WardrobeOutfitEditFrame.CancelButton)
	F.ReskinButton(WardrobeOutfitEditFrame.DeleteButton)

	-- HPetBattleAny
	local reskinHPet
	CollectionsJournal:HookScript("OnShow", function()
		if not IsAddOnLoaded("HPetBattleAny") then return end
		if not reskinHPet then
			F.ReskinButton(HPetInitOpenButton)
			F.ReskinButton(HPetAllInfoButton)
			for i = 1, 9 do
				select(i, HPetAllInfoButton:GetRegions()):Hide()
			end

			if PetJournalBandageButton then
				PetJournalBandageButton:SetPushedTexture("")
				PetJournalBandageButton:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)
				PetJournalBandageButton:SetPoint("TOPRIGHT", PetJournalHealPetButton, "TOPLEFT", -3, 0)
				PetJournalBandageButton:SetPoint("BOTTOMLEFT", PetJournalHealPetButton, "BOTTOMLEFT", -35, 0)
				PetJournalBandageButtonBorder:Hide()
				F.ReskinIcon(PetJournalBandageButtonIcon, true)
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
						F.ReskinButton(_G["HPetOption"..v])
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
					F.ReskinIcon(bu.Icon, true)
				end
				f.styled = true
			end)
			f:UnregisterEvent(event)
		end
	end)
end