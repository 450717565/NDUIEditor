local _, ns = ...
local B, C, L, DB = unpack(ns)
if not C.Infobar.Durability then return end

local Infobar = B:GetModule("Infobar")
local info = Infobar:RegisterInfobar("Durability", C.Infobar.DurabilityPos)

local format, sort, floor, select = string.format, table.sort, math.floor, select
local GetInventoryItemLink, GetInventoryItemDurability, GetInventoryItemTexture = GetInventoryItemLink, GetInventoryItemDurability, GetInventoryItemTexture
local GetMoney, GetRepairAllCost, RepairAllItems, CanMerchantRepair = GetMoney, GetRepairAllCost, RepairAllItems, CanMerchantRepair
local GetAverageItemLevel, IsInGuild, CanGuildBankRepair, GetGuildBankWithdrawMoney = GetAverageItemLevel, IsInGuild, CanGuildBankRepair, GetGuildBankWithdrawMoney
local C_Timer_After, IsShiftKeyDown, InCombatLockdown, CanMerchantRepair = C_Timer.After, IsShiftKeyDown, InCombatLockdown, CanMerchantRepair
local HelpTip = HelpTip

local repairCostString = gsub(REPAIR_COST, HEADER_COLON, "")
local lowDurabilityCap = 25

local localSlots = {
	[1] = {1, INVTYPE_HEAD, 1000},
	[2] = {3, INVTYPE_SHOULDER, 1000},
	[3] = {5, INVTYPE_CHEST, 1000},
	[4] = {6, INVTYPE_WAIST, 1000},
	[5] = {7, INVTYPE_LEGS, 1000},
	[6] = {8, L["Feet"], 1000},
	[7] = {9, INVTYPE_WRIST, 1000},
	[8] = {10, L["Hands"], 1000},
	[9] = {16, INVTYPE_WEAPONMAINHAND, 1000},
	[10] = {17, INVTYPE_WEAPONOFFHAND, 1000}
}

local function hideAlertWhileCombat()
	if InCombatLockdown() then
		info:RegisterEvent("PLAYER_REGEN_ENABLED")
		info:UnregisterEvent("UPDATE_INVENTORY_DURABILITY")
	end
end

local lowDurabilityInfo = {
	text = L["Low Durability"],
	buttonStyle = HelpTip.ButtonStyle.Okay,
	targetPoint = HelpTip.Point.TopEdgeCenter,
	onAcknowledgeCallback = hideAlertWhileCombat,
	offsetY = 10,
}

local function sortSlots(a, b)
	if a and b then
		return (a[3] == b[3] and a[1] < b[1]) or (a[3] < b[3])
	end
end

local function UpdateAllSlots()
	local numSlots = 0
	for i = 1, 10 do
		localSlots[i][3] = 1000
		local index = localSlots[i][1]
		if GetInventoryItemLink("player", index) then
			local current, max = GetInventoryItemDurability(index)
			if current then
				localSlots[i][3] = tonumber(format("%.1f", current/max*100))
				numSlots = numSlots + 1
			end
			localSlots[i][4] = "|T"..GetInventoryItemTexture("player", index)..":13:15:0:0:50:50:4:46:4:46|t " or ""
		end
	end
	sort(localSlots, sortSlots)

	return numSlots
end

local function isLowDurability()
	for i = 1, 10 do
		if localSlots[i][3] < lowDurabilityCap then
			return true
		end
	end
end

info.eventList = {
	"PLAYER_ENTERING_WORLD",
	"UPDATE_INVENTORY_DURABILITY",
}

info.onEvent = function(self, event)
	if event == "PLAYER_ENTERING_WORLD" then
		self:UnregisterEvent(event)
	end

	local numSlots = UpdateAllSlots()
	local isLow = isLowDurability()

	if event == "PLAYER_REGEN_ENABLED" then
		self:UnregisterEvent(event)
		self:RegisterEvent("UPDATE_INVENTORY_DURABILITY")
	else
		if numSlots > 0 then
			self.text:SetFormattedText("%s%s", B.ColorText(localSlots[1][3]), L["D"])
		else
			self.text:SetFormattedText("%s%s", DB.MyColor..NONE.."|r", L["D"])
		end
	end

	if isLow then
		HelpTip:Show(info, lowDurabilityInfo)
	else
		HelpTip:Hide(info, L["Low Durability"])
	end
