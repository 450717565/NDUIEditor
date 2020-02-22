local B, C, L, DB = unpack(select(2, ...))
local S = B:GetModule("Skins")

function S:ExtVendor()
	if not IsAddOnLoaded("ExtVendor") then return end

	B.ReskinFrame(ExtVendor_SellJunkPopup)
	B.ReskinButton(ExtVendor_SellJunkPopupYesButton)
	B.ReskinButton(ExtVendor_SellJunkPopupNoButton)

	B.ReskinInput(MerchantFrameSearchBox, 22)
	B.ReskinButton(MerchantFrameFilterButton)

	local ic = B.ReskinIcon(MerchantFrameSellJunkButtonIcon)
	B.ReskinTexture(MerchantFrameSellJunkButton, ic)
	MerchantFrameSellJunkButton:SetPushedTexture(DB.pushed)

	for i = 13, 20 do
		B.ReskinMerchantItem(i)
	end

	hooksecurefunc("ExtVendor_UpdateMerchantInfo", B.UpdateMerchantInfo)
end