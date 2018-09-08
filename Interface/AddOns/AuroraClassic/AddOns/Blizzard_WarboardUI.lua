local F, C = unpack(select(2, ...))

C.themes["Blizzard_WarboardUI"] = function()
	F.StripTextures(WarboardQuestChoiceFrame, true)
	F.StripTextures(WarboardQuestChoiceFrame.BorderFrame, true)
	F.StripTextures(WarboardQuestChoiceFrame.Title, true)
	WarboardQuestChoiceFrame.Background:Hide()

	F.CreateBD(WarboardQuestChoiceFrame)
	F.CreateSD(WarboardQuestChoiceFrame)
	F.ReskinClose(WarboardQuestChoiceFrame.CloseButton)

	hooksecurefunc(WarboardQuestChoiceFrame, "Update", function(self)
		for i = 1, self:GetNumOptions() do
			local option = self.Options[i]
			option.Background:Hide()
			option.Header.Ribbon:Hide()
			option.OptionText:SetTextColor(1, .8, 0)
			option.Header.Text:SetTextColor(1, 1, 1)
			F.Reskin(option.OptionButtonsContainer.OptionButton1)
		end
	end)
end