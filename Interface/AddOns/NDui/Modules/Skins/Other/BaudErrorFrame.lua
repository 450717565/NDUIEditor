local B, C, L, DB = unpack(select(2, ...))
local S = B:GetModule("Skins")

function S:BaudErrorFrame()
	if not IsAddOnLoaded("!BaudErrorFrame") then return end

	local cr, cg, cb = DB.r, DB.g, DB.b

	B.CreateBGFrame(BaudErrorFrame)

	B.StripTextures(BaudErrorFrameListScrollBox)
	B.StripTextures(BaudErrorFrameDetailScrollBox)
	B.CreateBDFrame(BaudErrorFrameListScrollBox, 0)
	B.CreateBDFrame(BaudErrorFrameDetailScrollBox, 0)
	B.ReskinScroll(BaudErrorFrameListScrollBoxScrollBarScrollBar)
	B.ReskinScroll(BaudErrorFrameDetailScrollFrameScrollBar)

	local boxHL = BaudErrorFrameListScrollBoxHighlightTexture
	boxHL:SetTexture(DB.bdTex)
	boxHL:SetVertexColor(cr, cg, cb, .25)

	local buttons = {BaudErrorFrameClearButton, BaudErrorFrameCloseButton, BaudErrorFrameReloadUIButton}
	for _, button in pairs(buttons) do
		B.ReskinButton(button)
		button.Text:SetTextColor(cr, cg, cb)
	end
end