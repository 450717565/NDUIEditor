local F, C = unpack(select(2, ...))

C.themes["Blizzard_ScrappingMachineUI"] = function()
	F.ReskinFrame(ScrappingMachineFrame)
	F.ReskinButton(ScrappingMachineFrame.ScrapButton)

	local function refreshIcon(self)
		if self.itemLocation and not self.item:IsItemEmpty() and self.item:GetItemName() then
			local quality = self.item:GetItemQuality()
			local color = BAG_ITEM_QUALITY_COLORS[quality]

			self.bg:SetBackdropBorderColor(color.r, color.g, color.b)
		else
			self.bg:SetBackdropBorderColor(0, 0, 0)
		end
	end

	local ItemSlots = ScrappingMachineFrame.ItemSlots
	F.StripTextures(ItemSlots)

	for button in pairs(ItemSlots.scrapButtons.activeObjects) do
		if not button.styled then
			button.IconBorder:SetAlpha(0)
			button.bg = F.ReskinIcon(button.Icon, true)
			F.ReskinTexture(button, button.bg, false)

			hooksecurefunc(button, "RefreshIcon", refreshIcon)

			button.styled = true
		end
	end
end