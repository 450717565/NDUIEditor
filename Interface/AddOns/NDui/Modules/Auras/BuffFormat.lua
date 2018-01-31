local B, C, L, DB = unpack(select(2, ...))

-- Convert the Bufftimers into details
local function FormatAuraTime(s)
	local d, h, m, str = 0, 0, 0
	if s >= 86400 then
		d = s/86400
		s = s%86400
	end
	if s >= 3600 then
		h = s/3600
		s = s%3600
	end
	if s >= 60 then
		m = s/60
		s = s%60
	end
	if d > 0 then
		str = format("%d "..DB.MyColor..L["Days"], d)
	elseif h > 0 then
		str = format("%d "..DB.MyColor..L["Hours"], h)
	elseif m >= 10 then
		str = format("%d "..DB.MyColor..L["Minutes"], m)
	elseif m > 0 and m < 10 then
		str = format("%.2d:%.2d", m, s)
	else
		if s <= 5 then
			str = format("|cffff0000%.1f|r", s) -- red
		elseif s <= 10 then
			str = format("|cffffff00%.1f|r", s) -- yellow
		else
			str = format("%d "..DB.MyColor..L["Seconds"], s)
		end
	end
	return str
end

hooksecurefunc("AuraButton_UpdateDuration", function(auraButton, timeLeft)
	local duration = auraButton.duration
	if SHOW_BUFF_DURATIONS == "1" and timeLeft then
		duration:SetFormattedText(FormatAuraTime(timeLeft))
		duration:SetTextColor(1, 1, 1)
		duration:Show()
	else
		duration:Hide()
	end
end)