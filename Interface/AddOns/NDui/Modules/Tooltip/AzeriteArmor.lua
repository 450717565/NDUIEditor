local _, ns = ...
local B, C, L, DB = unpack(ns)
local TT = B:GetModule("Tooltip")

local _G = getfenv(0)
local format, tinsert, pairs, select = string.format, table.insert, pairs, select
local GetSpellInfo = GetSpellInfo
local C_AzeriteEmpoweredItem_GetPowerInfo = C_AzeriteEmpoweredItem.GetPowerInfo
local C_AzeriteEmpoweredItem_IsAzeriteEmpoweredItemByID = C_AzeriteEmpoweredItem.IsAzeriteEmpoweredItemByID
local C_AzeriteEmpoweredItem_GetAllTierInfoByItemID = C_AzeriteEmpoweredItem.GetAllTierInfoByItemID
local tipList, powerList, powerCache, tierCache = {}, {}, {}, {}

local knownString = DB.MyColor..">|r".."%s"..DB.MyColor.."<|r"
local iconString = "|T%s:16:20:0:0:64:64:5:59:5:59"
local function getIconString(icon, known)
	if known then
		return format(format(knownString, iconString..":255:255:255|t"), icon)
	else
		return format(iconString..":128:128:128|t", icon)
	end
end

function TT:Azerite_ScanTooltip()
	wipe(tipList)
	wipe(powerList)

	for i = 9, self:NumLines() do
		local line = _G[self:GetDebugName().."TextLeft"..i]
		local text = line:GetText()
		local powerName = text and strmatch(text, "%- (.+)")
		if powerName then
			tinsert(tipList, i)
			powerList[i] = powerName
		end
	end
end

function TT:Azerite_PowerToSpell(id)
	local spellID = powerCache[id]
	if not spellID then
		local powerInfo = C_AzeriteEmpoweredItem_GetPowerInfo(id)
		if powerInfo and powerInfo.spellID then
			spellID = powerInfo.spellID
			powerCache[id] = spellID
		end
	end
	return spellID
end

function TT:Azerite_UpdateTier(link)
	if not C_AzeriteEmpoweredItem_IsAzeriteEmpoweredItemByID(link) then return end
	local allTierInfo = tierCache[link]
	if not allTierInfo then
		allTierInfo = C_AzeriteEmpoweredItem_GetAllTierInfoByItemID(link)
		tierCache[link] = allTierInfo
	end

	return allTierInfo
end

function TT:Azerite_UpdateItem()
	local _, link = self:GetItem()
	if not link then return end

	local allTierInfo = TT:Azerite_UpdateTier(link)
	if not allTierInfo then return end

	TT.Azerite_ScanTooltip(self)
	if #tipList == 0 then return end

	local index = 1
	for i = 1, #allTierInfo do
		local powerIDs = allTierInfo[i].azeritePowerIDs
		if powerIDs[1] == 13 then break end

		local lineIndex = tipList[index]
		if not lineIndex then break end

		local tooltipText = ""
		for _, id in pairs(powerIDs) do
			local spellID = TT:Azerite_PowerToSpell(id)
			if not spellID then break end

			local name, _, icon = GetSpellInfo(spellID)
			local found = name == powerList[lineIndex]
			if found then
				tooltipText = tooltipText.." "..getIconString(icon, true)
			else
				tooltipText = tooltipText.." "..getIconString(icon)
			end
		end

		if tooltipText ~= "" then
			local line = _G[self:GetDebugName().."TextLeft"..lineIndex]
			if C.db["Tooltip"]["OnlyArmorIcons"] then
				line:SetText(tooltipText)
				_G[self:GetDebugName().."TextLeft"..lineIndex+1]:SetText("")
			else
				line:SetText(line:GetText().."\n "..tooltipText)
			end
		end

		index = index + 1
	end
end

function TT:AzeriteArmor()
	if not C.db["Tooltip"]["AzeriteArmor"] then return end
	if IsAddOnLoaded("AzeriteTooltip") then return end

	local itemTooltips = DB.ItemTooltips
	for _, tip in pairs(itemTooltips) do
		tip:HookScript("OnTooltipSetItem", TT.Azerite_UpdateItem)
	end
end