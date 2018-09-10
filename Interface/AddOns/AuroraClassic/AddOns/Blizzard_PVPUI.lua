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
		local icon = bu.Icon
		local cu = bu.CurrencyDisplay

		bu.Ring:Hide()
		bu.Background:SetAllPoints()
		bu.Background:SetColorTexture(r, g, b, .25)
		bu.Background:Hide()

		F.Reskin(bu, true)

		icon:SetTexCoord(.08, .92, .08, .92)
		icon:SetPoint("LEFT", bu, "LEFT")
		icon:SetDrawLayer("OVERLAY")
		F.CreateBDFrame(icon)

		local bg = F.CreateBG(icon)
		bg:SetDrawLayer("ARTWORK")

		if cu then
			local ic = cu.Icon

			ic:SetSize(16, 16)
			ic:SetPoint("TOPLEFT", bu.Name, "BOTTOMLEFT", 0, -8)
			cu.Amount:SetPoint("LEFT", ic, "RIGHT", 4, 0)

			ic:SetTexCoord(.08, .92, .08, .92)
			local bg = F.CreateBG(ic)
			bg:SetDrawLayer("BACKGROUND", 1)
		end
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
		cbreward.Icon:SetTexCoord(.08, .92, .08, .92)
		F.CreateBDFrame(cbreward.Icon, .25)
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
		bu.SelectedTexture:SetDrawLayer("BACKGROUND")
		bu.SelectedTexture:SetColorTexture(r, g, b, .25)
		bu.SelectedTexture:SetAllPoints()
	end

	-- Honor frame specific
	--[[
	for _, bu in pairs(HonorFrame.SpecificFrame.buttons) do
		bu.Bg:Hide()
		bu.Border:Hide()

		bu:SetNormalTexture("")
		bu:SetHighlightTexture("")

		local bg = CreateFrame("Frame", nil, bu)
		bg:SetPoint("TOPLEFT", 2, 0)
		bg:SetPoint("BOTTOMRIGHT", -1, 2)
		F.CreateBD(bg, 0)
		F.CreateSD(bg)
		bg:SetFrameLevel(bu:GetFrameLevel()-1)

		bu.tex = F.CreateGradient(bu)
		bu.tex:SetDrawLayer("BACKGROUND")
		bu.tex:SetPoint("TOPLEFT", bg, 1, -1)
		bu.tex:SetPoint("BOTTOMRIGHT", bg, -1, 1)

		bu.SelectedTexture:SetDrawLayer("BACKGROUND")
		bu.SelectedTexture:SetColorTexture(r, g, b, .25)
		bu.SelectedTexture:SetAllPoints(bu.tex)

		bu.Icon:SetTexCoord(.08, .92, .08, .92)
		F.CreateBDFrame(bu.Icon)
		bu.Icon.bg = F.CreateBG(bu.Icon)
		bu.Icon.bg:SetDrawLayer("BACKGROUND", 1)
		bu.Icon:SetPoint("TOPLEFT", 5, -3)

		bu.SizeText:ClearAllPoints()
		bu.SizeText:SetPoint("TOPRIGHT", -5, -5)
		bu.InfoText:ClearAllPoints()
		bu.InfoText:SetPoint("BOTTOMRIGHT", -5, 5)
	end
]]
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
		bu.SelectedTexture:SetDrawLayer("BACKGROUND")
		bu.SelectedTexture:SetColorTexture(r, g, b, .25)
		bu.SelectedTexture:SetAllPoints()
	end
end