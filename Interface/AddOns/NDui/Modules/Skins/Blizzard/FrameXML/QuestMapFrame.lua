local B, C, L, DB = unpack(select(2, ...))

tinsert(C.defaultThemes, function()
	local LE_QUEST_FREQUENCY_DAILY = LE_QUEST_FREQUENCY_DAILY or 2

	--ScrollFrame
	B.StripTextures(QuestScrollFrame.DetailFrame, 0)
	B.ReskinScroll(QuestScrollFrame.ScrollBar)

	local Contents = QuestScrollFrame.Contents
	Contents.Separator:SetAlpha(0)
	Contents.Separator:SetHeight(10)

	local WarCampaignHeader = Contents.WarCampaignHeader
	local StoryHeader = Contents.StoryHeader
	for _, header in pairs({WarCampaignHeader, StoryHeader}) do
		B.StripTextures(header, 0)

		header.Text:ClearAllPoints()
		header.Text:SetPoint("TOPLEFT", 10, -20)

		header.Progress:ClearAllPoints()
		header.Progress:SetPoint("BOTTOMLEFT", 10, 10)

		local bdTex = B.CreateBGFrame(header, 2, -15, -5, 5)
		header.bdTex = bdTex

		B.Hook_OnEnter(header, true)
		B.Hook_OnLeave(header, true)

		if header == WarCampaignHeader then
			local newTex = bdTex:CreateTexture(nil, "OVERLAY")
			newTex:SetPoint("RIGHT", 0, 0)
			newTex:SetSize(50, 50)
			newTex:SetBlendMode("ADD")
			newTex:SetAlpha(0)
			header.newTex = newTex
		end
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
					WarCampaignHeader.newTex:SetAlpha(1)
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
					B.ReskinExpandOrCollapse(child)

					child.styled = true
				end
				child:SetHighlightTexture("")
			end
		end
	end)

	-- Show quest color and level
	local function Showlevel(_, _, _, title, level, _, isHeader, _, isComplete, frequency, questID)
		if ENABLE_COLORBLIND_MODE == "1" then return end

		for button in pairs(QuestScrollFrame.titleFramePool.activeObjects) do
			if title and not isHeader and button.questID == questID then
				local title = "["..level.."] "..title
				if isComplete then
					title = "|cffff78ff"..title
				elseif C_QuestLog.IsQuestReplayable(questID) then
					title = "|cff00ff00"..title
				elseif frequency == LE_QUEST_FREQUENCY_DAILY then
					title = "|cff3399ff"..title
				end
				button.Text:SetText(title)
				button.Text:SetPoint("TOPLEFT", 24, -5)
				button.Text:SetWidth(205)
				button.Text:SetWordWrap(false)
				button.Check:SetPoint("LEFT", button.Text, button.Text:GetWrappedWidth(), 0)
			end
		end
	end
	hooksecurefunc("QuestLogQuests_AddQuestButton", Showlevel)

	--DetailsFrame
	B.StripTextures(QuestMapFrame)

	local DetailsFrame = QuestMapFrame.DetailsFrame
	B.StripTextures(DetailsFrame, 0)
	B.StripTextures(DetailsFrame.ShareButton)
	B.ReskinScroll(DetailsFrame.ScrollFrame.ScrollBar)

	local RewardsFrame = DetailsFrame.RewardsFrame
	B.StripTextures(RewardsFrame)

	DetailsFrame.ShareButton:ClearAllPoints()
	DetailsFrame.ShareButton:SetPoint("TOP", RewardsFrame, "BOTTOM", 0, 2)
	DetailsFrame.AbandonButton:ClearAllPoints()
	DetailsFrame.AbandonButton:SetPoint("RIGHT", DetailsFrame.ShareButton, "LEFT", -2, 0)
	DetailsFrame.TrackButton:ClearAllPoints()
	DetailsFrame.TrackButton:SetPoint("LEFT", DetailsFrame.ShareButton, "RIGHT", 2, 0)

	local CompleteQuestFrame = DetailsFrame.CompleteQuestFrame
	B.StripTextures(CompleteQuestFrame)
	B.ReskinButton(CompleteQuestFrame.CompleteButton)

	--QuestLogPopupDetailFrame
	B.ReskinFrame(QuestLogPopupDetailFrame)
	B.ReskinScroll(QuestLogPopupDetailFrame.ScrollFrame.ScrollBar)

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
			B.ReskinButton(button1)
		end

		local button2 = QuestLogPopupDetailFrame[name]
		if button2 then
			button2:SetWidth(100)
			B.ReskinButton(button2)
		end
	end

	-- Party Sync button
	local QuestSessionManagement = QuestMapFrame.QuestSessionManagement
	QuestSessionManagement.BG:Hide()
	B.CreateBDFrame(QuestSessionManagement, 0, 0)

	local function reskinSessionDialog(_, dialog)
		if not dialog.styled then
			B.ReskinFrame(dialog)
			B.ReskinButton(dialog.ButtonContainer.Confirm)
			B.ReskinButton(dialog.ButtonContainer.Decline)
			if dialog.MinimizeButton then
				B.ReskinArrow(dialog.MinimizeButton, "down")
			end

			dialog.styled = true
		end
	end
	hooksecurefunc(QuestSessionManager, "NotifyDialogShow", reskinSessionDialog)

	local ExecuteSessionCommand = QuestSessionManagement.ExecuteSessionCommand
	B.ReskinButton(ExecuteSessionCommand)

	local icon = ExecuteSessionCommand:CreateTexture(nil, "ARTWORK")
	icon:SetInside()
	ExecuteSessionCommand.normalIcon = icon

	local sessionCommandToButtonAtlas = {
		[_G.Enum.QuestSessionCommand.Start] = "QuestSharing-DialogIcon",
		[_G.Enum.QuestSessionCommand.Stop] = "QuestSharing-Stop-DialogIcon"
	}

	hooksecurefunc(QuestMapFrame.QuestSessionManagement, "UpdateExecuteCommandAtlases", function(self, command)
		self.ExecuteSessionCommand:SetNormalTexture("")
		self.ExecuteSessionCommand:SetPushedTexture("")
		self.ExecuteSessionCommand:SetDisabledTexture("")

		local atlas = sessionCommandToButtonAtlas[command]
		if atlas then
			self.ExecuteSessionCommand.normalIcon:SetAtlas(atlas)
		end
	end)
end)