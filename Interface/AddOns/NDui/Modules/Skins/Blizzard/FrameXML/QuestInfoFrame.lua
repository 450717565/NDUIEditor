local B, C, L, DB = unpack(select(2, ...))

tinsert(C.defaultThemes, function()
	local cr, cg, cb = DB.r, DB.g, DB.b

	-- Item reward highlight
	B.StripTextures(QuestInfoItemHighlight)

	local function clearHighlight()
		for _, button in pairs(QuestInfoRewardsFrame.RewardButtons) do
			button.bg:SetBackdropColor(0, 0, 0, 0)
		end
	end

	local function setHighlight(self)
		clearHighlight()

		local relativeTo = select(2, self:GetPoint())
		if relativeTo then
			relativeTo.bg:SetBackdropColor(cr, cg, cb, .25)
		end
	end

	hooksecurefunc(QuestInfoItemHighlight, "SetPoint", setHighlight)
	QuestInfoItemHighlight:HookScript("OnShow", setHighlight)
	QuestInfoItemHighlight:HookScript("OnHide", clearHighlight)

	-- Reskin rewards
	local function restyleSpellButton(bu)
		local name = bu:GetName()
		_G[name.."NameFrame"]:Hide()
		_G[name.."SpellBorder"]:Hide()

		local icon = bu.Icon
		icon:SetPoint("TOPLEFT", 3, -2)
		local icbg = B.ReskinIcon(icon)

		local bubg = B.CreateBDFrame(bu, 0)
		bubg:SetPoint("TOPLEFT", icbg, "TOPRIGHT", 2, 0)
		bubg:SetPoint("BOTTOMRIGHT", icbg, "BOTTOMRIGHT", -5, 0)
	end
	restyleSpellButton(QuestInfoSpellObjectiveFrame)

	-- Reskin rewards
	local function restyleRewardButton(bu, isMapQuestInfo)
		if not bu then return end

		if bu.NameFrame then bu.NameFrame:Hide() end
		if bu.IconBorder then bu.IconBorder:SetAlpha(0) end

		if bu.Icon then
			if isMapQuestInfo then
				bu.Icon:SetSize(28, 28)
			else
				bu.Icon:SetSize(38, 38)
			end

			local icbg = B.ReskinIcon(bu.Icon)
			local bubg = B.CreateBDFrame(bu, 0)
			bubg:SetPoint("TOPLEFT", icbg, "TOPRIGHT", 2, 0)
			bubg:SetPoint("BOTTOMRIGHT", icbg, "BOTTOMRIGHT", 102, 0)

			bu.bg = bubg
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
				local portrait = reward.PortraitFrame
				if not reward.styled then
					portrait:ClearAllPoints()
					B.ReskinGarrisonPortrait(portrait)

					reward.BG:Hide()
					reward.bg = B.CreateBDFrame(reward, 0)

					if reward.Class then
						reward.Class:SetSize(36, 36)
						reward.Class:ClearAllPoints()
						reward.Class:SetPoint("RIGHT", -2, 2)
						reward.Class:SetTexCoord(.18, .92, .08, .92)
						B.CreateBDFrame(reward.Class, 0)
					end

					reward.styled = true
				end

				if isQuestLog then
					portrait:SetPoint("TOPLEFT", 2, 0)
					reward.bg:SetPoint("TOPLEFT", 0, 1)
					reward.bg:SetPoint("BOTTOMRIGHT", 2, -3)
				else
					portrait:SetPoint("TOPLEFT", 2, -5)
					reward.bg:SetPoint("TOPLEFT", 0, -3)
					reward.bg:SetPoint("BOTTOMRIGHT", 2, 7)
				end

				if portrait then
					local color = DB.QualityColors[portrait.quality or 1]
					portrait.squareBG:SetBackdropBorderColor(color.r, color.g, color.b)
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