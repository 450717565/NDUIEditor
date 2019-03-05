local B, C, L, DB = unpack(select(2, ...))

local tbinsert = table.insert
local mmax, mfloor = math.max, math.floor

local iconSize = 33

local fontSize = mfloor(select(2, GameFontWhite:GetFont()) + .5)

local point = {"CENTER", 300, 0}
local slots = {}

local LightLoot = CreateFrame("Button", "LightLoot")
LightLoot:RegisterForClicks("AnyUp")
LightLoot:SetClampedToScreen(true)
LightLoot:SetClampRectInsets(0, 0, 14, 0)
LightLoot:SetFrameStrata("TOOLTIP")
LightLoot:SetHitRectInsets(0, 0, -14, 0)
LightLoot:SetMovable(true)
LightLoot:SetParent(UIParent)
LightLoot:SetToplevel(true)

LightLoot:SetScript("OnEvent", function(self, event, ...)
	self[event](self, event, ...)
end)

LightLoot:SetScript("OnHide", function(self)
	StaticPopup_Hide("CONFIRM_LOOT_DISTRIBUTION")
	CloseLoot()
end)

local Title = B.CreateFS(LightLoot, 18, "", false, "TOPLEFT", 4, 20)
LightLoot.Title = Title

local function OnEnter(self)
	local slot = self:GetID()
	if GetLootSlotType(slot) == LOOT_SLOT_ITEM then
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetLootItem(slot)
		CursorUpdate(self)
	end
	self.glow:Show()
end

local function OnLeave(self)
	self.glow:Hide()
	GameTooltip:Hide()
	ResetCursor()
end

local function OnClick(self)
	if IsModifiedClick() then
		HandleModifiedItemClick(GetLootSlotLink(self:GetID()))
	else
		StaticPopup_Hide("CONFIRM_LOOT_DISTRIBUTION")

		LootFrame.selectedLootButton = self
		LootFrame.selectedSlot = self:GetID()
		LootFrame.selectedQuality = self.lootQuality
		LootFrame.selectedItemName = self.name:GetText()

		LootSlot(self:GetID())
	end
end

local function OnUpdate(self)
	if GameTooltip:IsOwned(self) then
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetLootItem(self:GetID())
		CursorOnUpdate(self)
	end
end

local function CreateSlot(id)
	local button = CreateFrame("Button", "LightLootSlot"..id, LightLoot)
	button:SetHeight(mmax(fontSize, iconSize))
	button:SetPoint("LEFT", 5, 0)
	button:SetPoint("RIGHT", -5, 0)
	button:SetID(id)

	button:RegisterForClicks("LeftButtonUp", "RightButtonUp")
	button:SetScript("OnEnter", OnEnter)
	button:SetScript("OnLeave", OnLeave)
	button:SetScript("OnClick", OnClick)
	button:SetScript("OnUpdate", OnUpdate)

	local border = CreateFrame("Frame", nil, button)
	border:SetSize(iconSize, iconSize)
	border:SetPoint("LEFT", button)
	B.CreateBD(border, 1)
	button.border = border

	local icon = border:CreateTexture(nil, "ARTWORK")
	icon:SetAlpha(.8)
	icon:SetTexCoord(unpack(DB.TexCoord))
	icon:SetPoint("TOPLEFT", C.mult, -C.mult)
	icon:SetPoint("BOTTOMRIGHT", -C.mult, C.mult)
	button.icon = icon

	local glow = button:CreateTexture(nil, "ARTWORK")
	glow:SetPoint("TOPLEFT", icon, "TOPRIGHT", 3, 0)
	glow:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT")
	glow:SetTexture(DB.bdTex)
	glow:SetVertexColor(DB.r, DB.g, DB.b, .5)
	glow:Hide()
	button.glow = glow

	local count = B.CreateFS(border, 14, "")
	count:SetJustifyH("RIGHT")
	count:ClearAllPoints()
	count:SetPoint("BOTTOMRIGHT", border, "BOTTOMRIGHT", -C.mult, C.mult)
	button.count = count

	local name = B.CreateFS(border, 14, "")
	name:SetJustifyH("LEFT")
	name:ClearAllPoints()
	name:SetPoint("LEFT", border, "RIGHT", 5, 0)
	name:SetNonSpaceWrap(true)
	button.name = name

	slots[id] = button
	return button
end

