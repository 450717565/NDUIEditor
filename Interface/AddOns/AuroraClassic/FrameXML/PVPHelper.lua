local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	PVPReadyDialogBackground:Hide()
	PVPReadyDialogBottomArt:Hide()
	PVPReadyDialogFiligree:Hide()

	F.ReskinPortraitFrame(PVPReadyDialog, true)
	PVPReadyDialog.SetBackdrop = F.dummy

	F.Reskin(PVPReadyDialog.enterButton)
	F.Reskin(PVPReadyDialog.leaveButton)
end)