local B, C, L, DB = unpack(select(2, ...))
local Skins = B:GetModule("Skins")

function Skins:TransmogWishList()
	if not IsAddOnLoaded("TransmogWishList") then return end

	B.ReskinButton(TransmogWishListButton)
	B.ReskinButton(TransmogWishListFrameBackButton)

	local ListFrame = TransmogWishListFrame
	B.ReskinInput(ListFrame.AddBox)
	B.ReskinArrow(ListFrame.PagingFrame.PrevPageButton, "left")
	B.ReskinArrow(ListFrame.PagingFrame.NextPageButton, "right")

	local ModPicker = TransmogWishListModPicker
	B.ReskinButton(ModPicker.AcceptButton)
	B.ReskinButton(ModPicker.CancelButton)
	local ModList = ModPicker.ModList
	for _, button in pairs(ModList.ModButtons) do
		if not button.styled then
			B.ReskinButton(button)
			B.ReskinHighlight(button.SelectTexture, button)

			button.styled = true
		end
	end
end