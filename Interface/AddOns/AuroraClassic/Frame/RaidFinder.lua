local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	F.StripTextures(RaidFinderFrame)
	F.StripTextures(RaidFinderFrameRoleInset)

	RaidFinderQueueFrameBackground:Hide()
	RaidFinderQueueFrameScrollFrame:SetWidth(304)

	F.ReskinScroll(RaidFinderQueueFrameScrollFrameScrollBar)
	F.ReskinDropDown(RaidFinderQueueFrameSelectionDropDown)

	local buttons = {RaidFinderFrameFindRaidButton, RaidFinderQueueFrameIneligibleFrameLeaveQueueButton, RaidFinderQueueFramePartyBackfillBackfillButton, RaidFinderQueueFramePartyBackfillNoBackfillButton}
	for _, button in pairs(buttons) do
		F.ReskinButton(button)
	end
end)