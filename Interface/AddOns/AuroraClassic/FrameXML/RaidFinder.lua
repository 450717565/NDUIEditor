local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	F.StripTextures(RaidFinderFrame, true)
	F.StripTextures(RaidFinderFrameRoleInset, true)
	F.StripTextures(RaidFinderQueueFrameScrollFrame, true)
	RaidFinderQueueFrameBackground:Hide()

	RaidFinderQueueFrameScrollFrame:SetWidth(304)

	F.ReskinScroll(RaidFinderQueueFrameScrollFrameScrollBar)
	F.ReskinDropDown(RaidFinderQueueFrameSelectionDropDown)
	F.ReskinButton(RaidFinderFrameFindRaidButton)
	F.ReskinButton(RaidFinderQueueFrameIneligibleFrameLeaveQueueButton)
	F.ReskinButton(RaidFinderQueueFramePartyBackfillBackfillButton)
	F.ReskinButton(RaidFinderQueueFramePartyBackfillNoBackfillButton)
end)