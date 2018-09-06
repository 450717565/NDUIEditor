local F, C = unpack(select(2, ...))

C.themes["Blizzard_ChallengesUI"] = function()
	local function AffixesSetup(self)
		for _, frame in ipairs(self.Affixes) do
			frame.Border:SetTexture(nil)
			frame.Portrait:SetTexture(nil)
			if not frame.bg then
				frame.Portrait:SetTexCoord(.08, .92, .08, .92)
				frame.bg = F.CreateBDFrame(frame.Portrait, .25)
			end

			if frame.info then
				frame.Portrait:SetTexture(CHALLENGE_MODE_EXTRA_AFFIX_INFO[frame.info.key].texture)
			elseif frame.affixID then
				local _, _, filedataid = C_ChallengeMode.GetAffixInfo(frame.affixID)
				frame.Portrait:SetTexture(filedataid)
			end
		end
	end

	F.StripTextures(ChallengesFrame, true)
	F.StripTextures(ChallengesFrameInset, true)

	local angryStyle
	local function UpdateIcons(self)
		for i = 1, #self.maps do
			local bu = self.DungeonIcons[i]
			if bu and not bu.styled then
				bu:GetRegions():SetAlpha(0)
				bu.Icon:SetTexCoord(.08, .92, .08, .92)
				F.CreateBD(bu, .3)
				F.CreateSD(bu)
				bu.styled = true
			end
		end

		if IsAddOnLoaded("AngryKeystones") and not angryStyle then
			local scheduel = select(4, self:GetChildren())
			scheduel:GetRegions():SetAlpha(0)
			select(3, scheduel:GetRegions()):SetAlpha(0)
			F.CreateBD(scheduel, .3)
			F.CreateSD(scheduel)
			if scheduel.Entries then
				for i = 1, 4 do
					AffixesSetup(scheduel.Entries[i])
				end
			end

			angryStyle = true
		end
	end
	hooksecurefunc("ChallengesFrame_Update", UpdateIcons)

	hooksecurefunc(ChallengesFrame.WeeklyInfo, "SetUp", function(self)
		local affixes = C_MythicPlus.GetCurrentAffixes()
		if affixes then
			AffixesSetup(self.Child)
		end
	end)

	local keystone = ChallengesKeystoneFrame
	F.CreateBD(keystone)
	F.CreateSD(keystone)
	F.ReskinClose(keystone.CloseButton)
	F.Reskin(keystone.StartButton)

	hooksecurefunc(keystone, "Reset", function(self)
		self:GetRegions():SetAlpha(0)
		self.InstructionBackground:SetAlpha(0)
	end)

	hooksecurefunc(keystone, "OnKeystoneSlotted", AffixesSetup)
end