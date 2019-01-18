local F, C = unpack(select(2, ...))

C.themes["Blizzard_WarboardUI"] = function()
	local function reskin(self)
		if not self.styled then
			F.ReskinFrame(WarboardQuestChoiceFrame)
			F.StripTextures(WarboardQuestChoiceFrame.Title, true)
		end

		for i = 1, self:GetNumOptions() do
			local option = self.Options[i]
			if AuroraConfig.reskinFont then
				option.OptionText:SetTextColor(1, 1, 1)
				option.Header.Text:SetTextColor(1, .8, 0)
			end

			if not option.styled then
				option.Background:Hide()
				option.Header.Ribbon:Hide()
				F.ReskinButton(option.OptionButtonsContainer.OptionButton1)
				F.ReskinButton(option.OptionButtonsContainer.OptionButton2)

				option.styled = true
			end
		end
	end

	hooksecurefunc(WarboardQuestChoiceFrame, "Update", reskin)
end