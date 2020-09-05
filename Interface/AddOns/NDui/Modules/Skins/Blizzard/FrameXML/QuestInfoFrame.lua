local B, C, L, DB = unpack(select(2, ...))

tinsert(C.defaultThemes, function()
	local cr, cg, cb = DB.r, DB.g, DB.b

	-- Item reward highlight
	B.StripTextures(QuestInfoItemHighlight)
	local highlight = B.CreateBDFrame(QuestInfoItemHighlight, 0)
	highlight:SetBackdropColor(cr, cg, cb, .25)
	highlight:SetBackdropBorderColor(cr, cg, cb, 1)

	-- Reskin rewards
	local function restyleSpellButton(bu)
		local name = bu:GetDebugName()
		_G[name.."NameFrame"]:Hide()
		_G[name.."SpellBorder"]:Hide()

		local icon = bu.Icon
		icon:SetPoint("TOPLEFT", 3, -2)
		local icbg = B.ReskinIcon(icon)
		B.CreateBGFrame(bu, 2, 0, -5, 0, icbg)
	end
	restyleSpellButton(QuestInfoSpellObjectiveFrame)

	-- Reskin rewards
	local function restyleRewardButton(button, isMapQuestInfo)
		if not button then return end

		if button.NameFrame then button.NameFrame:Hide() end

		if button.Icon then
			if isMapQuestInfo then
				if button.Name then button.Name:SetFontObject(Game12Font) end
				button.Icon:SetSize(28, 28)
			else
				button.Icon:SetSize(38, 38)
			end

			local icbg = B.ReskinIcon(button.Icon)
			local bubg = B.CreateBDFrame(button, 0)
			bubg:SetPoint("TOPLEFT", icbg, "TOPRIGHT", 2, 0)
			bubg:SetPoint("BOTTOMRIGHT", icbg, "BOTTOMRIGHT", 102, 0)

			if button.IconBorder then
				B.ReskinBorder(button.IconBorder, icbg, bubg)
			end

			if highlight then
				highlight:SetAllPoints(bubg)
			end
		end
	end

	local frames =  {"HonorFrame", "MoneyFrame", "SkillPointFrame", "XPFrame", "ArtifactXPFrame", "TitleFrame", "WarModeBonusFrame"}
	for _, frame in pairs(frames) do
		local quests = QuestInfoRewardsFrame[frame]
		if quests then restyleRewardButton(quests) end

		local maps = MapQuestInfoRewardsFrame[frame]
		if maps then restyleRewardButton(maps, true) end
	end

	hooksecurefunc("QuestInfo_GetRewardButton", function(rewardsFrame, index)
		local bu = rewardsFrame.RewardButtons[index]

		if not bu.styled then
			restyleRewardButton(bu, rewardsFrame == MapQuestInfoRewardsFrame)

			bu.styled = true
		end
	end)

	-- Others
	local function reskinFollowerReward()
		local rewardsFrame = QuestInfoFrame.rewardsFrame
		local isQuestLog = QuestInfoFrame.questLog ~= nil
		local numSpellRewards = isQuestLog and GetNumQuestLogRewardSpells() or GetNumRewardSpells()

		if numSpellRewards > 0 then
			-- Spell Headers
			for spellHeader in rewardsFrame.spellHeaderPool:EnumerateActive() do
				spellHeader:SetVertexColor(1, 1, 1)
			end

			-- Follower Rewards
			for reward in rewardsFrame.followerRewardPool:EnumerateActive() do
				local PortraitFrame = reward.PortraitFrame
				if not reward.styled then
					PortraitFrame:ClearAllPoints()
					B.ReskinPortrait(PortraitFrame)

					reward.BG:Hide()
					reward.bg = B.CreateBDFrame(reward, 0)

					if reward.Class then
						B.ReskinFollowerClass(reward.Class, 36, "RIGHT", -2, 2)
					end

					reward.styled = true
				end

				if isQuestLog then
					PortraitFrame:SetPoint("TOPLEFT", 2, 0)
					reward.bg:SetPoint("TOPLEFT", 0, 1)
					reward.bg:SetPoint("BOTTOMRIGHT", 2, -3)
				else
					PortraitFrame:SetPoint("TOPLEFT", 2, -5)
					reward.bg:SetPoint("TOPLEFT", 0, -3)
					reward.bg:SetPoint("BOTTOMRIGHT", 2, 7)
				end

				if PortraitFrame then
					B.UpdatePortraitColor(PortraitFrame)
				end
			end

			-- Spell Rewards
			for spellReward in rewardsFrame.spellRewardPool:EnumerateActive() do
				if not spellReward.styled then
					B.StripTextures(spellReward, 1)

					local icon = spellReward.Icon
					if isQuestLog then
						icon:SetSize(28, 28)
					else
						icon:SetSize(38, 38)
					end

					local icbg = B.ReskinIcon(icon)
					local bubg = B.CreateBDFrame(spellReward.NameFrame, 0)
					bubg:SetPoint("TOPLEFT", icbg, "TOPRIGHT", 2, 0)
					bubg:SetPoint("BOTTOMRIGHT", icbg, "BOTTOMRIGHT", 102, 0)

					spellReward.styled = true
				end
			end
		end
	end

	hooksecurefunc("QuestInfo_Display", reskinFollowerReward)

	-- Quest objective text color
	local function QuestInfo_GetQuestID()
		if QuestInfoFrame.questLog then
			return select(8, GetQuestLogTitle(GetQuestLogSelection()))
		else
			return GetQuestID()
		end
	end

	local function colourObjectivesText()
		if not QuestInfoFrame.questLog then return end

		local questID = QuestInfo_GetQuestID()
		local objectivesTable = QuestInfoObjectivesFrame.Objectives
		local numVisibleObjectives = 0

		local waypointText = C_QuestLog.GetNextWaypointText(questID);
		if waypointText then
			numVisibleObjectives = numVisibleObjectives + 1
			objective = objectivesTable[numVisibleObjectives]

			objective:SetTextColor(1, 1, 1)
		end

		for i = 1, GetNumQuestLeaderBoards() do
			local _, type, finished = GetQuestLogLeaderBoard(i)

			if type ~= "spell" and type ~= "log" and numVisibleObjectives < MAX_OBJECTIVES then
				numVisibleObjectives = numVisibleObjectives + 1
				objective = objectivesTable[numVisibleObjectives]

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

	-- Other text colours
	local function colourGeneralsText()
		local headers = {QuestInfoDescriptionHeader, QuestInfoObjectivesHeader, QuestInfoRewardsFrame.Header, QuestInfoTitleHeader, QuestInfoSpellObjectiveLearnLabel}
		for _, header in pairs(headers) do
			header:SetTextColor(1, .8, 0)
		end

		local texts = {QuestInfoDescriptionText, QuestInfoGroupSize, QuestInfoObjectivesText, QuestInfoRewardsFrame.ItemChooseText, QuestInfoRewardsFrame.ItemReceiveText, QuestInfoRewardsFrame.PlayerTitleText, QuestInfoRewardsFrame.XPFrame.ReceiveText, QuestInfoRewardText}
		for _, text in pairs(texts) do
			text:SetTextColor(1, 1, 1)
		end

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
end)