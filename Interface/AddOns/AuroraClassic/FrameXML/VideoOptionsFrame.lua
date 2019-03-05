local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
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

	local styled = false
	VideoOptionsFrame:HookScript("OnShow", function()
		if styled then return end

		F.ReskinFrame(VideoOptionsFrame)

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
			F.StripTextures(texture, true)
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

		local line = VideoOptionsFrameCategoryFrame:CreateTexture(nil, "ARTWORK")
		line:SetSize(C.mult, 512)
		line:SetPoint("RIGHT", 10, 0)
		line:SetColorTexture(1, 1, 1, .25)

		VideoOptionsFrameHeader:Hide()
		VideoOptionsFrameHeader:ClearAllPoints()
		VideoOptionsFrameHeader:SetPoint("TOP", VideoOptionsFrame, 0, 0)
		VideoOptionsFrameOkay:SetPoint("BOTTOMRIGHT", VideoOptionsFrameCancel, "BOTTOMLEFT", -1, 0)
		AudioOptionsSoundPanelPlaybackTitle:SetPoint("BOTTOMLEFT", AudioOptionsSoundPanelPlayback, "TOPLEFT", 5, 2)
		AudioOptionsSoundPanelHardwareTitle:SetPoint("BOTTOMLEFT", AudioOptionsSoundPanelHardware, "TOPLEFT", 5, 2)
		AudioOptionsSoundPanelVolumeTitle:SetPoint("BOTTOMLEFT", AudioOptionsSoundPanelVolume, "TOPLEFT", 5, 2)

		for i = 1, 6 do
			local button = _G["VideoOptionsFrameCategoryFrameButton"..i]
			button.highlight:SetTexture(C.media.bdTex)
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
			F.ReskinButton(button)
		end

		local dropdowns = {
			Advanced_AdapterDropDown,
			Advanced_BufferingDropDown,
			Advanced_GraphicsAPIDropDown,
			Advanced_LagDropDown,
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
			Graphics_LightingQualityDropDown,
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
			RaidGraphics_LightingQualityDropDown,
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
			F.ReskinDropDown(dropdown)
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
			F.ReskinSlider(slider)
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
			F.ReskinCheck(checkboxe)
		end

		local testInputDevie = AudioOptionsVoicePanelTestInputDevice
		F.ReskinButton(testInputDevie.ToggleTest)
		F.StripTextures(testInputDevie.VUMeter)
		F.ReskinStatusBar(testInputDevie.VUMeter.Status, true)

		styled = true
	end)

	hooksecurefunc("AudioOptionsVoicePanel_InitializeCommunicationModeUI", function(self)
		if not self.styled then
			F.ReskinButton(self.PushToTalkKeybindButton)
			self.styled = true
		end
	end)
end)