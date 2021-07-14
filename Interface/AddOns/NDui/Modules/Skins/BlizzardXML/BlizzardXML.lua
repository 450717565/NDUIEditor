local _, ns = ...
local B, C, L, DB = unpack(ns)

C.OnLoginThemes["ColorPickerFrame"] = function()
	B.CreateBG(ColorPickerFrame)

	B.ReskinSlider(OpacitySliderFrame, true)
	B.ReskinButton(ColorPickerOkayButton)
	B.ReskinButton(ColorPickerCancelButton)

	local Header = ColorPickerFrame.Header
	B.StripTextures(Header)
	Header:ClearAllPoints()
	Header:SetPoint("TOP", 0, 5)

	ColorPickerFrame.Border:Hide()
	ColorPickerOkayButton:ClearAllPoints()
	ColorPickerOkayButton:SetPoint("BOTTOMRIGHT", ColorPickerFrame, "BOTTOM", -1, 5)
	ColorPickerCancelButton:ClearAllPoints()
	ColorPickerCancelButton:SetPoint("BOTTOMLEFT", ColorPickerFrame, "BOTTOM", 1, 5)
end

local function Reskin_CloseDialog(frame)
	local dialog = B.GetObject(frame, "CloseDialog")
	dialog:HookScript("OnShow", function(self)
		self:SetScale(UIParent:GetScale())
	end)

	local bg = B.ReskinFrame(dialog)
	bg:SetFrameLevel(dialog:GetFrameLevel()+1)

	local confirmButton = B.GetObject(dialog, "ConfirmButton")
	B.ReskinButton(confirmButton)

	local resumeButton = B.GetObject(dialog, "ResumeButton")
	B.ReskinButton(resumeButton)
end

C.OnLoginThemes["CloseDialog"] = function()
	Reskin_CloseDialog(CinematicFrame)
	Reskin_CloseDialog(MovieFrame)
end

C.OnLoginThemes["GameMenuFrame"] = function()
	B.ReskinFrame(GameMenuFrame)

	local buttons = {
		GameMenuButtonAddons,
		GameMenuButtonContinue,
		GameMenuButtonHelp,
		GameMenuButtonKeybindings,
		GameMenuButtonLogout,
		GameMenuButtonMacros,
		GameMenuButtonOptions,
		GameMenuButtonQuit,
		GameMenuButtonStore,
		GameMenuButtonUIOptions,
		GameMenuButtonWhatsNew,
	}

	for _, button in pairs(buttons) do
		B.ReskinButton(button)
	end
end

C.OnLoginThemes["GhostFrame"] = function()
	local bg = B.ReskinFrame(GhostFrame)
	B.ReskinHLTex(GhostFrame, bg, true)

	B.ReskinIcon(GhostFrameContentsFrameIcon)
end

local function Reskin_TextColor(self, r, g, b)
	if r ~= 1 or g ~= 1 or b ~= 1 then
		B.ReskinText(self, 1, 1, 1)
	end
end

C.OnLoginThemes["ItemTextFrame"] = function()
	B.ReskinFrame(ItemTextFrame)
	B.ReskinScroll(ItemTextScrollFrameScrollBar)
	B.ReskinArrow(ItemTextPrevPageButton, "left")
	B.ReskinArrow(ItemTextNextPageButton, "right")

	hooksecurefunc(ItemTextPageText, "SetTextColor", Reskin_TextColor)
end

local function Reskin_LossOfControlFrame(self)
	if not self.styled then
		B.ReskinIcon(self.Icon)

		self.styled = true
	end
end

C.OnLoginThemes["LossOfControlFrame"] = function()
	hooksecurefunc("LossOfControlFrame_SetUpDisplay", Reskin_LossOfControlFrame)
end

C.OnLoginThemes["MawBuffsFrame"] = function()
	B.ReskinMawBuffs(MawBuffsBelowMinimapFrame)
	B.ReskinMawBuffs(ScenarioBlocksFrame.MawBuffsBlock)
end

