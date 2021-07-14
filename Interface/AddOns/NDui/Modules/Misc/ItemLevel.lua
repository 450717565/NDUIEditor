local _, ns = ...
local B, C, L, DB = unpack(ns)
local MISC = B:GetModule("Misc")
local TT = B:GetModule("Tooltip")

local pairs, select, next, type, unpack = pairs, select, next, type, unpack
local UnitGUID, GetItemInfo, GetSpellInfo = UnitGUID, GetItemInfo, GetSpellInfo
local GetContainerItemLink, GetInventoryItemLink = GetContainerItemLink, GetInventoryItemLink
local EquipmentManager_UnpackLocation, EquipmentManager_GetItemInfoByLocation = EquipmentManager_UnpackLocation, EquipmentManager_GetItemInfoByLocation
local C_AzeriteEmpoweredItem_IsPowerSelected = C_AzeriteEmpoweredItem.IsPowerSelected

local slots = DB.Slots

function MISC:GetSlotAnchor(index, isIcon)
	if not index then return end

	if index <= 5 or index == 9 or index == 15 or index == 18 then
		if isIcon then
			return "BOTTOMLEFT", "BOTTOMRIGHT", 4, 2, "LEFT"
		else
			return "TOPLEFT", "TOPRIGHT", 4, -2, "LEFT"
		end
	elseif index == 16 then
		if isIcon then
			return "TOPRIGHT", "TOPLEFT", -4, -2, "RIGHT"
		else
			return "BOTTOMRIGHT", "BOTTOMLEFT", -4, 2, "RIGHT"
		end
	elseif index == 17 then
		if isIcon then
			return "TOPLEFT", "TOPRIGHT", 4, -2, "LEFT"
		else
			return "BOTTOMLEFT", "BOTTOMRIGHT", 4, 2, "LEFT"
		end
	else
		if isIcon then
			return "BOTTOMRIGHT", "BOTTOMLEFT", -4, 2, "RIGHT"
		else
			return "TOPRIGHT", "TOPLEFT", -4, -2, "RIGHT"
		end
	end
end

function MISC:CreateItemTexture(slot, relF, relT, x, y)
	local icon = slot:CreateTexture()
	icon:SetPoint(relF, slot, relT, x, y)
	icon:SetSize(14, 14)
	icon.icbg = B.ReskinIcon(icon)
	icon.icbg:SetFrameLevel(3)
	icon.icbg:Hide()

	return icon
end

function MISC:CreateItemString(frame, strType)
	if frame.fontCreated then return end

	for index, slot in pairs(slots) do
		if index ~= 4 or index ~= 18 then
			local slotFrame = _G[strType..slot.."Slot"]
			slotFrame.iLvlText = B.CreateFS(slotFrame, DB.Font[2]+1)
			B.UpdatePoint(slotFrame.iLvlText, "BOTTOM", slotFrame, "BOTTOM", 1, 1)

			local tp1, tp2, tx, ty, jh = MISC:GetSlotAnchor(index)
			slotFrame.enchantText = B.CreateFS(slotFrame, DB.Font[2]+1)
			slotFrame.enchantText:SetJustifyH(jh)
			B.UpdatePoint(slotFrame.enchantText, tp1, slotFrame, tp2, tx, ty)
			B.ReskinText(slotFrame.enchantText, 0, 1, 0)

			local ip1, ip2, ix, iy = MISC:GetSlotAnchor(index, true)
			for i = 1, 10 do
				local offset = (i-1)*18 + 3
				local iconX = ix > 0 and ix+offset or ix-offset
				local iconY = iy
				slotFrame["textureIcon"..i] = MISC:CreateItemTexture(slotFrame, ip1, ip2, iconX, iconY)
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

function MISC:ItemLevel_UpdateTraits(button, id, link)
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

function MISC:ItemLevel_UpdateInfo(slotFrame, info, quality)
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

function MISC:ItemLevel_RefreshInfo(link, unit, index, slotFrame)
	C_Timer.After(.1, function()
		local quality = select(3, GetItemInfo(link))
		local info = B.GetItemLevel(link, unit, index, C.db["Misc"]["GemNEnchant"])
		if info == "tooSoon" then return end
		MISC:ItemLevel_UpdateInfo(slotFrame, info, quality)
	end)
end

function MISC:ItemLevel_SetupInfo(frame, strType, unit)
	if not UnitExists(unit) then return end

	MISC:CreateItemString(frame, strType)

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
					MISC:ItemLevel_RefreshInfo(link, unit, index, slotFrame)
				else
					MISC:ItemLevel_UpdateInfo(slotFrame, info, quality)
				end

				if strType == "Character" then
					MISC:ItemLevel_UpdateTraits(slotFrame, index, link)
				end
			end
		end
	end
