
-------------------------------------
-- 物品等級顯示 Author: M
-------------------------------------
local B, C, L, DB = unpack(NDui)

local LibEvent = LibStub:GetLibrary("LibEvent.7000")
local LibItemGem = LibStub:GetLibrary("LibItemGem.7000")
local LibSchedule = LibStub:GetLibrary("LibSchedule.7000")
local LibItemInfo = LibStub:GetLibrary("LibItemInfo.7000")

local ARMOR = ARMOR or "Armor"
local RELICSLOT = RELICSLOT or "Relic"
local ARTIFACT_POWER = ARTIFACT_POWER or "Artifact"

local EnableItemLevel = true
local EnableItemLevelOther = true
local ShowColoredItemLevelString = false
local ShowItemSlotString = true
local EnableItemLevelGuildNews = true
local PaperDollItemLevelOutsideString = true

--框架 #category Bag|Bank|Merchant|Trade|GuildBank|Auction|AltEquipment|PaperDoll|Loot
local function GetItemLevelFrame(self, category)
	if (not self.ItemLevelFrame) then
		local fontAdjust = GetLocale():sub(1,2) == "zh" and 0 or -3
		local anchor, w, h = self.IconBorder or self, self:GetSize()
		local ww, hh = anchor:GetSize()
		if (ww == 0 or hh == 0) then
			anchor = self.Icon or self.icon or self
			w, h = anchor:GetSize()
		else
			w, h = min(w, ww), min(h, hh)
		end
		self.ItemLevelFrame = CreateFrame("Frame", nil, self)
		self.ItemLevelFrame:SetScale(max(0.75, h<32 and h/32 or 1))
		self.ItemLevelFrame:SetToplevel(true)
		self.ItemLevelFrame:SetSize(w, h)
		self.ItemLevelFrame:SetPoint("CENTER", anchor, "CENTER", 0, 0)
		self.ItemLevelFrame.slotString = B.CreateFS(self.ItemLevelFrame, 10+fontAdjust, "", false, "BOTTOMRIGHT", 0, 2)
		self.ItemLevelFrame.slotString:SetJustifyH("RIGHT")
		self.ItemLevelFrame.levelString = B.CreateFS(self.ItemLevelFrame, 14+fontAdjust, "", false, "TOPLEFT", 1, -1)
		self.ItemLevelFrame.levelString:SetJustifyH("LEFT")
		LibEvent:trigger("ITEMLEVEL_FRAME_CREATED", self.ItemLevelFrame, self)
	end
	if EnableItemLevel then
		self.ItemLevelFrame:Show()
		LibEvent:trigger("ITEMLEVEL_FRAME_SHOWN", self.ItemLevelFrame, self, category or "")
	else
		self.ItemLevelFrame:Hide()
	end
	if (category) then
		self.ItemLevelCategory = category
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
local function SetItemSlotString(self, class, subclass, equipSlot, link)
	local itemSolt = ""
	if ShowItemSlotString then
		if equipSlot and equipSlot ~= "" then
			itemSolt = _G[equipSlot] or ""

			if equipSlot == "INVTYPE_FEET" then
				itemSolt = L["Feet"]
			elseif equipSlot == "INVTYPE_HAND" then
				itemSolt = L["Hands"]
			elseif equipSlot == "INVTYPE_HOLDABLE" then
				itemSolt = SECONDARYHANDSLOT
			elseif equipSlot == "INVTYPE_SHIELD" then
				itemSolt = SHIELDSLOT
			end
		end

		if subclass and subclass ~= "" then
			if subclass == MOUNTS then
				itemSolt = MOUNTS
			elseif subclass == PETS..COMPANIONS then
				itemSolt = PETS
			end
		end

		if link then
			if IsArtifactPowerItem(link) then
				itemSolt = ARTIFACT_POWER
			elseif IsArtifactRelicItem(link) then
				itemSolt = RELICSLOT
			end
		end
	end
	self:SetText(itemSolt)
end

