local F, C = unpack(select(2, ...))

C.themes["Blizzard_IslandsQueueUI"] = function()
	F.ReskinPortraitFrame(IslandsQueueFrame, true)
	IslandsQueueFrame.ArtOverlayFrame:Hide()
	IslandsQueueFrame.TitleBanner.Banner:Hide()

	F.Reskin(IslandsQueueFrame.DifficultySelectorFrame.QueueButton)
	IslandsQueueFrame.DifficultySelectorFrame.Background:Hide()

	local helpbutton = IslandsQueueFrame.HelpButton
	helpbutton.Ring:SetAlpha(0)
	helpbutton:ClearAllPoints()
	helpbutton:SetPoint("TOPLEFT", IslandsQueueFrame, "TOPLEFT", 0, 0)

	local tutorial = IslandsQueueFrame.TutorialFrame
	F.CreateBDFrame(tutorial, .25)
	F.Reskin(tutorial.Leave)
	F.ReskinClose(tutorial.CloseButton)

	tutorial.TutorialText:SetTextColor(1, 1, 1)
end