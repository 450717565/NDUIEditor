local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	local bg = F.ReskinFrame(GhostFrame)
	F.ReskinTexture(GhostFrame, bg, true)

	F.ReskinIcon(GhostFrameContentsFrameIcon)
end)