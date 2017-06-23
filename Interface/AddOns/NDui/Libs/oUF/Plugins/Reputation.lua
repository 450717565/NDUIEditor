local B, C, L, DB = unpack(select(2, ...))
local oUF = NDui.oUF or oUF

if not oUF then return end

local function tooltip(self)
	GameTooltip:SetOwner(self, "ANCHOR_TOP", 0, 5)
	GameTooltip:ClearLines()
	local name, standing, minvalue, maxvalue, value, factionID = GetWatchedFactionInfo()
	local friendID, _, _, _, _, _, friendTextLevel, _, nextFriendThreshold = GetFriendshipReputation(factionID)
	local currentRank, maxRank = GetFriendshipReputationRanks(friendID)
	local standingtext
	if friendID then
		if maxRank > 0 then
			name = name.."（"..currentRank.." / "..maxRank.."）"
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
	GameTooltip:AddLine(name, 0,.6,1)
	GameTooltip:AddDoubleLine(standingtext, value - minvalue.." / "..maxvalue - minvalue.."（"..string.format("%.1f", (value - minvalue)/(maxvalue - minvalue)*100).."%）", .6,.8,1, 1,1,1)
	if C_Reputation.IsFactionParagon(factionID) then
		local currentValue, threshold = C_Reputation.GetFactionParagonInfo(factionID)
		local value = mod(currentValue, threshold)
		GameTooltip:AddDoubleLine(L["ParagonRep"], value.."/"..threshold.." ("..string.format("%.1f", (value/threshold*100)).."%)", .6,.8,1, 1,1,1)
	end

	GameTooltip:Show()
end

local function update(self, event, unit)
	local bar = self.Reputation
	if (not GetWatchedFactionInfo()) then return bar:Hide() end

	local name, standing, minvalue, maxvalue, value, factionID = GetWatchedFactionInfo()
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
		minvalue, maxvalue, value = 0, threshold, currentValue
	else
		if standing == MAX_REPUTATION_REACTION then
			minvalue, maxvalue, value = 0, 1, 1
		end
	end
	bar:SetMinMaxValues(minvalue, maxvalue)
	bar:SetValue(value)
	bar:Show()

	if (bar.Text) then
		if (bar.OverrideText) then
			bar:OverrideText(minvalue, maxvalue, value, name, standing)
		else
			bar.Text:SetFormattedText("%d / %d - %s", value - minvalue, maxvalue - minvalue, name)
		end
	end

	if (bar.PostUpdate) then bar.PostUpdate(self, event, unit, bar, minvalue, maxvalue, value, name, standing) end
end

local function enable(self, unit)
	local bar = self.Reputation
	if (bar and unit == "player") then
		if (not bar:GetStatusBarTexture()) then
			bar:SetStatusBarTexture([=[Interface\TargetingFrame\UI-StatusBar]=])
		end

		self:RegisterEvent("UPDATE_FACTION", update)

		if (bar.Tooltip) then
			bar:EnableMouse(true)
			bar:HookScript("OnLeave", GameTooltip_Hide)
			bar:HookScript("OnEnter", tooltip)
		end

		return true
	end
end

local function disable(self)
	if (self.Reputation) then
		self:UnregisterEvent("UPDATE_FACTION", update)
	end
end

oUF:AddElement("Reputation", update, enable, disable)