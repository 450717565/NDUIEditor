local B, C, L, DB = unpack(select(2, ...))

C.themes["Blizzard_Tutorial"] = function()
	local tutorialFrame = NPE_TutorialKeyboardMouseFrame_Frame
	B.ReskinFrame(tutorialFrame)

	tutorialFrame.TitleBg:Hide()
	NPE_TutorialKeyString:SetTextColor(1, 1, 1)
end