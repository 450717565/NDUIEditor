local B, C, L, DB = unpack(select(2, ...))

tinsert(C.defaultThemes, function()
	B.StripTextures(ScenarioFinderFrameInset)

	ScenarioQueueFrame.Bg:Hide()
	ScenarioQueueFrameRandomScrollFrame:SetWidth(304)

	B.ReskinButton(ScenarioQueueFrameFindGroupButton)
	B.ReskinButton(ScenarioQueueFrameRandomScrollFrameChildFrame.bonusRepFrame.ChooseButton)
	B.ReskinDropDown(ScenarioQueueFrameTypeDropDown)
	B.ReskinScroll(ScenarioQueueFrameRandomScrollFrameScrollBar)
	B.ReskinScroll(ScenarioQueueFrameSpecificScrollFrameScrollBar)
end)