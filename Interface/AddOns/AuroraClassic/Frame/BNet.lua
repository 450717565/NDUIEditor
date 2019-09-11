local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	F.ReskinFrame(BNToastFrame)
	F.ReskinFrame(BNToastFrame.TooltipFrame)

	local p1, p2, p3, x, y = BNToastFrame:GetPoint()
	--BNToastFrame:ClearAllPoints()
	BNToastFrame:SetPoint(p1, p2, p3, x+3, y)

	local frame, send, cancel = BattleTagInviteFrame:GetChildren()
	F.ReskinFrame(frame)
	F.ReskinButton(send)
	F.ReskinButton(cancel)
end)