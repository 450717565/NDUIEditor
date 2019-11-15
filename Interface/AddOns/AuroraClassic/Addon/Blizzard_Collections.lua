local F, C = unpack(select(2, ...))

C.themes["Blizzard_Collections"] = function()
	local cr, cg, cb = C.r, C.g, C.b

	-- [[ General ]]
	CollectionsJournal.bg = F.ReskinFrame(CollectionsJournal)
	F.SetupTabStyle(CollectionsJournal, 5)

	local filters = {HeirloomsJournalFilterButton, MountJournalFilterButton, PetJournalFilterButton, ToyBoxFilterButton, WardrobeCollectionFrame.FilterButton}
	for _, filter in pairs(filters) do
		F.ReskinFilter(filter)
	end

	local inputs = {HeirloomsJournalSearchBox, MountJournalSearchBox, PetJournalSearchBox, ToyBox.searchBox, WardrobeCollectionFrameSearchBox}
	for _, input in pairs(inputs) do
		F.ReskinInput(input)
	end

	local scrolls = {MountJournalListScrollFrameScrollBar, PetJournalListScrollFrameScrollBar, WardrobeCollectionFrameScrollFrameScrollBar}
	for _, scroll in pairs(scrolls) do
		F.ReskinScroll(scroll)
	end

	MountJournalFilterButton:ClearAllPoints()
	MountJournalFilterButton:SetPoint("LEFT", MountJournalSearchBox, "RIGHT", 2, 0)
	PetJournalFilterButton:ClearAllPoints()
	PetJournalFilterButton:SetPoint("LEFT", PetJournalSearchBox, "RIGHT", 2, 0)
	WardrobeCollectionFrame.FilterButton:ClearAllPoints()
	WardrobeCollectionFrame.FilterButton:SetPoint("LEFT", WardrobeCollectionFrameSearchBox, "RIGHT", 2, 0)

	local function reskinDrag(drag, point)
		drag.ActiveTexture:SetTexture(C.media.checked)
		F.ReskinTexture(drag, point)
	end

	local scrollFrames = {MountJournal.ListScrollFrame, PetJournal.listScroll, WardrobeCollectionFrame.SetsCollectionFrame.ScrollFrame}
	for _, scrollFrame in pairs(scrollFrames) do
		for i = 1, #scrollFrame.buttons do
			local bu = scrollFrame.buttons[i]
			F.StripTextures(bu)

			local bubg = F.CreateBDFrame(bu, 0, -C.mult)
			F.ReskinTexture(bu, bubg, true)

			local sl = bu.SelectedTexture or bu.selectedTexture
			F.ReskinTexture(sl, bubg, true)

			local ic = bu.Icon or bu.icon
			local icbg = F.ReskinIcon(ic)

			if bu.ProgressBar then
				local bar = bu.ProgressBar
				bar:SetTexture(C.media.bdTex)
				bar:SetVertexColor(cr, cg, cb, .25)
				bar:SetPoint("TOPLEFT", bubg, C.mult, -C.mult)
				bar:SetPoint("BOTTOMLEFT", bubg, -C.mult, C.mult)
			end

			if bu.DragButton then
				reskinDrag(bu.DragButton, icbg)
			end

			if bu.dragButton then
				reskinDrag(bu.dragButton, icbg)

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
	for _, list in pairs(lists) do
		F.StripTextures(list)
	end

	F.CreateBDFrame(MountJournal.MountDisplay.ModelScene, 0)
	F.ReskinButton(MountJournalMountButton)
	F.ReskinButton(PetJournalSummonButton)
	F.ReskinButton(PetJournalFindBattle)
	F.ReskinArrow(MountJournal.MountDisplay.ModelScene.RotateLeftButton, "left")
	F.ReskinArrow(MountJournal.MountDisplay.ModelScene.RotateRightButton, "right")
	F.ReskinIcon(MountJournal.MountDisplay.InfoButton.Icon)

	local function reskinButton(button)
		local bu = _G[button]
		F.CleanTextures(bu)

		local bd = _G[button.."Border"]
		bd:Hide()

		local icbg = F.ReskinIcon(_G[button.."IconTexture"])
		F.ReskinTexture(bu, icbg)
	end

	reskinButton("MountJournalSummonRandomFavoriteButton")
	reskinButton("PetJournalHealPetButton")
	reskinButton("PetJournalSummonRandomFavoritePetButton")

	PetJournalTutorialButton.Ring:Hide()
	PetJournalTutorialButton:SetPoint("TOPLEFT", -14, 14)
	MountJournalSummonRandomFavoriteButton:SetPoint("BOTTOMRIGHT", MountJournal.MountDisplay, "TOPRIGHT", 0, 4)
	PetJournalLoadoutBorderSlotHeaderText:SetParent(PetJournal)
	PetJournalLoadoutBorderSlotHeaderText:SetPoint("CENTER", PetJournalLoadoutBorderTop, "TOP", 0, 4)

	local function updateMountScroll()
		local buttons = MountJournal.ListScrollFrame.buttons
		for i = 1, #buttons do
			local bu = buttons[i]
			bu.favorite:SetAtlas("collections-icon-favorites")
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
							local color = BAG_ITEM_QUALITY_COLORS[(rarity-1) or 1]
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

	local TogglePlayer = MountJournal.MountDisplay.ModelScene.TogglePlayer
	F.ReskinCheck(TogglePlayer)
	TogglePlayer:SetSize(28, 28)

	local BottomLeftInset = MountJournal.BottomLeftInset
	F.StripTextures(BottomLeftInset)
	local bg = F.CreateBDFrame(BottomLeftInset, 0)
	bg:SetPoint("TOPLEFT", 3, -2)
	bg:SetPoint("BOTTOMRIGHT", -25, 2)

	local SlotButton = BottomLeftInset.SlotButton
	F.StripTextures(SlotButton)
	local icbg = F.ReskinIcon(SlotButton.ItemIcon)
	F.ReskinTexture(SlotButton, icbg)
	F.ReskinTexture(SlotButton.DragTargetHighlight, icbg)

	-- Pet PetCard
	local PetCard = PetJournalPetCard
	F.StripTextures(PetCard)
	F.CreateBDFrame(PetCard, 0)
	F.ReskinStatusBar(PetCard.xpBar, true)
	F.ReskinStatusBar(PetCard.HealthFrame.healthBar, true)

	PetCard.AbilitiesBG1:SetAlpha(0)
	PetCard.AbilitiesBG2:SetAlpha(0)
	PetCard.AbilitiesBG3:SetAlpha(0)

	local PetInfo = PetCard.PetInfo
	F.StripTextures(PetInfo)
	F.ReskinIcon(PetInfo.icon)
	F.ReskinBorder(PetInfo.qualityBorder, PetInfo.icon)
	PetInfo.level:SetTextColor(1, 1, 1)

	for i = 1, 6 do
		local bu = PetCard["spell"..i]
		local icbg = F.ReskinIcon(bu.icon)
		F.ReskinTexture(bu, icbg)
	end

	-- Pet loadout
	for i = 1, 3 do
		local bu = PetJournal.Loadout["Pet"..i]
		F.StripTextures(bu)
		F.ReskinBorder(bu.qualityBorder, bu.icon)
		F.ReskinStatusBar(bu.xpBar, true)
		F.ReskinStatusBar(bu.healthFrame.healthBar, true)

		local bubg = F.CreateBDFrame(bu, 0)
		bubg:SetPoint("TOPLEFT", 0, -4)
		bubg:SetPoint("BOTTOMRIGHT")

		local setButton = bu.setButton:GetRegions()
		F.ReskinTexture(setButton, bu.qualityBorder)

		local icbg = F.ReskinIcon(bu.icon)
		F.ReskinTexture(bu.dragButton, icbg)
		bu.level:SetTextColor(1, 1, 1)

		for j = 1, 3 do
			local spell = bu["spell"..j]
			spell:GetRegions():Hide()
			F.CleanTextures(spell)

			spell.FlyoutArrow:SetTexture(C.media.arrowDown)
			spell.FlyoutArrow:SetSize(8, 8)
			spell.FlyoutArrow:SetTexCoord(0, 1, 0, 1)

			local icbg = F.ReskinIcon(spell.icon)
			F.ReskinTexture(spell, icbg)
			F.ReskinTexed(spell.selected, icbg)
		end
	end

	F.StripTextures(PetJournal.SpellSelect)
	for i = 1, 2 do
		local bu = PetJournal.SpellSelect["Spell"..i]
		F.CleanTextures(bu)

		local icbg = F.ReskinIcon(bu.icon)
		F.ReskinTexture(bu, icbg)
		F.ReskinTexed(bu, icbg)
	end

	-- [[ Toy box ]]
	F.StripTextures(ToyBox.iconsFrame)
	F.ReskinArrow(ToyBox.PagingFrame.PrevPageButton, "left")
	F.ReskinArrow(ToyBox.PagingFrame.NextPageButton, "right")
	F.ReskinStatusBar(ToyBox.progressBar)

	-- Toys!
	local changed = true
	local function nameColor(name)
		if changed then
			changed = false

			local self = name:GetParent()
			if PlayerHasToy(self.itemID) then
				local _, _, quality = GetItemInfo(self.itemID)
				local color = BAG_ITEM_QUALITY_COLORS[quality or 1]
				if quality then
					name:SetTextColor(color.r, color.g, color.b)
				else
					name:SetTextColor(1, 1, 1)
				end
			else
				name:SetTextColor(.5, .5, .5)
			end

			changed = true
		end
	end

	local buttons = ToyBox.iconsFrame
	for i = 1, 18 do
		local button = buttons["spellButton"..i]
		F.StripTextures(button)

		local icbg = F.ReskinIcon(button.iconTexture)
		F.ReskinTexture(button, icbg)
		button.icbg = icbg

		local cooldown = button.cooldown
		cooldown:SetPoint("TOPLEFT", icbg, C.mult, -C.mult)
		cooldown:SetPoint("BOTTOMRIGHT", icbg, -C.mult, C.mult)

		hooksecurefunc(button.name, "SetTextColor", nameColor)
	end

	hooksecurefunc("ToyBox_UpdateButtons", function(self)
		for i = 1, 18 do
			local button = ToyBox.iconsFrame["spellButton"..i]
			if PlayerHasToy(button.itemID) then
				local quality = select(3, GetItemInfo(button.itemID))
				local color = BAG_ITEM_QUALITY_COLORS[quality or 1]

				if quality then
					button.icbg:SetBackdropBorderColor(color.r, color.g, color.b)
				else
					button.icbg:SetBackdropBorderColor(0, 0, 0)
				end
			else
				button.icbg:SetBackdropBorderColor(0, 0, 0)
			end
		end
	end)

	-- [[ Heirlooms ]]
	F.StripTextures(HeirloomsJournal.iconsFrame)
	F.ReskinDropDown(HeirloomsJournalClassDropDown)
	F.ReskinArrow(HeirloomsJournal.PagingFrame.PrevPageButton, "left")
	F.ReskinArrow(HeirloomsJournal.PagingFrame.NextPageButton, "right")
	F.ReskinStatusBar(HeirloomsJournal.progressBar)

	-- Buttons
	hooksecurefunc(HeirloomsJournal, "UpdateButton", function(_, button)
		if not button.styled then
			F.StripTextures(button)

			button.iconTextureUncollected:SetTexCoord(.08, .92, .08, .92)
			button.levelBackground:SetAlpha(0)
			button.level:ClearAllPoints()
			button.level:SetPoint("BOTTOM", 0, 1)

			local icbg = F.ReskinIcon(button.iconTexture)
			F.ReskinTexture(button, icbg)
			button.icbg = icbg

			local lvbg = button:CreateTexture(nil, "OVERLAY")
			lvbg:SetColorTexture(0, 0, 0, .5)
			lvbg:SetPoint("BOTTOMLEFT", button, "BOTTOMLEFT", 4, 5)
			lvbg:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -4, 5)
			lvbg:SetHeight(11)
			button.lvbg = lvbg

			button.styled = true
		end

		button.level:SetTextColor(1, 1, 1)
		button.special:SetTextColor(1, 1, 1)
		button.name:SetTextColor(.5, .5, .5)
		button.icbg:SetBackdropBorderColor(0, 0, 0)
		button.lvbg:Hide()

		if button.iconTexture:IsShown() then
			button.name:SetTextColor(0, .8, 1)
			button.icbg:SetBackdropBorderColor(0, .8, 1)
			button.lvbg:Show()
		end
	end)

	hooksecurefunc(HeirloomsJournal, "LayoutCurrentPage", function()
		for i = 1, #HeirloomsJournal.heirloomHeaderFrames do
			local header = HeirloomsJournal.heirloomHeaderFrames[i]
			if not header.styled then
				header.text:SetTextColor(1, .8, 0)
				header.text:SetFont(C.media.font, 16, "OUTLINE")

				header.styled = true
			end
		end
	end)

	-- [[ WardrobeCollectionFrame ]]
	local ItemsCollectionFrame = WardrobeCollectionFrame.ItemsCollectionFrame
	F.StripTextures(ItemsCollectionFrame)
	F.ReskinDropDown(WardrobeCollectionFrameWeaponDropDown)

	for index = 1, 2 do
		local tab = _G["WardrobeCollectionFrameTab"..index]
		F.StripTextures(tab)

		tab.bg = F.CreateBDFrame(tab, 0)
		tab.bg:SetPoint("TOPLEFT", 3, -3)
		tab.bg:SetPoint("BOTTOMRIGHT", -3, -1)
	end

	hooksecurefunc("WardrobeCollectionFrame_SetTab", function(tabID)
		for index = 1, 2 do
			local tab = _G["WardrobeCollectionFrameTab"..index]
			if tabID == index then
				tab.bg:SetBackdropColor(cr, cg, cb, .25)
			else
				tab.bg:SetBackdropColor(0, 0, 0, 0)
			end
		end
	end)

	F.ReskinArrow(ItemsCollectionFrame.PagingFrame.PrevPageButton, "left")
	F.ReskinArrow(ItemsCollectionFrame.PagingFrame.NextPageButton, "right")
	F.ReskinStatusBar(WardrobeCollectionFrame.progressBar)

	-- ItemSetsCollection
	local SetsCollectionFrame = WardrobeCollectionFrame.SetsCollectionFrame
	F.StripTextures(SetsCollectionFrame)
	local bg = F.CreateBDFrame(SetsCollectionFrame.Model, 0)
	SetsCollectionFrame.bg = bg

	local DetailsFrame = SetsCollectionFrame.DetailsFrame
	F.StripTextures(DetailsFrame)
	F.ReskinFilter(DetailsFrame.VariantSetsButton, "Down")

	hooksecurefunc(SetsCollectionFrame, "Refresh", function()
		if DetailsFrame.LimitedSet:IsShown() then
			SetsCollectionFrame.bg:SetBackdropBorderColor(1, .5, .2)
		else
			SetsCollectionFrame.bg:SetBackdropBorderColor(0, 0, 0)
		end
	end)

	hooksecurefunc(SetsCollectionFrame, "SetItemFrameQuality", function(_, itemFrame)
		local ic = itemFrame.Icon

		if not ic.bg then
			itemFrame.IconBorder:Hide()
			ic.bg = F.ReskinIcon(ic)
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
	F.StripTextures(SetsTransmogFrame)
	F.ReskinArrow(SetsTransmogFrame.PagingFrame.PrevPageButton, "left")
	F.ReskinArrow(SetsTransmogFrame.PagingFrame.NextPageButton, "right")

	-- [[ Wardrobe ]]
	F.ReskinFrame(WardrobeFrame)
	F.StripTextures(WardrobeTransmogFrame)
	F.StripTextures(WardrobeOutfitFrame)
	F.CreateBDFrame(WardrobeOutfitFrame, .25, nil, true)
	F.ReskinButton(WardrobeTransmogFrame.ApplyButton)
	F.ReskinButton(WardrobeOutfitDropDown.SaveButton)
	F.ReskinArrow(WardrobeTransmogFrame.SpecButton, "down")
	F.ReskinDropDown(WardrobeOutfitDropDown)

	WardrobeOutfitDropDown:SetHeight(32)
	WardrobeOutfitDropDown.SaveButton:SetPoint("LEFT", WardrobeOutfitDropDown, "RIGHT", -13, 2)
	WardrobeTransmogFrame.SpecButton:SetPoint("RIGHT", WardrobeTransmogFrame.ApplyButton, "LEFT", -3, 0)

	local ModelScene = C.isNewPatch and WardrobeTransmogFrame.ModelScene or WardrobeTransmogFrame.Model
	F.ReskinButton(ModelScene.ClearAllPendingButton)

	local slots = {"Head", "Shoulder", "Back", "Chest", "Shirt", "Tabard", "Wrist", "Hands", "Waist", "Legs", "Feet", "MainHand", "SecondaryHand", "MainHandEnchant", "SecondaryHandEnchant"}
	for i = 1, #slots do
		local slot = ModelScene[slots[i].."Button"]
		if slot then
			slot.Border:Hide()

			local icbg = F.ReskinIcon(slot.Icon)
			F.ReskinTexture(slot, icbg)
		end
	end

	hooksecurefunc(WardrobeOutfitFrame, "Update", function(self)
		for i = 1, C_TransmogCollection.GetNumMaxOutfits() do
			local button = self.Buttons[i]
			if button and button:IsShown() and not button.styled then
				button.Selection:SetColorTexture(1, 1, 1, .25)
				button.Highlight:SetColorTexture(cr, cg, cb, .25)

				button.styled = true
			end
		end
	end)

	-- Edit Frame
	F.ReskinFrame(WardrobeOutfitEditFrame)
	F.StripTextures(WardrobeOutfitEditFrame.EditBox)
	F.CreateBDFrame(WardrobeOutfitEditFrame.EditBox,.25)
	F.ReskinButton(WardrobeOutfitEditFrame.AcceptButton)
	F.ReskinButton(WardrobeOutfitEditFrame.CancelButton)
	F.ReskinButton(WardrobeOutfitEditFrame.DeleteButton)

	-- HPetBattleAny
	CollectionsJournal:HookScript("OnShow", function(self)
		if not IsAddOnLoaded("HPetBattleAny") then return end
		if not self.styled then
			F.ReskinButton(HPetInitOpenButton)
			F.ReskinButton(HPetAllInfoButton)
			for i = 1, 9 do
				select(i, HPetAllInfoButton:GetRegions()):Hide()
			end

			if PetJournalBandageButton then
				PetJournalBandageButton:SetPoint("TOPRIGHT", PetJournalHealPetButton, "TOPLEFT", -3, 0)
				PetJournalBandageButton:SetPoint("BOTTOMLEFT", PetJournalHealPetButton, "BOTTOMLEFT", -35, 0)
				PetJournalBandageButtonBorder:Hide()
				F.CleanTextures(PetJournalBandageButton)

				local icbg = F.ReskinIcon(PetJournalBandageButtonIcon)
				F.ReskinTexture(PetJournalBandageButton, icbg)
			end

			self.styled = true
		end
	end)
end