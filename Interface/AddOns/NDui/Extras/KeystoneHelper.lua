local B, C, L, DB = unpack(select(2, ...))

local MythicLootItemLevel = {  0 ,155 ,160 ,165 ,170 ,175 ,180 ,185 ,190 ,195 ,200 ,205 ,210 ,215 ,220}
local WeeklyLootItemLevel = {  0 ,175 ,180 ,185 ,190 ,195 ,200 ,205 ,210 ,215 ,220 ,225 ,230 ,235 ,240}

local function GetModifiers(linkType, ...)
	if type(linkType) ~= "string" then return end
	local modifierOffset = 3
	local instanceID, mythicLevel, notDepleted, _ = ...

	if mythicLevel and mythicLevel ~= "" then
		mythicLevel = tonumber(mythicLevel)
		if mythicLevel and mythicLevel > 15 then
			mythicLevel = 15
		end
	else
		mythicLevel = nil
	end

	if linkType:find("item") then
		_, _, _, _, _, _, _, _, _, _, _, _, _, instanceID, mythicLevel = ...
		if ... == "138019" then
			modifierOffset = 16
		else
			return
		end
	elseif not linkType:find("keystone") then
		return
	end

	local modifiers = {}
	for i = modifierOffset, select("#", ...) do
		local num = strmatch(select(i, ...) or "", "^(%d+)")
		if num then
			local modifierID = tonumber(num)
			tinsert(modifiers, modifierID)
		end
	end
	local numModifiers = #modifiers
	if modifiers[numModifiers] and modifiers[numModifiers] < 2 then
		tremove(modifiers, numModifiers)
	end
	return modifiers, instanceID, mythicLevel
end

local function DecorateTooltip(self)
	local _, link = self:GetItem()
	if type(link) == "string" and link:find("keystone") then
		local modifiers, instanceID, mythicLevel = GetModifiers(strsplit(":", link))
		local ilvl = MythicLootItemLevel[mythicLevel]
		local wlvl = WeeklyLootItemLevel[mythicLevel]
		if modifiers then
			self:AddLine(" ")
			for _, modifierID in ipairs(modifiers) do
				local modifierName, modifierDescription = C_ChallengeMode.GetAffixInfo(modifierID)
				if modifierName and modifierDescription then
					self:AddLine(format("|cffff0000%s|r - %s", modifierName, modifierDescription), 0, 1, 0, true)
				end
			end
		end
		if type(mythicLevel) == "number" and mythicLevel > 0 then
			self:AddLine(" ")
			self:AddLine("|cff00ffff"..L["Mythic Loot Item Level"]..ilvl.."+|r")
			self:AddLine("|cff00ffff"..L["Weekly Loot Item Level"]..wlvl.."+|r")
		end
		if modifiers or mythicLevel then
			self:Show()
		end
	end
end

hooksecurefunc(ItemRefTooltip, "SetHyperlink", DecorateTooltip)
--ItemRefTooltip:HookScript("OnTooltipSetItem", DecorateTooltip)
GameTooltip:HookScript("OnTooltipSetItem", DecorateTooltip)