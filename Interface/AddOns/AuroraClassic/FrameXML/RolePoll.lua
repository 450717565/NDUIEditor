local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	F.ReskinFrame(RolePollPopup)
	F.ReskinButton(RolePollPopupAcceptButton)

	F.ReskinRole(RolePollPopupRoleButtonTank, "TANK")
	F.ReskinRole(RolePollPopupRoleButtonHealer, "HEALER")
	F.ReskinRole(RolePollPopupRoleButtonDPS, "DPS")
end)