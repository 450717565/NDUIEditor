local B, C, L, DB = unpack(select(2, ...))
local S = B:GetModule("Skins")

function S:WhisperPop()
	if not IsAddOnLoaded("WhisperPop") then return end

	local cr, cg, cb = DB.r, DB.g, DB.b

	B.ReskinFrame(WhisperPopFrame, "noKill")
	B.ReskinFrame(WhisperPopMessageFrame, "noKill")
	B.ReskinArrow(WhisperPopScrollingMessageFrameButtonDown, "down")
	B.ReskinArrow(WhisperPopScrollingMessageFrameButtonEnd, "bottom")
	B.ReskinArrow(WhisperPopScrollingMessageFrameButtonUp, "up")
	B.ReskinCheck(WhisperPopMessageFrameProtectCheck)
	B.ReskinScroll(WhisperPopFrameListScrollBar)

	local listHL = WhisperPopFrameListHighlightTexture
	listHL:SetTexture(DB.bdTex)
	listHL:SetVertexColor(cr, cg, cb, .25)

	local lists = {WhisperPopFrameListDelete, WhisperPopFrameTopCloseButton, WhisperPopMessageFrameTopCloseButton}
	for _, list in pairs(lists) do
		B.ReskinClose(list)
	end

	local buttons = {"WhisperPopFrameConfig", "WhisperPopNotifyButton"}
	for _, button in pairs(buttons) do
		local bu = _G[button]
		bu:SetNormalTexture("")
		bu:SetPushedTexture("")

		local ic = _G[button.."Icon"]

		local icbg = B.ReskinIcon(ic)
		B.ReskinTexture(bu, icbg)

		if bu.SetCheckedTexture then
			B.ReskinTexed(bu, icbg)
		end
	end
end