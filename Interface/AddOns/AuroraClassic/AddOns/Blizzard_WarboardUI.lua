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
			if AuroraConfig.reskinFont then
				option.OptionText:SetTextColor(1, .8, 0)
				option.Header.Text:SetTextColor(1, 1, 1)
			end

			if not option.styled then
				for i = 1, option.WidgetContainer:GetNumChildren() do
					local child = select(i, option.WidgetContainer:GetChildren())
					if child.Text and AuroraConfig.reskinFont then
						child.Text:SetTextColor(1, 1, 1)
						child.Text.SetTextColor = F.dummy
					end
				end

				option.Background:Hide()
				option.Header.Ribbon:Hide()
				F.Reskin(option.OptionButtonsContainer.OptionButton1)
				F.Reskin(option.OptionButtonsContainer.OptionButton2)

				option.styled = true
			end
		end
	end)
end