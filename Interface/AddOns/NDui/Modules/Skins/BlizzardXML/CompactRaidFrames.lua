local _, ns = ...
local B, C, L, DB = unpack(ns)

local function Update_Collapse(self)
	self.toggleButton:GetNormalTexture():SetTexCoord(.15, .39, 0, 1)
end

local function Update_Expand(self)
	self.toggleButton:GetNormalTexture():SetTexCoord(.86, 1, 0, 1)
end

C.OnLoginThemes["CompactRaidFrameManager"] = function()
	if not CompactRaidFrameManager then return end

	B.ReskinFrame(CompactRaidFrameManager)
	CompactRaidFrameManagerDisplayFrameHeaderBackground:Hide()
	CompactRaidFrameManagerDisplayFrameHeaderDelineator:Hide()

	B.ReskinDropDown(CompactRaidFrameManagerDisplayFrameProfileSelector)
	B.ReskinCheck(CompactRaidFrameManagerDisplayFrameEveryoneIsAssistButton)

	CompactRaidFrameManagerToggleButton:SetNormalTexture("Interface\\Buttons\\UI-ColorPicker-Buttons")
	CompactRaidFrameManagerToggleButton:GetNormalTexture():SetTexCoord(.15, .39, 0, 1)
	CompactRaidFrameManagerToggleButton:SetSize(15, 15)
	hooksecurefunc("CompactRaidFrameManager_Collapse", Update_Collapse)
	hooksecurefunc("CompactRaidFrameManager_Expand", Update_Expand)

	local buttons = {
		CompactRaidFrameManagerDisplayFrameConvertToRaid,
		CompactRaidFrameManagerDisplayFrameFilterOptionsFilterGroup1,
		CompactRaidFrameManagerDisplayFrameFilterOptionsFilterGroup2,
		CompactRaidFrameManagerDisplayFrameFilterOptionsFilterGroup3,
		CompactRaidFrameManagerDisplayFrameFilterOptionsFilterGroup4,
		CompactRaidFrameManagerDisplayFrameFilterOptionsFilterGroup5,
		CompactRaidFrameManagerDisplayFrameFilterOptionsFilterGroup6,
		CompactRaidFrameManagerDisplayFrameFilterOptionsFilterGroup7,
		CompactRaidFrameManagerDisplayFrameFilterOptionsFilterGroup8,
		CompactRaidFrameManagerDisplayFrameFilterOptionsFilterRoleDamager,
		CompactRaidFrameManagerDisplayFrameFilterOptionsFilterRoleHealer,
		CompactRaidFrameManagerDisplayFrameFilterOptionsFilterRoleTank,
		CompactRaidFrameManagerDisplayFrameHiddenModeToggle,
		CompactRaidFrameManagerDisplayFrameLeaderOptionsCountdown,
		CompactRaidFrameManagerDisplayFrameLeaderOptionsInitiateReadyCheck,
		CompactRaidFrameManagerDisplayFrameLeaderOptionsInitiateRolePoll,
		CompactRaidFrameManagerDisplayFrameLockedModeToggle,
	}
	for _, button in pairs(buttons) do
		B.StripTextures(button)
		B.ReskinButton(button)
	end

	if not C.db["Misc"]["RaidTool"] then
		local WorldMarkerButton = CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton
		B.StripTextures(WorldMarkerButton)
		B.ReskinButton(WorldMarkerButton)
		WorldMarkerButton:SetNormalTexture("Interface\\RaidFrame\\Raid-WorldPing")
	end
end