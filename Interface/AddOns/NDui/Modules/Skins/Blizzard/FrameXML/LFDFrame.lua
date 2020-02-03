local B, C, L, DB = unpack(select(2, ...))

tinsert(C.defaultThemes, function()
	B.StripTextures(LFDParentFrame)

	LFDQueueFrameBackground:Hide()
	LFDQueueFrameRandomScrollFrame:SetWidth(304)

	B.ReskinFrame(LFDRoleCheckPopup)
	B.ReskinDropDown(LFDQueueFrameTypeDropDown)
	B.ReskinScroll(LFDQueueFrameSpecificListScrollFrameScrollBar)
	B.ReskinScroll(LFDQueueFrameRandomScrollFrameScrollBar)

	local buttons = {LFDRoleCheckPopupAcceptButton, LFDRoleCheckPopupDeclineButton, LFDQueueFrameFindGroupButton, LFDQueueFramePartyBackfillBackfillButton, LFDQueueFramePartyBackfillNoBackfillButton, LFDQueueFrameNoLFDWhileLFRLeaveQueueButton}
	for _, button in pairs(buttons) do
		B.ReskinButton(button)
	end

	hooksecurefunc("LFGDungeonListButton_SetDungeon", function(button)
		if not button.styled then
			B.ReskinCheck(button.enableButton)
			B.ReskinExpandOrCollapse(button.expandOrCollapseButton)

			button.styled = true
		end

		button.enableButton:GetCheckedTexture():SetDesaturated(true)
	end)
end)