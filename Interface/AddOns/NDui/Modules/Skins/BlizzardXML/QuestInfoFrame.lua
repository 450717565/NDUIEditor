local _, ns = ...
local B, C, L, DB = unpack(ns)
local S = B:GetModule("Skins")

local cr, cg, cb = DB.cr, DB.cg, DB.cb

local function QuestInfo_GetQuestID()
	if QuestInfoFrame.questLog then
		return C_QuestLog.GetSelectedQuest()
	else
		return GetQuestID()
	end
end

local function Reskin_ObjectivesText()
	if not QuestInfoFrame.questLog then return end

	local questID = QuestInfo_GetQuestID()
	local objectivesTable = QuestInfoObjectivesFrame.Objectives
	local numVisibleObjectives = 0
	local objective

	local waypointText = C_QuestLog.GetNextWaypointText(questID);
	if waypointText then
		numVisibleObjectives = numVisibleObjectives + 1;
		objective = objectivesTable[numVisibleObjectives]

		B.ReskinText(objective, 1, 0, 1)
	end

	for i = 1, GetNumQuestLeaderBoards() do
		local _, objectiveType, isCompleted = GetQuestLogLeaderBoard(i)

		if (objectiveType ~= "spell" and objectiveType ~= "log" and numVisibleObjectives < MAX_OBJECTIVES) then
			numVisibleObjectives = numVisibleObjectives + 1
			objective = objectivesTable[numVisibleObjectives]

			if objective then
				if isCompleted then
					B.ReskinText(objective, 0, 1, 0)
				else
					B.ReskinText(objective, 1, 0, 0)
				end
			end
		end
	end
end

local function Reskin_GeneralsText()
	local titles = {
		QuestInfoDescriptionHeader,
		QuestInfoObjectivesHeader,
		QuestInfoRewardsFrame.Header,
		QuestInfoSpellObjectiveLearnLabel,
		QuestInfoTitleHeader,
	}
	for _, title in pairs(titles) do
		B.ReskinText(title, 1, .8, 0)
	end

	local texts = {
		QuestInfoDescriptionText,
		QuestInfoGroupSize,
		QuestInfoObjectivesText,
		QuestInfoRewardsFrame.ItemChooseText,
		QuestInfoRewardsFrame.ItemReceiveText,
		QuestInfoRewardsFrame.PlayerTitleText,
		QuestInfoRewardsFrame.XPFrame.ReceiveText,
		QuestInfoRewardText,
	}
	for _, text in pairs(texts) do
		B.ReskinText(text, 1, 1, 1)
	end

	B.ReskinText(QuestInfoQuestType, 0, 1, 1)
end

local function Reskin_RewardButton(self, isMapQuestInfo)
	if not self then return end

	B.StripTextures(self, 1)

	if self.Icon then
		if isMapQuestInfo then
			if self.Name then self.Name:SetFontObject(Game12Font) end
			self.Icon:SetSize(28, 28)
		else
			self.Icon:SetSize(38, 38)
		end

		local icbg = B.ReskinIcon(self.Icon)
		local bubg = B.CreateBDFrame(self)
		bubg:SetPoint("TOPLEFT", icbg, "TOPRIGHT", 2, 0)
		bubg:SetPoint("BOTTOMRIGHT", icbg, "BOTTOMRIGHT", 102, 0)

		if self.IconBorder then
			B.ReskinBorder(self.IconBorder, icbg, bubg)
		end
	end
end

local function Reskin_GetRewardButton(rewardsFrame, index)
	local button = rewardsFrame.RewardButtons[index]

	if not button.styled then
		Reskin_RewardButton(button, rewardsFrame == MapQuestInfoRewardsFrame)

		button.styled = true
	end

	if QuestInfoFrame.chooseItems then
		if button.type == "choice" then
			button.bubg:SetBackdropColor(cr, cg, cb, .5)
		else
			button.bubg:SetBackdropColor(0, 0, 0, 0)
		end
	end
end

