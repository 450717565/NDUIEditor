local _, ns = ...
local B, C, L, DB = unpack(ns)

local function Reskin_TextColor(self, r, g, b)
	if self.styled then return end

	B.ReskinText(self, r, g, b)
	self.SetTextColor = B.Dummy

	self.styled = true
end

local function Reskin_FirstOptionButton(self)
	if not self or self.bgTex then return end

	B.StripTextures(self)
	B.ReskinButton(self)
end

local function Reskin_SecondOptionButton(self)
	if not self or self.bgTex then return end

	B.ReskinButton(self, false, true)
end

local function Reskin_Update(self)
	if not self.bg then
		self.BlackBackground:SetAlpha(0)

		local Title = self.Title
		Title:DisableDrawLayer("BACKGROUND")
		Title.Text:SetFontObject(SystemFont_Huge1)
		B.ReskinText(Title.Text, 1, .8, 0)

		self.bg = B.ReskinFrame(self)
	end

	self.bg:SetShown(not IsInJailersTower())
	self.CloseButton:SetPoint("TOPRIGHT", self.bg, -6, -6)

	for i = 1, self:GetNumOptions() do
		local option = self.Options[i]
		B.ReskinText(option.Header.Text, 1, .8, 0)
		B.ReskinText(option.OptionText, 1, 1, 1)

		local children = {option.WidgetContainer:GetChildren()}
		for _, child in pairs(children) do
			if child then
				if child.Text then
					Reskin_TextColor(child.Text, 1, 1, 1)
				end

				if child.LeadingText then
					Reskin_TextColor(child.LeadingText, 1, .8, 0)
				end

				if child.Spell then
					if not child.Spell.styled then
						child.Spell.Border:SetTexture("")
						child.Spell.IconMask:Hide()
						B.ReskinIcon(child.Spell.Icon)

						child.Spell.styled = true
					end

					Reskin_TextColor(child.Spell.Text, 1, .8, 0)
				end

				local subChildren = {child:GetChildren()}
				for _, subChild in pairs(subChildren) do
					if subChild then
						if subChild.Text then
							Reskin_TextColor(subChild.Text, 1, 1, 1)
						end

						if subChild.LeadingText then
							Reskin_TextColor(subChild.LeadingText, 1, .8, 0)
						end

						if subChild.Icon and not subChild.Icon.styled then
							B.ReskinIcon(subChild.Icon)

							subChild.Icon.styled = true
						end
					end
				end
			end
		end

		Reskin_FirstOptionButton(option.OptionButtonsContainer.button1)
		Reskin_SecondOptionButton(option.OptionButtonsContainer.button2)
	end
end

local function Reskin_SetupRewards(self)
	for i = 1, self.numActiveOptions do
		local Rewards = self.Options[i].RewardsFrame.Rewards
		for button in Rewards.ItemRewardsPool:EnumerateActive() do
			if button and not button.styled then
				local icbg = B.ReskinIcon(button.Icon)
				B.ReskinBorder(button.IconBorder, icbg)
				B.ReskinText(button.Name, .9, .8, .5)

				button.styled = true
			end
		end
	end
end

-- Note: isNewPatch, PlayerChoiceUI rename to PlayerChoice
C.OnLoadThemes["Blizzard_PlayerChoiceUI"] = function()
	hooksecurefunc(PlayerChoiceFrame, "Update", Reskin_Update)
	hooksecurefunc(PlayerChoiceFrame, "SetupRewards", Reskin_SetupRewards)
end