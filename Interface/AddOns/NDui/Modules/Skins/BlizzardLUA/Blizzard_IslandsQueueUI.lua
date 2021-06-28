local _, ns = ...
local B, C, L, DB = unpack(ns)

local cr, cg, cb = DB.cr, DB.cg, DB.cb

C.OnLoadThemes["Blizzard_IslandsQueueUI"] = function()
	B.ReskinFrame(IslandsQueueFrame)

	local DifficultySelectorFrame = IslandsQueueFrame.DifficultySelectorFrame
	B.ReskinButton(DifficultySelectorFrame.QueueButton)
	DifficultySelectorFrame.Background:Hide()

	local HelpButton = IslandsQueueFrame.HelpButton
	B.ReskinTutorialButton(HelpButton, IslandsQueueFrame)

	local TutorialFrame = IslandsQueueFrame.TutorialFrame
	B.CreateBDFrame(TutorialFrame)
	B.ReskinButton(TutorialFrame.Leave)
	B.ReskinClose(TutorialFrame.CloseButton)
	B.ReskinText(TutorialFrame.TutorialText, 1, 1, 1)

	local WeeklyQuest = IslandsQueueFrame.WeeklyQuest
	local OverlayFrame = WeeklyQuest.OverlayFrame
	B.StripTextures(OverlayFrame)
	B.CreateBDFrame(OverlayFrame, 0, -C.mult)

	local StatusBar = WeeklyQuest.StatusBar
	StatusBar.BarTexture:SetColorTexture(cr, cg, cb, C.alpha)

	local QuestReward = WeeklyQuest.QuestReward
	QuestReward:ClearAllPoints()
	QuestReward:SetPoint("LEFT", OverlayFrame, "RIGHT", 0, 0)
	B.ReskinIcon(QuestReward.Icon)
end