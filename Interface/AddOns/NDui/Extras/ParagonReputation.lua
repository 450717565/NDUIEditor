		-----------------------------------------------
		-- Paragon Reputation 1.12 by Sev (Drakkari) --
		-----------------------------------------------

		--[[	Special thanks to Ammako for
				helping me with the vars and
				the options.					]]--

ParagonReputation = {} -- Localization
local B, C, L, DB = unpack(select(2, ...))

local faction = CreateFrame("FRAME") -- FactionName
local gains = CreateFrame("FRAME") -- ReputationMath

local id = {} -- FactionID
local rep = {} -- FactionRep
local gain = {} -- FactionRepGain

faction:RegisterEvent("PLAYER_LOGIN") -- RegisterLogin/Reload
gains:RegisterEvent("CHAT_MSG_COMBAT_FACTION_CHANGE") -- RegisterReputationMessage

-- Get Paragon Factions
faction:SetScript("OnEvent",function()
	local factionIndex = 1
	repeat
		local name, _, _, _, _, _, _, _, _, _, _, _, _, factionID = GetFactionInfo(factionIndex)
		if factionID and C_Reputation.IsFactionParagon(factionID) then
			local currentValue = C_Reputation.GetFactionParagonInfo(factionID)
			table.insert(faction,name)
			table.insert(id,factionID)
			table.insert(rep,currentValue)
			table.insert(gain,0)
		end
	factionIndex = factionIndex + 1
	until factionIndex > 200
end)

-- Calculate Reputation Gains
gains:SetScript("OnEvent",function(_,_,msg,...)
	for n = 1, #faction do
		local msgrep = gsub(FACTION_STANDING_INCREASED_GENERIC,"%%s",faction[n])
		if string.match(msgrep, msg) then
			local currentValue = C_Reputation.GetFactionParagonInfo(id[n])
			gain[n] = currentValue - rep[n]
			rep[n] = rep[n] + gain[n]
		end
	end
end)

-- Filter Reputation Messages
ChatFrame_AddMessageEventFilter("CHAT_MSG_COMBAT_FACTION_CHANGE",function(_,_,msg,...)
	for n = 1, #faction do
		local msgrep = gsub(FACTION_STANDING_INCREASED_GENERIC,"%%s",faction[n])
		if string.match(msgrep, msg) then
			msg=format(FACTION_STANDING_INCREASED,faction[n],gain[n])
		end
	end
	return false,msg,...
end)

-- Reputation Frame
hooksecurefunc("ReputationFrame_Update",function()
	ReputationFrame.paragonFramesPool:ReleaseAll()
	local numFactions = GetNumFactions()
	local factionOffset = FauxScrollFrame_GetOffset(ReputationListScrollFrame)
	for i=1, NUM_FACTIONS_DISPLAYED, 1 do
		local factionIndex = factionOffset + i
		local factionRow = _G["ReputationBar"..i]
		local factionBar = _G["ReputationBar"..i.."ReputationBar"]
		local factionStanding = _G["ReputationBar"..i.."ReputationBarFactionStanding"]
		if ( factionIndex <= numFactions ) then
			local _, _, _, _, _, _, _, _, _, _, _, _, _, factionID = GetFactionInfo(factionIndex)
			if factionID and C_Reputation.IsFactionParagon(factionID) then
				local currentValue, threshold, _, hasRewardPending = C_Reputation.GetFactionParagonInfo(factionID)
				local value = mod(currentValue, threshold)
				if hasRewardPending then
					local paragonFrame = ReputationFrame.paragonFramesPool:Acquire()
					paragonFrame.factionID = factionID
					paragonFrame:SetPoint("RIGHT", factionRow, 11, 0)
					paragonFrame.Glow:SetShown(true)
					paragonFrame.Check:SetShown(true)
					paragonFrame:Show()
					value = value + threshold
				end
				factionBar:SetMinMaxValues(0, threshold)
				factionBar:SetValue(value)
				factionBar:SetStatusBarColor(0, .5, .9)
				factionRow.rolloverText = HIGHLIGHT_FONT_COLOR_CODE..format(REPUTATION_PROGRESS_FORMAT, BreakUpLargeNumbers(value), BreakUpLargeNumbers(threshold))..FONT_COLOR_CODE_CLOSE
				factionStanding:SetText(L["Paragon"])
				factionRow.standingText = L["Paragon"]
			end
		else
			factionRow:Hide()
		end
	end
end)

-- Reputation Watchbar (Thanks Hoalz)
hooksecurefunc("MainMenuBar_UpdateExperienceBars",function()
	local name, standingID, _, _, _, factionID = GetWatchedFactionInfo()
	if standingID == MAX_REPUTATION_REACTION then
		ReputationWatchBar.StatusBar:SetAnimatedValues(1, 0, 1)
	end
	if factionID and ReputationWatchBar:IsShown() and C_Reputation.IsFactionParagon(factionID) then
		local currentValue, threshold, _, hasRewardPending = C_Reputation.GetFactionParagonInfo(factionID)
		local value = mod(currentValue, threshold)
		if hasRewardPending then
			value = value + threshold
		end
		local overlayText = name.." "..HIGHLIGHT_FONT_COLOR_CODE..format(REPUTATION_PROGRESS_FORMAT, value, threshold)..FONT_COLOR_CODE_CLOSE
		ReputationWatchBar.OverlayFrame.Text:SetText(overlayText)
		ReputationWatchBar.StatusBar:SetAnimatedValues(value, 0, threshold)
		ReputationWatchBar.StatusBar:SetStatusBarColor(r, g, b)
	end
end)

-- Reputation Watchbar (Paragon Tooltip Hide)
hooksecurefunc("ReputationParagonWatchBar_OnEnter",function(self)
	local _, _, _, _, _, factionID = GetWatchedFactionInfo()
	local _, _, _, hasRewardPending = C_Reputation.GetFactionParagonInfo(factionID)
	if not hasRewardPending then
		ReputationParagonTooltip:Hide()
	end
end)