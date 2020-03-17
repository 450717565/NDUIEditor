local B, C, L, DB = unpack(select(2, ...))

tinsert(C.defaultThemes, function()
	local bg = B.ReskinFrame(GhostFrame)
	B.ReskinHighlight(GhostFrame, bg, true)

	B.ReskinIcon(GhostFrameContentsFrameIcon)
end)