local F, C = unpack(select(2, ...))

C.themes["Blizzard_PVPUI"] = function()
	local cr, cg, cb = C.r, C.g, C.b

	-- ConquestBar
	local function styleBar(self)
		F.ReskinStatusBar(self.ConquestBar)

		local cbreward = self.ConquestBar.Reward
		cbreward:ClearAllPoints()
		cbreward:SetPoint("LEFT", self.ConquestBar, "RIGHT", 2, 0)
		cbreward.CircleMask:Hide()
		cbreward.Ring:Hide()
		F.ReskinIcon(cbreward.Icon)
	end

	-- RoleButton
	local function styleRole(self)
		self:DisableDrawLayer("BACKGROUND")
		self:DisableDrawLayer("BORDER")
		F.ReskinRole(self.TankIcon, "TANK")
		F.ReskinRole(self.HealerIcon, "HEALER")
		F.ReskinRole(self.DPSIcon, "DPS")
	end

	-- PVPQueueFrame
	F.StripTextures(PVPQueueFrame.HonorInset, true)

	-- CategoryButton
	PVPQueueFrame.CategoryButton1.Icon:SetTexture("Interface\\Icons\\achievement_bg_winwsg")
	PVPQueueFrame.CategoryButton2.Icon:SetTexture("Interface\\Icons\\achievement_bg_killxenemies_generalsroom")
	PVPQueueFrame.CategoryButton3.Icon:SetTexture("Interface\\Icons\\ability_warrior_offensivestance")

	for i = 1, 3 do
		local bu = PVPQueueFrame["CategoryButton"..i]
		bu.Ring:Hide()
		F.ReskinButton(bu)
		F.ReskinTexture(bu.Background, bu, true)

		local icon = bu.Icon
		icon:SetPoint("LEFT", bu, "LEFT")
		F.ReskinIcon(icon)
	end

	hooksecurefunc("PVPQueueFrame_SelectButton", function(index)
		for i = 1, 3 do
			local button = PVPQueueFrame["CategoryButton"..i]
			--button.Background:SetShown(i == index)
			if i == index then
				button:SetBackdropColor(cr, cg, cb, .25)
			else
				button:SetBackdropColor(0, 0, 0, 0)
			end
		end
	end)

	local NewSeason = PVPQueueFrame.NewSeasonPopup
	F.ReskinButton(NewSeason.Leave)
	NewSeason.NewSeason:SetTextColor(1, .8, 0)
	NewSeason.SeasonDescription:SetTextColor(1, 1, 1)
	NewSeason.SeasonDescription2:SetTextColor(1, 1, 1)

	local SeasonRewardFrame = SeasonRewardFrame
	SeasonRewardFrame.CircleMask:Hide()
	SeasonRewardFrame.Ring:Hide()
	F.ReskinIcon(SeasonRewardFrame.Icon)
	select(3, SeasonRewardFrame:GetRegions()):SetTextColor(1, .8, 0)
	-- HonorFrame
	local BonusFrame = HonorFrame.BonusFrame
	F.StripTextures(HonorFrame, true)
	F.StripTextures(BonusFrame, true)
	F.ReskinButton(HonorFrame.QueueButton)
	F.ReskinDropDown(HonorFrameTypeDropDown)
	F.ReskinScroll(HonorFrameSpecificFrameScrollBar)

	styleBar(HonorFrame)
	styleRole(HonorFrame)

	for _, bonusButton in next, {"RandomBGButton", "RandomEpicBGButton", "Arena1Button", "BrawlButton"} do
		local bu = BonusFrame[bonusButton]
		F.ReskinButton(bu)
		F.ReskinTexture(bu.SelectedTexture, bu, true)
	end

	for i = 1, 8 do
		local bu = _G["HonorFrameSpecificFrameButton"..i]
		bu.Bg:Hide()
		bu.Border:Hide()

		local ic = F.ReskinIcon(bu.Icon)

		local bg = F.CreateBDFrame(bu, 0)
		bg:SetPoint("TOPLEFT", ic, "TOPRIGHT", 2, 0)
		bg:SetPoint("BOTTOMRIGHT", -2, 3.5)
		F.ReskinTexture(bu.HighlightTexture, bg, true)
		F.ReskinTexture(bu.SelectedTexture, bg, true)

		local nt = bu.NameText
		nt:ClearAllPoints()
		nt:SetPoint("LEFT", bg, 2, 0)

		local st = bu.SizeText
		st:ClearAllPoints()
		st:SetPoint("TOPRIGHT", bg, -1, -2)

		local it = bu.InfoText
		it:ClearAllPoints()
		it:SetPoint("BOTTOMRIGHT", bg, -1, 3)
	end

	-- ConquestFrame
	F.StripTextures(ConquestFrame, true)
	F.ReskinButton(ConquestFrame.JoinButton)

	styleBar(ConquestFrame)
	styleRole(ConquestFrame)

	for _, conquestButton in next, {"Arena2v2", "Arena3v3", "RatedBG"} do
		local bu = ConquestFrame[conquestButton]
		F.ReskinButton(bu)
		F.ReskinTexture(bu.SelectedTexture, bu, true)
	end

	if AuroraConfig.tooltips then
		F.ReskinTooltip(ConquestTooltip)
	end
end