local F, C = unpack(select(2, ...))

C.themes["Blizzard_TalkingHeadUI"] = function()
	TalkingHeadFrame:SetScale(UIParent:GetScale())

	local MainFrame = TalkingHeadFrame.MainFrame
	local CloseButton = MainFrame.CloseButton
	F.ReskinClose(CloseButton, "TOPRIGHT", MainFrame, "TOPRIGHT", -25, -25)

	hooksecurefunc("TalkingHeadFrame_PlayCurrent", function()
		local frame = TalkingHeadFrame
		if frame:IsShown() then
			frame.NameFrame.Name:SetTextColor(1, .8, 0)
			frame.TextFrame.Text:SetTextColor(1, 1, 1)
		end
	end)
end