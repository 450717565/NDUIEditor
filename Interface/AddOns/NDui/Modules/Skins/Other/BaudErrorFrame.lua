local B, C, L, DB = unpack(select(2, ...))
local Skins = B:GetModule("Skins")

local cr, cg, cb = DB.r, DB.g, DB.b

function Skins:BaudErrorFrame()
	if not IsAddOnLoaded("!BaudErrorFrame") then return end

	B.StripTextures(BaudErrorFrame)
	B.CreateBG(BaudErrorFrame)

	B.StripTextures(BaudErrorFrameListScrollBox)
	B.StripTextures(BaudErrorFrameDetailScrollBox)
	B.CreateBDFrame(BaudErrorFrameListScrollBox)
	B.CreateBDFrame(BaudErrorFrameDetailScrollBox)
	B.ReskinScroll(BaudErrorFrameListScrollBoxScrollBarScrollBar)
	B.ReskinScroll(BaudErrorFrameDetailScrollFrameScrollBar)
	B.ReskinHighlight(BaudErrorFrameListScrollBoxHighlightTexture, nil, true, true)

	local buttons = {BaudErrorFrameClearButton, BaudErrorFrameCloseButton, BaudErrorFrameReloadUIButton}
	for _, button in pairs(buttons) do
		B.ReskinButton(button)
		button.Text:SetTextColor(cr, cg, cb)
	end
end