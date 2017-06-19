
-------------------------------------
-- 物品等級顯示 Author: M
-------------------------------------

local LibEvent = LibStub:GetLibrary("LibEvent.7000")
local LibSchedule = LibStub:GetLibrary("LibSchedule.7000")
local LibItemInfo = LibStub:GetLibrary("LibItemInfo.7000")

local ARMOR = ARMOR or "Armor"
local RELICSLOT = RELICSLOT or "Relic"
local ARTIFACT_POWER = ARTIFACT_POWER or "Artifact"

local EnableItemLevel = true
local ShowColoredItemLevelString = false
local ShowItemSlotString = true
local EnableItemLevelGuildNews = true

--框架 #category Bag|Bank|Merchant|Trade|GuildBank|Auction|AltEquipment|PaperDoll
local function GetItemLevelFrame(self, category)
	if (not self.ItemLevelFrame) then
		local fontAdjust = GetLocale():sub(1,2) == "zh" and 0 or -3
		self.ItemLevelFrame = CreateFrame("Frame", nil, self)
		self.ItemLevelFrame:SetFrameLevel(8)
		self.ItemLevelFrame:SetSize(self:GetSize())
		self.ItemLevelFrame:SetPoint("CENTER")
		self.ItemLevelFrame.levelString = self.ItemLevelFrame:CreateFontString(nil, "OVERLAY")
		self.ItemLevelFrame.levelString:SetFont(STANDARD_TEXT_FONT, 14+fontAdjust, "OUTLINE")
		self.ItemLevelFrame.levelString:SetPoint("TOP", 0, -1)
		self.ItemLevelFrame.slotString = self.ItemLevelFrame:CreateFontString(nil, "OVERLAY")
		self.ItemLevelFrame.slotString:SetFont(STANDARD_TEXT_FONT, 10+fontAdjust, "OUTLINE")
		self.ItemLevelFrame.slotString:SetPoint("BOTTOMRIGHT", 0, 2)
		self.ItemLevelFrame.slotString:SetJustifyH("RIGHT")
		self.ItemLevelFrame.slotString:SetWidth(34)
		self.ItemLevelFrame.slotString:SetHeight(0)
		LibEvent:trigger("ITEMLEVEL_FRAME_CREATED", self.ItemLevelFrame, self)
	end
	if EnableItemLevel then
		self.ItemLevelFrame:Show()
		LibEvent:trigger("ITEMLEVEL_FRAME_SHOWN", self.ItemLevelFrame, self, category)
	else
		self.ItemLevelFrame:Hide()
	end
	return self.ItemLevelFrame
end

--設置裝等文字
local function SetItemLevelString(self, text, quality)
	if (quality and ShowColoredItemLevelString) then
		local r, g, b, hex = GetItemQualityColor(quality)
		text = format("|c%s%s|r", hex, text)
	end
	self:SetText(text)
end

--設置部位文字
local function SetItemSlotString(self, class, equipSlot, link)
	local slotText = ""
	if ShowItemSlotString then
		if (equipSlot and string.find(equipSlot, "INVTYPE_")) then
			slotText = _G[equipSlot] or ""
		elseif (class == ARMOR) then
			slotText = class
		elseif (link and IsArtifactPowerItem(link)) then
			slotText = ARTIFACT_POWER
		elseif (link and IsArtifactRelicItem(link)) then
			slotText = RELICSLOT
		end
	end
	self:SetText(slotText)
end

--設置物品等級
local function SetItemLevel(self, link, category)
	if (not self) then return end
	local frame = GetItemLevelFrame(self, category)
	if (self.OrigItemLink == link) then
		SetItemLevelString(frame.levelString, self.OrigItemLevel, self.OrigItemQuality)
		SetItemSlotString(frame.slotString, self.OrigItemClass, self.OrigItemEquipSlot, self.OrigItemLink)
	else
		local _, count, level, quality, class, equipSlot
		if (link) then
			count, level, _, _, quality, _, _, class, _, _, equipSlot = LibItemInfo:GetItemInfo(link)
			SetItemLevelString(frame.levelString, level > 0 and level or "", quality)
			SetItemSlotString(frame.slotString, class, equipSlot, link)
		else
			SetItemLevelString(frame.levelString, "")
			SetItemSlotString(frame.slotString)
		end
		self.OrigItemLink = link
		self.OrigItemLevel = (level and level > 0) and level or ""
		self.OrigItemQuality = quality
		self.OrigItemClass = class
		self.OrigItemEquipSlot = equipSlot
	end
end

-- Merchant
hooksecurefunc("MerchantFrameItem_UpdateQuality", function(self, link)
	SetItemLevel(self.ItemButton, link, "Merchant")
end)

-- Trade
hooksecurefunc("TradeFrame_UpdatePlayerItem", function(id)
	SetItemLevel(_G["TradePlayerItem"..id.."ItemButton"], GetTradePlayerItemLink(id), "Trade")
end)
hooksecurefunc("TradeFrame_UpdateTargetItem", function(id)
	SetItemLevel(_G["TradeRecipientItem"..id.."ItemButton"], GetTradeTargetItemLink(id), "Trade")
end)

