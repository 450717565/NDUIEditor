local _, ns = ...
local B, C, L, DB = unpack(ns)
local Extras = B:GetModule("Extras")

function Extras.KH_CheckLink(link)
	if link and type(link) == "string" and string.match(link, "|Hkeystone:([0-9:]+)|h(%b[])|h") then
		return true
	else
		return false
	end
end

function Extras.KH_GetMapLevel(link)
	local mapLevel = 0

	if Extras.KH_CheckLink(link) then
		local info = {string.split(":", link)}
		mapLevel = tonumber(info[4])

		if mapLevel > 15 then mapLevel = 15 end
	end

	return mapLevel
end

function Extras:KH_OnTooltipSetItem()
	local showIt = false
	local _, link = self:GetItem()

	if Extras.KH_CheckLink(link) then
		local mapLevel = Extras.KH_GetMapLevel(link)
		local mlvl = DB.MythicLoot[mapLevel]
		local wlvl = DB.WeeklyLoot[mapLevel]

		if mapLevel >= 2 then
			self:AddLine(" ")
			self:AddLine(string.format(L["Mythic & Weekly Loot"], DB.InfoColor..mlvl.."|r", DB.InfoColor..wlvl.."|r"))
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