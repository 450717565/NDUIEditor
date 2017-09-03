local B, C, L, DB = unpack(select(2, ...))

local function MythicLootItemLevel(mlvl)
	if mlvl == "2" then
		return "890+"
	elseif mlvl == "3" or mlvl == "4" then
		return "895+"
	elseif mlvl == "5" then
		return "900+"
	elseif mlvl == "6" or mlvl == "7" then
		return "905+"
	elseif mlvl == "8" or mlvl == "9" then
		return "910+"
	elseif mlvl == "10" then
		return "915+"
	else
		return "915+"
	end
end

local function WeeklyLootItemLevel(mlvl)
	if mlvl == "0" then
		return "没有低保！"
	elseif mlvl == "2" then
		return "905+"
	elseif mlvl == "3" then
		return "910+"
	elseif mlvl == "4" then
		return "915+"
	elseif mlvl == "5" or mlvl == "6" then
		return "920+"
	elseif mlvl == "7" or mlvl == "8" then
		return "925+"
	elseif mlvl == "9" then
		return "930+"
	elseif mlvl == "10" then
		return "935+"
	else
		return "935+"
	end
end

local numScreen = ""
local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:SetScript("OnEvent", function(self, event, addonName, ...)
	if event == "ADDON_LOADED" and addonName == "Blizzard_ChallengesUI" then
		local iLvlFrm = CreateFrame("Frame", "LootLevel", ChallengesModeWeeklyBest)
		iLvlFrm:SetSize(200, 50)
		iLvlFrm:SetPoint("TOP", ChallengesModeWeeklyBest.Child.Level, "BOTTOM", 0, 5)
		iLvlFrm.text = B.CreateFS(iLvlFrm, 40, "", true)
		iLvlFrm.text:SetJustifyH("CENTER")
		iLvlFrm:SetScript("OnUpdate", function(self, elaps)
			self.time = (self.time or 1) - elaps
			if self.time > 0 then
				return
			end
			while self.time <= 0 do
				if ChallengesModeWeeklyBest then
					numScreen = ChallengesModeWeeklyBest.Child.Level:GetText()
					self.time = self.time + 1
					self.text:SetText(WeeklyLootItemLevel(numScreen))
					self:SetScript("OnUpdate", nil)
				end
			end
		end)
	end
end)

local function GetModifiers(linkType, ...)
	if type(linkType) ~= "string" then return end
	local modifierOffset = 3
	local instanceID, mythicLevel, notDepleted, _ = ... -- "keystone" links
	if linkType:find("item") then -- only used for ItemRefTooltip currently
		_, _, _, _, _, _, _, _, _, _, _, _, _, instanceID, mythicLevel = ...
		if ... == "138019" then -- mythic keystone
			modifierOffset = 16
		else
			return
		end
	elseif not linkType:find("keystone") then
		return
	end

	local modifiers = {}
	for i = modifierOffset, select("#", ...) do
		local num = strmatch(select(i, ...) or "", "^(%d+)")
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
	if type(link) == "string" then
		local modifiers, instanceID, mythicLevel = GetModifiers(strsplit(":", link))
		local ilvl = MythicLootItemLevel(mythicLevel)
		local wlvl = WeeklyLootItemLevel(mythicLevel)
		if modifiers then
			self:AddLine(" ")
			for _, modifierID in ipairs(modifiers) do
				local modifierName, modifierDescription = C_ChallengeMode.GetAffixInfo(modifierID)
				if modifierName and modifierDescription then
					self:AddLine(format("|cffff0000%s|r - %s", modifierName, modifierDescription), 0, 1, 0, true)
				end
			end
		end
		if mythicLevel then
			self:AddLine(" ")
			self:AddLine("|cff00ffff秘境箱子等级："..ilvl.."|r")
			self:AddLine("|cff00ffff低保箱子等级："..wlvl.."|r")
		end
		if modifiers or mythicLevel then
			self:Show()
		end
	end
end

hooksecurefunc(ItemRefTooltip, "SetHyperlink", DecorateTooltip)
GameTooltip:HookScript("OnTooltipSetItem", DecorateTooltip)