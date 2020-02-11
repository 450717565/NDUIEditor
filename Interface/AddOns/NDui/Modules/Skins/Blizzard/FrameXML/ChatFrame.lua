local B, C, L, DB = unpack(select(2, ...))

tinsert(C.defaultThemes, function()
	local cr, cg, cb = DB.r, DB.g, DB.b
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

	local function reskinScroll(self)
		local thumb = _G[self:GetName().."ThumbTexture"]
		thumb:SetAlpha(0)
		thumb:SetWidth(18)

		local bg = B.CreateBDFrame(thumb, 0)
		self.bdTex = bg

		local down = self.ScrollToBottomButton
		B.ReskinArrow(down, "down")
		down:ClearAllPoints()
		down:SetPoint("BOTTOM", _G[self:GetName().."ResizeButton"], "BOTTOM", -5, 3)
	end

	for i = 1, NUM_CHAT_WINDOWS do
		local frame = "ChatFrame"..i

		reskinScroll(_G[frame])
		B.StripTextures(_G[frame.."Tab"])
	end
end)