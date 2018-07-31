local _, ns = ...
local B, C, L, DB = unpack(ns)
if not C.Infobar.Durability then return end

local module = B:GetModule("Infobar")
local info = module:RegisterInfobar(C.Infobar.DurabilityPos)

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
				localSlots[i][3] = tonumber(string.format("%.1f", current/max*100))
				numSlots = numSlots + 1
			end
		else
			localSlots[i][3] = 1000
		end
	end
	sort(localSlots, function(a, b) return a[3] < b[3] end)

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
	if not NDuiADB["RepairType"] then NDuiADB["RepairType"] = 1 end

	if event == "PLAYER_REGEN_ENABLED" then
		self:UnregisterEvent(event)
		self:RegisterEvent("UPDATE_INVENTORY_DURABILITY")
		getItemDurability()
		if isLowDurability() then inform:Show() end
	else
		local numSlots = getItemDurability()
		if numSlots > 0 then
			self.text:SetText(B.ColorPercent(localSlots[1][3])..L["D"])
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
	GameTooltip:AddDoubleLine(DURABILITY, format("%s: %.1f / %.1f", STAT_AVERAGE_ITEM_LEVEL, total, equipped),0,.6,1,0,.6,1)
	GameTooltip:AddLine(" ")

	for i = 1, 10 do
		if localSlots[i][3] ~= 1000 then
			local v = localSlots[i][3] / 100
			local r = 1 - v
			local g = v
			local b = 0
			local slotIcon = "|T"..GetInventoryItemTexture("player", localSlots[i][1])..":13:15:0:0:50:50:4:46:4:46|t " or ""
			GameTooltip:AddDoubleLine(slotIcon..localSlots[i][2], string.format("%.1f%%", localSlots[i][3]), 1,1,1, r,g,b)
		end
	end

	GameTooltip:AddDoubleLine(" ", DB.LineString)
	GameTooltip:AddDoubleLine(" ", DB.LeftButton..L["Player Panel"].." ", 1,1,1, .6,.8,1)
	GameTooltip:AddDoubleLine(" ", DB.RightButton..L["Auto Repair"]..repairlist[NDuiADB["RepairType"]].." ", 1,1,1, .6,.8,1)
	GameTooltip:Show()
end

info.onLeave = function() GameTooltip:Hide() end

-- Auto repair
local isShown
local function autoRepair(event)
	if event == "MERCHANT_SHOW" and not isShown then
		isShown = true
		if NDuiADB["RepairType"] == 0 or not CanMerchantRepair() then return end

		local cost = GetRepairAllCost()
		if cost > 0 then
			local money = GetMoney()
			if IsInGuild() and NDuiADB["RepairType"] == 1 then
				local guildMoney = GetGuildBankWithdrawMoney()
				if guildMoney > GetGuildBankMoney() then
					guildMoney = GetGuildBankMoney()
				end
				if guildMoney >= cost and CanGuildBankRepair() or guildMoney == 0 and IsGuildLeader() then
					RepairAllItems(1)
					print(format(DB.InfoColor.."%s:|r %s", L["Guild repair"], GetMoneyString(cost)))
					return
				end
			end

			if money > cost then
				RepairAllItems()
				print(format(DB.InfoColor.."%s:|r %s", L["Repair cost"], GetMoneyString(cost)))
			else
				print(DB.InfoColor..L["Repair error"])
			end
		end
	elseif event == "MERCHANT_CLOSED" then
		isShown = false
	end
end
B:RegisterEvent("MERCHANT_SHOW", autoRepair)
B:RegisterEvent("MERCHANT_CLOSED", autoRepair)