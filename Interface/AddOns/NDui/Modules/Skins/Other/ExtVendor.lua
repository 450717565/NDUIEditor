local _, ns = ...
local B, C, L, DB = unpack(ns)
local SKIN = B:GetModule("Skins")

function SKIN:ExtVendor()
	if not IsAddOnLoaded("ExtVendor") then return end
	B.ReskinInput(MerchantFrameSearchBox, 22)
	B.ReskinButton(MerchantFrameFilterButton)

	local icbg = B.ReskinIcon(MerchantFrameSellJunkButtonIcon)
	B.ReskinHLTex(MerchantFrameSellJunkButton, icbg)
	B.ReskinCPTex(MerchantFrameSellJunkButton, icbg)

	for i = 13, 20 do
		local item = _G["MerchantItem"..i]
		B.ReskinMerchantItem(item)

		for j = 1, 3 do
			local texture = _G["MerchantItem"..i.."AltCurrencyFrameItem"..j.."Texture"]
			B.ReskinIcon(texture)
		end
	end

	hooksecurefunc("ExtVendor_UpdateMerchantInfo", B.UpdateMerchantInfo)

	local QVConfigFrame = "ExtVendor_QVConfigFrame"
	B.ReskinFrame(_G[QVConfigFrame])

	local buttons = {
		"_ClearGlobalWhitelistButton",
		"_ClearLocalWhitelistButton",
		"_ItemDropBlacklistButton",
		"_ItemDropGlobalWhitelistButton",
		"_ItemDropLocalWhitelistButton",
		"_RemoveFromBlacklistButton",
		"_RemoveFromGlobalWhitelistButton",
		"_RemoveFromLocalWhitelistButton",
		"_ResetBlacklistButton",
	}
	for _, button in pairs(buttons) do
		B.ReskinButton(_G[QVConfigFrame..button])
	end

	local lists = {
		"_Blacklist",
		"_GlobalWhitelist",
		"_LocalWhitelist",
	}
	for _, list in pairs(lists) do
		local frame = _G[QVConfigFrame..list]
		local itemList = _G[QVConfigFrame..list.."ItemList"]
		B.StripTextures(frame)
		local bg = B.CreateBDFrame(frame)
		bg:SetOutside(itemList, 1+C.mult)

		local scrollBar = _G[QVConfigFrame..list.."ItemListScrollBar"]
		B.ReskinScroll(scrollBar)
	end

	local OptionContainer = "ExtVendor_QVConfigFrame_OptionContainer"
	B.ReskinButton(_G[OptionContainer.."_SaveButton"])

	local checks = {
		"_AlreadyKnown",
		"_EnableButton",
		"_OutdatedFood",
		"_OutdatedGear",
		"_SuboptimalArmor",
		"_UnusableEquip",
		"_WhiteGear",
	}
	for _, check in pairs(checks) do
		B.ReskinCheck(_G[OptionContainer..check])
	end

	local SellJunkPopup = "ExtVendor_SellJunkPopup"
	B.ReskinFrame(_G[SellJunkPopup])
	B.ReskinButton(_G[SellJunkPopup.."YesButton"])
	B.ReskinButton(_G[SellJunkPopup.."NoButton"])
	B.ReskinButton(_G[SellJunkPopup.."DebugButton"])
	B.ReskinScroll(_G[SellJunkPopup.."_JunkListItemListScrollBar"])

	B.StripTextures(_G[SellJunkPopup.."_JunkList"])
	local bg = B.CreateBDFrame(_G[SellJunkPopup.."_JunkList"])
	bg:SetOutside(_G[SellJunkPopup.."_JunkListItemList"])

	local SellJunkProgressPopup = "ExtVendor_SellJunkProgressPopup_Main"
	B.ReskinFrame(_G[SellJunkProgressPopup])
	B.ReskinStatusBar(_G[SellJunkProgressPopup.."ProgressBar"])
	B.ReskinButton(_G[SellJunkProgressPopup.."CancelButton"])
end

C.OnLoginThemes["ExtVendor"] = SKIN.ExtVendor