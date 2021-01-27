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

	B.ReskinButton(self, true)
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

		if option.Header.Ribbon then option.Header.Ribbon:Hide() end
		--if option.Background then option.Background:Hide() end

		for i = 1, option.WidgetContainer:GetNumChildren() do
			local child1 = select(i, option.WidgetContainer:GetChildren())
			if child1 then
				if child1.Text then
					Reskin_TextColor(child1.Text, 1, 1, 1)
				end

				if child1.LeadingText then
					Reskin_TextColor(child1.LeadingText, 1, .8, 0)
				end

				if child1.Spell then
					if not child1.Spell.styled then
						child1.Spell.Border:SetTexture("")
						child1.Spell.IconMask:Hide()
						B.ReskinIcon(child1.Spell.Icon)

						child1.Spell.styled = true
					end

					Reskin_TextColor(child1.Spell.Text, 1, .8, 0)
				end

				for j = 1, child1:GetNumChildren() do
					local child2 = select(j, child1:GetChildren())
					if child2 then
						if child2.Text then
							Reskin_TextColor(child2.Text, 1, 1, 1)
						end

						if child2.LeadingText then
							Reskin_TextColor(child2.LeadingText, 1, .8, 0)
						end

						if child2.Icon and not child2.Icon.styled then
							B.ReskinIcon(child2.Icon)

							child2.Icon.styled = true
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

C.LUAThemes["Blizzard_PlayerChoiceUI"] = function()
	hooksecurefunc(PlayerChoiceFrame, "Update", Reskin_Update)
	hooksecurefunc(PlayerChoiceFrame, "SetupRewards", Reskin_SetupRewards)
end