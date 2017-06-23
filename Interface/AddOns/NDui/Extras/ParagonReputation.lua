		-----------------------------------------------
		-- Paragon Reputation 1.15 by Sev (Drakkari) --
		-----------------------------------------------

		--[[	Special thanks to Ammako for
				helping me with the vars and
				the options.					]]--

local B, C, L, DB = unpack(select(2, ...))

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