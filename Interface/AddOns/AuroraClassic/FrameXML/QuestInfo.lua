local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	local cr, cg, cb = C.r, C.g, C.b

	-- [[ Item reward highlight ]]
	do
		QuestInfoItemHighlight:GetRegions():Hide()

		local function clearHighlight()
			for _, button in pairs(QuestInfoRewardsFrame.RewardButtons) do
				button.bg:SetBackdropColor(0, 0, 0, 0)
			end
		end

		local function setHighlight(self)
			clearHighlight()

			local _, point = self:GetPoint()
			if point then
				point.bg:SetBackdropColor(cr, cg, cb, .25)
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
		for _, frame in next, frames do
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
			for _, header in next, headers do
				header:SetTextColor(1, .8, 0)
			end

			local texts = {QuestInfoDescriptionText, QuestInfoGroupSize, QuestInfoObjectivesText, QuestInfoRewardsFrame.ItemChooseText, QuestInfoRewardsFrame.ItemReceiveText, QuestInfoRewardsFrame.PlayerTitleText, QuestInfoRewardsFrame.XPFrame.ReceiveText, QuestInfoRewardText}
			for _, text in next, texts do
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