end

function MISC:ItemLevel_SetupItemInfo(button, link, size)
	local width = B.Round(button:GetWidth()*.35)

	if not self.iLvl then
		self.iLvl = B.CreateFS(button, size or width, "", false, "BOTTOMRIGHT", 1, 0)
	end
	if not self.iSlot then
		self.iSlot = B.CreateFS(button, size or width, "", false, "TOPLEFT", 0, -2)
	end

	self.iLvl:SetText("")
	self.iSlot:SetText("")

	if link then
		local level = B.GetItemLevel(link)
		self.iLvl:SetText(level or "")

		local slot = B.GetItemSlot(link)
		self.iSlot:SetText(slot or "")
	end
end

-- iLvl on CharacterFrame
function MISC:ItemLevel_SetupPlayer()
	MISC:ItemLevel_SetupInfo(CharacterFrame, "Character", "player")
end

-- iLvl on InspectFrame
function MISC:ItemLevel_SetupTarget(...)
	local guid = ...
	if InspectFrame and InspectFrame.unit and UnitGUID(InspectFrame.unit) == guid then
		MISC:ItemLevel_SetupInfo(InspectFrame, "Inspect", InspectFrame.unit)
	end
end

-- iLvl on Tooltip
function MISC:ItemLevel_SetupTooltip()
	local _, link = self:GetItem()
	if not link then return end

	local Icon = GameTooltip.ItemTooltip.Icon
	local size = B.Round(Icon:GetWidth()*.35)

	MISC.ItemLevel_SetupItemInfo(self, self, link, size)
	B.UpdatePoint(self.iLvl, "BOTTOMRIGHT", Icon, "BOTTOMRIGHT", 1, 0)
	B.UpdatePoint(self.iSlot, "TOPLEFT", Icon, "TOPLEFT", 0, -2)
end

-- iLvl on FlyoutButtons
function MISC:ItemLevel_UpdateFlyout(bag, slot, quality)
	if not self.iLvl then
		self.iLvl = B.CreateFS(self, DB.Font[2]+1)
	end

	self.iLvl:SetText("")

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

function MISC:ItemLevel_SetupFlyout()
	if self.iLvl then self.iLvl:SetText("") end

	local location = self.location
	if not location or location >= EQUIPMENTFLYOUT_FIRST_SPECIAL_LOCATION then return end

	local _, _, bags, voidStorage, slot, bag = EquipmentManager_UnpackLocation(location)
	if voidStorage then return end
	local quality = select(13, EquipmentManager_GetItemInfoByLocation(location))
	if bags then
		MISC.ItemLevel_UpdateFlyout(self, bag, slot, quality)
	else
		MISC.ItemLevel_UpdateFlyout(self, nil, slot, quality)
	end
end

-- iLvl on MerchantFrame
function MISC:ItemLevel_SetupMerchant(link)
	local ItemButton = B.GetObject(self, "ItemButton")
	MISC.ItemLevel_SetupItemInfo(self, ItemButton, link)
end

-- iLvl on TradeFrame
function MISC.ItemLevel_SetupTradePlayer(index)
	local button = _G["TradePlayerItem"..index]
	local link = GetTradePlayerItemLink(index)
	MISC.ItemLevel_SetupMerchant(button, link)
end

function MISC.ItemLevel_SetupTradeTarget(index)
	local button = _G["TradeRecipientItem"..index]
	local link = GetTradeTargetItemLink(index)
	MISC.ItemLevel_SetupMerchant(button, link)
end

-- iLvl on ScrappingMachineFrame
function MISC:ItemLevel_UpdateScrapMachine()
	MISC.ItemLevel_SetupItemInfo(self, self, self.itemLink)
end

function MISC:ItemLevel_SetupScrapMachine()
	for button in pairs(ScrappingMachineFrame.ItemSlots.scrapButtons.activeObjects) do
		hooksecurefunc(button, "RefreshIcon", MISC.ItemLevel_UpdateScrapMachine)
	end
end

-- iLvl on EncounterJournal
function MISC:ItemLevel_UpdateEJLoot()
	self.slot:SetText("")

	local itemInfo = C_EncounterJournal.GetLootInfoByIndex(self.index)
	if itemInfo and itemInfo.link then
		local info = ""
		local slot = B.GetItemSlot(itemInfo.link)
		local level = B.GetItemLevel(itemInfo.link)

		if slot and level then
			info = slot.." "..level
		elseif slot then
			info = slot
		elseif level then
			info = level
		end

		self.slot:SetText(info)
	end
