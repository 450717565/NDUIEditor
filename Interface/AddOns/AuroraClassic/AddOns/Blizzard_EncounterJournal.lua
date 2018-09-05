local F, C = unpack(select(2, ...))

C.themes["Blizzard_EncounterJournal"] = function()
	local r, g, b = C.r, C.g, C.b

	F.StripTextures(EncounterJournal, true)
	F.StripTextures(EncounterJournalInset, true)
	F.StripTextures(EncounterJournalEncounterFrameInfo, true)
	EncounterJournalInstanceSelectBG:Hide()
	EncounterJournalEncounterFrameInfoInstanceButton:Hide()
	F.CreateBD(EncounterJournal)
	F.CreateSD(EncounterJournal)

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

		F.Reskin(tab)
	end

	-- [[ Side tabs ]]
	EncounterJournalEncounterFrameInfoOverviewTab:ClearAllPoints()
	EncounterJournalEncounterFrameInfoOverviewTab:SetPoint("TOPLEFT", EncounterJournalEncounterFrameInfo, "TOPRIGHT", 6, -35)
	EncounterJournalEncounterFrameInfoLootTab:ClearAllPoints()
	EncounterJournalEncounterFrameInfoLootTab:SetPoint("TOP", EncounterJournalEncounterFrameInfoOverviewTab, "BOTTOM", 0, 0)
	EncounterJournalEncounterFrameInfoBossTab:ClearAllPoints()
	EncounterJournalEncounterFrameInfoBossTab:SetPoint("TOP", EncounterJournalEncounterFrameInfoLootTab, "BOTTOM", 0, 0)

	local sidetabs = {EncounterJournalEncounterFrameInfoOverviewTab, EncounterJournalEncounterFrameInfoLootTab, EncounterJournalEncounterFrameInfoBossTab, EncounterJournalEncounterFrameInfoModelTab}
	for _, tab in pairs(sidetabs) do
		tab:SetScale(.75)
		F.ReskinTab(tab)
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

			bu:SetHighlightTexture(C.media.backdrop)
			local hl = bu:GetHighlightTexture()
			hl:SetVertexColor(1, 1, 1, .25)
			hl:SetPoint("TOPLEFT", 4, -4)
			hl:SetPoint("BOTTOMRIGHT", -5, 3)

			local bg = F.CreateBDFrame(bu.bgImage, .25)
			bg:SetPoint("TOPLEFT", 3, -3)
			bg:SetPoint("BOTTOMRIGHT", -4, 2)

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

	F.CreateBDFrame(EncounterJournalEncounterFrameInfoModelFrame, .25)
	EncounterJournalEncounterFrameInfoCreatureButton1:SetPoint("TOPLEFT", EncounterJournalEncounterFrameInfoModelFrame, 0, -35)

	do
		local numBossButtons = 1
		local bossButton

		hooksecurefunc("EncounterJournal_DisplayInstance", function()
			bossButton = _G["EncounterJournalBossButton"..numBossButtons]
			while bossButton do
				F.Reskin(bossButton, true)

				bossButton.text:SetTextColor(1, 1, 1)

				local hl = bossButton:GetHighlightTexture()
				hl:SetColorTexture(r, g, b, .25)
				hl:SetPoint("TOPLEFT", 1, -1)
				hl:SetPoint("BOTTOMRIGHT", -1, 1)

				bossButton.creature:SetPoint("TOPLEFT", 0, -4)

				numBossButtons = numBossButtons + 1
				bossButton = _G["EncounterJournalBossButton"..numBossButtons]
			end

			-- move last tab
			local _, point = EncounterJournalEncounterFrameInfoModelTab:GetPoint()
			EncounterJournalEncounterFrameInfoModelTab:SetPoint("TOP", point, "BOTTOM", 0, 0)
		end)
	end

	hooksecurefunc("EncounterJournal_ToggleHeaders", function()
		local index = 1
		local header = _G["EncounterJournalInfoHeader"..index]
		while header do
			if not header.styled then
				F.StripTextures(header.button)
				F.Reskin(header.button)

				header.description:SetTextColor(1, 1, 1)
				header.button.bg = F.ReskinIcon(header.button.abilityIcon)

				header.styled = true
			end

			if header.button.abilityIcon:GetTexture() then
				header.button.bg:Show()
			else
				header.button.bg:Hide()
			end

			index = index + 1
			header = _G["EncounterJournalInfoHeader"..index]
		end
	end)

	hooksecurefunc("EncounterJournal_SetUpOverview", function(self, _, index)
		local header = self.overviews[index]
		if not header.styled then
			F.StripTextures(header.button)
			F.Reskin(header.button)

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

		item.icon:SetTexCoord(.08, .92, .08, .92)
		item.icon:SetDrawLayer("OVERLAY")
		F.CreateBDFrame(item.icon, .25)

		local bg = F.CreateBDFrame(item, .25)
		bg:SetPoint("TOPLEFT", 1, -1)
		bg:SetPoint("BOTTOMRIGHT", -1, 1)
		bg:SetFrameLevel(item:GetFrameLevel() - 1)
	end

	-- [[ Search results ]]
	F.StripTextures(EncounterJournalSearchBox.searchPreviewContainer, true)
	local function styleSearchButton(result)
		F.StripTextures(result)

		if result.icon then
			F.ReskinIcon(result.icon)
		end

		local bd = F.CreateBDFrame(result, .25)
		bd:SetPoint("TOPLEFT")
		bd:SetPoint("BOTTOMRIGHT", 0, 1)

		result:SetHighlightTexture(C.media.backdrop)
		local hl = result:GetHighlightTexture()
		hl:SetVertexColor(r, g, b, .25)
		hl:SetPoint("TOPLEFT", 1, -1)
		hl:SetPoint("BOTTOMRIGHT", -1, 2)
	end

	for i = 1, 5 do
		styleSearchButton(EncounterJournalSearchBox["sbutton"..i])
	end
	styleSearchButton(EncounterJournalSearchBox.showAllResults)

	do
		local result = EncounterJournalSearchResults
		result:SetPoint("BOTTOMLEFT", EncounterJournal, "BOTTOMRIGHT", 30, 0)
		F.StripTextures(result, true)

		local bg = F.CreateBDFrame(result)
		bg:SetPoint("TOPLEFT", -10, 0)
		bg:SetPoint("BOTTOMRIGHT")

		F.ReskinClose(EncounterJournalSearchResultsCloseButton)
		F.ReskinScroll(EncounterJournalSearchResultsScrollFrameScrollBar)

		for i = 1, 9 do
			local bu = _G["EncounterJournalSearchResultsScrollFrameButton"..i]
			F.StripTextures(bu)

			local bd = F.CreateBDFrame(bu, .25)
			bd:SetPoint("TOPLEFT", 2, -2)
			bd:SetPoint("BOTTOMRIGHT", -1, 1)

			bu.icon:SetTexCoord(.08, .92, .08, .92)
			bu.icon.SetTexCoord = F.dummy
			F.CreateBDFrame(bu.icon, .25)

			bu:SetHighlightTexture(C.media.backdrop)
			local hl = bu:GetHighlightTexture()
			hl:SetVertexColor(r, g, b, .25)
			hl:SetPoint("TOPLEFT", 3, -3)
			hl:SetPoint("BOTTOMRIGHT", -2, 2)
		end
	end

	-- [[ Various controls ]]
	F.Reskin(EncounterJournalEncounterFrameInfoResetButton)
	F.ReskinClose(EncounterJournalCloseButton)
	F.ReskinInput(EncounterJournalSearchBox)
	F.ReskinScroll(EncounterJournalInstanceSelectScrollFrameScrollBar)
	F.ReskinScroll(EncounterJournalEncounterFrameInstanceFrameLoreScrollFrameScrollBar)
	F.ReskinScroll(EncounterJournalEncounterFrameInfoOverviewScrollFrameScrollBar)
	F.ReskinScroll(EncounterJournalEncounterFrameInfoBossesScrollFrameScrollBar)
	F.ReskinScroll(EncounterJournalEncounterFrameInfoDetailsScrollFrameScrollBar)
	F.ReskinScroll(EncounterJournalEncounterFrameInfoLootScrollFrameScrollBar)

	-- Tooltip
	if AuroraConfig.tooltips then
		local EncounterJournalTooltip = EncounterJournalTooltip
		F.CreateBD(EncounterJournalTooltip)
		F.CreateSD(EncounterJournalTooltip)
		EncounterJournalTooltip.Item1.icon:SetTexCoord(.08, .92, .08, .92)
		EncounterJournalTooltip.Item2.icon:SetTexCoord(.08, .92, .08, .92)
		EncounterJournalTooltip.Item1.newBg = F.CreateBDFrame(EncounterJournalTooltip.Item1.icon, .25)
		EncounterJournalTooltip.Item2.newBg = F.CreateBDFrame(EncounterJournalTooltip.Item2.icon, .25)
	end

	-- [[ Suggest frame ]]
	local suggestFrame = EncounterJournal.suggestFrame

	-- Suggestion 1
	local suggestion = suggestFrame.Suggestion1
	F.StripTextures(suggestion)
	F.CreateBDFrame(suggestion, .25)

	suggestion.icon:ClearAllPoints()
	suggestion.icon:SetPoint("TOP", 0, -15)
	F.CreateBDFrame(suggestion.icon, .25)

	local centerDisplay = suggestion.centerDisplay
	centerDisplay.title.text:SetTextColor(1, 1, 1)
	centerDisplay.description.text:SetTextColor(.9, .9, .9)
	F.Reskin(suggestion.button)

	local reward = suggestion.reward
	F.StripTextures(reward)
	reward.text:SetTextColor(.9, .9, .9)
	F.CreateBDFrame(reward.icon)

	F.ReskinArrow(suggestion.prevButton, "left")
	F.ReskinArrow(suggestion.nextButton, "right")

	-- Suggestion 2 and 3
	for i = 2, 3 do
		local suggestion = suggestFrame["Suggestion"..i]
		F.StripTextures(suggestion)
		F.CreateBDFrame(suggestion, .25)

		suggestion.icon:SetPoint("TOPLEFT", 10, -10)
		F.CreateBDFrame(suggestion.icon, .25)

		local centerDisplay = suggestion.centerDisplay
		centerDisplay:ClearAllPoints()
		centerDisplay:SetPoint("BOTTOMLEFT", suggestion.icon, "BOTTOMRIGHT", 15, 0)
		centerDisplay.title.text:SetTextColor(1, 1, 1)
		centerDisplay.description.text:SetTextColor(.9, .9, .9)
		F.Reskin(centerDisplay.button)

		local reward = suggestion.reward
		F.StripTextures(reward)

		local bd = F.CreateBDFrame(reward.icon, .25)
		bd:SetFrameLevel(reward:GetFrameLevel()+1)
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
		F.Reskin(btn)
	end

	-- ItemSetsFrame
	hooksecurefunc(EncounterJournal.LootJournal.ItemSetsFrame, "UpdateList", function(self)
		local buttons = self.buttons
		for i = 1, #buttons do
			local button = buttons[i]

			if not button.styled then
				button.ItemLevel:SetTextColor(1, 1, 1)
				button.Background:Hide()
				F.CreateBDFrame(button, .25)

				button.styled = true
			end
		end
	end)

	hooksecurefunc(EncounterJournal.LootJournal.ItemSetsFrame, "ConfigureItemButton", function(_, button)
		if not button.bg then
			button.Border:SetAlpha(0)
			button.Icon:SetTexCoord(.08, .92, .08, .92)
			button.bg = F.CreateBDFrame(button.Icon, .25)
		end

		local quality = select(3, GetItemInfo(button.itemID))
		local color = BAG_ITEM_QUALITY_COLORS[quality or 1]
		button.bg:SetBackdropBorderColor(color.r, color.g, color.b)
		button.bg.Shadow:SetBackdropBorderColor(color.r, color.g, color.b)
	end)
end