local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	F.StripTextures(ScenarioFinderFrameInset)

	ScenarioQueueFrame.Bg:Hide()
	ScenarioQueueFrameRandomScrollFrame:SetWidth(304)

	F.ReskinButton(ScenarioQueueFrameFindGroupButton)
	F.ReskinButton(ScenarioQueueFrameRandomScrollFrameChildFrame.bonusRepFrame.ChooseButton)
	F.ReskinDropDown(ScenarioQueueFrameTypeDropDown)
	F.ReskinScroll(ScenarioQueueFrameRandomScrollFrameScrollBar)
	F.ReskinScroll(ScenarioQueueFrameSpecificScrollFrameScrollBar)
end)