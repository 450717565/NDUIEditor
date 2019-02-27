local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	F.StripTextures(LFDParentFrame)
	F.StripTextures(LFDQueueFrameRandomScrollFrame)
	F.StripTextures(LFDQueueFrameSpecificListScrollFrame)

	LFDQueueFrameBackground:Hide()
	LFDQueueFrameRandomScrollFrameScrollBackground:Hide()

	F.ReskinFrame(LFDRoleCheckPopup)
	F.ReskinDropDown(LFDQueueFrameTypeDropDown)
	F.ReskinScroll(LFDQueueFrameSpecificListScrollFrameScrollBar)
	F.ReskinScroll(LFDQueueFrameRandomScrollFrameScrollBar)

	local buttons = {LFDRoleCheckPopupAcceptButton, LFDRoleCheckPopupDeclineButton, LFDQueueFrameFindGroupButton, LFDQueueFramePartyBackfillBackfillButton, LFDQueueFramePartyBackfillNoBackfillButton, LFDQueueFrameNoLFDWhileLFRLeaveQueueButton}
	for _, button in next, buttons do
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