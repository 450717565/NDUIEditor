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

--- 共享计量条材质
local media = LibStub("LibSharedMedia-3.0")
media:Register("statusbar", "Altz01", [[Interface\AddOns\NDui\Media\StatusBar\Altz01]])
media:Register("statusbar", "Altz02", [[Interface\AddOns\NDui\Media\StatusBar\Altz02]])
media:Register("statusbar", "Altz03", [[Interface\AddOns\NDui\Media\StatusBar\Altz03]])
media:Register("statusbar", "Altz04", [[Interface\AddOns\NDui\Media\StatusBar\Altz04]])
media:Register("statusbar", "MaoR", [[Interface\AddOns\NDui\Media\StatusBar\MaoR]])
media:Register("statusbar", "normTex", [[Interface\AddOns\NDui\Media\normTex]])
media:Register("statusbar", "Ray01", [[Interface\AddOns\NDui\Media\StatusBar\Ray01]])
media:Register("statusbar", "Ray02", [[Interface\AddOns\NDui\Media\StatusBar\Ray02]])
media:Register("statusbar", "Ray03", [[Interface\AddOns\NDui\Media\StatusBar\Ray03]])
media:Register("statusbar", "Ray04", [[Interface\AddOns\NDui\Media\StatusBar\Ray04]])
media:Register("statusbar", "Ya01", [[Interface\AddOns\NDui\Media\StatusBar\Ya01]])
media:Register("statusbar", "Ya02", [[Interface\AddOns\NDui\Media\StatusBar\Ya02]])
media:Register("statusbar", "Ya03", [[Interface\AddOns\NDui\Media\StatusBar\Ya03]])
media:Register("statusbar", "Ya04", [[Interface\AddOns\NDui\Media\StatusBar\Ya04]])
media:Register("statusbar", "Ya05", [[Interface\AddOns\NDui\Media\StatusBar\Ya05]])

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