C.OnLoginThemes["ModelPreviewFrame"] = function()
	B.StripTextures(ModelPreviewFrame)
	B.CreateBG(ModelPreviewFrame)

	B.ReskinClose(ModelPreviewFrameCloseButton)
	B.ReskinButton(ModelPreviewFrame.CloseButton)
	B.StripTextures(ModelPreviewFrame.Display)

	local ModelScene = ModelPreviewFrame.Display.ModelScene
	B.CreateBDFrame(ModelScene, 0, -C.mult)
	B.ReskinArrow(ModelScene.RotateLeftButton, "left")
	B.ReskinArrow(ModelScene.RotateRightButton, "right")
	B.ReskinArrow(ModelScene.CarouselLeftButton, "left")
	B.ReskinArrow(ModelScene.CarouselRightButton, "right")
end

C.OnLoginThemes["PetBattleQueueReadyFrame"] = function()
	B.ReskinFrame(PetBattleQueueReadyFrame)
	B.CreateBDFrame(PetBattleQueueReadyFrame.Art)
	B.ReskinButton(PetBattleQueueReadyFrame.AcceptButton)
	B.ReskinButton(PetBattleQueueReadyFrame.DeclineButton)
end

local function Reskin_PlayerReport(self)
	if not self.styled then
		B.ReskinFrame(self)
		B.ReskinInput(self.Comment)
		B.ReskinButton(self.ReportButton)
		B.ReskinButton(self.CancelButton)

		self.styled = true
	end
end

C.OnLoginThemes["PlayerReportFrame"] = function()
	PlayerReportFrame:HookScript("OnShow", Reskin_PlayerReport)
end

local function Update_SelectGroupButton(index)
	for i = 1, 3 do
		local button = GroupFinderFrame["groupButton"..i]
		button.bg:SetShown(i == index)
	end
end

C.OnLoginThemes["PVEFrame"] = function()
	B.ReskinFrame(PVEFrame)
	B.ReskinFrameTab(PVEFrame, 3)

	for i = 1, 3 do
		local button = GroupFinderFrame["groupButton"..i]
		B.StripTextures(button)
		B.ReskinButton(button)
		B.ReskinHLTex(button.bg, button.bgTex, true)

		local icon = button.icon
		B.UpdatePoint(icon, "LEFT", button, "LEFT")

		local icbg = B.ReskinIcon(icon)
		icbg:SetFrameLevel(button:GetFrameLevel())
	end

	GroupFinderFrame.groupButton1.icon:SetTexture("Interface\\Icons\\INV_Helmet_08")
	GroupFinderFrame.groupButton2.icon:SetTexture("Interface\\Icons\\INV_Helmet_06")
	GroupFinderFrame.groupButton3.icon:SetTexture("Interface\\Icons\\INV_Misc_GroupNeedMore")

	hooksecurefunc("GroupFinderFrame_SelectGroupButton", Update_SelectGroupButton)
end

local function Reskin_ReadyCheckFrame(self)
	if self.initiator and UnitIsUnit("player", self.initiator) then
		self:Hide()
	end
end

C.OnLoginThemes["ReadyCheckFrame"] = function()
	B.ReskinFrame(ReadyCheckFrame)
	B.ReskinButton(ReadyCheckFrameYesButton)
	B.ReskinButton(ReadyCheckFrameNoButton)
	B.StripTextures(ReadyCheckListenerFrame)

	ReadyCheckPortrait:SetAlpha(0)
	ReadyCheckFrame:HookScript("OnShow", Reskin_ReadyCheckFrame)
end

C.OnLoginThemes["RolePollPopup"] = function()
	B.ReskinFrame(RolePollPopup)
	B.ReskinButton(RolePollPopupAcceptButton)

	B.ReskinRole(RolePollPopupRoleButtonTank, "TANK")
	B.ReskinRole(RolePollPopupRoleButtonHealer, "HEALER")
	B.ReskinRole(RolePollPopupRoleButtonDPS, "DPS")
end

C.OnLoginThemes["ScriptErrorsFrame"] = function()
	ScriptErrorsFrame:SetScale(UIParent:GetScale())

	B.StripTextures(ScriptErrorsFrame)
	B.CreateBG(ScriptErrorsFrame)
	B.ReskinClose(ScriptErrorsFrameClose)
	B.ReskinButton(ScriptErrorsFrame.Reload)
	B.ReskinButton(ScriptErrorsFrame.Close)
	B.ReskinArrow(ScriptErrorsFrame.PreviousError, "left")
	B.ReskinArrow(ScriptErrorsFrame.NextError, "right")
	B.ReskinScroll(ScriptErrorsFrameScrollBar)
