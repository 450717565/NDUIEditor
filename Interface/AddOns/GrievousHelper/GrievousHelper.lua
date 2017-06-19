local L = select(2, ...).L
if IsAddOnLoaded("163UI_Plugins") then return end

local U1Message = U1Message or function(text, r, g, b, chatFrame)
	(chatFrame or DEFAULT_CHAT_FRAME):AddMessage(L"|cffcd1a1c[Grievous Helper]|r - "..text, r, g, b);
end

do
	local DEBUG = false
	local debug = DEBUG and print or function() end
	local function findEmptyBagSlots()
		for bag = 0, 4 do
			local slots, family = GetContainerNumFreeSlots(bag)
			if slots > 0 then
				for slot = 1, GetContainerNumSlots(bag) do
					if not GetContainerItemID(bag, slot) then
						return bag, slot
					end
				end
			end
		end
		U1Message(L"all bags are full")
	end

	local function putDownItem(bag)

		if bag == 0 then
			PutItemInBackpack()
		else
			PutItemInBag(19 + bag)
		end
	end

	local zbwq = CreateFrame("CheckButton", "zbwq", UIParent, "ActionButtonTemplate,SecureActionButtonTemplate")
	zbwq:SetPoint("CENTER")
	zbwq.icon:SetTexture(132343) --缴械图标
	RegisterStateDriver(zbwq, "visibility", "[combat, noworn:" .. GetItemClassInfo(LE_ITEM_CLASS_WEAPON) .. "] show; hide")
	ActionButton_ShowOverlayGlow(zbwq)
	zbwq:HookScript("OnClick", function(self)
		self.state = 4 --not show wearback info
	end)

	zbwq:SetAttribute("type", "macro")

	local ENABLE_AUTO_OFF = false
	local advised = false
	SlashCmdList["GRIEVOUS_HELPER"] = function()
		if not ENABLE_AUTO_OFF then
			U1Message(L"enabled")
			if not advised and GetLocale() == "zhCN" then
				U1Message("作者：桂花猫猫-暗影之月")
				advised = true
			end
		else
			U1Message(L"disabled")
		end
		ENABLE_AUTO_OFF = not ENABLE_AUTO_OFF
	end
	_G["SLASH_GRIEVOUS_HELPER1"] = "/zszs"
	_G["SLASH_GRIEVOUS_HELPER2"] = "/重伤助手"

	local UnitAura = UnitAura
	local debuffName = GetSpellInfo(240559)
	local function GetHP()
		return UnitHealth("player") / UnitHealthMax("player")
	end
	local function UnitHasDebuff()
		if DEBUG then
			return GetHP() < 0.95
		else
			return UnitAura("player", debuffName, nil, "HARMFUL")
		end
	end

	function U1_TakeOffWeapons()
		local equips = {}
		local link16 = GetInventoryItemLink("player", 16)
		if not link16 then return end
		local bag, slot = findEmptyBagSlots()
		if not bag then return end
		if link16 then
			PickupInventoryItem(16)
			if CursorHasItem() then
				local item, id, link = GetCursorInfo()
				assert(item == "item", "cursor is not item")
				zbwq.bag = bag
				zbwq.slot = slot
				PickupContainerItem(bag, slot)
				zbwq.state = 1
				zbwq:SetAttribute("macrotext", format("/use %d %d", bag, slot))
				U1Message(L"artifacts taken off")
				debug("takeoff", link16, zbwq.bag, zbwq.slot, zbwq:GetAttribute("macrotext"))

				if not zbwq.timer then
					zbwq.timer = C_Timer.NewTicker(0.1, U1_WearBackWeapons)
				end
			end
		end
	end

	function U1_WearBackWeapons()
		if not zbwq.state or zbwq.state < 2 or not zbwq.bag then return end
		if InCombatLockdown() or UnitIsDeadOrGhost("player") then return end
		if not UnitHasDebuff() then
			local link16 = GetInventoryItemLink("player", 16)
			debug("wearback", link16, zbwq.bag, zbwq.slot, zbwq:GetAttribute("macrotext"))
			if zbwq.bag and not link16 and select(4, GetContainerItemInfo(zbwq.bag, zbwq.slot)) == 6 then
				UseContainerItem(zbwq.bag, zbwq.slot)
				zbwq.state = 3
			end
		end
	end

	local f = CreateFrame("Frame")
	f:RegisterEvent("PLAYER_REGEN_ENABLED")
	f:RegisterEvent("PLAYER_REGEN_DISABLED")
	f:RegisterUnitEvent("UNIT_HEALTH", "player")
	f:RegisterUnitEvent("UNIT_INVENTORY_CHANGED", "player")
	f:SetScript("OnEvent", function(self, event, ...)
		if event == "PLAYER_REGEN_ENABLED" then
			if ENABLE_AUTO_OFF and UnitHasDebuff() then
				if select(5, GetSpecializationInfo(GetSpecialization())) == "HEALER" then
					if not f.healder then
						f.healder = true
						U1Message(L"not for healers")
					end
					return
				end
				U1_TakeOffWeapons()
			end

		elseif event == "UNIT_INVENTORY_CHANGED" then
			local link16 = GetInventoryItemLink("player", 16)
			if zbwq.state and zbwq.state > 0 then
				debug(zbwq.state, link16, zbwq.bag, zbwq.slot, zbwq:GetAttribute("macrotext"))
			end
			if zbwq.state == 1 and not link16 then
				--taken off, start trying wear back
				zbwq.state = 2
			elseif zbwq.state == 3 and link16 then
				--wear back success
				zbwq.state = 0
				zbwq.bag = nil
				U1Message(L"artifacts worn back")
			elseif zbwq.state == 4 and link16 then
				zbwq.state = 0
				zbwq.bag = nil
			end

		elseif event == "PLAYER_REGEN_DISABLED" then
			if ENABLE_AUTO_OFF and not GetInventoryItemLink("player", 16) then
				U1Message(L"click the button to put on artifacts in combat")
			end

		elseif event == "UNIT_HEALTH" then
			U1_WearBackWeapons()
		end
	end)
end