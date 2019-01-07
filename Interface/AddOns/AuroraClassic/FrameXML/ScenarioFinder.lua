local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	ScenarioQueueFrame.Bg:Hide()
	ScenarioQueueFrameRandomScrollFrame:SetWidth(304)

	F.StripTextures(ScenarioFinderFrameInset, true)
	F.Reskin(ScenarioQueueFrameFindGroupButton)
	F.Reskin(ScenarioQueueFrameRandomScrollFrameChildFrame.bonusRepFrame.ChooseButton)
	F.ReskinDropDown(ScenarioQueueFrameTypeDropDown)
	F.ReskinScroll(ScenarioQueueFrameRandomScrollFrameScrollBar)
	F.ReskinScroll(ScenarioQueueFrameSpecificScrollFrameScrollBar)
end)