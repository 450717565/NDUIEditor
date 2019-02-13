local F, C = unpack(select(2, ...))

C.themes["Blizzard_WarboardUI"] = function()
	local function reskin(self)
		if not self.styled then
			F.ReskinFrame(WarboardQuestChoiceFrame)
			F.StripTextures(WarboardQuestChoiceFrame.Title)

			WarboardQuestChoiceFrame.Title.Text:SetTextColor(1, .8, 0)
		end

		for i = 1, self:GetNumOptions() do
			local Option = self.Options[i]
			Option.OptionText:SetTextColor(1, 1, 1)
			Option.Header.Text:SetTextColor(1, .8, 0)
			Option.SubHeader.Text:SetTextColor(1, .8, 0)

			if not Option.styled then
				Option.Background:Hide()
				Option.Header.Ribbon:Hide()

				F.ReskinButton(Option.OptionButtonsContainer.OptionButton1)
				F.ReskinButton(Option.OptionButtonsContainer.OptionButton2)

				Option.styled = true
			end

			local WidgetContainer = Option.WidgetContainer
			if WidgetContainer then
				for i = 1, WidgetContainer:GetNumChildren() do
					local Child_1 = select(i, WidgetContainer:GetChildren())
					if Child_1 then
						if Child_1.Text then Child_1.Text:SetTextColor(1, .8, 0) end

						for j = 1, Child_1:GetNumChildren() do
							local Child_2 = select(j, Child_1:GetChildren())
							if Child_2 then
								if Child_2.LeadingText then Child_2.LeadingText:SetTextColor(1, .8, 0) end
								if Child_2.Text then Child_2.Text:SetTextColor(1, 1, 1) end
							end
						end
					end
				end
			end
		end
	end

	hooksecurefunc(WarboardQuestChoiceFrame, "Update", reskin)
end