function LightLoot:UpdateWidth()
	local maxWidth = 0
	for _, slot in pairs(slots) do
		if slot:IsShown() then
			local width = slot.name:GetStringWidth()
			if width > maxWidth then
				maxWidth = width
			end
		end
	end

	self:SetWidth(mmax(maxWidth + 16 + iconSize, self.Title:GetStringWidth() + 5))
end

function LightLoot:AnchorSlots()
	local shownSlots = 0

	for i = 1, #slots do
		local button = slots[i]
		if button:IsShown() then
			shownSlots = shownSlots + 1
			button:SetPoint("TOP", LightLoot, 0, (-5 + iconSize) - (shownSlots * iconSize) - (shownSlots - 1) * 5)
		end
	end

	self:SetHeight(mmax(shownSlots * iconSize + 10 + (shownSlots - 1) * 5 , iconSize))
end

function LightLoot:LOOT_OPENED(event, autoloot)
	self:Show()

	if not self:IsShown() then
		CloseLoot(not autoLoot)
	end

	if IsFishingLoot() then
		self.Title:SetText(PROFESSIONS_FISHING)
	elseif UnitIsDead("target") then
		self.Title:SetText(UnitName("target"))
	else
		self.Title:SetText(LOOT)
	end

	if GetCVar("lootUnderMouse") == "1" then
		local x, y = GetCursorPosition()
		x = x / self:GetEffectiveScale()
		y = y / self:GetEffectiveScale()

		self:ClearAllPoints()
		self:SetPoint("TOPLEFT", nil, "BOTTOMLEFT", x - 40, y + 20)
		self:GetCenter()
		self:Raise()
	else
		self:ClearAllPoints()
		self:SetUserPlaced(false)
		self:SetPoint(unpack(point))
	end

	local maxQuality = 0
	local items = GetNumLootItems()
	if items > 0 then
		for i = 1, items do
			local slot = slots[i] or CreateSlot(i)
			local lootIcon, lootName, lootQuantity, currencyID, lootQuality, locked, isQuestItem, questID, isActive = GetLootSlotInfo(i)
			if lootIcon then
				local color = BAG_ITEM_QUALITY_COLORS[lootQuality or 1]
				local r, g, b = color.r, color.g, color.b
				local slotType = GetLootSlotType(i)

				if slotType == LOOT_SLOT_MONEY then
					lootName = lootName:gsub("\n", L[","])
				end

				if lootQuantity and lootQuantity > 1 then
					slot.count:SetText(B.Numb(lootQuantity))
					slot.count:Show()
				else
					slot.count:Hide()
				end

				if (lootQuality and lootQuality >= 0) or questId or isQuestItem then
					if questId or isQuestItem then
						r, g, b = .8, .8, 0
					end
					slot.name:SetTextColor(r, g, b)
					slot.border:SetBackdropBorderColor(r, g, b)
				else
					slot.name:SetTextColor(.5, .5, .5)
					slot.border:SetBackdropBorderColor(.5, .5, .5)
				end

				slot.lootQuality = lootQuality
				slot.isQuestItem = isQuestItem

				slot.name:SetText(lootName)
				slot.icon:SetTexture(lootIcon)

				maxQuality = mmax(maxQuality, lootQuality)

				slot:Enable()
				slot:Show()
			end
		end
	else
		local slot = slots[1] or CreateSlot(1)

		slot.border:Hide()
		slot.count:Hide()
		slot.glow:Hide()
		slot.icon:Hide()
		slot.name:Hide()

		slot:Disable()
		slot:Show()
	end

	local color = BAG_ITEM_QUALITY_COLORS[maxQuality or 1]
	local r, g, b = color.r, color.g, color.b
	self:SetBackdropBorderColor(r, g, b)
	self.Title:SetTextColor(r, g, b)

	self:AnchorSlots()
	self:UpdateWidth()
end
LightLoot:RegisterEvent("LOOT_OPENED")

function LightLoot:LOOT_CLOSED()
	StaticPopup_Hide("LOOT_BIND")
	self:Hide()

	for _, v in pairs(slots) do
		v:Hide()
	end
end
LightLoot:RegisterEvent("LOOT_CLOSED")

function LightLoot:LOOT_SLOT_CLEARED(event, slot)
	if not self:IsShown() then return end

	slots[slot]:Hide()
	self:AnchorSlots()
end
LightLoot:RegisterEvent("LOOT_SLOT_CLEARED")

function LightLoot:PLAYER_LOGIN()
	B.SetBackground(LightLoot)
end
LightLoot:RegisterEvent("PLAYER_LOGIN")

LootFrame:UnregisterAllEvents()
tbinsert(UISpecialFrames, "LightLoot")