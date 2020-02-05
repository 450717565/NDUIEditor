local B, C, L, DB = unpack(select(2, ...))
local Extras = B:GetModule("Extras")

local strformat, strmatch, strsplit = string.format, string.match, string.split
local tbinsert, tbremove = table.insert, table.remove

function Extras.KH_CheckLink(link)
	if link and type(link) == "string" and strmatch(link, "|Hkeystone:([0-9:]+)|h(%b[])|h") then
		return true
	else
		return false
	end
end

function Extras.KH_CheckKeystone(link)
	local affixIDs, mapLevel = {}, 0

	if Extras.KH_CheckLink(link) then
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

function Extras:KH_OnTooltipSetItem()
	local _, link = self:GetItem()

	if Extras.KH_CheckLink(link) then
		local affixIDs, mapLevel = Extras.KH_CheckKeystone(link)
		local mlvl = Extras.MythicLoot[mapLevel]
		local wlvl = Extras.WeeklyLoot[mapLevel]

		if mapLevel >= 2 then
			self:AddLine(" ")
			self:AddLine(strformat(L["Mythic & Weekly Loot"], DB.MyColor..mlvl.."|r", DB.MyColor..wlvl.."|r"))
		end
	end
end

function Extras:KeystoneHelper()
	hooksecurefunc(ItemRefTooltip, "SetHyperlink", self.KH_OnTooltipSetItem)
	GameTooltip:HookScript("OnTooltipSetItem", self.KH_OnTooltipSetItem)
	ItemRefTooltip:HookScript("OnTooltipSetItem", self.KH_OnTooltipSetItem)
end