end

info.onMouseUp = function(self, btn)
	if btn == "MiddleButton" then
		NDuiADB["RepairType"] = mod(NDuiADB["RepairType"] + 1, 3)
		self:onEnter()
	else
		if InCombatLockdown() then UIErrorsFrame:AddMessage(DB.InfoColor..ERR_NOT_IN_COMBAT) return end
		ToggleCharacter("PaperDollFrame")
	end
end

local repairList = {
	[0] = "|cffFF0000"..VIDEO_OPTIONS_DISABLED,
	[1] = "|cff00FF00"..VIDEO_OPTIONS_ENABLED,
	[2] = "|cffFFFF00"..L["NFG"]
}

info.onEnter = function(self)
	local total, equipped = GetAverageItemLevel()
	GameTooltip:SetOwner(self, "ANCHOR_TOP", 0, 15)
	GameTooltip:ClearLines()
	GameTooltip:AddDoubleLine(STAT_AVERAGE_ITEM_LEVEL, format("%.1f / %.1f", equipped, total), 0,.6,1, 0,.6,1)
	GameTooltip:AddLine(" ")

	local totalCost = 0
	for i = 1, 10 do
		if localSlots[i][3] ~= 1000 then
			local slot = localSlots[i][1]
			local r, g, b = B.SmoothColor(localSlots[i][3], 100)
			GameTooltip:AddDoubleLine(localSlots[i][4]..localSlots[i][2], format("%.1f%%", localSlots[i][3]), 1,1,1, r,g,b)

			B.ScanTip:SetOwner(UIParent, "ANCHOR_NONE")
			totalCost = totalCost + select(3, B.ScanTip:SetInventoryItem("player", slot))
		end
	end

	if totalCost > 0 then
		GameTooltip:AddLine(" ")
		GameTooltip:AddDoubleLine(repairCostString, Infobar:GetMoneyString(totalCost), .6,.8,1, 1,1,1)
	end

	GameTooltip:AddDoubleLine(" ", DB.LineString)
	GameTooltip:AddDoubleLine(" ", DB.LeftButton..L["Player Panel"].." ", 1,1,1, .6,.8,1)
	GameTooltip:AddDoubleLine(" ", DB.ScrollButton..L["Auto Repair"]..repairList[NDuiADB["RepairType"]].." ", 1,1,1, .6,.8,1)
	GameTooltip:Show()
end

info.onLeave = B.HideTooltip

-- Auto repair
local isShown, isBankEmpty, autoRepair, repairAllCost, canRepair

local function delayFunc()
	if isBankEmpty then
		autoRepair(true)
	else
		print(format(DB.InfoColor.."%s|r%s", L["Guild repair"], Infobar:GetMoneyString(repairAllCost)))
	end
end

function autoRepair(override)
	if isShown and not override then return end
	isShown = true
	isBankEmpty = false

	local myMoney = GetMoney()
	repairAllCost, canRepair = GetRepairAllCost()

	if canRepair and repairAllCost > 0 then
		if (not override) and NDuiADB["RepairType"] == 1 and IsInGuild() and CanGuildBankRepair() and GetGuildBankWithdrawMoney() >= repairAllCost then
			RepairAllItems(true)
		else
			if myMoney > repairAllCost then
				RepairAllItems()
				print(format(DB.InfoColor.."%s|r%s", L["Repair cost"], Infobar:GetMoneyString(repairAllCost)))
				return
			else
				print(DB.InfoColor..L["Repair error"])
				return
			end
		end

		C_Timer_After(.5, delayFunc)
	end
end

local function checkBankFund(_, msgType)
	if msgType == LE_GAME_ERR_GUILD_NOT_ENOUGH_MONEY then
		isBankEmpty = true
	end
end

local function merchantClose()
	isShown = false
	B:UnregisterEvent("UI_ERROR_MESSAGE", checkBankFund)
	B:UnregisterEvent("MERCHANT_CLOSED", merchantClose)
end

local function merchantShow()
	if IsShiftKeyDown() or NDuiADB["RepairType"] == 0 or not CanMerchantRepair() then return end
	autoRepair()
	B:RegisterEvent("UI_ERROR_MESSAGE", checkBankFund)
	B:RegisterEvent("MERCHANT_CLOSED", merchantClose)
end
B:RegisterEvent("MERCHANT_SHOW", merchantShow)