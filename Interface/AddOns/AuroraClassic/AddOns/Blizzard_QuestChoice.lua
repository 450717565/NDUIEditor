local F, C = unpack(select(2, ...))

C.themes["Blizzard_QuestChoice"] = function()
	F.ReskinPortraitFrame(QuestChoiceFrame, true)

	local numOptions = #QuestChoiceFrame.Options
	for i = 1, numOptions do
		local option = QuestChoiceFrame["Option"..i]
		option.Header.Background:Hide()
		option.Header.Text:SetTextColor(.9, .9, .9)

		option.Artwork:SetTexCoord(0.140625, 0.84375, 0.2265625, 0.78125)
		option.Artwork:SetSize(180, 70)
		option.Artwork:SetPoint("TOP", 0, -20)
		F.CreateBDFrame(option.Artwork, .25)

		option.OptionText:SetTextColor(.9, .9, .9)
		option.OptionText:SetPoint("TOP", option.Artwork, "BOTTOM", 4, -10)

		local rewards = option.Rewards
		local item = rewards.Item
		item.Name:SetTextColor(1, 1, 1)
		item.Icon:SetDrawLayer("ARTWORK")
		F.ReskinIcon(item.Icon, true)
		F.ReskinTexture(item.IconBorder, item.Icon, false, true)

		local currencies = rewards.Currencies
		for j = 1, 3 do
			local cu = currencies["Currency"..j]
			F.ReskinIcon(cu.Icon, true)
		end

		F.Reskin(option.OptionButtonsContainer.OptionButton1)
		F.Reskin(option.OptionButtonsContainer.OptionButton2)
	end
end