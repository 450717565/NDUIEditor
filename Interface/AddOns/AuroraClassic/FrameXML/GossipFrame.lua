local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	F.ReskinFrame(GossipFrame)
	F.StripTextures(GossipGreetingScrollFrame, true)

	F.ReskinButton(GossipFrameGreetingGoodbyeButton)
	F.ReskinScroll(GossipGreetingScrollFrameScrollBar)
	F.ReskinStatusBar(NPCFriendshipStatusBar, false, true)

	GossipGreetingText:SetTextColor(1, 1, 1)
end)