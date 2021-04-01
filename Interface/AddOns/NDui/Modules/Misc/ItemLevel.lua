local _, ns = ...
local B, C, L, DB = unpack(ns)
local Misc = B:GetModule("Misc")
local TT = B:GetModule("Tooltip")

local pairs, select, next, type, unpack = pairs, select, next, type, unpack
local UnitGUID, GetItemInfo, GetSpellInfo = UnitGUID, GetItemInfo, GetSpellInfo
local GetContainerItemLink, GetInventoryItemLink = GetContainerItemLink, GetInventoryItemLink
local EquipmentManager_UnpackLocation, EquipmentManager_GetItemInfoByLocation = EquipmentManager_UnpackLocation, EquipmentManager_GetItemInfoByLocation
local C_AzeriteEmpoweredItem_IsPowerSelected = C_AzeriteEmpoweredItem.IsPowerSelected

local slots = DB.Slots

function Misc:GetSlotAnchor(index, isIcon)
	if not index then return end

	if index <= 5 or index == 9 or index == 15 or index == 18 then
		if isIcon then
			return "BOTTOMLEFT", "BOTTOMRIGHT", 4, 2
		else
			return "TOPLEFT", "TOPRIGHT", 4, -2
		end
	elseif index == 16 then
		if isIcon then
			return "TOPRIGHT", "TOPLEFT", -4, -2
		else
			return "BOTTOMRIGHT", "BOTTOMLEFT", -4, 2
		end
	elseif index == 17 then
		if isIcon then
			return "TOPLEFT", "TOPRIGHT", 4, -2
		else
			return "BOTTOMLEFT", "BOTTOMRIGHT", 4, 2
		end
	else
		if isIcon then
			return "BOTTOMRIGHT", "BOTTOMLEFT", -4, 2
		else
			return "TOPRIGHT", "TOPLEFT", -4, -2
		end
	end
end

function Misc:CreateItemTexture(slot, relF, relT, x, y)
	local icon = slot:CreateTexture()
	icon:SetPoint(relF, slot, relT, x, y)
	icon:SetSize(14, 14)
	icon.icbg = B.ReskinIcon(icon)
	icon.icbg:SetFrameLevel(3)
	icon.icbg:Hide()

	return icon
end

function Misc:CreateItemString(frame, strType)
	if frame.fontCreated then return end

	for index, slot in pairs(slots) do
		if index ~= 4 or index ~= 18 then
			local slotFrame = _G[strType..slot.."Slot"]
			slotFrame.iLvlText = B.CreateFS(slotFrame, DB.Font[2]+1)
			slotFrame.iLvlText:ClearAllPoints()
			slotFrame.iLvlText:SetPoint("BOTTOM", slotFrame, 1, 1)

			local tp1, tp2, tx, ty = Misc:GetSlotAnchor(index)
			slotFrame.enchantText = B.CreateFS(slotFrame, DB.Font[2]+1)
			slotFrame.enchantText:ClearAllPoints()
			slotFrame.enchantText:SetPoint(tp1, slotFrame, tp2, tx, ty)
			slotFrame.enchantText:SetTextColor(0, 1, 0)

			local ip1, ip2, ix, iy = Misc:GetSlotAnchor(index, true)
			for i = 1, 10 do
				local offset = (i-1)*18 + 3
				local iconX = ix > 0 and ix+offset or ix-offset
				local iconY = iy
				slotFrame["textureIcon"..i] = Misc:CreateItemTexture(slotFrame, ip1, ip2, iconX, iconY)
			end
		end
	end

	frame.fontCreated = true
end

local azeriteSlots = {
	[1] = true,
	[3] = true,
	[5] = true,
}

local locationCache = {}
local function GetSlotItemLocation(id)
	if not azeriteSlots[id] then return end

	local itemLocation = locationCache[id]
	if not itemLocation then
		itemLocation = ItemLocation:CreateFromEquipmentSlot(id)
		locationCache[id] = itemLocation
	end
	return itemLocation
end

