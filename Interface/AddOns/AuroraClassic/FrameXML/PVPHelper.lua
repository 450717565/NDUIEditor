local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	PVPReadyDialogBackground:Hide()
	PVPReadyDialogBottomArt:Hide()
	PVPReadyDialogFiligree:Hide()

	F.ReskinFrame(PVPReadyDialog)
	PVPReadyDialog.SetBackdrop = F.dummy

	F.ReskinButton(PVPReadyDialog.enterButton)
	F.ReskinButton(PVPReadyDialog.leaveButton)
end)