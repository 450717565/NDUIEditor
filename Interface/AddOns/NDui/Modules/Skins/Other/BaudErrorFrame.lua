local _, ns = ...
local B, C, L, DB = unpack(ns)
local SKIN = B:GetModule("Skins")

local cr, cg, cb = DB.cr, DB.cg, DB.cb

function SKIN:BaudErrorFrame()
	if not IsAddOnLoaded("!BaudErrorFrame") then return end

	B.StripTextures(BaudErrorFrame)
	B.CreateBG(BaudErrorFrame)

	B.StripTextures(BaudErrorFrameListScrollBox)
	B.StripTextures(BaudErrorFrameDetailScrollBox)
	B.CreateBDFrame(BaudErrorFrameListScrollBox)
	B.CreateBDFrame(BaudErrorFrameDetailScrollBox)
	B.ReskinScroll(BaudErrorFrameListScrollBoxScrollBarScrollBar)
	B.ReskinScroll(BaudErrorFrameDetailScrollFrameScrollBar)
	B.ReskinHLTex(BaudErrorFrameListScrollBoxHighlightTexture, nil, true)

	local buttons = {
		BaudErrorFrameClearButton,
		BaudErrorFrameCloseButton,
		BaudErrorFrameReloadUIButton,
	}
	for _, button in pairs(buttons) do
		B.ReskinButton(button)
		B.ReskinText(button.Text, cr, cg, cb)
	end
end

C.OnLoginThemes["BaudErrorFrame"] = SKIN.BaudErrorFrame