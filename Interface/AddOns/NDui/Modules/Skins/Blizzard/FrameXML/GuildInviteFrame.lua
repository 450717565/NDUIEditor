local B, C, L, DB = unpack(select(2, ...))

tinsert(C.defaultThemes, function()
	B.ReskinFrame(GuildInviteFrame)

	B.ReskinButton(GuildInviteFrameJoinButton)
	B.ReskinButton(GuildInviteFrameDeclineButton)
end)