--部分裝備無法一次讀取
local function SetItemLevelScheduled(button, ItemLevelFrame, link)
	if (not string.match(link, "item:(%d+):")) then return end
	LibSchedule:AddTask({
		identity  = link,
		elasped   = 1,
		expired   = GetTime() + 3,
		frame     = ItemLevelFrame,
		button    = button,
		onExecute = function(self)
			local count, level, _, _, quality, _, _, class, subclass, _, equipSlot = LibItemInfo:GetItemInfo(self.identity)
			if (count == 0) then
				SetItemLevelString(self.frame.levelString, level > 0 and level or "", quality)
				SetItemSlotString(self.frame.slotString, class, subclass, equipSlot, link)
				self.button.OrigItemLevel = (level and level > 0) and level or ""
				self.button.OrigItemQuality = quality
				self.button.OrigItemClass = class
				self.button.OrigItemSubClass = subclass
				self.button.OrigItemEquipSlot = equipSlot
				return true
			end
		end,
	})
end

--設置物品等級
local function SetItemLevel(self, link, category, BagID, SlotID)
	if (not self) then return end
	local frame = GetItemLevelFrame(self, category)
	if (self.OrigItemLink == link) then
		SetItemLevelString(frame.levelString, self.OrigItemLevel, self.OrigItemQuality)
		SetItemSlotString(frame.slotString, self.OrigItemClass, self.OrigItemSubClass, self.OrigItemEquipSlot, self.OrigItemLink)
	else
		local level = ""
		local _, count, quality, class, subclass, equipSlot
		if (link and string.match(link, "item:(%d+):")) then
			if (BagID and SlotID and (category == "Bag" or category == "AltEquipment")) then
				count, level = LibItemInfo:GetContainerItemLevel(BagID, SlotID)
				_, _, quality, _, _, class, subclass, _, equipSlot = GetItemInfo(link)
			else
				count, level, _, _, quality, _, _, class, subclass, _, equipSlot = LibItemInfo:GetItemInfo(link)
			end
			--除了装备和圣物外,其它不显示装等
			if ((equipSlot and string.find(equipSlot, "INVTYPE_"))
				or (subclass and string.find(subclass, RELICSLOT))) then else
				level = ""
			end
			if (count > 0) then
				SetItemLevelString(frame.levelString, "...")
				return SetItemLevelScheduled(self, frame, link)
			else
				if (tonumber(level) == 0) then level = "" end
				SetItemLevelString(frame.levelString, level, quality)
				SetItemSlotString(frame.slotString, class, subclass, equipSlot, link)
			end
		else
			SetItemLevelString(frame.levelString, "")
			SetItemSlotString(frame.slotString)
		end
		self.OrigItemLink = link
		self.OrigItemLevel = level
		self.OrigItemQuality = quality
		self.OrigItemClass = class
		self.OrigItemSubClass = subclass
		self.OrigItemEquipSlot = equipSlot
	end
end

--[[ All ]]
hooksecurefunc("SetItemButtonQuality", function(self, quality, itemIDOrLink)
	if (self.ItemLevelCategory or self.isBag) then return end
	local frame = GetItemLevelFrame(self)
	if (not EnableItemLevelOther) then
		return frame:Hide()
	end
	if (itemIDOrLink) then
		local link
		--Artifact
		if (IsArtifactRelicItem(itemIDOrLink)) then
			SetItemLevel(self)
		--QuestInfo
		elseif (self.type and self.objectType == "item") then
			if (QuestInfoFrame and QuestInfoFrame.questLog) then
				link = GetQuestLogItemLink(self.type, self:GetID())
			else
				link = GetQuestItemLink(self.type, self:GetID())
			end
			if (not link) then
				link = select(2, GetItemInfo(itemIDOrLink))
			end
			SetItemLevel(self, link)
		--EncounterJournal
		elseif (self.encounterID and self.link) then
			link = select(7, EJ_GetLootInfoByIndex(self.index))
			SetItemLevel(self, link or self.link)
		--EmbeddedItemTooltip
		elseif (self.Tooltip) then
			link = select(2, self.Tooltip:GetItem())
			SetItemLevel(self, link)
		end
	else
		SetItemLevelString(frame.levelString, "")
		SetItemSlotString(frame.slotString)
	end
end)

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

