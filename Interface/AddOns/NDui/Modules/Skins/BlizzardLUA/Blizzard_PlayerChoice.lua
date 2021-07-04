local _, ns = ...
local B, C, L, DB = unpack(ns)

local function ShouldHideBackground()
	local instID = select(3, GetInstanceInfo())
	return IsInJailersTower() or instID == 8
end

-- Needs review, still buggy on blizz
local function Reskin_OptionButton(self)
	if not self or self.bgTex then return end

	B.StripTextures(self)
	B.ReskinButton(self)
end

local function Reskin_SpellWidget(spell)
	B.StripTextures(spell, 1)
	B.ReskinText(spell.Text, 1, 1, 1)

	if not spell.styled then
		local icbg = B.ReskinIcon(spell.Icon)
		B.ReskinBorder(spell.DebuffBorder, icbg, nil, true)

		spell.styled = true
	end
end

local function Reskin_PlayerChoiceFrame(self)
	if not self.bg then
		local Title = self.Title
		Title:DisableDrawLayer("BACKGROUND")
		Title.Text:SetFontObject(SystemFont_Huge1)
		B.ReskinText(Title.Text, 1, .8, 0)

		self.bg = B.ReskinFrame(self)
	end

	self.bg:SetShown(not ShouldHideBackground())
	B.UpdatePoint(self.CloseButton, "TOPRIGHT", self.bg, "TOPRIGHT", -6, -6)

	for optionFrame in self.optionPools:EnumerateActiveByTemplate(self.optionFrameTemplate) do
		optionFrame.CircleBorder:Hide()

		B.ReskinText(optionFrame.OptionText, 1, 1, 1)

		local header = optionFrame.Header
		if header then
			B.ReskinText(header.Text, 1, .8, 0)
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
				B.ReskinText(widgetFrame.Text, 1, 1, 1)

				if widgetFrame.Spell then
					Reskin_SpellWidget(widgetFrame.Spell)
				end
			end
		end
	end
end

C.OnLoadThemes["Blizzard_PlayerChoice"] = function()
	hooksecurefunc(PlayerChoiceFrame, "TryShow", Reskin_PlayerChoiceFrame)
end