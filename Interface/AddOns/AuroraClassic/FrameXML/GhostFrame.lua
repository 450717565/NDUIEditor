local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	F.ReskinPortraitFrame(GhostFrame, true)
	F.ReskinIcon(GhostFrameContentsFrameIcon, true)
	F.ReskinHighlight(GhostFrame, true)
end)