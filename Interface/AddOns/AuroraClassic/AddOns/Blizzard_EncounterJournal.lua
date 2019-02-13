local F, C = unpack(select(2, ...))

C.themes["Blizzard_EncounterJournal"] = function()
	if AuroraConfig.tooltips then
		F.ReskinTooltip(EncounterJournalTooltip)
	end

	F.ReskinFrame(EncounterJournal)
	F.ReskinInput(EncounterJournal.searchBox)

	local scrolls = {EncounterJournalScrollBar, EncounterJournalInstanceSelectScrollFrameScrollBar, EncounterJournalEncounterFrameInstanceFrameLoreScrollFrameScrollBar, EncounterJournalEncounterFrameInfoOverviewScrollFrameScrollBar, EncounterJournalEncounterFrameInfoBossesScrollFrameScrollBar, EncounterJournalEncounterFrameInfoDetailsScrollFrameScrollBar, EncounterJournalEncounterFrameInfoLootScrollFrameScrollBar}
	for _, scroll in next, scrolls do
		F.ReskinScroll(scroll)
	end

	-- [[ Search results ]]
	F.StripTextures(EncounterJournalSearchBox.searchPreviewContainer, true)
	for i = 1, 5 do
		F.ReskinSearchBox(EncounterJournalSearchBox["sbutton"..i])
	end
	F.ReskinSearchBox(EncounterJournalSearchBox.showAllResults)
	F.ReskinSearchResult(EncounterJournal)

	-- [[ Instances Select]]
	local instanceSelect = EncounterJournal.instanceSelect
	F.ReskinDropDown(instanceSelect.tierDropDown)
	instanceSelect.bg:Hide()

	local selectTabs = {"suggestTab", "dungeonsTab", "raidsTab", "LootJournalTab"}
	for _, selectTab in next, selectTabs do
		local tab = instanceSelect[selectTab]
		F.StripTextures(tab)
		F.ReskinButton(tab)

		local text = tab:GetFontString()
		text:ClearAllPoints()
		text:SetPoint("CENTER")
	end

	do
		local index = 1
		local function reksinInstances()
			while true do
				local instance = instanceSelect.scroll.child["instance"..index]
				if not instance then return end

				local bubg = F.CreateBDFrame(instance.bgImage, 1, true)
				bubg:SetPoint("TOPLEFT", 3, -3)
				bubg:SetPoint("BOTTOMRIGHT", -4, 2)
				F.ReskinTexture(instance, bubg, false)

				index = index + 1
			end
		end
		hooksecurefunc("EncounterJournal_ListInstances", reksinInstances)
	end

	-- [[ Suggest Frame]]
	local SuggestFrame = EncounterJournal.suggestFrame
	local bg = F.CreateBDFrame(SuggestFrame, 0)
	bg:SetPoint("TOPLEFT", SuggestFrame.Suggestion1, 0, 0)
	bg:SetPoint("BOTTOMRIGHT", SuggestFrame.Suggestion3, 0, 0)

	for i = 1, 3 do
		local Suggestion = SuggestFrame["Suggestion"..i]
		F.StripTextures(Suggestion)

		local icon = Suggestion.icon
		icon:ClearAllPoints()
		F.CreateBDFrame(icon, 0)

		local centerDisplay = Suggestion.centerDisplay
		centerDisplay.title.text:SetTextColor(1, .8, 0)
		centerDisplay.description.text:SetTextColor(1, 1, 1)
		if centerDisplay.button then F.ReskinButton(centerDisplay.button) end

		local reward = Suggestion.reward
		F.StripTextures(reward)
		F.CreateBDFrame(reward.icon, 0)
		if reward.text then reward.text:SetTextColor(1, 1, 1) end

		if i == 1 then
			icon:SetPoint("BOTTOM", centerDisplay.title, "TOP", 0, 15)
			F.ReskinButton(Suggestion.button)
			F.ReskinArrow(Suggestion.prevButton, "left")
			F.ReskinArrow(Suggestion.nextButton, "right")
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
	F.StripTextures(LootJournal)

	local itemSetsFrame = LootJournal.ItemSetsFrame
	F.StripTextures(itemSetsFrame.ClassButton)
	F.ReskinButton(itemSetsFrame.ClassButton)

	hooksecurefunc(itemSetsFrame, "UpdateList", function(self)
		local buttons = self.buttons
		for i = 1, #buttons do
			local button = buttons[i]

			if not button.styled then
				button.ItemLevel:SetTextColor(1, 1, 1)
				button.Background:Hide()
				F.CreateBDFrame(button, 0)

				button.styled = true
			end
		end
	end)

	hooksecurefunc(itemSetsFrame, "ConfigureItemButton", function(_, button)
		if not button.bg then
			button.Border:SetAlpha(0)
			button.bg = F.ReskinIcon(button.Icon)
		end

		local quality = select(3, GetItemInfo(button.itemID))
		local color = BAG_ITEM_QUALITY_COLORS[quality or 1]
		button.bg:SetBackdropBorderColor(color.r, color.g, color.b)
	end)

	-- [[ Encounter Frame ]]
	local Encounter = EncounterJournal.encounter
	Encounter.infoFrame.description:SetTextColor(1, 1, 1)
	Encounter.instance.loreScroll.child.lore:SetTextColor(1, 1, 1)
	Encounter.overviewFrame.loreDescription:SetTextColor(1, 1, 1)
	Encounter.overviewFrame.overviewDescription.Text:SetTextColor(1, 1, 1)

	local infoFrame = Encounter.info
	F.StripTextures(infoFrame)
	F.StripTextures(infoFrame.model, true)
	F.CreateBDFrame(infoFrame.model, 0)

	F.ReskinButton(infoFrame.reset)
	F.ReskinButton(infoFrame.difficulty)
	F.ReskinButton(infoFrame.lootScroll.filter)
	F.ReskinButton(infoFrame.lootScroll.slotFilter)

	infoFrame.instanceButton:Hide()

	infoFrame.overviewTab:ClearAllPoints()
	infoFrame.overviewTab:SetPoint("TOPLEFT", infoFrame, "TOPRIGHT", 5, -25)
	local sideTabs = {"overviewTab", "lootTab", "bossTab", "modelTab"}
	for _, sideTab in next, sideTabs do
		local tab = infoFrame[sideTab]
		tab:SetSize(59, 59)

		local bg = F.CreateBDFrame(tab, nil, true)
		bg:SetPoint("TOPLEFT", 5, -5)
		bg:SetPoint("BOTTOMRIGHT", -5, 5)
		F.ReskinTexture(tab, bg, true)
	end

	local items = infoFrame.lootScroll.buttons
	for i = 1, #items do
		local item = items[i]
		F.StripTextures(item)
		item.IconBorder:SetAlpha(0)

		local icon = item.icon
		icon:ClearAllPoints()
		icon:SetPoint("TOPLEFT", item, 3, -3)
		icon:SetSize(39, 39)
		icon:SetDrawLayer("ARTWORK")
		local icbg = F.ReskinIcon(icon)

		local bubg = F.CreateBDFrame(item, 0)
		bubg:SetPoint("TOPLEFT", icbg, "TOPRIGHT", 2, 0)
		bubg:SetPoint("BOTTOMRIGHT", 0, 1)
		F.ReskinTexture(item, bubg, true)

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

	hooksecurefunc("EncounterJournal_SetUpOverview", function(self, _, index)
		local header = self.overviews[index]
		if not header.styled then
			F.StripTextures(header.button)
			F.ReskinButton(header.button)

			header.styled = true
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

	do
		local index = 1
		local function reskinBosses()
			while true do
				local boss = _G["EncounterJournalBossButton"..index]
				if not boss then return end

				F.ReskinButton(boss, true)
				F.ReskinTexture(boss, boss, true)
				boss.creature:SetPoint("TOPLEFT", 1, -4)

				index = index + 1
			end
		end
		hooksecurefunc("EncounterJournal_DisplayInstance", reskinBosses)
	end

	do
		local index = 1
		local function reskinHeaders()
			while true do
				local header = _G["EncounterJournalInfoHeader"..index]
				if not header then return end

				F.StripTextures(header.button)
				F.ReskinButton(header.button)
				header.description:SetTextColor(1, 1, 1)

				index = index + 1
			end
		end
		hooksecurefunc("EncounterJournal_ToggleHeaders", reskinHeaders)
	end
end