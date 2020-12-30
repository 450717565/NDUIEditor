local _, ns = ...
local B, C, L, DB = unpack(ns)
local Skins = B:GetModule("Skins")

local function Reskin_RefreshDisplay()
	local self = EncounterJournal.suggestFrame

	if #self.suggestions > 0 then
		local suggestion = self.Suggestion1
		local data = self.suggestions[1]

		if data.iconPath then
			suggestion.icon:SetMask(nil)
			suggestion.icon:SetTexCoord(unpack(DB.TexCoord))
		end
	end

	if #self.suggestions > 1 then
		for i = 2, #self.suggestions do
			local suggestion = self["Suggestion"..i]
			if not suggestion then return end

			local data = self.suggestions[i]
			if data.iconPath then
				suggestion.icon:SetMask(nil)
				suggestion.icon:SetTexCoord(unpack(DB.TexCoord))
			end
		end
	end
end

local function Reskin_UpdateRewards(suggestion)
	local rewardData = suggestion.reward.data
	if rewardData then
		suggestion.reward.icon:SetMask(nil)
		suggestion.reward.icon:SetTexCoord(unpack(DB.TexCoord))
	end
end

local function Reskin_DisplayInstance()
	local index = 1
	while true do
		local button = _G["EncounterJournalBossButton"..index]
		if not button then return end

		if not button.styled then
			B.StripTextures(button)
			button.creature:ClearAllPoints()
			button.creature:SetPoint("BOTTOMLEFT", button, "BOTTOMLEFT", 0, 0)

			local bubg = B.CreateBDFrame(button)
			B.ReskinHighlight(button, bubg, true)

			button.styled = true
		end

		index = index + 1
	end
end

local function Reskin_LootUpdate()
	local items = EncounterJournal.encounter.info.lootScroll.buttons
	for i = 1,#items do
		local item = items[i]
		if item.bossTexture and item.bossTexture:IsShown() then
			item.bubg:SetPoint("BOTTOM", item.bossTexture, "BOTTOM", 0, 0)
		else
			item.bubg:SetPoint("BOTTOM", item.icbg, "BOTTOM", 0, 0)
		end
	end
end

local r, g, b = GetItemQualityColor(5)

local function Reskin_PowersFrame(self)
	if not self.elements then return end

	for i = 1, self:GetNumElementFrames() do
		local button = self.elements[i]
		if button then
			if not button.styled then
				B.StripTextures(button, 1)
				local icbg = B.ReskinIcon(button.Icon)
				icbg:SetBackdropBorderColor(r, g, b)

				local bubg = B.CreateBGFrame(button, 2, 0, -5, 0, icbg)
				bubg:SetBackdropBorderColor(r, g, b)

				button.styled = true
			end
		end
	end
end

