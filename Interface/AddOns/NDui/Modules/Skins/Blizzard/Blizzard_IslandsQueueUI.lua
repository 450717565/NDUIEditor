local B, C, L, DB = unpack(select(2, ...))

C.themes["Blizzard_IslandsQueueUI"] = function()
	local cr, cg, cb = DB.r, DB.g, DB.b

	B.ReskinFrame(IslandsQueueFrame)
	IslandsQueueFrame.ArtOverlayFrame:Hide()
	IslandsQueueFrame.TitleBanner.Banner:Hide()

	B.ReskinButton(IslandsQueueFrame.DifficultySelectorFrame.QueueButton)
	IslandsQueueFrame.DifficultySelectorFrame.Background:Hide()

	local HelpButton = IslandsQueueFrame.HelpButton
	HelpButton.Ring:Hide()
	HelpButton:ClearAllPoints()
	HelpButton:SetPoint("TOPLEFT")

	local TutorialFrame = IslandsQueueFrame.TutorialFrame
	B.CreateBDFrame(TutorialFrame, 0)
	B.ReskinButton(TutorialFrame.Leave)
	B.ReskinClose(TutorialFrame.CloseButton)
	TutorialFrame.TutorialText:SetTextColor(1, 1, 1)

	local WeeklyQuest = IslandsQueueFrame.WeeklyQuest

	local OverlayFrame = WeeklyQuest.OverlayFrame
	B.StripTextures(OverlayFrame)
	B.CreateBDFrame(OverlayFrame, 0)

	local StatusBar = WeeklyQuest.StatusBar
	StatusBar.BarTexture:SetTexture(DB.normTex)
	StatusBar.BarTexture:SetColorTexture(cr, cg, cb, .8)

	local QuestReward = WeeklyQuest.QuestReward
	QuestReward:ClearAllPoints()
	QuestReward:SetPoint("LEFT", OverlayFrame, "RIGHT", 0, 0)
	B.ReskinIcon(QuestReward.Icon)
end