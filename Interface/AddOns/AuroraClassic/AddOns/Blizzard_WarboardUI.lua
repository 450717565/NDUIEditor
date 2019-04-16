local F, C = unpack(select(2, ...))

C.themes["Blizzard_WarboardUI"] = function()
	local function reskin(self)
		local frame = WarboardQuestChoiceFrame

		if not self.styled then
			F.ReskinFrame(frame)
			F.StripTextures(frame.Title)

			frame.Title.Text:SetTextColor(1, .8, 0)
		end

		for i = 1, self:GetNumOptions() do
			local Options = self.Options[i]
			Options.OptionText:SetTextColor(1, 1, 1)
			Options.Header.Text:SetTextColor(1, .8, 0)
			Options.SubHeader.Text:SetTextColor(1, .8, 0)

			if not Options.styled then
				Options.Background:Hide()
				Options.Header.Ribbon:Hide()

				F.ReskinButton(Options.OptionButtonsContainer.OptionButton1)
				F.ReskinButton(Options.OptionButtonsContainer.OptionButton2)

				Options.styled = true
			end

			local WidgetContainer = Options.WidgetContainer
			for i = 1, WidgetContainer:GetNumChildren() do
				local Child_1 = select(i, WidgetContainer:GetChildren())
				if Child_1.Text then
					Child_1.Text:SetTextColor(1, .8, 0)
				end

				if Child_1.Spell then
					Child_1.Spell.Text:SetTextColor(1, 1, 1)
				end

				for j = 1, Child_1:GetNumChildren() do
					local Child_2 = select(j, Child_1:GetChildren())
					if Child_2.LeadingText then
						Child_2.LeadingText:SetTextColor(1, .8, 0)
					end

					if Child_2.Text then
						Child_2.Text:SetTextColor(1, 1, 1)
					end
				end
			end
		end
	end

	hooksecurefunc(WarboardQuestChoiceFrame, "Update", reskin)
end