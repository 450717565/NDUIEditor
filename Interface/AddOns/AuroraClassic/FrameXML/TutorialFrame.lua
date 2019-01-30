local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	F.ReskinFrame(TutorialFrame)

	TutorialFrameBackground:Hide()
	TutorialFrameBackground.Show = F.Dummy
	TutorialFrame:DisableDrawLayer("BORDER")

	F.ReskinButton(TutorialFrameOkayButton)
	F.ReskinArrow(TutorialFramePrevButton, "left")
	F.ReskinArrow(TutorialFrameNextButton, "right")

	TutorialFrameOkayButton:ClearAllPoints()
	TutorialFrameOkayButton:SetPoint("BOTTOMLEFT", TutorialFrameNextButton, "BOTTOMRIGHT", 10, 0)
end)