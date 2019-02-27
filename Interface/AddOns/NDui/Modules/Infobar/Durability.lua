local _, ns = ...
local B, C, L, DB = unpack(ns)
if not C.Infobar.Durability then return end

local module = B:GetModule("Infobar")
local info = module:RegisterInfobar(C.Infobar.DurabilityPos)
local format, gsub, sort = string.format, string.gsub, table.sort
local floor, modf = math.floor, math.modf

local localSlots = {
	[1] = {1, INVTYPE_HEAD, 1000},
	[2] = {3, INVTYPE_SHOULDER, 1000},
	[3] = {5, INVTYPE_CHEST, 1000},
	[4] = {6, INVTYPE_WAIST, 1000},
	[5] = {9, INVTYPE_WRIST, 1000},
	[6] = {10, L["Hands"], 1000},
	[7] = {7, INVTYPE_LEGS, 1000},
	[8] = {8, L["Feet"], 1000},
	[9] = {16, INVTYPE_WEAPONMAINHAND, 1000},
	[10] = {17, INVTYPE_WEAPONOFFHAND, 1000}
}

local inform = CreateFrame("Frame", nil, nil, "MicroButtonAlertTemplate")
inform:SetPoint("BOTTOM", info, "TOP", 0, 23)
inform.Text:SetText(L["Low Durability"])
inform:Hide()

local function getItemDurability()
	local numSlots = 0
	for i = 1, 10 do
		if GetInventoryItemLink("player", localSlots[i][1]) then
			local current, max = GetInventoryItemDurability(localSlots[i][1])
			if current then
				localSlots[i][3] = tonumber(format("%.1f", current/max*100))
				numSlots = numSlots + 1
			end
		else
			localSlots[i][3] = 1000
		end
	end
	sort(localSlots, function(a, b)
		if a and b then
			return a[3] < b[3]
		end
	end)

	return numSlots
end

local function isLowDurability()
	for i = 1, 10 do
		if localSlots[i][3] < 25 then
			return true
		end
	end
end

info.eventList = {
	"UPDATE_INVENTORY_DURABILITY", "PLAYER_ENTERING_WORLD",
}

info.onEvent = function(self, event)
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	if event == "PLAYER_REGEN_ENABLED" then
		self:UnregisterEvent(event)
		self:RegisterEvent("UPDATE_INVENTORY_DURABILITY")
		getItemDurability()
		if isLowDurability() then inform:Show() end
	else
		local numSlots = getItemDurability()
		if numSlots > 0 then
			self.text:SetText(B.ColorText(localSlots[1][3])..L["D"])
		else
			self.text:SetText(DB.MyColor..NONE.."|r"..L["D"])
		end

		if isLowDurability() then inform:Show() else inform:Hide() end
	end
	self.text:SetJustifyH("RIGHT")
end

inform.CloseButton:HookScript("OnClick", function()
	if InCombatLockdown() then
		info:UnregisterEvent("UPDATE_INVENTORY_DURABILITY")
		info:RegisterEvent("PLAYER_REGEN_ENABLED")
	end
end)

info.onMouseUp = function(self, btn)
	if btn == "RightButton" then
		NDuiADB["RepairType"] = NDuiADB["RepairType"] + 1
		if NDuiADB["RepairType"] == 3 then NDuiADB["RepairType"] = 0 end
		self:GetScript("OnEnter")(self)
	else
		ToggleCharacter("PaperDollFrame")
	end
end

local repairlist = {
	[0] = "|cffff5555"..VIDEO_OPTIONS_DISABLED,
	[1] = "|cff55ff55"..VIDEO_OPTIONS_ENABLED,
	[2] = "|cffffff55"..L["NFG"]
}

info.onEnter = function(self)
	local total, equipped = GetAverageItemLevel()
	GameTooltip:SetOwner(self, "ANCHOR_TOP", 0, 15)
	GameTooltip:ClearLines()
	GameTooltip:AddLine(format("%s: %.1f / %.1f", STAT_AVERAGE_ITEM_LEVEL, total, equipped), 0,.6,1)
	GameTooltip:AddLine(" ")

	for i = 1, 10 do
		if localSlots[i][3] ~= 1000 then
			local v = localSlots[i][3] / 100
			local r, g, b = 1 - v, v, 0
			local slotIcon = "|T"..GetInventoryItemTexture("player", localSlots[i][1])..":13:15:0:0:50:50:4:46:4:46|t " or ""
			GameTooltip:AddDoubleLine(slotIcon..localSlots[i][2], format("%.1f%%", localSlots[i][3]), 1,1,1, r,g,b)
		end
	end

	GameTooltip:AddDoubleLine(" ", DB.LineString)
	GameTooltip:AddDoubleLine(" ", DB.LeftButton..L["Player Panel"].." ", 1,1,1, .6,.8,1)
	GameTooltip:AddDoubleLine(" ", DB.RightButton..L["Auto Repair"]..repairlist[NDuiADB["RepairType"]].." ", 1,1,1, .6,.8,1)
	GameTooltip:Show()
end

info.onLeave = B.HideTooltip

-- Auto repair
local isShown, isBankEmpty, autoRepair, repairAllCost, canRepair

local function delayFunc()
	if isBankEmpty then
		autoRepair(true)
	else
		print(format(DB.InfoColor.."%s|r%s", L["Guild repair"], GetMoneyString(repairAllCost)))
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
				print(format(DB.InfoColor.."%s|r%s", L["Repair cost"], GetMoneyString(repairAllCost)))
				return
			else
				print(DB.InfoColor..L["Repair error"])
				return
			end
		end

		C_Timer.After(.5, delayFunc)
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