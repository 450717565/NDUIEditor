local _, ns = ...
local B, C, L, DB = unpack(ns)

local cr, cg, cb = DB.cr, DB.cg, DB.cb
local tL, tR, tT, tB = unpack(DB.TexCoord)

local function Reskin_UpdatePetType(self)
	if self.PetType and self.typeIcon then
		local petType = C_PetBattles.GetPetType(self.petOwner, self.petIndex)
		self.typeIcon:SetTexture("Interface\\ICONS\\Icon_PetFamily_"..PET_TYPE_SUFFIX[petType])
	end
end

local function Reskin_UpdateDisplay(self)
	if not self.petOwner or self.petIndex > C_PetBattles.GetNumPets(self.petOwner) then return end

	if self.glow then self.glow:Hide() end

	if self.Icon then
		if self.petOwner == LE_BATTLE_PET_ALLY then
			self.Icon:SetTexCoord(.92, .08, .08, .92)
		else
			self.Icon:SetTexCoord(.08, .92, .08, .92)
		end
	end

	if self.Icon.icbg then
		local quality = C_PetBattles.GetBreedQuality(self.petOwner, self.petIndex) - 1 or 1
		local r, g, b = GetItemQualityColor(quality or 1)
		self.Icon.icbg:SetBackdropBorderColor(r, g, b)
	end
end

local function Reskin_UpdateHealthInstant(self)
	if self.BorderDead and self.deadIcon then
		self.deadIcon:SetShown(self.BorderDead:IsShown())
		self.healthBg:SetShown(not self.BorderDead:IsShown())
	end
end

local function Reskin_UpdateAuraHolder(self)
	if not self.petOwner or not self.petIndex then return end

	local nextFrame = 1
	for i = 1, C_PetBattles.GetNumAuras(self.petOwner, self.petIndex) do
		local isBuff = select(4, C_PetBattles.GetAuraInfo(self.petOwner, self.petIndex, i))
		if (isBuff and self.displayBuffs) or (not isBuff and self.displayDebuffs) then
			local frame = self.frames[nextFrame]

			if not frame.styled then
				local icbg = B.ReskinIcon(frame.Icon)
				B.ReskinBGBorder(frame.DebuffBorder, icbg)

				frame.styled = true
			end

			nextFrame = nextFrame + 1
		end
	end
end

local function Reskin_UpdateActionBarLayout(self)
	local BottomFrame = self.BottomFrame
	local buttonList = {
		BottomFrame.abilityButtons[1],
		BottomFrame.abilityButtons[2],
		BottomFrame.abilityButtons[3],
		BottomFrame.SwitchPetButton,
		BottomFrame.CatchButton,
		BottomFrame.ForfeitButton,
	}

	for i = 1, 6 do
		local button = buttonList[i]
		B.CleanTextures(button)

		button:SetParent(PetBattleFrame.bar)
		button:SetSize(40, 40)
		button:ClearAllPoints()

		if i == 1 then
			button:SetPoint("LEFT", PetBattleFrame.bar, 0, 0)
		else
			button:SetPoint("LEFT", buttonList[i-1], "RIGHT", 5, 0)
		end

		if not button.styled then
			local icbg = B.ReskinIcon(button.Icon)
			B.ReskinHLTex(button, icbg)

			button.CooldownShadow:SetInside(icbg)
			button.SelectedHighlight:SetOutside(icbg, 16, 16)
			button.Cooldown:SetFont(DB.Font[1], 26, DB.Font[3])

			button.styled = true
		end
	end
	buttonList[4]:GetCheckedTexture():SetColorTexture(cr, cg, cb, .25)
end

local function Reskin_UpdatePassButtonAndTimer(self)
	local BottomFrame = self.BottomFrame
	local TurnTimer = BottomFrame.TurnTimer

	TurnTimer.SkipButton:ClearAllPoints()
	TurnTimer.SkipButton:SetPoint("LEFT", BottomFrame.ForfeitButton, "RIGHT", 5, 0)

	local pveBattle = C_PetBattles.IsPlayerNPC(LE_BATTLE_PET_ENEMY)
	TurnTimer.bg:SetShown(not pveBattle)

	PetBattleFrameXPBar:ClearAllPoints()
	if pveBattle then
		PetBattleFrameXPBar:SetPoint("BOTTOM", PetBattleFrame.bar, "TOP", 0, 10)
	else
		PetBattleFrameXPBar:SetPoint("BOTTOM", TurnTimer, "TOP", 0, 5)
	end
end

