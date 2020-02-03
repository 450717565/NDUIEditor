local B, C, L, DB = unpack(select(2, ...))

C.themes["Blizzard_EncounterJournal"] = function()
	B.ReskinFrame(EncounterJournal)
	B.ReskinInput(EncounterJournal.searchBox)

	EncounterJournalEncounterFrameInstanceFrameMapButtonShadow:Hide()

	local scrolls = {EncounterJournalScrollBar, EncounterJournalInstanceSelectScrollFrameScrollBar, EncounterJournalEncounterFrameInstanceFrameLoreScrollFrameScrollBar, EncounterJournalEncounterFrameInfoOverviewScrollFrameScrollBar, EncounterJournalEncounterFrameInfoBossesScrollFrameScrollBar, EncounterJournalEncounterFrameInfoDetailsScrollFrameScrollBar, EncounterJournalEncounterFrameInfoLootScrollFrameScrollBar}
	for _, scroll in pairs(scrolls) do
		B.ReskinScroll(scroll)
	end

	-- [[ Search results ]]
	B.StripTextures(EncounterJournalSearchBox.searchPreviewContainer)
	for i = 1, 5 do
		B.ReskinSearchBox(EncounterJournalSearchBox["sbutton"..i])
	end
	B.ReskinSearchBox(EncounterJournalSearchBox.showAllResults)
	B.ReskinSearchResult(EncounterJournal)

	-- [[ Instances Select]]
	local instanceSelect = EncounterJournal.instanceSelect
	B.ReskinDropDown(instanceSelect.tierDropDown)
	instanceSelect.bg:Hide()

	local selectTabs = {"suggestTab", "dungeonsTab", "raidsTab", "LootJournalTab"}
	for _, selectTab in pairs(selectTabs) do
		local tab = instanceSelect[selectTab]
		B.StripTextures(tab)
		B.ReskinButton(tab)

		local text = tab:GetFontString()
		text:ClearAllPoints()
		text:SetPoint("CENTER")
	end

	hooksecurefunc("EncounterJournal_ListInstances", function()
		local index = 1
		while true do
			local instance = instanceSelect.scroll.child["instance"..index]
			if not instance then return end

			if not instance.styled then
				B.CleanTextures(instance)

				local bubg = B.CreateBDFrame(instance.bgImage, 1, nil, true)
				bubg:SetPoint("TOPLEFT", 3, -3)
				bubg:SetPoint("BOTTOMRIGHT", -4, 2)
				B.ReskinTexture(instance, bubg)

				instance.styled = true
			end

			index = index + 1
		end
	end)

	-- [[ Suggest Frame]]
	local SuggestFrame = EncounterJournal.suggestFrame
	local bg = B.CreateBDFrame(SuggestFrame, 0)
	bg:SetPoint("TOPLEFT", SuggestFrame.Suggestion1, 0, 0)
	bg:SetPoint("BOTTOMRIGHT", SuggestFrame.Suggestion3, 0, 0)

	for i = 1, 3 do
		local Suggestion = SuggestFrame["Suggestion"..i]
		B.StripTextures(Suggestion)

		local icon = Suggestion.icon
		B.CreateBDFrame(icon, 0)
		icon:ClearAllPoints()

		local centerDisplay = Suggestion.centerDisplay
		centerDisplay.title.text:SetTextColor(1, .8, 0)
		centerDisplay.description.text:SetTextColor(1, 1, 1)
		if centerDisplay.button then B.ReskinButton(centerDisplay.button) end

		local reward = Suggestion.reward
		B.StripTextures(reward)
		local icbg = B.CreateBDFrame(reward.icon, 0)
		icbg:SetFrameLevel(reward:GetFrameLevel() + 1)
		if reward.text then reward.text:SetTextColor(1, 1, 1) end

		if i == 1 then
			icon:SetPoint("BOTTOM", centerDisplay.title, "TOP", 0, 15)
			B.ReskinButton(Suggestion.button)
			B.ReskinArrow(Suggestion.prevButton, "left")
			B.ReskinArrow(Suggestion.nextButton, "right")
		else
			icon:SetPoint("LEFT", 10, 0)
			centerDisplay:ClearAllPoints()
			centerDisplay:SetPoint("LEFT", Suggestion.icon, "RIGHT", 15, 0)
		end
	end

	hooksecurefunc("EJSuggestFrame_RefreshDisplay", function()
		local self = SuggestFrame

		if #self.suggestions > 0 then
			local suggestion = self.Suggestion1
			local data = self.suggestions[1]

			if data.iconPath then
				suggestion.icon:SetMask(nil)
				suggestion.icon:SetTexCoord(.08, .92, .08, .92)
			end
		end

		if #self.suggestions > 1 then
			for i = 2, #self.suggestions do
				local suggestion = self["Suggestion"..i]
				if not suggestion then return end

				local data = self.suggestions[i]
				if data.iconPath then
					suggestion.icon:SetMask(nil)
					suggestion.icon:SetTexCoord(.08, .92, .08, .92)
				end
			end
		end
	end)

	hooksecurefunc("EJSuggestFrame_UpdateRewards", function(suggestion)
		local rewardData = suggestion.reward.data
		if rewardData then
			suggestion.reward.icon:SetMask(nil)
			suggestion.reward.icon:SetTexCoord(.08, .92, .08, .92)
		end
	end)

	-- [[ Loot Journal ]]
	local LootJournal = EncounterJournal.LootJournal
	B.StripTextures(LootJournal)

	local itemSetsFrame = LootJournal.ItemSetsFrame
	B.StripTextures(itemSetsFrame.ClassButton)
	B.ReskinButton(itemSetsFrame.ClassButton)

	hooksecurefunc(itemSetsFrame, "UpdateList", function(self)
		local buttons = self.buttons
		for i = 1, #buttons do
			local button = buttons[i]

			if not button.styled then
				button.ItemLevel:SetTextColor(1, 1, 1)
				button.Background:Hide()
				B.CreateBDFrame(button, 0)

				button.styled = true
			end
		end
	end)

	hooksecurefunc(itemSetsFrame, "ConfigureItemButton", function(_, button)
		if not button.bg then
			button.Border:SetAlpha(0)
			button.bg = B.ReskinIcon(button.Icon)
		end

		local quality = select(3, GetItemInfo(button.itemID))
		local color = BAG_ITEM_QUALITY_COLORS[quality or 1]
		button.bg:SetBackdropBorderColor(color.r, color.g, color.b)
	end)

	-- [[ Encounter Frame ]]
	local Encounter = EncounterJournal.encounter
	B.StripTextures(Encounter.overviewFrame)
	Encounter.infoFrame.description:SetTextColor(1, 1, 1)
	Encounter.instance.loreScroll.child.lore:SetTextColor(1, 1, 1)
	Encounter.overviewFrame.loreDescription:SetTextColor(1, 1, 1)
	Encounter.overviewFrame.overviewDescription.Text:SetTextColor(1, 1, 1)
	Encounter.instance.titleBG:Hide()

	local infoFrame = Encounter.info
	B.StripTextures(infoFrame)
	B.StripTextures(infoFrame.model, true)
	B.CreateBDFrame(infoFrame.model, 0)
	B.StripTextures(infoFrame.lootScroll.classClearFilter)
	B.ReskinButton(infoFrame.reset)

	infoFrame.instanceButton:Hide()
	infoFrame.overviewTab:ClearAllPoints()
	infoFrame.overviewTab:SetPoint("TOPLEFT", infoFrame, "TOPRIGHT", 5, -25)

	local buttons = {infoFrame.difficulty, infoFrame.lootScroll.filter, infoFrame.lootScroll.slotFilter}
	for _, button in pairs(buttons) do
		B.StripTextures(button)
		B.ReskinButton(button)
	end

	local sideTabs = {"overviewTab", "lootTab", "bossTab", "modelTab"}
	for _, sideTab in pairs(sideTabs) do
		local tab = infoFrame[sideTab]
		B.CleanTextures(tab)
		tab:SetSize(59, 59)

		local bg = B.CreateBDFrame(tab, nil, -5, true)
		B.ReskinTexture(tab, bg, true)
	end

	local items = infoFrame.lootScroll.buttons
	for i = 1, #items do
		local item = items[i]
		B.StripTextures(item)
		item.IconBorder:SetAlpha(0)

		local icon = item.icon
		icon:ClearAllPoints()
		icon:SetPoint("TOPLEFT", item, 3, -3)
		icon:SetSize(39, 39)
		icon:SetDrawLayer("ARTWORK")

		local icbg = B.ReskinIcon(icon)
		local bubg = B.CreateBDFrame(item, 0)
		bubg:SetPoint("TOPLEFT", icbg, "TOPRIGHT", 2, 0)
		bubg:SetPoint("BOTTOMRIGHT", 0, C.mult)
		B.ReskinTexture(item, bubg, true)

		local armor = item.armorType
		armor:SetTextColor(1, 1, 1)
		armor:ClearAllPoints()
		armor:SetPoint("RIGHT", bubg, "RIGHT", -5, 0)

		local name = item.name
		name:ClearAllPoints()
		name:SetPoint("TOPLEFT", bubg, "TOPLEFT", 5, -6)

		local slot = item.slot
		slot:SetTextColor(1, 1, 1)
		slot:ClearAllPoints()
		slot:SetPoint("TOPLEFT", name, "BOTTOMLEFT", 0, -6)

		local boss = item.boss
		boss:ClearAllPoints()
		boss:SetPoint("TOPLEFT", slot, "BOTTOMLEFT", 0, -6)
		boss:SetTextColor(1, .8, 0)
	end

	local function reskinHeader(header)
		B.StripTextures(header.button)
		header.descriptionBG:SetAlpha(0)
		header.descriptionBGBottom:SetAlpha(0)

		local bubg = B.CreateBDFrame(header.button, 0, -C.mult*2)
		B.ReskinTexture(header.button, bubg, true)
	end

	hooksecurefunc("EncounterJournal_SetUpOverview", function(self, _, index)
		local header = self.overviews[index]

		if not header.styled then
			reskinHeader(header)

			header.styled = true
		end
	end)

	hooksecurefunc("EncounterJournal_ToggleHeaders", function()
		local index = 1
		while true do
			local header = _G["EncounterJournalInfoHeader"..index]
			if not header then return end

			if not header.styled then
				reskinHeader(header)
				header.description:SetTextColor(1, 1, 1)

				header.styled = true
			end

			index = index + 1
		end
	end)

	hooksecurefunc("EncounterJournal_DisplayInstance", function()
		local index = 1
		while true do
			local boss = _G["EncounterJournalBossButton"..index]
			if not boss then return end

			if not boss.styled then
				B.StripTextures(boss)
				boss.creature:ClearAllPoints()
				boss.creature:SetPoint("TOPLEFT", 2, -3)

				local bubg = B.CreateBDFrame(boss, 0, -C.mult*2)
				B.ReskinTexture(boss, bubg, true)

				boss.styled = true
			end

			index = index + 1
		end
	end)

	hooksecurefunc("EncounterJournal_SetBullets", function(object)
		local parent = object:GetParent()
		if parent.Bullets then
			for _, bullet in pairs(parent.Bullets) do
				if not bullet.styled then
					bullet.Text:SetTextColor(1, 1, 1)

					bullet.styled = true
				end
			end
		end
	end)

	hooksecurefunc("EncounterJournal_GetCreatureButton", function(index)
		B.CleanTextures(infoFrame.creatureButtons[index])
	end)
end