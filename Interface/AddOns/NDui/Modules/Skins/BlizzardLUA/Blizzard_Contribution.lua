local _, ns = ...
local B, C, L, DB = unpack(ns)

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

C.LUAThemes["Blizzard_Contribution"] = function()
	B.ReskinFrame(ContributionCollectionFrame)

	hooksecurefunc(ContributionMixin, "Update", Reskin_Contribution)
	hooksecurefunc(ContributionRewardMixin, "Setup", Reskin_ContributionReward)
end