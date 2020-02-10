local B, C, L, DB = unpack(select(2, ...))

C.themes["Blizzard_ChallengesUI"] = function()
	B.StripTextures(ChallengesFrame)

	local angryStyle
	local function UpdateIcons(self)
		for i = 1, #self.maps do
			local bu = self.DungeonIcons[i]
			if bu and not bu.styled then
				bu:GetRegions():Hide()
				bu.Icon:SetScale(.95)
				B.ReskinIcon(bu.Icon)

				bu.styled = true
			end
			if i == 1 then
				self.WeeklyInfo.Child.SeasonBest:ClearAllPoints()
				self.WeeklyInfo.Child.SeasonBest:SetPoint("BOTTOMLEFT", self.DungeonIcons[i], "TOPLEFT", 0, 5)
			end
		end

		if IsAddOnLoaded("AngryKeystones") and not angryStyle then
			local mod = AngryKeystones.Modules.Schedule
			local scheduel = mod.AffixFrame
			local party = mod.PartyFrame

			B.StripTextures(scheduel)
			B.CreateBDFrame(scheduel, 0)
			if scheduel.Entries then
				for i = 1, 3 do
					B.ReskinAffixes(scheduel.Entries[i])
				end
			end

			B.StripTextures(party)
			B.CreateBDFrame(party, 0)

			angryStyle = true
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
	local bg = B.ReskinIcon(Affix.Portrait)
	bg:SetFrameLevel(3)

	hooksecurefunc(Affix, "SetUp", function(_, affixID)
		local _, _, texture = C_ChallengeMode.GetAffixInfo(affixID)
		if texture then
			Affix.Portrait:SetTexture(texture)
		end
	end)
end