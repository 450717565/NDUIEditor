local F, C = unpack(select(2, ...))

C.themes["Blizzard_IslandsQueueUI"] = function()
	if AuroraConfig.tooltips then
		local tooltip = IslandsQueueFrameTooltip:GetParent()
		tooltip.IconBorder:SetAlpha(0)
		tooltip.Icon:SetTexCoord(.08, .92, .08, .92)
		F.ReskinTooltip(tooltip:GetParent())
	end

	local cr, cg, cb = C.r, C.g, C.b

	F.ReskinFrame(IslandsQueueFrame)
	IslandsQueueFrame.ArtOverlayFrame:Hide()
	IslandsQueueFrame.TitleBanner.Banner:Hide()

	F.ReskinButton(IslandsQueueFrame.DifficultySelectorFrame.QueueButton)
	IslandsQueueFrame.DifficultySelectorFrame.Background:Hide()

	local HelpButton = IslandsQueueFrame.HelpButton
	HelpButton.Ring:Hide()
	HelpButton:ClearAllPoints()
	HelpButton:SetPoint("TOPLEFT")

	local TutorialFrame = IslandsQueueFrame.TutorialFrame
	F.CreateBDFrame(TutorialFrame, 0)
	F.ReskinButton(TutorialFrame.Leave)
	F.ReskinClose(TutorialFrame.CloseButton)
	TutorialFrame.TutorialText:SetTextColor(1, 1, 1)

	local WeeklyQuest = IslandsQueueFrame.WeeklyQuest

	local OverlayFrame = WeeklyQuest.OverlayFrame
	F.StripTextures(OverlayFrame)
	F.CreateBDFrame(OverlayFrame, 0)

	local StatusBar = WeeklyQuest.StatusBar
	StatusBar.BarTexture:SetTexture(C.media.normTex)
	StatusBar.BarTexture:SetColorTexture(cr, cg, cb, .8)

	local QuestReward = WeeklyQuest.QuestReward
	QuestReward:ClearAllPoints()
	QuestReward:SetPoint("LEFT", OverlayFrame, "RIGHT", 0, 0)
	F.ReskinIcon(QuestReward.Icon)
end