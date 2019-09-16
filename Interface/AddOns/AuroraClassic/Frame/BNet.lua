local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	F.ReskinFrame(BNToastFrame)
	F.ReskinFrame(BNToastFrame.TooltipFrame)

	local frame, send, cancel = BattleTagInviteFrame:GetChildren()
	F.ReskinFrame(frame)
	F.ReskinButton(send)
	F.ReskinButton(cancel)
end)