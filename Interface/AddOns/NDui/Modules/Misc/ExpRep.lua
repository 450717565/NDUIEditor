local B, C, L, DB = unpack(select(2, ...))
local module = NDui:GetModule("Misc")

--[[
	一个工具条用来替代系统的经验条、声望条、神器经验等等
]]
function module:Expbar()
	if not NDuiDB["Misc"]["ExpRep"] then return end

	local ExpRep = CreateFrame("StatusBar", nil, Minimap)
	ExpRep:SetPoint("TOP", Minimap, "BOTTOM", 0, -5)
	ExpRep:SetSize(Minimap:GetWidth() - 10, 4)
	ExpRep:SetHitRectInsets(0, 0, 0, -10)
	B.CreateSB(ExpRep, true)

	local Rest = CreateFrame("StatusBar", nil, ExpRep)
	Rest:SetAllPoints()
	Rest:SetStatusBarTexture(DB.normTex)
	Rest:SetStatusBarColor(0, .4, 1, .6)
	Rest:SetFrameLevel(ExpRep:GetFrameLevel() - 1)

	local newPoint = ExpRep:CreateTexture(nil, "OVERLAY")
	newPoint:SetTexture("Interface\\COMMON\\ReputationStar")
	newPoint:SetTexCoord(.5, 1, .5, 1)
	newPoint:SetSize(18, 18)
	newPoint:SetPoint("CENTER", 0, -2)

	local function UpdateData(self)
		newPoint:SetAlpha(0)
		if UnitLevel("player") < MAX_PLAYER_LEVEL then
			local xp, mxp, rxp = UnitXP("player"), UnitXPMax("player"), GetXPExhaustion()
			self:SetStatusBarColor(0, .7, 1)
			self:SetMinMaxValues(0, mxp)
			self:SetValue(xp)
			self:Show()
			if rxp then
				Rest:SetMinMaxValues(0, mxp)
				Rest:SetValue(math.min(xp + rxp, mxp))
				Rest:Show()
			else
				Rest:Hide()
			end
			if IsXPUserDisabled() then self:SetStatusBarColor(.7, 0, 0) end
		elseif GetWatchedFactionInfo() then
			local _, standing, minvalue, maxvalue, value, factionID = GetWatchedFactionInfo()
			local friendID, friendRep, _, _, _, _, _, friendThreshold, nextFriendThreshold = GetFriendshipReputation(factionID)
			if friendID then
				if nextFriendThreshold then
					minvalue, maxvalue, value = friendThreshold, nextFriendThreshold, friendRep
				else
					minvalue, maxvalue, value = 0, 1, 1
				end
				standing = 5
			elseif C_Reputation.IsFactionParagon(factionID) then
				local currentValue, threshold = C_Reputation.GetFactionParagonInfo(factionID)
				currentValue = mod(currentValue, threshold)
				minvalue, maxvalue, value = 0, threshold, currentValue
			else
				if standing == MAX_REPUTATION_REACTION then
					minvalue, maxvalue, value = 0, 1, 1
				end
			end
			self:SetStatusBarColor(FACTION_BAR_COLORS[standing].r, FACTION_BAR_COLORS[standing].g, FACTION_BAR_COLORS[standing].b, .85)
			self:SetMinMaxValues(minvalue, maxvalue)
			self:SetValue(value)
			self:Show()
			Rest:Hide()
		elseif HasArtifactEquipped() then
			local _, _, _, _, totalXP, pointsSpent, _, _, _, _, _, _, artifactTier = C_ArtifactUI.GetEquippedArtifactInfo()
			local _, xp, xpForNextPoint = MainMenuBar_GetNumArtifactTraitsPurchasableFromXP(pointsSpent, totalXP, artifactTier)
			self:SetStatusBarColor(.9, .8, .6)
			self:SetMinMaxValues(0, xpForNextPoint)
			self:SetValue(xp)
			self:Show()
			Rest:Hide()
		else
			self:Hide()
			Rest:Hide()
		end

		-- Available ArtfactPoint
		if HasArtifactEquipped() then
			local _, _, _, _, totalXP, pointsSpent, _, _, _, _, _, _, artifactTier = C_ArtifactUI.GetEquippedArtifactInfo()
			local num = MainMenuBar_GetNumArtifactTraitsPurchasableFromXP(pointsSpent, totalXP, artifactTier)
			if num > 0 then newPoint:SetAlpha(1) end
		end
	end

	local function SetTooltip(self)
		GameTooltip:SetOwner(self, "ANCHOR_LEFT")
		GameTooltip:ClearLines()
		GameTooltip:AddLine(LEVEL.." "..UnitLevel("player"), 0,.6,1)

		if UnitLevel("player") < MAX_PLAYER_LEVEL then
			local xp, mxp, rxp = UnitXP("player"), UnitXPMax("player"), GetXPExhaustion()
			GameTooltip:AddDoubleLine(XP..": ", B.Numb(xp).." / "..B.Numb(mxp).." ("..string.format("%.1f", xp/mxp*100).."%)", .6,.8,1, 1,1,1)
			GameTooltip:AddDoubleLine(L["Need XP"]..": ", B.Numb(mxp-xp).." ("..string.format("%.1f", (1-xp/mxp)*100).."%)", .6,.8,1, 1,1,1)
			if rxp then
				GameTooltip:AddDoubleLine(TUTORIAL_TITLE26..": ", "+"..B.Numb(rxp).." ("..string.format("%.1f", rxp/mxp*100).."%)", .6,.8,1, 1,1,1)
			end
			if IsXPUserDisabled() then GameTooltip:AddLine("|cffff0000"..XP..LOCKED) end
		end

		if GetWatchedFactionInfo() then
			local name, standing, minvalue, maxvalue, value, factionID = GetWatchedFactionInfo()
			local friendID, _, _, _, _, _, friendTextLevel, _, nextFriendThreshold = GetFriendshipReputation(factionID)
			local currentRank, maxRank = GetFriendshipReputationRanks(friendID)
			local standingtext
			if friendID then
				if maxRank > 0 then
				name = name.." ("..currentRank.." / "..maxRank..")"
				end
				if not nextFriendThreshold then
					value = maxvalue - 1
				end
				standingtext = friendTextLevel
			else
				if standing == MAX_REPUTATION_REACTION then
					maxvalue = minvalue + 1e3
					value = maxvalue - 1
				end
				standingtext = GetText("FACTION_STANDING_LABEL"..standing, UnitSex("player"))
			end
			GameTooltip:AddLine(" ")
			GameTooltip:AddLine(name, 0,.6,1)
			GameTooltip:AddDoubleLine(standingtext, value - minvalue.." / "..maxvalue - minvalue.." ("..string.format("%.1f", (value - minvalue)/(maxvalue - minvalue)*100).."%)", .6,.8,1, 1,1,1)
			if C_Reputation.IsFactionParagon(factionID) then
				local currentValue, threshold = C_Reputation.GetFactionParagonInfo(factionID)
				local paraCount = floor(currentValue/threshold)
				currentValue = mod(currentValue, threshold)
				GameTooltip:AddDoubleLine(L["ParagonRep"]..paraCount, currentValue.." / "..threshold.." ("..string.format("%.1f", (currentValue/threshold*100)).."%)", .6,.8,1, 1,1,1)
			end
		end

		if IsWatchingHonorAsXP() then
			local current, maxvalue = UnitHonor("player"), UnitHonorMax("player")
			local level, levelmax = UnitHonorLevel("player"), GetMaxPlayerHonorLevel()
			local text
			if CanPrestige() then
				text = PVP_HONOR_PRESTIGE_AVAILABLE
			elseif level == levelmax then
				text = MAX_HONOR_LEVEL
			else
				text = current.." / "..maxvalue
			end
			GameTooltip:AddLine(" ")
			if UnitPrestige("player") > 0 then
				GameTooltip:AddLine(select(2, GetPrestigeInfo(UnitPrestige("player"))), .0,.6,1)
			else
				GameTooltip:AddLine(PVP_PRESTIGE_RANK_UP_TITLE..LEVEL.."0", .0,.6,1)
			end
			GameTooltip:AddDoubleLine(HONOR_POINTS..LEVEL..level, text, .6,.8,1, 1,1,1)
		end

		if HasArtifactEquipped() then
			local _, _, name, _, totalXP, pointsSpent, _, _, _, _, _, _, artifactTier = C_ArtifactUI.GetEquippedArtifactInfo()
			local num, xp, xpForNextPoint = MainMenuBar_GetNumArtifactTraitsPurchasableFromXP(pointsSpent, totalXP, artifactTier)
			GameTooltip:AddLine(" ")
			if pointsSpent > 51 then
				GameTooltip:AddLine(name.." ("..format(SPELLBOOK_AVAILABLE_AT, pointsSpent).." - "..format(SPELLBOOK_AVAILABLE_AT, (pointsSpent-51))..")", 0,.6,1)
			else
				GameTooltip:AddLine(name.." ("..format(SPELLBOOK_AVAILABLE_AT, pointsSpent)..")", 0,.6,1)
			end
			GameTooltip:AddDoubleLine(ARTIFACT_POWER..": ", B.Numb(totalXP).." ("..num..")", .6,.8,1, 1,1,1)
			GameTooltip:AddDoubleLine(L["Next Trait"]..": ", B.Numb(xp).." / "..B.Numb(xpForNextPoint).." ("..string.format("%.1f", xp/xpForNextPoint*100).."%)", .6,.8,1, 1,1,1)
			GameTooltip:AddDoubleLine(L["Need Trait"]..": ", B.Numb(xpForNextPoint-xp).." ("..string.format("%.1f", (1-xp/xpForNextPoint)*100).."%)", .6,.8,1, 1,1,1)
		end
		GameTooltip:Show()
	end

	ExpRep:RegisterEvent("PLAYER_XP_UPDATE")
	ExpRep:RegisterEvent("PLAYER_LEVEL_UP")
	ExpRep:RegisterEvent("UPDATE_EXHAUSTION")
	ExpRep:RegisterEvent("PLAYER_ENTERING_WORLD")
	ExpRep:RegisterEvent("UPDATE_FACTION")
	ExpRep:RegisterEvent("ARTIFACT_XP_UPDATE")
	ExpRep:RegisterEvent("UNIT_INVENTORY_CHANGED")
	ExpRep:RegisterEvent("ENABLE_XP_GAIN")
	ExpRep:RegisterEvent("DISABLE_XP_GAIN")
	ExpRep:SetScript("OnEvent", UpdateData)
	ExpRep:SetScript("OnEnter", SetTooltip)
	ExpRep:SetScript("OnLeave", GameTooltip_Hide)
	ExpRep:SetScript("OnMouseUp", function(_, btn)
		if not HasArtifactEquipped() or btn ~= "LeftButton" then return end
		if not ArtifactFrame or not ArtifactFrame:IsShown() then
			SocketInventoryItem(16)
		else
			ToggleFrame(ArtifactFrame)
		end
	end)
end