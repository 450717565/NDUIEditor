local _, ns = ...
local B, C, L, DB = unpack(ns)
local S = B:GetModule("Skins")

-- 显示附加词缀, by 雨夜独行客
local BonusIDs = {
	["40"] = ITEM_MOD_CR_AVOIDANCE_SHORT,
	["41"] = ITEM_MOD_CR_LIFESTEAL_SHORT,
	["42"] = ITEM_MOD_CR_SPEED_SHORT,
	["43"] = ITEM_MOD_CR_STURDINESS_SHORT,
}

local function CreateBonus(self, r, g, b)
	local fs = B.CreateFS(self, 12)
	fs:ClearAllPoints()
	fs:SetPoint("LEFT", self.cells[5], "LEFT", 5, 0)
	fs:SetTextColor(0, 1, 0)
	fs:Hide()

	return fs
end

local function UpdateRow(self)
	if self and self.rowData then
		self.bonus:SetText("")
		self.bonus:Hide()

		local itemLink = string.match(self.rowData.itemLink, "item:%d([:%d]+)")
		if itemLink then
			local itemIds = {strsplit(":", itemLink)}
			for _, id in pairs(itemIds) do
				if id and BonusIDs[id] then
					self.bonus:SetText(BonusIDs[id])
					self.bonus:Show()

					break
				end
			end
		end
	end
end

local function ProcessRows()
	local tableBuilder = AuctionHouseFrame.ItemBuyFrame.ItemList.tableBuilder
	if AuctionHouseFrame and tableBuilder then
		for rowIndex, row in pairs(tableBuilder.rows) do
			if not row.bonus then
				row.bonus = CreateBonus(row)
			end

			UpdateRow(row)
		end
	end
end

local ticker
local function updateTicker(event)
	if event == "ITEM_SEARCH_RESULTS_UPDATED" then
		if ticker then ticker:Cancel() end
		ticker = C_Timer.NewTicker(0.1, ProcessRows)
	else
		if ticker then ticker:Cancel() end
	end
end

local eventList = {
	"AUCTION_HOUSE_BROWSE_FAILURE",
	"AUCTION_HOUSE_BROWSE_RESULTS_ADDED",
	"AUCTION_HOUSE_BROWSE_RESULTS_UPDATED",
	"AUCTION_HOUSE_CLOSED",
	"AUCTION_HOUSE_SHOW",
	"ITEM_SEARCH_RESULTS_UPDATED",
}
for _, event in pairs(eventList) do
	B:RegisterEvent(event, updateTicker)
end

-- 钓鱼价避开
local function Update_PriceSelection(self)
	local name = self:GetItem()
	if name then
		local itemID = C_Item.GetItemID(name)
		local itemLink = C_Item.GetItemLink(name)

		if itemID and itemLink then
			local sr_1 = C_AuctionHouse.GetCommoditySearchResultInfo(itemID, 1)
			local sr_2 = C_AuctionHouse.GetCommoditySearchResultInfo(itemID, 2)

			if sr_1 and self:GetUnitPrice() == sr_1.unitPrice then
				local itemSeller = sr_1.owners[1] or ""
				local itemPrice = GetMoneyString(sr_1.unitPrice)

				if sr_1.quantity <= 3 then
					if sr_2 and sr_2.unitPrice > sr_1.unitPrice * 1.1 then
						self:GetCommoditiesSellList():SetSelectedEntry(sr_2)
						print(format("%s %s (|cffff0000%s|r) 疑似钓鱼价，已为您避开。", itemLink, itemPrice, itemSeller))
					end
				end
			end
		end
	end
end

local function OptimizePriceSelection()
	hooksecurefunc(AuctionHouseFrame.CommoditiesSellFrame, "UpdatePriceSelection", Update_PriceSelection)
end

S.LoadWithAddOn("Blizzard_AuctionHouseUI", OptimizePriceSelection)