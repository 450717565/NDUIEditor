local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	F.ReskinFrame(RolePollPopup)
	F.ReskinButton(RolePollPopupAcceptButton)

	for _, roleButton in next, {RolePollPopupRoleButtonTank, RolePollPopupRoleButtonHealer, RolePollPopupRoleButtonDPS} do
		F.ReskinCheck(roleButton.checkButton)
	end
end)