local B, C, L, DB = unpack(select(2, ...))

tinsert(C.defaultThemes, function()
	B.ReskinFrame(RaidInfoFrame)

	B.ReskinButton(RaidFrameRaidInfoButton)
	B.ReskinButton(RaidInfoCancelButton)
	B.ReskinButton(RaidInfoExtendButton)
	B.ReskinCheck(RaidFrameAllAssistCheckButton)
	B.ReskinClose(RaidInfoCloseButton)
	B.ReskinScroll(RaidInfoScrollFrameScrollBar)

	RaidInfoFrame:ClearAllPoints()
	RaidInfoFrame:SetPoint("TOPLEFT", RaidFrame, "TOPRIGHT", 3, -25)
	RaidFrameRaidInfoButton:ClearAllPoints()
	RaidFrameRaidInfoButton:SetPoint("TOPRIGHT", FriendsFrame.CloseButton, "BOTTOMRIGHT", 0, -2)
	RaidFrame.RoleCount:ClearAllPoints()
	RaidFrame.RoleCount:SetPoint("RIGHT", RaidFrameRaidInfoButton, "LEFT", 0, 0)
	RaidFrameAllAssistCheckButton:ClearAllPoints()
	RaidFrameAllAssistCheckButton:SetPoint("RIGHT", RaidFrame.RoleCount, "LEFT", -60, 0)

	local ConvertButton = RaidFrameConvertToRaidButton
	B.ReskinButton(RaidFrameConvertToRaidButton)
	ConvertButton:SetSize(134, 21)
	ConvertButton:ClearAllPoints()
	ConvertButton:SetPoint("BOTTOMRIGHT", -6, 4)

	local labels =  {RaidInfoInstanceLabel, RaidInfoIDLabel}
	for _, label in pairs(labels) do
		B.StripTextures(label)
		B.CreateBDFrame(label, 0, -C.mult*2)
	end
end)