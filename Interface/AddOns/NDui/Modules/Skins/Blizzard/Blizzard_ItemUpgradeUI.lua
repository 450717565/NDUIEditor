local B, C, L, DB = unpack(select(2, ...))

C.themes["Blizzard_ItemUpgradeUI"] = function()
	B.ReskinFrame(ItemUpgradeFrame)

	B.StripTextures(ItemUpgradeFrameMoneyFrame)
	B.StripTextures(ItemUpgradeFrame.ButtonFrame)
	B.ReskinButton(ItemUpgradeFrameUpgradeButton)
	B.ReskinIcon(ItemUpgradeFrameMoneyFrame.Currency.icon)

	local ItemButton = ItemUpgradeFrame.ItemButton
	B.StripTextures(ItemButton)
	local icbg = B.ReskinIcon(ItemButton.IconTexture)
	B.ReskinHighlight(ItemButton, icbg)
	ItemButton.bg = icbg

	hooksecurefunc("ItemUpgradeFrame_Update", function()
		local icon, _, quality = GetItemUpgradeItemInfo()
		local r, g, b = GetItemQualityColor(quality or 1)

		if icon then
			ItemButton.IconTexture:SetTexCoord(unpack(DB.TexCoord))
			ItemButton.bg:SetBackdropBorderColor(r, g, b)
		else
			ItemButton.IconTexture:SetTexture("")
			ItemButton.bg:SetBackdropBorderColor(0, 0, 0)
		end
	end)

	local TextFrame = ItemUpgradeFrame.TextFrame
	B.StripTextures(TextFrame)
	B.CreateBG(TextFrame, icbg, 2, 0, -5, 0)
end