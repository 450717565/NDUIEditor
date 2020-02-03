local B, C, L, DB = unpack(select(2, ...))

tinsert(C.defaultThemes, function()
	B.ReskinScroll(QuickJoinScrollFrame.scrollBar)

	B.ReskinRole(QuickJoinRoleSelectionFrame.RoleButtonTank, "TANK")
	B.ReskinRole(QuickJoinRoleSelectionFrame.RoleButtonHealer, "HEALER")
	B.ReskinRole(QuickJoinRoleSelectionFrame.RoleButtonDPS, "DPS")

	local JoinQueueButton = QuickJoinFrame.JoinQueueButton
	B.ReskinButton(JoinQueueButton)
	JoinQueueButton:SetSize(134, 21)
	JoinQueueButton:ClearAllPoints()
	JoinQueueButton:SetPoint("BOTTOMRIGHT", -6, 4)
end)