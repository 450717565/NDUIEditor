local _, ns = ...
local B, C, L, DB = unpack(ns)
local Skins = B:GetModule("Skins")

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

		if highlight then
			highlight:SetAllPoints(bubg)
		end
	end
end

local function Reskin_GetRewardButton(rewardsFrame, index)
	local button = rewardsFrame.RewardButtons[index]

	if not button.styled then
		Reskin_RewardButton(button, rewardsFrame == MapQuestInfoRewardsFrame)

		button.styled = true
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

		-- Follower Rewards
		for followerReward in rewardsFrame.followerRewardPool:EnumerateActive() do
			local PortraitFrame = followerReward.PortraitFrame
			if not followerReward.styled then
				Skins.ReskinPortrait(PortraitFrame)

				followerReward.BG:Hide()
				followerReward.bg = B.CreateBDFrame(followerReward)

				if followerReward.Class then
					B.ReskinFollowerClass(followerReward.Class, 36, "RIGHT", -2, 2)
				end

				followerReward.styled = true
			end

			PortraitFrame:ClearAllPoints()
			followerReward.bg:ClearAllPoints()
			if isQuestLog then
				PortraitFrame:SetPoint("TOPLEFT", 2, 0)
				followerReward.bg:SetPoint("TOPLEFT", 0, 1)
				followerReward.bg:SetPoint("BOTTOMRIGHT", 2, -3)
			else
				PortraitFrame:SetPoint("TOPLEFT", 2, -5)
				followerReward.bg:SetPoint("TOPLEFT", 0, -3)
				followerReward.bg:SetPoint("BOTTOMRIGHT", 2, 7)
			end

			if PortraitFrame then
				Skins.UpdatePortraitColor(PortraitFrame)
			end
		end

		-- Spell Rewards
		for spellReward in rewardsFrame.spellRewardPool:EnumerateActive() do
			if not spellReward.styled then
				Reskin_RewardButton(spellReward, isQuestLog)

				spellReward.styled = true
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
	hooksecurefunc(QuestInfoRequiredMoneyText, "SetTextColor", Skins.ReskinRMTColor)

	-- Quest Info Item
	B.StripTextures(QuestInfoItemHighlight)
	local highlight = B.CreateBDFrame(QuestInfoItemHighlight, 0)
	highlight:SetBackdropColor(cr, cg, cb, .25)
	highlight:SetBackdropBorderColor(cr, cg, cb, 1)

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