local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	F.ReskinPortraitFrame(RolePollPopup, true)
	F.Reskin(RolePollPopupAcceptButton)

	for _, roleButton in next, {RolePollPopupRoleButtonTank, RolePollPopupRoleButtonHealer, RolePollPopupRoleButtonDPS} do
		F.ReskinCheck(roleButton.checkButton)
	end
end)