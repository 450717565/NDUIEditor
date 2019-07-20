local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	F.StripTextures(LFDParentFrame)

	LFDQueueFrameBackground:Hide()
	LFDQueueFrameRandomScrollFrame:SetWidth(304)

	F.ReskinFrame(LFDRoleCheckPopup)
	F.ReskinDropDown(LFDQueueFrameTypeDropDown)
	F.ReskinScroll(LFDQueueFrameSpecificListScrollFrameScrollBar)
	F.ReskinScroll(LFDQueueFrameRandomScrollFrameScrollBar)

	local buttons = {LFDRoleCheckPopupAcceptButton, LFDRoleCheckPopupDeclineButton, LFDQueueFrameFindGroupButton, LFDQueueFramePartyBackfillBackfillButton, LFDQueueFramePartyBackfillNoBackfillButton, LFDQueueFrameNoLFDWhileLFRLeaveQueueButton}
	for _, button in pairs(buttons) do
		F.ReskinButton(button)
	end

	hooksecurefunc("LFGDungeonListButton_SetDungeon", function(button)
		if not button.styled then
			F.ReskinCheck(button.enableButton)
			F.ReskinExpandOrCollapse(button.expandOrCollapseButton)

			button.styled = true
		end

		button.enableButton:GetCheckedTexture():SetDesaturated(true)
	end)
end)