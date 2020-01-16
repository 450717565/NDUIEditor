local F, C = unpack(select(2, ...))

C.themes["Blizzard_PVPUI"] = function()
	if AuroraConfig.tooltips then
		F.ReskinTooltip(ConquestTooltip)
	end

	local cr, cg, cb = C.r, C.g, C.b

	-- CategoryButton
	for i = 1, 3 do
		local bu = PVPQueueFrame["CategoryButton"..i]
		F.StripTextures(bu)
		F.ReskinButton(bu)

		local icon = bu.Icon
		icon:ClearAllPoints()
		icon:SetPoint("LEFT", bu, "LEFT")
		F.ReskinIcon(icon)
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
	F.StripTextures(PVPQueueFrame.HonorInset)

	local NewSeason = PVPQueueFrame.NewSeasonPopup
	F.ReskinButton(NewSeason.Leave)
	NewSeason.NewSeason:SetTextColor(1, .8, 0)
	NewSeason.SeasonDescription:SetTextColor(1, 1, 1)
	NewSeason.SeasonDescription2:SetTextColor(1, 1, 1)

	local frames = {NewSeason.SeasonRewardFrame, PVPQueueFrame.HonorInset.RatedPanel.SeasonRewardFrame}
	for _, frame in pairs(frames) do
		frame.Ring:Hide()
		frame.CircleMask:Hide()
		F.ReskinIcon(frame.Icon)
	end

	-- HonorFrame
	F.StripTextures(HonorFrame)
	F.ReskinButton(HonorFrame.QueueButton)
	F.ReskinDropDown(HonorFrameTypeDropDown)
	F.ReskinScroll(HonorFrameSpecificFrameScrollBar)
	F.ReskinClose(PremadeGroupsPvPTutorialAlert.CloseButton)

	local BonusFrame = HonorFrame.BonusFrame
	F.StripTextures(BonusFrame)

	for _, bonusButton in pairs({"RandomBGButton", "RandomEpicBGButton", "Arena1Button", "BrawlButton", "SpecialEventButton"}) do
		local bu = BonusFrame[bonusButton]
		F.ReskinButton(bu)
		F.ReskinTexture(bu.SelectedTexture, bu, true)
	end

	for i = 1, 8 do
		local bu = _G["HonorFrameSpecificFrameButton"..i]
		bu.Bg:Hide()
		bu.Border:Hide()

		local icbg = F.ReskinIcon(bu.Icon)
		local bubg = F.CreateBDFrame(bu, 0)
		bubg:SetPoint("TOPLEFT", icbg, "TOPRIGHT", 2, 0)
		bubg:SetPoint("BOTTOMRIGHT", -2, 4)
		F.ReskinTexture(bu.HighlightTexture, bubg, true)
		F.ReskinTexture(bu.SelectedTexture, bubg, true)

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
	F.StripTextures(ConquestFrame)
	F.ReskinButton(ConquestFrame.JoinButton)

	for _, conquestButton in pairs({"Arena2v2", "Arena3v3", "RatedBG"}) do
		local bu = ConquestFrame[conquestButton]
		F.ReskinButton(bu)
		F.ReskinTexture(bu.SelectedTexture, bu, true)
	end

	-- reskin bar and role
	for _, frame in pairs({HonorFrame, ConquestFrame}) do
		F.ReskinRole(frame.TankIcon, "TANK")
		F.ReskinRole(frame.HealerIcon, "HEALER")
		F.ReskinRole(frame.DPSIcon, "DPS")
		F.ReskinStatusBar(frame.ConquestBar)

		local Reward = frame.ConquestBar.Reward
		Reward:ClearAllPoints()
		Reward:SetPoint("LEFT", frame.ConquestBar, "RIGHT", 2, 0)
		Reward.CircleMask:Hide()
		Reward.Ring:Hide()
		F.ReskinIcon(Reward.Icon)

		hooksecurefunc(frame.ConquestBar, "Update", function(self)
			self.Reward:SetShown(IsPlayerAtEffectiveMaxLevel())
		end)
	end
end