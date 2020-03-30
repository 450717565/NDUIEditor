local B, C, L, DB = unpack(select(2, ...))
local TT = B:GetModule("Tooltip")

-- 雨夜独行客
local function GetCorruptions()
	local corruptions = {}
	for slotId = 1, 17 do
		local itemLink = GetInventoryItemLink("player", slotId)
		if itemLink then
			local value = TT:Corruption_Search(itemLink)
			if value then
				if not value.name or not value.icon then
					value.name, _, value.icon = GetSpellInfo(value.spellID)
				end
				corruptions[#corruptions + 1] = value
			end
		end
	end

	return corruptions
end

local function Corruption_OnEnter()
	local corruptions = GetCorruptions()
	if #corruptions > 0 then
		GameTooltip:AddLine(" ")

		local buckets = {}
		for i = 1, #corruptions do
			local name = corruptions[i].name
			local icon = corruptions[i].icon
			local level = corruptions[i].level
			local info = name.." "..level
			local line = "|T"..icon..":0|t"..info

			if buckets[info] == nil then
				buckets[info] = {1, line}
			else
				buckets[info][1] = buckets[info][1] + 1
			end
		end
		table.sort(buckets)
		for info, _ in pairs(buckets) do
			GameTooltip:AddLine("|cff956dd1"..buckets[info][1].." x "..buckets[info][2].."|r")
		end

		GameTooltip:Show()
	end
end

CharacterStatsPane.ItemLevelFrame.Corruption:HookScript("OnEnter", Corruption_OnEnter)