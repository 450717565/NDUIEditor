local F, C = unpack(select(2, ...))

C.themes["Blizzard_ChallengesUI"] = function()
	F.StripTextures(ChallengesFrame, true)
	F.StripTextures(ChallengesFrameInset, true)

	local angryStyle
	local function UpdateIcons(self)
		for i = 1, #self.maps do
			local bu = self.DungeonIcons[i]
			if bu and not bu.styled then
				bu:GetRegions():SetAlpha(0)
				bu.Icon:SetTexCoord(.08, .92, .08, .92)
				F.CreateBD(bu, .25)
				F.CreateSD(bu)

				bu.styled = true
			end
		end

		if IsAddOnLoaded("AngryKeystones") and not angryStyle then
			local scheduel, party = select(5, self:GetChildren())

			F.StripTextures(scheduel, true)
			F.CreateBDFrame(scheduel, .25)
			if scheduel.Entries then
				for i = 1, 3 do
					F.AffixesSetup(scheduel.Entries[i])
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
			F.AffixesSetup(self.Child)
		end
	end)

	F.ReskinPortraitFrame(ChallengesKeystoneFrame, true)
	F.Reskin(ChallengesKeystoneFrame.StartButton)

	hooksecurefunc(ChallengesKeystoneFrame, "Reset", function(self)
		self:GetRegions():SetAlpha(0)
		self.InstructionBackground:SetAlpha(0)
	end)

	hooksecurefunc(ChallengesKeystoneFrame, "OnKeystoneSlotted", F.AffixesSetup)
end