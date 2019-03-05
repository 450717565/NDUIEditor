local F, C = unpack(select(2, ...))

C.themes["Blizzard_TimeManager"] = function()
	-- TimeManagerFrame
	F.ReskinFrame(TimeManagerFrame)
	F.ReskinInput(TimeManagerAlarmMessageEditBox)

	TimeManagerAlarmHourDropDown:SetWidth(80)
	TimeManagerAlarmMinuteDropDown:SetWidth(80)
	TimeManagerAlarmAMPMDropDown:SetWidth(90)
	TimeManagerFrameTicker:ClearAllPoints()
	TimeManagerFrameTicker:SetPoint("TOPLEFT", 10, -10)

	local check = TimeManagerStopwatchCheck
	local icbg = F.ReskinIcon(check:GetNormalTexture())
	F.ReskinTexed(check, icbg)
	F.ReskinTexture(check, icbg, false)

	local dropdowns = {TimeManagerAlarmHourDropDown, TimeManagerAlarmMinuteDropDown, TimeManagerAlarmAMPMDropDown}
	for _, dropdown in pairs(dropdowns) do
		F.ReskinDropDown(dropdown)
	end

	local checks = {TimeManagerAlarmEnabledButton, TimeManagerMilitaryTimeCheck, TimeManagerLocalTimeCheck}
	for _, check in pairs(checks) do
		F.ReskinCheck(check)
	end

	-- StopwatchFrame
	F.ReskinFrame(StopwatchFrame)
	F.StripTextures(StopwatchTabFrame)
	F.ReskinClose(StopwatchCloseButton, "TOPRIGHT", StopwatchFrame, "TOPRIGHT", -2, -2)

	local reset = StopwatchResetButton
	reset:GetNormalTexture():SetTexCoord(.25, .75, .27, .75)
	reset:SetSize(18, 18)
	reset:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)
	reset:SetPoint("BOTTOMRIGHT", -3, 3)
	F.CreateBDFrame(reset, 0)

	local play = StopwatchPlayPauseButton
	play:GetNormalTexture():SetTexCoord(.25, .75, .27, .75)
	play:SetSize(18, 18)
	play:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)
	play:SetPoint("RIGHT", reset, "LEFT", -3, 0)
	F.CreateBDFrame(play, 0)
end