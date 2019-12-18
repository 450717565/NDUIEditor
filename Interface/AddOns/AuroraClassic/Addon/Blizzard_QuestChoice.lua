local F, C = unpack(select(2, ...))

C.themes["Blizzard_QuestChoice"] = function()
	F.ReskinFrame(QuestChoiceFrame)

	local Options = #QuestChoiceFrame.Options
	for i = 1, Options do
		local Option = QuestChoiceFrame["Option"..i]
		Option.Header.Background:Hide()
		Option.Header.Text:SetTextColor(1, .8, 0)

		Option.Artwork:SetTexCoord(0.140625, 0.84375, 0.2265625, 0.78125)
		Option.Artwork:SetSize(180, 70)
		Option.Artwork:ClearAllPoints()
		Option.Artwork:SetPoint("TOP", 0, -20)
		F.CreateBDFrame(Option.Artwork, 0)

		Option.OptionText:SetTextColor(1, 1, 1)
		Option.OptionText:ClearAllPoints()
		Option.OptionText:SetPoint("TOP", Option.Artwork, "BOTTOM", 4, -10)

		local Rewards = Option.Rewards
		local Item = Rewards.Item
		Item.Name:SetTextColor(1, 1, 1)
		F.ReskinIcon(Item.Icon)
		F.ReskinBorder(Item.IconBorder, Item.Icon)

		local Currencies = Rewards.Currencies
		for j = 1, 3 do
			local cu = Currencies["Currency"..j]
			F.ReskinIcon(cu.Icon)
		end

		F.ReskinButton(Option.OptionButtonsContainer.OptionButton1)
		F.ReskinButton(Option.OptionButtonsContainer.OptionButton2)
	end
end