local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	F.ReskinPortraitFrame(GossipFrame, true)
	F.StripTextures(GossipGreetingScrollFrame, true)

	F.Reskin(GossipFrameGreetingGoodbyeButton)
	F.ReskinScroll(GossipGreetingScrollFrameScrollBar)
	F.ReskinStatusBar(NPCFriendshipStatusBar, false, true)

	GossipGreetingText:SetTextColor(1, 1, 1)
end)