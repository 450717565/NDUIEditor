local B, C, L, DB = unpack(select(2, ...))

C.themes["Blizzard_PVPUI"] = function()
	local cr, cg, cb = DB.r, DB.g, DB.b

	local function reskinButtons(self)
		B.ReskinButton(self)
		B.ReskinHighlight(self.SelectedTexture, self, true)

		local Reward = self.Reward
		if Reward then
			Reward.Border:Hide()
			Reward.CircleMask:Hide()
			Reward.icbg = B.ReskinIcon(Reward.Icon)

			local Bonus = Reward.EnlistmentBonus
			if Bonus then
				Bonus:DisableDrawLayer("ARTWORK")
				Bonus.Icon:SetTexture(GetSpellTexture(241260))
				Bonus.icbg = B.ReskinIcon(Bonus.Icon)
				Bonus.icbg:SetFrameLevel(Bonus:GetFrameLevel())
			end
		end
	end

	-- CategoryButton
	for i = 1, 3 do
		local bu = PVPQueueFrame["CategoryButton"..i]
		B.StripTextures(bu)
		B.ReskinButton(bu)

		local icon = bu.Icon
		icon:ClearAllPoints()
		icon:SetPoint("LEFT", bu, "LEFT")
		B.ReskinIcon(icon)
	end

	hooksecurefunc("PVPQueueFrame_SelectButton", function(index)
		for i = 1, 3 do
			local button = PVPQueueFrame["CategoryButton"..i]
			if i == index then
				button:SetBackdropColor(cr, cg, cb, .25)
			else
				button:SetBackdropColor(0, 0, 0, 0)
			end
		end
	end)

	PVPQueueFrame.CategoryButton1.Icon:SetTexture("Interface\\Icons\\achievement_bg_winwsg")
	PVPQueueFrame.CategoryButton2.Icon:SetTexture("Interface\\Icons\\achievement_bg_killxenemies_generalsroom")
	PVPQueueFrame.CategoryButton3.Icon:SetTexture("Interface\\Icons\\INV_Misc_GroupNeedMore")

	-- PVPQueueFrame
	B.StripTextures(PVPQueueFrame.HonorInset)

	local NewSeason = PVPQueueFrame.NewSeasonPopup
	B.ReskinButton(NewSeason.Leave)
	NewSeason.NewSeason:SetTextColor(1, .8, 0)
	NewSeason.SeasonDescription:SetTextColor(1, 1, 1)
	NewSeason.SeasonDescription2:SetTextColor(1, 1, 1)

	local frames = {NewSeason.SeasonRewardFrame, PVPQueueFrame.HonorInset.RatedPanel.SeasonRewardFrame}
	for _, frame in pairs(frames) do
		frame.Ring:Hide()
		frame.CircleMask:Hide()
		B.ReskinIcon(frame.Icon)
	end

	-- HonorFrame
	B.StripTextures(HonorFrame)
	B.ReskinButton(HonorFrame.QueueButton)
	B.ReskinDropDown(HonorFrameTypeDropDown)
	B.ReskinScroll(HonorFrameSpecificFrameScrollBar)
	B.ReskinClose(PremadeGroupsPvPTutorialAlert.CloseButton)

	local BonusFrame = HonorFrame.BonusFrame
	B.StripTextures(BonusFrame)

	for _, bonusButton in pairs({"RandomBGButton", "RandomEpicBGButton", "Arena1Button", "BrawlButton", "SpecialEventButton"}) do
		reskinButtons(BonusFrame[bonusButton])
	end

	for i = 1, 9 do
		local bu = _G["HonorFrameSpecificFrameButton"..i]
		bu.Bg:Hide()
		bu.Border:Hide()

		local icbg = B.ReskinIcon(bu.Icon)
		local bubg = B.CreateBGFrame(bu, 2, 0, -2, 0, icbg)
		B.ReskinHighlight(bu.HighlightTexture, bubg, true)
		B.ReskinHighlight(bu.SelectedTexture, bubg, true)

		local name = bu.NameText
		name:ClearAllPoints()
		name:SetPoint("LEFT", bubg, 2, 0)

		local size = bu.SizeText
		size:ClearAllPoints()
		size:SetPoint("TOPRIGHT", bubg, -1, -2)

		local info = bu.InfoText
		info:ClearAllPoints()
		info:SetPoint("BOTTOMRIGHT", bubg, -1, 3)
	end

	-- ConquestFrame
	B.StripTextures(ConquestFrame)
	B.ReskinButton(ConquestFrame.JoinButton)

	for _, conquestButton in pairs({"Arena2v2", "Arena3v3", "RatedBG"}) do
		reskinButtons(ConquestFrame[conquestButton])
	end

	-- reskin bar and role
	for _, frame in pairs({HonorFrame, ConquestFrame}) do
		B.ReskinRole(frame.TankIcon, "TANK")
		B.ReskinRole(frame.HealerIcon, "HEALER")
		B.ReskinRole(frame.DPSIcon, "DPS")
		B.ReskinStatusBar(frame.ConquestBar)

		local Reward = frame.ConquestBar.Reward
		Reward:ClearAllPoints()
		Reward:SetPoint("LEFT", frame.ConquestBar, "RIGHT", 2, 0)
		Reward.CircleMask:Hide()
		Reward.Ring:Hide()
		B.ReskinIcon(Reward.Icon)

		hooksecurefunc(frame.ConquestBar, "Update", function(self)
			self.Reward:SetShown(IsPlayerAtEffectiveMaxLevel())
		end)
	end

	-- Item Borders for HonorFrame & ConquestFrame
	hooksecurefunc("PVPUIFrame_ConfigureRewardFrame", function(rewardFrame, _, _, itemRewards, currencyRewards)
		local rewardTexture, rewardQuaility, _ = nil, 1

		if currencyRewards then
			for _, reward in pairs(currencyRewards) do
				local name, _, texture, _, _, _, _, quality = GetCurrencyInfo(reward.id)
				if quality == _G.LE_ITEM_QUALITY_ARTIFACT then
					_, rewardTexture, _, rewardQuaility = CurrencyContainerUtil.GetCurrencyContainerInfo(reward.id, reward.quantity, name, texture, quality)
				end
			end
		end

		if not rewardTexture and itemRewards then
			local reward = itemRewards[1]
			if reward then
				_, _, rewardQuaility, _, _, _, _, _, _, rewardTexture = GetItemInfo(reward.id)
			end
		end

		if rewardTexture then
			rewardFrame.Icon:SetTexture(rewardTexture)
			local r, g, b = GetItemQualityColor(rewardQuaility or 1)
			rewardFrame.icbg:SetBackdropBorderColor(r, g, b)
		end
	end)
end