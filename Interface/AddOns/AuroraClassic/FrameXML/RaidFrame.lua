local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	F.StripTextures(RaidInfoFrame, true)

	F.CreateBD(RaidInfoFrame)
	F.CreateSD(RaidInfoFrame)
	F.Reskin(RaidFrameRaidInfoButton)
	F.Reskin(RaidFrameConvertToRaidButton)
	F.Reskin(RaidInfoExtendButton)
	F.Reskin(RaidInfoCancelButton)
	F.ReskinClose(RaidInfoCloseButton)
	F.ReskinCheck(RaidFrameAllAssistCheckButton)
	F.ReskinScroll(RaidInfoScrollFrameScrollBar)

	RaidInfoFrame:SetPoint("TOPLEFT", RaidFrame, "TOPRIGHT", 1, 0)
	RaidInfoFrameHeaderText:SetPoint("TOP", RaidInfoFrame, "TOP", 0, -10)
end)