end

C.OnLoginThemes["SplashFrame"] = function()
	B.ReskinButton(SplashFrame.BottomCloseButton)
	B.ReskinClose(SplashFrame.TopCloseButton, SplashFrame, -20, -20)
	B.ReskinText(SplashFrame.Label, 1, .8, 0)
end

C.OnLoginThemes["StackSplitFrame"] = function()
	B.ReskinFrame(StackSplitFrame)

	B.ReskinButton(StackSplitFrame.OkayButton)
	B.ReskinButton(StackSplitFrame.CancelButton)
	B.ReskinArrow(StackSplitFrame.LeftButton, "left")
	B.ReskinArrow(StackSplitFrame.RightButton, "right")
end

C.OnLoginThemes["TabardFrame"] = function()
	B.ReskinFrame(TabardFrame)
	B.StripTextures(TabardFrameCostFrame)
	B.ReskinButton(TabardFrameAcceptButton)
	B.ReskinButton(TabardFrameCancelButton)
	B.ReskinArrow(TabardCharacterModelRotateLeftButton, "left")
	B.ReskinArrow(TabardCharacterModelRotateRightButton, "right")

	B.StripTextures(TabardFrameMoneyBg)
	B.StripTextures(TabardFrameMoneyInset)

	TabardFrameCustomizationBorder:Hide()
	TabardCharacterModelRotateRightButton:ClearAllPoints()
	TabardCharacterModelRotateRightButton:SetPoint("TOPLEFT", TabardCharacterModelRotateLeftButton, "TOPRIGHT", 1, 0)

	for i = 1, 5 do
		B.StripTextures(_G["TabardFrameCustomization"..i])
		B.ReskinArrow(_G["TabardFrameCustomization"..i.."LeftButton"], "left")
		B.ReskinArrow(_G["TabardFrameCustomization"..i.."RightButton"], "right")
	end
end

C.OnLoginThemes["TaxiFrame"] = function()
	local bg = B.ReskinFrame(TaxiFrame, "none")
	bg:SetOutside(TaxiRouteMap)

	local TitleText = TaxiFrame.TitleText
	TitleText:ClearAllPoints()
	TitleText:SetPoint("TOP", bg, 0, -6)
end

C.OnLoginThemes["TutorialFrame"] = function()
	B.ReskinFrame(TutorialFrame)

	B.ReskinButton(TutorialFrameOkayButton)
	B.ReskinArrow(TutorialFramePrevButton, "left")
	B.ReskinArrow(TutorialFrameNextButton, "right")

	TutorialFrameBackground:SetAlpha(0)
	TutorialFrame:DisableDrawLayer("BORDER")

	TutorialFrameOkayButton:ClearAllPoints()
	TutorialFrameOkayButton:SetPoint("BOTTOMLEFT", TutorialFrameNextButton, "BOTTOMRIGHT", 10, 0)
end

C.OnLoginThemes["WorldMapFrame"] = function()
	B.ReskinNavBar(WorldMapFrame.NavBar)

	local overlayFrames = WorldMapFrame.overlayFrames
	B.ReskinDropDown(overlayFrames[1])
	for _, frame in pairs(overlayFrames) do
		frame:DisableDrawLayer("BACKGROUND")
		frame:DisableDrawLayer("OVERLAY")
	end

	local SidePanelToggle = WorldMapFrame.SidePanelToggle
	B.ReskinArrow(SidePanelToggle.OpenButton, "right")
	B.ReskinArrow(SidePanelToggle.CloseButton, "left")

	local BorderFrame = WorldMapFrame.BorderFrame
	B.ReskinMinMax(BorderFrame.MaximizeMinimizeFrame)
	B.ReskinTutorialButton(BorderFrame.Tutorial, BorderFrame)

	local bg = B.ReskinFrame(BorderFrame)
	bg:SetParent(WorldMapFrame)
	bg:ClearAllPoints()
	bg:SetPoint("BOTTOMLEFT", WorldMapFrame.ScrollContainer, -C.mult, -C.mult)
	bg:SetPoint("TOPRIGHT", BorderFrame, C.mult, C.mult)
end