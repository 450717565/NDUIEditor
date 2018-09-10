local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
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
	F.StripTextures(QuickJoinRoleSelectionFrame)

	for _, bu in next, {QuickJoinRoleSelectionFrame.RoleButtonTank, QuickJoinRoleSelectionFrame.RoleButtonHealer, QuickJoinRoleSelectionFrame.RoleButtonDPS} do
		F.ReskinCheck(bu.CheckButton)
	end
end)