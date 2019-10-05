local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	local cr, cg, cb = C.r, C.g, C.b

	if AuroraConfig.tooltips then
		F.ReskinTooltip(QuestScrollFrame.StoryTooltip)
		F.ReskinTooltip(QuestScrollFrame.WarCampaignTooltip)
	end

	--ScrollFrame
	F.StripTextures(QuestScrollFrame.DetailFrame, true)
	F.ReskinScroll(QuestScrollFrame.ScrollBar)

	local Contents = QuestScrollFrame.Contents
	Contents.Separator:SetAlpha(0)
	Contents.Separator:SetHeight(10)

	local WarCampaignHeader = Contents.WarCampaignHeader
	local StoryHeader = Contents.StoryHeader
	for _, header in pairs({WarCampaignHeader, StoryHeader}) do
		F.StripTextures(header, true)

		header.Text:ClearAllPoints()
		header.Text:SetPoint("TOPLEFT", 10, -20)

		header.Progress:ClearAllPoints()
		header.Progress:SetPoint("BOTTOMLEFT", 10, 10)

		local bg = F.CreateBDFrame(header, 0)
		bg:SetPoint("TOPLEFT", 2, -15)
		bg:SetPoint("BOTTOMRIGHT", -5, 5)

		if header == WarCampaignHeader then
			local newTex = bg:CreateTexture(nil, "OVERLAY")
			newTex:SetPoint("RIGHT", 0, 0)
			newTex:SetSize(50, 50)
			newTex:SetBlendMode("ADD")
			newTex:SetAlpha(0)
			header.newTex = newTex
		end

		header:HookScript("OnEnter", function()
			bg:SetBackdropColor(cr, cg, cb, .25)
		end)
		header:HookScript("OnLeave", function()
			bg:SetBackdropColor(0, 0, 0, 0)
		end)
	end

	local idToTexture = {
		[261] = "Interface\\Timer\\Alliance-Logo",
		[262] = "Interface\\Timer\\Horde-Logo",
	}

	local function UpdateCampaignHeader()
		WarCampaignHeader.newTex:SetAlpha(0)
		if WarCampaignHeader:IsShown() then
			local campaignID = C_CampaignInfo.GetCurrentCampaignID()
			if campaignID then
				local warCampaignInfo = C_CampaignInfo.GetCampaignInfo(campaignID)
				local textureID = warCampaignInfo.uiTextureKitID
				if textureID and idToTexture[textureID] then
					WarCampaignHeader.newTex:SetTexture(idToTexture[textureID])
					WarCampaignHeader.newTex:SetAlpha(.7)
				end
			end
		end
	end

	hooksecurefunc("QuestLogQuests_Update", function()
		UpdateCampaignHeader()

		local Contents = QuestMapFrame.QuestsFrame.Contents
		for i = 6, Contents:GetNumChildren() do
			local child = select(i, Contents:GetChildren())
			if child.ButtonText then
				if not child.styled then
					F.ReskinExpandOrCollapse(child)

					child.styled = true
				end
				child:SetHighlightTexture("")
			end
		end
	end)

	--DetailsFrame
	F.StripTextures(QuestMapFrame)

	local DetailsFrame = QuestMapFrame.DetailsFrame
	F.StripTextures(DetailsFrame, true)
	F.StripTextures(DetailsFrame.ShareButton)
	F.ReskinScroll(DetailsFrame.ScrollFrame.ScrollBar)

	local RewardsFrame = DetailsFrame.RewardsFrame
	F.StripTextures(RewardsFrame)

	DetailsFrame.ShareButton:ClearAllPoints()
	DetailsFrame.ShareButton:SetPoint("TOP", RewardsFrame, "BOTTOM", 0, 2)
	DetailsFrame.AbandonButton:ClearAllPoints()
	DetailsFrame.AbandonButton:SetPoint("RIGHT", DetailsFrame.ShareButton, "LEFT", -2, 0)
	DetailsFrame.TrackButton:ClearAllPoints()
	DetailsFrame.TrackButton:SetPoint("LEFT", DetailsFrame.ShareButton, "RIGHT", 2, 0)

	local CompleteQuestFrame = DetailsFrame.CompleteQuestFrame
	F.StripTextures(CompleteQuestFrame)
	F.ReskinButton(CompleteQuestFrame.CompleteButton)

	--QuestLogPopupDetailFrame
	F.ReskinFrame(QuestLogPopupDetailFrame)
	F.ReskinScroll(QuestLogPopupDetailFrame.ScrollFrame.ScrollBar)

	QuestLogPopupDetailFrame.ShareButton:ClearAllPoints()
	QuestLogPopupDetailFrame.ShareButton:SetPoint("BOTTOM", QuestLogPopupDetailFrame, "BOTTOM", 0, 4)
	QuestLogPopupDetailFrame.AbandonButton:ClearAllPoints()
	QuestLogPopupDetailFrame.AbandonButton:SetPoint("RIGHT", QuestLogPopupDetailFrame.ShareButton, "LEFT", -10, 0)
	QuestLogPopupDetailFrame.TrackButton:ClearAllPoints()
	QuestLogPopupDetailFrame.TrackButton:SetPoint("LEFT", QuestLogPopupDetailFrame.ShareButton, "RIGHT", 10, 0)

	--Buttons
	local names = {"BackButton", "AbandonButton", "ShareButton", "TrackButton"}
	for _, name in pairs(names) do
		local button1 = DetailsFrame[name]
		if button1 then
			button1:SetWidth(92)
			F.ReskinButton(button1)
		end

		local button2 = QuestLogPopupDetailFrame[name]
		if button2 then
			button2:SetWidth(100)
			F.ReskinButton(button2)
		end
	end

	-- Sync button
	local QuestSessionManagement = QuestMapFrame.QuestSessionManagement
	QuestSessionManagement.BG:Hide()
	F.CreateBDFrame(QuestSessionManagement, 0, 0)

	local names = {"StartDialog", "CheckStartDialog", "CheckStopDialog", "CheckLeavePartyDialog"}
	for _, name in pairs(names) do
		local dialog = QuestSessionManager[name]
		F.ReskinFrame(dialog)
		F.ReskinButton(dialog.ButtonContainer.Confirm)
		F.ReskinButton(dialog.ButtonContainer.Decline)
		if dialog.MinimizeButton then
			F.ReskinArrow(dialog.MinimizeButton, "bottom")
		end
	end
end)