end

function MISC:ItemLevel_SetupEJLoot()
	hooksecurefunc("EncounterJournal_SetLootButton", MISC.ItemLevel_UpdateEJLoot)
end

-- iLvl on GuildBank
function MISC:ItemLevel_UpdateGuildBank()
	if GuildBankFrame.mode == "bank" then
		local tab = GetCurrentGuildBankTab()
		local button, index, column, link
		for i = 1, MAX_GUILDBANK_SLOTS_PER_TAB do
			index = mod(i, NUM_SLOTS_PER_GUILDBANK_GROUP)
			if index == 0 then
				index = NUM_SLOTS_PER_GUILDBANK_GROUP
			end
			column = ceil((i-0.5)/NUM_SLOTS_PER_GUILDBANK_GROUP)
			button = _G["GuildBankColumn"..column.."Button"..index]
			link = GetGuildBankItemLink(tab, i)

			MISC.ItemLevel_SetupItemInfo(button, button, link)
		end
	end
end

function MISC:ItemLevel_SetupGuildBank()
	hooksecurefunc("GuildBankFrame_Update", MISC.ItemLevel_UpdateGuildBank)
end

-- iLvl on GuildNews
local itemCache = {}
function MISC.ItemLevel_UpdateGuildNews(button, text_color, text, text1, text2, ...)
	if text2 and type(text2) == "string" then
		local link = string.match(text2, "(|Hitem:%d+:.-|h.-|h)")
		if link then
			local slot = B.GetItemSlot(link)
			local level = B.GetItemLevel(link)
			local info = itemCache[link] or "<"..level..(slot and "-"..slot or "")..">"

			if info then
				itemCache[link] = info
				text2 = text2:gsub("(%|Hitem:%d+:.-%|h%[)(.-)(%]%|h)", "%1"..info.."%2%3")
				button.text:SetFormattedText(text, text1, text2, ...)
			end
		end
	end
end

function MISC.ItemLevel_SetupGuildNews()
	hooksecurefunc("GuildNewsButton_SetText", MISC.ItemLevel_UpdateGuildNews)
end

function MISC:ShowItemLevel()
	if not C.db["Misc"]["ItemLevel"] then return end

	-- iLvl on CharacterFrame
	CharacterFrame:HookScript("OnShow", MISC.ItemLevel_SetupPlayer)
	B:RegisterEvent("PLAYER_EQUIPMENT_CHANGED", MISC.ItemLevel_SetupPlayer)

	-- iLvl on InspectFrame
	B:RegisterEvent("INSPECT_READY", MISC.ItemLevel_SetupTarget)

	-- iLvl on Tooltip
	GameTooltipTooltip:HookScript("OnTooltipSetItem", MISC.ItemLevel_SetupTooltip)
	EmbeddedItemTooltip:HookScript("OnTooltipSetItem", MISC.ItemLevel_SetupTooltip)

	-- iLvl on FlyoutButtons
	hooksecurefunc("EquipmentFlyout_DisplayButton", MISC.ItemLevel_SetupFlyout)

	-- iLvl on MerchantFrame
	hooksecurefunc("MerchantFrameItem_UpdateQuality", MISC.ItemLevel_SetupMerchant)

	-- iLvl on TradeFrame
	hooksecurefunc("TradeFrame_UpdatePlayerItem", MISC.ItemLevel_SetupTradePlayer)
	hooksecurefunc("TradeFrame_UpdateTargetItem", MISC.ItemLevel_SetupTradeTarget)

	-- iLvl on ScrappingMachineFrame
	B.LoadWithAddOn("Blizzard_ScrappingMachineUI", MISC.ItemLevel_SetupScrapMachine)

	-- iLvl on EncounterJournal
	B.LoadWithAddOn("Blizzard_EncounterJournal", MISC.ItemLevel_SetupEJLoot)

	-- iLvl on GuildBank
	B.LoadWithAddOn("Blizzard_GuildBankUI", MISC.ItemLevel_SetupGuildBank)

	-- iLvl on GuildNews
	B.LoadWithAddOn("Blizzard_GuildUI", MISC.ItemLevel_SetupGuildNews)
	B.LoadWithAddOn("Blizzard_Communities", MISC.ItemLevel_SetupGuildNews)
end
MISC:RegisterMisc("GearInfo", MISC.ShowItemLevel)