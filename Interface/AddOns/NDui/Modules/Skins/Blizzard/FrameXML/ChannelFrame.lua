local B, C, L, DB = unpack(select(2, ...))

tinsert(C.defaultThemes, function()
	B.ReskinFrame(ChannelFrame)
	B.ReskinButton(ChannelFrame.NewButton)
	B.ReskinButton(ChannelFrame.SettingsButton)
	B.ReskinScroll(ChannelFrame.ChannelList.ScrollBar)
	B.ReskinScroll(ChannelFrame.ChannelRoster.ScrollFrame.scrollBar)

	ChannelFrame.NewButton:ClearAllPoints()
	ChannelFrame.NewButton:SetPoint("BOTTOMLEFT", 5, 4)

	hooksecurefunc(ChannelFrame.ChannelList, "Update", function(self)
		for i = 1, self.Child:GetNumChildren() do
			local tab = select(i, self.Child:GetChildren())
			if not tab.styled and tab:IsHeader() then
				B.CleanTextures(tab)

				local bg = B.CreateBDFrame(tab, 0)
				bg:SetAllPoints()
				B.ReskinHighlight(tab, bg, true)

				tab.styled = true
			end
		end
	end)

	B.ReskinFrame(CreateChannelPopup)
	B.ReskinButton(CreateChannelPopup.OKButton)
	B.ReskinButton(CreateChannelPopup.CancelButton)
	B.ReskinInput(CreateChannelPopup.Name)
	B.ReskinInput(CreateChannelPopup.Password)

	B.ReskinFrame(VoiceChatChannelActivatedNotification)
	B.ReskinFrame(VoiceChatPromptActivateChannel)
	B.ReskinButton(VoiceChatPromptActivateChannel.AcceptButton)

	B.ReskinSlider(UnitPopupVoiceMicrophoneVolume.Slider)
	B.ReskinSlider(UnitPopupVoiceSpeakerVolume.Slider)

	-- VoiceActivityManager
	hooksecurefunc(VoiceActivityManager, "LinkFrameNotificationAndGuid", function(_, _, notification, guid)
		local class = select(2, GetPlayerInfoByGUID(guid))
		if class then
			local color = DB.ClassColors[class]
			if notification.Name then
				notification.Name:SetTextColor(color.r, color.g, color.b)
			end
		end
	end)
end)