local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	local cr, cg, cb = C.r, C.g, C.b

	-- [[ Item reward highlight ]]
	do
		F.StripTextures(QuestInfoItemHighlight)

		local function clearHighlight()
			for _, button in pairs(QuestInfoRewardsFrame.RewardButtons) do
				button.bg:SetBackdropColor(0, 0, 0, 0)
			end
		end

		local function setHighlight(self)
			clearHighlight()

			local _, relativeTo = self:GetPoint()
			if relativeTo then
				relativeTo.bg:SetBackdropColor(cr, cg, cb, .25)
			end
		end

		hooksecurefunc(QuestInfoItemHighlight, "SetPoint", setHighlight)
		QuestInfoItemHighlight:HookScript("OnShow", setHighlight)
		QuestInfoItemHighlight:HookScript("OnHide", clearHighlight)
	end

	-- [[ Quest rewards ]]
	do
		local function reskinRewards(bu, isMapQuestInfo)
			if bu.NameFrame then bu.NameFrame:Hide() end
			if bu.IconBorder then bu.IconBorder:SetAlpha(0) end

			if bu.Icon then
				if isMapQuestInfo then bu.Icon:SetSize(28, 28) end

				local icbg = F.ReskinIcon(bu.Icon)
				local bubg = F.CreateBDFrame(bu, 0)
				bubg:SetPoint("TOPLEFT", icbg, "TOPRIGHT", 2, 0)
				bubg:SetPoint("BOTTOMRIGHT", icbg, "BOTTOMRIGHT", 102, 0)

				bu.bg = bubg
			end
		end

		local frames =  {"HonorFrame", "MoneyFrame", "SkillPointFrame", "XPFrame", "ArtifactXPFrame", "TitleFrame"}
		for _, frame in pairs(frames) do
			local quests = QuestInfoRewardsFrame[frame]
			if quests then reskinRewards(quests) end

			local maps = MapQuestInfoRewardsFrame[frame]
			if maps then reskinRewards(maps, true) end
		end

		hooksecurefunc("QuestInfo_GetRewardButton", function(rewardsFrame, index)
			local bu = rewardsFrame.RewardButtons[index]

			if not bu.styled then
				reskinRewards(bu, rewardsFrame == MapQuestInfoRewardsFrame)

				bu.styled = true
			end
		end)
	end

	-- [[ Spell rewards ]]
	do
		local quests = QuestInfoRewardsFrame.spellRewardPool:Acquire()
		quests.NameFrame:Hide()

		local maps = MapQuestInfoRewardsFrame.spellRewardPool:Acquire()
		maps.NameFrame:Hide()
		maps.Icon:SetSize(28, 28)

		local icbg = F.ReskinIcon(maps.Icon)
		local bubg = F.CreateBDFrame(maps.NameFrame, 0)
		bubg:SetPoint("TOPLEFT", icbg, "TOPRIGHT", 2, 0)
		bubg:SetPoint("BOTTOMRIGHT", icbg, "BOTTOMRIGHT", 102, 0)
	end

	-- [[ Follower rewards ]]
	do
		local function reskinFollowerReward()
			local rewardsFrame = QuestInfoFrame.rewardsFrame
			local isQuestLog = QuestInfoFrame.questLog ~= nil
			local numSpellRewards = isQuestLog and GetNumQuestLogRewardSpells() or GetNumRewardSpells()

			if numSpellRewards > 0 then
				for reward in rewardsFrame.followerRewardPool:EnumerateActive() do
					local portrait = reward.PortraitFrame
					if not reward.styled then
						portrait:ClearAllPoints()
						portrait:SetPoint("LEFT", 2, 0)
						F.ReskinGarrisonPortrait(portrait)

						reward.BG:Hide()
						local bg = F.CreateBDFrame(reward, 0)
						bg:SetPoint("TOPLEFT", 0, -3)
						bg:SetPoint("BOTTOMRIGHT", 2, 7)

						if reward.Class then
							reward.Class:SetSize(36, 36)
							reward.Class:ClearAllPoints()
							reward.Class:SetPoint("RIGHT", -2, 2)
							reward.Class:SetTexCoord(.18, .92, .08, .92)
							F.CreateBDFrame(reward.Class, 0)
						end

						reward.styled = true
					end

					if portrait then
						local color = BAG_ITEM_QUALITY_COLORS[portrait.quality or 1]
						portrait.squareBG:SetBackdropBorderColor(color.r, color.g, color.b)
					end
				end
			end
		end

		hooksecurefunc("QuestInfo_Display", reskinFollowerReward)
	end

	-- [[ Change text colours ]]
	do
		local function colourObjectivesText()
			if not QuestInfoFrame.questLog then return end

			local objectivesTable = QuestInfoObjectivesFrame.Objectives
			local numVisibleObjectives = 0

			for i = 1, GetNumQuestLeaderBoards() do
				local _, type, finished = GetQuestLogLeaderBoard(i)

				if type ~= "spell" and type ~= "log" and numVisibleObjectives < MAX_OBJECTIVES then
					numVisibleObjectives = numVisibleObjectives + 1
					local objective = objectivesTable[numVisibleObjectives]

					if objective then
						if finished then
							objective:SetTextColor(0, 1, 0)
						else
							objective:SetTextColor(1, 0, 0)
						end
					end
				end
			end
		end

		local function colourGeneralsText()
			local headers = {QuestInfoDescriptionHeader, QuestInfoObjectivesHeader, QuestInfoRewardsFrame.Header, QuestInfoTitleHeader, QuestInfoSpellObjectiveLearnLabel}
			for _, header in pairs(headers) do
				header:SetTextColor(1, .8, 0)
			end

			local texts = {QuestInfoDescriptionText, QuestInfoGroupSize, QuestInfoObjectivesText, QuestInfoRewardsFrame.ItemChooseText, QuestInfoRewardsFrame.ItemReceiveText, QuestInfoRewardsFrame.PlayerTitleText, QuestInfoRewardsFrame.XPFrame.ReceiveText, QuestInfoRewardText}
			for _, text in pairs(texts) do
				text:SetTextColor(1, 1, 1)
			end

			local spellHeaderPool = QuestInfoRewardsFrame.spellHeaderPool
			spellHeaderPool.textR, spellHeaderPool.textG, spellHeaderPool.textB = 1, 1, 1

			QuestInfoQuestType:SetTextColor(0, 1, 1)
		end

		hooksecurefunc("QuestInfo_Display", colourObjectivesText)
		hooksecurefunc("QuestInfo_Display", colourGeneralsText)

		hooksecurefunc(QuestInfoRequiredMoneyText, "SetTextColor", function(self, r)
			if r == 0 then
				self:SetTextColor(1, 0, 0)
			elseif r == .2 then
				self:SetTextColor(0, 1, 0)
			end
		end)

		QuestFont:SetTextColor(1, 1, 1)
	end
end)