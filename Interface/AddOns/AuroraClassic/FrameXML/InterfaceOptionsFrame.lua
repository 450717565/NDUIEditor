local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	local styled = false

	InterfaceOptionsFrame:HookScript("OnShow", function()
		if styled then return end

		F.ReskinFrame(InterfaceOptionsFrame)

		local textures = {
			InterfaceOptionsFrameAddOns,
			InterfaceOptionsFrameCategories,
			InterfaceOptionsFramePanelContainer,
			InterfaceOptionsFrameTab1,
			InterfaceOptionsFrameTab2,
		}
		for _, texture in pairs(textures) do
			F.StripTextures(texture, true)
		end

		local line = InterfaceOptionsFrame:CreateTexture(nil, "ARTWORK")
		line:SetSize(C.mult, 546)
		line:SetPoint("LEFT", 205, 10)
		line:SetColorTexture(1, 1, 1, .25)

		InterfaceOptionsFrameHeader:Hide()
		InterfaceOptionsFrameHeader:ClearAllPoints()
		InterfaceOptionsFrameHeader:SetPoint("TOP")
		InterfaceOptionsFrameOkay:SetPoint("RIGHT", InterfaceOptionsFrameCancel, "LEFT", -1, 0)

		for i = 1, 10 do
			local button = _G["InterfaceOptionsFrameCategoriesButton"..i]
			button.highlight:SetTexture(C.media.bdTex)
			button.highlight:SetAlpha(.25)
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
		for _, checkbox in pairs(checkboxes) do
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
		for _, dropdown in pairs(dropdowns) do
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
		for _, slider in pairs(sliders) do
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

			for _, box in pairs(boxes) do
				F.ReskinCheck(box)
			end
		end

		styled = true
	end)

	hooksecurefunc("InterfaceOptions_AddCategory", function()
		local num = #INTERFACEOPTIONS_ADDONCATEGORIES
		for i = 1, num do
			local button = _G["InterfaceOptionsFrameAddOnsButton"..i]
			local toggle = _G["InterfaceOptionsFrameAddOnsButton"..i.."Toggle"]
			if button and not button.reskinned then
				F.ReskinExpandOrCollapse(toggle)
				toggle:SetPushedTexture("")
				toggle.SetPushedTexture = F.Dummy

				button.highlight:SetTexture(C.media.bdTex)
				button.highlight:SetAlpha(.25)

				button.reskinned = true
			end
		end
	end)
end)