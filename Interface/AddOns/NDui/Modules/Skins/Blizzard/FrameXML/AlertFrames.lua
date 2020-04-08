local B, C, L, DB = unpack(select(2, ...))

tinsert(C.defaultThemes, function()
	if IsAddOnLoaded("ls_Toasts") then return end

	local alpha = NDuiDB["Skins"]["BGAlpha"]

	-- Fix Alertframe bg
	local function fixBg(frame)
		if frame:GetObjectType() == "AnimationGroup" then
			frame = frame:GetParent()
		end
		if frame.bg then
			frame.bg:SetBackdropColor(0, 0, 0, alpha)
		end
	end

	local function fixParentbg(frame)
		frame = frame:GetParent():GetParent()
		if frame.bg then
			frame.bg:SetBackdropColor(0, 0, 0, alpha)
		end
	end

	local function fixAnim(frame)
		if frame.hooked then return end

		frame:HookScript("OnEnter", fixBg)
		frame:HookScript("OnShow", fixBg)
		frame.animIn:HookScript("OnFinished", fixBg)
		if frame.animArrows then
			frame.animArrows:HookScript("OnPlay", fixBg)
			frame.animArrows:HookScript("OnFinished", fixBg)
		end
		if frame.Arrows and frame.Arrows.ArrowsAnim then
			frame.Arrows.ArrowsAnim:HookScript("OnPlay", fixParentbg)
			frame.Arrows.ArrowsAnim:HookScript("OnFinished", fixParentbg)
		end

		frame.hookded = true
	end

	hooksecurefunc("AlertFrame_PauseOutAnimation", fixBg)

	-- AlertFrames
	hooksecurefunc(AlertFrame, "AddAlertFrame", function(_, frame)
		if frame.queue == AchievementAlertSystem then
			if not frame.bg then
				frame.bg = B.SetBDFrame(frame, 0, -7, 0, 8)

				frame.Unlocked:SetTextColor(1, 1, 1)
				frame.GuildName:ClearAllPoints()
				frame.GuildName:SetPoint("TOPLEFT", 50, -14)
				frame.GuildName:SetPoint("TOPRIGHT", -50, -14)

				frame.GuildBanner:SetTexture("")
				frame.OldAchievement:SetTexture("")
				frame.GuildBorder:SetTexture("")
				frame.Icon.Bling:SetTexture("")

				B.ReskinIcon(frame.Icon.Texture)
			end
			frame.glow:SetTexture("")
			frame.Background:SetTexture("")
			frame.Icon.Overlay:SetTexture("")
			-- otherwise it hides
			frame.Shield.Points:Show()
			frame.Shield.Icon:Show()
		elseif frame.queue == CriteriaAlertSystem then
			if not frame.bg then
				frame.bg = B.SetBDFrame(frame, -18, 5, 18, -1)

				frame.Icon.Bling:SetTexture("")
				frame.Icon.Overlay:SetTexture("")
				frame.Background:SetTexture("")
				frame.glow:SetTexture("")
				frame.shine:SetTexture("")
				frame.Unlocked:SetTextColor(1, 1, 1)

				B.ReskinIcon(frame.Icon.Texture)
			end
		elseif frame.queue == LootAlertSystem then
			local lootItem = frame.lootItem
			if not frame.bg then
				frame.bg = B.SetBDFrame(frame, 13, -15, -13, 13)

				lootItem.SpecRing:SetTexture("")
				lootItem.SpecIcon:SetDrawLayer("ARTWORK")
				lootItem.SpecIcon:SetPoint("TOPLEFT", lootItem.Icon, -5, 5)
				lootItem.SpecIcon.bg = B.ReskinIcon(lootItem.SpecIcon)

				B.ReskinIcon(lootItem.Icon)
			end
			frame.glow:SetTexture("")
			frame.shine:SetTexture("")
			frame.Background:SetTexture("")
			frame.PvPBackground:SetTexture("")
			frame.BGAtlas:SetTexture("")
			lootItem.IconBorder:SetTexture("")
			lootItem.SpecIcon.bg:SetShown(lootItem.SpecIcon:IsShown() and lootItem.SpecIcon:GetTexture() ~= nil)
		elseif frame.queue == LootUpgradeAlertSystem then
			if not frame.bg then
				frame.bg = B.SetBDFrame(frame, 10, -13, -12, 11)

				frame.Icon:ClearAllPoints()
				frame.Icon:SetPoint("CENTER", frame.BaseQualityBorder)
				frame.BaseQualityBorder:SetSize(52, 52)
				frame.BaseQualityBorder:SetTexture(DB.bdTex)
				frame.UpgradeQualityBorder:SetTexture(DB.bdTex)
				frame.UpgradeQualityBorder:SetSize(52, 52)
				frame.Sheen:SetTexture("")
				frame.Background:SetTexture("")
				frame.BorderGlow:SetTexture("")

				B.ReskinIcon(frame.Icon)
			end
			frame.BaseQualityBorder:SetTexture("")
			frame.UpgradeQualityBorder:SetTexture("")
		elseif frame.queue == MoneyWonAlertSystem or frame.queue == HonorAwardedAlertSystem then
			if not frame.bg then
				frame.bg = B.SetBDFrame(frame, 7, -7, -7, 7)

				frame.Background:SetTexture("")
				frame.IconBorder:SetTexture("")

				B.ReskinIcon(frame.Icon)
			end
		elseif frame.queue == NewRecipeLearnedAlertSystem then
			if not frame.bg then
				frame.bg = B.SetBDFrame(frame, 10, -5, -10, 5)

				frame:GetRegions():SetTexture("")
				frame.glow:SetTexture("")
				frame.shine:SetTexture("")

				B.CreateBDFrame(frame.Icon, 0)
			end
			frame.Icon:SetMask(nil)
			frame.Icon:SetTexCoord(unpack(DB.TexCoord))
		elseif frame.queue == WorldQuestCompleteAlertSystem then
			if not frame.bg then
				frame.bg = B.SetBDFrame(frame, 3, -9, -3, 6)

				frame.shine:SetTexture("")
				frame:DisableDrawLayer("BORDER")
				select(6, frame:GetRegions()):SetFontObject(NumberFont_GameNormal)

				B.ReskinIcon(frame.QuestTexture)
			end
		elseif frame.queue == GarrisonTalentAlertSystem then
			if not frame.bg then
				frame.bg = B.SetBDFrame(frame, 8, -8, -8, 11)

				frame:GetRegions():Hide()
				frame.glow:SetTexture("")
				frame.shine:SetTexture("")

				B.ReskinIcon(frame.Icon)
			end
		elseif frame.queue == GarrisonFollowerAlertSystem then
			if not frame.bg then
				frame.bg = B.SetBDFrame(frame, 16, -3, -16, 16)

				frame:GetRegions():Hide()
				select(5, frame:GetRegions()):Hide()
				frame.PortraitFrame:ClearAllPoints()
				frame.PortraitFrame:SetPoint("TOPLEFT", 22, -8)
				frame.glow:SetTexture("")
				frame.shine:SetTexture("")

				B.ReskinGarrisonPortrait(frame.PortraitFrame)
			end
			frame.FollowerBG:SetTexture("")
		elseif frame.queue == GarrisonMissionAlertSystem or frame.queue == GarrisonRandomMissionAlertSystem or frame.queue == GarrisonShipMissionAlertSystem or frame.queue == GarrisonShipFollowerAlertSystem then
			if not frame.bg then
				frame.bg = B.SetBDFrame(frame, 8, -8, -8, 10)

				if frame.Blank then frame.Blank:Hide() end
				if frame.IconBG then frame.IconBG:Hide() end
				frame.Background:Hide()
				frame.glow:SetTexture("")
				frame.shine:SetTexture("")
			end

			-- Anchor fix in 8.2
			if frame.Level then
				if frame.ItemLevel:IsShown() and frame.Rare:IsShown() then
					frame.Level:SetPoint("TOP", frame, "TOP", -115, -14)
					frame.ItemLevel:SetPoint("TOP", frame, "TOP", -115, -37)
					frame.Rare:SetPoint("TOP", frame, "TOP", -115, -48)
				elseif frame.Rare:IsShown() then
					frame.Level:SetPoint("TOP", frame, "TOP", -115, -19)
					frame.Rare:SetPoint("TOP", frame, "TOP", -115, -45)
				elseif frame.ItemLevel:IsShown() then
					frame.Level:SetPoint("TOP", frame, "TOP", -115, -19)
					frame.ItemLevel:SetPoint("TOP", frame, "TOP", -115, -45)
				else
					frame.Level:SetPoint("TOP", frame, "TOP", -115, -28)
				end
			end
		elseif frame.queue == GarrisonBuildingAlertSystem then
			if not frame.bg then
				frame.bg = B.SetBDFrame(frame, 9, -9, -9, 11)

				frame:GetRegions():Hide()
				frame.glow:SetTexture("")
				frame.shine:SetTexture("")

				B.ReskinIcon(frame.Icon)
			end
		elseif frame.queue == DigsiteCompleteAlertSystem then
			if not frame.bg then
				frame.bg = B.SetBDFrame(frame, 8, -8, -8, 8)

				frame:GetRegions():Hide()
				frame.glow:SetTexture("")
				frame.shine:SetTexture("")
			end
		elseif frame.queue == GuildChallengeAlertSystem then
			if not frame.bg then
				frame.bg = B.SetBDFrame(frame, 8, -12, -8, 13)

				select(2, frame:GetRegions()):SetTexture("")
				frame.glow:SetTexture("")
				frame.shine:SetTexture("")
			end
		elseif frame.queue == DungeonCompletionAlertSystem then
			if not frame.bg then
				frame.bg = B.SetBDFrame(frame, 2, -10, 0, 2)

				frame:DisableDrawLayer("Border")
				frame.heroicIcon:SetTexture("")
				frame.glowFrame.glow:SetTexture("")
				frame.shine:SetTexture("")

				B.ReskinIcon(frame.dungeonTexture)
			end
		elseif frame.queue == ScenarioAlertSystem then
			if not frame.bg then
				frame.bg = B.SetBDFrame(frame, 5, -5, -5, 5)

				select(1, frame:GetRegions()):Hide()
				select(3, frame:GetRegions()):Hide()
				frame.glowFrame.glow:SetTexture("")
				frame.shine:SetTexture("")

				B.ReskinIcon(frame.dungeonTexture)
			end
		elseif frame.queue == LegendaryItemAlertSystem then
			if not frame.bg then
				frame.bg = B.SetBDFrame(frame, 25, -22, -25, 22)

				frame:HookScript("OnUpdate", fixBg)
				frame.Icon:ClearAllPoints()
				frame.Icon:SetPoint("TOPLEFT", frame.bg, 12, -12)
				frame.Background:SetTexture("")
				frame.Background2:SetTexture("")
				frame.Background3:SetTexture("")
				frame.glow:SetTexture("")

				B.ReskinIcon(frame.Icon)
			end
		elseif frame.queue == NewPetAlertSystem or frame.queue == NewMountAlertSystem or frame.queue == NewToyAlertSystem then
			if not frame.bg then
				frame.bg = B.SetBDFrame(frame, 12, -13, -12, 10)

				frame.IconBorder:Hide()
				frame.Background:SetTexture("")
				frame.shine:SetTexture("")
				frame.glow:SetTexture("")

				B.ReskinIcon(frame.Icon)
			end
		elseif frame.queue == InvasionAlertSystem then
			if not frame.bg then
				frame.bg = B.SetBDFrame(frame, 6, -6, -6, 6)

				local bg, icon = frame:GetRegions()
				bg:Hide()

				B.ReskinIcon(icon)
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
					reward.texture:SetInside(nil, 6, 6)

					reward.bg = B.ReskinIcon(reward.texture)
				end
			end
		end
	end)

	-- BonusRollLootWonFrame
	hooksecurefunc("LootWonAlertFrame_SetUp", function(frame)
		local lootItem = frame.lootItem
		if not frame.bg then
			frame.bg = B.SetBDFrame(frame, 10, -10, -10, 10)
			fixAnim(frame)

			frame.shine:SetTexture("")
			lootItem.SpecRing:SetTexture("")
			lootItem.SpecIcon:SetDrawLayer("ARTWORK")
			lootItem.SpecIcon:SetPoint("TOPLEFT", lootItem.Icon, -5, 5)
			lootItem.SpecIcon.bg = B.ReskinIcon(lootItem.SpecIcon)
			lootItem.SpecIcon.bg:SetShown(lootItem.SpecIcon:IsShown() and lootItem.SpecIcon:GetTexture() ~= nil)

			B.ReskinIcon(lootItem.Icon)
		end

		frame.glow:SetTexture("")
		frame.Background:SetTexture("")
		frame.PvPBackground:SetTexture("")
		frame.BGAtlas:SetAlpha(0)
		lootItem.IconBorder:SetTexture("")
	end)

	-- BonusRollMoneyWonFrame
	hooksecurefunc("MoneyWonAlertFrame_SetUp", function(frame)
		if not frame.bg then
			frame.bg = B.SetBDFrame(frame, 5, -5, -5, 5)
			fixAnim(frame)

			frame.Background:SetTexture("")
			frame.IconBorder:SetTexture("")

			B.ReskinIcon(frame.Icon)
		end
	end)
end)
