local B, C, L, DB = unpack(select(2, ...))

C.themes["Blizzard_TalkingHeadUI"] = function()
	TalkingHeadFrame:SetScale(UIParent:GetScale())

	local MainFrame = TalkingHeadFrame.MainFrame
	B.ReskinFrame(MainFrame)

	hooksecurefunc("TalkingHeadFrame_PlayCurrent", function()
		B.StripTextures(TalkingHeadFrame.PortraitFrame)
		B.StripTextures(TalkingHeadFrame.BackgroundFrame)
		B.StripTextures(MainFrame.Model)

		TalkingHeadFrame.NameFrame.Name:SetTextColor(1, .8, 0)
		TalkingHeadFrame.TextFrame.Text:SetTextColor(1, 1, 1)

		if not MainFrame.styled then
			B.CreateBDFrame(MainFrame.Model, 0)

			MainFrame.styled = true
		end
	end)
end