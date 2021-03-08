﻿local _, ns = ...
local B, C, L, DB = unpack(ns)
if not C.Infobar.Gold then return end

local Infobar = B:GetModule("Infobar")
local info = Infobar:RegisterInfobar("Gold", C.Infobar.GoldPos)

local format, pairs, wipe, unpack = string.format, pairs, table.wipe, unpack
local CLASS_ICON_TCOORDS = CLASS_ICON_TCOORDS
local GetMoney, GetNumWatchedTokens, Ambiguate = GetMoney, GetNumWatchedTokens, Ambiguate
local GetContainerNumSlots, GetContainerItemLink, GetItemInfo, GetContainerItemInfo, UseContainerItem = GetContainerNumSlots, GetContainerItemLink, GetItemInfo, GetContainerItemInfo, UseContainerItem
local C_Timer_After, IsControlKeyDown, IsShiftKeyDown = C_Timer.After, IsControlKeyDown, IsShiftKeyDown
local C_CurrencyInfo_GetCurrencyInfo = C_CurrencyInfo.GetCurrencyInfo
local C_CurrencyInfo_GetBackpackCurrencyInfo = C_CurrencyInfo.GetBackpackCurrencyInfo

local profit, spent, oldMoney = 0, 0, 0
local myName, myRealm = DB.MyName, DB.MyRealm

local crossRealms = GetAutoCompleteRealms()
if not crossRealms or #crossRealms == 0 then
	crossRealms = {[1]=myRealm}
end

local function getClassIcon(class)
	local tcoords = CLASS_ICON_TCOORDS[class]
	local c1, c2, c3, c4 = (tcoords[1]+.03)*50, (tcoords[2]-.03)*50, (tcoords[3]+.03)*50, (tcoords[4]-.03)*50
	local classStr = "|TInterface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes:13:15:0:0:50:50:"..c1..":"..c2..":"..c3..":"..c4.."|t "
	return classStr or ""
end

info.eventList = {
	"PLAYER_ENTERING_WORLD",
	"PLAYER_MONEY",
	"PLAYER_TRADE_MONEY",
	"SEND_MAIL_COD_CHANGED",
	"SEND_MAIL_MONEY_CHANGED",
	"TRADE_MONEY_CHANGED",
}

info.onEvent = function(self, event)
	if event == "PLAYER_ENTERING_WORLD" then
		oldMoney = GetMoney()
		self:UnregisterEvent(event)
	end

	local newMoney = GetMoney()
	local change = newMoney - oldMoney	-- Positive if we gain money
	if oldMoney > newMoney then			-- Lost Money
		spent = spent - change
	else								-- Gained Moeny
		profit = profit + change
	end
	self.text:SetText(Infobar:GetMoneyString(newMoney, true))

	if not NDuiADB["totalGold"][myRealm] then NDuiADB["totalGold"][myRealm] = {} end
	if not NDuiADB["totalGold"][myRealm][myName] then NDuiADB["totalGold"][myRealm][myName] = {} end
	NDuiADB["totalGold"][myRealm][myName][1] = GetMoney()
	NDuiADB["totalGold"][myRealm][myName][2] = DB.MyClass

	oldMoney = newMoney
end

StaticPopupDialogs["RESETGOLD"] = {
	text = L["Are you sure to reset the gold count?"],
	button1 = YES,
	button2 = NO,
	OnAccept = function()
		for _, realm in pairs(crossRealms) do
			if NDuiADB["totalGold"][realm] then
				wipe(NDuiADB["totalGold"][realm])
			end
		end
		NDuiADB["totalGold"][myRealm][myName] = {GetMoney(), DB.MyClass}
	end,
	whileDead = 1,
}

info.onMouseUp = function(self, btn)
	if IsControlKeyDown() and btn == "RightButton" then
		StaticPopup_Show("RESETGOLD")
	elseif btn == "MiddleButton" then
		NDuiADB["AutoSell"] = not NDuiADB["AutoSell"]
		self:onEnter()
	else
		if InCombatLockdown() then UIErrorsFrame:AddMessage(DB.InfoColor..ERR_NOT_IN_COMBAT) return end
		ToggleCharacter("TokenFrame")
	end
end

local switchList = {
	[false] = "|cffFF0000"..VIDEO_OPTIONS_DISABLED,
	[true] = "|cff00FF00"..VIDEO_OPTIONS_ENABLED,
}

