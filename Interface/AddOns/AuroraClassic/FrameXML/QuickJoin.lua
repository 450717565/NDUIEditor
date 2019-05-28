local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	F.StripTextures(QuickJoinScrollFrame)
	F.ReskinScroll(QuickJoinScrollFrameScrollBar)

	F.ReskinRole(QuickJoinRoleSelectionFrame.RoleButtonTank, "TANK")
	F.ReskinRole(QuickJoinRoleSelectionFrame.RoleButtonHealer, "HEALER")
	F.ReskinRole(QuickJoinRoleSelectionFrame.RoleButtonDPS, "DPS")

	local JoinQueueButton = QuickJoinFrame.JoinQueueButton
	F.ReskinButton(JoinQueueButton)
	JoinQueueButton:SetSize(134, 21)
	JoinQueueButton:ClearAllPoints()
	JoinQueueButton:SetPoint("BOTTOMRIGHT", -6, 4)
end)