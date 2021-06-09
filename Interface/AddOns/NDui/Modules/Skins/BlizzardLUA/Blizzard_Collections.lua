local _, ns = ...
local B, C, L, DB = unpack(ns)
local S = B:GetModule("Skins")

local cr, cg, cb = DB.cr, DB.cg, DB.cb
local tL, tR, tT, tB = unpack(DB.TexCoord)

local function Reskin_Button(self)
	local button = _G[self]
	B.CleanTextures(button)

	local border = _G[self.."Border"]
	border:Hide()

	local icbg = B.ReskinIcon(_G[self.."IconTexture"])
	B.ReskinHLTex(button, icbg)
end

local function Update_MountList()
	local buttons = MountJournal.ListScrollFrame.buttons
	for i = 1, #buttons do
		local button = buttons[i]
		if button.DragButton then
			if button.DragButton.ActiveTexture and button.DragButton.ActiveTexture:IsShown() then
				button.icbg:SetBackdropBorderColor(cr, cg, cb)
				button.bubg:SetBackdropBorderColor(cr, cg, cb)
			else
				button.icbg:SetBackdropBorderColor(0, 0, 0)
				button.bubg:SetBackdropBorderColor(0, 0, 0)
			end
		end
	end
end

local function Update_PetList()
	local buttons = PetJournal.listScroll.buttons
	if buttons then
		for i = 1, #buttons do
			local button = buttons[i]
			if button.dragButton then
				if button.dragButton.ActiveTexture and button.dragButton.ActiveTexture:IsShown() then
					button.icbg:SetBackdropBorderColor(cr, cg, cb)
					button.bubg:SetBackdropBorderColor(cr, cg, cb)
				else
					button.icbg:SetBackdropBorderColor(0, 0, 0)
					button.bubg:SetBackdropBorderColor(0, 0, 0)
				end
			end

			local index = button.index
			if index then
				local petID, _, isOwned = C_PetJournal.GetPetInfoByIndex(index)
				if petID and isOwned then
					local _, _, _, _, rarity = C_PetJournal.GetPetStats(petID)
					local r, g, b = GetItemQualityColor((rarity-1) or 1)

					B.ReskinText(button.name, r, g, b)
				else
					B.ReskinText(button.name, .5, .5, .5)
				end
			end
		end
	end
end

local function Reskin_ToyBoxName(self)
	if self.isSetting then return end
	self.isSetting = true

	local button = self:GetParent()
	local itemID = button.itemID

	if PlayerHasToy(itemID) then
		local quality = select(3, GetItemInfo(itemID))
		local r, g, b = GetItemQualityColor(quality or 1)

		B.ReskinText(self, r, g, b)
	else
		B.ReskinText(self, .5, .5, .5)
	end

	self.isSetting = nil
end

local function Reskin_ToyBoxBorder()
	for i = 1, 18 do
		local button = ToyBox.iconsFrame["spellButton"..i]
		if PlayerHasToy(button.itemID) then
			local quality = select(3, GetItemInfo(button.itemID))
			local r, g, b = GetItemQualityColor(quality or 1)

			button.icbg:SetBackdropBorderColor(r, g, b)
		else
			button.icbg:SetBackdropBorderColor(0, 0, 0)
		end
	end
end

local function Reskin_UpdateButton(_, button)
	if not button.styled then
		B.StripTextures(button)

		button.iconTextureUncollected:SetTexCoord(tL, tR, tT, tB)
		button.levelBackground:SetAlpha(0)

		local icbg = B.ReskinIcon(button.iconTexture)
		B.ReskinHLTex(button, icbg)
		button.icbg = icbg

		button.level:ClearAllPoints()
		button.level:SetPoint("BOTTOMRIGHT", icbg, -1, -1)
		button.level:SetJustifyH("RIGHT")

		button.styled = true
	end

	B.ReskinText(button.level, 1, 1, 1)
	B.ReskinText(button.special, 1, 1, 1)
	B.ReskinText(button.name, .5, .5, .5)

	button.icbg:SetBackdropBorderColor(0, 0, 0)

	if button.iconTexture:IsShown() then
		B.ReskinText(button.name, 0, .8, 1)
		button.icbg:SetBackdropBorderColor(0, .8, 1)
	end
