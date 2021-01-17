local _, ns = ...
local B, C, L, DB = unpack(ns)

local function Reskin_InterfaceAddOnsList()
	local num = #INTERFACEOPTIONS_ADDONCATEGORIES
	for i = 1, num do
		local buttons = "InterfaceOptionsFrameAddOnsButton"..i
		local button = _G[buttons]

		if not button then return end

		button.highlight:SetTexture(DB.bgTex)
		button.highlight:SetAlpha(.25)

		local toggle = _G[buttons.."Toggle"]
		if toggle then
			if not toggle.styled then
				B.ReskinCollapse(toggle)

				toggle.styled = true
			end
		end

		toggle:SetPushedTexture("")
	end
end

local function Reskin_InterfaceOptionsFrame(self)
	if self.styled then return end

	B.ReskinFrame(self)

	local lists = {
		InterfaceOptionsFrameAddOns,
		InterfaceOptionsFrameCategories,
		InterfaceOptionsFramePanelContainer,
		InterfaceOptionsFrameTab1,
		InterfaceOptionsFrameTab2,
	}
	for _, list in pairs(lists) do
		B.StripTextures(list)
	end

	local buttons = {
		CompactUnitFrameProfilesDeleteButton,
		CompactUnitFrameProfilesGeneralOptionsFrameResetPositionButton,
		CompactUnitFrameProfilesSaveButton,
		InterfaceOptionsDisplayPanelResetTutorials,
		InterfaceOptionsFrameCancel,
		InterfaceOptionsFrameDefaults,
		InterfaceOptionsFrameOkay,
		InterfaceOptionsSocialPanelRedockChat,
		InterfaceOptionsSocialPanelTwitterLoginButton,
	}
	for _, button in pairs(buttons) do
		B.ReskinButton(button)
	end

	local checkboxes = {
		InterfaceOptionsAccessibilityPanelCinematicSubtitles,
		InterfaceOptionsAccessibilityPanelColorblindMode,
		InterfaceOptionsAccessibilityPanelMovePad,
		InterfaceOptionsAccessibilityPanelOverrideFadeOut,
		InterfaceOptionsActionBarsPanelAlwaysShowActionBars,
		InterfaceOptionsActionBarsPanelBottomLeft,
		InterfaceOptionsActionBarsPanelBottomRight,
		InterfaceOptionsActionBarsPanelCountdownCooldowns,
		InterfaceOptionsActionBarsPanelLockActionBars,
		InterfaceOptionsActionBarsPanelRight,
		InterfaceOptionsActionBarsPanelRightTwo,
		InterfaceOptionsActionBarsPanelStackRightBars,
		InterfaceOptionsCameraPanelWaterCollision,
		InterfaceOptionsCombatPanelAutoSelfCast,
		InterfaceOptionsCombatPanelEnableFloatingCombatText,
		InterfaceOptionsCombatPanelFlashLowHealthWarning,
		InterfaceOptionsCombatPanelLossOfControl,
		InterfaceOptionsCombatPanelTargetOfTarget,
		InterfaceOptionsControlsPanelAutoClearAFK,
		InterfaceOptionsControlsPanelAutoDismount,
		InterfaceOptionsControlsPanelAutoLootCorpse,
		InterfaceOptionsControlsPanelInteractOnLeftClick,
		InterfaceOptionsControlsPanelLootAtMouse,
		InterfaceOptionsControlsPanelStickyTargeting,
		InterfaceOptionsDisplayPanelAJAlerts,
		InterfaceOptionsDisplayPanelRotateMinimap,
		InterfaceOptionsDisplayPanelShowInGameNavigation,
		InterfaceOptionsDisplayPanelShowTutorials,
		InterfaceOptionsMousePanelClickToMove,
		InterfaceOptionsMousePanelEnableMouseSpeed,
		InterfaceOptionsMousePanelInvertMouse,
		InterfaceOptionsMousePanelLockCursorToScreen,
		InterfaceOptionsNamesPanelEnemyMinions,
		InterfaceOptionsNamesPanelEnemyPlayerNames,
		InterfaceOptionsNamesPanelFriendlyMinions,
		InterfaceOptionsNamesPanelFriendlyPlayerNames,
		InterfaceOptionsNamesPanelMyName,
		InterfaceOptionsNamesPanelNonCombatCreature,
		InterfaceOptionsNamesPanelUnitNameplatesAggroFlash,
		InterfaceOptionsNamesPanelUnitNameplatesEnemies,
		InterfaceOptionsNamesPanelUnitNameplatesEnemyMinions,
		InterfaceOptionsNamesPanelUnitNameplatesEnemyMinus,
		InterfaceOptionsNamesPanelUnitNameplatesFriendlyMinions,
		InterfaceOptionsNamesPanelUnitNameplatesFriends,
		InterfaceOptionsNamesPanelUnitNameplatesMakeLarger,
		InterfaceOptionsNamesPanelUnitNameplatesPersonalResource,
		InterfaceOptionsNamesPanelUnitNameplatesPersonalResourceOnEnemy,
		InterfaceOptionsNamesPanelUnitNameplatesShowAll,
		InterfaceOptionsSocialPanelAutoAcceptQuickJoinRequests,
		InterfaceOptionsSocialPanelBlockChatChannelInvites,
		InterfaceOptionsSocialPanelBlockGuildInvites,
		InterfaceOptionsSocialPanelBlockTrades,
		InterfaceOptionsSocialPanelBroadcasts,
		InterfaceOptionsSocialPanelEnableTwitter,
		InterfaceOptionsSocialPanelFriendRequests,
		InterfaceOptionsSocialPanelGuildMemberAlert,
		InterfaceOptionsSocialPanelOfflineFriends,
		InterfaceOptionsSocialPanelOnlineFriends,
		InterfaceOptionsSocialPanelProfanityFilter,
		InterfaceOptionsSocialPanelShowAccountAchievments,
		InterfaceOptionsSocialPanelShowToastWindow,
		InterfaceOptionsSocialPanelSpamFilter,
	}
	for _, checkbox in pairs(checkboxes) do
		B.ReskinCheck(checkbox)
	end

	local dropdowns = {
		CompactUnitFrameProfilesGeneralOptionsFrameHealthTextDropdown,
		CompactUnitFrameProfilesGeneralOptionsFrameSortByDropdown,
		CompactUnitFrameProfilesProfileSelector,
		InterfaceOptionsAccessibilityPanelColorFilterDropDown,
		InterfaceOptionsAccessibilityPanelMotionSicknessDropdown,
		InterfaceOptionsAccessibilityPanelShakeIntensityDropdown,
		InterfaceOptionsActionBarsPanelPickupActionKeyDropDown,
		InterfaceOptionsCameraPanelStyleDropDown,
		InterfaceOptionsCombatPanelFocusCastKeyDropDown,
		InterfaceOptionsCombatPanelSelfCastKeyDropDown,
		InterfaceOptionsControlsPanelAutoLootKeyDropDown,
		InterfaceOptionsDisplayPanelChatBubblesDropDown,
		InterfaceOptionsDisplayPanelDisplayDropDown,
		InterfaceOptionsDisplayPanelOutlineDropDown,
		InterfaceOptionsDisplayPanelSelfHighlightDropDown,
		InterfaceOptionsMousePanelClickMoveStyleDropDown,
		InterfaceOptionsNamesPanelNPCNamesDropDown,
		InterfaceOptionsNamesPanelUnitNameplatesMotionDropDown,
		InterfaceOptionsSocialPanelChatStyle,
		InterfaceOptionsSocialPanelTimestamps,
		InterfaceOptionsSocialPanelWhisperMode,
	}
	for _, dropdown in pairs(dropdowns) do
		B.ReskinDropDown(dropdown)
	end

	local sliders = {
		CompactUnitFrameProfilesGeneralOptionsFrameHeightSlider,
		CompactUnitFrameProfilesGeneralOptionsFrameWidthSlider,
		InterfaceOptionsAccessibilityPanelColorblindStrengthSlider,
		InterfaceOptionsCameraPanelFollowSpeedSlider,
		InterfaceOptionsCombatPanelSpellAlertOpacitySlider,
		InterfaceOptionsMousePanelMouseLookSpeedSlider,
		InterfaceOptionsMousePanelMouseSensitivitySlider,
	}
	for _, slider in pairs(sliders) do
		B.ReskinSlider(slider)
	end

	for i = 1, 10 do
		local button = _G["InterfaceOptionsFrameCategoriesButton"..i]
		button.highlight:SetTexture(DB.bgTex)
		button.highlight:SetAlpha(.25)
	end

	local aLine = B.CreateLine(InterfaceOptionsFrameAddOns)
	aLine:SetPoint("RIGHT", 10, 0)

	local cLine = B.CreateLine(InterfaceOptionsFrameCategories)
	cLine:SetPoint("RIGHT", 10, 0)

	local examples = InterfaceOptionsAccessibilityPanel.ColorblindFilterExamples
	for i = 1, 6 do
		local icon = examples["ExampleIcon"..i]
		B.ReskinIcon(icon)

		local border = examples["ExampleIcon"..i.."Border"]
		border:Hide()
	end

	InterfaceOptionsAccessibilityPanel.ColorblindFiltersSeparator:Hide()
	InterfaceOptionsFrameOkay:ClearAllPoints()
	InterfaceOptionsFrameOkay:SetPoint("RIGHT", InterfaceOptionsFrameCancel, "LEFT", -1, 0)

	if IsAddOnLoaded("Blizzard_CUFProfiles") then
		CompactUnitFrameProfilesGeneralOptionsFrameAutoActivateBG:Hide()

		local boxes = {
			CompactUnitFrameProfilesGeneralOptionsFrameAutoActivate10Players,
			CompactUnitFrameProfilesGeneralOptionsFrameAutoActivate15Players,
			CompactUnitFrameProfilesGeneralOptionsFrameAutoActivate25Players,
			CompactUnitFrameProfilesGeneralOptionsFrameAutoActivate2Players,
			CompactUnitFrameProfilesGeneralOptionsFrameAutoActivate3Players,
			CompactUnitFrameProfilesGeneralOptionsFrameAutoActivate40Players,
			CompactUnitFrameProfilesGeneralOptionsFrameAutoActivate5Players,
			CompactUnitFrameProfilesGeneralOptionsFrameAutoActivatePvE,
			CompactUnitFrameProfilesGeneralOptionsFrameAutoActivatePvP,
			CompactUnitFrameProfilesGeneralOptionsFrameAutoActivateSpec1,
			CompactUnitFrameProfilesGeneralOptionsFrameAutoActivateSpec2,
			CompactUnitFrameProfilesGeneralOptionsFrameAutoActivateSpec3,
			CompactUnitFrameProfilesGeneralOptionsFrameAutoActivateSpec4,
			CompactUnitFrameProfilesGeneralOptionsFrameDisplayAggroHighlight,
			CompactUnitFrameProfilesGeneralOptionsFrameDisplayBorder,
			CompactUnitFrameProfilesGeneralOptionsFrameDisplayIncomingHeals,
			CompactUnitFrameProfilesGeneralOptionsFrameDisplayMainTankAndAssist,
			CompactUnitFrameProfilesGeneralOptionsFrameDisplayOnlyDispellableDebuffs,
			CompactUnitFrameProfilesGeneralOptionsFrameDisplayPets,
			CompactUnitFrameProfilesGeneralOptionsFrameDisplayPowerBar,
			CompactUnitFrameProfilesGeneralOptionsFrameHorizontalGroups,
			CompactUnitFrameProfilesGeneralOptionsFrameKeepGroupsTogether,
			CompactUnitFrameProfilesGeneralOptionsFrameShowDebuffs,
			CompactUnitFrameProfilesGeneralOptionsFrameUseClassColors,
			CompactUnitFrameProfilesRaidStylePartyFrames,
		}
		for _, box in pairs(boxes) do
			B.ReskinCheck(box)
		end
	end

	self.styled = true
end

tinsert(C.XMLThemes, function()
	InterfaceOptionsFrame:HookScript("OnShow", Reskin_InterfaceOptionsFrame)
	hooksecurefunc("InterfaceAddOnsList_Update", Reskin_InterfaceAddOnsList)
end)