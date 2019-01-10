local F, C = unpack(select(2, ...))

C.themes["Blizzard_PVPUI"] = function()
	local r, g, b = C.r, C.g, C.b

	-- Main style
	F.StripTextures(PVPQueueFrame.HonorInset, true)
	F.Reskin(HonorFrame.QueueButton)
	F.Reskin(ConquestFrame.JoinButton)
	F.ReskinDropDown(HonorFrameTypeDropDown)
	F.ReskinScroll(HonorFrameSpecificFrameScrollBar)

	-- Category buttons
	for i = 1, 3 do
		local bu = PVPQueueFrame["CategoryButton"..i]
		bu.Ring:Hide()
		F.Reskin(bu)
		F.ReskinTexture(bu.Background, true, bu)

		local icon = bu.Icon
		icon:SetPoint("LEFT", bu, "LEFT")
		icon:SetDrawLayer("OVERLAY")
		F.ReskinIcon(icon, true)

		local bg = F.CreateBG(bu.Icon)
		bg:SetDrawLayer("ARTWORK")
	end

	PVPQueueFrame.CategoryButton1.Icon:SetTexture("Interface\\Icons\\achievement_bg_winwsg")
	PVPQueueFrame.CategoryButton2.Icon:SetTexture("Interface\\Icons\\achievement_bg_killxenemies_generalsroom")
	PVPQueueFrame.CategoryButton3.Icon:SetTexture("Interface\\Icons\\ability_warrior_offensivestance")

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

	-- Role buttons
	local function styleRole(f)
		F.StripTextures(f, true)

		for _, roleButton in next, {f.HealerIcon, f.TankIcon, f.DPSIcon} do
			F.ReskinCheck(roleButton.checkButton)
		end
	end
	styleRole(HonorFrame)
	styleRole(ConquestFrame)
	styleBar(HonorFrame)
	styleBar(ConquestFrame)

	-- Honor frame
	local Inset = HonorFrame.Inset
	local BonusFrame = HonorFrame.BonusFrame
	F.StripTextures(Inset, true)
	F.StripTextures(BonusFrame, true)
	BonusFrame.ShadowOverlay:Hide()

	for _, bonusButton in next, {"RandomBGButton", "RandomEpicBGButton", "Arena1Button", "BrawlButton"} do
		local bu = BonusFrame[bonusButton]
		F.Reskin(bu)
		F.ReskinTexture(bu.SelectedTexture, true, bu)
	end

	-- Conquest Frame
	F.StripTextures(ConquestFrame.Inset, true)
	ConquestFrame.ShadowOverlay:Hide()

	if AuroraConfig.tooltips then
		F.ReskinTooltip(ConquestTooltip)
	end

	for _, conquestButton in next, {"Arena2v2", "Arena3v3", "RatedBG"} do
		local bu = ConquestFrame[conquestButton]
		F.Reskin(bu)
		F.ReskinTexture(bu.SelectedTexture, true, bu)
	end
end