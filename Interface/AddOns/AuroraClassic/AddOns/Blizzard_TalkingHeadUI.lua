local F, C = unpack(select(2, ...))

C.themes["Blizzard_TalkingHeadUI"] = function()
	local MainFrame = TalkingHeadFrame.MainFrame
	F.ReskinClose(MainFrame.CloseButton, "TOPRIGHT", MainFrame, "TOPRIGHT", -20, -20)

	hooksecurefunc("TalkingHeadFrame_PlayCurrent", function()
		local frame = TalkingHeadFrame
		if frame:IsShown() then
			frame.NameFrame.Name:SetTextColor(1, .8, 0)
			frame.TextFrame.Text:SetTextColor(1, 1, 1)
		end
	end)
end