local _, ns = ...
local B, C, L, DB = unpack(ns)

C.LUAThemes["Blizzard_TimeManager"] = function()
	-- TimeManagerFrame
	B.ReskinFrame(TimeManagerFrame)
	B.ReskinInput(TimeManagerAlarmMessageEditBox)

	TimeManagerFrameTicker:ClearAllPoints()
	TimeManagerFrameTicker:SetPoint("TOPLEFT", 10, -10)

	local check = TimeManagerStopwatchCheck
	local icbg = B.ReskinIcon(check:GetNormalTexture())
	B.ReskinCPTex(check, icbg)
	B.ReskinHLTex(check, icbg)

	local dropdowns = {
		TimeManagerAlarmHourDropDown,
		TimeManagerAlarmMinuteDropDown,
		TimeManagerAlarmAMPMDropDown,
	}
	for _, dropdown in pairs(dropdowns) do
		dropdown:SetWidth(80)
		B.ReskinDropDown(dropdown)
	end

	local checks = {
		TimeManagerAlarmEnabledButton,
		TimeManagerMilitaryTimeCheck,
		TimeManagerLocalTimeCheck,
	}
	for _, check in pairs(checks) do
		B.ReskinCheck(check)
	end

	-- StopwatchFrame
	B.ReskinFrame(StopwatchFrame)
	B.StripTextures(StopwatchTabFrame)
	B.ReskinClose(StopwatchCloseButton, StopwatchFrame, -2, -2)

	local reset = StopwatchResetButton
	local resetBG = B.CreateBDFrame(reset)
	B.ReskinHLTex(reset, resetBG)
	reset:GetNormalTexture():SetInside(resetBG)
	reset:GetNormalTexture():SetTexCoord(.25, .75, .27, .75)
	reset:SetSize(18, 18)
	reset:ClearAllPoints()
	reset:SetPoint("BOTTOMRIGHT", -3, 3)

	local play = StopwatchPlayPauseButton
	local playBG = B.CreateBDFrame(play)
	B.ReskinHLTex(play, playBG)
	play:GetNormalTexture():SetInside(playBG)
	play:GetNormalTexture():SetTexCoord(.25, .75, .27, .75)
	play:SetSize(18, 18)
	play:ClearAllPoints()
	play:SetPoint("RIGHT", reset, "LEFT", -3, 0)
end