C.LUAThemes["Blizzard_EncounterJournal"] = function()
	B.ReskinFrame(EncounterJournal)

	-- Search Box
	B.ReskinInput(EncounterJournal.searchBox)
	B.StripTextures(EncounterJournalSearchBox.searchPreviewContainer)

	for i = 1, 5 do
		Skins.ReskinSearchBox(EncounterJournalSearchBox["sbutton"..i])
	end
	Skins.ReskinSearchBox(EncounterJournalSearchBox.showAllResults)
	Skins.ReskinSearchResult(EncounterJournal)

	-- Instance Select
	local instanceSelect = EncounterJournal.instanceSelect
	B.StripTextures(instanceSelect, 0)
	B.ReskinDropDown(instanceSelect.tierDropDown)
	B.ReskinScroll(EncounterJournalInstanceSelectScrollFrame.ScrollBar)

	local selectTabs = {
		"suggestTab",
		"dungeonsTab",
		"raidsTab",
		"LootJournalTab",
	}
	for _, selectTab in pairs(selectTabs) do
		local tab = instanceSelect[selectTab]
		B.StripTextures(tab)
		B.ReskinButton(tab)

		local text = tab:GetFontString()
		text:ClearAllPoints()
		text:SetPoint("CENTER")
	end

	-- Suggest Frame
	local suggestFrame = EncounterJournal.suggestFrame
	local bg = B.CreateBDFrame(suggestFrame)
	bg:SetOutside(suggestFrame.Suggestion1, 0, 0, suggestFrame.Suggestion3)

	for i = 1, 3 do
		local Suggestion = suggestFrame["Suggestion"..i]
		B.StripTextures(Suggestion)

		local icon = Suggestion.icon
		B.CreateBDFrame(icon, 0, -C.mult)

		local centerDisplay = Suggestion.centerDisplay
		B.ReskinText(centerDisplay.title.text, 1, .8, 0)
		B.ReskinText(centerDisplay.description.text, 1, 1, 1)
		if centerDisplay.button then B.ReskinButton(centerDisplay.button) end

		local reward = Suggestion.reward
		B.StripTextures(reward)
		local icbg = B.CreateBDFrame(reward.icon, 0, -C.mult)
		icbg:SetFrameLevel(reward:GetFrameLevel())
		if reward.text then B.ReskinText(reward.text, 1, 1, 1) end

		icon:ClearAllPoints()
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

	hooksecurefunc("EJSuggestFrame_RefreshDisplay", Reskin_RefreshDisplay)
	hooksecurefunc("EJSuggestFrame_UpdateRewards", Reskin_UpdateRewards)

	-- Loot Journal
	local lootJournal = EncounterJournal.LootJournal
	B.StripTextures(lootJournal)
	B.ReskinScroll(lootJournal.PowersFrame.ScrollBar)
	B.ReskinButton(lootJournal.RuneforgePowerFilterDropDownButton)
	B.ReskinButton(lootJournal.ClassDropDownButton)

	hooksecurefunc(lootJournal.PowersFrame, "RefreshListDisplay", Reskin_PowersFrame)

	-- Encounter Frame
	local encounterFrame = EncounterJournal.encounter
	local texts = {
		encounterFrame.infoFrame.description,
		encounterFrame.instance.loreScroll.child.lore,
		encounterFrame.overviewFrame.loreDescription,
		encounterFrame.overviewFrame.overviewDescription.Text,
	}
	for _, text in pairs(texts) do
		B.ReskinText(text, 1, 1, 1)
	end

	local infoFrame = encounterFrame.info
	B.StripTextures(infoFrame)
	B.StripTextures(infoFrame.model, 0)
	B.CreateBDFrame(infoFrame.model)

	infoFrame.instanceButton:Hide()
	infoFrame.overviewTab:ClearAllPoints()
	infoFrame.overviewTab:SetPoint("TOPLEFT", infoFrame, "TOPRIGHT", 5, -25)

	local buttons = {
		infoFrame.difficulty,
		infoFrame.lootScroll.filter,
		infoFrame.lootScroll.slotFilter,
	}
	for _, button in pairs(buttons) do
		B.ReskinButton(button)
	end

	local sideTabs = {
		"overviewTab",
		"lootTab",
		"bossTab",
		"modelTab",
	}
	for _, sideTab in pairs(sideTabs) do
		local tab = infoFrame[sideTab]
		B.CleanTextures(tab)
		tab:SetSize(60, 60)

		local bg = B.CreateBG(tab, 5, -5, -5, 5)
		B.ReskinHighlight(tab, bg, true)
	end

	local scrolls = {
		"InfoBossesScrollFrameScrollBar",
		"InfoDetailsScrollFrameScrollBar",
		"InfoLootScrollFrameScrollBar",
		"InfoOverviewScrollFrameScrollBar",
		"InstanceFrameLoreScrollFrameScrollBar",
	}
	for _, scroll in pairs(scrolls) do
		B.ReskinScroll(_G["EncounterJournalEncounterFrame"..scroll])
	end

	local items = infoFrame.lootScroll.buttons
	for i = 1, #items do
		local item = items[i]
		B.StripTextures(item)
		item.IconBorder:SetAlpha(0)

		local icon = item.icon
		icon:ClearAllPoints()
		icon:SetPoint("TOPLEFT", item, 3, -3)
		icon:SetSize(40, 40)

		local icbg = B.ReskinIcon(icon)
		item.icbg = icbg

		local border = item.IconBorder
		B.ReskinBorder(border, icbg)

		local bubg = B.CreateBGFrame(item, 2, 0, 0, 0, icbg)
		B.ReskinHighlight(item, bubg, true)
		item.bubg = bubg

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

	hooksecurefunc("EncounterJournal_LootUpdate", Reskin_LootUpdate)
	hooksecurefunc("EncounterJournal_DisplayInstance", Reskin_DisplayInstance)
end