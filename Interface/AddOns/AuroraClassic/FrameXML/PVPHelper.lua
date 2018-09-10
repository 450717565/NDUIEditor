local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	local PVPReadyDialog = PVPReadyDialog

	PVPReadyDialogBackground:Hide()
	PVPReadyDialogBottomArt:Hide()
	PVPReadyDialogFiligree:Hide()

	F.CreateBD(PVPReadyDialog)
	F.CreateSD(PVPReadyDialog)
	PVPReadyDialog.SetBackdrop = F.dummy

	F.Reskin(PVPReadyDialog.enterButton)
	F.Reskin(PVPReadyDialog.leaveButton)
	F.ReskinClose(PVPReadyDialogCloseButton)
end)