local _, ns = ...
local B, C, L, DB = unpack(ns)

local function Reskin_ChoiceDialog(self)
	if not self.styled then
		for i = 6, 7 do
			local button = select(i, self:GetChildren())
			if button then
				button.ItemNameBG:Hide()

				local icbg = B.ReskinIcon(button.Icon)
				B.CreateBGFrame(button, C.margin, 0, -5, 0, icbg)
			end
		end

		local Child = self.Details.Child
		B.ReskinText(Child.TitleHeader, 1, .8, 0)
		B.ReskinText(Child.ObjectivesHeader, 1, .8, 0)

		self.styled = true
	end
end

C.OnLoadThemes["Blizzard_AdventureMap"] = function()
	local ChoiceDialog = AdventureMapQuestChoiceDialog

	B.ReskinFrame(ChoiceDialog)
	B.ReskinButton(ChoiceDialog.AcceptButton)
	B.ReskinButton(ChoiceDialog.DeclineButton)
	B.ReskinScroll(ChoiceDialog.Details.ScrollBar)

	ChoiceDialog:HookScript("OnShow", Reskin_ChoiceDialog)
end

C.OnLoadThemes["Blizzard_AnimaDiversionUI"] = function()
	local frame = AnimaDiversionFrame
	B.ReskinButton(frame.ReinforceInfoFrame.AnimaNodeReinforceButton)

	local bg = B.ReskinFrame(frame)
	bg:SetOutside(frame.ScrollContainer.Child)

	local currency = frame.AnimaDiversionCurrencyFrame
	B.StripTextures(currency)
	currency:ClearAllPoints()
	currency:SetPoint("TOP", bg)

	local CurrencyFrame = currency.CurrencyFrame
	B.ReplaceIconString(CurrencyFrame.Quantity)
end

C.OnLoadThemes["Blizzard_BattlefieldMap"] = function()
	local BorderFrame = BattlefieldMapFrame.BorderFrame

	local bg = B.ReskinFrame(BorderFrame)
	bg:SetParent(BattlefieldMapFrame)
	bg:SetOutside(BattlefieldMapFrame.ScrollContainer)

	B.ReskinTab(BattlefieldMapTab)
	B.ReskinFrame(OpacityFrame)
	B.ReskinSlider(OpacityFrameSlider, true)
end

C.OnLoadThemes["Blizzard_ChromieTimeUI"] = function()
	local frame = ChromieTimeFrame

	B.ReskinFrame(frame)
	B.ReskinButton(frame.SelectButton)

	local title = frame.Title
	B.StripTextures(title)
	title.Text:SetFontObject(SystemFont_Huge1)
	B.ReskinText(title.Text, 1, .8, 0)

	local infoFrame = frame.CurrentlySelectedExpansionInfoFrame
	B.ReskinText(infoFrame.Name, 1, .8, 0)
	B.ReskinText(infoFrame.Description, 1, 1, 1)
	infoFrame.Background:Hide()
end

local function Reskin_Contribution(self)
	if not self.styled then
		B.ReskinButton(self.ContributeButton)

		local Header = self.Header
		Header.Background:Hide()
		B.ReskinText(Header.Text, 1, .8, 0)

		self.styled = true
	end
end

local function Reskin_ContributionReward(self)
	if not self.styled then
		self.Border:Hide()
		self:GetRegions():Hide()

		B.ReskinIcon(self.Icon)
		B.ReskinText(self.RewardName, 1, 1, 1)

		self.styled = true
	end
end

C.OnLoadThemes["Blizzard_Contribution"] = function()
	B.ReskinFrame(ContributionCollectionFrame)

	hooksecurefunc(ContributionMixin, "Update", Reskin_Contribution)
	hooksecurefunc(ContributionRewardMixin, "Setup", Reskin_ContributionReward)
end

C.OnLoadThemes["Blizzard_DeathRecap"] = function()
	B.StripTextures(DeathRecapFrame)
	B.CreateBG(DeathRecapFrame)
	B.ReskinButton(DeathRecapFrame.CloseButton)
	B.ReskinClose(DeathRecapFrame.CloseXButton)

	for i = 1, NUM_DEATH_RECAP_EVENTS do
		local SpellInfo = DeathRecapFrame["Recap"..i].SpellInfo
		SpellInfo.IconBorder:Hide()
		B.ReskinIcon(SpellInfo.Icon)
	end
end

C.OnLoadThemes["Blizzard_FlightMap"] = function()
	if IsAddOnLoaded("WorldFlightMap") then return end

	local BorderFrame = FlightMapFrame.BorderFrame

	local bg = B.ReskinFrame(BorderFrame)
	bg:SetParent(FlightMapFrame)
	bg:SetOutside(FlightMapFrame.ScrollContainer)

	local TitleText = BorderFrame.TitleText
	TitleText:ClearAllPoints()
	TitleText:SetPoint("TOP", bg, 0, -6)
end

