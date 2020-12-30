﻿local _, ns = ...
local B, C, L, DB = unpack(ns)

local Bags = B:RegisterModule("Bags")
local cargBags = ns.cargBags
local ipairs, strmatch, unpack, ceil = ipairs, string.match, unpack, math.ceil
local LE_ITEM_QUALITY_POOR, LE_ITEM_QUALITY_RARE, LE_ITEM_QUALITY_HEIRLOOM = LE_ITEM_QUALITY_POOR, LE_ITEM_QUALITY_RARE, LE_ITEM_QUALITY_HEIRLOOM
local LE_ITEM_CLASS_WEAPON, LE_ITEM_CLASS_ARMOR, LE_ITEM_CLASS_CONTAINER = LE_ITEM_CLASS_WEAPON, LE_ITEM_CLASS_ARMOR, LE_ITEM_CLASS_CONTAINER
local SortBankBags, SortReagentBankBags, SortBags = SortBankBags, SortReagentBankBags, SortBags
local GetContainerNumSlots, GetContainerItemInfo, PickupContainerItem = GetContainerNumSlots, GetContainerItemInfo, PickupContainerItem
local C_NewItems_IsNewItem, C_NewItems_RemoveNewItem, C_Timer_After = C_NewItems.IsNewItem, C_NewItems.RemoveNewItem, C_Timer.After
local C_AzeriteEmpoweredItem_IsAzeriteEmpoweredItemByID = C_AzeriteEmpoweredItem.IsAzeriteEmpoweredItemByID
local C_Soulbinds_IsItemConduitByItemInfo = C_Soulbinds.IsItemConduitByItemInfo
local IsCosmeticItem = IsCosmeticItem
local IsControlKeyDown, IsAltKeyDown, DeleteCursorItem = IsControlKeyDown, IsAltKeyDown, DeleteCursorItem
local GetItemInfo, GetContainerItemID, SplitContainerItem = GetItemInfo, GetContainerItemID, SplitContainerItem
local cr, cg, cb = DB.r, DB.g, DB.b

local sortCache = {}
function Bags:ReverseSort()
	for bag = 0, 4 do
		local numSlots = GetContainerNumSlots(bag)
		for slot = 1, numSlots do
			local texture, _, locked = GetContainerItemInfo(bag, slot)
			if (slot <= numSlots/2) and texture and not locked and not sortCache["b"..bag.."s"..slot] then
				PickupContainerItem(bag, slot)
				PickupContainerItem(bag, numSlots+1 - slot)
				sortCache["b"..bag.."s"..slot] = true
			end
		end
	end

	Bags.Bags.isSorting = false
	Bags:UpdateAllBags()
end

function Bags:UpdateAnchors(parent, bags)
	local anchor = parent
	for _, bag in ipairs(bags) do
		if bag:GetHeight() > 45 then
			bag:Show()
		else
			bag:Hide()
		end
		if bag:IsShown() then
			bag:SetPoint("BOTTOMLEFT", anchor, "TOPLEFT", 0, 5)
			anchor = bag
		end
	end
end

local function highlightFunction(button, match)
	button:SetAlpha(match and 1 or .25)
end

function Bags:CreateInfoFrame()
	local infoFrame = CreateFrame("Button", nil, self)
	infoFrame:SetPoint("TOPLEFT", 10, 0)
	infoFrame:SetSize(160, 32)

	local icon = infoFrame:CreateTexture()
	icon:SetSize(24, 24)
	icon:SetPoint("LEFT")
	icon:SetTexture("Interface\\Minimap\\Tracking\\None")
	icon:SetTexCoord(1, 0, 0, 1)

	local search = self:SpawnPlugin("SearchBar", infoFrame)
	search.highlightFunction = highlightFunction
	search.isGlobal = true
	search:SetPoint("LEFT", 0, 5)
	search:DisableDrawLayer("BACKGROUND")
	B.CreateBGFrame(search, -5, -5, 5, 5)

	local tag = self:SpawnPlugin("TagDisplay", "[money]", infoFrame)
	tag:SetFont(unpack(DB.Font))
	tag:SetPoint("LEFT", icon, "RIGHT", 5, 0)
end

function Bags:CreateBagBar(settings, columns)
	local bagBar = self:SpawnPlugin("BagBar", settings.Bags)
	local width, height = bagBar:LayoutButtons("grid", columns, 5, 5, -5)
	bagBar:SetSize(width + 10, height + 10)
	bagBar:SetPoint("TOPRIGHT", self, "BOTTOMRIGHT", 0, -5)
	B.CreateBG(bagBar)
	bagBar.highlightFunction = highlightFunction
	bagBar.isGlobal = true
	bagBar:Hide()

	self.BagBar = bagBar
end

function Bags:CreateCloseButton()
	local bu = B.CreateButton(self, 24, 24, true, "Interface\\RAIDFRAME\\ReadyCheck-NotReady")
	bu:SetScript("OnClick", CloseAllBags)
	bu.title = CLOSE
	B.AddTooltip(bu, "ANCHOR_TOP")

	return bu
end

