local function MythicLootItemLevel(mlvl)
	if (mlvl == "2" or mlvl == "3") then
		return "870+"
	elseif (mlvl == "4" or mlvl == "5") then
		return "875+"
	elseif (mlvl == "6" or mlvl == "7") then
		return "880+"
	elseif (mlvl == "8" or mlvl == "9") then
		return "885+"
	elseif (mlvl == "10") then
		return "890+"
	else
		return "890+"
	end
end

local function MythicWeeklyLootItemLevel(mlvl)
	if (mlvl == "0") then
		return "没有低保！"
	elseif (mlvl == "2") then
		return "875+"
	elseif (mlvl == "3") then
		return "880+"
	elseif (mlvl == "4") then
		return "885+"
	elseif (mlvl == "5" or mlvl == "6") then
		return "890+"
	elseif (mlvl == "7" or mlvl == "8") then
		return "895+"
	elseif (mlvl == "9") then
		return "900+"
	elseif (mlvl == "10") then
		return "905+"
	else
		return "905+"
	end
end

local function InsertKeystone(self)
	for bag = 0, NUM_BAG_SLOTS do
		for bagSlot = 1, GetContainerNumSlots(bag) do
			local _,_,_,_,_,_,itemName = GetContainerItemInfo(bag, bagSlot);
			if itemName  ~= nil and string.match(itemName, "Keystone") then
			   if (ChallengesKeystoneFrame:IsShown()) then
					PickupContainerItem(bag, bagSlot);
					if (CursorHasItem()) then
						C_ChallengeMode.SlotKeystone();
					end
				end
			end
		end
	end
end

local numScreen = ""
local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:SetScript("OnEvent", function(self, event, addonName, ...)
    if event == "ADDON_LOADED" and addonName == "Blizzard_ChallengesUI" then
		ChallengesKeystoneFrame:HookScript("OnShow", InsertKeystone)
		local iLvlFrm = CreateFrame("Frame", "LootLevel", ChallengesModeWeeklyBest)
		iLvlFrm:SetSize(200, 50)
		if IsAddOnLoaded('Aurora') then
			iLvlFrm:SetPoint("TOP", ChallengesModeWeeklyBest.Child.Level, "BOTTOM", 0, 0)
		else
			iLvlFrm:SetPoint("TOP", ChallengesModeWeeklyBest.Child.Level, "BOTTOM", 0, -50)
		end
		iLvlFrm.text = iLvlFrm:CreateFontString(nil, "MEDIUM", "GameFontHighlightLarge")
		iLvlFrm.text:SetAllPoints(iLvlFrm)
		iLvlFrm.text:SetFont(STANDARD_TEXT_FONT, 40, "OUTLINE")
		iLvlFrm.text:SetJustifyH("CENTER")
		iLvlFrm.text:SetTextColor(0, 1, 0, 1)
		iLvlFrm:SetScript("OnUpdate", function(self, elaps)
			self.time = (self.time or 1) - elaps
			if (self.time > 0) then
				return
			end
			while self.time <= 0 do
				if (ChallengesModeWeeklyBest) then
					numScreen = ChallengesModeWeeklyBest.Child.Level:GetText()
					self.time = self.time + 1
					self.text:SetText(MythicWeeklyLootItemLevel(numScreen))
					self:SetScript("OnUpdate", nil)
				end
			end
		end)
	end
end)

local function GetModifiers(linkType, ...)
	if type(linkType) ~= 'string' then return end
	local modifierOffset = 3
	local instanceID, mythicLevel, notDepleted, _ = ... -- "keystone" links
	if linkType:find('item') then -- only used for ItemRefTooltip currently
		_, _, _, _, _, _, _, _, _, _, _, _, _, instanceID, mythicLevel = ...
		if ... == '138019' then -- mythic keystone
			modifierOffset = 16
		else
			return
		end
	elseif not linkType:find('keystone') then
		return
	end

	local modifiers = {}
	for i = modifierOffset, select('#', ...) do
		local num = strmatch(select(i, ...) or '', '^(%d+)')
		if num then
			local modifierID = tonumber(num)
			--if not modifierID then break end
			tinsert(modifiers, modifierID)
		end
	end
	local numModifiers = #modifiers
	if modifiers[numModifiers] and modifiers[numModifiers] < 2 then
		tremove(modifiers, numModifiers)
	end
	return modifiers, instanceID, mythicLevel
end

local function DecorateTooltip(self, link, _)
	if not link then
		_, link = self:GetItem()
	end
	if type(link) == 'string' then
		local modifiers, instanceID, mythicLevel = GetModifiers(strsplit(':', link))
		local ilvl = MythicLootItemLevel(mythicLevel)
		local wlvl = MythicWeeklyLootItemLevel(mythicLevel)
		if modifiers then
			self:AddLine(" ")
			for _, modifierID in ipairs(modifiers) do
				local modifierName, modifierDescription = C_ChallengeMode.GetAffixInfo(modifierID)
				if modifierName and modifierDescription then
					self:AddLine(format('|cffff0000%s|r - %s', modifierName, modifierDescription), 0, 1, 0, true)
				end
			end
		end
		if mythicLevel then
			self:AddLine(" ")
			self:AddLine("|cff00ffff秘境箱子等级：" .. ilvl .. "|r")
			self:AddLine("|cff00ffff低保箱子等级：" .. wlvl .. "|r")
		end
		if modifiers or mythicLevel then
			self:Show()
		end
	end
end

-- hack to handle ItemRefTooltip:GetItem() not returning a proper keystone link
hooksecurefunc(ItemRefTooltip, 'SetHyperlink', DecorateTooltip) 
--ItemRefTooltip:HookScript('OnTooltipSetItem', DecorateTooltip)
GameTooltip:HookScript('OnTooltipSetItem', DecorateTooltip)