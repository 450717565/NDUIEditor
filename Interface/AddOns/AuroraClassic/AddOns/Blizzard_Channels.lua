local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	F.ReskinPortraitFrame(ChannelFrame, true)
	F.Reskin(ChannelFrame.NewButton)
	F.Reskin(ChannelFrame.SettingsButton)
	F.ReskinScroll(ChannelFrame.ChannelList.ScrollBar)
	F.ReskinScroll(ChannelFrame.ChannelRoster.ScrollFrame.scrollBar)

	ChannelFrame.LeftInset:Hide()
	ChannelFrame.RightInset:Hide()
	ChannelFrame.NewButton:ClearAllPoints()
	ChannelFrame.NewButton:SetPoint("BOTTOMLEFT", 5, 4)

	hooksecurefunc(ChannelFrame.ChannelList, "Update", function(self)
		for i = 1, self.Child:GetNumChildren() do
			local tab = select(i, self.Child:GetChildren())
			if not tab.styled and tab:IsHeader() then
				tab:SetNormalTexture("")
				tab.bg = F.CreateBDFrame(tab, .25)
				tab.bg:SetAllPoints()

				F.ReskinHighlight(tab, true, tab.bg)

				tab.styled = true
			end
		end
	end)

	F.ReskinPortraitFrame(CreateChannelPopup, true)
	F.Reskin(CreateChannelPopup.OKButton)
	F.Reskin(CreateChannelPopup.CancelButton)
	F.ReskinInput(CreateChannelPopup.Name)
	F.ReskinInput(CreateChannelPopup.Password)

	F.ReskinPortraitFrame(VoiceChatChannelActivatedNotification, true)
	F.ReskinPortraitFrame(VoiceChatPromptActivateChannel, true)
	F.Reskin(VoiceChatPromptActivateChannel.AcceptButton)

	F.ReskinSlider(UnitPopupVoiceMicrophoneVolume.Slider)
	F.ReskinSlider(UnitPopupVoiceSpeakerVolume.Slider)

	-- VoiceActivityManager
	hooksecurefunc(VoiceActivityManager, "LinkFrameNotificationAndGuid", function(_, _, notification, guid)
		local class = select(2, GetPlayerInfoByGUID(guid))
		if class then
			local color = C.classcolours[class]
			if notification.Name then
				notification.Name:SetTextColor(color.r, color.g, color.b)
			end
		end
	end)
end)