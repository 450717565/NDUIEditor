local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	-- Fix Alertframe bg
	local function fixBg(f)
		if f:GetObjectType() == "AnimationGroup" then
			f = f:GetParent()
		end
		if f.bg then
			f.bg:SetBackdropColor(0, 0, 0, AuroraConfig.alpha)
		end
	end

	local function fixParentbg(f)
		f = f:GetParent():GetParent()
		if f.bg then
			f.bg:SetBackdropColor(0, 0, 0, AuroraConfig.alpha)
		end
	end

	local function fixAnim(frame)
		frame:HookScript("OnEnter", fixBg)
		frame:HookScript("OnShow", fixBg)
		frame.animIn:HookScript("OnFinished", fixBg)
		if frame.animArrows then
			frame.animArrows:HookScript("OnPlay", fixBg)
			frame.animArrows:HookScript("OnFinished", fixBg)
		end
	end

	hooksecurefunc("AlertFrame_PauseOutAnimation", fixBg)

	-- AlertFrames
	hooksecurefunc(AlertFrame, "AddAlertFrame", function(_, frame)
		if frame.queue == AchievementAlertSystem then
			if not frame.bg then
				frame.bg = F.CreateBDFrame(frame, .25)
				frame.bg:SetPoint("TOPLEFT", 0, -7)
				frame.bg:SetPoint("BOTTOMRIGHT", 0, 8)

				frame.Unlocked:SetTextColor(1, 1, 1)
				frame.GuildName:ClearAllPoints()
				frame.GuildName:SetPoint("TOPLEFT", 50, -14)
				frame.GuildName:SetPoint("TOPRIGHT", -50, -14)
				F.ReskinIcon(frame.Icon.Texture)

				frame.GuildBanner:SetTexture("")
				frame.OldAchievement:SetTexture("")
				frame.GuildBorder:SetTexture("")
				frame.Icon.Bling:SetTexture("")
			end
			frame.glow:SetTexture("")
			frame.Background:SetTexture("")
			frame.Icon.Overlay:SetTexture("")
			-- otherwise it hides
			frame.Shield.Points:Show()
			frame.Shield.Icon:Show()
		elseif frame.queue == CriteriaAlertSystem then
			if not frame.bg then
				frame.bg = F.CreateBDFrame(frame, .25)
				frame.bg:SetPoint("TOPLEFT", frame, -18, 5)
				frame.bg:SetPoint("BOTTOMRIGHT", frame, 18, -1)

				frame.Icon:SetScale(.8)
				frame.Unlocked:SetTextColor(1, 1, 1)
				F.ReskinIcon(frame.Icon.Texture)
				frame.Background:SetTexture("")
				frame.Icon.Bling:SetTexture("")
				frame.Icon.Overlay:SetTexture("")
				frame.glow:SetTexture("")
				frame.shine:SetTexture("")
			end
		elseif frame.queue == LootAlertSystem then
			if not frame.bg then
				frame.bg = F.CreateBDFrame(frame, .25)
				frame.bg:SetPoint("TOPLEFT", frame, 13, -15)
				frame.bg:SetPoint("BOTTOMRIGHT", frame, -13, 11)

				F.ReskinIcon(frame.Icon, 0)
				frame.SpecRing:SetTexture("")
				frame.SpecIcon.bg = F.ReskinIcon(frame.SpecIcon)
			end
			frame.glow:SetTexture("")
			frame.shine:SetTexture("")
			frame.Background:SetTexture("")
			frame.PvPBackground:SetTexture("")
			frame.BGAtlas:SetTexture("")
			frame.IconBorder:SetTexture("")
			frame.SpecIcon.bg:SetShown(frame.SpecIcon:IsShown() and frame.SpecIcon:GetTexture() ~= nil)
		elseif frame.queue == LootUpgradeAlertSystem then
			if not frame.bg then
				frame.bg = F.CreateBDFrame(frame, .25)
				frame.bg:SetPoint("TOPLEFT", 10, -13)
				frame.bg:SetPoint("BOTTOMRIGHT", -12, 11)

				F.ReskinIcon(frame.Icon)
				frame.Icon:SetDrawLayer("BORDER", 5)
				frame.Icon:ClearAllPoints()
				frame.Icon:SetPoint("CENTER", frame.BaseQualityBorder)

				frame.BaseQualityBorder:SetSize(52, 52)
				frame.BaseQualityBorder:SetTexture(C.media.bdTex)
				frame.UpgradeQualityBorder:SetTexture(C.media.bdTex)
				frame.UpgradeQualityBorder:SetSize(52, 52)
				frame.Background:SetTexture("")
				frame.Sheen:SetTexture("")
				frame.BorderGlow:SetTexture("")
			end
			frame.BaseQualityBorder:SetTexture("")
			frame.UpgradeQualityBorder:SetTexture("")
		elseif frame.queue == MoneyWonAlertSystem or frame.queue == HonorAwardedAlertSystem then
			if not frame.bg then
				frame.bg = F.CreateBDFrame(frame, .25)
				frame.bg:SetPoint("TOPLEFT", 7, -7)
				frame.bg:SetPoint("BOTTOMRIGHT", -7, 7)

				F.ReskinIcon(frame.Icon)

				frame.Background:SetTexture("")
				frame.IconBorder:SetTexture("")
			end
		elseif frame.queue == NewRecipeLearnedAlertSystem then
			if not frame.bg then
				frame.bg = F.CreateBDFrame(frame, .25)
				frame.bg:SetPoint("TOPLEFT", 10, -5)
				frame.bg:SetPoint("BOTTOMRIGHT", -10, 5)

				frame:GetRegions():SetTexture("")
				F.CreateBDFrame(frame.Icon, 0)
				frame.glow:SetTexture("")
				frame.shine:SetTexture("")
			end
			frame.Icon:SetMask(nil)
			frame.Icon:SetTexCoord(.08, .92, .08, .92)
		elseif frame.queue == WorldQuestCompleteAlertSystem then
			if not frame.bg then
				frame.bg = F.CreateBDFrame(frame, .25)
				frame.bg:SetPoint("TOPLEFT", 3, -9)
				frame.bg:SetPoint("BOTTOMRIGHT", -3, 6)
				F.ReskinIcon(frame.QuestTexture)
				frame.shine:SetTexture("")
				for i = 2, 5 do
					select(i, frame:GetRegions()):Hide()
				end
			end
		elseif frame.queue == GarrisonTalentAlertSystem then
			if not frame.bg then
				frame.bg = F.CreateBDFrame(frame, .25)
				frame.bg:SetPoint("TOPLEFT", 8, -8)
				frame.bg:SetPoint("BOTTOMRIGHT", -8, 11)
				F.ReskinIcon(frame.Icon)
				frame:GetRegions():Hide()
				frame.glow:SetTexture("")
				frame.shine:SetTexture("")
			end
		elseif frame.queue == GarrisonFollowerAlertSystem then
			if not frame.bg then
				frame.bg = F.CreateBDFrame(frame, .25)
				frame.bg:SetPoint("TOPLEFT", 16, -3)
				frame.bg:SetPoint("BOTTOMRIGHT", -16, 16)

				frame.Arrows.ArrowsAnim:HookScript("OnPlay", fixParentbg)
				frame.Arrows.ArrowsAnim:HookScript("OnFinished", fixParentbg)

				frame:GetRegions():Hide()
				select(5, frame:GetRegions()):Hide()
				F.ReskinGarrisonPortrait(frame.PortraitFrame)
				frame.PortraitFrame:ClearAllPoints()
				frame.PortraitFrame:SetPoint("TOPLEFT", 22, -8)

				frame.glow:SetTexture("")
				frame.shine:SetTexture("")
			end
			frame.FollowerBG:SetTexture("")
		elseif frame.queue == GarrisonMissionAlertSystem or frame.queue == GarrisonShipMissionAlertSystem or frame.queue == GarrisonShipFollowerAlertSystem then
			if not frame.bg then
				frame.bg = F.CreateBDFrame(frame, .25)
				frame.bg:SetPoint("TOPLEFT", 8, -8)
				frame.bg:SetPoint("BOTTOMRIGHT", -8, 10)

				frame.Background:Hide()
				if frame.IconBG then frame.IconBG:Hide() end
				frame.glow:SetTexture("")
				frame.shine:SetTexture("")
			end
		elseif frame.queue == GarrisonBuildingAlertSystem then
			if not frame.bg then
				frame.bg = F.CreateBDFrame(frame, .25)
				frame.bg:SetPoint("TOPLEFT", 9, -9)
				frame.bg:SetPoint("BOTTOMRIGHT", -9, 11)

				frame.Icon:SetDrawLayer("ARTWORK")
				F.ReskinIcon(frame.Icon)
				frame:GetRegions():Hide()
				frame.glow:SetTexture("")
				frame.shine:SetTexture("")
			end
		elseif frame.queue == DigsiteCompleteAlertSystem then
			if not frame.bg then
				frame.bg = F.CreateBDFrame(frame, .25)
				frame.bg:SetPoint("TOPLEFT", 8, -8)
				frame.bg:SetPoint("BOTTOMRIGHT", -8, 8)
				frame:GetRegions():Hide()
				frame.glow:SetTexture("")
				frame.shine:SetTexture("")
			end
		elseif frame.queue == GuildChallengeAlertSystem then
			if not frame.bg then
				frame.bg = F.CreateBDFrame(frame, .25)
				frame.bg:SetPoint("TOPLEFT", 8, -12)
				frame.bg:SetPoint("BOTTOMRIGHT", -8, 13)
				select(2, frame:GetRegions()):SetTexture("")
				frame.glow:SetTexture("")
				frame.shine:SetTexture("")
			end
		elseif frame.queue == DungeonCompletionAlertSystem then
			if not frame.bg then
				frame.bg = F.CreateBDFrame(frame, .25)
				frame.bg:SetPoint("TOPLEFT", 2, -10)
				frame.bg:SetPoint("BOTTOMRIGHT", 0, 2)
				F.ReskinIcon(frame.dungeonTexture)
				frame:DisableDrawLayer("Border")
				frame.heroicIcon:SetTexture("")
				frame.glowFrame.glow:SetTexture("")
				frame.shine:SetTexture("")
			end
		elseif frame.queue == ScenarioAlertSystem then
			if not frame.bg then
				frame.bg = F.CreateBDFrame(frame, .25)
				frame.bg:SetPoint("TOPLEFT", 5, -5)
				frame.bg:SetPoint("BOTTOMRIGHT", -5, 5)
				F.ReskinIcon(frame.dungeonTexture)
				select(1, frame:GetRegions()):Hide()
				select(3, frame:GetRegions()):Hide()
				frame.glowFrame.glow:SetTexture("")
				frame.shine:SetTexture("")
			end
		elseif frame.queue == LegendaryItemAlertSystem then
			if not frame.bg then
				frame.bg = F.CreateBDFrame(frame, .25)
				frame.bg:SetPoint("TOPLEFT", 25, -22)
				frame.bg:SetPoint("BOTTOMRIGHT", -25, 22)
				frame:HookScript("OnUpdate", fixBg)

				F.ReskinIcon(frame.Icon)
				frame.Icon:ClearAllPoints()
				frame.Icon:SetPoint("TOPLEFT", frame.bg, 12, -12)

				frame.Background:SetTexture("")
				frame.Background2:SetTexture("")
				frame.Background3:SetTexture("")
				frame.glow:SetTexture("")
			end
		elseif frame.queue == NewPetAlertSystem or frame.queue == NewMountAlertSystem or frame.queue == NewToyAlertSystem then
			if not frame.bg then
				frame.bg = F.CreateBDFrame(frame, .25)
				frame.bg:SetPoint("TOPLEFT", 12, -13)
				frame.bg:SetPoint("BOTTOMRIGHT", -12, 10)

				F.ReskinIcon(frame.Icon)
				frame.IconBorder:Hide()
				frame.Background:SetTexture("")
				frame.shine:SetTexture("")
				frame.glow:SetTexture("")
			end
		elseif frame.queue == InvasionAlertSystem then
			if not frame.bg then
				frame.bg = F.CreateBDFrame(frame, .25)
				frame.bg:SetPoint("TOPLEFT", 6, -6)
				frame.bg:SetPoint("BOTTOMRIGHT", -6, 6)

				select(1, frame:GetRegions()):Hide()
				local icon = select(2, frame:GetRegions())
				F.ReskinIcon(icon)
			end
		end

		fixAnim(frame)
	end)

	-- Reward Icons
	hooksecurefunc("StandardRewardAlertFrame_AdjustRewardAnchors", function(frame)
		if frame.RewardFrames then
			for i = 1, frame.numUsedRewardFrames do
				local reward = frame.RewardFrames[i]
				if not reward.bg then
					select(2, reward:GetRegions()):SetTexture("")
					reward.texture:ClearAllPoints()
					reward.texture:SetPoint("TOPLEFT", 6, -6)
					reward.texture:SetPoint("BOTTOMRIGHT", -6, 6)
					reward.bg = F.ReskinIcon(reward.texture)
				end
			end
		end
	end)

	-- BonusRollLootWonFrame
	hooksecurefunc("LootWonAlertFrame_SetUp", function(f)
		if not f.bg then
			f.bg = F.CreateBDFrame(f, .25)
			f.bg:SetPoint("TOPLEFT", 10, -10)
			f.bg:SetPoint("BOTTOMRIGHT", -10, 10)
			fixAnim(f)

			f.shine:SetTexture("")
			f.Icon:SetDrawLayer("BORDER")
			F.ReskinIcon(f.Icon)

			f.SpecRing:SetTexture("")
			f.SpecIcon.bg = F.ReskinIcon(f.SpecIcon)
			f.SpecIcon.bg:SetShown(f.SpecIcon:IsShown() and f.SpecIcon:GetTexture() ~= nil)
		end

		f.glow:SetTexture("")
		f.Background:SetTexture("")
		f.PvPBackground:SetTexture("")
		f.BGAtlas:SetTexture("")
		f.IconBorder:SetTexture("")
	end)

	-- BonusRollMoneyWonFrame
	hooksecurefunc("MoneyWonAlertFrame_SetUp", function(f)
		if not f.bg then
			f.bg = F.CreateBDFrame(f, .25)
			f.bg:SetPoint("TOPLEFT", 5, -5)
			f.bg:SetPoint("BOTTOMRIGHT", -5, 5)
			fixAnim(f)

			f.Background:SetTexture("")
			f.Icon:SetDrawLayer("ARTWORK")
			F.ReskinIcon(f.Icon)
			f.IconBorder:SetTexture("")
		end
	end)
end)
