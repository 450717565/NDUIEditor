local _, ns = ...
local B, C, L, DB = unpack(ns)

local cr, cg, cb = DB.cr, DB.cg, DB.cb

-- ChatFrame
local homeTex = "Interface\\Buttons\\UI-HomeButton"

local function Reskin_ScrollBar(self)
	local thumb = _G[self:GetDebugName().."ThumbTexture"]
	thumb:SetAlpha(0)
	thumb:SetWidth(18)

	self.bdTex = B.CreateBDFrame(thumb)
	B.SetupHook(self)

	local down = self.ScrollToBottomButton
	B.ReskinArrow(down, "bottom")
	down:ClearAllPoints()
	down:SetPoint("BOTTOM", _G[self:GetDebugName().."ResizeButton"], "BOTTOM", -5, 3)
end

tinsert(C.XMLThemes, function()
	local ChannelButton = ChatFrameChannelButton
	B.ReskinButton(ChannelButton)
	ChannelButton:SetSize(20, 20)

	local DeafenButton = ChatFrameToggleVoiceDeafenButton
	B.ReskinButton(DeafenButton)
	DeafenButton:SetSize(20, 20)

	local MuteButton = ChatFrameToggleVoiceMuteButton
	B.ReskinButton(MuteButton)
	MuteButton:SetSize(20, 20)

	local MenuButton = ChatFrameMenuButton
	B.ReskinButton(MenuButton)
	MenuButton:SetSize(20, 20)
	MenuButton:SetNormalTexture(homeTex)
	MenuButton:SetPushedTexture(homeTex)

	local OverflowButton = GeneralDockManagerOverflowButton
	B.ReskinArrow(OverflowButton, "down")
	OverflowButton:ClearAllPoints()
	OverflowButton:SetPoint("BOTTOM", MenuButton, "TOP", 0, 3)

	for i = 1, NUM_CHAT_WINDOWS do
		local frame = "ChatFrame"..i

		Reskin_ScrollBar(_G[frame])
		B.StripTextures(_G[frame.."Tab"])
	end
end)

-- QuickJoinToastButton
local friendTex = "Interface\\HELPFRAME\\ReportLagIcon-Chat"
local queueTex = "Interface\\HELPFRAME\\HelpIcon-ItemRestoration"

local function Update_ToastToFriendFinished(self)
	self.FriendsButton:SetShown(not self.displayedToast)
	self.FriendCount:SetShown(not self.displayedToast)
end

local function Update_UpdateQueueIcon(self)
	if not self.displayedToast then return end

	self.QueueButton:SetTexture(queueTex)
	self.FlashingLayer:SetTexture(queueTex)
	self.FriendsButton:SetShown(false)
	self.FriendCount:SetShown(false)
end

local function Update_QuickJoinToastButton(self)
	self.FriendsButton:SetTexture(friendTex)
end

tinsert(C.XMLThemes, function()
	QuickJoinToastButton.FriendsButton:SetTexture(friendTex)
	QuickJoinToastButton.QueueButton:SetTexture(queueTex)
	QuickJoinToastButton:SetHighlightTexture("")

	hooksecurefunc(QuickJoinToastButton, "ToastToFriendFinished", Update_ToastToFriendFinished)
	hooksecurefunc(QuickJoinToastButton, "UpdateQueueIcon", Update_UpdateQueueIcon)
	QuickJoinToastButton:HookScript("OnMouseDown", Update_QuickJoinToastButton)
	QuickJoinToastButton:HookScript("OnMouseUp", Update_QuickJoinToastButton)

	local Toast = QuickJoinToastButton.Toast
	B.StripTextures(Toast, 0)
	local bg = B.CreateBGFrame(Toast, 10, -1, 0, 3)
	bg:Hide()

	hooksecurefunc(QuickJoinToastButton, "ShowToast", function() bg:Show() end)
	hooksecurefunc(QuickJoinToastButton, "HideToast", function() bg:Hide() end)
end)

-- BNToastFrame
local function Update_FrameAnchor(self)
	self:ClearAllPoints()
	self:SetPoint("BOTTOMLEFT", QuickJoinToastButton, "TOPRIGHT", 0, 0)
end

tinsert(C.XMLThemes, function()
	B.ReskinFrame(BNToastFrame)
	B.ReskinFrame(BNToastFrame.TooltipFrame)

	hooksecurefunc(BNToastFrame, "ShowToast", Update_FrameAnchor)

	local frame, send, cancel = BattleTagInviteFrame:GetChildren()
	B.ReskinFrame(frame)
	B.ReskinButton(send)
	B.ReskinButton(cancel)
end)

-- ChatBubbles
local events = {
	CHAT_MSG_SAY = "chatBubbles",
	CHAT_MSG_YELL = "chatBubbles",
	CHAT_MSG_MONSTER_SAY = "chatBubbles",
	CHAT_MSG_MONSTER_YELL = "chatBubbles",
	CHAT_MSG_PARTY = "chatBubblesParty",
	CHAT_MSG_PARTY_LEADER = "chatBubblesParty",
	CHAT_MSG_MONSTER_PARTY = "chatBubblesParty",
}

local function Reskin_ChatBubble(self)
	if not self.styled then
		local frame = self:GetChildren()
		if frame and not frame:IsForbidden() then
			local bg = B.CreateBG(frame)
			bg:SetScale(UIParent:GetEffectiveScale())
			bg:SetInside(frame, 6, 6)

			frame:DisableDrawLayer("BORDER")
			frame.Tail:SetAlpha(0)
		end

		self.styled = true
	end
