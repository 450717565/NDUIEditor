local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	local r, g, b = C.r, C.g, C.b

	F.ReskinFrame(GossipFrame)
	F.StripTextures(GossipGreetingScrollFrame, true)

	F.ReskinButton(GossipFrameGreetingGoodbyeButton)
	F.ReskinScroll(GossipGreetingScrollFrameScrollBar)
	F.ReskinStatusBar(NPCFriendshipStatusBar, true)

	GossipGreetingText:SetTextColor(1, 1, 1)

	for i = 1, NUMGOSSIPBUTTONS do
		local button = _G["GossipTitleButton"..i]
		if button then
			F.ReskinTexture(button, button, true)
		end
	end
end)