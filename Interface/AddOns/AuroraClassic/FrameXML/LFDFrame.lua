local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	F.StripTextures(LFDParentFrame)
	F.StripTextures(LFDQueueFrameRandomScrollFrame)
	F.StripTextures(LFDQueueFrameSpecificListScrollFrame)
	LFDQueueFrameBackground:Hide()

	-- this fixes right border of second reward being cut off
	LFDQueueFrameRandomScrollFrame:SetWidth(LFDQueueFrameRandomScrollFrame:GetWidth()+1)

	hooksecurefunc("LFGDungeonListButton_SetDungeon", function(button)
		if not button.expandOrCollapseButton.styled then
			F.ReskinCheck(button.enableButton)
			F.ReskinExpandOrCollapse(button.expandOrCollapseButton)

			button.expandOrCollapseButton.styled = true
		end

		button.enableButton:GetCheckedTexture():SetDesaturated(true)
	end)

	F.ReskinFrame(LFDRoleCheckPopup)
	F.ReskinButton(LFDRoleCheckPopupAcceptButton)
	F.ReskinButton(LFDRoleCheckPopupDeclineButton)
	F.ReskinButton(LFDQueueFrameRandomScrollFrameChildFrame.bonusRepFrame.ChooseButton)
	F.ReskinScroll(LFDQueueFrameSpecificListScrollFrameScrollBar)
	F.ReskinScroll(LFDQueueFrameRandomScrollFrameScrollBar)
	F.ReskinDropDown(LFDQueueFrameTypeDropDown)
	F.ReskinButton(LFDQueueFrameFindGroupButton)
	F.ReskinButton(LFDQueueFramePartyBackfillBackfillButton)
	F.ReskinButton(LFDQueueFramePartyBackfillNoBackfillButton)
	F.ReskinButton(LFDQueueFrameNoLFDWhileLFRLeaveQueueButton)

	LFDQueueFrameSpecificListScrollFrameScrollBarScrollDownButton:SetPoint("TOP", LFDQueueFrameSpecificListScrollFrameScrollBar, "BOTTOM", 0, 2)
	LFDQueueFrameRandomScrollFrameScrollBarScrollDownButton:SetPoint("TOP", LFDQueueFrameRandomScrollFrameScrollBar, "BOTTOM", 0, 2)
end)