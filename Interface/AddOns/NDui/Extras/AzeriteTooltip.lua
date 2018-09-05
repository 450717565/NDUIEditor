local function AzeriteTooltip_GetSpellID(powerID)
	local powerInfo = C_AzeriteEmpoweredItem.GetPowerInfo(powerID)
	if powerInfo then
		return powerInfo["spellID"]
	end
end

local function AzeriteTooltip_ScanSelectedTraits(tooltip, powerName)
	for i = 8, tooltip:NumLines() do
		local left = _G[tooltip:GetName().."TextLeft"..i]
		local text = left:GetText()
		if text and text:find(powerName) then
			return true
		end
	end
end

local function AzeriteTooltip_BuildTooltip(self)
	local name, link = self:GetItem()
	if not name then return end

	if C_AzeriteEmpoweredItem.IsAzeriteEmpoweredItemByID(link) then
		local currentLevel = 0
		local azeriteItemLocation = C_AzeriteItem.FindActiveAzeriteItem()
		if azeriteItemLocation then
			currentLevel = C_AzeriteItem.GetPowerLevel(azeriteItemLocation)
		end

		local specID = GetSpecializationInfo(GetSpecialization())
		local allTierInfo = C_AzeriteEmpoweredItem.GetAllTierInfoByItemID(link)

		if (not allTierInfo) or (not specID) then return end

		for j = 1, 3 do
			local tierLevel = allTierInfo[j]["unlockLevel"]
			local azeritePowerID = allTierInfo[j]["azeritePowerIDs"][1]

			if azeritePowerID == 13 then break end -- Ignore +5 item level tier

			if tierLevel <= currentLevel then
				self:AddLine(" ")
				self:AddLine(PVP_RATING..tierLevel, 0, 1, 0)
			else
				self:AddLine(" ")
				self:AddLine(PVP_RATING..tierLevel, 1, 0, 0)
			end

			for i, _ in pairs(allTierInfo[j]["azeritePowerIDs"]) do
				local azeritePowerID = allTierInfo[j]["azeritePowerIDs"][i]
				local azeriteSpellID = AzeriteTooltip_GetSpellID(azeritePowerID)

				local azeritePowerName, _, icon = GetSpellInfo(azeriteSpellID)
				local azeriteIcon = "  |T"..icon..":16:16:0:0:64:64:4:60:4:60|t "
				local azeriteTooltipText = azeriteIcon..azeritePowerName

				if tierLevel <= currentLevel then
					if AzeriteTooltip_ScanSelectedTraits(self, azeritePowerName) then
						self:AddLine(azeriteTooltipText, 0, 1, 0)
					elseif C_AzeriteEmpoweredItem.IsPowerAvailableForSpec(azeritePowerID, specID) then
						self:AddLine(azeriteTooltipText, 1, 1, 1)
					else
						self:AddLine(azeriteTooltipText,  0.5, 0.5, 0.5)
					end
				else
					self:AddLine(azeriteTooltipText, 0.5, 0.5, 0.5)
				end
			end
		end
	end
end

GameTooltip:HookScript("OnTooltipSetItem", AzeriteTooltip_BuildTooltip)
ItemRefTooltip:HookScript("OnTooltipSetItem", AzeriteTooltip_BuildTooltip)
ShoppingTooltip1:HookScript("OnTooltipSetItem", AzeriteTooltip_BuildTooltip)
WorldMapTooltip.ItemTooltip.Tooltip:HookScript("OnTooltipSetItem", AzeriteTooltip_BuildTooltip)