C.OnLoadThemes["Blizzard_NewPlayerExperienceGuide"] = function()
	B.ReskinFrame(GuideFrame)
	B.ReskinText(GuideFrame.Title, 1, .8, 0)

	local ScrollFrame = GuideFrame.ScrollFrame
	B.ReskinScroll(ScrollFrame.ScrollBar)
	B.ReskinButton(ScrollFrame.ConfirmationButton)
	B.ReskinText(ScrollFrame.Child.Text, 1, 1, 1)
end

C.OnLoadThemes["Blizzard_ObliterumUI"] = function()
	B.ReskinFrame(ObliterumForgeFrame)
	B.ReskinButton(ObliterumForgeFrame.ObliterateButton)
	B.ReskinIcon(ObliterumForgeFrame.ItemSlot.Icon)
end

local function Reskin_PartyPoseUI(self)
	B.ReskinFrame(self)
	B.ReskinButton(self.LeaveButton)
	B.StripTextures(self.ModelScene, 0)
	B.CreateBDFrame(self.ModelScene, 0, -C.mult)

	self.OverlayElements:Hide()

	local RewardFrame = self.RewardAnimations.RewardFrame
	RewardFrame.NameFrame:SetAlpha(0)

	local icbg = B.ReskinIcon(RewardFrame.Icon)
	B.ReskinBorder(RewardFrame.IconBorder, icbg)

	local Label = RewardFrame.Label
	Label:ClearAllPoints()
	Label:SetPoint("LEFT", icbg, "RIGHT", 6, 10)

	local Name = RewardFrame.Name
	Name:ClearAllPoints()
	Name:SetPoint("LEFT", icbg, "RIGHT", 6, -10)
end

C.OnLoadThemes["Blizzard_IslandsPartyPoseUI"] = function()
	Reskin_PartyPoseUI(IslandsPartyPoseFrame)
end

C.OnLoadThemes["Blizzard_WarfrontsPartyPoseUI"] = function()
	Reskin_PartyPoseUI(WarfrontsPartyPoseFrame)
end

C.OnLoadThemes["Blizzard_ScrappingMachineUI"] = function()
	B.ReskinFrame(ScrappingMachineFrame)
	B.ReskinButton(ScrappingMachineFrame.ScrapButton)

	local ItemSlots = ScrappingMachineFrame.ItemSlots
	B.StripTextures(ItemSlots)

	local activeObjects = ItemSlots.scrapButtons.activeObjects
	for button in pairs(activeObjects) do
		if button and not button.styled then
			local icbg = B.ReskinIcon(button.Icon)
			B.ReskinHLTex(button, icbg)
			B.ReskinBorder(button.IconBorder, icbg)

			button.styled = true
		end
	end
end

local function Reskin_Button(self)
	B.CreateBDFrame(self)
	B.ReskinText(self.ButtonText, 1, .8, 0)
end

C.OnLoadThemes["Blizzard_SubscriptionInterstitialUI"] = function()
	B.ReskinFrame(SubscriptionInterstitialFrame)

	B.ReskinButton(SubscriptionInterstitialFrame.ClosePanelButton)
	Reskin_Button(SubscriptionInterstitialFrame.UpgradeButton)
	Reskin_Button(SubscriptionInterstitialFrame.SubscribeButton)
end

local function Reskin_TalkingHeadFrame()
	local frame = TalkingHeadFrame

	B.StripTextures(frame.PortraitFrame)
	B.StripTextures(frame.BackgroundFrame)

	B.ReskinText(frame.NameFrame.Name, 1, .8, 0)
	B.ReskinText(frame.TextFrame.Text, 1, 1, 1)

	local MainFrame = frame.MainFrame
	B.StripTextures(MainFrame.Model)

	if not MainFrame.styled then
		B.ReskinFrame(MainFrame)
		B.CreateBDFrame(MainFrame.Model, 0, -C.mult)

		MainFrame.styled = true
	end
end

C.OnLoadThemes["Blizzard_TalkingHeadUI"] = function()
	TalkingHeadFrame:SetScale(UIParent:GetScale())

	hooksecurefunc("TalkingHeadFrame_PlayCurrent", Reskin_TalkingHeadFrame)
end

C.OnLoadThemes["Blizzard_TorghastLevelPicker"] = function()
	local frame = TorghastLevelPickerFrame

	B.ReskinClose(frame.CloseButton, frame, -60, -60)
	B.ReskinButton(frame.OpenPortalButton)
	B.ReskinArrow(frame.Pager.PreviousPage, "left", 22)
	B.ReskinArrow(frame.Pager.NextPage, "right", 22)
end

C.OnLoadThemes["Blizzard_Tutorial"] = function()
	local frame = NPE_TutorialKeyboardMouseFrame_Frame
	frame.TitleBg:Hide()

	B.ReskinFrame(frame)
	B.ReskinText(NPE_TutorialKeyString, 1, 1, 1)
end