function Misc:ItemLevel_UpdateTraits(button, id, link)
	if not C.db["Misc"]["AzeriteTraits"] then return end

	local empoweredItemLocation = GetSlotItemLocation(id)
	if not empoweredItemLocation then return end

	local allTierInfo = TT:Azerite_UpdateTier(link)
	if not allTierInfo then return end

	for i = 1, 4 do
		local powerIDs = allTierInfo[i] and allTierInfo[i].azeritePowerIDs
		if not powerIDs or powerIDs[1] == 13 then break end

		for _, powerID in pairs(powerIDs) do
			local selected = C_AzeriteEmpoweredItem_IsPowerSelected(empoweredItemLocation, powerID)
			if selected then
				local spellID = TT:Azerite_PowerToSpell(powerID)
				local name, _, icon = GetSpellInfo(spellID)
				local texture = button["textureIcon"..i]
				if name and texture then
					texture:SetTexture(icon)
					texture.icbg:Show()
				end
			end
		end
	end
end

function Misc:ItemLevel_UpdateInfo(slotFrame, info, quality)
	local infoType = type(info)
	local level
	if infoType == "table" then
		level = info.iLvl
	else
		level = info
	end

	if level and level > 1 and quality and quality > 1 then
		slotFrame.iLvlText:SetText(level)
	end

	if infoType == "table" then
		local enchant = info.enchantText
		if enchant then
			slotFrame.enchantText:SetText(enchant)
		end

		local gemStep, essenceStep = 1, 1
		for i = 1, 10 do
			local texture = slotFrame["textureIcon"..i]
			local bg = texture.icbg
			local gem = info.gems and info.gems[gemStep]
			local essence = not gem and (info.essences and info.essences[essenceStep])
			if gem then
				texture:SetTexture(gem)
				bg:SetBackdropBorderColor(0, 0, 0)
				bg:Show()

				gemStep = gemStep + 1
			elseif essence and next(essence) then
				local r = essence[4]
				local g = essence[5]
				local b = essence[6]
				if r and g and b then
					bg:SetBackdropBorderColor(r, g, b)
				else
					bg:SetBackdropBorderColor(0, 0, 0)
				end

				local selected = essence[1]
				texture:SetTexture(selected)
				bg:Show()

				essenceStep = essenceStep + 1
			end
		end
	end
end

function Misc:ItemLevel_RefreshInfo(link, unit, index, slotFrame)
	C_Timer.After(.1, function()
		local quality = select(3, GetItemInfo(link))
		local info = B.GetItemLevel(link, unit, index, C.db["Misc"]["GemNEnchant"])
		if info == "tooSoon" then return end
		Misc:ItemLevel_UpdateInfo(slotFrame, info, quality)
	end)
end

function Misc:ItemLevel_SetupLevel(frame, strType, unit)
	if not UnitExists(unit) then return end

	Misc:CreateItemString(frame, strType)

	for index, slot in pairs(slots) do
		if index ~= 4 or index ~= 18 then
			local slotFrame = _G[strType..slot.."Slot"]
			slotFrame.iLvlText:SetText("")
			slotFrame.enchantText:SetText("")
			for i = 1, 10 do
				local texture = slotFrame["textureIcon"..i]
				texture:SetTexture("")
				texture.icbg:Hide()
			end

			local link = GetInventoryItemLink(unit, index)
			if link then
				local quality = select(3, GetItemInfo(link))
				local info = B.GetItemLevel(link, unit, index, C.db["Misc"]["GemNEnchant"])
				if info == "tooSoon" then
					Misc:ItemLevel_RefreshInfo(link, unit, index, slotFrame)
				else
					Misc:ItemLevel_UpdateInfo(slotFrame, info, quality)
				end

				if strType == "Character" then
					Misc:ItemLevel_UpdateTraits(slotFrame, index, link)
				end
			end
		end
	end
end

function Misc:ItemLevel_UpdatePlayer()
	Misc:ItemLevel_SetupLevel(CharacterFrame, "Character", "player")
end

function Misc:ItemLevel_UpdateInspect(...)
	local guid = ...
	if InspectFrame and InspectFrame.unit and UnitGUID(InspectFrame.unit) == guid then
		Misc:ItemLevel_SetupLevel(InspectFrame, "Inspect", InspectFrame.unit)
	end
end

function Misc:ItemLevel_FlyoutUpdate(bag, slot, quality)
	if not self.iLvl then
		self.iLvl = B.CreateFS(self, DB.Font[2]+1)
	end

	local link, level
	if bag then
		link = GetContainerItemLink(bag, slot)
		level = B.GetItemLevel(link, bag, slot)
	else
		link = GetInventoryItemLink("player", slot)
		level = B.GetItemLevel(link, "player", slot)
	end

	self.iLvl:SetText(level)
