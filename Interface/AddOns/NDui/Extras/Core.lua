local B, C, L, DB = unpack(select(2, ...))

--- 重定义部分函数

BAG_ITEM_QUALITY_COLORS[0] = { r = 0.4, g = 0.4, b = 0.4 }
BAG_ITEM_QUALITY_COLORS[1] = { r = 0.9, g = 0.9, b = 0.9 }
BAG_ITEM_QUALITY_COLORS[LE_ITEM_QUALITY_POOR] = { r = 0.4, g = 0.4, b = 0.4 }
BAG_ITEM_QUALITY_COLORS[LE_ITEM_QUALITY_COMMON] = { r = 0.9, g = 0.9, b = 0.9 }

GOLD_AMOUNT = "%d|c00ffd700金|r"
SILVER_AMOUNT = "%d|c00c7c7cf银|r"
COPPER_AMOUNT = "%d|c00eda55f铜|r"

--- 修复世界地图错位
local old_ResetZoom = _G.WorldMapScrollFrame_ResetZoom

_G.WorldMapScrollFrame_ResetZoom = function()
	if _G.InCombatLockdown() then
		_G.WorldMapFrame_Update()
		_G.WorldMapScrollFrame_ReanchorQuestPOIs()
		_G.WorldMapFrame_ResetPOIHitTranslations()
		_G.WorldMapBlobFrame_DelayedUpdateBlobs()
	else
		old_ResetZoom()
	end
end

--- 特殊物品购买无需确认
--[[
MerchantItemButton_OnClick = function(self, button, ...)
	if MerchantFrame.selectedTab == 1 then
		MerchantFrame.extendedCost = nil
		MerchantFrame.highPrice = nil
		if button == "LeftButton" then
			if MerchantFrame.refundItem then
				if ContainerFrame_GetExtendedPriceString(MerchantFrame.refundItem, MerchantFrame.refundItemEquipped) then
					return
				end
			end
			PickupMerchantItem(self:GetID())
		else
			BuyMerchantItem(self:GetID())
		end
	end
end
]]

--- 自动填写DELETE
hooksecurefunc(StaticPopupDialogs["DELETE_GOOD_ITEM"],"OnShow",function(s) s.editBox:SetText(DELETE_ITEM_CONFIRM_STRING) end)