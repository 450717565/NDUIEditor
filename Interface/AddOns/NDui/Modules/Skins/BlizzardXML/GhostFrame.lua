local _, ns = ...
local B, C, L, DB = unpack(ns)

tinsert(C.XMLThemes, function()
	local bg = B.ReskinFrame(GhostFrame)
	B.ReskinHLTex(GhostFrame, bg, true)

	B.ReskinIcon(GhostFrameContentsFrameIcon)
end)