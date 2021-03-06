local _, ns = ...
local B, C, L, DB = unpack(ns)
local MISC = B:GetModule("Misc")

--[[
	一个工具条用来替代系统的经验条、声望条、神器经验等等
]]
local format, pairs, select = string.format, pairs, select
local min, mod, floor = math.min, mod, math.floor
local MAX_REPUTATION_REACTION = MAX_REPUTATION_REACTION
local FACTION_BAR_COLORS = FACTION_BAR_COLORS
local NUM_FACTIONS_DISPLAYED = NUM_FACTIONS_DISPLAYED
local REPUTATION_PROGRESS_FORMAT = REPUTATION_PROGRESS_FORMAT
local HONOR, LEVEL, TUTORIAL_TITLE26, SPELLBOOK_AVAILABLE_AT = HONOR, LEVEL, TUTORIAL_TITLE26, SPELLBOOK_AVAILABLE_AT
local ARTIFACT_POWER, ARTIFACT_RETIRED = ARTIFACT_POWER, ARTIFACT_RETIRED

local UnitLevel, UnitXP, UnitXPMax, GetXPExhaustion, IsXPUserDisabled = UnitLevel, UnitXP, UnitXPMax, GetXPExhaustion, IsXPUserDisabled
local GetText, UnitSex, BreakUpLargeNumbers, GetNumFactions, GetFactionInfo = GetText, UnitSex, BreakUpLargeNumbers, GetNumFactions, GetFactionInfo
local GetWatchedFactionInfo, GetFriendshipReputation, GetFriendshipReputationRanks = GetWatchedFactionInfo, GetFriendshipReputation, GetFriendshipReputationRanks
local HasArtifactEquipped, ArtifactBarGetNumArtifactTraitsPurchasableFromXP = HasArtifactEquipped, ArtifactBarGetNumArtifactTraitsPurchasableFromXP
local IsWatchingHonorAsXP, UnitHonor, UnitHonorMax, UnitHonorLevel = IsWatchingHonorAsXP, UnitHonor, UnitHonorMax, UnitHonorLevel
local IsPlayerAtEffectiveMaxLevel = IsPlayerAtEffectiveMaxLevel
local C_Reputation_IsFactionParagon = C_Reputation.IsFactionParagon
local C_Reputation_GetFactionParagonInfo = C_Reputation.GetFactionParagonInfo
local C_AzeriteItem_IsAzeriteItemAtMaxLevel = C_AzeriteItem.IsAzeriteItemAtMaxLevel
local C_AzeriteItem_FindActiveAzeriteItem = C_AzeriteItem.FindActiveAzeriteItem
local C_AzeriteItem_GetAzeriteItemXPInfo = C_AzeriteItem.GetAzeriteItemXPInfo
local C_AzeriteItem_GetPowerLevel = C_AzeriteItem.GetPowerLevel
local C_ArtifactUI_IsEquippedArtifactDisabled = C_ArtifactUI.IsEquippedArtifactDisabled
local C_ArtifactUI_GetEquippedArtifactInfo = C_ArtifactUI.GetEquippedArtifactInfo

local function IsAzeriteAvailable()
	local itemLocation = C_AzeriteItem_FindActiveAzeriteItem()
	return itemLocation and itemLocation:IsEquipmentSlot() and not C_AzeriteItem_IsAzeriteItemAtMaxLevel()
end

