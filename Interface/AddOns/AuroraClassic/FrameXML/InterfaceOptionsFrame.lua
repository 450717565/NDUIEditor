local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	local restyled = false

	InterfaceOptionsFrame:HookScript("OnShow", function()
		if restyled then return end

		F.StripTextures(InterfaceOptionsFrameAddOns, true)
		F.StripTextures(InterfaceOptionsFrameCategories, true)
		F.StripTextures(InterfaceOptionsFramePanelContainer, true)
		F.StripTextures(InterfaceOptionsFrameTab1, true)
		F.StripTextures(InterfaceOptionsFrameTab2, true)
		F.ReskinFrame(InterfaceOptionsFrame)

		InterfaceOptionsFrameHeader:Hide()
		InterfaceOptionsFrameOkay:SetPoint("RIGHT", InterfaceOptionsFrameCancel, "LEFT", -1, 0)

		InterfaceOptionsFrameHeader:ClearAllPoints()
		InterfaceOptionsFrameHeader:SetPoint("TOP")

		local line = InterfaceOptionsFrame:CreateTexture(nil, "ARTWORK")
		line:SetSize(C.mult, 546)
		line:SetPoint("LEFT", 205, 10)
		line:SetColorTexture(1, 1, 1, .25)

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
		for _, button in next, buttons do
			F.ReskinButton(button)
		end

		local checkboxes = {
			InterfaceOptionsAccessibilityPanelCinematicSubtitles,
			InterfaceOptionsAccessibilityPanelColorblindMode,
			InterfaceOptionsAccessibilityPanelMovePad,
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
		for _, checkbox in next, checkboxes do
			F.ReskinCheck(checkbox)
		end

		local dropdowns = {
			CompactUnitFrameProfilesGeneralOptionsFrameHealthTextDropdown,
			CompactUnitFrameProfilesGeneralOptionsFrameSortByDropdown,
			CompactUnitFrameProfilesProfileSelector,
			InterfaceOptionsAccessibilityPanelColorFilterDropDown,
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
		for _, dropdown in next, dropdowns do
			F.ReskinDropDown(dropdown)
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
		for _, slider in next, sliders do
			F.ReskinSlider(slider)
		end

		if IsAddOnLoaded("Blizzard_CompactRaidFrames") then
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

			for _, box in next, boxes do
				F.ReskinCheck(box)
			end
		end

		restyled = true
	end)

	hooksecurefunc("InterfaceOptions_AddCategory", function()
		local num = #INTERFACEOPTIONS_ADDONCATEGORIES
		for i = 1, num do
			local bu = _G["InterfaceOptionsFrameAddOnsButton"..i.."Toggle"]
			if bu and not bu.reskinned then
				F.ReskinExpandOrCollapse(bu)
				bu:SetPushedTexture("")
				bu.SetPushedTexture = F.dummy
				bu.reskinned = true
			end
		end
	end)
end)