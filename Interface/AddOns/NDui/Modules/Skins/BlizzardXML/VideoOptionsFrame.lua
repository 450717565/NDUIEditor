local _, ns = ...
local B, C, L, DB = unpack(ns)
local S = B:GetModule("Skins")

local function Reskin_AudioOptionsVoicePanel(self)
	if not self.styled then
		B.ReskinButton(self.PushToTalkKeybindButton)

		self.styled = true
	end
end

local function Reskin_PanelTitle(self)
	local title = _G[self:GetDebugName().."Title"]

	title:ClearAllPoints()
	title:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 5, 2)
end

local function Reskin_VideoOptionsFrame(self)
	if self.styled then return end

	B.ReskinFrame(self)

	local lists = {
		Display_,
		Graphics_,
		RaidGraphics_,
		AudioOptionsSoundPanelHardware,
		AudioOptionsSoundPanelPlayback,
		AudioOptionsSoundPanelVolume,
		VideoOptionsFrameCategoryFrame,
		VideoOptionsFramePanelContainer,
	}
	for _, list in pairs(lists) do
		B.StripTextures(list)
	end

	local lines = {
		Advanced_DisplayHeaderUnderline,
		Display_DisplayHeaderUnderline,
		AudioOptionsSoundPanelDisplayHeaderUnderline,
		AudioOptionsVoicePanelDisplayHeaderUnderline,
		InterfaceOptionsLanguagesPanelDisplayHeaderUnderline,
		NetworkOptionsPanelDisplayHeaderUnderline,
	}
	for _, line in pairs(lines) do
		line:Hide()
	end

	local buttons = {
		"VideoOptionsFrameOkay",
		"VideoOptionsFrameCancel",
		"VideoOptionsFrameDefaults",
		"VideoOptionsFrameApply",
		"GraphicsButton",
		"RaidButton",
	}
	for _, button in pairs(buttons) do
		B.ReskinButton(_G[button])
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

	Reskin_PanelTitle(AudioOptionsSoundPanelPlayback)
	Reskin_PanelTitle(AudioOptionsSoundPanelHardware)
	Reskin_PanelTitle(AudioOptionsSoundPanelVolume)

	VideoOptionsFrameOkay:ClearAllPoints()
	VideoOptionsFrameOkay:SetPoint("BOTTOMRIGHT", VideoOptionsFrameCancel, "BOTTOMLEFT", -1, 0)

	local panels = {
		"Advanced_",
		"Display_",
		"Graphics_",
		"RaidGraphics_",
		"AudioOptionsSoundPanel",
		"AudioOptionsVoicePanel",
		"InterfaceOptionsLanguagesPanel",
		"NetworkOptionsPanel",
	}
	S.ReskinOptions(panels)

	self.styled = true
end

tinsert(C.XMLThemes, function()
	VideoOptionsFrame:HookScript("OnShow", Reskin_VideoOptionsFrame)
	hooksecurefunc("AudioOptionsVoicePanel_InitializeCommunicationModeUI", Reskin_AudioOptionsVoicePanel)
end)