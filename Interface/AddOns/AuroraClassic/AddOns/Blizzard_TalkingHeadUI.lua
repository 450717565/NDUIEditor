local F, C = unpack(select(2, ...))

C.themes["Blizzard_TalkingHeadUI"] = function()
	local CloseButton = TalkingHeadFrame.MainFrame.CloseButton
	F.ReskinClose(CloseButton)
	CloseButton:ClearAllPoints()
	CloseButton:SetPoint("TOPRIGHT", -20, -20)
end