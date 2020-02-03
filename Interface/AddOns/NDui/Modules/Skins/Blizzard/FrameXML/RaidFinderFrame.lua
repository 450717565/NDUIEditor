local B, C, L, DB = unpack(select(2, ...))

tinsert(C.defaultThemes, function()
	B.StripTextures(RaidFinderFrame)
	B.StripTextures(RaidFinderFrameRoleInset)

	RaidFinderQueueFrameBackground:Hide()
	RaidFinderQueueFrameScrollFrame:SetWidth(304)

	B.ReskinScroll(RaidFinderQueueFrameScrollFrameScrollBar)
	B.ReskinDropDown(RaidFinderQueueFrameSelectionDropDown)

	local buttons = {RaidFinderFrameFindRaidButton, RaidFinderQueueFrameIneligibleFrameLeaveQueueButton, RaidFinderQueueFramePartyBackfillBackfillButton, RaidFinderQueueFramePartyBackfillNoBackfillButton}
	for _, button in pairs(buttons) do
		B.ReskinButton(button)
	end
end)