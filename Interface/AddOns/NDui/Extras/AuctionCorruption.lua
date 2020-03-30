local B, C, L, DB = unpack(select(2, ...))
local TT = B:GetModule("Tooltip")

-- 雨夜独行客
local BonusIDs = {
	["40"] = ITEM_MOD_CR_AVOIDANCE_SHORT,
	["41"] = ITEM_MOD_CR_LIFESTEAL_SHORT,
	["42"] = ITEM_MOD_CR_SPEED_SHORT,
	["43"] = ITEM_MOD_CR_STURDINESS_SHORT,
}

local function createFS(row, r, g, b, x)
	local fs = B.CreateFS(row, 12, "", false, "LEFT", x, 0)
	fs:SetTextColor(r, g, b)
	fs:SetJustifyH("LEFT")
	fs:Hide()

	return fs
end

local function rowUpdate(row)
	if row and row.rowData then
		local data = row.rowData
		local itemLink = string.match(data.itemLink, "item:%d([:%d]+)")
		row.corruption:SetText("")
		row.corruption:Hide()
		row.bonus:SetText("")
		row.bonus:Hide()
		if itemLink then
			local itemIds = {strsplit(":", itemLink)}
			for _, id in pairs(itemIds) do
				if id and BonusIDs[id] then
					row.bonus:SetText(BonusIDs[id])
					row.bonus:Show()
					break
				end
			end
		end
		local value = TT:Corruption_Search(data.itemLink)
		if value then
			local name, _, icon = GetSpellInfo(value.spellID)
			local text = "|T"..icon..":14:14:0:0:64:64:5:59:5:59|t"..name.." "..value.level
			row.corruption:SetText(text)
			row.corruption:Show()
		end
	end
end

local function processRows()
	if AuctionHouseFrame and AuctionHouseFrame.ItemBuyFrame.ItemList.tableBuilder then
		for rowIndex, row in pairs(AuctionHouseFrame.ItemBuyFrame.ItemList.tableBuilder.rows) do
			if not row.corruption then
				row.corruption = createFS(row, .6, .4, .8, 300)
			end
			if not row.bonus then
				row.bonus = createFS(row, 0, 1, 0, 475)
			end
			rowUpdate(row)
		end
	end
end

local ticker
local function updateTicker(event)
	if event == "ITEM_SEARCH_RESULTS_UPDATED" then
		if ticker then ticker:Cancel() end
		ticker = C_Timer.NewTicker(0.1, processRows)
	else
		if ticker then ticker:Cancel() end
	end
end

local eventList = {"AUCTION_HOUSE_BROWSE_FAILURE", "AUCTION_HOUSE_BROWSE_RESULTS_ADDED", "AUCTION_HOUSE_BROWSE_RESULTS_UPDATED", "AUCTION_HOUSE_CLOSED", "AUCTION_HOUSE_SHOW", "ITEM_SEARCH_RESULTS_UPDATED"}
for _, event in pairs(eventList) do
	B:RegisterEvent(event, updateTicker)
end