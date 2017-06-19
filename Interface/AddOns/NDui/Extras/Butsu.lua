if not IsAddOnLoaded("NDui") then return end

local B, C, L, DB = unpack(select(2, ...))

local sQuality, sID, sName
local fish, empty = "钓鱼", "没有物品"
local iconSize = 33
local fontType = {DB.Font[1], DB.Font[2]+2, DB.Font[3]}
local addonPoint = {"CENTER", 300, 0}

local addon = CreateFrame("Button", "Butsu")
local title = B.CreateFS(addon, 18, "", true, "TOPLEFT", 4, 20)
if IsAddOnLoaded("Aurora") then
	local F = unpack(Aurora)
	F.CreateBD(addon)
	F.CreateSD(addon)
else
	B.CreateMF(addon)
	B.CreateBD(addon)
	B.CreateTex(addon)
end
addon:RegisterForClicks("AnyUp")
addon:SetParent(UIParent)
addon:SetWidth(256)
addon:SetHeight(64)
addon:SetClampedToScreen(true)
addon:SetClampRectInsets(0, 0, 14, 0)
addon:SetHitRectInsets(0, 0, -14, 0)
addon:SetFrameStrata("HIGH")
addon:SetToplevel(true)
addon:SetScript("OnHide", function(self)
	StaticPopup_Hide("CONFIRM_LOOT_DISTRIBUTION")
	CloseLoot()
end)

local OnEnter = function(self)
	self.glow:Show()
	local slot = self:GetID()
	if (GetLootSlotType(slot) == LOOT_SLOT_ITEM) then
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetLootItem(slot)
		CursorUpdate(self)
	end
	LootFrame.selectedSlot = self:GetID()
end

local OnLeave = function(self)
	self.glow:Hide()
	GameTooltip_Hide()
	ResetCursor()
end

local OnClick = function(self)
	if (IsModifiedClick()) then
		HandleModifiedItemClick(GetLootSlotLink(self:GetID()))
	else
		StaticPopup_Hide("CONFIRM_LOOT_DISTRIBUTION")
		sID = self:GetID()
		sQuality = self.lootQuality
		sName = self.name:GetText()
		LootSlot(sID)
	end
end

local OnUpdate = function(self)
	if (GameTooltip:IsOwned(self)) then
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetLootItem(self:GetID())
		CursorOnUpdate(self)
	end
end

local createSlot = function(id)
	local iconsize = iconSize
	local frame = CreateFrame("Button", "ButsuSlot"..id, addon)
	frame:SetPoint("LEFT", 5, 0)
	frame:SetPoint("RIGHT", -5, 0)
	frame:SetHeight(iconsize)
	frame:SetID(id)

	frame:RegisterForClicks("LeftButtonUp", "RightButtonUp")

	frame:SetScript("OnEnter", OnEnter)
	frame:SetScript("OnLeave", OnLeave)
	frame:SetScript("OnClick", OnClick)
	frame:SetScript("OnUpdate", OnUpdate)

	local iconFrame = CreateFrame("Frame", tostring(frame:GetName()).."IconFrame", frame)
	iconFrame:SetHeight(iconsize)
	iconFrame:SetWidth(iconsize)
	iconFrame:ClearAllPoints()
	iconFrame:SetPoint("LEFT", frame)
	B.CreateBB(iconFrame)
	frame.iconFrame = iconFrame

	local icon = iconFrame:CreateTexture(nil, "ARTWORK")
	icon:SetAlpha(.8)
	icon:SetTexCoord(.07, .93, .07, .93)
	icon:SetPoint("TOPLEFT", 1, -1)
	icon:SetPoint("BOTTOMRIGHT", -1, 1)
	frame.icon = icon

	local count = iconFrame:CreateFontString(nil, "OVERLAY")
	count:ClearAllPoints()
	count:SetJustifyH"RIGHT"
	count:SetPoint("BOTTOMRIGHT", iconFrame, -2, 2)
	count:SetFont(unpack(fontType))
	count:SetShadowOffset(1, 1)
	count:SetShadowColor(.3, .3, .3, .7)
	count:SetText(1)
	frame.count = count

	local name = frame:CreateFontString(nil, "OVERLAY")
	name:SetJustifyH("LEFT")
	name:ClearAllPoints()
	name:SetPoint("RIGHT", frame)
	name:SetPoint("LEFT", icon, "RIGHT", 5, 0)
	name:SetNonSpaceWrap(true)
	name:SetFont(unpack(fontType))
	name:SetShadowOffset(1, -1)
	name:SetShadowColor(.3, .3, .3, .7)
	frame.name = name

	local glow = frame:CreateTexture(nil, "ARTWORK")
	glow:SetAlpha(.5)
	glow:SetPoint("TOPLEFT", icon, "TOPRIGHT", 2, 0)
	glow:SetPoint("BOTTOMRIGHT", frame)
	glow:SetTexture("Interface\\Buttons\\WHITE8x8")
	glow:SetVertexColor(1, 1, 0)
	glow:Hide()
	frame.glow = glow

	addon.slots[id] = frame
	return frame
end

