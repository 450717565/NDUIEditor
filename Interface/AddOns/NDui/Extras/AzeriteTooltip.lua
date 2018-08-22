local function AzeriteTooltip_GetSpellID(powerID)
	local powerInfo = C_AzeriteEmpoweredItem.GetPowerInfo(powerID)
	if (powerInfo) then
		local azeriteSpellID = powerInfo["spellID"]
		return azeriteSpellID
	end
end

local function AzeriteTooltip_ScanSelectedTraits(powerName)
	for i = 10, GameTooltip:NumLines() do
		local left = _G[GameTooltip:GetName().."TextLeft"..i]
		local text = left:GetText()
		if text:find(powerName) then
			return true
		end
	end
end

local currentLevel = 0

local function AzeriteTooltip_BuildTooltip(itemLink, tooltip)
	-- Current Azerite Level
	local azeriteItemLocation = C_AzeriteItem.FindActiveAzeriteItem()
	if azeriteItemLocation then
		currentLevel = C_AzeriteItem.GetPowerLevel(azeriteItemLocation)
	end

	local specID = GetSpecializationInfo(GetSpecialization())
	local allTierInfo = C_AzeriteEmpoweredItem.GetAllTierInfoByItemID(itemLink)

	if not allTierInfo[1]["azeritePowerIDs"][1] then return end

	tooltip:AddLine(" ")

	for j=1, 3 do
		local tierLevel = allTierInfo[j]["unlockLevel"]
		local azeritePowerID = allTierInfo[j]["azeritePowerIDs"][1]

		if azeritePowerID == 13 then break end -- Ignore +5 item level tier

		if tierLevel <= currentLevel then
			tooltip:AddLine(PVP_RATING..tierLevel, 1, 0.8, 0)
		else
			tooltip:AddLine(PVP_RATING..tierLevel, 0.5, 0.5, 0.5)
		end

		for i, _ in pairs(allTierInfo[j]["azeritePowerIDs"]) do
			local azeritePowerID = allTierInfo[j]["azeritePowerIDs"][i]
			local azeriteSpellID = AzeriteTooltip_GetSpellID(azeritePowerID)

			local azeritePowerName, _, icon = GetSpellInfo(azeriteSpellID)
			local azeriteIcon = "  |T"..icon..":16:16:0:0:64:64:4:60:4:60|t "
			local azeriteTooltipText = azeriteIcon..azeritePowerName

			if tierLevel <= currentLevel then
				if AzeriteTooltip_ScanSelectedTraits(azeritePowerName) then
					tooltip:AddLine(azeriteTooltipText, 0, 1, 0)
				elseif C_AzeriteEmpoweredItem.IsPowerAvailableForSpec(azeritePowerID, specID) then
					tooltip:AddLine(azeriteTooltipText, 1, 1, 1)
				else
					tooltip:AddLine(azeriteTooltipText,  0.5, 0.5, 0.5)
				end
			else
				tooltip:AddLine(azeriteTooltipText, 0.5, 0.5, 0.5)
			end
		end
	end
end

GameTooltip:HookScript("OnTooltipSetItem", function(self)
	local name, link = self:GetItem()
	if not name then return end

	if C_AzeriteEmpoweredItem.IsAzeriteEmpoweredItemByID(link) then
		AzeriteTooltip_BuildTooltip(link, self)
	end
end)

ItemRefTooltip:HookScript("OnTooltipSetItem", function(self)
	local name, link = self:GetItem()
	if not name then return end

	if C_AzeriteEmpoweredItem.IsAzeriteEmpoweredItemByID(link) then
		AzeriteTooltip_BuildTooltip(link, self)
	end
end)

WorldMapTooltip.ItemTooltip.Tooltip:HookScript("OnTooltipSetItem", function(self)
	local name, link = self:GetItem()
	if not name then return end

	if C_AzeriteEmpoweredItem.IsAzeriteEmpoweredItemByID(link) then
		AzeriteTooltip_BuildTooltip(link, self)
	end
end)