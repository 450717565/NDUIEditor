local F, C = unpack(select(2, ...))

C.themes["Simulationcraft"] = function()
	F.ReskinFrame(SimcCopyFrame)
	F.ReskinButton(SimcCopyFrameButton)
	F.ReskinScroll(SimcCopyFrameScrollScrollBar)
end