function Bags:CreateRestoreButton(f)
	local bu = B.CreateButton(self, 24, 24, true, "Atlas:transmog-icon-revert")
	bu:SetScript("OnClick", function()
		C.db["TempAnchor"][f.main:GetDebugName()] = nil
		C.db["TempAnchor"][f.bank:GetDebugName()] = nil
		C.db["TempAnchor"][f.reagent:GetDebugName()] = nil
		f.main:ClearAllPoints()
		f.main:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -100, 200)
		f.bank:ClearAllPoints()
		f.bank:SetPoint("TOPRIGHT", f.main, "TOPLEFT", -25, 0)
		f.reagent:ClearAllPoints()
		f.reagent:SetPoint("BOTTOMLEFT", f.bank)
		PlaySound(SOUNDKIT.IG_MINIMAP_OPEN)
	end)
	bu.title = RESET
	B.AddTooltip(bu, "ANCHOR_TOP")

	return bu
end

function Bags:CreateReagentButton(f)
	local bu = B.CreateButton(self, 24, 24, true, "Interface\\Icons\\INV_MISC_RUNE_08")
	bu:RegisterForClicks("AnyUp")
	bu:SetScript("OnClick", function(_, btn)
		if not IsReagentBankUnlocked() then
			StaticPopup_Show("CONFIRM_BUY_REAGENTBANK_TAB")
		else
			PlaySound(SOUNDKIT.IG_CHARACTER_INFO_TAB)
			ReagentBankFrame:Show()
			BankFrame.selectedTab = 2
			f.reagent:Show()
			f.bank:Hide()
			if btn == "RightButton" then DepositReagentBank() end
		end
	end)
	bu.title = REAGENT_BANK
	B.AddTooltip(bu, "ANCHOR_TOP")

	return bu
end

function Bags:CreateBankButton(f)
	local bu = B.CreateButton(self, 24, 24, true, "Atlas:Banker")
	bu:SetScript("OnClick", function()
		PlaySound(SOUNDKIT.IG_CHARACTER_INFO_TAB)
		ReagentBankFrame:Hide()
		BankFrame.selectedTab = 1
		f.reagent:Hide()
		f.bank:Show()
	end)
	bu.title = BANK
	B.AddTooltip(bu, "ANCHOR_TOP")

	return bu
end

local function updateDepositButtonStatus(bu)
	if C.db["Bags"]["AutoDeposit"] then
		bu.icbg:SetBackdropBorderColor(cr, cg, cb)
	else
		bu.icbg:SetBackdropBorderColor(0, 0, 0)
	end
end

function Bags:AutoDeposit()
	if C.db["Bags"]["AutoDeposit"] then
		DepositReagentBank()
	end
end

function Bags:CreateDepositButton()
	local bu = B.CreateButton(self, 24, 24, true, "Atlas:GreenCross")
	bu.Icon:SetOutside()
	bu:RegisterForClicks("AnyUp")
	bu:SetScript("OnClick", function(_, btn)
		if btn == "RightButton" then
			C.db["Bags"]["AutoDeposit"] = not C.db["Bags"]["AutoDeposit"]
			updateDepositButtonStatus(bu)
		else
			DepositReagentBank()
		end
	end)
	bu.title = REAGENTBANK_DEPOSIT
	B.AddTooltip(bu, "ANCHOR_TOP", DB.InfoColor..L["AutoDepositTip"])
	updateDepositButtonStatus(bu)

	return bu
end

function Bags:CreateBagToggle()
	local bu = B.CreateButton(self, 24, 24, true, "Interface\\Icons\\INV_Misc_Bag_08")
	bu:SetScript("OnClick", function()
		B.TogglePanel(self.BagBar)
		if self.BagBar:IsShown() then
			bu.icbg:SetBackdropBorderColor(cr, cg, cb)
			PlaySound(SOUNDKIT.IG_BACKPACK_OPEN)
		else
			bu.icbg:SetBackdropBorderColor(0, 0, 0)
			PlaySound(SOUNDKIT.IG_BACKPACK_CLOSE)
		end
	end)
	bu.title = BACKPACK_TOOLTIP
	B.AddTooltip(bu, "ANCHOR_TOP")

	return bu
end

function Bags:CreateSortButton(name)
	local bu = B.CreateButton(self, 24, 24, true, "Interface\\Icons\\INV_Pet_Broom")
	bu:SetScript("OnClick", function()
		if C.db["Bags"]["BagSortMode"] == 3 then
			UIErrorsFrame:AddMessage(DB.InfoColor..L["BagSortDisabled"])
			return
		end

		if name == "Bank" then
			SortBankBags()
		elseif name == "Reagent" then
			SortReagentBankBags()
		else
			if C.db["Bags"]["BagSortMode"] == 1 then
				SortBags()
			elseif C.db["Bags"]["BagSortMode"] == 2 then
				if InCombatLockdown() then
					UIErrorsFrame:AddMessage(DB.InfoColor..ERR_NOT_IN_COMBAT)
				else
					SortBags()
					wipe(sortCache)
					Bags.Bags.isSorting = true
					C_Timer_After(.5, Bags.ReverseSort)
				end
			end
		end
	end)
	bu.title = L["Sort"]
	B.AddTooltip(bu, "ANCHOR_TOP")

	return bu
end

function Bags:GetContainerEmptySlot(bagID)
	for slotID = 1, GetContainerNumSlots(bagID) do
		if not GetContainerItemID(bagID, slotID) then
			return slotID
		end
	end
