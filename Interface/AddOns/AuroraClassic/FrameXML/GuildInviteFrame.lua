local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	for i = 1, 10 do
		select(i, GuildInviteFrame:GetRegions()):Hide()
	end
	F.CreateBD(GuildInviteFrame)
	F.CreateSD(GuildInviteFrame)

	F.Reskin(GuildInviteFrameJoinButton)
	F.Reskin(GuildInviteFrameDeclineButton)
end)