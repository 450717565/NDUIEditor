local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	-- Battlenet toast frame
	F.ReskinFrame(BNToastFrame)
	F.ReskinFrame(BNToastFrame.TooltipFrame)
	F.ReskinFrame(BattleTagInviteFrame)

	local send, cancel = BattleTagInviteFrame:GetChildren()
	F.ReskinButton(send)
	F.ReskinButton(cancel)
end)