end

function Bags:GetEmptySlot(name)
	if name == "Main" then
		for bagID = 0, 4 do
			local slotID = Bags:GetContainerEmptySlot(bagID)
			if slotID then
				return bagID, slotID
			end
		end
	elseif name == "Bank" then
		local slotID = Bags:GetContainerEmptySlot(-1)
		if slotID then
			return -1, slotID
		end
		for bagID = 5, 11 do
			local slotID = Bags:GetContainerEmptySlot(bagID)
			if slotID then
				return bagID, slotID
			end
		end
	elseif name == "Reagent" then
		local slotID = Bags:GetContainerEmptySlot(-3)
		if slotID then
			return -3, slotID
		end
	end
end

function Bags:FreeSlotOnDrop()
	local bagID, slotID = Bags:GetEmptySlot(self.__name)
	if slotID then
		PickupContainerItem(bagID, slotID)
	end
end

local freeSlotContainer = {
	["Main"] = true,
	["Bank"] = true,
	["Reagent"] = true,
}

function Bags:CreateFreeSlots()
	local name = self.name
	if not freeSlotContainer[name] then return end

	local slot = CreateFrame("Button", name.."FreeSlot", self)
	local bubg = B.CreateBDFrame(slot)
	B.ReskinHighlight(slot, bubg)

	slot:SetSize(self.iconSize, self.iconSize)
	slot:SetScript("OnMouseUp", Bags.FreeSlotOnDrop)
	slot:SetScript("OnReceiveDrag", Bags.FreeSlotOnDrop)
	B.AddTooltip(slot, "ANCHOR_RIGHT", L["FreeSlots"])
	slot.__name = name

	local tag = self:SpawnPlugin("TagDisplay", "[space]", slot)
	tag:SetFont(DB.Font[1], DB.Font[2]+4, DB.Font[3])
	tag:SetPoint("CENTER", 1, 0)
	B.ReskinText(tag, .6, .8, 1)
	tag.__name = name

	self.freeSlot = slot
end

local toggleButtons = {}
function Bags:SelectToggleButton(id)
	for index, button in pairs(toggleButtons) do
		if index ~= id then
			button.__turnOff()
		end
	end
end

local splitEnable
local function saveSplitCount(self)
	local count = self:GetText() or ""
	C.db["Bags"]["SplitCount"] = tonumber(count) or 1
end

function Bags:CreateSplitButton()
	local enabledText = DB.InfoColor..L["SplitMode Enabled"]

	local splitFrame = CreateFrame("Frame", nil, self)
	splitFrame:SetSize(100, 50)
	splitFrame:SetPoint("TOPRIGHT", self, "TOPLEFT", -5, 0)
	B.CreateBG(splitFrame)
	B.CreateFS(splitFrame, 14, L["SplitCount"], "system", "TOP", 1, -5)
	splitFrame:Hide()
	local editbox = B.CreateEditBox(splitFrame, 90, 20)
	editbox:SetPoint("BOTTOMLEFT", 5, 5)
	editbox:SetJustifyH("CENTER")
	editbox:SetScript("OnTextChanged", saveSplitCount)

	local bu = B.CreateButton(self, 24, 24, true, "Interface\\Icons\\Ability_Druid_GiftoftheEarthmother")
	bu.__turnOff = function()
		bu.icbg:SetBackdropBorderColor(0, 0, 0)
		bu.tooltip = nil
		splitFrame:Hide()
		splitEnable = nil
	end
	bu:SetScript("OnClick", function(self)
		Bags:SelectToggleButton(1)
		splitEnable = not splitEnable
		if splitEnable then
			self.icbg:SetBackdropBorderColor(cr, cg, cb)
			self.tooltip = enabledText
			splitFrame:Show()
			editbox:SetText(C.db["Bags"]["SplitCount"])
		else
			self.__turnOff()
		end
		self:GetScript("OnEnter")(self)
	end)
	bu:SetScript("OnHide", bu.__turnOff)
	bu.title = L["QuickSplit"]
	B.AddTooltip(bu, "ANCHOR_TOP")

	toggleButtons[1] = bu

	return bu
end

local function splitOnClick(self)
	if not splitEnable then return end

	PickupContainerItem(self.bagID, self.slotID)

	local texture, itemCount, locked = GetContainerItemInfo(self.bagID, self.slotID)
	if texture and not locked and itemCount and itemCount > C.db["Bags"]["SplitCount"] then
		SplitContainerItem(self.bagID, self.slotID, C.db["Bags"]["SplitCount"])

		local bagID, slotID = Bags:GetEmptySlot("Main")
		if slotID then
			PickupContainerItem(bagID, slotID)
		end
	end
end

local favouriteEnable
function Bags:CreateFavouriteButton()
	local enabledText = DB.InfoColor..L["FavouriteMode Enabled"]

	local bu = B.CreateButton(self, 24, 24, true, "Interface\\Icons\\Item_Shop_GiftBox01")
	bu.__turnOff = function()
		bu.icbg:SetBackdropBorderColor(0, 0, 0)
		bu.tooltip = nil
		favouriteEnable = nil
	end
	bu:SetScript("OnClick", function(self)
		Bags:SelectToggleButton(2)
		favouriteEnable = not favouriteEnable
		if favouriteEnable then
			self.icbg:SetBackdropBorderColor(cr, cg, cb)
			self.tooltip = enabledText
		else
			self.__turnOff()
		end
		self:GetScript("OnEnter")(self)
	end)
	bu:SetScript("OnHide", bu.__turnOff)
	bu.title = L["FavouriteMode"]
	B.AddTooltip(bu, "ANCHOR_TOP")

	toggleButtons[2] = bu

	return bu