-- Loot
hooksecurefunc("LootFrame_UpdateButton", function(index)
	local button = _G["LootButton"..index]
	local numLootItems = LootFrame.numLootItems
	local numLootToShow = LOOTFRAME_NUMBUTTONS
	if (numLootItems > LOOTFRAME_NUMBUTTONS) then
		numLootToShow = numLootToShow - 1
	end
	local slot = (numLootToShow * (LootFrame.page - 1)) + index
	if (button:IsShown()) then
		SetItemLevel(button, GetLootSlotLink(slot), "Loot")
	end
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
--[[
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
]]

-- ForAddons: Bagnon Combuctor LiteBag ArkInventory
LibEvent:attachEvent("PLAYER_LOGIN", function()
	-- For Bagnon
	if (Bagnon and Bagnon.ItemSlot and Bagnon.ItemSlot.Update) then
		hooksecurefunc(Bagnon.ItemSlot, "Update", function(self)
			SetItemLevel(self, self:GetItem(), "Bag", self:GetBag(), self:GetID())
		end)
	end
	-- For Combuctor
	if (Combuctor and Combuctor.ItemSlot and Combuctor.ItemSlot.Update) then
		hooksecurefunc(Combuctor.ItemSlot, "Update", function(self)
			SetItemLevel(self, self:GetItem(), "Bag", self:GetBag(), self:GetID())
		end)
	elseif (Combuctor and Combuctor.Item and Combuctor.Item.Update) then
		hooksecurefunc(Combuctor.Item, "Update", function(self)
			SetItemLevel(self, self.hasItem, "Bag", self.bag, self.GetID and self:GetID())
		end)
	end
	-- For LiteBag
	if (LiteBagItemButton_UpdateItem) then
		hooksecurefunc("LiteBagItemButton_UpdateItem", function(self)
			SetItemLevel(self, GetContainerItemLink(self:GetParent():GetID(), self:GetID()), "Bag", self:GetParent():GetID(), self:GetID())
		end)
	end
	-- For ArkInventory
	if (ArkInventory and ArkInventory.Frame_Item_Update_Texture) then
		hooksecurefunc(ArkInventory, "Frame_Item_Update_Texture", function(button)
			local i = ArkInventory.Frame_Item_GetDB(button)
			if (i) then
				SetItemLevel(button, i.h, "Bag")
			end
		end)
	end
end)

--For Addon: BaudBag
if (BaudBag and BaudBag.CreateItemButton) then
	local BaudBagCreateItemButton = BaudBag.CreateItemButton
	BaudBag.CreateItemButton = function(self, subContainer, slotIndex, buttonTemplate)
		local ItemButton = BaudBagCreateItemButton(self, subContainer, slotIndex, buttonTemplate)
		local Prototype = getmetatable(ItemButton).__index
		local UpdateContent = Prototype.UpdateContent
		Prototype.UpdateContent = function(self, useCache, slotCache)
			local link, cacheEntry = UpdateContent(self, useCache, slotCache)
			SetItemLevel(self.Frame, link)
			return link, cacheEntry
		end
		setmetatable(ItemButton, {__index=Prototype})
		return ItemButton
	end
end

-- GuildNews
local GuildNewsItemCache = {}
local function setupGuild(button, text_color, text, text1, text2, ...)
	if (not EnableItemLevel) or (not EnableItemLevelGuildNews) then return end
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
end

LibEvent:attachEvent("ADDON_LOADED", function(self, addonName)
	if addonName == "Blizzard_GuildUI" or addonName == "Blizzard_Communities" then
		hooksecurefunc("GuildNewsButton_SetText", setupGuild)
	end
end)