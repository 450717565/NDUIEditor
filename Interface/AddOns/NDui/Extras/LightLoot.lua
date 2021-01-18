local _, ns = ...
local B, C, L, DB = unpack(ns)

local cr, cg, cb = DB.cr, DB.cg, DB.cb
local tL, tR, tT, tB = unpack(DB.TexCoord)

local iconSize = 33
local fontSize = math.floor(select(2, GameFontWhite:GetFont()) + .5)

local mover
local slots = {}

local LightLoot = CreateFrame("Button", "LightLoot")
LightLoot:SetClampRectInsets(0, 0, 14, 0)
LightLoot:SetHitRectInsets(0, 0, -14, 0)
LightLoot:RegisterForClicks("AnyUp")
LightLoot:SetFrameStrata("TOOLTIP")
LightLoot:SetClampedToScreen(true)
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
	button:SetHeight(math.max(fontSize, iconSize))
	button:SetPoint("LEFT", 5, 0)
	button:SetPoint("RIGHT", -5, 0)
	button:SetID(id)

	button:RegisterForClicks("LeftButtonUp", "RightButtonUp")
	button:SetScript("OnEnter", OnEnter)
	button:SetScript("OnLeave", OnLeave)
	button:SetScript("OnClick", OnClick)
	button:SetScript("OnUpdate", OnUpdate)

	local border = CreateFrame("Frame", nil, button, "BackdropTemplate")
	border:SetSize(iconSize, iconSize)
	border:SetPoint("LEFT", button)
	B.CreateBD(border, 1)
	button.border = border

	local icon = border:CreateTexture(nil, "ARTWORK")
	icon:SetTexCoord(tL, tR, tT, tB)
	icon:SetInside()
	button.icon = icon

	local glow = button:CreateTexture(nil, "ARTWORK")
	glow:SetPoint("TOPLEFT", icon, "TOPRIGHT", 3, 0)
	glow:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT")
	glow:SetTexture(DB.bgTex)
	glow:SetColorTexture(cr, cg, cb, .5)
	glow:Hide()
	button.glow = glow

	local count = B.CreateFS(border, 12)
	count:SetJustifyH("RIGHT")
	count:ClearAllPoints()
	count:SetPoint("BOTTOMRIGHT", border, "BOTTOMRIGHT", -1, 2)
	button.count = count

	local name = B.CreateFS(border, 14)
	name:SetJustifyH("LEFT")
	name:SetNonSpaceWrap(true)
	name:ClearAllPoints()
	name:SetPoint("LEFT", border, "RIGHT", 5, 0)
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

	self:SetWidth(math.max(maxWidth + 16 + iconSize, self.Title:GetStringWidth() + 5))
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

	self:SetHeight(math.max(shownSlots * iconSize + 10 + (shownSlots - 1) * 5 , iconSize))
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
		if not mover then
			mover = B.Mover(self, "LightLoot", "LightLoot", {"CENTER", 300, 0}, 50, 50)
		end
		self:ClearAllPoints()
		self:SetPoint("CENTER", mover)
	end

	local maxQuality = 0
	local items = GetNumLootItems()
	if items > 0 then
		for i = 1, items do
			local slot = slots[i] or CreateSlot(i)
			local lootIcon, lootName, lootQuantity, currencyID, lootQuality, isLocked, isQuestItem, questID, isActive = GetLootSlotInfo(i)

			if currencyID then
				lootName, lootIcon, lootQuantity, lootQuality = CurrencyContainerUtil.GetCurrencyContainerInfo(currencyID, lootQuantity, lootName, lootIcon, lootQuality)
			end

			local r, g, b = GetItemQualityColor(lootQuality or 1)

			if lootIcon and lootName then
				local slotType = GetLootSlotType(i)

				if slotType == LOOT_SLOT_MONEY then
					lootName = gsub(lootName, "\n", "，")
				end

				if lootQuantity and lootQuantity > 1 then
					slot.count:SetText(B.FormatNumb(lootQuantity))
					slot.count:Show()
				else
					slot.count:Hide()
				end

				if (lootQuality and lootQuality >= 0) or questId or isQuestItem then
					if questId or isQuestItem then
						r, g, b = 1, 1, 0
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

				maxQuality = math.max(maxQuality, lootQuality)

				slot:Enable()
				slot:Show()
			end
		end
	else
		local slot = slots[1] or CreateSlot(1)

		slot:Disable()
		slot:Hide()
	end

	local r, g, b = GetItemQualityColor(maxQuality or 1)
	self.bg:SetBackdropBorderColor(r, g, b)
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
	if not self:IsShown() or not slots[slot] then return end

	slots[slot]:Hide()
	self:AnchorSlots()
end
LightLoot:RegisterEvent("LOOT_SLOT_CLEARED")

function LightLoot:PLAYER_LOGIN()
	LightLoot.bg = B.CreateBG(LightLoot)
end
LightLoot:RegisterEvent("PLAYER_LOGIN")

LootFrame:UnregisterAllEvents()
table.insert(UISpecialFrames, "LightLoot")