local B, C, L, DB = unpack(select(2, ...))

C.themes["Blizzard_ChallengesUI"] = function()
	B.StripTextures(ChallengesFrame)

	ChallengesFrame.WeeklyInfo:SetInside()
	ChallengesFrame.Background:SetInside()

	local styled
	local function UpdateIcons(self)
		for i = 1, #self.maps do
			local DungeonIcon = self.DungeonIcons[i]
			if DungeonIcon and not DungeonIcon.styled then
				DungeonIcon:GetRegions():Hide()
				DungeonIcon.Icon:SetScale(.95)
				B.ReskinIcon(DungeonIcon.Icon)

				DungeonIcon.styled = true
			end
			if i == 1 then
				self.DungeonIcons[i]:ClearAllPoints()
				self.DungeonIcons[i]:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", B.Scale(2), B.Scale(2))

				local SeasonBest = self.WeeklyInfo.Child.SeasonBest
				SeasonBest:ClearAllPoints()
				SeasonBest:SetPoint("BOTTOMLEFT", self.DungeonIcons[i], "TOPLEFT", 0, 3)
			end
		end

		if IsAddOnLoaded("AngryKeystones") and not styled then
			local WeeklyChest = self.WeeklyInfo.Child.WeeklyChest
			local Modules = AngryKeystones.Modules.Schedule
			local AffixFrame = Modules.AffixFrame
			local PartyFrame = Modules.PartyFrame

			B.StripTextures(AffixFrame)
			B.CreateBDFrame(AffixFrame, 0)
			if AffixFrame.Entries then
				for i = 1, 3 do
					B.ReskinAffixes(AffixFrame.Entries[i])
				end
			end

			B.StripTextures(PartyFrame)
			B.CreateBDFrame(PartyFrame, 0)

			styled = true
		end
	end
	hooksecurefunc("ChallengesFrame_Update", UpdateIcons)

	hooksecurefunc(ChallengesFrame.WeeklyInfo, "SetUp", function(self)
		local affixes = C_MythicPlus.GetCurrentAffixes()
		if affixes then
			B.ReskinAffixes(self.Child)
		end
	end)

	local keystoneFrame = ChallengesKeystoneFrame
	B.ReskinFrame(keystoneFrame)
	B.ReskinButton(keystoneFrame.StartButton)

	hooksecurefunc(keystoneFrame, "Reset", function(self)
		self:GetRegions():Hide()
		self.InstructionBackground:Hide()
	end)

	hooksecurefunc(keystoneFrame, "OnKeystoneSlotted", B.ReskinAffixes)

	-- New season
	local noticeFrame = ChallengesFrame.SeasonChangeNoticeFrame
	B.ReskinButton(noticeFrame.Leave)
	noticeFrame.NewSeason:SetTextColor(1, .8, 0)
	noticeFrame.SeasonDescription:SetTextColor(1, 1, 1)
	noticeFrame.SeasonDescription2:SetTextColor(1, 1, 1)
	noticeFrame.SeasonDescription3:SetTextColor(1, .8, 0)

	local Affix = noticeFrame.Affix
	B.StripTextures(Affix)
	local icbg = B.ReskinIcon(Affix.Portrait)
	icbg:SetFrameLevel(3)

	hooksecurefunc(Affix, "SetUp", function(_, affixID)
		local _, _, texture = C_ChallengeMode.GetAffixInfo(affixID)
		if texture then
			Affix.Portrait:SetTexture(texture)
		end
	end)
end