function MISC:ExpBar_Update()
	local rest = self.restBar
	if rest then rest:Hide() end

	if not IsPlayerAtEffectiveMaxLevel() then
		local xp, mxp, rxp = UnitXP("player"), UnitXPMax("player"), GetXPExhaustion()
		self:SetStatusBarColor(0, .7, 1, C.alpha)
		self:SetMinMaxValues(0, mxp)
		self:SetValue(xp)
		self:Show()
		if rxp then
			rest:SetMinMaxValues(0, mxp)
			rest:SetValue(min(xp + rxp, mxp))
			rest:Show()
		end
		if IsXPUserDisabled() then self:SetStatusBarColor(.7, 0, 0, C.alpha) end
	elseif GetWatchedFactionInfo() then
		local _, standing, barMin, barMax, value, factionID = GetWatchedFactionInfo()
		local friendID, friendRep, _, _, _, _, _, friendThreshold, nextFriendThreshold = GetFriendshipReputation(factionID)
		if friendID then
			if nextFriendThreshold then
				barMin, barMax, value = friendThreshold, nextFriendThreshold, friendRep
			else
				barMin, barMax, value = 0, 1, 1
			end
			standing = 5
		elseif C_Reputation_IsFactionParagon(factionID) then
			local currentValue, threshold = C_Reputation_GetFactionParagonInfo(factionID)
			currentValue = mod(currentValue, threshold)
			barMin, barMax, value = 0, threshold, currentValue
		else
			if standing == MAX_REPUTATION_REACTION then barMin, barMax, value = 0, 1, 1 end
		end
		self:SetStatusBarColor(FACTION_BAR_COLORS[standing].r, FACTION_BAR_COLORS[standing].g, FACTION_BAR_COLORS[standing].b, C.alpha)
		self:SetMinMaxValues(barMin, barMax)
		self:SetValue(value)
		self:Show()
	elseif IsWatchingHonorAsXP() then
		local current, barMax = UnitHonor("player"), UnitHonorMax("player")
		self:SetStatusBarColor(1, .24, 0, C.alpha)
		self:SetMinMaxValues(0, barMax)
		self:SetValue(current)
		self:Show()
	elseif IsAzeriteAvailable() then
		local azeriteItemLocation = C_AzeriteItem_FindActiveAzeriteItem()
		local xp, totalLevelXP = C_AzeriteItem_GetAzeriteItemXPInfo(azeriteItemLocation)
		self:SetStatusBarColor(.9, .8, .6, C.alpha)
		self:SetMinMaxValues(0, totalLevelXP)
		self:SetValue(xp)
		self:Show()
	elseif HasArtifactEquipped() then
		if C_ArtifactUI_IsEquippedArtifactDisabled() then
			self:SetStatusBarColor(.6, .6, .6, C.alpha)
			self:SetMinMaxValues(0, 1)
			self:SetValue(1)
		else
			local _, _, _, _, totalXP, pointsSpent, _, _, _, _, _, _, artifactTier = C_ArtifactUI_GetEquippedArtifactInfo()
			local _, xp, xpForNextPoint = ArtifactBarGetNumArtifactTraitsPurchasableFromXP(pointsSpent, totalXP, artifactTier)
			xp = xpForNextPoint == 0 and 0 or xp
			self:SetStatusBarColor(.9, .8, .6, C.alpha)
			self:SetMinMaxValues(0, xpForNextPoint)
			self:SetValue(xp)
		end
		self:Show()
	else
		self:Hide()
	end
end

