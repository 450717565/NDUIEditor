local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	local friendTex = "Interface\\HELPFRAME\\ReportLagIcon-Chat"
	local queueTex = "Interface\\HELPFRAME\\HelpIcon-ItemRestoration"
	local homeTex = "Interface\\Buttons\\UI-HomeButton"

	QuickJoinToastButton.FriendsButton:SetTexture(friendTex)
	QuickJoinToastButton.QueueButton:SetTexture(queueTex)
	QuickJoinToastButton:SetHighlightTexture("")
	hooksecurefunc(QuickJoinToastButton, "ToastToFriendFinished", function(self)
		self.FriendsButton:SetShown(not self.displayedToast)
	end)

	hooksecurefunc(QuickJoinToastButton, "UpdateQueueIcon", function(self)
		if not self.displayedToast then return end
		self.QueueButton:SetTexture(queueTex)
		self.FlashingLayer:SetTexture(queueTex)
		self.FriendsButton:SetShown(false)
	end)

	QuickJoinToastButton:HookScript("OnMouseDown", function(self)
		self.FriendsButton:SetTexture(friendTex)
	end)

	QuickJoinToastButton:HookScript("OnMouseUp", function(self)
		self.FriendsButton:SetTexture(friendTex)
	end)

	F.StripTextures(QuickJoinToastButton.Toast)
	local bg = F.CreateBDFrame(QuickJoinToastButton.Toast, .25)
	bg:SetPoint("TOPLEFT", 10, -1)
	bg:SetPoint("BOTTOMRIGHT", 0, 3)
	bg:Hide()
	hooksecurefunc(QuickJoinToastButton, "ShowToast", function() bg:Show() end)
	hooksecurefunc(QuickJoinToastButton, "HideToast", function() bg:Hide() end)

	F.ReskinButton(ChatFrameChannelButton)
	ChatFrameChannelButton:SetSize(20, 20)

	F.ReskinButton(ChatFrameToggleVoiceDeafenButton)
	ChatFrameToggleVoiceDeafenButton:SetSize(20, 20)

	F.ReskinButton(ChatFrameToggleVoiceMuteButton)
	ChatFrameToggleVoiceMuteButton:SetSize(20, 20)

	F.ReskinButton(ChatFrameMenuButton)
	ChatFrameMenuButton:SetSize(20, 20)
	ChatFrameMenuButton:SetNormalTexture(homeTex)
	ChatFrameMenuButton:SetPushedTexture(homeTex)

	local function reskinScroll(self)
		local bu = _G[self:GetName().."ThumbTexture"]
		bu:SetAlpha(0)
		bu:SetWidth(16)
		F.CreateBDFrame(bu, .25)

		local down = self.ScrollToBottomButton
		F.ReskinArrow(down, "down")
		down:ClearAllPoints()
		down:SetPoint("BOTTOM", _G[self:GetName().."ResizeButton"], "BOTTOM", -5, 3)
	end

	for i = 1, NUM_CHAT_WINDOWS do
		reskinScroll(_G["ChatFrame"..i])
		F.StripTextures(_G["ChatFrame"..i.."Tab"])
	end
end)