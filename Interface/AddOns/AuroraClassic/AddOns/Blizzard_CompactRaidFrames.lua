local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	if not IsAddOnLoaded("Blizzard_CUFProfiles") then return end
	if not IsAddOnLoaded("Blizzard_CompactRaidFrames") then return end
	if not CompactRaidFrameManagerToggleButton then return end

	CompactRaidFrameManagerToggleButton:SetNormalTexture("Interface\\Buttons\\UI-ColorPicker-Buttons")
	CompactRaidFrameManagerToggleButton:GetNormalTexture():SetTexCoord(.15, .39, 0, 1)
	CompactRaidFrameManagerToggleButton:SetSize(15, 15)
	hooksecurefunc("CompactRaidFrameManager_Collapse", function()
		CompactRaidFrameManagerToggleButton:GetNormalTexture():SetTexCoord(.15, .39, 0, 1)
	end)
	hooksecurefunc("CompactRaidFrameManager_Expand", function()
		CompactRaidFrameManagerToggleButton:GetNormalTexture():SetTexCoord(.86, 1, 0, 1)
	end)

	local buttons = {
		CompactRaidFrameManagerDisplayFrameFilterOptionsFilterRoleTank,
		CompactRaidFrameManagerDisplayFrameFilterOptionsFilterRoleHealer,
		CompactRaidFrameManagerDisplayFrameFilterOptionsFilterRoleDamager,
		CompactRaidFrameManagerDisplayFrameFilterOptionsFilterGroup1,
		CompactRaidFrameManagerDisplayFrameFilterOptionsFilterGroup2,
		CompactRaidFrameManagerDisplayFrameFilterOptionsFilterGroup3,
		CompactRaidFrameManagerDisplayFrameFilterOptionsFilterGroup4,
		CompactRaidFrameManagerDisplayFrameFilterOptionsFilterGroup5,
		CompactRaidFrameManagerDisplayFrameFilterOptionsFilterGroup6,
		CompactRaidFrameManagerDisplayFrameFilterOptionsFilterGroup7,
		CompactRaidFrameManagerDisplayFrameFilterOptionsFilterGroup8,
		CompactRaidFrameManagerDisplayFrameLeaderOptionsInitiateRolePoll,
		CompactRaidFrameManagerDisplayFrameLeaderOptionsInitiateReadyCheck,
		--CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton,
		CompactRaidFrameManagerDisplayFrameLockedModeToggle,
		CompactRaidFrameManagerDisplayFrameHiddenModeToggle,
		CompactRaidFrameManagerDisplayFrameConvertToRaid
	}
	for _, button in pairs(buttons) do
		for i = 1, 9 do
			select(i, button:GetRegions()):Hide()
		end
		F.ReskinButton(button)
	end
	--CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton:SetNormalTexture("Interface\\RaidFrame\\Raid-WorldPing")

	F.ReskinFrame(CompactRaidFrameManager)
	CompactRaidFrameManagerDisplayFrameHeaderBackground:Hide()
	CompactRaidFrameManagerDisplayFrameHeaderDelineator:Hide()

	F.ReskinDropDown(CompactRaidFrameManagerDisplayFrameProfileSelector)
	F.ReskinCheck(CompactRaidFrameManagerDisplayFrameEveryoneIsAssistButton)
end)