function MISC:ExpBar_UpdateTooltip()
	GameTooltip:SetOwner(self, "ANCHOR_LEFT")
	GameTooltip:ClearLines()
	GameTooltip:AddLine(LEVEL.." "..UnitLevel("player"), 0,.6,1)

	if not IsPlayerAtEffectiveMaxLevel() then
		GameTooltip:AddLine(" ")
		local xp, mxp, rxp = UnitXP("player"), UnitXPMax("player"), GetXPExhaustion()
			GameTooltip:AddDoubleLine(EXPERIENCE_COLON, format("%s / %s (%.1f%%)", B.FormatNumb(xp), B.FormatNumb(mxp), xp/mxp*100), .6,.8,1, 1,1,1)
			GameTooltip:AddDoubleLine(NEXT_RANK_COLON, format("%s (%.1f%%)", B.FormatNumb(mxp-xp), (1-xp/mxp)*100), .6,.8,1, 1,1,1)
		if rxp then
			GameTooltip:AddDoubleLine(TUTORIAL_TITLE26.."：", format("+%s (%.1f%%)", B.FormatNumb(rxp), rxp/mxp*100), .6,.8,1, 1,1,1)
		end
		if IsXPUserDisabled() then GameTooltip:AddLine("|cffFF0000"..XP..LOCKED) end
	end

	if GetWatchedFactionInfo() then
		local name, standing, barMin, barMax, value, factionID = GetWatchedFactionInfo()
		local friendID, _, _, _, _, _, friendTextLevel, _, nextFriendThreshold = GetFriendshipReputation(factionID)
		local currentRank, maxRank = GetFriendshipReputationRanks(friendID)
		local standingtext
		if friendID then
			if maxRank > 0 then
				name = name.." ("..currentRank.." / "..maxRank..")"
			end
			if not nextFriendThreshold then
				barMax = barMin + 1e3
				value = barMax - 1
			end
			standingtext = friendTextLevel
		else
			if standing == MAX_REPUTATION_REACTION then
				barMax = barMin + 1e3
				value = barMax - 1
			end
			standingtext = GetText("FACTION_STANDING_LABEL"..standing, UnitSex("player"))
		end

		local curValue, maxValue = value - barMin, barMax - barMin
		GameTooltip:AddLine(" ")
		if curValue < 0 then
			GameTooltip:AddLine(name, 0,.6,1)
			GameTooltip:AddLine(standingtext, .6,.8,1)
		else
			GameTooltip:AddLine(name, 0,.6,1)
			GameTooltip:AddDoubleLine(standingtext, format("%s / %s (%.1f%%)", curValue, maxValue, curValue/maxValue*100), .6,.8,1, 1,1,1)
		end

		if C_Reputation_IsFactionParagon(factionID) then
			local currentValue, threshold = C_Reputation_GetFactionParagonInfo(factionID)
			local paraCount = floor(currentValue/threshold)
			currentValue = mod(currentValue, threshold)
			GameTooltip:AddDoubleLine(L["Paragon"]..paraCount, format("%s / %s (%.1f%%)", currentValue, threshold, currentValue/threshold*100), .6,.8,1, 1,1,1)
		end

		if factionID == 2465 then -- 荒猎团
			local _, rep, _, name, _, _, reaction, threshold, nextThreshold = GetFriendshipReputation(2463) -- 玛拉斯缪斯
			if nextThreshold and rep > 0 then
				local current = rep - threshold
				local currentMax = nextThreshold - threshold
				GameTooltip:AddLine(" ")
				GameTooltip:AddLine(name, 0,.6,1)
				GameTooltip:AddDoubleLine(reaction, format("%s / %s (%.1f%%)", current, currentMax, current/currentMax*100), .6,.8,1, 1,1,1)
			end
		end
	end

	if IsWatchingHonorAsXP() then
		local current, barMax, level = UnitHonor("player"), UnitHonorMax("player"), UnitHonorLevel("player")
		GameTooltip:AddLine(" ")
		GameTooltip:AddLine(HONOR, 0,.6,1)
		GameTooltip:AddDoubleLine(LEVEL.." "..level, current.." / "..barMax, .6,.8,1, 1,1,1)
	end

	if IsAzeriteAvailable() then
		local azeriteItemLocation = C_AzeriteItem_FindActiveAzeriteItem()
		local azeriteItem = Item:CreateFromItemLocation(azeriteItemLocation)
		local xp, totalLevelXP = C_AzeriteItem_GetAzeriteItemXPInfo(azeriteItemLocation)
		local currentLevel = C_AzeriteItem_GetPowerLevel(azeriteItemLocation)
		local isMaxLevel = C_AzeriteItem_IsAzeriteItemAtMaxLevel()
		if not isMaxLevel then
			azeriteItem:ContinueWithCancelOnItemLoad(function()
				local azeriteItemName = azeriteItem:GetItemName()
				GameTooltip:AddLine(" ")
				GameTooltip:AddLine(azeriteItemName.." "..currentLevel, 0,.6,1)
				GameTooltip:AddDoubleLine(ARTIFACT_POWER.."：", format("%s / %s (%.1f%%)", B.FormatNumb(xp), B.FormatNumb(totalLevelXP), xp/totalLevelXP*100), .6,.8,1, 1,1,1)
				GameTooltip:AddDoubleLine(NEXT_RANK_COLON, format("%s (%.1f%%)", B.FormatNumb(totalLevelXP-xp), (1-xp/totalLevelXP)*100), .6,.8,1, 1,1,1)
			end)
		end
	end

	if HasArtifactEquipped() then
		local _, _, name, _, totalXP, pointsSpent, _, _, _, _, _, _, artifactTier = C_ArtifactUI_GetEquippedArtifactInfo()
		local num, xp, xpForNextPoint = ArtifactBarGetNumArtifactTraitsPurchasableFromXP(pointsSpent, totalXP, artifactTier)
		GameTooltip:AddLine(" ")
		if C_ArtifactUI_IsEquippedArtifactDisabled() then
			GameTooltip:AddLine(name, 0,.6,1)
			GameTooltip:AddLine(ARTIFACT_RETIRED, .6,.8,1, 1)
		else
			GameTooltip:AddLine(name.." "..pointsSpent, 0,.6,1)
			local numText = num > 0 and " ("..num..")" or ""
			GameTooltip:AddDoubleLine(ARTIFACT_POWER.."：", B.FormatNumb(totalXP)..numText, .6,.8,1, 1,1,1)
			if xpForNextPoint ~= 0 then
				GameTooltip:AddDoubleLine(NEXT_ABILITY.."：", format("%s / %s (%.1f%%)", B.FormatNumb(xp), B.FormatNumb(xpForNextPoint), xp/xpForNextPoint*100), .6,.8,1, 1,1,1)
				GameTooltip:AddDoubleLine(GARRISON_FOLLOWER_XP_UPGRADE_STRING.."：", format("%s (%.1f%%)", B.FormatNumb(xpForNextPoint-xp), (1-xp/xpForNextPoint)*100), .6,.8,1, 1,1,1)
			end
		end
	end
	GameTooltip:Show()
end

