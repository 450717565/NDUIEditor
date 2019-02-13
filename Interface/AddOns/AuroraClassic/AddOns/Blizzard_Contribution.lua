local F, C = unpack(select(2, ...))

C.themes["Blizzard_Contribution"] = function()
	F.ReskinFrame(ContributionCollectionFrame)

	hooksecurefunc(ContributionMixin, "Update", function(self)
		if not self.styled then
			self.Header.Text:SetTextColor(1, .8, 0)
			F.ReskinButton(self.ContributeButton)

			self.styled = true
		end
	end)

	hooksecurefunc(ContributionRewardMixin, "Setup", function(self)
		if not self.styled then
			self.RewardName:SetTextColor(1, 1, 1)
			self.Border:Hide()
			self:GetRegions():Hide()
			F.ReskinIcon(self.Icon)

			self.styled = true
		end
	end)

	-- Tooltips
	if AuroraConfig.tooltips then
		F.ReskinTooltip(ContributionBuffTooltip)
	end
end