tinsert(C.XMLThemes, function()
	local color = C.db["Skins"]["LineColor"]
	if not C.db["Skins"]["ClassLine"] then cr, cg, cb = color.r, color.g, color.b end

	-- Top Frame
	local frame = PetBattleFrame
	B.StripTextures(frame)

	frame.TopVersusText:ClearAllPoints()
	frame.TopVersusText:SetPoint("TOP", 0, -90)

	frame.ActiveAlly:ClearAllPoints()
	frame.ActiveAlly:SetPoint("TOP", -350, -50)
	frame.AllyBuffFrame:ClearAllPoints()
	frame.AllyBuffFrame:SetPoint("TOPLEFT", frame.ActiveAlly, "BOTTOMLEFT", 0, -5)
	frame.AllyDebuffFrame:ClearAllPoints()
	frame.AllyDebuffFrame:SetPoint("TOPLEFT", frame.AllyBuffFrame, "BOTTOMLEFT", 0, -5)
	frame.AllyPadBuffFrame:ClearAllPoints()
	frame.AllyPadBuffFrame:SetPoint("TOPRIGHT", frame.ActiveAlly, "BOTTOMLEFT", 0, -5)
	frame.AllyPadDebuffFrame:ClearAllPoints()
	frame.AllyPadDebuffFrame:SetPoint("TOPRIGHT", frame.EnemyPadBuffFrame, "BOTTOMRIGHT", 0, -5)

	frame.ActiveEnemy:ClearAllPoints()
	frame.ActiveEnemy:SetPoint("TOP", 350, -50)
	frame.EnemyBuffFrame:ClearAllPoints()
	frame.EnemyBuffFrame:SetPoint("TOPRIGHT", frame.ActiveEnemy, "BOTTOMRIGHT", 0, -5)
	frame.EnemyDebuffFrame:ClearAllPoints()
	frame.EnemyDebuffFrame:SetPoint("TOPRIGHT", frame.EnemyBuffFrame, "BOTTOMRIGHT", 0, -5)
	frame.EnemyPadBuffFrame:ClearAllPoints()
	frame.EnemyPadBuffFrame:SetPoint("TOPLEFT", frame.ActiveEnemy, "BOTTOMRIGHT", 0, -5)
	frame.EnemyPadDebuffFrame:ClearAllPoints()
	frame.EnemyPadDebuffFrame:SetPoint("TOPLEFT", frame.EnemyPadBuffFrame, "BOTTOMLEFT", 0, -5)

	-- Weather
	local WeatherFrame = frame.WeatherFrame
	B.StripTextures(frame)

	WeatherFrame.Label:Hide()
	WeatherFrame.Name:Hide()
	WeatherFrame:ClearAllPoints()
	WeatherFrame:SetPoint("TOP", frame.TopVersusText, "BOTTOM", 0, -15)
	WeatherFrame.Duration:ClearAllPoints()
	WeatherFrame.Duration:SetPoint("CENTER", WeatherFrame.Icon, 1, 0)
	WeatherFrame.Icon:ClearAllPoints()
	WeatherFrame.Icon:SetPoint("TOP", frame.TopVersusText, "BOTTOM", 0, -15)
	B.ReskinIcon(WeatherFrame.Icon)

	-- Current Pets
	local units = {
		frame.ActiveAlly,
		frame.ActiveEnemy,
	}
	for index, unit in pairs(units) do
		B.StripTextures(unit)

		unit.healthBarWidth = 250
		unit.ActualHealthBar:SetTexture(DB.normTex)
		unit.ActualHealthBar:ClearAllPoints()
		unit.healthBg = B.CreateBDFrame(unit.ActualHealthBar)
		unit.healthBg:SetWidth(250+C.mult*2)
		unit.healthBg:ClearAllPoints()

		unit.HealthText:ClearAllPoints()
		unit.HealthText:SetPoint("CENTER", unit.healthBg)

		unit.typeIcon = unit:CreateTexture(nil, "ARTWORK")
		unit.typeIcon:SetSize(24, 24)
		unit.typeIcon:ClearAllPoints()
		B.ReskinIcon(unit.typeIcon)

		unit.PetType:SetAlpha(0)
		unit.PetType:ClearAllPoints()
		unit.PetType:SetAllPoints(unit.typeIcon)

		unit.Level:SetFontObject(SystemFont_Shadow_Huge1)
		unit.Level:ClearAllPoints()

		unit.Name:ClearAllPoints()

		unit.Icon.icbg = B.ReskinIcon(unit.Icon)

		if unit.SpeedIcon then
			unit.SpeedIcon:SetSize(30, 30)
			unit.SpeedIcon:ClearAllPoints()
		end

		if index == 1 then
			unit.ActualHealthBar:SetVertexColor(0, 1, 0, C.alpha)
			unit.ActualHealthBar:SetPoint("BOTTOMLEFT", unit.Icon, "BOTTOMRIGHT", 10, 0)
			unit.healthBg:SetPoint("TOPLEFT", unit.ActualHealthBar, -C.mult, C.mult)
			unit.healthBg:SetPoint("BOTTOMLEFT", unit.ActualHealthBar, -C.mult, -C.mult)

			unit.typeIcon:SetPoint("TOPLEFT", unit.Icon, "TOPRIGHT", 10, 0)
			unit.Level:SetPoint("BOTTOMLEFT", unit.Icon, 2, 2)
			unit.Name:SetPoint("LEFT", unit.typeIcon, "RIGHT", 5, 0)

			if unit.SpeedIcon then
				unit.SpeedIcon:SetPoint("LEFT", unit.healthBg, "RIGHT", 5, 0)
				unit.SpeedIcon:SetTexCoord(0, .5, .5, 1)
			end
		else
			unit.ActualHealthBar:SetVertexColor(1, 0, 0, C.alpha)
			unit.ActualHealthBar:SetPoint("BOTTOMRIGHT", unit.Icon, "BOTTOMLEFT", -10, 0)
			unit.healthBg:SetPoint("TOPRIGHT", unit.ActualHealthBar, C.mult, C.mult)
			unit.healthBg:SetPoint("BOTTOMRIGHT", unit.ActualHealthBar, C.mult, -C.mult)

			unit.Level:SetPoint("BOTTOMRIGHT", unit.Icon, -2, 2)
			unit.typeIcon:SetPoint("TOPRIGHT", unit.Icon, "TOPLEFT", -10, 0)
			unit.Name:SetPoint("RIGHT", unit.typeIcon, "LEFT", -5, 0)

			if unit.SpeedIcon then
				unit.SpeedIcon:SetPoint("RIGHT", unit.healthBg, "LEFT", -5, 0)
				unit.SpeedIcon:SetTexCoord(.5, 0, .5, 1)
			end
		end
	end

	-- Pending Pets
	local buddies = {
		frame.Ally2,
		frame.Ally3,
		frame.Enemy2,
		frame.Enemy3,
	}
	for index, buddy in pairs(buddies) do
		B.StripTextures(buddy)

		buddy.Icon.icbg = B.ReskinIcon(buddy.Icon)

		buddy.deadIcon = buddy:CreateTexture(nil, "ARTWORK")
		buddy.deadIcon:SetAllPoints(buddy.Icon)
		buddy.deadIcon:SetTexture("Interface\\PETBATTLES\\DeadPetIcon")
		buddy.deadIcon:Hide()

		buddy.healthBarWidth = 38
		buddy.ActualHealthBar:SetTexture(DB.normTex)
		buddy.ActualHealthBar:ClearAllPoints()
		buddy.ActualHealthBar:SetPoint("TOPLEFT", buddy.Icon.icbg, "BOTTOMLEFT", C.mult, -4)
		buddy.healthBg = B.CreateBDFrame(buddy.ActualHealthBar)
		buddy.healthBg:SetPoint("TOPLEFT", buddy.ActualHealthBar, "TOPLEFT", -C.mult, C.mult)
		buddy.healthBg:SetPoint("BOTTOMRIGHT", buddy.ActualHealthBar, "BOTTOMLEFT", 38+C.mult, -C.mult)

		if index <= 2 then
			buddy.ActualHealthBar:SetVertexColor(0, 1, 0, C.alpha)
		else
			buddy.ActualHealthBar:SetVertexColor(1, 0, 0, C.alpha)
		end
	end

	frame.Ally2:ClearAllPoints()
	frame.Ally2:SetPoint("RIGHT", frame.ActiveAlly, "LEFT", -10, 0)
	frame.Ally3:ClearAllPoints()
	frame.Ally3:SetPoint("RIGHT", frame.Ally2, "LEFT", -10, 0)

	frame.Enemy2:ClearAllPoints()
	frame.Enemy2:SetPoint("LEFT", frame.ActiveEnemy, "RIGHT", 10, 0)
	frame.Enemy3:ClearAllPoints()
	frame.Enemy3:SetPoint("LEFT", frame.Enemy2, "RIGHT", 10, 0)

	-- Update Status
	hooksecurefunc("PetBattleUnitFrame_UpdatePetType", Reskin_UpdatePetType)
	hooksecurefunc("PetBattleUnitFrame_UpdateDisplay", Reskin_UpdateDisplay)
	hooksecurefunc("PetBattleUnitFrame_UpdateHealthInstant", Reskin_UpdateHealthInstant)
	hooksecurefunc("PetBattleAuraHolder_Update", Reskin_UpdateAuraHolder)

	-- Bottom Frame
	local BottomFrame = frame.BottomFrame
	B.StripTextures(BottomFrame)
	B.StripTextures(BottomFrame.FlowFrame)
	B.StripTextures(BottomFrame.TurnTimer)

	BottomFrame.Delimiter:Hide()
	BottomFrame.MicroButtonFrame:Hide()

	-- Reskin Petbar
	local bar = CreateFrame("Frame", "NDuiPetBattleBar", UIParent, "SecureHandlerStateTemplate")
	bar:SetPoint("BOTTOM", 0, 30)
	bar:SetSize(310, 40)
	local visibleState = "[petbattle] show; hide"
	RegisterStateDriver(bar, "visibility", visibleState)
	PetBattleFrame.bar = bar

	hooksecurefunc("PetBattleFrame_UpdateActionBarLayout", Reskin_UpdateActionBarLayout)

	local TurnTimer = BottomFrame.TurnTimer
	TurnTimer:SetParent(bar)
	TurnTimer:SetSize(310, 10)
	TurnTimer:ClearAllPoints()
	TurnTimer:SetPoint("BOTTOM", bar, "TOP", 0, 10)
	TurnTimer.bg = B.CreateBDFrame(TurnTimer, 0, -C.mult)
	TurnTimer.Bar:ClearAllPoints()
	TurnTimer.Bar:SetPoint("LEFT", 2, 0)
	TurnTimer.TimerText:ClearAllPoints()
	TurnTimer.TimerText:SetPoint("CENTER", TurnTimer)

	local SkipButton = TurnTimer.SkipButton
	B.StripTextures(SkipButton)
	local bg = B.CreateBDFrame(SkipButton, 0, -C.mult)
	B.ReskinCPTex(SkipButton, bg)
	SkipButton:SetParent(bar)
	SkipButton:SetSize(40, 40)
	local text = SkipButton.Text
	text:ClearAllPoints()
	text:SetPoint("CENTER", 1, 0)
	local icon = SkipButton:CreateTexture(nil, "ARTWORK")
	icon:SetInside(bg)
	icon:SetTexCoord(tL, tR, tT, tB)
	icon:SetTexture("Interface\\Icons\\Ability_Foundryraid_Dormant")
	local hl = SkipButton:CreateTexture(nil, "HIGHLIGHT")
	hl:SetInside(bg)
	hl:SetColorTexture(1, 1, 1, .25)

	local XPBar = PetBattleFrameXPBar
	B.ReskinStatusBar(XPBar)
	XPBar:SetParent(bar)
	XPBar:SetSize(310, 10)

	hooksecurefunc("PetBattleFrame_UpdatePassButtonAndTimer", Reskin_UpdatePassButtonAndTimer)

	-- Pet Changing
	for i = 1, NUM_BATTLE_PETS_IN_BATTLE do
		local unit = BottomFrame.PetSelectionFrame["Pet"..i]
		B.StripTextures(unit)
		B.ReskinIcon(unit.Icon)

		unit.Name:ClearAllPoints()
		unit.Name:SetPoint("TOPLEFT", unit.Icon, "TOPRIGHT", 5, 0)

		unit.Level:ClearAllPoints()
		unit.Level:SetPoint("BOTTOMLEFT", unit.Icon, 2, 2)

		unit.healthBarWidth = 128
		unit.ActualHealthBar:SetTexture(DB.normTex)
		unit.ActualHealthBar:ClearAllPoints()
		unit.ActualHealthBar:SetPoint("BOTTOMLEFT", unit.Icon, "BOTTOMRIGHT", 5, 0)
		local healthBg = B.CreateBDFrame(unit.ActualHealthBar)
		healthBg:SetPoint("TOPLEFT", unit.ActualHealthBar, "TOPLEFT", -C.mult, C.mult)
		healthBg:SetPoint("BOTTOMRIGHT", unit.ActualHealthBar, "BOTTOMLEFT", 128+C.mult, -C.mult)

		unit.HealthText:ClearAllPoints()
		unit.HealthText:SetPoint("CENTER", healthBg)
	end
end)