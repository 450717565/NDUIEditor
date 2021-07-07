local _, ns = ...
local B, C, L, DB = unpack(ns)

local function Reskin_OptionButton(self)
	if not self or self.bgTex then return end

	B.ReskinButton(self)
end

local function Reskin_WidgetSpell(spell)
	B.StripTextures(spell, 1)
	B.ReskinText(spell.Text, 1, 1, 1)

	if not spell.styled then
		B.ReskinIcon(spell.Icon)

		spell.styled = true
	end
end

local function Reskin_PlayerChoiceFrame(self)
	B.StripTextures(self)
	B.StripTextures(self.Header)
	B.CleanTextures(self.CloseButton)

	if not self.bg then
		local Title = self.Title
		Title:DisableDrawLayer("BACKGROUND")
		Title.Text:SetFontObject(SystemFont_Huge1)
		B.ReskinText(Title.Text, 1, .8, 0)

		self.bg = B.ReskinFrame(self)
	end

	self.bg:SetShown(self.CloseButton:IsShown())
	B.UpdatePoint(self.CloseButton, "TOPRIGHT", self.bg, "TOPRIGHT", -6, -6)

	for optionFrame in self.optionPools:EnumerateActiveByTemplate(self.optionFrameTemplate) do
		B.ReskinText(optionFrame.OptionText, 1, 1, 1)

		local circleBorder = optionFrame.CircleBorder
		if circleBorder then
			circleBorder:Hide()
		end

		local header = optionFrame.Header
		if header then
			if header.Text then B.ReskinText(header.Text, 1, .8, 0) end
			if header.Contents then B.ReskinText(header.Contents.Text, 1, .8, 0) end
		end

		local optionButtonsContainer = optionFrame.OptionButtonsContainer
		if optionButtonsContainer and optionButtonsContainer.buttonPool then
			for button in optionButtonsContainer.buttonPool:EnumerateActive() do
				Reskin_OptionButton(button)
			end
		end

		local rewards = optionFrame.Rewards
		if rewards then
			for rewardFrame in rewards.rewardsPool:EnumerateActiveByTemplate("PlayerChoiceBaseOptionItemRewardTemplate") do
				B.ReskinText(rewardFrame.Name, .9, .8, .5)
				if not rewardFrame.styled then
					local itemButton = rewardFrame.itemButton
					B.StripTextures(itemButton, 1)

					local icbg = B.ReskinIcon(itemButton:GetRegions())
					B.ReskinBorder(itemButton.IconBorder, icbg)

					rewardFrame.styled = true
				end
			end

			--[[ unseen templates
			PlayerChoiceBaseOptionCurrencyContainerRewardTemplate
			PlayerChoiceBaseOptionCurrencyRewardTemplate
			PlayerChoiceBaseOptionReputationRewardTemplate ]]
		end

		local widgetContainer = optionFrame.WidgetContainer
		if widgetContainer and widgetContainer.widgetFrames then
			for _, widgetFrame in pairs(widgetContainer.widgetFrames) do
				if widgetFrame.Text then
					B.ReskinText(widgetFrame.Text, 1, 1, 1)
				end
				if widgetFrame.Spell then
					Reskin_WidgetSpell(widgetFrame.Spell)
				end
			end
		end
	end
end

C.OnLoadThemes["Blizzard_PlayerChoice"] = function()
	hooksecurefunc(PlayerChoiceFrame, "SetupOptions", Reskin_PlayerChoiceFrame)
end