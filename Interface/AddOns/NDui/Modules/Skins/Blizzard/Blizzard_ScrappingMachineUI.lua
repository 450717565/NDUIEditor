local B, C, L, DB = unpack(select(2, ...))

C.themes["Blizzard_ScrappingMachineUI"] = function()
	B.ReskinFrame(ScrappingMachineFrame)
	B.ReskinButton(ScrappingMachineFrame.ScrapButton)

	local ItemSlots = ScrappingMachineFrame.ItemSlots
	B.StripTextures(ItemSlots)

	for button in pairs(ItemSlots.scrapButtons.activeObjects) do
		if not button.styled then
			local icbg = B.ReskinIcon(button.Icon)
			B.ReskinTexture(button, icbg)
			B.ReskinBorder(button.IconBorder, button.Icon)

			button.styled = true
		end
	end
end