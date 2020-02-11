local B, C, L, DB = unpack(select(2, ...))

C.themes["Blizzard_PVPUI"] = function()
	local cr, cg, cb = DB.r, DB.g, DB.b

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
		local bu = BonusFrame[bonusButton]
		B.ReskinButton(bu)
		B.ReskinTexture(bu.SelectedTexture, bu, true)
	end

	for i = 1, 8 do
		local bu = _G["HonorFrameSpecificFrameButton"..i]
		bu.Bg:Hide()
		bu.Border:Hide()

		local icbg = B.ReskinIcon(bu.Icon)
		local bubg = B.CreateBDFrame(bu, 0)
		bubg:SetPoint("TOPLEFT", icbg, "TOPRIGHT", 2, 0)
		bubg:SetPoint("BOTTOMRIGHT", -2, 4)
		B.ReskinTexture(bu.HighlightTexture, bubg, true)
		B.ReskinTexture(bu.SelectedTexture, bubg, true)

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
		local bu = ConquestFrame[conquestButton]
		B.ReskinButton(bu)
		B.ReskinTexture(bu.SelectedTexture, bu, true)
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
end