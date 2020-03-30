local B, C, L, DB = unpack(select(2, ...))

-- 雨夜独行客
local Corruptions = {
	["6483"] = {315607, "I"},
	["6484"] = {315608, "II"},
	["6485"] = {315609, "III"},
	["6474"] = {315544, "I"},
	["6475"] = {315545, "II"},
	["6476"] = {315546, "III"},
	["6471"] = {315529, "I"},
	["6472"] = {315530, "II"},
	["6473"] = {315531, "III"},
	["6480"] = {315554, "I"},
	["6481"] = {315557, "II"},
	["6482"] = {315558, "III"},
	["6477"] = {315549, "I"},
	["6478"] = {315552, "II"},
	["6479"] = {315553, "III"},
	["6493"] = {315590, "I"},
	["6494"] = {315591, "II"},
	["6495"] = {315592, "III"},
	["6437"] = {315277, "I"},
	["6438"] = {315281, "II"},
	["6439"] = {315282, "III"},
	["6555"] = {318266, "I"},
	["6559"] = {318492, "II"},
	["6560"] = {318496, "III"},
	["6556"] = {318268, "I"},
	["6561"] = {318493, "II"},
	["6562"] = {318497, "III"},
	["6558"] = {318270, "I"},
	["6565"] = {318495, "II"},
	["6566"] = {318499, "III"},
	["6557"] = {318269, "I"},
	["6563"] = {318494, "II"},
	["6564"] = {318498, "III"},
	["6549"] = {318280, "I"},
	["6550"] = {318485, "II"},
	["6551"] = {318486, "III"},
	["6552"] = {318274, "I"},
	["6553"] = {318487, "II"},
	["6554"] = {318488, "III"},
	["6547"] = {318303, "I"},
	["6548"] = {318484, "II"},
	["6537"] = {318276, "I"},
	["6538"] = {318477, "II"},
	["6539"] = {318478, "III"},
	["6543"] = {318481, "I"},
	["6544"] = {318482, "II"},
	["6545"] = {318483, "III"},
	["6540"] = {318286, "I"},
	["6541"] = {318479, "II"},
	["6542"] = {318480, "III"},
	["6573"] = {318272, ""},
	["6546"] = {318239, ""},
	["6571"] = {318293, ""},
	["6572"] = {316651, ""},
	["6567"] = {318294, ""},
	["6568"] = {316780, ""},
	["6570"] = {318299, ""},
	["6569"] = {317290, ""},
}
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
				end
				if id and Corruptions[id] then
					local name, _, icon = GetSpellInfo(Corruptions[id][1])
					local text = "|T" .. icon .. ":14:14:0:0:64:64:5:59:5:59|t " .. name .. " " .. Corruptions[id][2]
					row.corruption:SetText(text)
					row.corruption:Show()
					break
				end
			end
		end
	end
end

local function processRows()
	if AuctionHouseFrame and AuctionHouseFrame.ItemBuyFrame.ItemList.tableBuilder then
		for rowIndex, row in pairs(AuctionHouseFrame.ItemBuyFrame.ItemList.tableBuilder.rows) do
			if not row.corruption then
				row.corruption = createFS(row, .5, .5, 1, 300)
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