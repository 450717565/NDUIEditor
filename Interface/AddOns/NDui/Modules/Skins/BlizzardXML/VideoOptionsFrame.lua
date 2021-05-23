local _, ns = ...
local B, C, L, DB = unpack(ns)
local S = B:GetModule("Skins")

local function Reskin_AudioOptionsVoicePanel(self)
	if not self.styled then
		B.ReskinButton(self.PushToTalkKeybindButton)

		self.styled = true
	end
end

local function Reskin_VideoOptionsFrame(self)
	if self.styled then return end

	B.ReskinFrame(self)

	local textures = {
		AudioOptionsSoundPanelHardware,
		AudioOptionsSoundPanelPlayback,
		AudioOptionsSoundPanelVolume,
		Display_,
		Graphics_,
		GraphicsButton,
		RaidButton,
		RaidGraphics_,
		VideoOptionsFrameCategoryFrame,
		VideoOptionsFramePanelContainer,
	}
	for _, texture in pairs(textures) do
		B.StripTextures(texture)
	end

	local buttons = {
		"VideoOptionsFrameOkay",
		"VideoOptionsFrameCancel",
		"VideoOptionsFrameDefaults",
		"VideoOptionsFrameApply",
		"GraphicsButton",
		"RaidButton",
	}
	S.ReskinOptions(buttons, "bt")

	local dropdowns = {
		"Advanced_AdapterDropDown",
		"Advanced_BufferingDropDown",
		"Advanced_FilteringDropDown",
		"Advanced_GraphicsAPIDropDown",
		"Advanced_MultisampleAlphaTest",
		"Advanced_MultisampleAntiAliasingDropDown",
		"Advanced_PhysicsInteractionDropDown",
		"Advanced_PostProcessAntiAliasingDropDown",
		"Advanced_ResampleQualityDropDown",
		"Advanced_RTShadowQualityDropDown",
		"Advanced_SSAOTypeDropDown",
		"AudioOptionsSoundPanelHardwareDropDown",
		"AudioOptionsSoundPanelSoundCacheSizeDropDown",
		"AudioOptionsSoundPanelSoundChannelsDropDown",
		"AudioOptionsVoicePanelChatModeDropdown",
		"AudioOptionsVoicePanelMicDeviceDropdown",
		"AudioOptionsVoicePanelOutputDeviceDropdown",
		"Display_AntiAliasingDropDown",
		"Display_DisplayModeDropDown",
		"Display_PrimaryMonitorDropDown",
		"Display_ResolutionDropDown",
		"Display_VerticalSyncDropDown",
		"Graphics_DepthEffectsDropDown",
		"Graphics_LiquidDetailDropDown",
		"Graphics_OutlineModeDropDown",
		"Graphics_ParticleDensityDropDown",
		"Graphics_ProjectedTexturesDropDown",
		"Graphics_ShadowsDropDown",
		"Graphics_SpellDensityDropDown",
		"Graphics_SSAODropDown",
		"Graphics_SunshaftsDropDown", -- isNewPatch, removed in 38627
		"Graphics_TextureResolutionDropDown",
		"InterfaceOptionsLanguagesPanelAudioLocaleDropDown",
		"InterfaceOptionsLanguagesPanelLocaleDropDown",
		"RaidGraphics_DepthEffectsDropDown",
		"RaidGraphics_LiquidDetailDropDown",
		"RaidGraphics_OutlineModeDropDown",
		"RaidGraphics_ParticleDensityDropDown",
		"RaidGraphics_ProjectedTexturesDropDown",
		"RaidGraphics_ShadowsDropDown",
		"RaidGraphics_SpellDensityDropDown",
		"RaidGraphics_SSAODropDown",
		"RaidGraphics_SunshaftsDropDown", -- isNewPatch, removed in 38627
		"RaidGraphics_TextureResolutionDropDown",
	}
	if DB.isNewPatch then
		tinsert(dropdowns, "Graphics_ComputeEffectsDropDown")
		tinsert(dropdowns, "RaidGraphics_ComputeEffectsDropDown")
		tremove(dropdowns, 31)
		tremove(dropdowns, 43)
	end
	S.ReskinOptions(dropdowns, "dd")

	local sliders = {
		"Advanced_BrightnessSlider",
		"Advanced_ContrastSlider",
		"Advanced_GammaSlider",
		"Advanced_MaxFPSBKSlider",
		"Advanced_MaxFPSSlider",
		"Advanced_TargetFPSSlider",
		"AudioOptionsSoundPanelAmbienceVolume",
		"AudioOptionsSoundPanelDialogVolume",
		"AudioOptionsSoundPanelMasterVolume",
		"AudioOptionsSoundPanelMusicVolume",
		"AudioOptionsSoundPanelSoundVolume",
		"AudioOptionsVoicePanelVoiceChatDucking",
		"AudioOptionsVoicePanelVoiceChatMicSensitivity",
		"AudioOptionsVoicePanelVoiceChatMicVolume",
		"AudioOptionsVoicePanelVoiceChatVolume",
		"Display_RenderScaleSlider",
		"Display_UIScaleSlider",
		"Graphics_EnvironmentalDetailSlider",
		"Graphics_GroundClutterSlider",
		"Graphics_Quality",
		"Graphics_ViewDistanceSlider",
		"RaidGraphics_EnvironmentalDetailSlider",
		"RaidGraphics_GroundClutterSlider",
		"RaidGraphics_Quality",
		"RaidGraphics_ViewDistanceSlider",
	}
	S.ReskinOptions(sliders, "sd")

	local checkboxes = {
		"Advanced_MaxFPSBKCheckBox",
		"Advanced_MaxFPSCheckBox",
		"Advanced_TargetFPSCheckBox",
		"AudioOptionsSoundPanelAmbientSounds",
		"AudioOptionsSoundPanelDialogSounds",
		"AudioOptionsSoundPanelEmoteSounds",
		"AudioOptionsSoundPanelEnableSound",
		"AudioOptionsSoundPanelErrorSpeech",
		"AudioOptionsSoundPanelHRTF",
		"AudioOptionsSoundPanelLoopMusic",
		"AudioOptionsSoundPanelMusic",
		"AudioOptionsSoundPanelPetBattleMusic",
		"AudioOptionsSoundPanelPetSounds",
		"AudioOptionsSoundPanelReverb",
		"AudioOptionsSoundPanelSoundEffects",
		"AudioOptionsSoundPanelSoundInBG",
		"Display_RaidSettingsEnabledCheckBox",
		"Display_UseUIScale",
		"NetworkOptionsPanelAdvancedCombatLogging",
		"NetworkOptionsPanelOptimizeSpeed",
		"NetworkOptionsPanelUseIPv6",
	}
	S.ReskinOptions(checkboxes, "cb")

	local lines = {
		Advanced_DisplayHeaderUnderline,
		AudioOptionsSoundPanelDisplayHeaderUnderline,
		AudioOptionsVoicePanelDisplayHeaderUnderline,
		Display_DisplayHeaderUnderline,
		InterfaceOptionsLanguagesPanelDisplayHeaderUnderline,
		NetworkOptionsPanelDisplayHeaderUnderline,
	}
	for _, line in pairs(lines) do
		line:Hide()
	end

	for i = 1, 6 do
		local button = _G["VideoOptionsFrameCategoryFrameButton"..i]
		button.highlight:SetTexture(DB.bgTex)
		button.highlight:SetAlpha(.25)
	end

	local categoryLine = B.CreateLines(VideoOptionsFrameCategoryFrame, "V")
	categoryLine:SetPoint("RIGHT", 10, 0)

	local containerLine = B.CreateLines(VideoOptionsFramePanelContainer, "H")
	containerLine:SetPoint("TOPLEFT", VideoOptionsFramePanelContainer, 10,-40)

	local testInputDevie = AudioOptionsVoicePanelTestInputDevice
	B.ReskinButton(testInputDevie.ToggleTest)
	B.StripTextures(testInputDevie.VUMeter)
	B.ReskinStatusBar(testInputDevie.VUMeter.Status, true)

	VideoOptionsFrameOkay:ClearAllPoints()
	VideoOptionsFrameOkay:SetPoint("BOTTOMRIGHT", VideoOptionsFrameCancel, "BOTTOMLEFT", -1, 0)
	AudioOptionsSoundPanelPlaybackTitle:ClearAllPoints()
	AudioOptionsSoundPanelPlaybackTitle:SetPoint("BOTTOMLEFT", AudioOptionsSoundPanelPlayback, "TOPLEFT", 5, 2)
	AudioOptionsSoundPanelHardwareTitle:ClearAllPoints()
	AudioOptionsSoundPanelHardwareTitle:SetPoint("BOTTOMLEFT", AudioOptionsSoundPanelHardware, "TOPLEFT", 5, 2)
	AudioOptionsSoundPanelVolumeTitle:ClearAllPoints()
	AudioOptionsSoundPanelVolumeTitle:SetPoint("BOTTOMLEFT", AudioOptionsSoundPanelVolume, "TOPLEFT", 5, 2)

	self.styled = true
end

tinsert(C.XMLThemes, function()
	VideoOptionsFrame:HookScript("OnShow", Reskin_VideoOptionsFrame)
	hooksecurefunc("AudioOptionsVoicePanel_InitializeCommunicationModeUI", Reskin_AudioOptionsVoicePanel)
end)