end

local function favouriteOnClick(self)
	if not favouriteEnable then return end

	local texture, _, _, quality, _, _, _, _, _, itemID = GetContainerItemInfo(self.bagID, self.slotID)
	if texture and quality > LE_ITEM_QUALITY_POOR then
		if C.db["Bags"]["FavouriteItems"][itemID] then
			C.db["Bags"]["FavouriteItems"][itemID] = nil
		else
			C.db["Bags"]["FavouriteItems"][itemID] = true
		end
		ClearCursor()
		Bags:UpdateAllBags()
	end
end

StaticPopupDialogs["NDUI_WIPE_JUNK_LIST"] = {
	text = L["Reset junklist warning"],
	button1 = YES,
	button2 = NO,
	OnAccept = function()
		wipe(NDuiADB["CustomJunkList"])
	end,
	whileDead = 1,
}
local customJunkEnable
function Bags:CreateJunkButton()
	local enabledText = DB.InfoColor..L["JunkMode Enabled"]

	local bu = B.CreateButton(self, 24, 24, true, "Interface\\Icons\\inv_misc_coinbag_special")
	bu.__turnOff = function()
		bu.icbg:SetBackdropBorderColor(0, 0, 0)
		bu.tooltip = nil
		customJunkEnable = nil
	end
	bu:SetScript("OnClick", function(self)
		if IsAltKeyDown() and IsControlKeyDown() then
			StaticPopup_Show("NDUI_WIPE_JUNK_LIST")
			return
		end

		Bags:SelectToggleButton(3)
		customJunkEnable = not customJunkEnable
		if customJunkEnable then
			self.icbg:SetBackdropBorderColor(cr, cg, cb)
			self.tooltip = enabledText
		else
			bu.__turnOff()
		end
		Bags:UpdateAllBags()
		self:GetScript("OnEnter")(self)
	end)
	bu:SetScript("OnHide", bu.__turnOff)
	bu.title = L["CustomJunkMode"]
	B.AddTooltip(bu, "ANCHOR_TOP")

	toggleButtons[3] = bu

	return bu
end

local function customJunkOnClick(self)
	if not customJunkEnable then return end

	local texture, _, _, _, _, _, _, _, _, itemID = GetContainerItemInfo(self.bagID, self.slotID)
	local price = select(11, GetItemInfo(itemID))
	if texture and price > 0 then
		if NDuiADB["CustomJunkList"][itemID] then
			NDuiADB["CustomJunkList"][itemID] = nil
		else
			NDuiADB["CustomJunkList"][itemID] = true
		end
		ClearCursor()
		Bags:UpdateAllBags()
	end
end

local deleteEnable
function Bags:CreateDeleteButton()
	local enabledText = DB.InfoColor..L["DeleteMode Enabled"]

	local bu = B.CreateButton(self, 24, 24, true, "Interface\\Buttons\\UI-GroupLoot-Pass-Up")
	bu.Icon:SetPoint("TOPLEFT", 3, -2)
	bu.Icon:SetPoint("BOTTOMRIGHT", -1, 2)
	bu.__turnOff = function()
		bu.icbg:SetBackdropBorderColor(0, 0, 0)
		bu.tooltip = nil
		deleteEnable = nil
	end
	bu:SetScript("OnClick", function(self)
		Bags:SelectToggleButton(4)
		deleteEnable = not deleteEnable
		if deleteEnable then
			self.icbg:SetBackdropBorderColor(cr, cg, cb)
			self.tooltip = enabledText
		else
			bu.__turnOff()
		end
		self:GetScript("OnEnter")(self)
	end)
	bu:SetScript("OnHide", bu.__turnOff)
	bu.title = L["ItemDeleteMode"]
	B.AddTooltip(bu, "ANCHOR_TOP")

	toggleButtons[4] = bu

	return bu
end

local function deleteButtonOnClick(self)
	if not deleteEnable then return end

	local texture, _, _, quality = GetContainerItemInfo(self.bagID, self.slotID)
	if IsControlKeyDown() and IsAltKeyDown() and texture and (quality < LE_ITEM_QUALITY_RARE or quality == LE_ITEM_QUALITY_HEIRLOOM) then
		PickupContainerItem(self.bagID, self.slotID)
		DeleteCursorItem()
	end
end

function Bags:ButtonOnClick(btn)
	if btn ~= "LeftButton" then return end
	splitOnClick(self)
	favouriteOnClick(self)
	customJunkOnClick(self)
	deleteButtonOnClick(self)
end

function Bags:UpdateAllBags()
	if self.Bags and self.Bags:IsShown() then
		self.Bags:BAG_UPDATE()
	end
end

function Bags:OpenBags()
	OpenAllBags(true)
end

function Bags:CloseBags()
	CloseAllBags()
end

