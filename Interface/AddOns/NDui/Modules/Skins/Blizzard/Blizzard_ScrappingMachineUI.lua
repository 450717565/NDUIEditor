local B, C, L, DB = unpack(select(2, ...))

C.themes["Blizzard_ScrappingMachineUI"] = function()
	B.ReskinFrame(ScrappingMachineFrame)
	B.ReskinButton(ScrappingMachineFrame.ScrapButton)

	local ItemSlots = ScrappingMachineFrame.ItemSlots
	B.StripTextures(ItemSlots)

	local activeObjects = ItemSlots.scrapButtons.activeObjects
	for button in pairs(activeObjects) do
		if not button.styled then
			local icbg = B.ReskinIcon(button.Icon)
			B.ReskinHighlight(button, icbg)
			B.ReskinBorder(button.IconBorder, icbg)

			button.styled = true
		end
	end
end