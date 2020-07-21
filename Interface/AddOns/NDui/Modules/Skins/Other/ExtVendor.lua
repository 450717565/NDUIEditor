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

	B.ReskinFrame(ExtVendor_QVConfigFrame)
	B.ReskinButton(ExtVendor_QVConfigFrame_OptionContainer_SaveButton)

	local checks = {"EnableButton", "SuboptimalArmor", "AlreadyKnown", "UnusableEquip", "WhiteGear", "OutdatedGear", "OutdatedFood"}
	for _, check in pairs(checks) do
		B.ReskinCheck(_G["ExtVendor_QVConfigFrame_OptionContainer_"..check])
	end

	local buttons = {"RemoveFromBlacklistButton", "ResetBlacklistButton", "RemoveFromGlobalWhitelistButton", "ClearGlobalWhitelistButton", "RemoveFromLocalWhitelistButton", "ClearLocalWhitelistButton", "ItemDropBlacklistButton", "ItemDropGlobalWhitelistButton", "ItemDropLocalWhitelistButton"}
	for _, button in pairs(buttons) do
		B.ReskinButton(_G["ExtVendor_QVConfigFrame_"..button])
	end

	local lists = {"Blacklist", "GlobalWhitelist", "LocalWhitelist"}
	for _, list in pairs(lists) do
		local frame = _G["ExtVendor_QVConfigFrame_"..list]
		local itemList = _G["ExtVendor_QVConfigFrame_"..list.."ItemList"]
		B.StripTextures(frame)
		local bg = B.CreateBDFrame(frame, 0)
		bg:SetOutside(itemList)

		local scrollBar = _G["ExtVendor_QVConfigFrame_"..list.."ItemListScrollBar"]
		B.ReskinScroll(scrollBar)
	end
end