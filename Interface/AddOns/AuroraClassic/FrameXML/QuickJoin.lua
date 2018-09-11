local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	F.StripTextures(QuickJoinScrollFrame, true)

	F.ReskinScroll(QuickJoinScrollFrameScrollBar)
	F.Reskin(QuickJoinFrame.JoinQueueButton)
end)