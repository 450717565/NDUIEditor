local B, C, L, DB = unpack(select(2, ...))
local Extras = B:GetModule("Extras")

local strformat, strmatch, strsplit = string.format, string.match, string.split
local tbinsert, tbremove = table.insert, table.remove

local MythicLootItemLevel =  {405, 405, 410, 415, 415, 420, 425, 425, 430}
local WeeklyLootItemLevel =  {410, 415, 420, 420, 425, 430, 430, 435, 440}

function Extras:KH_CheckLink()
	if self and type(self) == "string" and strmatch(self, "|Hkeystone:([0-9:]+)|h(%b[])|h") then
		return true
	else
		return false
	end
end

function Extras:KH_CheckKeystone()
	local affixIDs, mapLevel = {}, 0

	if Extras.KH_CheckLink(self) then
		local info = {strsplit(":", self)}
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

function Extras:KH_OnTooltipSetItem()
	local _, self = self:GetItem()

	if Extras.KH_CheckLink(self) then
		local affixIDs, mapLevel = Extras.KH_CheckKeystone(self)
		local ilvl = MythicLootItemLevel[mapLevel]
		local wlvl = WeeklyLootItemLevel[mapLevel]

		if mapLevel >= 2 then
			self:AddLine(" ")
			self:AddLine(strformat(L["Mythic Loot Item Level"], ilvl), 0,1,1)
			self:AddLine(strformat(L["Weekly Loot Item Level"], wlvl), 1,1,0)
		end
	end
end

function Extras:KeystoneHelper()
	hooksecurefunc(ItemRefTooltip, "SetHyperlink", self.KH_OnTooltipSetItem)
	GameTooltip:HookScript("OnTooltipSetItem", self.KH_OnTooltipSetItem)
	ItemRefTooltip:HookScript("OnTooltipSetItem", self.KH_OnTooltipSetItem)
end