local _, ns = ...
local B, C, L, DB = unpack(ns)

C.LUAThemes["Blizzard_NewPlayerExperienceGuide"] = function()
	B.ReskinFrame(GuideFrame)
	B.ReskinText(GuideFrame.Title, 1, .8, 0)

	local ScrollFrame = GuideFrame.ScrollFrame
	B.ReskinScroll(ScrollFrame.ScrollBar)
	B.ReskinButton(ScrollFrame.ConfirmationButton)
	B.ReskinText(ScrollFrame.Child.Text, 1, 1, 1)
end