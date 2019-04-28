local F, C = unpack(select(2, ...))

C.themes["Blizzard_ChallengesUI"] = function()
	F.StripTextures(ChallengesFrame, true)

	local angryStyle
	local function UpdateIcons(self)
		for i = 1, #self.maps do
			local bu = self.DungeonIcons[i]
			if bu and not bu.styled then
				bu:GetRegions():Hide()
				bu.Icon:SetScale(.95)
				F.ReskinIcon(bu.Icon)

				bu.styled = true
			end
			if i == 1 then
				self.WeeklyInfo.Child.SeasonBest:ClearAllPoints()
				self.WeeklyInfo.Child.SeasonBest:SetPoint("BOTTOMLEFT", self.DungeonIcons[i], "TOPLEFT", 0, 5)
			end
		end

		if IsAddOnLoaded("AngryKeystones") and not angryStyle then
			local scheduel, party = select(5, self:GetChildren())

			F.StripTextures(scheduel)
			F.CreateBDFrame(scheduel, 0)
			if scheduel.Entries then
				for i = 1, 3 do
					F.ReskinAffixes(scheduel.Entries[i])
				end
			end

			F.StripTextures(party)
			F.CreateBDFrame(party, 0)

			angryStyle = true
		end
	end
	hooksecurefunc("ChallengesFrame_Update", UpdateIcons)

	hooksecurefunc(ChallengesFrame.WeeklyInfo, "SetUp", function(self)
		local affixes = C_MythicPlus.GetCurrentAffixes()
		if affixes then
			F.ReskinAffixes(self.Child)
		end
	end)

	F.ReskinFrame(ChallengesKeystoneFrame)
	F.ReskinButton(ChallengesKeystoneFrame.StartButton)

	hooksecurefunc(ChallengesKeystoneFrame, "Reset", function(self)
		self:GetRegions():Hide()
		self.InstructionBackground:Hide()
	end)

	hooksecurefunc(ChallengesKeystoneFrame, "OnKeystoneSlotted", F.ReskinAffixes)

	-- New season
	local NewSeason = ChallengesFrame.SeasonChangeNoticeFrame
	F.ReskinButton(NewSeason.Leave)
	NewSeason.NewSeason:SetTextColor(1, .8, 0)
	NewSeason.SeasonDescription:SetTextColor(1, 1, 1)
	NewSeason.SeasonDescription2:SetTextColor(1, 1, 1)
	NewSeason.SeasonDescription3:SetTextColor(1, .8, 0)

	local affix = NewSeason.Affix
	F.StripTextures(affix)
	F.ReskinIcon(affix.Portrait)
	affix.Portrait:SetTexture(2446016)
end