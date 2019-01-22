local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	local r, g, b = C.r, C.g, C.b

	F.ReskinFrame(GossipFrame)
	F.StripTextures(GossipGreetingScrollFrame, true)

	F.ReskinButton(GossipFrameGreetingGoodbyeButton)
	F.ReskinScroll(GossipGreetingScrollFrameScrollBar)
	F.ReskinStatusBar(NPCFriendshipStatusBar, false, true)

	GossipGreetingText:SetTextColor(1, 1, 1)

	for i = 1, NUMGOSSIPBUTTONS do
		local button = _G["GossipTitleButton"..i]
		if button then
			button:SetHighlightTexture(C.media.bdTex)
			local hl = button:GetHighlightTexture()
			hl:SetColorTexture(r, g, b, .25)
			hl:SetPoint("TOPLEFT", 0, 2)
			hl:SetPoint("BOTTOMRIGHT", 0, -2)
		end
	end
end)