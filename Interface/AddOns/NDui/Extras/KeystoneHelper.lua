local _, ns = ...
local B, C, L, DB = unpack(ns)
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
	local mapLevel = 0

	if Extras.KH_CheckLink(link) then
		local info = {strsplit(":", link)}
		mapLevel = tonumber(info[4])

		if mapLevel > 15 then mapLevel = 15 end
	end

	return mapLevel
end

function Extras:KH_OnTooltipSetItem()
	local showIt = false
	local _, link = self:GetItem()

	if Extras.KH_CheckLink(link) then
		local mapLevel = Extras.KH_CheckKeystone(link)
		local mlvl = DB.MythicLoot[mapLevel]
		local wlvl = DB.WeeklyLoot[mapLevel]

		if mapLevel >= 2 then
			self:AddLine(" ")
			self:AddLine(strformat(L["Mythic & Weekly Loot"], DB.MyColor..mlvl.."|r", DB.MyColor..wlvl.."|r"))
		end

		showIt = true
	end

	if showIt then self:Show() end
end

function Extras:KeystoneHelper()
	GameTooltip:HookScript("OnTooltipSetItem", self.KH_OnTooltipSetItem)
	ItemRefTooltip:HookScript("OnTooltipSetItem", self.KH_OnTooltipSetItem)
	ShoppingTooltip1:HookScript("OnTooltipSetItem", self.KH_OnTooltipSetItem)
	ShoppingTooltip2:HookScript("OnTooltipSetItem", self.KH_OnTooltipSetItem)
	GameTooltipTooltip:HookScript("OnTooltipSetItem", self.KH_OnTooltipSetItem)
	EmbeddedItemTooltip:HookScript("OnTooltipSetItem", self.KH_OnTooltipSetItem)
end