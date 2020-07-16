local B, C, L, DB = unpack(select(2, ...))

C.themes["Blizzard_Collections"] = function()
	local cr, cg, cb = DB.r, DB.g, DB.b

	-- [[ General ]]
	CollectionsJournal.bg = B.ReskinFrame(CollectionsJournal)
	B.SetupTabStyle(CollectionsJournal, 5)

	local filters = {HeirloomsJournalFilterButton, MountJournalFilterButton, PetJournalFilterButton, ToyBoxFilterButton, WardrobeCollectionFrame.FilterButton}
	for _, filter in pairs(filters) do
		B.ReskinFilter(filter)
	end

	local inputs = {HeirloomsJournalSearchBox, MountJournalSearchBox, PetJournalSearchBox, ToyBox.searchBox, WardrobeCollectionFrameSearchBox}
	for _, input in pairs(inputs) do
		B.ReskinInput(input)
	end

	local scrolls = {MountJournalListScrollFrameScrollBar, PetJournalListScrollFrameScrollBar, WardrobeCollectionFrameScrollFrameScrollBar}
	for _, scroll in pairs(scrolls) do
		B.ReskinScroll(scroll)
	end

	MountJournalFilterButton:ClearAllPoints()
	MountJournalFilterButton:SetPoint("LEFT", MountJournalSearchBox, "RIGHT", 2, 0)
	PetJournalFilterButton:ClearAllPoints()
	PetJournalFilterButton:SetPoint("LEFT", PetJournalSearchBox, "RIGHT", 2, 0)
	WardrobeCollectionFrame.FilterButton:ClearAllPoints()
	WardrobeCollectionFrame.FilterButton:SetPoint("LEFT", WardrobeCollectionFrameSearchBox, "RIGHT", 2, 0)

	local function reskinDrag(drag, point)
		drag.ActiveTexture:SetTexture(DB.checked)
		B.ReskinHighlight(drag, point)
	end

	local scrollFrames = {MountJournal.ListScrollFrame, PetJournal.listScroll, WardrobeCollectionFrame.SetsCollectionFrame.ScrollFrame}
	for _, scrollFrame in pairs(scrollFrames) do
		for i = 1, #scrollFrame.buttons do
			local bu = scrollFrame.buttons[i]
			B.StripTextures(bu)

			local bubg = B.CreateBDFrame(bu, 0, -C.mult*2)
			B.ReskinHighlight(bu, bubg, true)

			local sl = bu.SelectedTexture or bu.selectedTexture
			B.ReskinHighlight(sl, bubg, true)

			local ic = bu.Icon or bu.icon
			local icbg = B.ReskinIcon(ic)

			if bu.ProgressBar then
				local bar = bu.ProgressBar
				bar:SetTexture(DB.bdTex)
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
	local lists = {PetJournal, PetJournal.PetCount, PetJournal.PetCardInset, PetJournal.loadoutBorder, MountJournal, MountJournal.MountCount, MountJournal.MountDisplay, MountJournal.MountDisplay.ShadowOverlay}
	for _, list in pairs(lists) do
		B.StripTextures(list)
	end

	B.CreateBDFrame(MountJournal.MountDisplay.ModelScene, 0)
	B.ReskinButton(MountJournalMountButton)
	B.ReskinButton(PetJournalSummonButton)
	B.ReskinButton(PetJournalFindBattle)
	B.ReskinArrow(MountJournal.MountDisplay.ModelScene.RotateLeftButton, "left")
	B.ReskinArrow(MountJournal.MountDisplay.ModelScene.RotateRightButton, "right")
	B.ReskinIcon(MountJournal.MountDisplay.InfoButton.Icon)

	local function reskinButton(button)
		local bu = _G[button]
		B.CleanTextures(bu)

		local bd = _G[button.."Border"]
		bd:Hide()

		local icbg = B.ReskinIcon(_G[button.."IconTexture"])
		B.ReskinHighlight(bu, icbg)
	end

	reskinButton("MountJournalSummonRandomFavoriteButton")
	reskinButton("PetJournalHealPetButton")
	reskinButton("PetJournalSummonRandomFavoritePetButton")

	PetJournalTutorialButton.Ring:Hide()
	PetJournalTutorialButton:ClearAllPoints()
	PetJournalTutorialButton:SetPoint("TOPLEFT", -14, 14)
	PetJournalHealPetButton:ClearAllPoints()
	PetJournalHealPetButton:SetPoint("BOTTOMRIGHT", PetJournalPetCard, "TOPRIGHT", 0, 4)
	MountJournalSummonRandomFavoriteButton:ClearAllPoints()
	MountJournalSummonRandomFavoriteButton:SetPoint("BOTTOMRIGHT", MountJournal.MountDisplay, "TOPRIGHT", 0, 4)
	PetJournalLoadoutBorderSlotHeaderText:ClearAllPoints()
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
							local r, g, b = GetItemQualityColor((rarity-1) or 1)
							bu.name:SetTextColor(r, g, b)
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
	B.ReskinCheck(TogglePlayer)
	TogglePlayer:SetSize(28, 28)

	local BottomLeftInset = MountJournal.BottomLeftInset
	B.StripTextures(BottomLeftInset)
	B.CreateBGFrame(BottomLeftInset, 3, -2, -25, 2)

	local SlotButton = BottomLeftInset.SlotButton
	B.StripTextures(SlotButton)
	local icbg = B.ReskinIcon(SlotButton.ItemIcon)
	B.ReskinHighlight(SlotButton, icbg)
	B.ReskinHighlight(SlotButton.DragTargetHighlight, icbg)

	-- Pet PetCard
	local PetCard = PetJournalPetCard
	B.StripTextures(PetCard)
	B.CreateBDFrame(PetCard, 0)
	B.ReskinStatusBar(PetCard.xpBar, true)
	B.ReskinStatusBar(PetCard.HealthFrame.healthBar, true)

	PetCard.AbilitiesBG1:SetAlpha(0)
	PetCard.AbilitiesBG2:SetAlpha(0)
	PetCard.AbilitiesBG3:SetAlpha(0)

	local PetInfo = PetCard.PetInfo
	B.StripTextures(PetInfo)
	local icbg = B.ReskinIcon(PetInfo.icon)
	B.ReskinIconBorder(PetInfo.qualityBorder, icbg)
	PetInfo.level:SetTextColor(1, 1, 1)

	for i = 1, 6 do
		local bu = PetCard["spell"..i]
		local icbg = B.ReskinIcon(bu.icon)
		B.ReskinHighlight(bu, icbg)
	end

	-- Pet loadout
	for i = 1, 3 do
		local bu = PetJournal.Loadout["Pet"..i]
		B.StripTextures(bu)
		B.CreateBGFrame(bu, 0, -4, 0, 0)
		B.ReskinStatusBar(bu.xpBar, true)
		B.ReskinStatusBar(bu.healthFrame.healthBar, true)

		local setButton = bu.setButton:GetRegions()
		B.ReskinHighlight(setButton, bu.qualityBorder)

		local icbg = B.ReskinIcon(bu.icon)
		B.ReskinHighlight(bu.dragButton, icbg)
		B.ReskinIconBorder(bu.qualityBorder, icbg)
		bu.level:SetTextColor(1, 1, 1)

		for j = 1, 3 do
			local spell = bu["spell"..j]
			spell:GetRegions():Hide()
			B.CleanTextures(spell)

			spell.FlyoutArrow:SetTexture(DB.arrowDown)
			spell.FlyoutArrow:SetSize(8, 8)
			spell.FlyoutArrow:SetTexCoord(0, 1, 0, 1)

			local icbg = B.ReskinIcon(spell.icon)
			B.ReskinHighlight(spell, icbg)
			B.ReskinChecked(spell.selected, icbg)
			spell.BlackCover:SetInside(icbg)
		end
	end

	B.StripTextures(PetJournal.SpellSelect)
	for i = 1, 2 do
		local bu = PetJournal.SpellSelect["Spell"..i]
		B.CleanTextures(bu)

		local icbg = B.ReskinIcon(bu.icon)
		B.ReskinHighlight(bu, icbg)
		B.ReskinChecked(bu, icbg)
	end

	-- [[ Toy box ]]
	B.StripTextures(ToyBox.iconsFrame)
	B.ReskinArrow(ToyBox.PagingFrame.PrevPageButton, "left")
	B.ReskinArrow(ToyBox.PagingFrame.NextPageButton, "right")
	B.ReskinStatusBar(ToyBox.progressBar)

	-- Toys!
	local changed = true
	local function nameColor(name)
		if changed then
			changed = false

			local self = name:GetParent()
			if PlayerHasToy(self.itemID) then
				local _, _, quality = GetItemInfo(self.itemID)
				local r, g, b = GetItemQualityColor(quality or 1)
				if quality then
					name:SetTextColor(r, g, b)
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
		B.StripTextures(button)

		local icbg = B.ReskinIcon(button.iconTexture)
		B.ReskinHighlight(button, icbg)
		button.icbg = icbg

		local cooldown = button.cooldown
		cooldown:SetInside(icbg)

		hooksecurefunc(button.name, "SetTextColor", nameColor)
	end

	hooksecurefunc("ToyBox_UpdateButtons", function(self)
		for i = 1, 18 do
			local button = ToyBox.iconsFrame["spellButton"..i]
			if PlayerHasToy(button.itemID) then
				local quality = select(3, GetItemInfo(button.itemID))
				local r, g, b = GetItemQualityColor(quality or 1)

				if quality then
					button.icbg:SetBackdropBorderColor(r, g, b)
				else
					button.icbg:SetBackdropBorderColor(0, 0, 0)
				end
			else
				button.icbg:SetBackdropBorderColor(0, 0, 0)
			end
		end
	end)

	-- [[ Heirlooms ]]
	B.StripTextures(HeirloomsJournal.iconsFrame)
	B.ReskinDropDown(HeirloomsJournalClassDropDown)
	B.ReskinArrow(HeirloomsJournal.PagingFrame.PrevPageButton, "left")
	B.ReskinArrow(HeirloomsJournal.PagingFrame.NextPageButton, "right")
	B.ReskinStatusBar(HeirloomsJournal.progressBar)

	-- Buttons
	hooksecurefunc(HeirloomsJournal, "UpdateButton", function(_, button)
		if not button.styled then
			B.StripTextures(button)

			button.iconTextureUncollected:SetTexCoord(unpack(DB.TexCoord))
			button.levelBackground:SetAlpha(0)

			local icbg = B.ReskinIcon(button.iconTexture)
			B.ReskinHighlight(button, icbg)
			button.icbg = icbg

			button.level:ClearAllPoints()
			button.level:SetPoint("BOTTOMRIGHT", icbg, -1, -1)
			button.level:SetJustifyH("RIGHT")

			button.styled = true
		end

		button.level:SetTextColor(1, 1, 1)
		button.special:SetTextColor(1, 1, 1)
		button.name:SetTextColor(.5, .5, .5)
		button.icbg:SetBackdropBorderColor(0, 0, 0)

		if button.iconTexture:IsShown() then
			button.name:SetTextColor(0, .8, 1)
			button.icbg:SetBackdropBorderColor(0, .8, 1)
		end
	end)

	hooksecurefunc(HeirloomsJournal, "LayoutCurrentPage", function()
		for i = 1, #HeirloomsJournal.heirloomHeaderFrames do
			local header = HeirloomsJournal.heirloomHeaderFrames[i]
			if not header.styled then
				header.text:SetTextColor(1, .8, 0)
				header.text:SetFont(DB.Font[1], 16, DB.Font[3])

				header.styled = true
			end
		end
	end)

	-- [[ WardrobeCollectionFrame ]]
	local ItemsCollectionFrame = WardrobeCollectionFrame.ItemsCollectionFrame
	B.StripTextures(ItemsCollectionFrame)
	B.ReskinDropDown(WardrobeCollectionFrameWeaponDropDown)

	for i = 1, 2 do
		local tab = _G["WardrobeCollectionFrameTab"..i]
		B.StripTextures(tab)

		tab.bg = B.CreateBDFrame(tab, 0, -3)
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

	B.ReskinArrow(ItemsCollectionFrame.PagingFrame.PrevPageButton, "left")
	B.ReskinArrow(ItemsCollectionFrame.PagingFrame.NextPageButton, "right")
	B.ReskinStatusBar(WardrobeCollectionFrame.progressBar)

	-- ItemSetsCollection
	local SetsCollectionFrame = WardrobeCollectionFrame.SetsCollectionFrame
	B.StripTextures(SetsCollectionFrame)
	local bg = B.CreateBDFrame(SetsCollectionFrame.Model, 0)
	SetsCollectionFrame.bg = bg

	local DetailsFrame = SetsCollectionFrame.DetailsFrame
	B.StripTextures(DetailsFrame)
	B.ReskinFilter(DetailsFrame.VariantSetsButton)

	hooksecurefunc(SetsCollectionFrame, "Refresh", function(self)
		if DetailsFrame.LimitedSet:IsShown() then
			self.bg:SetBackdropBorderColor(1, .5, .2)
		else
			self.bg:SetBackdropBorderColor(0, 0, 0)
		end
	end)

	hooksecurefunc(SetsCollectionFrame, "SetItemFrameQuality", function(_, itemFrame)
		local border = itemFrame.IconBorder
		border:SetAlpha(0)

		local icon = itemFrame.Icon
		if not icon.icbg then
			icon.icbg = B.ReskinIcon(icon)
		end

		if itemFrame.collected then
			local sourceInfo = C_TransmogCollection.GetSourceInfo(itemFrame.sourceID)
			local quality = sourceInfo.quality
			local r, g, b = GetItemQualityColor(quality or 1)
			icon.icbg:SetBackdropBorderColor(r, g, b)
		else
			icon.icbg:SetBackdropBorderColor(0, 0, 0)
		end
	end)

	local SetsTransmogFrame = WardrobeCollectionFrame.SetsTransmogFrame
	B.StripTextures(SetsTransmogFrame)
	B.ReskinArrow(SetsTransmogFrame.PagingFrame.PrevPageButton, "left")
	B.ReskinArrow(SetsTransmogFrame.PagingFrame.NextPageButton, "right")

	-- [[ Wardrobe ]]
	B.ReskinFrame(WardrobeFrame)
	B.ReskinFrame(WardrobeOutfitFrame)
	B.StripTextures(WardrobeTransmogFrame)
	B.ReskinButton(WardrobeTransmogFrame.ApplyButton)
	B.ReskinButton(WardrobeOutfitDropDown.SaveButton)
	B.ReskinArrow(WardrobeTransmogFrame.SpecButton, "down")
	B.ReskinDropDown(WardrobeOutfitDropDown)

	WardrobeOutfitDropDown:SetHeight(32)
	WardrobeOutfitDropDown.SaveButton:SetPoint("LEFT", WardrobeOutfitDropDown, "RIGHT", -13, 2)
	WardrobeTransmogFrame.SpecButton:SetPoint("RIGHT", WardrobeTransmogFrame.ApplyButton, "LEFT", -3, 0)

	local ModelScene = WardrobeTransmogFrame.ModelScene
	B.ReskinButton(ModelScene.ClearAllPendingButton)

	local slots = {"Head", "Neck", "Shoulder", "Shirt", "Chest", "Waist", "Legs", "Feet", "Wrist", "Hands", "Finger0", "Finger1", "Trinket0", "Trinket1", "Back", "MainHand", "SecondaryHand", "Tabard", "MainHandEnchant", "SecondaryHandEnchant"}
	for i = 1, #slots do
		local slot = ModelScene[slots[i].."Button"]
		if slot then
			slot.Border:Hide()

			local icbg = B.ReskinIcon(slot.Icon)
			B.ReskinHighlight(slot, icbg)
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
	B.ReskinFrame(WardrobeOutfitEditFrame)
	B.ReskinInput(WardrobeOutfitEditFrame.EditBox)
	B.ReskinButton(WardrobeOutfitEditFrame.AcceptButton)
	B.ReskinButton(WardrobeOutfitEditFrame.CancelButton)
	B.ReskinButton(WardrobeOutfitEditFrame.DeleteButton)

	-- HPetBattleAny
	CollectionsJournal:HookScript("OnShow", function(self)
		if not IsAddOnLoaded("HPetBattleAny") then return end
		if not self.styled then
			B.ReskinButton(HPetInitOpenButton)
			B.ReskinButton(HPetAllInfoButton)
			for i = 1, 9 do
				select(i, HPetAllInfoButton:GetRegions()):Hide()
			end

			if PetJournalBandageButton then
				PetJournalBandageButton:SetPoint("TOPRIGHT", PetJournalHealPetButton, "TOPLEFT", -3, 0)
				PetJournalBandageButton:SetPoint("BOTTOMLEFT", PetJournalHealPetButton, "BOTTOMLEFT", -35, 0)
				PetJournalBandageButtonBorder:Hide()
				B.CleanTextures(PetJournalBandageButton)

				local icbg = B.ReskinIcon(PetJournalBandageButtonIcon)
				B.ReskinHighlight(PetJournalBandageButton, icbg)
			end

			self.styled = true
		end
	end)
end