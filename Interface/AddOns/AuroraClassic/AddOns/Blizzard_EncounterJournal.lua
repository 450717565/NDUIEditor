local F, C = unpack(select(2, ...))

C.themes["Blizzard_EncounterJournal"] = function()
	local r, g, b = C.r, C.g, C.b

	F.ReskinFrame(EncounterJournal)
	F.StripTextures(EncounterJournalEncounterFrameInfo, true)
	EncounterJournalInstanceSelectBG:Hide()
	EncounterJournalEncounterFrameInfoInstanceButton:Hide()

	-- [[ Dungeon / raid tabs ]]

	local function onEnable(self)
		self:SetHeight(self.storedHeight)
		self:SetBackdropColor(0, 0, 0, 0)
	end

	local function onDisable(self)
		self:SetBackdropColor(r, g, b, .25)
	end

	local function onClick(self)
		self:GetFontString():SetTextColor(1, 1, 1)
	end

	local tabs = {EncounterJournalInstanceSelectSuggestTab, EncounterJournalInstanceSelectDungeonTab, EncounterJournalInstanceSelectRaidTab, EncounterJournalInstanceSelectLootJournalTab}
	for _, tab in next, tabs do
		F.StripTextures(tab, true)

		tab:SetHeight(tab.storedHeight)
		tab:HookScript("OnEnable", onEnable)
		tab:HookScript("OnDisable", onDisable)
		tab:HookScript("OnClick", onClick)

		local text = tab:GetFontString()
		text:SetPoint("CENTER")
		text:SetTextColor(1, 1, 1)

		F.ReskinButton(tab)
	end

	-- [[ Side tabs ]]
	EncounterJournalEncounterFrameInfoOverviewTab:ClearAllPoints()
	EncounterJournalEncounterFrameInfoOverviewTab:SetPoint("TOPLEFT", EncounterJournalEncounterFrameInfo, "TOPRIGHT", 8, -35)
	EncounterJournalEncounterFrameInfoLootTab:ClearAllPoints()
	EncounterJournalEncounterFrameInfoLootTab:SetPoint("TOP", EncounterJournalEncounterFrameInfoOverviewTab, "BOTTOM", 0, 8)
	EncounterJournalEncounterFrameInfoBossTab:ClearAllPoints()
	EncounterJournalEncounterFrameInfoBossTab:SetPoint("TOP", EncounterJournalEncounterFrameInfoLootTab, "BOTTOM", 0, 8)

	local sidetabs = {EncounterJournalEncounterFrameInfoOverviewTab, EncounterJournalEncounterFrameInfoLootTab, EncounterJournalEncounterFrameInfoBossTab, EncounterJournalEncounterFrameInfoModelTab}
	for _, tab in pairs(sidetabs) do
		tab:SetScale(.75)
		local bg = F.CreateBDFrame(tab, nil, true)
		bg:SetPoint("TOPLEFT", 5, -5)
		bg:SetPoint("BOTTOMRIGHT", -5, 5)
	end

	-- [[ Instance select ]]
	F.ReskinDropDown(EncounterJournalInstanceSelectTierDropDown)

	local index = 1
	local function listInstances()
		while true do
			local bu = EncounterJournal.instanceSelect.scroll.child["instance"..index]
			if not bu then return end

			bu:SetNormalTexture("")
			bu:SetPushedTexture("")

			local bg = F.CreateBDFrame(bu.bgImage, 0)
			bg:SetPoint("TOPLEFT", 3, -3)
			bg:SetPoint("BOTTOMRIGHT", -4, 2)

			F.ReskinTexture(bu, bg, false)

			index = index + 1
		end
	end

	hooksecurefunc("EncounterJournal_ListInstances", listInstances)

	-- [[ Encounter frame ]]
	F.StripTextures(EncounterJournalEncounterFrameInfoOverviewScrollFrame, true)
	F.StripTextures(EncounterJournalEncounterFrameInfoModelFrame, true)

	EncounterJournalEncounterFrameInfoEncounterTitle:SetTextColor(1, 1, 1)
	EncounterJournalEncounterFrameInstanceFrameLoreScrollFrameScrollChildLore:SetTextColor(1, 1, 1)
	EncounterJournalEncounterFrameInfoDetailsScrollFrameScrollChildDescription:SetTextColor(1, 1, 1)
	EncounterJournalEncounterFrameInfoOverviewScrollFrameScrollChildLoreDescription:SetTextColor(1, 1, 1)
	EncounterJournalEncounterFrameInfoOverviewScrollFrameScrollChildTitle:SetTextColor(1, 1, 1)
	EncounterJournalEncounterFrameInfoOverviewScrollFrameScrollChild.overviewDescription.Text:SetTextColor(1, 1, 1)

	F.CreateBDFrame(EncounterJournalEncounterFrameInfoModelFrame, 0)
	EncounterJournalEncounterFrameInfoCreatureButton1:SetPoint("TOPLEFT", EncounterJournalEncounterFrameInfoModelFrame, 0, -35)

	do
		local numBossButtons = 1
		local bossButton

		hooksecurefunc("EncounterJournal_DisplayInstance", function()
			bossButton = _G["EncounterJournalBossButton"..numBossButtons]
			while bossButton do
				F.ReskinButton(bossButton, true)
				F.ReskinTexture(bossButton, bossButton, true)

				bossButton.text:SetTextColor(1, 1, 1)
				bossButton.creature:SetPoint("TOPLEFT", 0, -4)

				numBossButtons = numBossButtons + 1
				bossButton = _G["EncounterJournalBossButton"..numBossButtons]
			end

			-- move last tab
			local _, point = EncounterJournalEncounterFrameInfoModelTab:GetPoint()
			EncounterJournalEncounterFrameInfoModelTab:SetPoint("TOP", point, "BOTTOM", 0, 8)
		end)
	end

	hooksecurefunc("EncounterJournal_ToggleHeaders", function()
		local index = 1
		local header = _G["EncounterJournalInfoHeader"..index]
		while header do
			if not header.styled then
				F.StripTextures(header.button)
				F.ReskinButton(header.button)

				header.description:SetTextColor(1, 1, 1)
				header.button.bg = F.ReskinIcon(header.button.abilityIcon, true)

				header.styled = true
			end

			header.button.bg:SetShown(header.button.abilityIcon:IsShown())

			index = index + 1
			header = _G["EncounterJournalInfoHeader"..index]
		end
	end)

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

	local items = EncounterJournal.encounter.info.lootScroll.buttons

	for i = 1, #items do
		local item = items[i]
		F.StripTextures(item)

		item.boss:SetTextColor(1, 1, 1)
		item.slot:SetTextColor(1, 1, 1)
		item.armorType:SetTextColor(1, 1, 1)

		item.IconBorder:SetAlpha(0)

		item.icon:SetPoint("TOPLEFT", 2, -3)
		item.icon:SetSize(39, 39)

		item.icon:SetDrawLayer("OVERLAY")
		F.ReskinIcon(item.icon)

		local bg = F.CreateBDFrame(item, 0)
		bg:SetPoint("TOPLEFT", C.mult, -C.mult)
		bg:SetPoint("BOTTOMRIGHT", -C.mult, C.mult)
	end

	-- [[ Search results ]]
	F.StripTextures(EncounterJournalSearchBox.searchPreviewContainer, true)
	for i = 1, 5 do
		F.ReskinSearchBox(EncounterJournalSearchBox["sbutton"..i])
	end
	F.ReskinSearchBox(EncounterJournalSearchBox.showAllResults)
	F.ReskinSearchResult(EncounterJournal)

	-- [[ Various controls ]]
	F.ReskinButton(EncounterJournalEncounterFrameInfoResetButton)
	F.ReskinInput(EncounterJournalSearchBox)
	F.ReskinScroll(EncounterJournalInstanceSelectScrollFrameScrollBar)
	F.ReskinScroll(EncounterJournalEncounterFrameInstanceFrameLoreScrollFrameScrollBar)
	F.ReskinScroll(EncounterJournalEncounterFrameInfoOverviewScrollFrameScrollBar)
	F.ReskinScroll(EncounterJournalEncounterFrameInfoBossesScrollFrameScrollBar)
	F.ReskinScroll(EncounterJournalEncounterFrameInfoDetailsScrollFrameScrollBar)
	F.ReskinScroll(EncounterJournalEncounterFrameInfoLootScrollFrameScrollBar)

	-- Tooltip
	if AuroraConfig.tooltips then
		F.ReskinTooltip(EncounterJournalTooltip)
		EncounterJournalTooltip.Item1.newBg = F.ReskinIcon(EncounterJournalTooltip.Item1.icon, true)
		EncounterJournalTooltip.Item2.newBg = F.ReskinIcon(EncounterJournalTooltip.Item2.icon, true)
	end

	-- [[ Suggest frame ]]
	local suggestFrame = EncounterJournal.suggestFrame

	-- Suggestion 1
	local suggestion = suggestFrame.Suggestion1
	F.StripTextures(suggestion)

	local bg = F.CreateBDFrame(suggestion, 0)
	bg:SetPoint("TOPLEFT", 0, 5)
	bg:SetPoint("BOTTOMRIGHT", suggestFrame.Suggestion3, 15, 0)

	suggestion.icon:ClearAllPoints()
	suggestion.icon:SetPoint("TOP", 0, -15)
	F.CreateBDFrame(suggestion.icon, 0)

	local centerDisplay = suggestion.centerDisplay
	centerDisplay.title.text:SetTextColor(1, 1, 1)
	centerDisplay.description.text:SetTextColor(.9, .9, .9)
	F.ReskinButton(suggestion.button)

	local reward = suggestion.reward
	F.StripTextures(reward)
	reward.text:SetTextColor(.9, .9, .9)
	F.CreateBDFrame(reward.icon, 0)

	F.ReskinArrow(suggestion.prevButton, "left")
	F.ReskinArrow(suggestion.nextButton, "right")

	-- Suggestion 2 and 3
	for i = 2, 3 do
		local suggestion = suggestFrame["Suggestion"..i]
		F.StripTextures(suggestion)

		suggestion.icon:SetPoint("TOPLEFT", 25, -25)
		F.CreateBDFrame(suggestion.icon, 0)

		local centerDisplay = suggestion.centerDisplay
		centerDisplay:ClearAllPoints()
		centerDisplay:SetPoint("BOTTOMLEFT", suggestion.icon, "BOTTOMRIGHT", 15, 0)
		centerDisplay.title.text:SetTextColor(1, 1, 1)
		centerDisplay.description.text:SetTextColor(.9, .9, .9)
		F.ReskinButton(centerDisplay.button)

		local reward = suggestion.reward
		F.StripTextures(reward)

		local bg = F.CreateBDFrame(reward.icon, 0)
		--bg:SetFrameLevel(reward:GetFrameLevel()+1)
	end

	-- Hook functions

	hooksecurefunc("EJSuggestFrame_RefreshDisplay", function()
		local self = suggestFrame

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
				if not suggestion then break end

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
	F.StripTextures(EncounterJournal.LootJournal, true)
	F.ReskinScroll(EncounterJournal.LootJournal.ItemSetsFrame.scrollBar)

	local buttons = {
		EncounterJournalEncounterFrameInfoDifficulty,
		EncounterJournalEncounterFrameInfoLootScrollFrameFilterToggle,
		EncounterJournalEncounterFrameInfoLootScrollFrameSlotFilterToggle,
		EncounterJournal.LootJournal.ItemSetsFrame.ClassButton,
	}
	for _, btn in pairs(buttons) do
		F.StripTextures(btn, true)
		F.ReskinButton(btn)
	end

	-- ItemSetsFrame
	hooksecurefunc(EncounterJournal.LootJournal.ItemSetsFrame, "UpdateList", function(self)
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

	hooksecurefunc(EncounterJournal.LootJournal.ItemSetsFrame, "ConfigureItemButton", function(_, button)
		if not button.bg then
			button.Border:SetAlpha(0)
			button.bg = F.ReskinIcon(button.Icon)
		end

		local quality = select(3, GetItemInfo(button.itemID))
		local color = BAG_ITEM_QUALITY_COLORS[quality or 1]
		button.bg:SetBackdropBorderColor(color.r, color.g, color.b)
	end)
end