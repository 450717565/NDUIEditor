local _, ns = ...
local B, C, L, DB = unpack(ns)

C.LUAThemes["Blizzard_Tutorial"] = function()
	local frame = NPE_TutorialKeyboardMouseFrame_Frame
	frame.TitleBg:Hide()

	B.ReskinFrame(frame)
	B.ReskinText(NPE_TutorialKeyString, 1, 1, 1)
end