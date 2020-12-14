local B, C, L, DB = unpack(select(2, ...))

-- Function
-- Quest objective text color
local function QuestInfo_GetQuestID()
	if QuestInfoFrame.questLog then
		return C_QuestLog.GetSelectedQuest()
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

-- Reskin
tinsert(C.defaultThemes, function()
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