local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	local cr, cg, cb = C.r, C.g, C.b

	-- [[ Quest scroll frame ]]

	local campaignHeader = QuestScrollFrame.Contents.WarCampaignHeader
	local StoryHeader = QuestScrollFrame.Contents.StoryHeader

	F.StripTextures(QuestMapFrame, true)
	F.StripTextures(QuestScrollFrame, true)
	F.StripTextures(QuestScrollFrame.DetailFrame, true)
	QuestScrollFrame.Contents.Separator:SetAlpha(0)
	QuestScrollFrame.Contents.Separator:SetHeight(5)

	if AuroraConfig.tooltips then
		F.ReskinTooltip(QuestScrollFrame.StoryTooltip)
		F.ReskinTooltip(QuestScrollFrame.WarCampaignTooltip)
	end
	F.ReskinScroll(QuestScrollFrame.ScrollBar)

	for _, header in pairs({campaignHeader, StoryHeader}) do
		F.StripTextures(header, true)

		header.Text:SetPoint("TOPLEFT", 10, -20)
		header.Progress:SetPoint("BOTTOMLEFT", 10, 10)

		local bg = F.CreateBDFrame(header, 0)
		bg:SetPoint("TOPLEFT", 2, -15)
		bg:SetPoint("BOTTOMRIGHT", -5, 5)

		if header == campaignHeader then
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
		campaignHeader.newTex:SetAlpha(0)
		if campaignHeader:IsShown() then
			local warCampaignInfo = C_CampaignInfo.GetCampaignInfo(C_CampaignInfo.GetCurrentCampaignID())
			local textureID = warCampaignInfo.uiTextureKitID
			if textureID and idToTexture[textureID] then
				campaignHeader.newTex:SetTexture(idToTexture[textureID])
				campaignHeader.newTex:SetAlpha(.7)
			end
		end
	end

	-- [[ Quest details ]]

	local DetailsFrame = QuestMapFrame.DetailsFrame
	local RewardsFrame = DetailsFrame.RewardsFrame
	local CompleteQuestFrame = DetailsFrame.CompleteQuestFrame

	F.StripTextures(DetailsFrame, true)
	F.StripTextures(DetailsFrame.ShareButton, true)

	F.ReskinButton(DetailsFrame.BackButton)
	F.ReskinButton(DetailsFrame.AbandonButton)
	F.ReskinButton(DetailsFrame.ShareButton)
	F.ReskinButton(DetailsFrame.TrackButton)
	F.ReskinScroll(QuestMapDetailsScrollFrameScrollBar)

	DetailsFrame.AbandonButton:ClearAllPoints()
	DetailsFrame.AbandonButton:SetPoint("BOTTOMLEFT", DetailsFrame, 1, 0)
	DetailsFrame.AbandonButton:SetWidth(93)

	DetailsFrame.ShareButton:ClearAllPoints()
	DetailsFrame.ShareButton:SetPoint("LEFT", DetailsFrame.AbandonButton, "RIGHT", 2, 0)
	DetailsFrame.ShareButton:SetWidth(93)

	DetailsFrame.TrackButton:ClearAllPoints()
	DetailsFrame.TrackButton:SetPoint("LEFT", DetailsFrame.ShareButton, "RIGHT", 2, 0)
	DetailsFrame.TrackButton:SetWidth(93)

	-- Rewards frame

	F.StripTextures(RewardsFrame, true)

	-- Scroll frame

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

	-- Complete quest frame
	F.StripTextures(CompleteQuestFrame, true)
	F.ReskinButton(CompleteQuestFrame.CompleteButton)

	-- [[ Quest log popup detail frame ]]

	F.ReskinFrame(QuestLogPopupDetailFrame)
	F.StripTextures(QuestLogPopupDetailFrameScrollFrame, true)
	F.ReskinScroll(QuestLogPopupDetailFrameScrollFrameScrollBar)
	F.ReskinButton(QuestLogPopupDetailFrame.AbandonButton)
	F.ReskinButton(QuestLogPopupDetailFrame.TrackButton)
	F.ReskinButton(QuestLogPopupDetailFrame.ShareButton)

	-- Show map button

	local ShowMapButton = QuestLogPopupDetailFrame.ShowMapButton
	F.StripTextures(ShowMapButton, true)

	ShowMapButton:SetSize(ShowMapButton.Text:GetStringWidth() + 14, 22)
	ShowMapButton.Text:ClearAllPoints()
	ShowMapButton.Text:SetPoint("CENTER", 1, 0)

	ShowMapButton:ClearAllPoints()
	ShowMapButton:SetPoint("TOPRIGHT", QuestLogPopupDetailFrame, -30, -25)

	F.ReskinButton(ShowMapButton)

	ShowMapButton:HookScript("OnEnter", function(self)
		self.Text:SetTextColor(GameFontHighlight:GetTextColor())
	end)

	ShowMapButton:HookScript("OnLeave", function(self)
		self.Text:SetTextColor(GameFontNormal:GetTextColor())
	end)

	-- Bottom buttons

	QuestLogPopupDetailFrame.ShareButton:ClearAllPoints()
	QuestLogPopupDetailFrame.ShareButton:SetPoint("LEFT", QuestLogPopupDetailFrame.AbandonButton, "RIGHT", 1, 0)
	QuestLogPopupDetailFrame.ShareButton:SetPoint("RIGHT", QuestLogPopupDetailFrame.TrackButton, "LEFT", -1, 0)
end)