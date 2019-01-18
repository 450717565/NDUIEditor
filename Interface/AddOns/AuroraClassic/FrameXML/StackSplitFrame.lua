local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	F.ReskinFrame(StackSplitFrame)

	F.ReskinButton(StackSplitFrame.OkayButton)
	F.ReskinButton(StackSplitFrame.CancelButton)
	F.ReskinArrow(StackSplitFrame.LeftButton, "left")
	F.ReskinArrow(StackSplitFrame.RightButton, "right")
end)