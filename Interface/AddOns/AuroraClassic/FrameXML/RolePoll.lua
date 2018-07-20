local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	F.CreateBD(RolePollPopup)
	F.CreateSD(RolePollPopup)
	F.Reskin(RolePollPopupAcceptButton)
	F.ReskinClose(RolePollPopupCloseButton)

	for _, roleButton in pairs({RolePollPopupRoleButtonTank, RolePollPopupRoleButtonHealer, RolePollPopupRoleButtonDPS}) do
		roleButton.cover:SetTexture(C.media.roleIcons)
		roleButton:SetNormalTexture(C.media.roleIcons)
		F.CreateBDFrame(roleButton, .5, 9, -7, -9, 11)

		roleButton.checkButton:SetFrameLevel(roleButton:GetFrameLevel() + 2)
		F.ReskinRadio(roleButton.checkButton)
	end
end)