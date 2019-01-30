local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	F.ReskinFrame(ChannelFrame)
	F.ReskinButton(ChannelFrame.NewButton)
	F.ReskinButton(ChannelFrame.SettingsButton)
	F.ReskinScroll(ChannelFrame.ChannelList.ScrollBar)
	F.ReskinScroll(ChannelFrame.ChannelRoster.ScrollFrame.scrollBar)

	ChannelFrame.NewButton:ClearAllPoints()
	ChannelFrame.NewButton:SetPoint("BOTTOMLEFT", 5, 4)

	hooksecurefunc(ChannelFrame.ChannelList, "Update", function(self)
		for i = 1, self.Child:GetNumChildren() do
			local tab = select(i, self.Child:GetChildren())
			if not tab.styled and tab:IsHeader() then
				tab:SetNormalTexture("")
				tab.bg = F.CreateBDFrame(tab, 0)
				tab.bg:SetAllPoints()
				F.ReskinTexture(tab, tab.bg, true)

				tab.styled = true
			end
		end
	end)

	F.ReskinFrame(CreateChannelPopup)
	F.ReskinButton(CreateChannelPopup.OKButton)
	F.ReskinButton(CreateChannelPopup.CancelButton)
	F.ReskinInput(CreateChannelPopup.Name)
	F.ReskinInput(CreateChannelPopup.Password)

	F.ReskinFrame(VoiceChatChannelActivatedNotification)
	F.ReskinFrame(VoiceChatPromptActivateChannel)
	F.ReskinButton(VoiceChatPromptActivateChannel.AcceptButton)

	F.ReskinSlider(UnitPopupVoiceMicrophoneVolume.Slider)
	F.ReskinSlider(UnitPopupVoiceSpeakerVolume.Slider)

	-- VoiceActivityManager
	hooksecurefunc(VoiceActivityManager, "LinkFrameNotificationAndGuid", function(_, _, notification, guid)
		local class = select(2, GetPlayerInfoByGUID(guid))
		if class then
			local color = C.ClassColors[class]
			if notification.Name then
				notification.Name:SetTextColor(color.r, color.g, color.b)
			end
		end
	end)
end)