local F, C = unpack(select(2, ...))

C.themes["Blizzard_TalkingHeadUI"] = function()
	local main = TalkingHeadFrame.MainFrame
	F.ReskinClose(main.CloseButton, "TOPRIGHT", main, "TOPRIGHT", -20, -20)

	hooksecurefunc("TalkingHeadFrame_PlayCurrent", function()
		local frame = TalkingHeadFrame
		if frame:IsShown() then
			frame.NameFrame.Name:SetTextColor(1, .8, 0)
			frame.NameFrame.Name:SetShadowColor(0, 0, 0, 0)
			frame.TextFrame.Text:SetTextColor(1, 1, 1)
			frame.TextFrame.Text:SetShadowColor(0, 0, 0, 0)
		end
	end)
end