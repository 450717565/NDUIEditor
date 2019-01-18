local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	F.ReskinFrame(GhostFrame)
	F.ReskinIcon(GhostFrameContentsFrameIcon, true)
	F.ReskinTexture(GhostFrame, GhostFrame, true)
end)