local F, C = unpack(select(2, ...))

C.themes["WhisperPop"] = function()
	local cr, cg, cb = C.r, C.g, C.b

	F.ReskinFrame(WhisperPopFrame, true)
	F.ReskinFrame(WhisperPopMessageFrame, true)
	F.ReskinArrow(WhisperPopScrollingMessageFrameButtonDown, "down")
	F.ReskinArrow(WhisperPopScrollingMessageFrameButtonEnd, "bottom")
	F.ReskinArrow(WhisperPopScrollingMessageFrameButtonUp, "up")
	F.ReskinCheck(WhisperPopMessageFrameProtectCheck)
	F.ReskinScroll(WhisperPopFrameListScrollBar)

	local listHL = WhisperPopFrameListHighlightTexture
	listHL:SetTexture(C.media.bdTex)
	listHL:SetVertexColor(cr, cg, cb, .25)

	local lists = {WhisperPopFrameListDelete, WhisperPopFrameTopCloseButton, WhisperPopMessageFrameTopCloseButton}
	for _, list in pairs(lists) do
		F.ReskinClose(list)
	end

	local buttons = {"WhisperPopFrameConfig", "WhisperPopNotifyButton"}
	for _, button in pairs(buttons) do
		local bu = _G[button]
		bu:SetNormalTexture("")
		bu:SetPushedTexture("")

		local ic = _G[button.."Icon"]

		local bg = F.ReskinIcon(ic)
		F.ReskinTexture(bu, bg, false)

		if bu.SetCheckedTexture then
			bu:SetCheckedTexture(C.media.checked)
		end
	end
end