end

function Misc:ItemLevel_FlyoutSetup()
	if self.iLvl then self.iLvl:SetText("") end

	local location = self.location
	if not location or location >= EQUIPMENTFLYOUT_FIRST_SPECIAL_LOCATION then
		return
	end

	local _, _, bags, voidStorage, slot, bag = EquipmentManager_UnpackLocation(location)
	if voidStorage then return end
	local quality = select(13, EquipmentManager_GetItemInfoByLocation(location))
	if bags then
		Misc.ItemLevel_FlyoutUpdate(self, bag, slot, quality)
	else
		Misc.ItemLevel_FlyoutUpdate(self, nil, slot, quality)
	end
end

function Misc:ItemLevel_ScrappingUpdate()
	if not self.iLvl then
		self.iLvl = B.CreateFS(self, DB.Font[2]+3)
	end
	if not self.itemLink then self.iLvl:SetText("") return end

	local quality = 1
	if self.itemLocation and not self.item:IsItemEmpty() and self.item:GetItemName() then
		quality = self.item:GetItemQuality()
	end
	local level = B.GetItemLevel(self.itemLink)
	self.iLvl:SetText(level)
end

function Misc.ItemLevel_ScrappingShow(event, addon)
	if addon == "Blizzard_ScrappingMachineUI" then
		for button in pairs(ScrappingMachineFrame.ItemSlots.scrapButtons.activeObjects) do
			hooksecurefunc(button, "RefreshIcon", Misc.ItemLevel_ScrappingUpdate)
		end

		B:UnregisterEvent(event, Misc.ItemLevel_ScrappingShow)
	end
end

function Misc:ItemLevel_UpdateItemButton(link)
	local ItemButton = _G[self:GetDebugName().."ItemButton"]
	if not self.iLvl then
		self.iLvl = B.CreateFS(ItemButton, DB.Font[2]+1, "", false, "TOPLEFT", 1, -2)
	end
	if not self.iSlot then
		self.iSlot = B.CreateFS(ItemButton, DB.Font[2]+1, "", false, "BOTTOMRIGHT", 1, 1)
	end

	if link then
		local level = B.GetItemLevel(link)
		self.iLvl:SetText(level or "")

		local slot = B.GetItemSlot(link)
		self.iSlot:SetText(slot or "")
	end
end

function Misc.ItemLevel_UpdateTradePlayer(index)
	local button = _G["TradePlayerItem"..index]
	local link = GetTradePlayerItemLink(index)
	Misc.ItemLevel_UpdateItemButton(button, link)
end

function Misc.ItemLevel_UpdateTradeTarget(index)
	local button = _G["TradeRecipientItem"..index]
	local link = GetTradeTargetItemLink(index)
	Misc.ItemLevel_UpdateItemButton(button, link)
end

function Misc:ShowItemLevel()
	if not C.db["Misc"]["ItemLevel"] then return end

	-- iLvl on CharacterFrame
	CharacterFrame:HookScript("OnShow", Misc.ItemLevel_UpdatePlayer)
	B:RegisterEvent("PLAYER_EQUIPMENT_CHANGED", Misc.ItemLevel_UpdatePlayer)

	-- iLvl on InspectFrame
	B:RegisterEvent("INSPECT_READY", Misc.ItemLevel_UpdateInspect)

	-- iLvl on FlyoutButtons
	hooksecurefunc("EquipmentFlyout_DisplayButton", Misc.ItemLevel_FlyoutSetup)

	-- iLvl on ScrappingMachineFrame
	B:RegisterEvent("ADDON_LOADED", Misc.ItemLevel_ScrappingShow)

	-- iLvl on MerchantFrame
	hooksecurefunc("MerchantFrameItem_UpdateQuality", Misc.ItemLevel_UpdateItemButton)

	-- iLvl on TradeFrame
	hooksecurefunc("TradeFrame_UpdatePlayerItem", Misc.ItemLevel_UpdateTradePlayer)
	hooksecurefunc("TradeFrame_UpdateTargetItem", Misc.ItemLevel_UpdateTradeTarget)
end
Misc:RegisterMisc("GearInfo", Misc.ShowItemLevel)