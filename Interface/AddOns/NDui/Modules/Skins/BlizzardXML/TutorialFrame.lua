local _, ns = ...
local B, C, L, DB = unpack(ns)

tinsert(C.XMLThemes, function()
	B.ReskinFrame(TutorialFrame)

	B.ReskinButton(TutorialFrameOkayButton)
	B.ReskinArrow(TutorialFramePrevButton, "left")
	B.ReskinArrow(TutorialFrameNextButton, "right")

	TutorialFrameBackground:SetAlpha(0)
	TutorialFrame:DisableDrawLayer("BORDER")

	TutorialFrameOkayButton:ClearAllPoints()
	TutorialFrameOkayButton:SetPoint("BOTTOMLEFT", TutorialFrameNextButton, "BOTTOMRIGHT", 10, 0)
end)