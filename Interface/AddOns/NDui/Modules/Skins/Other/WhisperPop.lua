local _, ns = ...
local B, C, L, DB = unpack(ns)
local Skins = B:GetModule("Skins")

function Skins:WhisperPop()
	if not IsAddOnLoaded("WhisperPop") then return end

	B.ReskinFrame(WhisperPopFrame, "none")
	B.ReskinFrame(WhisperPopMessageFrame, "none")
	B.ReskinArrow(WhisperPopScrollingMessageFrameButtonDown, "down")
	B.ReskinArrow(WhisperPopScrollingMessageFrameButtonEnd, "bottom")
	B.ReskinArrow(WhisperPopScrollingMessageFrameButtonUp, "up")
	B.ReskinCheck(WhisperPopMessageFrameProtectCheck)
	B.ReskinScroll(WhisperPopFrameListScrollBar)
	B.ReskinHLTex(WhisperPopFrameListHighlightTexture, nil, true)

	local lists = {
		WhisperPopFrameListDelete,
		WhisperPopFrameTopCloseButton,
		WhisperPopMessageFrameTopCloseButton,
	}
	for _, list in pairs(lists) do
		B.ReskinClose(list)
	end

	local buttons = {
		"WhisperPopFrameConfig",
		"WhisperPopNotifyButton",
	}
	for _, button in pairs(buttons) do
		local bu = _G[button]
		B.CleanTextures(bu)

		local icbg = B.ReskinIcon(_G[button.."Icon"])
		B.ReskinHLTex(bu, icbg)
		B.ReskinCPTex(bu, icbg)
	end
end