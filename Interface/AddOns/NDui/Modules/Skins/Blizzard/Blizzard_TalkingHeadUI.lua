local B, C, L, DB = unpack(select(2, ...))

C.themes["Blizzard_TalkingHeadUI"] = function()
	TalkingHeadFrame:SetScale(UIParent:GetScale())

	local MainFrame = TalkingHeadFrame.MainFrame
	local CloseButton = MainFrame.CloseButton
	B.ReskinClose(CloseButton, "TOPRIGHT", MainFrame, "TOPRIGHT", -25, -25)

	hooksecurefunc("TalkingHeadFrame_PlayCurrent", function()
		if TalkingHeadFrame:IsShown() then
			TalkingHeadFrame.NameFrame.Name:SetTextColor(1, .8, 0)
			TalkingHeadFrame.TextFrame.Text:SetTextColor(1, 1, 1)
		end
	end)
end