function Bags:OnLogin()
	if not C.db["Bags"]["Enable"] then return end

	-- Settings
	local bagsScale = C.db["Bags"]["BagsScale"]
	local bagsWidth = C.db["Bags"]["BagsWidth"]
	local bankWidth = C.db["Bags"]["BankWidth"]
	local iconSize = C.db["Bags"]["IconSize"]
	local deleteButton = C.db["Bags"]["DeleteButton"]
	local showNewItem = C.db["Bags"]["ShowNewItem"]
	local showItemLevel = C.db["Bags"]["BagsiLvl"]
	local showItemSlot = C.db["Bags"]["BagsSlot"]
	local hasCanIMogIt = IsAddOnLoaded("CanIMogIt")
	local hasPawn = IsAddOnLoaded("Pawn")

	-- Init
	local Backpack = cargBags:NewImplementation("NDui_Backpack")
	Backpack:RegisterBlizzard()
	Backpack:SetScale(bagsScale)
	Backpack:HookScript("OnShow", function() PlaySound(SOUNDKIT.IG_BACKPACK_OPEN) end)
	Backpack:HookScript("OnHide", function() PlaySound(SOUNDKIT.IG_BACKPACK_CLOSE) end)

	Bags.Bags = Backpack
	Bags.BagsType = {}
	Bags.BagsType[0] = 0	-- backpack
	Bags.BagsType[-1] = 0	-- bank
	Bags.BagsType[-3] = 0	-- reagent

	local f = {}
	local filters = self:GetFilters()

	function Backpack:OnInit()
		local MyContainer = self:GetContainerClass()

		f.main = MyContainer:New("Main", {Columns = bagsWidth, Bags = "bags"})
		f.main:SetFilter(filters.onlyBags, true)
		f.main:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -100, 200)

		f.junk = MyContainer:New("Junk", {Columns = bagsWidth, Parent = f.main})
		f.junk:SetFilter(filters.bagsJunk, true)

		f.bagFavourite = MyContainer:New("BagFavourite", {Columns = bagsWidth, Parent = f.main})
		f.bagFavourite:SetFilter(filters.bagFavourite, true)

		f.azeriteItem = MyContainer:New("AzeriteItem", {Columns = bagsWidth, Parent = f.main})
		f.azeriteItem:SetFilter(filters.bagAzeriteItem, true)

		f.equipment = MyContainer:New("Equipment", {Columns = bagsWidth, Parent = f.main})
		f.equipment:SetFilter(filters.bagEquipment, true)

		f.equipSet = MyContainer:New("EquipSet", {Columns = bagsWidth, Parent = f.main})
		f.equipSet:SetFilter(filters.bagEquipSet, true)

		f.consumable = MyContainer:New("Consumable", {Columns = bagsWidth, Parent = f.main})
		f.consumable:SetFilter(filters.bagConsumable, true)

		f.bagCollection = MyContainer:New("BagCollection", {Columns = bagsWidth, Parent = f.main})
		f.bagCollection:SetFilter(filters.bagCollection, true)

		f.bagGoods = MyContainer:New("BagGoods", {Columns = bagsWidth, Parent = f.main})
		f.bagGoods:SetFilter(filters.bagGoods, true)

		f.bagQuest = MyContainer:New("BagQuest", {Columns = bagsWidth, Parent = f.main})
		f.bagQuest:SetFilter(filters.bagQuest, true)

		f.bank = MyContainer:New("Bank", {Columns = bankWidth, Bags = "bank"})
		f.bank:SetFilter(filters.onlyBank, true)
		f.bank:SetPoint("TOPRIGHT", f.main, "TOPLEFT", -25, 0)
		f.bank:Hide()

		f.bankFavourite = MyContainer:New("BankFavourite", {Columns = bankWidth, Parent = f.bank})
		f.bankFavourite:SetFilter(filters.bankFavourite, true)

		f.bankAzeriteItem = MyContainer:New("BankAzeriteItem", {Columns = bankWidth, Parent = f.bank})
		f.bankAzeriteItem:SetFilter(filters.bankAzeriteItem, true)

		f.bankLegendary = MyContainer:New("BankLegendary", {Columns = bankWidth, Parent = f.bank})
		f.bankLegendary:SetFilter(filters.bankLegendary, true)

		f.bankEquipment = MyContainer:New("BankEquipment", {Columns = bankWidth, Parent = f.bank})
		f.bankEquipment:SetFilter(filters.bankEquipment, true)

		f.bankEquipSet = MyContainer:New("BankEquipSet", {Columns = bankWidth, Parent = f.bank})
		f.bankEquipSet:SetFilter(filters.bankEquipSet, true)

		f.bankConsumable = MyContainer:New("BankConsumable", {Columns = bankWidth, Parent = f.bank})
		f.bankConsumable:SetFilter(filters.bankConsumable, true)

		f.bankCollection = MyContainer:New("BankCollection", {Columns = bankWidth, Parent = f.bank})
		f.bankCollection:SetFilter(filters.bankCollection, true)

		f.bankGoods = MyContainer:New("BankGoods", {Columns = bankWidth, Parent = f.bank})
		f.bankGoods:SetFilter(filters.bankGoods, true)

		f.bankQuest = MyContainer:New("BankQuest", {Columns = bankWidth, Parent = f.bank})
		f.bankQuest:SetFilter(filters.bankQuest, true)

		f.reagent = MyContainer:New("Reagent", {Columns = bankWidth})
		f.reagent:SetFilter(filters.onlyReagent, true)
		f.reagent:SetPoint("BOTTOMLEFT", f.bank)
		f.reagent:Hide()

		Bags.BagGroup = {f.azeriteItem, f.equipment, f.equipSet, f.bagCollection, f.bagGoods, f.consumable, f.bagQuest, f.bagFavourite, f.junk}
		Bags.BankGroup = {f.bankAzeriteItem, f.bankEquipment, f.bankEquipSet, f.bankLegendary, f.bankCollection, f.bankGoods, f.bankConsumable, f.bankQuest, f.bankFavourite}
	end

	local initBagType
	function Backpack:OnBankOpened()
		BankFrame:Show()
		self:GetContainer("Bank"):Show()

		if not initBagType then
			Bags:UpdateAllBags() -- Initialize bagType
			initBagType = true
		end
	end

	function Backpack:OnBankClosed()
		BankFrame.selectedTab = 1
		BankFrame:Hide()
		self:GetContainer("Bank"):Hide()
		self:GetContainer("Reagent"):Hide()
		ReagentBankFrame:Hide()
	end

	local MyButton = Backpack:GetItemButtonClass()
	MyButton:Scaffold("Default")

	function MyButton:OnCreate()
		B.CleanTextures(self)

		self.bubg = B.CreateBDFrame(self)
		B.ReskinHighlight(self, self.bubg)

		self:SetSize(iconSize, iconSize)
		self.Cooldown:SetInside(self.bubg)
		self.IconOverlay:SetInside(self.bubg)
		self.IconOverlay2:SetInside(self.bubg)

		self.Icon:SetTexCoord(unpack(DB.TexCoord))
		self.Icon:SetInside(self.bubg)

		self.Count:SetPoint("BOTTOMRIGHT", 0, 1)
		self.Count:SetFont(unpack(DB.Font))

		local parentFrame = CreateFrame("Frame", nil, self)
		parentFrame:SetAllPoints()
		parentFrame:SetFrameLevel(5)

		self.Favourite = parentFrame:CreateTexture(nil, "ARTWORK")
		self.Favourite:SetAtlas("collections-icon-favorites")
		self.Favourite:SetSize(30, 30)
		self.Favourite:SetPoint("TOPLEFT", -12, 9)

		self.Quest = B.CreateFS(self, 30, "!", "system", "LEFT", 3, 0)
		self.iLvl = B.CreateFS(self, 12, "", false, "BOTTOMRIGHT", 0, 1)
		self.Slot = B.CreateFS(self, 12, "", false, "TOPLEFT", 1, -2)

		if showNewItem then
			self.glowFrame = B.CreateGlowFrame(self, iconSize)
		end

		self:HookScript("OnClick", Bags.ButtonOnClick)

		if hasCanIMogIt then
			self.canIMogIt = parentFrame:CreateTexture(nil, "OVERLAY")
			self.canIMogIt:SetSize(13, 13)
			self.canIMogIt:SetPoint(unpack(CanIMogIt.ICON_LOCATIONS[CanIMogItOptions["iconLocation"]]))
		end
	end

	function MyButton:ItemOnEnter()
		if self.glowFrame then
			B.HideOverlayGlow(self.glowFrame)
			C_NewItems_RemoveNewItem(self.bagID, self.slotID)
		end
	end

	local bagTypeColor = {
		[ 0] = { 0,  0,  0,  0},	-- 容器
		[ 1] = {.3, .3, .3, .5},	-- 弹药袋
		[ 2] = { 0, .5,  0, .5},	-- 草药袋
		[ 3] = {.8,  0, .8, .5},	-- 附魔袋
		[ 4] = { 1, .8,  0, .5},	-- 工程袋
		[ 5] = { 0, .8, .8, .5},	-- 宝石袋
		[ 6] = {.5, .4,  0, .5},	-- 矿石袋
		[ 7] = {.8, .5, .5, .5},	-- 制皮包
		[ 8] = {.8, .8, .8, .5},	-- 铭文包
		[ 9] = {.4, .6,  1, .5},	-- 工具箱
		[10] = {.8,  0,  0, .5},	-- 烹饪包
	}

	local function GetIconOverlayAtlas(item)
		if not item.link then return end

		if C_AzeriteEmpoweredItem_IsAzeriteEmpoweredItemByID(item.link) then
			return "AzeriteIconFrame"
		elseif IsCosmeticItem(item.link) then
			return "CosmeticIconFrame"
		elseif C_Soulbinds_IsItemConduitByItemInfo(item.link) then
			return "ConduitIconFrame", "ConduitIconFrame-Corners"
		end
	end

	local function UpdateCanIMogIt(self, item)
		if not self.canIMogIt then return end

		local text, unmodifiedText = CanIMogIt:GetTooltipText(nil, item.bagID, item.slotID)
		if text and text ~= "" then
			local icon = CanIMogIt.tooltipOverlayIcons[unmodifiedText]
			self.canIMogIt:SetTexture(icon)
			self.canIMogIt:Show()
		else
			self.canIMogIt:Hide()
		end
	end

	local function UpdatePawnArrow(self, item)
		if not hasPawn then return end
		if not PawnIsContainerItemAnUpgrade then return end
		if self.UpgradeIcon then
			self.UpgradeIcon:SetShown(PawnIsContainerItemAnUpgrade(item.bagID, item.slotID))
		end
	end

	function MyButton:OnUpdate(item)
		if self.JunkIcon then
			if ((item.rarity and item.rarity == LE_ITEM_QUALITY_POOR) or NDuiADB["CustomJunkList"][item.id]) and (item.sellPrice and item.sellPrice > 0) then
				self.JunkIcon:Show()
			else
				self.JunkIcon:Hide()
			end
		end

		self.IconOverlay:SetVertexColor(1, 1, 1)
		self.IconOverlay:Hide()
		self.IconOverlay2:Hide()
		local atlas, secondAtlas = GetIconOverlayAtlas(item)
		if atlas then
			self.IconOverlay:SetAtlas(atlas)
			self.IconOverlay:Show()
			if secondAtlas then
				local r, g, b = GetItemQualityColor(item.rarity or 1)
				self.IconOverlay:SetVertexColor(r, g, b)
				self.IconOverlay2:SetAtlas(secondAtlas)
				self.IconOverlay2:Show()
			end
		end

		if C.db["Bags"]["FavouriteItems"][item.id] then
			self.Favourite:Show()
		else
			self.Favourite:Hide()
		end

		if item.link and (item.rarity and item.rarity > 0) and (item.level and item.level > 0) then
			local slot = B.GetItemSlot(item.link)
			local level = B.GetItemLevel(item.link, item.bagID, item.slotID) or item.level

			if level < C.db["Bags"]["iLvlToShow"] then level = "" end

			if (item.subType and item.subType == EJ_LOOT_SLOT_FILTER_ARTIFACT_RELIC) or (item.equipLoc and item.equipLoc ~= "") then
				if showItemLevel then self.iLvl:SetText(level) end
				if showItemSlot then self.Slot:SetText(slot) end
			elseif (item.classID and item.classID == LE_ITEM_CLASS_MISCELLANEOUS) and (item.subClassID and (item.subClassID == LE_ITEM_MISCELLANEOUS_COMPANION_PET or item.subClassID == LE_ITEM_MISCELLANEOUS_MOUNT)) then
				if showItemSlot then self.Slot:SetText(slot) end
			else
				if showItemLevel then self.iLvl:SetText("") end
				if showItemSlot then self.Slot:SetText("") end
			end
		else
			if showItemLevel then self.iLvl:SetText("") end
			if showItemSlot then self.Slot:SetText("") end
		end

		if self.glowFrame then
			if C_NewItems_IsNewItem(item.bagID, item.slotID) then
				B.ShowOverlayGlow(self.glowFrame)
			else
				B.HideOverlayGlow(self.glowFrame)
			end
		end

		if C.db["Bags"]["SpecialBagsColor"] then
			local bagType = Bags.BagsType[item.bagID]
			local color = bagTypeColor[bagType] or bagTypeColor[0]
			self.bubg:SetBackdropColor(unpack(color))
		else
			self.bubg:SetBackdropColor(0, 0, 0, 0)
		end

		-- Hide empty tooltip
		if not GetContainerItemInfo(item.bagID, item.slotID) then
			GameTooltip:Hide()
		end

		-- Support CanIMogIt
		UpdateCanIMogIt(self, item)

		-- Support Pawn
		UpdatePawnArrow(self, item)
	end

	function MyButton:OnUpdateQuest(item)
		if item.questID and not item.questActive then
			self.Quest:Show()
		else
			self.Quest:Hide()
		end

		if item.questID or item.isQuestItem then
			self.bubg:SetBackdropBorderColor(1, 1, 0)
		elseif item.rarity and item.rarity > 0 then
			local r, g, b = GetItemQualityColor(item.rarity or 1)
			self.bubg:SetBackdropBorderColor(r, g, b)
		else
			self.bubg:SetBackdropBorderColor(0, 0, 0)
		end
	end

	local MyContainer = Backpack:GetContainerClass()

	function MyContainer:OnContentsChanged()
		self:SortButtons("bagSlot")

		local columns = self.Settings.Columns
		local offset = 38
		local spacing = C.margin
		local xOffset = 5
		local yOffset = -offset + xOffset
		local _, height = self:LayoutButtons("grid", columns, spacing, xOffset, yOffset)
		local width = columns * (iconSize+spacing)-spacing
		if self.freeSlot then
			if C.db["Bags"]["GatherEmpty"] then
				local numSlots = #self.buttons + 1
				local row = ceil(numSlots / columns)
				local col = numSlots % columns
				if col == 0 then col = columns end
				local xPos = (col-1) * (iconSize + spacing)
				local yPos = -1 * (row-1) * (iconSize + spacing)

				self.freeSlot:ClearAllPoints()
				self.freeSlot:SetPoint("TOPLEFT", self, "TOPLEFT", xPos+xOffset, yPos+yOffset)
				self.freeSlot:Show()

				if height < 0 then
					height = iconSize
				elseif col == 1 then
					height = height + iconSize + spacing
				end
			else
				self.freeSlot:Hide()
			end
		end
		self:SetSize(width + xOffset*2, height + offset)

		Bags:UpdateAnchors(f.main, Bags.BagGroup)
		Bags:UpdateAnchors(f.bank, Bags.BankGroup)
	end

	function MyContainer:OnCreate(name, settings)
		self.Settings = settings
		self:SetParent(settings.Parent or Backpack)
		self:SetFrameStrata("HIGH")
		self:SetClampedToScreen(true)
		B.CreateBG(self)
		B.CreateMF(self, settings.Parent, true)

		local label
		if strmatch(name, "AzeriteItem$") then
			label = L["Azerite Armor"]
		elseif strmatch(name, "Equipment$") then
			label = BAG_FILTER_EQUIPMENT
		elseif strmatch(name, "EquipSet$") then
			label = L["Equipement Set"]
		elseif name == "BankLegendary" then
			label = LOOT_JOURNAL_LEGENDARIES
		elseif strmatch(name, "Consumable$") then
			label = BAG_FILTER_CONSUMABLES
		elseif name == "Junk" then
			label = BAG_FILTER_JUNK
		elseif strmatch(name, "Collection") then
			label = COLLECTIONS
		elseif strmatch(name, "Favourite") then
			label = PREFERENCES
		elseif strmatch(name, "Goods") then
			label = AUCTION_CATEGORY_TRADE_GOODS
		elseif strmatch(name, "Quest") then
			label = QUESTS_LABEL
		end
		if label then
			self.label = B.CreateFS(self, 14, label, true, "TOPLEFT", 5, -8)
			return
		end

		Bags.CreateInfoFrame(self)

		local buttons = {}
		buttons[1] = Bags.CreateCloseButton(self)
		if name == "Main" then
			Bags.CreateBagBar(self, settings, 4)
			buttons[2] = Bags.CreateRestoreButton(self, f)
			buttons[3] = Bags.CreateBagToggle(self)
			buttons[5] = Bags.CreateSplitButton(self)
			buttons[6] = Bags.CreateFavouriteButton(self)
			buttons[7] = Bags.CreateJunkButton(self)
			if deleteButton then buttons[8] = Bags.CreateDeleteButton(self) end
		elseif name == "Bank" then
			Bags.CreateBagBar(self, settings, 7)
			buttons[2] = Bags.CreateReagentButton(self, f)
			buttons[3] = Bags.CreateBagToggle(self)
		elseif name == "Reagent" then
			buttons[2] = Bags.CreateBankButton(self, f)
			buttons[3] = Bags.CreateDepositButton(self)
		end
		buttons[4] = Bags.CreateSortButton(self, name)

		for i = 1, #buttons do
			local bu = buttons[i]
			if not bu then break end
			if i == 1 then
				bu:SetPoint("TOPRIGHT", -5, -5)
			else
				bu:SetPoint("RIGHT", buttons[i-1], "LEFT", -3, 0)
			end
		end

		self:HookScript("OnShow", B.RestoreMF)

		self.iconSize = iconSize
		Bags.CreateFreeSlots(self)
	end

	local BagButton = Backpack:GetClass("BagButton", true, "BagButton")
	function BagButton:OnCreate()
		B.CleanTextures(self)

		self.bubg = B.CreateBDFrame(self)
		B.ReskinHighlight(self, self.bubg)

		self:SetSize(iconSize, iconSize)
		self.Icon:SetTexCoord(unpack(DB.TexCoord))
		self.Icon:SetInside(self.bubg)
	end

	function BagButton:OnUpdate()
		self.bubg:SetBackdropBorderColor(0, 0, 0)

		local id = GetInventoryItemID("player", (self.GetInventorySlot and self:GetInventorySlot()) or self.invID)
		if not id then return end
		local _, _, quality, _, _, _, _, _, _, _, _, classID, subClassID = GetItemInfo(id)
		if not quality or quality == 1 then quality = 0 end
		local r, g, b = GetItemQualityColor(quality or 1)
		if not self.hidden and not self.notBought then
			self.bubg:SetBackdropBorderColor(r, g, b)
		end

		if classID == LE_ITEM_CLASS_CONTAINER then
			Bags.BagsType[self.bagID] = subClassID or 0
		else
			Bags.BagsType[self.bagID] = 0
		end
	end

	-- Sort order
	SetSortBagsRightToLeft(C.db["Bags"]["BagSortMode"] == 1)
	SetInsertItemsLeftToRight(false)

	-- Init
	ToggleAllBags()
	ToggleAllBags()
	Bags.initComplete = true

	B:RegisterEvent("TRADE_SHOW", Bags.OpenBags)
	B:RegisterEvent("TRADE_CLOSED", Bags.CloseBags)
	B:RegisterEvent("BANKFRAME_OPENED", Bags.AutoDeposit)

	-- Fixes
	BankFrame.GetRight = function() return f.bank:GetRight() end
	BankFrameItemButton_Update = B.Dummy

	-- Shift key alert
	local function onUpdate(self, elapsed)
		if IsShiftKeyDown() then
			self.elapsed = (self.elapsed or 0) + elapsed
			if self.elapsed > 5 then
				UIErrorsFrame:AddMessage(DB.InfoColor..L["StupidShiftKey"])
				self.elapsed = 0
			end
		end
	end
	local shiftUpdater = CreateFrame("Frame", nil, f.main)
	shiftUpdater:SetScript("OnUpdate", onUpdate)
end