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
		F.Reskin(bu, true)
		F.ReskinTexture(bu.Background, true, bu)

		local icon = bu.Icon
		icon:SetPoint("LEFT", bu, "LEFT")
		icon:SetDrawLayer("OVERLAY")
		F.ReskinIcon(icon, true)
	end

	PVPQueueFrame.CategoryButton1.Icon:SetTexture("Interface\\Icons\\achievement_bg_winwsg")
	PVPQueueFrame.CategoryButton2.Icon:SetTexture("Interface\\Icons\\achievement_bg_killxenemies_generalsroom")
	PVPQueueFrame.CategoryButton3.Icon:SetTexture("Interface\\Icons\\ability_warrior_offensivestance")

	hooksecurefunc("PVPQueueFrame_SelectButton", function(index)
		local self = PVPQueueFrame
		for i = 1, 3 do
			local bu = self["CategoryButton"..i]
			if i == index then
				bu.Background:Show()
			else
				bu.Background:Hide()
			end
		end
	end)

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

		F.Reskin(bu, true)
		F.ReskinTexture(bu.SelectedTexture, true, bu)
	end

	-- Conquest Frame
	F.StripTextures(ConquestFrame.Inset, true)
	ConquestFrame.ShadowOverlay:Hide()

	if AuroraConfig.tooltips then
		F.CreateBD(ConquestTooltip)
		F.CreateSD(ConquestTooltip)
	end

	local ConquestFrameButton_OnEnter = function(self)
		ConquestTooltip:SetPoint("TOPLEFT", self, "TOPRIGHT", 1, 0)
	end

	ConquestFrame.Arena2v2:HookScript("OnEnter", ConquestFrameButton_OnEnter)
	ConquestFrame.Arena3v3:HookScript("OnEnter", ConquestFrameButton_OnEnter)
	ConquestFrame.RatedBG:HookScript("OnEnter", ConquestFrameButton_OnEnter)

	for _, bu in next, {ConquestFrame.Arena2v2, ConquestFrame.Arena3v3, ConquestFrame.RatedBG} do
		F.Reskin(bu, true)
		F.ReskinTexture(bu.SelectedTexture, true, bu)
	end
end