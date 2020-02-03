local B, C, L, DB = unpack(select(2, ...))

tinsert(C.defaultThemes, function()
	local function CreateUnderLine(frame)
		local frameName = frame:GetName()
		local DisplayHeader = _G[frameName.."DisplayHeader"]
		local Underline = _G[frameName.."DisplayHeaderUnderline"]

		if Underline then Underline:Hide() end

		local line = frame:CreateTexture(nil, "ARTWORK")
		line:SetSize(580, C.mult)
		line:SetPoint("TOPLEFT", DisplayHeader, "BOTTOMLEFT", 0, -4)
		line:SetColorTexture(1, 1, 1, .25)
	end

	VideoOptionsFrame:HookScript("OnShow", function(self)
		if self.styled then return end

		B.ReskinFrame(VideoOptionsFrame)

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

		local headers = {
			Advanced_,
			AudioOptionsSoundPanel,
			AudioOptionsVoicePanel,
			Display_,
			InterfaceOptionsLanguagesPanel,
			NetworkOptionsPanel,
		}
		for _, header in pairs(headers) do
			CreateUnderLine(header)
		end

		local line = B.CreateLine(VideoOptionsFrameCategoryFrame)
		line:SetPoint("RIGHT", 10, 0)

		VideoOptionsFrameOkay:ClearAllPoints()
		VideoOptionsFrameOkay:SetPoint("BOTTOMRIGHT", VideoOptionsFrameCancel, "BOTTOMLEFT", -1, 0)
		AudioOptionsSoundPanelPlaybackTitle:ClearAllPoints()
		AudioOptionsSoundPanelPlaybackTitle:SetPoint("BOTTOMLEFT", AudioOptionsSoundPanelPlayback, "TOPLEFT", 5, 2)
		AudioOptionsSoundPanelHardwareTitle:ClearAllPoints()
		AudioOptionsSoundPanelHardwareTitle:SetPoint("BOTTOMLEFT", AudioOptionsSoundPanelHardware, "TOPLEFT", 5, 2)
		AudioOptionsSoundPanelVolumeTitle:ClearAllPoints()
		AudioOptionsSoundPanelVolumeTitle:SetPoint("BOTTOMLEFT", AudioOptionsSoundPanelVolume, "TOPLEFT", 5, 2)

		for i = 1, 6 do
			local button = _G["VideoOptionsFrameCategoryFrameButton"..i]
			button.highlight:SetTexture(DB.bdTex)
			button.highlight:SetAlpha(.25)
		end

		local buttons = {
			VideoOptionsFrameOkay,
			VideoOptionsFrameCancel,
			VideoOptionsFrameDefaults,
			VideoOptionsFrameApply,
			GraphicsButton,
			RaidButton,
		}
		for _, button in pairs(buttons) do
			B.ReskinButton(button)
		end

		local dropdowns = {
			Advanced_AdapterDropDown,
			Advanced_BufferingDropDown,
			Advanced_GraphicsAPIDropDown,
			Advanced_MultisampleAlphaTest,
			Advanced_MultisampleAntiAliasingDropDown,
			Advanced_PhysicsInteractionDropDown,
			Advanced_PostProcessAntiAliasingDropDown,
			Advanced_ResampleQualityDropDown,
			AudioOptionsSoundPanelHardwareDropDown,
			AudioOptionsSoundPanelSoundCacheSizeDropDown,
			AudioOptionsSoundPanelSoundChannelsDropDown,
			AudioOptionsVoicePanelChatModeDropdown,
			AudioOptionsVoicePanelMicDeviceDropdown,
			AudioOptionsVoicePanelOutputDeviceDropdown,
			Display_AntiAliasingDropDown,
			Display_DisplayModeDropDown,
			Display_PrimaryMonitorDropDown,
			Display_ResolutionDropDown,
			Display_VerticalSyncDropDown,
			Graphics_DepthEffectsDropDown,
			Graphics_FilteringDropDown,
			Graphics_LiquidDetailDropDown,
			Graphics_OutlineModeDropDown,
			Graphics_ParticleDensityDropDown,
			Graphics_ProjectedTexturesDropDown,
			Graphics_ShadowsDropDown,
			Graphics_SSAODropDown,
			Graphics_SunshaftsDropDown,
			Graphics_TextureResolutionDropDown,
			InterfaceOptionsLanguagesPanelAudioLocaleDropDown,
			InterfaceOptionsLanguagesPanelLocaleDropDown,
			RaidGraphics_DepthEffectsDropDown,
			RaidGraphics_FilteringDropDown,
			RaidGraphics_LiquidDetailDropDown,
			RaidGraphics_OutlineModeDropDown,
			RaidGraphics_ParticleDensityDropDown,
			RaidGraphics_ProjectedTexturesDropDown,
			RaidGraphics_ShadowsDropDown,
			RaidGraphics_SSAODropDown,
			RaidGraphics_SunshaftsDropDown,
			RaidGraphics_TextureResolutionDropDown,
		}
		for _, dropdown in pairs(dropdowns) do
			B.ReskinDropDown(dropdown)
		end

		local sliders = {
			Advanced_BrightnessSlider,
			Advanced_ContrastSlider,
			Advanced_GammaSlider,
			Advanced_MaxFPSBKSlider,
			Advanced_MaxFPSSlider,
			Advanced_UIScaleSlider,
			AudioOptionsSoundPanelAmbienceVolume,
			AudioOptionsSoundPanelDialogVolume,
			AudioOptionsSoundPanelMasterVolume,
			AudioOptionsSoundPanelMusicVolume,
			AudioOptionsSoundPanelSoundVolume,
			AudioOptionsVoicePanelVoiceChatDucking,
			AudioOptionsVoicePanelVoiceChatMicSensitivity,
			AudioOptionsVoicePanelVoiceChatMicVolume,
			AudioOptionsVoicePanelVoiceChatVolume,
			Display_RenderScaleSlider,
			Graphics_EnvironmentalDetailSlider,
			Graphics_GroundClutterSlider,
			Graphics_Quality,
			Graphics_ViewDistanceSlider,
			RaidGraphics_EnvironmentalDetailSlider,
			RaidGraphics_GroundClutterSlider,
			RaidGraphics_Quality,
			RaidGraphics_ViewDistanceSlider,
		}
		for _, slider in pairs(sliders) do
			B.ReskinSlider(slider)
		end

		local checkboxes = {
			Advanced_MaxFPSBKCheckBox,
			Advanced_MaxFPSCheckBox,
			Advanced_UseUIScale,
			AudioOptionsSoundPanelAmbientSounds,
			AudioOptionsSoundPanelDialogSounds,
			AudioOptionsSoundPanelEmoteSounds,
			AudioOptionsSoundPanelEnableSound,
			AudioOptionsSoundPanelErrorSpeech,
			AudioOptionsSoundPanelHRTF,
			AudioOptionsSoundPanelLoopMusic,
			AudioOptionsSoundPanelMusic,
			AudioOptionsSoundPanelPetBattleMusic,
			AudioOptionsSoundPanelPetSounds,
			AudioOptionsSoundPanelReverb,
			AudioOptionsSoundPanelSoundEffects,
			AudioOptionsSoundPanelSoundInBG,
			Display_RaidSettingsEnabledCheckBox,
			NetworkOptionsPanelAdvancedCombatLogging,
			NetworkOptionsPanelOptimizeSpeed,
			NetworkOptionsPanelUseIPv6,
		}
		for _, checkboxe in pairs(checkboxes) do
			B.ReskinCheck(checkboxe)
		end

		local testInputDevie = AudioOptionsVoicePanelTestInputDevice
		B.ReskinButton(testInputDevie.ToggleTest)
		B.StripTextures(testInputDevie.VUMeter)
		B.ReskinStatusBar(testInputDevie.VUMeter.Status, true)

		self.styled = true
	end)

	hooksecurefunc("AudioOptionsVoicePanel_InitializeCommunicationModeUI", function(self)
		if not self.styled then
			B.ReskinButton(self.PushToTalkKeybindButton)

			self.styled = true
		end
	end)
end)