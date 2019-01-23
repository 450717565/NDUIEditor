local F, C = unpack(select(2, ...))

C.themes["Blizzard_PVPUI"] = function()
	-- ConquestBar
	local function styleBar(f)
		F.ReskinStatusBar(f.ConquestBar, true, true)

		local cbreward = f.ConquestBar.Reward
		cbreward:ClearAllPoints()
		cbreward:SetPoint("LEFT", f.ConquestBar, "RIGHT", 2, 0)
		cbreward.CircleMask:Hide()
		cbreward.Ring:Hide()
		F.ReskinIcon(cbreward.Icon, true)
	end

	-- RoleButton
	local function styleRole(f)
		for _, roleButton in next, {f.HealerIcon, f.TankIcon, f.DPSIcon} do
			F.ReskinCheck(roleButton.checkButton)
		end
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
		icon:SetDrawLayer("OVERLAY")
		F.ReskinIcon(icon, true)

		local bg = F.CreateBG(bu.Icon)
		bg:SetDrawLayer("ARTWORK")
	end

	hooksecurefunc("PVPQueueFrame_SelectButton", function(index)
		for i = 1, 3 do
			local button = PVPQueueFrame["CategoryButton"..i]
			button.Background:SetShown(i == index)
		end
	end)

	-- HonorFrame
	local BonusFrame = HonorFrame.BonusFrame
	F.StripTextures(HonorFrame, true)
	F.StripTextures(BonusFrame, true)
	F.ReskinButton(HonorFrame.QueueButton)
	F.ReskinDropDown(HonorFrameTypeDropDown)

	styleBar(HonorFrame)
	styleRole(HonorFrame)

	for _, bonusButton in next, {"RandomBGButton", "RandomEpicBGButton", "Arena1Button", "BrawlButton"} do
		local bu = BonusFrame[bonusButton]
		F.ReskinButton(bu)
		F.ReskinTexture(bu.SelectedTexture, bu, true)
	end

	local styled = false
	HonorFrameSpecificFrame:HookScript("OnShow", function()
		if not styled then
			F.ReskinScroll(HonorFrameSpecificFrameScrollBar)

			for i = 1, 8 do
				local bu = _G["HonorFrameSpecificFrameButton"..i]
				bu.Bg:Hide()
				bu.Border:Hide()

				local ic = F.ReskinIcon(bu.Icon, true)

				local bg = F.CreateBDFrame(bu, .25)
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

			styled = true
		end
	end)

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