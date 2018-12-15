local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	local r, g, b = C.r, C.g, C.b

	F.StripTextures(GhostFrame, true)
	F.CreateBD(GhostFrame)
	F.CreateSD(GhostFrame)
	GhostFrame:SetHighlightTexture(C.media.backdrop)
	GhostFrame:GetHighlightTexture():SetVertexColor(r, g, b, .25)

	GhostFrameContentsFrameIcon:SetTexCoord(.08, .92, .08, .92)
	F.CreateBDFrame(GhostFrameContentsFrameIcon, .25)
end)