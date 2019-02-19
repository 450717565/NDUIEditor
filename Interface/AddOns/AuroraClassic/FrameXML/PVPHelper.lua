local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	PVPReadyDialogBackground:Hide()

	F.ReskinFrame(PVPReadyDialog)
	F.ReskinButton(PVPReadyDialog.enterButton)
	F.ReskinButton(PVPReadyDialog.leaveButton)

	hooksecurefunc("PVPReadyDialog_Display", function(self, _, _, _, _, _, role)
		if self.roleIcon:IsShown() then
			self.roleIcon.texture:SetTexCoord(F.GetRoleTexCoord(role))
		end
	end)
end)