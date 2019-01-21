local F, C = unpack(select(2, ...))

C.themes["Blizzard_ChallengesUI"] = function()
	F.StripTextures(ChallengesFrame, true)

	local angryStyle
	local function UpdateIcons(self)
		for i = 1, #self.maps do
			local bu = self.DungeonIcons[i]
			if bu and not bu.styled then
				bu:GetRegions():SetAlpha(0)
				bu.Icon:SetScale(.95)
				F.ReskinIcon(bu.Icon, true)

				bu.styled = true
			end
		end

		if IsAddOnLoaded("AngryKeystones") and not angryStyle then
			local scheduel, party = select(5, self:GetChildren())

			F.StripTextures(scheduel, true)
			F.CreateBDFrame(scheduel, .25)
			if scheduel.Entries then
				for i = 1, 3 do
					F.ReskinAffixes(scheduel.Entries[i])
				end
			end

			F.StripTextures(party, true)
			F.CreateBDFrame(party, .25)

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
		self:GetRegions():SetAlpha(0)
		self.InstructionBackground:SetAlpha(0)
	end)

	hooksecurefunc(ChallengesKeystoneFrame, "OnKeystoneSlotted", F.ReskinAffixes)
end