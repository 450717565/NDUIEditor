local F, C = unpack(select(2, ...))

C.themes["Blizzard_ItemUpgradeUI"] = function()
	F.ReskinFrame(ItemUpgradeFrame)

	F.StripTextures(ItemUpgradeFrameMoneyFrame)
	F.StripTextures(ItemUpgradeFrame.ButtonFrame)
	F.ReskinButton(ItemUpgradeFrameUpgradeButton)
	F.ReskinIcon(ItemUpgradeFrameMoneyFrame.Currency.icon)

	local ItemButton = ItemUpgradeFrame.ItemButton
	F.StripTextures(ItemButton)
	local icbg = F.ReskinIcon(ItemButton.IconTexture)
	F.ReskinTexture(ItemButton, icbg)
	ItemButton.bg = icbg

	hooksecurefunc("ItemUpgradeFrame_Update", function()
		local icon, _, quality = GetItemUpgradeItemInfo()
		local color = BAG_ITEM_QUALITY_COLORS[quality or 1]

		if icon then
			ItemButton.IconTexture:SetTexCoord(.08, .92, .08, .92)
			ItemButton.bg:SetBackdropBorderColor(color.r, color.g, color.b)
		else
			ItemButton.IconTexture:SetTexture("")
			ItemButton.bg:SetBackdropBorderColor(0, 0, 0)
		end
	end)

	local TextFrame = ItemUpgradeFrame.TextFrame
	F.StripTextures(TextFrame)
	local bubg = F.CreateBDFrame(TextFrame, 0)
	bubg:SetPoint("TOPLEFT", icbg, "TOPRIGHT", 2, 0)
	bubg:SetPoint("BOTTOMRIGHT", -5, 2.5)
end