info.onEnter = function(self)
	GameTooltip:SetOwner(self, "ANCHOR_TOP", -15, 15)
	GameTooltip:ClearLines()
	GameTooltip:AddLine(CURRENCY, 0,.6,1)
	GameTooltip:AddLine(" ")

	GameTooltip:AddLine(L["Session"], .6,.8,1)
	GameTooltip:AddDoubleLine(L["Earned"], Infobar:GetMoneyString(profit), 1,1,1, 1,1,1)
	GameTooltip:AddDoubleLine(L["Spent"], Infobar:GetMoneyString(spent), 1,1,1, 1,1,1)
	if profit < spent then
		GameTooltip:AddDoubleLine(L["Deficit"], Infobar:GetMoneyString(spent-profit), 1,0,0, 1,1,1)
	elseif profit > spent then
		GameTooltip:AddDoubleLine(L["Profit"], Infobar:GetMoneyString(profit-spent), 0,1,0, 1,1,1)
	end
	GameTooltip:AddLine(" ")

	local totalGold = 0
	GameTooltip:AddLine(L["RealmCharacter"], .6,.8,1)
	for _, realm in pairs(crossRealms) do
		local thisRealmList = NDuiADB["totalGold"][realm]
		if thisRealmList then
			for k, v in pairs(thisRealmList) do
				local name = Ambiguate(k.."-"..realm, "none")
				local gold, class = unpack(v)
				local r, g, b = B.ClassColor(class)
				GameTooltip:AddDoubleLine(getClassIcon(class)..name, Infobar:GetMoneyString(gold, true), r,g,b, 1,1,1)
				totalGold = totalGold + gold
			end
		end
	end
	GameTooltip:AddLine(" ")
	GameTooltip:AddDoubleLine(TOTAL.."：", Infobar:GetMoneyString(totalGold, true), .6,.8,1, 1,1,1)

	for i = 1, GetNumWatchedTokens() do
		local currencyInfo = C_CurrencyInfo_GetBackpackCurrencyInfo(i)
		if not currencyInfo then return end

		local name, count, icon, currencyID = currencyInfo.name, currencyInfo.quantity, currencyInfo.iconFileID, currencyInfo.currencyTypesID
		if name and i == 1 then
			GameTooltip:AddLine(" ")
			GameTooltip:AddLine(CURRENCY.."：", .6,.8,1)
		end
		if name and count then
			local total = C_CurrencyInfo_GetCurrencyInfo(currencyID).maxQuantity
			local iconTexture = " |T"..icon..":13:15:0:0:50:50:4:46:4:46|t"
			if total > 0 then
				GameTooltip:AddDoubleLine(name, B.FormatNumb(count).." / "..B.FormatNumb(total)..iconTexture, 1,1,1, 1,1,1)
			else
				GameTooltip:AddDoubleLine(name, B.FormatNumb(count)..iconTexture, 1,1,1, 1,1,1)
			end
		end
	end

	GameTooltip:AddLine(" ")
	GameTooltip:AddLine(LOOT_JOURNAL_POWERS.."：", .6,.8,1)
	GameTooltip:AddDoubleLine("1级（190）", "1250", 1,1,1, 1,1,1)
	GameTooltip:AddDoubleLine("2级（210）", "2000", 1,1,1, 1,1,1)
	GameTooltip:AddDoubleLine("3级（225）", "3200", 1,1,1, 1,1,1)
	GameTooltip:AddDoubleLine("4级（235）", "5150", 1,1,1, 1,1,1)

	GameTooltip:AddDoubleLine(" ", DB.LineString)
	GameTooltip:AddDoubleLine(" ", DB.LeftButton..L["Currency Panel"].." ", 1,1,1, .6,.8,1)
	GameTooltip:AddDoubleLine(" ", DB.ScrollButton..L["AutoSell Junk"]..switchList[NDuiADB["AutoSell"]].." ", 1,1,1, .6,.8,1)
	GameTooltip:AddDoubleLine(" ", "CTRL +"..DB.RightButton..L["Reset Gold"].." ", 1,1,1, .6,.8,1)
	GameTooltip:Show()
end

info.onLeave = B.HideTooltip

-- Auto selljunk
local sellCount, stop, cache = 0, true, {}
local errorText = _G.ERR_VENDOR_DOESNT_BUY

local function stopSelling(tell)
	stop = true
	if sellCount > 0 and tell then
		print(format("|cff99CCFF%s|r%s", L["Selljunk Calculate"], Infobar:GetMoneyString(sellCount)))
	end
	sellCount = 0
end

local function startSelling()
	if stop then return end
	for bag = 0, 4 do
		for slot = 1, GetContainerNumSlots(bag) do
			if stop then return end
			local link = GetContainerItemLink(bag, slot)
			if link then
				local price = select(11, GetItemInfo(link))
				local _, count, _, quality, _, _, _, _, _, itemID = GetContainerItemInfo(bag, slot)
				if (quality == 0 or NDuiADB["CustomJunkList"][itemID]) and price > 0 and not cache["b"..bag.."s"..slot] then
					sellCount = sellCount + price*count
					cache["b"..bag.."s"..slot] = true
					UseContainerItem(bag, slot)
					C_Timer_After(.15, startSelling)
					return
				end
			end
		end
	end
end

local function updateSelling(event, ...)
	if not NDuiADB["AutoSell"] then return end

	local _, arg = ...
	if event == "MERCHANT_SHOW" then
		if IsShiftKeyDown() then return end
		stop = false
		wipe(cache)
		startSelling()
		B:RegisterEvent("UI_ERROR_MESSAGE", updateSelling)
	elseif event == "UI_ERROR_MESSAGE" and arg == errorText then
		stopSelling(false)
	elseif event == "MERCHANT_CLOSED" then
		stopSelling(true)
	end
end
B:RegisterEvent("MERCHANT_SHOW", updateSelling)
B:RegisterEvent("MERCHANT_CLOSED", updateSelling)