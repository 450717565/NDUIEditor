local B, C, L, DB = unpack(select(2, ...))
local Skins = B:GetModule("Skins")

function Skins:WhisperPop()
	if not IsAddOnLoaded("WhisperPop") then return end

	local cr, cg, cb = DB.r, DB.g, DB.b

	B.ReskinFrame(WhisperPopFrame, "none")
	B.ReskinFrame(WhisperPopMessageFrame, "none")
	B.ReskinArrow(WhisperPopScrollingMessageFrameButtonDown, "down")
	B.ReskinArrow(WhisperPopScrollingMessageFrameButtonEnd, "bottom")
	B.ReskinArrow(WhisperPopScrollingMessageFrameButtonUp, "up")
	B.ReskinCheck(WhisperPopMessageFrameProtectCheck)
	B.ReskinScroll(WhisperPopFrameListScrollBar)

	local listHL = WhisperPopFrameListHighlightTexture
	listHL:SetTexture(DB.backgroundTex)
	listHL:SetVertexColor(cr, cg, cb, .25)

	local lists = {WhisperPopFrameListDelete, WhisperPopFrameTopCloseButton, WhisperPopMessageFrameTopCloseButton}
	for _, list in pairs(lists) do
		B.ReskinClose(list)
	end

	local buttons = {"WhisperPopFrameConfig", "WhisperPopNotifyButton"}
	for _, button in pairs(buttons) do
		local bu = _G[button]
		B.CleanTextures(bu)

		local ic = _G[button.."Icon"]

		local icbg = B.ReskinIcon(ic)
		B.ReskinHighlight(bu, icbg)

		if bu.SetCheckedTexture then
			B.ReskinChecked(bu, icbg)
		end
	end
end