end

local function Update_OnEvent(self, event)
	if GetCVarBool(events[event]) then
		self.elapsed = 0
		self:Show()
	end
end

local function Update_OnUpdate(self, elapsed)
	self.elapsed = self.elapsed + elapsed
	if self.elapsed > .1 then
		local chatbubbles = C_ChatBubbles.GetAllChatBubbles()
		for _, chatbubble in pairs(chatbubbles) do
			Reskin_ChatBubble(chatbubble)
		end

		self:Hide()
	end
end

tinsert(C.XMLThemes, function()
	local bubbleHook = CreateFrame("Frame")
	for event in pairs(events) do
		bubbleHook:RegisterEvent(event)
	end

	bubbleHook:SetScript("OnEvent", Update_OnEvent)
	bubbleHook:SetScript("OnUpdate", Update_OnUpdate)

	bubbleHook:Hide()
end)

-- ChannelFrame
local function Reskin_ChannelList(self)
	local children = {self.Child:GetChildren()}
	for _, tab in pairs(children) do
		if tab:IsHeader() and not tab.styled then
			B.CleanTextures(tab)

			local bg = B.CreateBDFrame(tab)
			bg:SetAllPoints()
			B.ReskinHighlight(tab, bg, true)

			tab.styled = true
		end
	end
end

local function Reskin_VoiceActivityManager(_, _, notification, guid)
	local class = select(2, GetPlayerInfoByGUID(guid))
	if class then
		local color = DB.ClassColors[class]
		if notification.Name then
			notification.Name:SetTextColor(color.r, color.g, color.b)
		end
	end
end

tinsert(C.XMLThemes, function()
	B.ReskinFrame(ChannelFrame)
	B.ReskinButton(ChannelFrame.NewButton)
	B.ReskinButton(ChannelFrame.SettingsButton)
	B.ReskinScroll(ChannelFrame.ChannelList.ScrollBar)
	B.ReskinScroll(ChannelFrame.ChannelRoster.ScrollFrame.scrollBar)

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

	ChannelFrame.NewButton:ClearAllPoints()
	ChannelFrame.NewButton:SetPoint("BOTTOMLEFT", 5, 4)

	hooksecurefunc(ChannelFrame.ChannelList, "Update", Reskin_ChannelList)
	hooksecurefunc(VoiceActivityManager, "LinkFrameNotificationAndGuid", Reskin_VoiceActivityManager)
end)

-- TextToSpeech
local function Reskin_TextToSpeechFrame()
	local checkBoxNameString = "TextToSpeechFramePanelContainerChatTypeContainerCheckBox"
	local checkBoxName, checkBox
	local checkBoxTable = TextToSpeechFramePanelContainerChatTypeContainer.checkBoxTable
	if checkBoxTable then
		for index, value in ipairs(checkBoxTable) do
			checkBoxName = checkBoxNameString..index
			checkBox = _G[checkBoxName]
			if checkBox and not checkBox.styled then
				B.ReskinCheck(checkBox)

				checkBox.styled = true
			end
		end
	end
end

local function Reskin_VoicePicker()
	local children = {self.ScrollBox.ScrollTarget:GetChildren()}
	for _, child in pairs(children) do
		if child and not child.styled then
			child.UnCheck:SetTexture(nil)
			child.Highlight:SetColorTexture(cr, cg, cb, .25)

			local check = child.Check
			check:SetColorTexture(cr, cg, cb, .25)
			check:SetSize(10, 10)
			check:SetPoint("LEFT", 2, 0)
			B.CreateBDFrame(check)

			child.styled = true
		end
	end
end

tinsert(C.XMLThemes, function()
	if DB.isNewPatch then
		B.ReskinFrame(TextToSpeechFrame)

		B.StripTextures(TextToSpeechButton, 5)
		TextToSpeechFramePanelContainer:SetBackdrop(nil)
		B.CreateBDFrame(TextToSpeechFramePanelContainer)
		TextToSpeechFramePanelContainerChatTypeContainer:SetBackdrop(nil)
		B.CreateBDFrame(TextToSpeechFramePanelContainerChatTypeContainer)

		B.ReskinButton(TextToSpeechFramePlaySampleButton)
		B.ReskinButton(TextToSpeechFrameDefaults)
		B.ReskinButton(TextToSpeechFrameOkay)

		B.ReskinDropDown(TextToSpeechFrameTtsVoiceDropdown)
		B.ReskinSlider(TextToSpeechFrameAdjustRateSlider)
		B.ReskinSlider(TextToSpeechFrameAdjustVolumeSlider)

		local checkboxes = {
			"PlaySoundWhenEnteringChatWindowCheckButton",
			"PlayActivitySoundWhenNotFocusedCheckButton",
			"PlaySoundSeparatingChatLinesCheckButton",
			"AddCharacterNameToSpeechCheckButton",
			"UseAlternateVoiceForSystemMessagesCheckButton",
		}
		for _, checkbox in pairs(checkboxes) do
			B.ReskinCheck(TextToSpeechFramePanelContainer[checkbox])
		end

		hooksecurefunc("TextToSpeechFrame_Update", Reskin_TextToSpeechFrame)

		-- voice picker
		local VoicePicker = TextToSpeechFramePanelContainer.VoicePicker
		local customFrame = VoicePicker:GetChildren()
		B.ReskinFrame(customFrame)

		VoicePicker:HookScript("OnShow", Reskin_VoicePicker)
	end
end)