if not IsAddOnLoaded("Aurora") then return end

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:SetScript("OnEvent", function()
	f:UnregisterEvent("PLAYER_ENTERING_WORLD")
	local F = unpack(Aurora)
	F.CreateBD(WhisperPopFrame)
	F.CreateSD(WhisperPopFrame)
	F.CreateBD(WhisperPopMessageFrame)
	F.CreateSD(WhisperPopMessageFrame)

	F.ReskinCheck(WhisperPopMessageFrameProtectCheck)
	F.ReskinClose(WhisperPopFrameListDelete)
	F.ReskinClose(WhisperPopFrameTopCloseButton)
	F.ReskinClose(WhisperPopMessageFrameTopCloseButton)
	F.ReskinArrow(WhisperPopScrollingMessageFrameButtonUp, "up")
	F.ReskinArrow(WhisperPopScrollingMessageFrameButtonDown, "down")
	F.ReskinArrow(WhisperPopScrollingMessageFrameButtonEnd, "down")
	F.ReskinScroll(WhisperPopFrameListScrollBar)

	local wpbtn = {"WhisperPopNotifyButton", "WhisperPopFrameConfig"}
	for k, v in pairs(wpbtn) do
		F.ReskinIconStyle(_G[v])
	end

end)