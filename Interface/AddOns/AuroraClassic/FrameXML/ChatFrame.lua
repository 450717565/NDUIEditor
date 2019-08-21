local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	local cr, cg, cb = C.r, C.g, C.b
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
	local bg = F.CreateBDFrame(QuickJoinToastButton.Toast, 0)
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

	local function scrollOnEnter(self)
		self.thumbBG:SetBackdropColor(cr, cg, cb, .25)
		self.thumbBG:SetBackdropBorderColor(cr, cg, cb)
	end

	local function scrollOnLeave(self)
		self.thumbBG:SetBackdropColor(0, 0, 0, 0)
		self.thumbBG:SetBackdropBorderColor(0, 0, 0)
	end

	local function reskinScroll(self)
		local bu = _G[self:GetName().."ThumbTexture"]
		bu:SetAlpha(0)
		bu:SetWidth(16)
		F.CreateBDFrame(bu, .25)

		local down = self.ScrollToBottomButton
		F.ReskinArrow(down, "down")
		down:ClearAllPoints()
		down:SetPoint("BOTTOM", _G[self:GetName().."ResizeButton"], "BOTTOM", -5, 3)

		self.ScrollBar.thumbBG = bg
		self.ScrollBar:HookScript("OnEnter", scrollOnEnter)
		self.ScrollBar:HookScript("OnLeave", scrollOnLeave)
	end

	for i = 1, NUM_CHAT_WINDOWS do
		local frame = "ChatFrame"..i

		reskinScroll(_G[frame])
		F.StripTextures(_G[frame.."Tab"])
	end
end)