local anchorSlots = function(self)
	local iconsize = iconSize
	local shownSlots = 0
	for i=1, #self.slots do
		local frame = self.slots[i]
		if frame:IsShown() then
			shownSlots = shownSlots + 1
			frame:SetPoint("TOP", addon, 0, (-5 + iconsize) - (shownSlots * iconsize) - (shownSlots - 1) * 5)
		end
	end

	self:SetHeight(math.max(shownSlots * iconsize + 10 + (shownSlots - 1) * 5 , iconsize))
end

addon.slots = {}
addon.LOOT_OPENED = function(self, event, autoloot)
	self:Show()

	if not self:IsShown() then
		CloseLoot(not autoLoot)
	end

	local items = GetNumLootItems()

	if IsFishingLoot() then
		title:SetText(fish)
	elseif UnitIsDead("target") and (not UnitIsFriend("player", "target")) then
		title:SetText(UnitName("target"))
	else
		title:SetText(LOOT)
	end

	-- Blizzard uses strings here
	if GetCVar("lootUnderMouse") == "1" then
		local x, y = GetCursorPosition()
		x = x / self:GetEffectiveScale()
		y = y / self:GetEffectiveScale()

		self:ClearAllPoints()
		self:SetPoint("TOPLEFT", nil, "BOTTOMLEFT", x-40, y+20)
		self:GetCenter()
		self:Raise()
	else
		self:ClearAllPoints()
		self:SetUserPlaced(false)
		self:SetPoint(unpack(addonPoint))
	end

	local w, t = 0, title:GetStringWidth()
	if items ~= nil and items > 0 then
		for i=1, items do
			local slot = addon.slots[i] or createSlot(i)
			local lootIcon, lootName, lootQuantity, lootQuality, locked, isQuestItem, questID, isActive = GetLootSlotInfo(i)
			local color = BAG_ITEM_QUALITY_COLORS[lootQuality]

			if (GetLootSlotType(i) == LOOT_SLOT_MONEY) then
				lootName = lootName:gsub("\n", ", ")
			end

			if lootQuantity and lootQuantity > 1 then
				slot.count:SetText(lootQuantity)
				slot.count:Show()
			else
				slot.count:Hide()
			end

			if lootQuality and lootQuality >= 0 then
				slot.iconFrame:SetBackdropBorderColor(color.r, color.g, color.b)
				slot.name:SetTextColor(color.r, color.g, color.b)
				slot.lootQuality = lootQuality
			else
				slot.iconFrame:SetBackdropBorderColor(0, 0, 0)
				slot.name:SetTextColor(0, 0, 0)
			end

			slot.name:SetText(lootName)
			slot.icon:SetTexture(lootIcon)

			w = math.max(w, slot.name:GetStringWidth())

			slot:Enable()
			slot:Show()
		end
	else
		local slot = addon.slots[1] or createSlot(1)

		slot.name:SetText(empty)
		slot.name:SetTextColor(1, 1, 1)
		slot.icon:SetTexture(nil)

		items = 1

		w = slot.name:GetStringWidth()

		slot.count:Hide()
		slot:Disable()
		slot:Show()
	end
	anchorSlots(self)

	w = w + 50
	t = t + 15

	self:SetWidth(math.max(w, t))
end

addon.LOOT_SLOT_CLEARED = function(self, event, slot)
	if not self:IsShown() then return end

	addon.slots[slot]:Hide()
	anchorSlots(self)
end

addon.LOOT_CLOSED = function(self)
	StaticPopup_Hide("LOOT_BIND")
	self:Hide()

	for _, v in pairs(self.slots) do
		v:Hide()
	end
end

addon.OPEN_MASTER_LOOT_LIST = function(self)
	ToggleDropDownMenu(1, nil, GroupLootDropDown, addon.slots[sID], 0, 0)
end

addon.UPDATE_MASTER_LOOT_LIST = function(self)
	UIDropDownMenu_Refresh(GroupLootDropDown)
end

addon:SetScript("OnEvent", function(self, event, ...)
	self[event](self, event, ...)
end)

addon:RegisterEvent("LOOT_OPENED")
addon:RegisterEvent("LOOT_SLOT_CLEARED")
addon:RegisterEvent("LOOT_CLOSED")
addon:RegisterEvent("OPEN_MASTER_LOOT_LIST")
addon:RegisterEvent("UPDATE_MASTER_LOOT_LIST")
addon:Hide()

-- Fuzz
LootFrame:UnregisterAllEvents()
table.insert(UISpecialFrames, "Butsu")

function _G.GroupLootDropDown_GiveLoot(self)
	if sQuality >= MASTER_LOOT_THREHOLD then
		local dialog = StaticPopup_Show("CONFIRM_LOOT_DISTRIBUTION", BAG_ITEM_QUALITY_COLORS[sQuality].hex..sName..FONT_COLOR_CODE_CLOSE, self:GetText())
		if (dialog) then
			dialog.data = self.value
		end
	else
		GiveMasterLoot(sID, self.value)
	end
	CloseDropDownMenus()
end

StaticPopupDialogs["CONFIRM_LOOT_DISTRIBUTION"].OnAccept = function(self, data)
	GiveMasterLoot(sID, data)
end