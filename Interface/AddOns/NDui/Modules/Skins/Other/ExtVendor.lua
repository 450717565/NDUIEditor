local B, C, L, DB = unpack(select(2, ...))
local S = B:GetModule("Skins")

function S:ExtVendor()
	if not IsAddOnLoaded("ExtVendor") then return end

	B.ReskinFrame(ExtVendor_SellJunkPopup)
	B.ReskinButton(ExtVendor_SellJunkPopupYesButton)
	B.ReskinButton(ExtVendor_SellJunkPopupNoButton)

	B.ReskinInput(MerchantFrameSearchBox, 22)
	B.ReskinButton(MerchantFrameFilterButton)

	local icbg = B.ReskinIcon(MerchantFrameSellJunkButtonIcon)
	B.ReskinHighlight(MerchantFrameSellJunkButton, icbg)
	B.ReskinPushed(MerchantFrameSellJunkButton, icbg)

	for i = 13, 20 do
		local item = _G["MerchantItem"..i]
		B.ReskinMerchantItem(item)

		for j = 1, 3 do
			local texture = _G["MerchantItem"..i.."AltCurrencyFrameItem"..j.."Texture"]
			B.ReskinIcon(texture)
		end
	end

	hooksecurefunc("ExtVendor_UpdateMerchantInfo", B.UpdateMerchantInfo)
end