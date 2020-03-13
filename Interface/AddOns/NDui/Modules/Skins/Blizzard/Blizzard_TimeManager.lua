local B, C, L, DB = unpack(select(2, ...))

C.themes["Blizzard_TimeManager"] = function()
	-- TimeManagerFrame
	B.ReskinFrame(TimeManagerFrame)
	B.ReskinInput(TimeManagerAlarmMessageEditBox)

	TimeManagerAlarmHourDropDown:SetWidth(80)
	TimeManagerAlarmMinuteDropDown:SetWidth(80)
	TimeManagerAlarmAMPMDropDown:SetWidth(90)
	TimeManagerFrameTicker:ClearAllPoints()
	TimeManagerFrameTicker:SetPoint("TOPLEFT", 10, -10)

	local check = TimeManagerStopwatchCheck
	local icbg = B.ReskinIcon(check:GetNormalTexture())
	B.ReskinTexed(check, icbg)
	B.ReskinTexture(check, icbg)

	local dropdowns = {TimeManagerAlarmHourDropDown, TimeManagerAlarmMinuteDropDown, TimeManagerAlarmAMPMDropDown}
	for _, dropdown in pairs(dropdowns) do
		B.ReskinDropDown(dropdown)
	end

	local checks = {TimeManagerAlarmEnabledButton, TimeManagerMilitaryTimeCheck, TimeManagerLocalTimeCheck}
	for _, check in pairs(checks) do
		B.ReskinCheck(check)
	end

	-- StopwatchFrame
	B.ReskinFrame(StopwatchFrame)
	B.StripTextures(StopwatchTabFrame)
	B.ReskinClose(StopwatchCloseButton, "TOPRIGHT", StopwatchFrame, "TOPRIGHT", -2, -2)

	local reset = StopwatchResetButton
	reset:GetNormalTexture():SetTexCoord(.25, .75, .27, .75)
	reset:SetSize(18, 18)
	reset:SetPoint("BOTTOMRIGHT", -3, 3)
	B.ReskinTexture(reset)
	B.CreateBDFrame(reset, 0)

	local play = StopwatchPlayPauseButton
	play:GetNormalTexture():SetTexCoord(.25, .75, .27, .75)
	play:SetSize(18, 18)
	play:SetPoint("RIGHT", reset, "LEFT", -3, 0)
	B.ReskinTexture(play)
	B.CreateBDFrame(play, 0)
end