local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	F.ReskinFrame(RaidInfoFrame)
	F.ReskinButton(RaidFrameConvertToRaidButton)
	F.ReskinButton(RaidFrameRaidInfoButton)
	F.ReskinButton(RaidInfoCancelButton)
	F.ReskinButton(RaidInfoExtendButton)
	F.ReskinCheck(RaidFrameAllAssistCheckButton)
	F.ReskinClose(RaidInfoCloseButton)
	F.ReskinScroll(RaidInfoScrollFrameScrollBar)

	RaidInfoFrame:ClearAllPoints()
	RaidInfoFrame:SetPoint("TOPLEFT", RaidFrame, "TOPRIGHT", 2, 0)
	RaidInfoFrameHeaderText:ClearAllPoints()
	RaidInfoFrameHeaderText:SetPoint("TOP", RaidInfoFrame, "TOP", 0, -10)

	local labels =  {RaidInfoInstanceLabel, RaidInfoIDLabel}
	for _, label in pairs(labels) do
		F.StripTextures(label)

		local bg = F.CreateBDFrame(label, 0)
		bg:SetPoint("TOPLEFT", C.mult, -C.mult)
		bg:SetPoint("BOTTOMRIGHT", -C.mult, C.mult)
	end
end)