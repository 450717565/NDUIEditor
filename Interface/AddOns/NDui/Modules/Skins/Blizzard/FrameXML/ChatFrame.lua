local B, C, L, DB = unpack(select(2, ...))

tinsert(C.defaultThemes, function()
	local homeTex = "Interface\\Buttons\\UI-HomeButton"

	B.ReskinButton(ChatFrameChannelButton)
	ChatFrameChannelButton:SetSize(20, 20)

	B.ReskinButton(ChatFrameToggleVoiceDeafenButton)
	ChatFrameToggleVoiceDeafenButton:SetSize(20, 20)

	B.ReskinButton(ChatFrameToggleVoiceMuteButton)
	ChatFrameToggleVoiceMuteButton:SetSize(20, 20)

	B.ReskinButton(ChatFrameMenuButton)
	ChatFrameMenuButton:SetSize(20, 20)
	ChatFrameMenuButton:SetNormalTexture(homeTex)
	ChatFrameMenuButton:SetPushedTexture(homeTex)

	B.ReskinArrow(GeneralDockManagerOverflowButton, "down")
	GeneralDockManagerOverflowButton:ClearAllPoints()
	GeneralDockManagerOverflowButton:SetPoint("BOTTOM", ChatFrameMenuButton, "TOP", 0, 3)

	local function reskinScroll(self)
		local thumb = _G[B.GetFrameName(self).."ThumbTexture"]
		thumb:SetAlpha(0)
		thumb:SetWidth(18)

		local bdTex = B.CreateBDFrame(thumb, 0)
		self.bdTex = bdTex
		B.Hook_OnEnter(self)
		B.Hook_OnLeave(self)

		local down = self.ScrollToBottomButton
		B.ReskinArrow(down, "down")
		down:ClearAllPoints()
		down:SetPoint("BOTTOM", _G[B.GetFrameName(self).."ResizeButton"], "BOTTOM", -5, 3)
	end

	for i = 1, NUM_CHAT_WINDOWS do
		local frame = "ChatFrame"..i

		reskinScroll(_G[frame])
		B.StripTextures(_G[frame.."Tab"])
	end
end)