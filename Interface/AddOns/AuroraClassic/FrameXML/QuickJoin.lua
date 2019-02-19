local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	F.StripTextures(QuickJoinScrollFrame, true)

	F.ReskinScroll(QuickJoinScrollFrameScrollBar)
	F.ReskinButton(QuickJoinFrame.JoinQueueButton)

	F.ReskinRole(QuickJoinRoleSelectionFrame.RoleButtonTank, "TANK")
	F.ReskinRole(QuickJoinRoleSelectionFrame.RoleButtonHealer, "HEALER")
	F.ReskinRole(QuickJoinRoleSelectionFrame.RoleButtonDPS, "DPS")
end)