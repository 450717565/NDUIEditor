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

	if AuroraConfig.tooltips then
		local tooltip = IslandsQueueFrameTooltip:GetParent()
		tooltip.IconBorder:SetAlpha(0)
		tooltip.Icon:SetTexCoord(.08, .92, .08, .92)
		F.ReskinTooltip(tooltip:GetParent())
	end
end