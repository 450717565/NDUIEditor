local B, C, L, DB = unpack(select(2, ...))

local strformat, strmatch, strsplit = string.format, string.match, string.split
local tbinsert, tbremove = table.insert, table.remove

local MythicLootItemLevel =  {  0, 375, 375, 380, 385, 385, 390, 395, 395, 400}
local WeeklyLootItemLevel =  {  0, 380, 385, 390, 390, 395, 400, 400, 405, 410}

local function CheckLink(link)
	if link and type(link) == "string" and strmatch(link, "|Hkeystone:([0-9:]+)|h(%b[])|h") then
		return true
	else
		return false
	end
end

local function CheckKeystone(link)
	local affixIDs, mapLevel = {}, 0

	if CheckLink(link) then
		local info = {strsplit(":", link)}
		mapLevel = tonumber(info[4])

		if mapLevel > 10 then mapLevel = 10 end
		if mapLevel >= 2 then
			for i = 5, 7 do
				local affixID = tonumber(info[i])
				if affixID then
					tbinsert(affixIDs, affixID)
				end
			end
		end

		local affixid = #affixIDs
		if affixIDs[affixid] and affixIDs[affixid] < 2 then
			tbremove(affixIDs, affixid)
		end
	end

	return affixIDs, mapLevel
end

local function OnTooltipSetItem(self)
	local _, link = self:GetItem()

	if CheckLink(link) then
		local affixIDs, mapLevel = CheckKeystone(link)
		local ilvl = MythicLootItemLevel[mapLevel]
		local wlvl = WeeklyLootItemLevel[mapLevel]

		if mapLevel >= 2 then
			self:AddLine(" ")
			self:AddLine(strformat(L["Mythic Loot Item Level"], ilvl), 0,1,1)
			self:AddLine(strformat(L["Weekly Loot Item Level"], wlvl), 1,1,0)
		end
	end
end

hooksecurefunc(ItemRefTooltip, "SetHyperlink", OnTooltipSetItem)
GameTooltip:HookScript("OnTooltipSetItem", OnTooltipSetItem)
ItemRefTooltip:HookScript("OnTooltipSetItem", OnTooltipSetItem)