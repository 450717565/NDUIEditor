local _, ns = ...
local B, C, L, DB = unpack(ns)

local function Reskin_QuestHeader(self, isCalling)
	if not self.styled then
		if self.Divider then self.Divider:Hide() end
		if self.TopFiligree then self.TopFiligree:Hide() end
		if self.Background then self.Background:SetAlpha(0) end

		local bg = B.CreateBGFrame(self.Background, 2, -2, -2, 6)
		self.bg = bg

		if self.SelectedHighlight then
			self.SelectedHighlight:SetInside(self.bg)
		end

		local collapseButton = isCalling and self or self.CollapseButton
		if collapseButton then
			B.ReskinCollapse(collapseButton, true)
		end

		self.styled = true
	end

	B.ReskinHighlight(self.HighlightTexture, self.bg, true, true)
end

local function Reskin_SessionDialog(_, dialog)
	if not dialog.styled then
		B.ReskinFrame(dialog)
		B.ReskinButton(dialog.ButtonContainer.Confirm)
		B.ReskinButton(dialog.ButtonContainer.Decline)

		if dialog.MinimizeButton then
			B.ReskinClose(dialog.MinimizeButton)
		end

		dialog.styled = true
	end
end

local function Reskin_QuestLogQuests()
	for button in QuestScrollFrame.headerFramePool:EnumerateActive() do
		if button.ButtonText then
			if not button.styled then
				B.ReskinCollapse(button, true)

				button.styled = true
			end
		end
	end

	for header in QuestScrollFrame.campaignHeaderFramePool:EnumerateActive() do
		Reskin_QuestHeader(header)
	end

	for header in QuestScrollFrame.covenantCallingsHeaderFramePool:EnumerateActive() do
		Reskin_QuestHeader(header, true)
	end
end

tinsert(C.XMLThemes, function()
	-- QuestScrollFrame
	B.ReskinScroll(QuestScrollFrame.ScrollBar)
	B.StripTextures(QuestScrollFrame.DetailFrame, 0)

	hooksecurefunc("QuestLogQuests_Update", Reskin_QuestLogQuests)

	local Contents = QuestScrollFrame.Contents
	B.StripTextures(Contents.Separator, 0)
	Reskin_QuestHeader(Contents.StoryHeader)

	-- QuestMapFrame
	B.StripTextures(QuestMapFrame, 0)

	-- Party Sync button
	local QuestSessionManagement = QuestMapFrame.QuestSessionManagement
	QuestSessionManagement.BG:Hide()
	B.CreateBDFrame(QuestSessionManagement)

	hooksecurefunc(QuestSessionManager, "NotifyDialogShow", Reskin_SessionDialog)

	local CampaignOverview = QuestMapFrame.CampaignOverview
	B.StripTextures(CampaignOverview)
	B.ReskinScroll(CampaignOverview.ScrollFrame.ScrollBar)
	Reskin_QuestHeader(CampaignOverview.Header)

	local DetailsFrame = QuestMapFrame.DetailsFrame
	B.StripTextures(DetailsFrame, 0)
	B.StripTextures(DetailsFrame.ShareButton)
	B.StripTextures(DetailsFrame.RewardsFrame)
	B.ReskinScroll(QuestMapDetailsScrollFrame.ScrollBar)

	DetailsFrame.ShareButton:ClearAllPoints()
	DetailsFrame.ShareButton:SetPoint("TOP", DetailsFrame.RewardsFrame, "BOTTOM", 0, 2)
	DetailsFrame.AbandonButton:ClearAllPoints()
	DetailsFrame.AbandonButton:SetPoint("RIGHT", DetailsFrame.ShareButton, "LEFT", -2, 0)
	DetailsFrame.TrackButton:ClearAllPoints()
	DetailsFrame.TrackButton:SetPoint("LEFT", DetailsFrame.ShareButton, "RIGHT", 2, 0)

	local CompleteQuestFrame = DetailsFrame.CompleteQuestFrame
	B.StripTextures(CompleteQuestFrame)
	B.StripTextures(CompleteQuestFrame.CompleteButton)
	B.ReskinButton(CompleteQuestFrame.CompleteButton)

	-- QuestLogPopupDetailFrame
	B.ReskinFrame(QuestLogPopupDetailFrame)
	B.ReskinScroll(QuestLogPopupDetailFrame.ScrollFrame.ScrollBar)

	QuestLogPopupDetailFrame.ShareButton:ClearAllPoints()
	QuestLogPopupDetailFrame.ShareButton:SetPoint("BOTTOM", QuestLogPopupDetailFrame, "BOTTOM", 0, 4)
	QuestLogPopupDetailFrame.AbandonButton:ClearAllPoints()
	QuestLogPopupDetailFrame.AbandonButton:SetPoint("RIGHT", QuestLogPopupDetailFrame.ShareButton, "LEFT", -10, 0)
	QuestLogPopupDetailFrame.TrackButton:ClearAllPoints()
	QuestLogPopupDetailFrame.TrackButton:SetPoint("LEFT", QuestLogPopupDetailFrame.ShareButton, "RIGHT", 10, 0)

	-- Buttons
	local buttons = {"BackButton", "AbandonButton", "ShareButton", "TrackButton"}
	for _, name in pairs(buttons) do
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
end)