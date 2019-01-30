local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	local r, g, b = C.r, C.g, C.b

	-- [[ Item reward highlight ]]

	QuestInfoItemHighlight:GetRegions():Hide()

	local function clearHighlight()
		for _, button in pairs(QuestInfoRewardsFrame.RewardButtons) do
			button.bg:SetBackdropColor(0, 0, 0, .25)
		end
	end

	local function setHighlight(self)
		clearHighlight()

		local _, point = self:GetPoint()
		if point then
			point.bg:SetBackdropColor(r, g, b, .25)
		end
	end

	hooksecurefunc(QuestInfoItemHighlight, "SetPoint", setHighlight)
	QuestInfoItemHighlight:HookScript("OnShow", setHighlight)
	QuestInfoItemHighlight:HookScript("OnHide", clearHighlight)

	-- [[ Shared ]]

	local function restyleSpellButton(bu)
		local name = bu:GetName()
		_G[name.."NameFrame"]:Hide()
		_G[name.."SpellBorder"]:Hide()

		bu.Icon:SetDrawLayer("ARTWORK", 1)
		local ic = F.ReskinIcon(bu.Icon)

		local bg = F.CreateBDFrame(bu, 0)
		bg:SetPoint("TOPLEFT", ic, "TOPRIGHT", 2, 0)
		bg:SetPoint("BOTTOMRIGHT", -5, 0)
	end
	restyleSpellButton(QuestInfoSpellObjectiveFrame)

	local function colourObjectivesText()
		if not QuestInfoFrame.questLog then return end

		local objectivesTable = QuestInfoObjectivesFrame.Objectives
		local numVisibleObjectives = 0

		for i = 1, GetNumQuestLeaderBoards() do
			local _, type, finished = GetQuestLogLeaderBoard(i)

			if (type ~= "spell" and type ~= "log" and numVisibleObjectives < MAX_OBJECTIVES) then
				numVisibleObjectives = numVisibleObjectives + 1
				local objective = objectivesTable[numVisibleObjectives]

				if objective then
					if finished then
						objective:SetTextColor(.9, .9, .9)
					else
						objective:SetTextColor(1, 1, 1)
					end
				end
			end
		end
	end

	hooksecurefunc("QuestMapFrame_ShowQuestDetails", colourObjectivesText)
	hooksecurefunc("QuestInfo_Display", colourObjectivesText)

	-- [[ Quest rewards ]]

	local function restyleRewardButton(bu, isMapQuestInfo)
		bu.NameFrame:Hide()

		bu.Icon:SetDrawLayer("ARTWORK", 1)
		local ic = F.ReskinIcon(bu.Icon)

		local bg = F.CreateBDFrame(bu, 0)
		bg:SetPoint("TOPLEFT", ic, "TOPRIGHT", 2, 0)
		bg:SetPoint("BOTTOMRIGHT", -5, 0)

		if bu.IconBorder then
			bu.IconBorder:SetAlpha(0)
		end

		if isMapQuestInfo then
			bu.Icon:SetSize(29, 29)
		end

		bu.bg = bg
	end

	hooksecurefunc("QuestInfo_GetRewardButton", function(rewardsFrame, index)
		local bu = rewardsFrame.RewardButtons[index]

		if not bu.restyled then
			restyleRewardButton(bu, rewardsFrame == MapQuestInfoRewardsFrame)

			bu.restyled = true
		end
	end)

	MapQuestInfoRewardsFrame.XPFrame.Name:SetShadowOffset(0, 0)
	for _, name in next, {"HonorFrame", "MoneyFrame", "SkillPointFrame", "XPFrame", "ArtifactXPFrame", "TitleFrame"} do
		restyleRewardButton(MapQuestInfoRewardsFrame[name], true)
	end

	for _, name in next, {"HonorFrame", "SkillPointFrame", "ArtifactXPFrame"} do
		restyleRewardButton(QuestInfoRewardsFrame[name])
	end

	-- Spell Rewards

	local spellRewards = {QuestInfoRewardsFrame, MapQuestInfoRewardsFrame}
	for _, rewardFrame in pairs(spellRewards) do
		local spellRewardFrame = rewardFrame.spellRewardPool:Acquire()

		local icon = spellRewardFrame.Icon
		icon:SetSize(29, 29)

		local nameFrame = spellRewardFrame.NameFrame
		nameFrame:Hide()

		local ic = F.ReskinIcon(icon)

		local bg = F.CreateBDFrame(nameFrame, 0)
		bg:SetPoint("TOPLEFT", ic, "TOPRIGHT", 2, 0)
		bg:SetPoint("BOTTOMRIGHT", -1, -1)
	end

	-- Title Reward
	do
		local frame = QuestInfoPlayerTitleFrame
		for i = 2, 4 do
			select(i, frame:GetRegions()):Hide()
		end

		local ic = F.ReskinIcon(frame.Icon)

		local bg = F.CreateBDFrame(frame, 0)
		bg:SetPoint("TOPLEFT", ic, "TOPRIGHT", 2, 0)
		bg:SetPoint("BOTTOMRIGHT", -1, -1)
	end

	-- Follower Rewards
	hooksecurefunc("QuestInfo_Display", function()
		local rewardsFrame = QuestInfoFrame.rewardsFrame
		local isQuestLog = QuestInfoFrame.questLog ~= nil
		local numSpellRewards = isQuestLog and GetNumQuestLogRewardSpells() or GetNumRewardSpells()

		if numSpellRewards > 0 then
			for reward in rewardsFrame.followerRewardPool:EnumerateActive() do
				local class = reward.Class
				local portrait = reward.PortraitFrame
				if not reward.styled then
					portrait:ClearAllPoints()
					portrait:SetPoint("TOPLEFT", 2, -5)
					F.ReskinGarrisonPortrait(portrait)

					reward.BG:Hide()
					local bg = F.CreateBDFrame(reward, 0)
					bg:SetPoint("TOPLEFT", 0, -3)
					bg:SetPoint("BOTTOMRIGHT", 2, 7)

					if class then
						class:SetSize(35, 35)
						class:ClearAllPoints()
						class:SetPoint("RIGHT", -3, 2)
						class:SetTexCoord(.18, .92, .08, .92)
						F.CreateBDFrame(class, 0)
					end

					reward.styled = true
				end

				if portrait then
					local color = BAG_ITEM_QUALITY_COLORS[portrait.quality or 1]
					portrait.squareBG:SetBackdropBorderColor(color.r, color.g, color.b)
				end
			end
		end
	end)

	-- [[ Change text colours ]]

	hooksecurefunc(QuestInfoRequiredMoneyText, "SetTextColor", function(self, r)
		if r == 0 then
			self:SetTextColor(.8, .8, .8)
		elseif r == .2 then
			self:SetTextColor(1, 1, 1)
		end
	end)

	QuestFont:SetTextColor(1, 1, 1)

	QuestInfoDescriptionHeader:SetTextColor(1, 1, 1)
	QuestInfoDescriptionHeader.SetTextColor = F.Dummy
	QuestInfoDescriptionHeader:SetShadowColor(0, 0, 0)

	QuestInfoDescriptionText:SetTextColor(1, 1, 1)
	QuestInfoDescriptionText.SetTextColor = F.Dummy

	QuestInfoGroupSize:SetTextColor(1, 1, 1)
	QuestInfoGroupSize.SetTextColor = F.Dummy

	QuestInfoObjectivesHeader:SetTextColor(1, 1, 1)
	QuestInfoObjectivesHeader.SetTextColor = F.Dummy
	QuestInfoObjectivesHeader:SetShadowColor(0, 0, 0)

	QuestInfoObjectivesText:SetTextColor(1, 1, 1)
	QuestInfoObjectivesText.SetTextColor = F.Dummy

	QuestInfoRewardsFrame.Header:SetTextColor(1, 1, 1)
	QuestInfoRewardsFrame.Header.SetTextColor = F.Dummy
	QuestInfoRewardsFrame.Header:SetShadowColor(0, 0, 0)

	QuestInfoRewardsFrame.ItemChooseText:SetTextColor(1, 1, 1)
	QuestInfoRewardsFrame.ItemChooseText.SetTextColor = F.Dummy

	QuestInfoRewardsFrame.ItemReceiveText:SetTextColor(1, 1, 1)
	QuestInfoRewardsFrame.ItemReceiveText.SetTextColor = F.Dummy

	QuestInfoRewardsFrame.PlayerTitleText:SetTextColor(1, 1, 1)
	QuestInfoRewardsFrame.PlayerTitleText.SetTextColor = F.Dummy

	QuestInfoRewardsFrame.spellHeaderPool:Acquire():SetVertexColor(1, 1, 1)
	QuestInfoRewardsFrame.spellHeaderPool:Acquire().SetVertexColor = F.Dummy

	QuestInfoRewardsFrame.XPFrame.ReceiveText:SetTextColor(1, 1, 1)
	QuestInfoRewardsFrame.XPFrame.ReceiveText.SetTextColor = F.Dummy

	QuestInfoRewardText:SetTextColor(1, 1, 1)
	QuestInfoRewardText.SetTextColor = F.Dummy

	QuestInfoSpellObjectiveLearnLabel:SetTextColor(1, 1, 1)
	QuestInfoSpellObjectiveLearnLabel.SetTextColor = F.Dummy

	QuestInfoTitleHeader:SetTextColor(1, 1, 1)
	QuestInfoTitleHeader.SetTextColor = F.Dummy
	QuestInfoTitleHeader:SetShadowColor(0, 0, 0)

end)