local function Reskin_SpecialReward()
	local rewardsFrame = QuestInfoFrame.rewardsFrame
	local isQuestLog = QuestInfoFrame.questLog ~= nil
	local numSpellRewards = isQuestLog and GetNumQuestLogRewardSpells() or GetNumRewardSpells()

	if numSpellRewards > 0 then
		-- Spell Headers
		for spellHeader in rewardsFrame.spellHeaderPool:EnumerateActive() do
			spellHeader:SetVertexColor(1, 1, 1)
		end

		-- Spell Rewards
		for spellReward in rewardsFrame.spellRewardPool:EnumerateActive() do
			if not spellReward.styled then
				Reskin_RewardButton(spellReward, isQuestLog)

				spellReward.styled = true
			end
		end

		-- Follower Rewards
		for followerReward in rewardsFrame.followerRewardPool:EnumerateActive() do
			local class = followerReward.Class
			local portrait = followerReward.PortraitFrame

			if not followerReward.styled then
				S.ReskinFollowerPortrait(portrait)

				followerReward.BG:Hide()
				local bubg = B.CreateBDFrame(followerReward)
				bubg:SetPoint("TOPLEFT", 0, -3)
				bubg:SetPoint("BOTTOMRIGHT", 2, 7)
				followerReward.bubg = bubg

				if class then
					S.ReskinFollowerClass(class, 36, "RIGHT", -2, 2)
				end

				followerReward.styled = true
			end

			portrait:ClearAllPoints()
			followerReward.bubg:ClearAllPoints()
			if isQuestLog then
				portrait:SetPoint("TOPLEFT", 2, 0)
				followerReward.bubg:SetPoint("TOPLEFT", 0, 1)
				followerReward.bubg:SetPoint("BOTTOMRIGHT", 2, -3)
			else
				portrait:SetPoint("TOPLEFT", 2, -5)
				followerReward.bubg:SetPoint("TOPLEFT", 0, -3)
				followerReward.bubg:SetPoint("BOTTOMRIGHT", 2, -2)
			end

			if portrait then
				S.UpdateFollowerQuality(portrait)
			end
		end
	end
end

local replacedSealColor = {
	["480404"] = "c20606",
	["042c54"] = "1c86ee",
}

local function Reskin_SealFrameText(self, text)
	if text and text ~= "" then
		local colorStr, rawText = string.match(text, "|c[fF][fF](%x%x%x%x%x%x)(.-)|r")
		if colorStr and rawText then
			colorStr = replacedSealColor[colorStr] or "99ccff"
			self:SetFormattedText("|cff%s%s|r", colorStr, rawText)
		end
	end
end

tinsert(C.XMLThemes, function()
	-- Text Color
	B.ReskinText(QuestProgressRequiredItemsText, 1, .8, 0)
	hooksecurefunc("QuestInfo_Display", Reskin_GeneralsText)
	hooksecurefunc("QuestInfo_Display", Reskin_ObjectivesText)
	hooksecurefunc("QuestInfo_Display", Reskin_SpecialReward)
	hooksecurefunc(QuestInfoSealFrame.Text, "SetText", Reskin_SealFrameText)
	hooksecurefunc(QuestInfoRequiredMoneyText, "SetTextColor", S.ReskinRMTColor)

	-- Quest Info Item
	B.StripTextures(QuestInfoItemHighlight)

	local frames =  {
		"ArtifactXPFrame",
		"HonorFrame",
		"MoneyFrame",
		"SkillPointFrame",
		"TitleFrame",
		"WarModeBonusFrame",
		"XPFrame",
	}
	for _, frame in pairs(frames) do
		local quests = QuestInfoRewardsFrame[frame]
		if quests then Reskin_RewardButton(quests) end

		local maps = MapQuestInfoRewardsFrame[frame]
		if maps then Reskin_RewardButton(maps, true) end
	end

	hooksecurefunc("QuestInfo_GetRewardButton", Reskin_GetRewardButton)

	-- Quest Progress Item
	for i = 1, MAX_REQUIRED_ITEMS do
		local item = "QuestProgressItem"..i
		B.StripTextures(_G[item])

		local icon = _G[item.."IconTexture"]
		local icbg = B.ReskinIcon(icon)
		B.CreateBGFrame(_G[item], 2, 0, -5, 0, icbg)
	end
end)