-- GuildBank
LibEvent:attachEvent("ADDON_LOADED", function(self, addonName)
	if (addonName == "Blizzard_GuildBankUI") then
		hooksecurefunc("GuildBankFrame_Update", function()
			if (GuildBankFrame.mode == "bank") then
				local tab = GetCurrentGuildBankTab()
				local button, index, column
				for i = 1, MAX_GUILDBANK_SLOTS_PER_TAB do
					index = mod(i, NUM_SLOTS_PER_GUILDBANK_GROUP)
					if (index == 0) then
						index = NUM_SLOTS_PER_GUILDBANK_GROUP
					end
					column = ceil((i-0.5)/NUM_SLOTS_PER_GUILDBANK_GROUP)
					button = _G["GuildBankColumn"..column.."Button"..index]
					SetItemLevel(button, GetGuildBankItemLink(tab, i), "GuildBank")
				end
			end
		end)
	end
end)

-- Auction
LibEvent:attachEvent("ADDON_LOADED", function(self, addonName)
	if (addonName == "Blizzard_AuctionUI") then
		hooksecurefunc("AuctionFrameBrowse_Update", function()
			local offset = FauxScrollFrame_GetOffset(BrowseScrollFrame)
			local itemButton
			for i = 1, NUM_BROWSE_TO_DISPLAY do
				itemButton = _G["BrowseButton"..i.."Item"]
				if (itemButton) then
					SetItemLevel(itemButton, GetAuctionItemLink("list", offset+i), "Auction")
				end
			end
		end)
		hooksecurefunc("AuctionFrameBid_Update", function()
			local offset = FauxScrollFrame_GetOffset(BidScrollFrame)
			local itemButton
			for i = 1, NUM_BIDS_TO_DISPLAY do
				itemButton = _G["BidButton"..i.."Item"]
				if (itemButton) then
					SetItemLevel(itemButton, GetAuctionItemLink("bidder", offset+i), "Auction")
				end
			end
		end)
		hooksecurefunc("AuctionFrameAuctions_Update", function()
			local offset = FauxScrollFrame_GetOffset(AuctionsScrollFrame)
			local tokenCount = C_WowTokenPublic.GetNumListedAuctionableTokens()
			local itemButton
			for i = 1, NUM_AUCTIONS_TO_DISPLAY do
				itemButton = _G["AuctionsButton"..i.."Item"]
				if (itemButton) then
					SetItemLevel(itemButton, GetAuctionItemLink("owner", offset-tokenCount+i), "Auction")
				end
			end
		end)
	end
end)

-- ALT
if (EquipmentFlyout_DisplayButton) then
	hooksecurefunc("EquipmentFlyout_DisplayButton", function(button, paperDollItemSlot)
		local location = button.location
		if (not location) then return end
		local player, bank, bags, voidStorage, slot, bag, tab, voidSlot = EquipmentManager_UnpackLocation(location)
		if (not player and not bank and not bags and not voidStorage) then return end
		if (voidStorage) then return end
		local link
		if (bags) then
			link = GetContainerItemLink(bag, slot)
		else
			link = GetInventoryItemLink("player", slot)
		end
		SetItemLevel(button, link, "AltEquipment")
	end)
end

-- ForAddons: Bagnon Combuctor LiteBag ArkInventory
LibEvent:attachEvent("PLAYER_LOGIN", function()
	-- For Bagnon
	if (Bagnon and Bagnon.ItemSlot) then
		local origFunc = Bagnon.ItemSlot.Update
		function Bagnon.ItemSlot:Update()
			origFunc(self)
			SetItemLevel(self, self:GetItem(), "Bag")
		end
	end
	-- For Combuctor
	if (Combuctor and Combuctor.ItemSlot) then
		local origFunc = Combuctor.ItemSlot.Update
		function Combuctor.ItemSlot:Update()
			origFunc(self)
			SetItemLevel(self, self:GetItem(), "Bag")
		end
	end
	-- For LiteBag
	if (LiteBagItemButton_UpdateItem) then
		hooksecurefunc("LiteBagItemButton_UpdateItem", function(self)
			SetItemLevel(self, GetContainerItemLink(self:GetParent():GetID(), self:GetID()), "Bag")
		end)
	end
	-- For ArkInventory
	if (ArkInventory and ArkInventory.Frame_Item_Update_Texture) then
		local origFunc = ArkInventory.Frame_Item_Update_Texture
		function ArkInventory.Frame_Item_Update_Texture(button)
			origFunc(button)
			local i = ArkInventory.Frame_Item_GetDB(button)
			if (i) then
				SetItemLevel(button, i.h, "Bag")
			end
		end
	end
end)

-- GuildNews
LibEvent:attachEvent("ADDON_LOADED", function(self, addonName)
	if (addonName == "Blizzard_GuildUI") then
		GuildNewsItemCache = {}
		hooksecurefunc("GuildNewsButton_SetText", function(button, text_color, text, text1, text2, ...)
			if (not EnableItemLevel) or (not EnableItemLevelGuildNews) then
			  return
			end
			if (text2 and type(text2) == "string") then
				local link = string.match(text2, "|H(item:%d+:.-)|h.-|h")
				if (link) then
					local level = GuildNewsItemCache[link] or select(2, LibItemInfo:GetItemInfo(link))
					if (level > 0) then
						GuildNewsItemCache[link] = level
						text2 = text2:gsub("(%|Hitem:%d+:.-%|h%[)(.-)(%]%|h)", "%1"..level..":%2%3")
						button.text:SetFormattedText(text, text1, text2, ...)
					end
				end
			end
		end)
	end
end)