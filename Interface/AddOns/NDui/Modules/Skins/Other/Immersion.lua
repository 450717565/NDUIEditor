local B, C, L, DB = unpack(select(2, ...))
local S = B:GetModule("Skins")

function S:Immersion()
	if not IsAddOnLoaded("Immersion") then return end

	local TalkBox = ImmersionFrame.TalkBox.MainFrame
	B.ReskinClose(TalkBox.CloseButton, "TOPRIGHT", TalkBox, "TOPRIGHT", -25, -25)
end