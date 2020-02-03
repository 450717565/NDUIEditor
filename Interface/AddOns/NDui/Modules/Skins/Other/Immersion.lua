local B, C, L, DB = unpack(select(2, ...))
local S = B:GetModule("Skins")

function S:Immersion()
	if not NDuiDB["Skins"]["BlizzardSkins"] then return end
	if not IsAddOnLoaded("Immersion") then return end

	local talkbox = ImmersionFrame.TalkBox.MainFrame
	B.ReskinClose(talkbox.CloseButton, "TOPRIGHT", talkbox, "TOPRIGHT", -20, -20)
end