local B, C, L, DB = unpack(select(2, ...))

tinsert(C.defaultThemes, function()
	B.ReskinFrame(ReadyCheckFrame)
	B.ReskinButton(ReadyCheckFrameYesButton)
	B.ReskinButton(ReadyCheckFrameNoButton)
	B.StripTextures(ReadyCheckListenerFrame)

	ReadyCheckPortrait:SetAlpha(0)

	ReadyCheckFrame:HookScript("OnShow", function(self)
		if self.initiator and UnitIsUnit("player", self.initiator) then
			self:Hide()
		end
	end)

	B.ReskinFrame(PVPReadyDialog)
	B.ReskinButton(PVPReadyDialog.enterButton)
	B.ReskinButton(PVPReadyDialog.leaveButton)
	B.ReskinRoleIcon(PVPReadyDialogRoleIconTexture)

	hooksecurefunc("PVPReadyDialog_Display", function(self, _, _, _, _, _, role)
		if self.roleIcon:IsShown() then
			self.roleIcon.texture:SetTexCoord(B.GetRoleTexCoord(role))
		end
	end)
end)