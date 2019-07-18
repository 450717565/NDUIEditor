local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	F.ReskinFrame(RaidInfoFrame)

	F.ReskinButton(RaidFrameRaidInfoButton)
	F.ReskinButton(RaidInfoCancelButton)
	F.ReskinButton(RaidInfoExtendButton)
	F.ReskinCheck(RaidFrameAllAssistCheckButton)
	F.ReskinClose(RaidInfoCloseButton)
	F.ReskinScroll(RaidInfoScrollFrameScrollBar)

	RaidInfoFrame:ClearAllPoints()
	RaidInfoFrame:SetPoint("TOPLEFT", RaidFrame, "TOPRIGHT", 3, 0)
	RaidInfoFrameHeaderText:ClearAllPoints()
	RaidInfoFrameHeaderText:SetPoint("TOP", RaidInfoFrame, "TOP", 0, -10)
	RaidFrameRaidInfoButton:ClearAllPoints()
	RaidFrameRaidInfoButton:SetPoint("TOPRIGHT", FriendsFrame.CloseButton, "BOTTOMRIGHT", 0, -2)
	RaidFrame.RoleCount:ClearAllPoints()
	RaidFrame.RoleCount:SetPoint("RIGHT", RaidFrameRaidInfoButton, "LEFT", 0, 0)
	RaidFrameAllAssistCheckButton:ClearAllPoints()
	RaidFrameAllAssistCheckButton:SetPoint("RIGHT", RaidFrame.RoleCount, "LEFT", -60, 0)

	local ConvertButton = RaidFrameConvertToRaidButton
	F.ReskinButton(RaidFrameConvertToRaidButton)
	ConvertButton:SetSize(134, 21)
	ConvertButton:ClearAllPoints()
	ConvertButton:SetPoint("BOTTOMRIGHT", -6, 4)

	local labels =  {RaidInfoInstanceLabel, RaidInfoIDLabel}
	for _, label in pairs(labels) do
		F.StripTextures(label)
		F.CreateBDFrame(label, 0, -C.mult)
	end
end)