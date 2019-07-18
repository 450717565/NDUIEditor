local F, C = unpack(select(2, ...))

C.themes["ExtVendor"] = function()
	F.ReskinFrame(ExtVendor_SellJunkPopup)
	F.ReskinButton(ExtVendor_SellJunkPopupYesButton)
	F.ReskinButton(ExtVendor_SellJunkPopupNoButton)

	F.ReskinInput(MerchantFrameSearchBox, 22)
	F.ReskinButton(MerchantFrameFilterButton)

	local ic = F.ReskinIcon(MerchantFrameSellJunkButtonIcon)
	F.ReskinTexture(MerchantFrameSellJunkButton, ic)
	MerchantFrameSellJunkButton:SetPushedTexture(C.mediapushed)

	for x = 13, 20 do
		F.ReskinMerchantItem(x)
	end
end