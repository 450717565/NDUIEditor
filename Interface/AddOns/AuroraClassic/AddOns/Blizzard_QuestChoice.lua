local F, C = unpack(select(2, ...))

C.themes["Blizzard_QuestChoice"] = function()
	F.ReskinFrame(QuestChoiceFrame)

	local numOptions = #QuestChoiceFrame.Options
	for i = 1, numOptions do
		local option = QuestChoiceFrame["Option"..i]
		option.Header.Background:Hide()
		option.Header.Text:SetTextColor(1, .8, 0)

		option.Artwork:SetTexCoord(0.140625, 0.84375, 0.2265625, 0.78125)
		option.Artwork:SetSize(180, 70)
		option.Artwork:ClearAllPoints()
		option.Artwork:SetPoint("TOP", 0, -20)
		F.CreateBDFrame(option.Artwork, 0)

		option.OptionText:SetTextColor(1, 1, 1)
		option.OptionText:ClearAllPoints()
		option.OptionText:SetPoint("TOP", option.Artwork, "BOTTOM", 4, -10)

		local rewards = option.Rewards
		local item = rewards.Item
		item.Name:SetTextColor(1, 1, 1)
		F.ReskinIcon(item.Icon)
		F.ReskinBorder(item.IconBorder, item.Icon)

		local currencies = rewards.Currencies
		for j = 1, 3 do
			local cu = currencies["Currency"..j]
			F.ReskinIcon(cu.Icon)
		end

		F.ReskinButton(option.OptionButtonsContainer.OptionButton1)
		F.ReskinButton(option.OptionButtonsContainer.OptionButton2)
	end
end