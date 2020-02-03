local B, C, L, DB = unpack(select(2, ...))

tinsert(C.defaultThemes, function()
	B.ReskinFrame(TutorialFrame)

	B.ReskinButton(TutorialFrameOkayButton)
	B.ReskinArrow(TutorialFramePrevButton, "left")
	B.ReskinArrow(TutorialFrameNextButton, "right")

	TutorialFrameBackground:Hide()
	TutorialFrameBackground.Show = B.Dummy
	TutorialFrame:DisableDrawLayer("BORDER")

	TutorialFrameOkayButton:ClearAllPoints()
	TutorialFrameOkayButton:SetPoint("BOTTOMLEFT", TutorialFrameNextButton, "BOTTOMRIGHT", 10, 0)
end)