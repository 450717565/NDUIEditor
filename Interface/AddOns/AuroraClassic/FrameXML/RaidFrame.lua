local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	F.ReskinFrame(RaidInfoFrame)
	F.ReskinButton(RaidFrameRaidInfoButton)
	F.ReskinButton(RaidFrameConvertToRaidButton)
	F.ReskinButton(RaidInfoExtendButton)
	F.ReskinButton(RaidInfoCancelButton)
	F.ReskinCheck(RaidFrameAllAssistCheckButton)
	F.ReskinScroll(RaidInfoScrollFrameScrollBar)

	RaidInfoFrame:SetPoint("TOPLEFT", RaidFrame, "TOPRIGHT", 1, 0)
	RaidInfoFrameHeaderText:SetPoint("TOP", RaidInfoFrame, "TOP", 0, -10)
end)