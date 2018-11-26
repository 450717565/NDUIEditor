local B, C, L, DB = unpack(select(2, ...))

local strformat = string.format
local tbinsert, tbremove = table.insert, table.remove

local MythicLootItemLevel =  {  0, 345, 345, 350, 355, 355, 360, 365, 365, 370}
local WeeklyLootItemLevel =  {  0, 355, 355, 360, 360, 365, 370, 370, 375, 380}
local WeeklyArmorItemLevel = {  0, 340, 340, 355, 355, 355, 370, 370, 370, 385}

local function CheckLink(link)
	if link and type(link) == "string" and link:match("|Hkeystone:([0-9:]+)|h(%b[])|h") then
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

			if mapLevel >= 10 then tbinsert(affixIDs, 16) end
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
		local alvl = WeeklyArmorItemLevel[mapLevel]
--[[
		if affixIDs then
			self:AddLine(" ")
			for _, affixID in ipairs(affixIDs) do
				local affixName, affixDescription = C_ChallengeMode.GetAffixInfo(affixID)
				if affixName and affixDescription then
					self:AddLine(strformat("|cffFF0000%s|r - |cff00FF00%s|r", affixName, affixDescription), nil, nil, nil, true)
				end
			end
		end
]]
		if mapLevel >= 2 then
			self:AddLine(" ")
			self:AddLine(strformat(L["Mythic Loot Item Level"], ilvl), 1,1,0)
			self:AddLine(strformat(L["Weekly Loot Item Level"], wlvl), 0,1,1)
			self:AddLine(strformat(L["Weekly Azerite Item Level"], alvl), .9,.8,.5)
		end
	end
end

hooksecurefunc(ItemRefTooltip, "SetHyperlink", OnTooltipSetItem)
GameTooltip:HookScript("OnTooltipSetItem", OnTooltipSetItem)
ItemRefTooltip:HookScript("OnTooltipSetItem", OnTooltipSetItem)