local _, ns = ...
local B, C, L, DB = unpack(ns)
local S = B:GetModule("Skins")

local function Reskin_InterfaceAddOnsList()
	local num = #INTERFACEOPTIONS_ADDONCATEGORIES
	for i = 1, num do
		local buttons = "InterfaceOptionsFrameAddOnsButton"..i
		local button = _G[buttons]

		if not button then return end

		button.highlight:SetTexture(DB.bgTex)
		button.highlight:SetAlpha(.25)

		local toggle = _G[buttons.."Toggle"]
		if toggle and not toggle.styled then
			B.ReskinCollapse(toggle)

			toggle.styled = true
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
		"InterfaceOptionsDisplayPanelResetTutorials",
		"InterfaceOptionsFrameCancel",
		"InterfaceOptionsFrameDefaults",
		"InterfaceOptionsFrameOkay",
		"InterfaceOptionsSocialPanelRedockChat",
		"InterfaceOptionsSocialPanelTwitterLoginButton",
	}
	if DB.isNewPatch then
		tinsert(buttons, "InterfaceOptionsAccessibilityPanelConfigureTextToSpeech")
		tinsert(buttons, "InterfaceOptionsAccessibilityPanelRemoteTextToSpeechVoicePlaySample")
	end
	S.ReskinOptions(buttons, "bt")

	local checkboxes = {
		"InterfaceOptionsAccessibilityPanelColorblindMode", -- isNewPatch, removed in 38709
		"InterfaceOptionsSocialPanelSpamFilter", -- isNewPatch, removed in 38627

		"InterfaceOptionsAccessibilityPanelCinematicSubtitles",
		"InterfaceOptionsAccessibilityPanelMovePad",
		"InterfaceOptionsAccessibilityPanelOverrideFadeOut",
		"InterfaceOptionsActionBarsPanelAlwaysShowActionBars",
		"InterfaceOptionsActionBarsPanelBottomLeft",
		"InterfaceOptionsActionBarsPanelBottomRight",
		"InterfaceOptionsActionBarsPanelCountdownCooldowns",
		"InterfaceOptionsActionBarsPanelLockActionBars",
		"InterfaceOptionsActionBarsPanelRight",
		"InterfaceOptionsActionBarsPanelRightTwo",
		"InterfaceOptionsActionBarsPanelStackRightBars",
		"InterfaceOptionsCameraPanelWaterCollision",
		"InterfaceOptionsCombatPanelAutoSelfCast",
		"InterfaceOptionsCombatPanelEnableFloatingCombatText",
		"InterfaceOptionsCombatPanelFlashLowHealthWarning",
		"InterfaceOptionsCombatPanelLossOfControl",
		"InterfaceOptionsCombatPanelTargetOfTarget",
		"InterfaceOptionsControlsPanelAutoClearAFK",
		"InterfaceOptionsControlsPanelAutoDismount",
		"InterfaceOptionsControlsPanelAutoLootCorpse",
		"InterfaceOptionsControlsPanelInteractOnLeftClick",
		"InterfaceOptionsControlsPanelLootAtMouse",
		"InterfaceOptionsControlsPanelStickyTargeting",
		"InterfaceOptionsDisplayPanelAJAlerts",
		"InterfaceOptionsDisplayPanelRotateMinimap",
		"InterfaceOptionsDisplayPanelShowInGameNavigation",
		"InterfaceOptionsDisplayPanelShowTutorials",
		"InterfaceOptionsMousePanelClickToMove",
		"InterfaceOptionsMousePanelEnableMouseSpeed",
		"InterfaceOptionsMousePanelInvertMouse",
		"InterfaceOptionsMousePanelLockCursorToScreen",
		"InterfaceOptionsNamesPanelEnemyMinions",
		"InterfaceOptionsNamesPanelEnemyPlayerNames",
		"InterfaceOptionsNamesPanelFriendlyMinions",
		"InterfaceOptionsNamesPanelFriendlyPlayerNames",
		"InterfaceOptionsNamesPanelMyName",
		"InterfaceOptionsNamesPanelNonCombatCreature",
		"InterfaceOptionsNamesPanelUnitNameplatesAggroFlash",
		"InterfaceOptionsNamesPanelUnitNameplatesEnemies",
		"InterfaceOptionsNamesPanelUnitNameplatesEnemyMinions",
		"InterfaceOptionsNamesPanelUnitNameplatesEnemyMinus",
		"InterfaceOptionsNamesPanelUnitNameplatesFriendlyMinions",
		"InterfaceOptionsNamesPanelUnitNameplatesFriends",
		"InterfaceOptionsNamesPanelUnitNameplatesMakeLarger",
		"InterfaceOptionsNamesPanelUnitNameplatesPersonalResource",
		"InterfaceOptionsNamesPanelUnitNameplatesPersonalResourceOnEnemy",
		"InterfaceOptionsNamesPanelUnitNameplatesShowAll",
		"InterfaceOptionsSocialPanelAutoAcceptQuickJoinRequests",
		"InterfaceOptionsSocialPanelBlockChatChannelInvites",
		"InterfaceOptionsSocialPanelBlockGuildInvites",
		"InterfaceOptionsSocialPanelBlockTrades",
		"InterfaceOptionsSocialPanelBroadcasts",
		"InterfaceOptionsSocialPanelEnableTwitter",
		"InterfaceOptionsSocialPanelFriendRequests",
		"InterfaceOptionsSocialPanelGuildMemberAlert",
		"InterfaceOptionsSocialPanelOfflineFriends",
		"InterfaceOptionsSocialPanelOnlineFriends",
		"InterfaceOptionsSocialPanelProfanityFilter",
		"InterfaceOptionsSocialPanelShowAccountAchievments",
		"InterfaceOptionsSocialPanelShowToastWindow",
	}
	if DB.isNewPatch then
		tremove(checkboxes, 1)
		tremove(checkboxes, 2)
		tinsert(checkboxes, "InterfaceOptionsAccessibilityPanelQuestTextContrast")
		tinsert(checkboxes, "InterfaceOptionsAccessibilityPanelRemoteTextToSpeech")
		tinsert(checkboxes, "InterfaceOptionsAccessibilityPanelSpeechToText")
		tinsert(checkboxes, "InterfaceOptionsAccessibilityPanelTextToSpeech")
		tinsert(checkboxes, "InterfaceOptionsColorblindPanelColorblindMode")
	end
	S.ReskinOptions(checkboxes, "cb")

	local dropdowns = {
		"InterfaceOptionsAccessibilityPanelColorFilterDropDown", -- isNewPatch, removed in 38709

		"InterfaceOptionsAccessibilityPanelMotionSicknessDropdown",
		"InterfaceOptionsAccessibilityPanelShakeIntensityDropdown",
		"InterfaceOptionsActionBarsPanelPickupActionKeyDropDown",
		"InterfaceOptionsCameraPanelStyleDropDown",
		"InterfaceOptionsCombatPanelFocusCastKeyDropDown",
		"InterfaceOptionsCombatPanelSelfCastKeyDropDown",
		"InterfaceOptionsControlsPanelAutoLootKeyDropDown",
		"InterfaceOptionsDisplayPanelChatBubblesDropDown",
		"InterfaceOptionsDisplayPanelDisplayDropDown",
		"InterfaceOptionsDisplayPanelOutlineDropDown",
		"InterfaceOptionsDisplayPanelSelfHighlightDropDown",
		"InterfaceOptionsMousePanelClickMoveStyleDropDown",
		"InterfaceOptionsNamesPanelNPCNamesDropDown",
		"InterfaceOptionsNamesPanelUnitNameplatesMotionDropDown",
		"InterfaceOptionsSocialPanelChatStyle",
		"InterfaceOptionsSocialPanelTimestamps",
		"InterfaceOptionsSocialPanelWhisperMode",
	}
	if DB.isNewPatch then
		tremove(dropdowns, 1)
		tinsert(dropdowns, "InterfaceOptionsColorblindPanelColorFilterDropDown")
		tinsert(dropdowns, "InterfaceOptionsAccessibilityPanelRemoteTextToSpeechVoiceDropdown")
	end
	S.ReskinOptions(dropdowns, "dd")

	local sliders = {
		"InterfaceOptionsAccessibilityPanelColorblindStrengthSlider", -- isNewPatch, removed in 38709

		"InterfaceOptionsCameraPanelFollowSpeedSlider",
		"InterfaceOptionsCombatPanelSpellAlertOpacitySlider",
		"InterfaceOptionsMousePanelMouseLookSpeedSlider",
		"InterfaceOptionsMousePanelMouseSensitivitySlider",
	}
	if DB.isNewPatch then
		tremove(sliders, 1)
		tinsert(sliders, "InterfaceOptionsColorblindPanelColorblindStrengthSlider")
	end
	S.ReskinOptions(sliders, "sd")

	for i = 1, 10 do
		local button = _G["InterfaceOptionsFrameCategoriesButton"..i]
		button.highlight:SetTexture(DB.bgTex)
		button.highlight:SetAlpha(.25)
	end

	local aLine = B.CreateLines(InterfaceOptionsFrameAddOns, "V")
	aLine:SetPoint("RIGHT", 10, 0)

	local cLine = B.CreateLines(InterfaceOptionsFrameCategories, "V")
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

		local checkboxes = {
			"CompactUnitFrameProfilesGeneralOptionsFrameAutoActivate10Players",
			"CompactUnitFrameProfilesGeneralOptionsFrameAutoActivate15Players",
			"CompactUnitFrameProfilesGeneralOptionsFrameAutoActivate25Players",
			"CompactUnitFrameProfilesGeneralOptionsFrameAutoActivate2Players",
			"CompactUnitFrameProfilesGeneralOptionsFrameAutoActivate3Players",
			"CompactUnitFrameProfilesGeneralOptionsFrameAutoActivate40Players",
			"CompactUnitFrameProfilesGeneralOptionsFrameAutoActivate5Players",
			"CompactUnitFrameProfilesGeneralOptionsFrameAutoActivatePvE",
			"CompactUnitFrameProfilesGeneralOptionsFrameAutoActivatePvP",
			"CompactUnitFrameProfilesGeneralOptionsFrameAutoActivateSpec1",
			"CompactUnitFrameProfilesGeneralOptionsFrameAutoActivateSpec2",
			"CompactUnitFrameProfilesGeneralOptionsFrameAutoActivateSpec3",
			"CompactUnitFrameProfilesGeneralOptionsFrameAutoActivateSpec4",
			"CompactUnitFrameProfilesGeneralOptionsFrameDisplayAggroHighlight",
			"CompactUnitFrameProfilesGeneralOptionsFrameDisplayBorder",
			"CompactUnitFrameProfilesGeneralOptionsFrameDisplayIncomingHeals",
			"CompactUnitFrameProfilesGeneralOptionsFrameDisplayMainTankAndAssist",
			"CompactUnitFrameProfilesGeneralOptionsFrameDisplayOnlyDispellableDebuffs",
			"CompactUnitFrameProfilesGeneralOptionsFrameDisplayPets",
			"CompactUnitFrameProfilesGeneralOptionsFrameDisplayPowerBar",
			"CompactUnitFrameProfilesGeneralOptionsFrameHorizontalGroups",
			"CompactUnitFrameProfilesGeneralOptionsFrameKeepGroupsTogether",
			"CompactUnitFrameProfilesGeneralOptionsFrameShowDebuffs",
			"CompactUnitFrameProfilesGeneralOptionsFrameUseClassColors",
			"CompactUnitFrameProfilesRaidStylePartyFrames",
		}
		S.ReskinOptions(checkboxes, "cb")

		local buttons = {
			"CompactUnitFrameProfilesDeleteButton",
			"CompactUnitFrameProfilesGeneralOptionsFrameResetPositionButton",
			"CompactUnitFrameProfilesSaveButton",
		}
		S.ReskinOptions(buttons, "bt")

		local dropdowns = {
			"CompactUnitFrameProfilesGeneralOptionsFrameHealthTextDropdown",
			"CompactUnitFrameProfilesGeneralOptionsFrameSortByDropdown",
			"CompactUnitFrameProfilesProfileSelector",
		}
		S.ReskinOptions(dropdowns, "dd")

		local sliders = {
			"CompactUnitFrameProfilesGeneralOptionsFrameHeightSlider",
			"CompactUnitFrameProfilesGeneralOptionsFrameWidthSlider",
		}
		S.ReskinOptions(sliders, "sd")
	end

	self.styled = true
end

tinsert(C.XMLThemes, function()
	InterfaceOptionsFrame:HookScript("OnShow", Reskin_InterfaceOptionsFrame)
	hooksecurefunc("InterfaceAddOnsList_Update", Reskin_InterfaceAddOnsList)
end)