end

local function Reskin_LayoutCurrentPage()
	for i = 1, #HeirloomsJournal.heirloomHeaderFrames do
		local header = HeirloomsJournal.heirloomHeaderFrames[i]
		if header and not header.styled then
			header.text:SetFont(DB.Font[1], 16, DB.Font[3])
			B.ReskinText(header.text, 1, .8, 0)

			header.styled = true
		end
	end
end

local function Reskin_SetTab(tabID)
	for index = 1, 2 do
		local tab = _G["WardrobeCollectionFrameTab"..index]
		if tabID == index then
			tab.bg:SetBackdropColor(cr, cg, cb, .5)
		else
			tab.bg:SetBackdropColor(0, 0, 0, 0)
		end
	end
end

local function Reskin_Refresh(self)
	if WardrobeCollectionFrame.SetsCollectionFrame.DetailsFrame.LimitedSet:IsShown() then
		self.bg:SetBackdropBorderColor(1, .5, .2)
	else
		self.bg:SetBackdropBorderColor(0, 0, 0)
	end
end

local function Reskin_SetItemFrameQuality(_, itemFrame)
	local border = itemFrame.IconBorder
	border:SetAlpha(0)

	local icon = itemFrame.Icon
	if not itemFrame.icbg then
		itemFrame.icbg = B.ReskinIcon(icon)
	end

	if itemFrame.collected then
		local sourceInfo = C_TransmogCollection.GetSourceInfo(itemFrame.sourceID)
		local quality = sourceInfo.quality
		local r, g, b = GetItemQualityColor(quality or 1)

		itemFrame.icbg:SetBackdropBorderColor(r, g, b)
	else
		itemFrame.icbg:SetBackdropBorderColor(0, 0, 0)
	end
end