function MISC:SetupScript(bar)
	bar.eventList = {
		"PLAYER_XP_UPDATE",
		"PLAYER_LEVEL_UP",
		"UPDATE_EXHAUSTION",
		"PLAYER_ENTERING_WORLD",
		"UPDATE_FACTION",
		"ARTIFACT_XP_UPDATE",
		"PLAYER_EQUIPMENT_CHANGED",
		"ENABLE_XP_GAIN",
		"DISABLE_XP_GAIN",
		"AZERITE_ITEM_EXPERIENCE_CHANGED",
		"HONOR_XP_UPDATE",
	}
	for _, event in pairs(bar.eventList) do
		bar:RegisterEvent(event)
	end
	bar:SetScript("OnEvent", MISC.ExpBar_Update)
	bar:SetScript("OnEnter", MISC.ExpBar_UpdateTooltip)
	bar:SetScript("OnLeave", B.HideTooltip)
	bar:SetScript("OnMouseUp", function(_, btn)
		if not HasArtifactEquipped() or btn ~= "LeftButton" then return end
		if not ArtifactFrame or not ArtifactFrame:IsShown() then
			SocketInventoryItem(16)
		else
			B.TogglePanel(ArtifactFrame)
		end
	end)
	hooksecurefunc(StatusTrackingBarManager, "UpdateBarsShown", function()
		MISC.ExpBar_Update(bar)
	end)
end

function MISC:Expbar()
	if not C.db["Misc"]["ExpRep"] then return end

	local bar = B.CreateSB(MinimapCluster)
	bar:SetPoint("TOPLEFT", Minimap, "BOTTOMLEFT", 0, -5)
	bar:SetPoint("TOPRIGHT", Minimap, "BOTTOMRIGHT", 0, -5)
	bar:SetHeight(6)
	bar:SetHitRectInsets(0, 0, 0, -10)
	B.SmoothSB(bar)

	local rest = CreateFrame("StatusBar", nil, bar)
	rest:SetAllPoints()
	rest:SetStatusBarTexture(DB.normTex)
	rest:SetStatusBarColor(0, .4, 1, C.alpha)
	bar.restBar = rest

	MISC:SetupScript(bar)
end
MISC:RegisterMisc("ExpRep", MISC.Expbar)

-- Paragon reputation info
function MISC:HookParagonRep()
	ReputationFrame.paragonFramesPool:ReleaseAll()
	local numFactions = GetNumFactions()
	local factionOffset = FauxScrollFrame_GetOffset(ReputationListScrollFrame)

	for i = 1, NUM_FACTIONS_DISPLAYED, 1 do
		local factionIndex = factionOffset + i
		local factionRow = _G["ReputationBar"..i]
		local factionBar = _G["ReputationBar"..i.."ReputationBar"]
		local factionStanding = _G["ReputationBar"..i.."ReputationBarFactionStanding"]

		if factionIndex <= numFactions then
			local standingID = select(3, GetFactionInfo(factionIndex))
			local factionID = select(14, GetFactionInfo(factionIndex))

			if not factionID then return end

			local isParagon = C_Reputation_IsFactionParagon(factionID)
			local friendID = GetFriendshipReputation(factionID)

			if isParagon then
				local currentValue, threshold, _, hasRewardPending = C_Reputation_GetFactionParagonInfo(factionID)
				if currentValue and threshold then
					local barValue = mod(currentValue, threshold)
					local factionStandingtext = L["Paragon"]..floor(currentValue/threshold)

					if hasRewardPending then
						local paragonFrame = ReputationFrame.paragonFramesPool:Acquire()
						paragonFrame.factionID = factionID
						paragonFrame.Check:SetShown(true)
						paragonFrame.Glow:SetShown(true)
						paragonFrame:SetPoint("RIGHT", factionRow, 11, 0)
						paragonFrame:Show()
					end

					factionBar:SetMinMaxValues(0, threshold)
					factionBar:SetStatusBarColor(0, .6, 1, C.alpha)
					factionBar:SetValue(barValue)
					factionRow.rolloverText = format(REPUTATION_PROGRESS_FORMAT, BreakUpLargeNumbers(barValue), BreakUpLargeNumbers(threshold))
					factionRow.standingText = factionStandingtext
					factionStanding:SetText(factionStandingtext)
				end
			elseif friendID then
				factionBar:SetStatusBarColor(0, 1, 1, C.alpha)
			end
		end
	end
end

function MISC:ParagonReputationSetup()
	if not C.db["Misc"]["ParagonRep"] then return end
	hooksecurefunc("ReputationFrame_Update", MISC.HookParagonRep)
end
MISC:RegisterMisc("ParagonRep", MISC.ParagonReputationSetup)