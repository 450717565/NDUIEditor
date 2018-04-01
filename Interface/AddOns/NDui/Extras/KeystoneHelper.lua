local B, C, L, DB = unpack(select(2, ...))

local MythicLootItemLevel = {  0 ,890 ,895 ,895 ,900 ,900 ,905 ,910 ,910 ,915 ,920 ,925 ,930 ,935 ,940}
local WeeklyLootItemLevel = {  0 ,910 ,910 ,915 ,915 ,920 ,925 ,925 ,930 ,935 ,940 ,945 ,950 ,955 ,960}

local numScreen = ""
local KeystoneHelper = NDui:EventFrame{"ADDON_LOADED"}
KeystoneHelper:SetScript("OnEvent", function(self, event, addonName, ...)
	if event == "ADDON_LOADED" and addonName == "Blizzard_ChallengesUI" then
		local iLvlFrm = CreateFrame("Frame", "LootLevel", ChallengesModeWeeklyBest)
		iLvlFrm:SetSize(200, 50)
		iLvlFrm:SetPoint("TOP", ChallengesModeWeeklyBest.Child.Level, "BOTTOM", 0, 5)
		iLvlFrm.text = B.CreateFS(iLvlFrm, 40, "", true)
		iLvlFrm.text:SetJustifyH("CENTER")
		iLvlFrm.text:SetJustifyV("MIDDLE")
		iLvlFrm:SetScript("OnUpdate", function(self, elaps)
			self.time = (self.time or 1) - elaps
			if self.time > 0 then
				return
			end

			while self.time <= 0 do
				if ChallengesModeWeeklyBest then
					numScreen = tonumber(ChallengesModeWeeklyBest.Child.Level:GetText())
					if numScreen > 15 then
						numScreen = 15
					end

					self.time = self.time + 1
					if WeeklyLootItemLevel[numScreen] and WeeklyLootItemLevel[numScreen] > 0 then
						self.text:SetText(WeeklyLootItemLevel[numScreen].."+")
					else
						self.text:SetText(L["No Weekly Item"])
					end
					self:SetScript("OnUpdate", nil)
				end
			end
		end)
	end
end)

local function GetModifiers(linkType, ...)
	if type(linkType) ~= "string" then return end
	local modifierOffset = 3
	local instanceID, mythicLevel, notDepleted, _ = ...

	if mythicLevel and mythicLevel ~= "" then
		mythicLevel = tonumber(mythicLevel)
		if mythicLevel and mythicLevel > 15 then
			mythicLevel = 15
		end
	else
		mythicLevel = nil
	end

	if linkType:find("item") then
		_, _, _, _, _, _, _, _, _, _, _, _, _, instanceID, mythicLevel = ...
		if ... == "138019" then
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
			tinsert(modifiers, modifierID)
		end
	end
	local numModifiers = #modifiers
	if modifiers[numModifiers] and modifiers[numModifiers] < 2 then
		tremove(modifiers, numModifiers)
	end
	return modifiers, instanceID, mythicLevel
end

local function DecorateTooltip(self)
	local _, link = self:GetItem()
	if type(link) == "string" and link:find("keystone") then
		local modifiers, instanceID, mythicLevel = GetModifiers(strsplit(":", link))
		local ilvl = MythicLootItemLevel[mythicLevel]
		local wlvl = WeeklyLootItemLevel[mythicLevel]
		if modifiers then
			self:AddLine(" ")
			for _, modifierID in ipairs(modifiers) do
				local modifierName, modifierDescription = C_ChallengeMode.GetAffixInfo(modifierID)
				if modifierName and modifierDescription then
					self:AddLine(format("|cffff0000%s|r - %s", modifierName, modifierDescription), 0, 1, 0, true)
				end
			end
		end
		if type(mythicLevel) == "number" and mythicLevel > 0 then
			self:AddLine(" ")
			self:AddLine("|cff00ffff"..L["Mythic Loot Item Level"]..ilvl.."+|r")
			self:AddLine("|cff00ffff"..L["Weekly Loot Item Level"]..wlvl.."+|r")
		end
		if modifiers or mythicLevel then
			self:Show()
		end
	end
end

hooksecurefunc(ItemRefTooltip, "SetHyperlink", DecorateTooltip)
ItemRefTooltip:HookScript("OnTooltipSetItem", DecorateTooltip)
GameTooltip:HookScript("OnTooltipSetItem", DecorateTooltip)