C.LUAThemes["Blizzard_Collections"] = function()
	-- [[ General ]]
	CollectionsJournal.bg = B.ReskinFrame(CollectionsJournal)
	B.ReskinFrameTab(CollectionsJournal, 5)

	local lists = {
		HeirloomsJournal.iconsFrame,
		MountJournal,
		MountJournal.MountCount,
		MountJournal.MountDisplay,
		MountJournal.MountDisplay.ShadowOverlay,
		PetJournal,
		PetJournal.loadoutBorder,
		PetJournal.PetCardInset,
		PetJournal.PetCount,
		PetJournal.SpellSelect,
		ToyBox.iconsFrame,
		WardrobeCollectionFrame.ItemsCollectionFrame,
		WardrobeCollectionFrame.SetsCollectionFrame,
		WardrobeCollectionFrame.SetsTransmogFrame,
		WardrobeTransmogFrame,
	}
	for _, list in pairs(lists) do
		B.StripTextures(list)
	end

	local buttons = {
		MountJournalMountButton,
		PetJournalFindBattle,
		PetJournalSummonButton,
		WardrobeOutfitDropDown.SaveButton,
		WardrobeTransmogFrame.ApplyButton,
	}
	for _, button in pairs(buttons) do
		B.ReskinButton(button)
	end

	local dropdowns = {
		HeirloomsJournalClassDropDown,
		WardrobeCollectionFrameWeaponDropDown,
		WardrobeOutfitDropDown,
	}
	for _, dropdown in pairs(dropdowns) do
		B.ReskinDropDown(dropdown)
	end

	local bars = {
		HeirloomsJournal.progressBar,
		ToyBox.progressBar,
		WardrobeCollectionFrame.progressBar,
	}
	for _, bar in pairs(bars) do
		B.ReskinStatusBar(bar)
	end

	local filters = {
		HeirloomsJournalFilterButton,
		MountJournalFilterButton,
		PetJournalFilterButton,
		ToyBoxFilterButton,
		WardrobeCollectionFrame.FilterButton,
	}
	for _, filter in pairs(filters) do
		B.ReskinFilter(filter)
	end

	local inputs = {
		HeirloomsJournalSearchBox,
		MountJournalSearchBox,
		PetJournalSearchBox,
		ToyBox.searchBox,
		WardrobeCollectionFrameSearchBox,
	}
	for _, input in pairs(inputs) do
		B.ReskinInput(input)
	end

	local scrolls = {
		MountJournalListScrollFrameScrollBar,
		PetJournalListScrollFrameScrollBar,
		WardrobeCollectionFrameScrollFrameScrollBar,
	}
	for _, scroll in pairs(scrolls) do
		B.ReskinScroll(scroll)
	end

	local scrollFrames = {
		MountJournal.ListScrollFrame,
		PetJournal.listScroll,
		WardrobeCollectionFrame.SetsCollectionFrame.ScrollFrame,
	}
	for _, scrollFrame in pairs(scrollFrames) do
		for i = 1, #scrollFrame.buttons do
			local button = scrollFrame.buttons[i]
			B.StripTextures(button)

			local icon = button.Icon or button.icon
			local icbg = B.ReskinIcon(icon)
			button.icbg = icbg

			local bubg = B.CreateBDFrame(button, 0, 1)
			B.ReskinHLTex(button, bubg, true)
			button.bubg = bubg

			local selected = button.SelectedTexture or button.selectedTexture
			B.ReskinHLTex(selected, bubg, true)

			local Name = button.Name
			if Name then
				Name:ClearAllPoints()
				Name:SetPoint("BOTTOMLEFT", bubg, "LEFT", 6, 1)
			end

			local Label = button.Label
			if Label then
				B.ReskinText(Label, .9, .9, .9)
			end

			local name = button.name
			if name then
				name:ClearAllPoints()
				name:SetPoint("LEFT", bubg, "LEFT", 6, 0)
			end

			local favorite = button.Favorite or button.favorite
			if favorite then
				favorite:SetAtlas("collections-icon-favorites")
			end

			local ProgressBar = button.ProgressBar
			if ProgressBar then
				ProgressBar:SetTexture(DB.bgTex)
				ProgressBar:SetVertexColor(cr, cg, cb, .25)
				ProgressBar:SetPoint("TOPLEFT", bubg, C.mult, -C.mult)
				ProgressBar:SetPoint("BOTTOMLEFT", bubg, C.mult, C.mult)
			end

			local DragButton = button.DragButton
			if DragButton then
				DragButton.ActiveTexture:SetTexture("")

				B.ReskinHLTex(DragButton, icbg)
			end

			local dragButton = button.dragButton
			if dragButton then
				dragButton.levelBG:SetAlpha(0)
				dragButton.ActiveTexture:SetTexture("")

				B.ReskinHLTex(dragButton, icbg)
				B.ReskinText(dragButton.level, 1, 1, 1)
			end
		end
	end

	MountJournalFilterButton:ClearAllPoints()
	MountJournalFilterButton:SetPoint("LEFT", MountJournalSearchBox, "RIGHT", 2, 0)
	PetJournalFilterButton:ClearAllPoints()
	PetJournalFilterButton:SetPoint("LEFT", PetJournalSearchBox, "RIGHT", 2, 0)
	WardrobeCollectionFrame.FilterButton:ClearAllPoints()
	WardrobeCollectionFrame.FilterButton:SetPoint("LEFT", WardrobeCollectionFrameSearchBox, "RIGHT", 2, 0)

	-- [[ Mounts and Pets ]]
	Reskin_Button("MountJournalSummonRandomFavoriteButton")
	Reskin_Button("PetJournalHealPetButton")
	Reskin_Button("PetJournalSummonRandomFavoritePetButton")

	-- MountJournal
	B.CreateBDFrame(MountJournal.MountDisplay.ModelScene, 0, -C.mult)
	B.ReskinArrow(MountJournal.MountDisplay.ModelScene.RotateLeftButton, "left")
	B.ReskinArrow(MountJournal.MountDisplay.ModelScene.RotateRightButton, "right")
	B.ReskinIcon(MountJournal.MountDisplay.InfoButton.Icon)

	local TogglePlayer = MountJournal.MountDisplay.ModelScene.TogglePlayer
	B.ReskinCheck(TogglePlayer)
	TogglePlayer:SetSize(28, 28)

	local BottomLeftInset = MountJournal.BottomLeftInset
	B.StripTextures(BottomLeftInset)
	B.CreateBGFrame(BottomLeftInset, 3, -2, -25, 2)

	local SlotButton = BottomLeftInset.SlotButton
	B.StripTextures(SlotButton)
	local icbg = B.ReskinIcon(SlotButton.ItemIcon)
	B.ReskinHLTex(SlotButton, icbg)
	B.ReskinHLTex(SlotButton.DragTargetHighlight, icbg)

	MountJournalSummonRandomFavoriteButton:ClearAllPoints()
	MountJournalSummonRandomFavoriteButton:SetPoint("BOTTOMRIGHT", MountJournal.MountDisplay, "TOPRIGHT", 0, 4)

	hooksecurefunc("MountJournal_UpdateMountList", Update_MountList)
	hooksecurefunc(MountJournalListScrollFrame, "update", Update_MountList)

	-- PetJournal
	S.ReskinTutorialButton(PetJournalTutorialButton, PetJournal)

	local PetCard = PetJournalPetCard
	B.StripTextures(PetCard)
	B.CreateBDFrame(PetCard)
	B.ReskinStatusBar(PetCard.xpBar, true)
	B.ReskinStatusBar(PetCard.HealthFrame.healthBar, true)

	PetCard.AbilitiesBG1:SetAlpha(0)
	PetCard.AbilitiesBG2:SetAlpha(0)
	PetCard.AbilitiesBG3:SetAlpha(0)

	local PetInfo = PetCard.PetInfo
	B.StripTextures(PetInfo)
	local icbg = B.ReskinIcon(PetInfo.icon)
	B.ReskinBorder(PetInfo.qualityBorder, icbg)
	B.ReskinText(PetInfo.level, 1, 1, 1)

	for i = 1, 6 do
		local button = PetCard["spell"..i]
		local icbg = B.ReskinIcon(button.icon)
		B.ReskinHLTex(button, icbg)
	end

	for i = 1, 3 do
		local button = PetJournal.Loadout["Pet"..i]
		B.StripTextures(button)
		B.CreateBGFrame(button, 0, -4, 0, 0)
		B.ReskinStatusBar(button.xpBar, true)
		B.ReskinStatusBar(button.healthFrame.healthBar, true)

		local setButton = button.setButton:GetRegions()
		B.ReskinHLTex(setButton, button.qualityBorder)

		local icbg = B.ReskinIcon(button.icon)
		B.ReskinHLTex(button.dragButton, icbg)
		B.ReskinBorder(button.qualityBorder, icbg)
		B.ReskinText(button.level, 1, 1, 1)

		for j = 1, 3 do
			local spell = button["spell"..j]
			spell:GetRegions():Hide()
			B.CleanTextures(spell)

			spell.FlyoutArrow:SetTexture(DB.arrowTex.."down")
			spell.FlyoutArrow:SetSize(12, 12)
			spell.FlyoutArrow:SetTexCoord(0, 1, 0, 1)

			local icbg = B.ReskinIcon(spell.icon)
			B.ReskinHLTex(spell, icbg, false, true)
			B.ReskinSpecialBorder(spell.selected, icbg)
			spell.BlackCover:SetInside(icbg)
		end
	end

	for i = 1, 2 do
		local button = PetJournal.SpellSelect["Spell"..i]
		B.CleanTextures(button)

		local icbg = B.ReskinIcon(button.icon)
		B.ReskinHLTex(button, icbg)
		B.ReskinCPTex(button, icbg)
	end

	PetJournalHealPetButton:ClearAllPoints()
	PetJournalHealPetButton:SetPoint("BOTTOMRIGHT", PetJournalPetCard, "TOPRIGHT", 0, 4)
	PetJournalLoadoutBorderSlotHeaderText:ClearAllPoints()
	PetJournalLoadoutBorderSlotHeaderText:SetParent(PetJournal)
	PetJournalLoadoutBorderSlotHeaderText:SetPoint("CENTER", PetJournalLoadoutBorderTop, "TOP", 0, 4)

	hooksecurefunc("PetJournal_UpdatePetList", Update_PetList)
	hooksecurefunc(PetJournalListScrollFrame, "update", Update_PetList)

	-- [[ Toy Box ]]
	B.ReskinArrow(ToyBox.PagingFrame.PrevPageButton, "left")
	B.ReskinArrow(ToyBox.PagingFrame.NextPageButton, "right")

	local buttons = ToyBox.iconsFrame
	for i = 1, 18 do
		local button = buttons["spellButton"..i]
		B.StripTextures(button)

		local icbg = B.ReskinIcon(button.iconTexture)
		B.ReskinHLTex(button, icbg)
		button.icbg = icbg

		local cooldown = button.cooldown
		cooldown:SetInside(icbg)

		hooksecurefunc(button.name, "SetTextColor", Reskin_ToyBoxName)
	end

	hooksecurefunc("ToyBox_UpdateButtons", Reskin_ToyBoxBorder)

	-- [[ HeirloomsJournal ]]
	B.ReskinArrow(HeirloomsJournal.PagingFrame.PrevPageButton, "left")
	B.ReskinArrow(HeirloomsJournal.PagingFrame.NextPageButton, "right")

	hooksecurefunc(HeirloomsJournal, "UpdateButton", Reskin_UpdateButton)
	hooksecurefunc(HeirloomsJournal, "LayoutCurrentPage", Reskin_LayoutCurrentPage)

	-- [[ WardrobeCollectionFrame ]]
	local ItemsCollectionFrame = WardrobeCollectionFrame.ItemsCollectionFrame
	B.ReskinArrow(ItemsCollectionFrame.PagingFrame.PrevPageButton, "left")
	B.ReskinArrow(ItemsCollectionFrame.PagingFrame.NextPageButton, "right")

	for i = 1, 2 do
		local tab = _G["WardrobeCollectionFrameTab"..i]
		B.StripTextures(tab)

		tab.bg = B.CreateBDFrame(tab, 0, 3)
	end

	hooksecurefunc("WardrobeCollectionFrame_SetTab", Reskin_SetTab)

	local SetsCollectionFrame = WardrobeCollectionFrame.SetsCollectionFrame
	SetsCollectionFrame.bg = B.CreateBDFrame(SetsCollectionFrame.Model)

	local DetailsFrame = SetsCollectionFrame.DetailsFrame
	B.StripTextures(DetailsFrame)
	B.ReskinFilter(DetailsFrame.VariantSetsButton)

	hooksecurefunc(SetsCollectionFrame, "Refresh", Reskin_Refresh)
	hooksecurefunc(SetsCollectionFrame, "SetItemFrameQuality", Reskin_SetItemFrameQuality)

	local SetsTransmogFrame = WardrobeCollectionFrame.SetsTransmogFrame
	B.ReskinArrow(SetsTransmogFrame.PagingFrame.PrevPageButton, "left")
	B.ReskinArrow(SetsTransmogFrame.PagingFrame.NextPageButton, "right")

	-- [[ WardrobeFrame ]]
	B.ReskinFrame(WardrobeFrame)
	B.ReskinArrow(WardrobeTransmogFrame.SpecButton, "down")

	local ModelScene = WardrobeTransmogFrame.ModelScene
	B.StripTextures(ModelScene.ControlFrame)
	B.ReskinButton(ModelScene.ClearAllPendingButton)

	local slots = {
		"Head",
		"Neck",
		"Shoulder",
		"Shirt",
		"Chest",
		"Waist",
		"Legs",
		"Feet",
		"Wrist",
		"Hands",
		"Finger0",
		"Finger1",
		"Trinket0",
		"Trinket1",
		"Back",
		"MainHand",
		"SecondaryHand",
		"Tabard",
		"MainHandEnchant",
		"SecondaryHandEnchant",
	}
	for i = 1, #slots do
		local slot = ModelScene[slots[i].."Button"]
		if slot then
			slot.Border:Hide()

			local icbg = B.ReskinIcon(slot.Icon)
			B.ReskinHLTex(slot, icbg)

			slot.HiddenVisualCover:SetInside(icbg)
		end
	end

	WardrobeOutfitDropDown:SetHeight(32)
	WardrobeOutfitDropDown.SaveButton:ClearAllPoints()
	WardrobeOutfitDropDown.SaveButton:SetPoint("LEFT", WardrobeOutfitDropDown, "RIGHT", -13, 2)
	WardrobeTransmogFrame.SpecButton:ClearAllPoints()
	WardrobeTransmogFrame.SpecButton:SetPoint("RIGHT", WardrobeTransmogFrame.ApplyButton, "LEFT", -3, 0)
end