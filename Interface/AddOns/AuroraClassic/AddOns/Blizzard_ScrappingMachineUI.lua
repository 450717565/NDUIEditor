local F, C = unpack(select(2, ...))

C.themes["Blizzard_ScrappingMachineUI"] = function()
	F.ReskinFrame(ScrappingMachineFrame)
	F.ReskinButton(ScrappingMachineFrame.ScrapButton)

	local ItemSlots = ScrappingMachineFrame.ItemSlots
	F.StripTextures(ItemSlots)

	for button in pairs(ItemSlots.scrapButtons.activeObjects) do
		if not button.styled then
			local icbg = F.ReskinIcon(button.Icon)
			F.ReskinTexture(button, icbg, false)
			F.ReskinBorder(button.IconBorder, button.Icon)

			button.styled = true
		end
	end
end