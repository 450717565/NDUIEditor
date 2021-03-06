local _, ns = ...
local B, C, L, DB = unpack(ns)

local cr, cg, cb = DB.cr, DB.cg, DB.cb

local function Reskin_SelectButton(index)
	for i = 1, 3 do
		local button = PVPQueueFrame["CategoryButton"..i]
		button.Background:SetShown(i == index)
	end
end

local function Reskin_Reward(self)
	B.ReskinButton(self)
	B.ReskinHLTex(self.SelectedTexture, self, true)

	local Reward = self.Reward
	if Reward then
		B.CleanTextures(Reward)
		Reward.icbg = B.ReskinIcon(Reward.Icon)

		local Bonus = Reward.EnlistmentBonus
		if Bonus then
			Bonus:DisableDrawLayer("ARTWORK")
			Bonus.Icon:SetTexture(413584)
			Bonus.Icon:SetDrawLayer("OVERLAY")
			Bonus.icbg = B.ReskinIcon(Bonus.Icon)
			Bonus.icbg:SetFrameLevel(Bonus:GetFrameLevel())
		end
	end
end

local function Reskin_ConquestBar(self)
	self.Reward:SetShown(IsPlayerAtEffectiveMaxLevel())
end

local function Reskin_ConfigureRewardFrame(rewardFrame, honor, experience, itemRewards, currencyRewards)
	local currencyID, rewardTexture, rewardQuaility

	if currencyRewards then
		for _, reward in pairs(currencyRewards) do
			if reward.id ~= Constants.CurrencyConsts.ECHOES_OF_NYALOTHA_CURRENCY_ID or #currencyRewards == 1 then
				local currencyInfo = C_CurrencyInfo.GetCurrencyInfo(reward.id)
				local name, texture, quality = currencyInfo.name, currencyInfo.iconFileID, currencyInfo.quality
				if quality == _G.LE_ITEM_QUALITY_ARTIFACT then
					_, rewardTexture, _, rewardQuaility = CurrencyContainerUtil.GetCurrencyContainerInfo(reward.id, reward.quantity, name, texture, quality)
					currencyID = reward.id
				elseif reward.id == Constants.CurrencyConsts.CONQUEST_CURRENCY_ID then
					rewardTexture = texture
				end
			end
		end
	end

	if not currencyID and itemRewards then
		local reward = itemRewards[1]
		if reward then
			_, _, rewardQuaility, _, _, _, _, _, _, rewardTexture = GetItemInfo(reward.id)
		end
	end

	if rewardTexture then
		rewardFrame.Icon:SetTexture(rewardTexture)
		local r, g, b = B.GetQualityColor(rewardQuaility)
		rewardFrame.icbg:SetBackdropBorderColor(r, g, b)
	end
end

C.OnLoadThemes["Blizzard_PVPUI"] = function()
	-- CategoryButton
	for i = 1, 3 do
		local button = PVPQueueFrame["CategoryButton"..i]
		B.StripTextures(button)
		B.ReskinButton(button)
		B.ReskinHLTex(button.Background, button.bgTex, true)

		local icon = button.Icon
		B.UpdatePoint(icon, "LEFT", button, "LEFT")

		local icbg = B.ReskinIcon(icon)
		icbg:SetFrameLevel(button:GetFrameLevel())
	end

	PVPQueueFrame.CategoryButton1.Icon:SetTexture("Interface\\Icons\\achievement_bg_winwsg")
	PVPQueueFrame.CategoryButton2.Icon:SetTexture("Interface\\Icons\\achievement_bg_killxenemies_generalsroom")
	PVPQueueFrame.CategoryButton3.Icon:SetTexture("Interface\\Icons\\INV_Misc_GroupNeedMore")

	hooksecurefunc("PVPQueueFrame_SelectButton", Reskin_SelectButton)

	-- PVPQueueFrame
	B.StripTextures(PVPQueueFrame.HonorInset)

	local season = PVPQueueFrame.NewSeasonPopup
	B.ReskinButton(season.Leave)
	B.ReskinText(season.NewSeason, 1, .8, 0)
	B.ReskinText(season.SeasonRewardText, 1, .8, 0)
	B.ReskinText(season.SeasonDescriptionHeader, 1, 1, 1)
	season:HookScript("OnShow", function(self)
		for _, description in pairs(self.SeasonDescriptions) do
			B.ReskinText(description, 1, 1, 1)
		end
	end)

	local frames = {
		season.SeasonRewardFrame,
		PVPQueueFrame.HonorInset.RatedPanel.SeasonRewardFrame,
	}
	for _, frame in pairs(frames) do
		B.CleanTextures(frame)
		local icbg = B.ReskinIcon(frame.Icon)
		icbg:SetFrameLevel(frame:GetFrameLevel())
	end

	-- HonorFrame
	B.StripTextures(HonorFrame)
	B.ReskinButton(HonorFrame.QueueButton)
	B.ReskinDropDown(HonorFrameTypeDropDown)
	B.ReskinScroll(HonorFrameSpecificFrameScrollBar)

	local BonusFrame = HonorFrame.BonusFrame
	B.StripTextures(BonusFrame)

	local buttons = {
		"RandomBGButton",
		"RandomEpicBGButton",
		"Arena1Button",
		"BrawlButton",
		"SpecialEventButton",
	}
	for _, button in pairs(buttons) do
		Reskin_Reward(BonusFrame[button])
	end

	for _, button in pairs(HonorFrame.SpecificFrame.buttons) do
		B.CleanTextures(button)

		local icbg = B.ReskinIcon(button.Icon)
		local bubg = B.CreateBGFrame(button, C.margin, 0, -2, 0, icbg)
		B.ReskinHLTex(button.HighlightTexture, bubg, true)
		B.ReskinHLTex(button.SelectedTexture, bubg, true)

		local name = button.NameText
		B.UpdatePoint(name, "LEFT", bubg, "LEFT", 2, 0)

		local size = button.SizeText
		B.UpdatePoint(size, "TOPRIGHT", bubg, "TOPRIGHT", -1, -2)

		local info = button.InfoText
		B.UpdatePoint(info, "BOTTOMRIGHT", bubg, "BOTTOMRIGHT", -1, 3)
	end

	-- ConquestFrame
	B.StripTextures(ConquestFrame)
	B.ReskinButton(ConquestFrame.JoinButton)

	local arenas = {
		"Arena2v2",
		"Arena3v3",
		"RatedBG",
	}
	for _, arena in pairs(arenas) do
		Reskin_Reward(ConquestFrame[arena])
	end

	-- Reskin bar and role
	local frames = {HonorFrame, ConquestFrame}
	for _, frame in pairs(frames) do
		B.ReskinRole(frame.TankIcon, "TANK")
		B.ReskinRole(frame.HealerIcon, "HEALER")
		B.ReskinRole(frame.DPSIcon, "DPS")
		B.ReskinStatusBar(frame.ConquestBar)

		local Reward = frame.ConquestBar.Reward
		B.UpdatePoint(Reward, "LEFT", frame.ConquestBar, "RIGHT", 2, 0)
		B.CleanTextures(Reward)
		B.ReskinIcon(Reward.Icon)

		hooksecurefunc(frame.ConquestBar, "Update", Reskin_ConquestBar)
	end

	-- Item Borders for HonorFrame & ConquestFrame
	hooksecurefunc("PVPUIFrame_ConfigureRewardFrame", Reskin_ConfigureRewardFrame)
end