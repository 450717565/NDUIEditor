local B, C, L, DB = unpack(select(2, ...))
local Skins = B:GetModule("Skins")

local function reskinRewards(button)
	for index = 1, 3 do
		local reward = button.Rewards["Reward"..index]
		if reward then
			if not reward.styled then
				local icbg = B.ReskinIcon(reward.Icon)
				B.ReskinBorder(reward.IconBorder, icbg)

				reward.styled = true
			end

			reward:ClearAllPoints()
			if index == 1 then
				reward:SetPoint("RIGHT", button, "RIGHT", -5, 0)
			else
				reward:SetPoint("RIGHT", button.Rewards["Reward"..(index-1)].icbg, "LEFT", -2, 0)
			end
		end
	end
end

local function reskinCategory(category)
	B.StripTextures(category)
	B.ReskinButton(category)

	for _, setting in ipairs(category.settings) do
		if setting.DropDown then
			B.ReskinDropDown(setting.DropDown)
		end

		if setting.Slider then
			B.ReskinSlider(setting.Slider)
		end

		if setting.TextBox then
			B.ReskinInput(setting.TextBox)
		end

		if setting.Button then
			B.ReskinButton(setting.Button)
		end

		if setting.CheckBox then
			B.ReskinCheck(setting.CheckBox)
		end

		if setting.ResetButton then
			B.ReskinButton(setting.ResetButton)
		end

		if setting.Picker then
			B.ReskinButton(setting.Picker)
			setting.Picker.Color:SetInside(setting.Picker.__Tex, 0, 0)
		end
	end
end

function Skins:WorldQuestTab()
	if not IsAddOnLoaded("WorldQuestTab") then return end

	B.StripTextures(WQT_OverlayFrame)
	B.StripTextures(WQT_OverlayFrame.DetailFrame)
	B.StripTextures(WQT_QuestLogFiller)
	B.StripTextures(WQT_QuestScrollFrame.DetailFrame)
	B.StripTextures(WQT_SettingsFrame)
	B.StripTextures(WQT_SettingsFrame.ScrollFrame.ScrollBar)
	B.StripTextures(WQT_WorldQuestFrame, 0)

	B.CreateBDFrame(WQT_SettingsFrameThumbTexture)
	B.ReskinButton(WQT_WorldQuestFrameSettingsButton)
	B.ReskinClose(WQT_OverlayFrame.CloseButton)
	B.ReskinDropDown(WQT_WorldQuestFrameSortButton)
	B.ReskinFilter(WQT_WorldQuestFrameFilterButton)
	B.ReskinScroll(WQT_QuestScrollFrameScrollBar)

	reskinRewards(WQT_SettingsQuestListPreview.Preview)

	for _, tab in pairs({WQT_TabNormal, WQT_TabWorld}) do
		B.StripTextures(tab, 2)
		B.ReskinButton(tab)

		local icon = tab.Icon
		icon:ClearAllPoints()
		icon:SetPoint("CENTER")

		B.ReskinHighlight(tab.Hider, tab)
	end

	for i = 1, 15 do
		local button = _G["WQT_QuestScrollFrameButton"..i]
		reskinRewards(button)

		local Faction = button.Faction
		Faction.Ring:Hide()

		local Title = button.Title
		Title:ClearAllPoints()
		Title:SetPoint("BOTTOMLEFT", Faction, "RIGHT", 0, 0)

		local Time = button.Time
		Time:ClearAllPoints()
		Time:SetPoint("TOPLEFT", Faction, "RIGHT", 5, 0)
	end

	local function reskinSettings(event)
		for _, category in ipairs(WQT_SettingsFrame.categories) do
			reskinCategory(category)

			local numSubs = #category.subCategories
			if numSubs > 0 then
				for i = 1, numSubs do
					reskinCategory(category.subCategories[i])
				end
			end
		end

		B:UnregisterEvent(event, reskinSettings)
	end
	B:RegisterEvent("PLAYER_ENTERING_WORLD", reskinSettings)
end