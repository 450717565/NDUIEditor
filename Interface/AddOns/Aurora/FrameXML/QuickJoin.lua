local F, C = unpack(select(2, ...))

tinsert(C.themes["Aurora"], function()
	for i = 1, 3 do
		select(i, QuickJoinScrollFrame:GetRegions()):Hide()
	end
	F.ReskinScroll(QuickJoinScrollFrameScrollBar)
	F.Reskin(QuickJoinFrame.JoinQueueButton)

	F.CreateBD(QuickJoinRoleSelectionFrame)
	F.CreateSD(QuickJoinRoleSelectionFrame)
	F.Reskin(QuickJoinRoleSelectionFrame.AcceptButton)
	F.Reskin(QuickJoinRoleSelectionFrame.CancelButton)
	F.ReskinClose(QuickJoinRoleSelectionFrame.CloseButton)
	for i = 1, 9 do
		select(i, QuickJoinRoleSelectionFrame:GetRegions()):Hide()
	end

	for _, bu in pairs({QuickJoinRoleSelectionFrame.RoleButtonTank, QuickJoinRoleSelectionFrame.RoleButtonHealer, QuickJoinRoleSelectionFrame.RoleButtonDPS}) do
		bu.Cover:SetTexture(C.media.roleIcons)
		bu:SetNormalTexture(C.media.roleIcons)
		F.CreateBDFrame(QuickJoinRoleSelectionFrame, .5, 8, -6, -7, 9)

		bu.CheckButton:SetFrameLevel(bu:GetFrameLevel() + 2)
		F.ReskinCheck(bu.CheckButton)
	end
end)