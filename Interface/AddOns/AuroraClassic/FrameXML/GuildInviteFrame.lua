local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	F.ReskinFrame(GuildInviteFrame)

	F.ReskinButton(GuildInviteFrameJoinButton)
	F.ReskinButton(GuildInviteFrameDeclineButton)
end)