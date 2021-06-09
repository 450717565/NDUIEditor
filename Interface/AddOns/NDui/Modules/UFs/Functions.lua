local _, ns = ...
local B, C, L, DB = unpack(ns)

local oUF = ns.oUF
local UF = B:RegisterModule("UnitFrames")
local Auras = B:GetModule("Auras")

local format, floor = string.format, math.floor
local pairs, next = pairs, next
local UnitFrame_OnEnter, UnitFrame_OnLeave = UnitFrame_OnEnter, UnitFrame_OnLeave
local SpellGetVisibilityInfo, UnitAffectingCombat, SpellIsSelfBuff, SpellIsPriorityAura = SpellGetVisibilityInfo, UnitAffectingCombat, SpellIsSelfBuff, SpellIsPriorityAura

local barWidth, barHeight

-- Smooth Color
function B.SmoothColor(cur, max, fullRed)
	local usageColor = {1, 0, 0, 1, 1, 0, 0, 1, 0}
	if fullRed then
		usageColor = {0, 1, 0, 1, 1, 0, 1, 0, 0}
	end

	local r, g, b = oUF:RGBColorGradient(cur, max, unpack(usageColor))
	return r, g, b
end

-- Color Text
function B.ColorText(per, val, fullRed)
	local p = format("%.1f%%", per)
	local r, g, b = B.SmoothColor(per, 100, fullRed)
	if val then
		return B.HexRGB(r, g, b, val)
	else
		return B.HexRGB(r, g, b, p)
	end
end

-- Custom colors
oUF.colors.smooth = {1, 0, 0, .85, .8, .45, .1, .1, .1}

local function ReplacePowerColor(name, index, color)
	oUF.colors.power[name] = color
	oUF.colors.power[index] = oUF.colors.power[name]
end
ReplacePowerColor("MANA", 0, {0, .4, 1})
ReplacePowerColor("SOUL_SHARDS", 7, {.58, .51, .79})
ReplacePowerColor("HOLY_POWER", 9, {.88, .88, .06})
ReplacePowerColor("CHI", 12, {0, 1, .59})
ReplacePowerColor("ARCANE_CHARGES", 16, {.41, .8, .94})

-- Various values
local function retVal(self, val1, val2, val3, val4, val5)
	local mystyle = self.mystyle
	if mystyle == "player" or mystyle == "target" then
		return val1
	elseif mystyle == "focus" then
		return val2
	elseif mystyle == "boss" or mystyle == "arena" then
		return val3
	else
		if mystyle == "nameplate" and val5 then
			return val5
		else
			return val4
		end
	end
end

-- Elements
local function UF_OnEnter(self)
	UnitFrame_OnEnter(self)
	self.Highlight:Show()
end

local function UF_OnLeave(self)
	UnitFrame_OnLeave(self)
	self.Highlight:Hide()
end

function UF:CreateHeader(self)
	local hl = self:CreateTexture(nil, "OVERLAY")
	hl:SetAllPoints()
	hl:SetTexture("Interface\\PETBATTLES\\PetBattle-SelectedPetGlow")
	hl:SetTexCoord(0, 1, .5, 1)
	hl:SetVertexColor(.6, .6, .6)
	hl:SetBlendMode("ADD")
	hl:Hide()
	self.Highlight = hl

	self:RegisterForClicks("AnyUp")
	self:HookScript("OnEnter", UF_OnEnter)
	self:HookScript("OnLeave", UF_OnLeave)
end

local function UpdateHealthColorByIndex(health, index)
	health.colorClass = (index == 2)
	health.colorReaction = (index == 2)
	if health.SetColorTapping then
		health:SetColorTapping(index == 2)
	else
		health.colorTapping = (index == 2)
	end
	if health.SetColorDisconnected then
		health:SetColorDisconnected(index == 2)
	else
		health.colorDisconnected = (index == 2)
	end
	health.colorSmooth = (index == 3)
	if index == 1 then
		health:SetStatusBarColor(.1, .1, .1, 1)
		health.bg:SetVertexColor(.6, .6, .6, 1)
	end
end

function UF:UpdateHealthBarColor(self, force)
	local health = self.Health
	local mystyle = self.mystyle
	if mystyle == "playerplate" then
		health.colorHealth = true
	elseif mystyle == "raid" then
		UpdateHealthColorByIndex(health, C.db["UFs"]["RaidHealthColor"])
	else
		UpdateHealthColorByIndex(health, C.db["UFs"]["HealthColor"])
	end

	if force then
		health:ForceUpdate()
	end
end

function UF:CreateHealthBar(self)
	local health = B.CreateSB(self, false, .1, .1, .1)
	health:SetFrameLevel(self:GetFrameLevel())
	health:SetPoint("TOPLEFT", self)
	health:SetPoint("TOPRIGHT", self)
	B.SmoothSB(health)

	local healthHeight
	local mystyle = self.mystyle

	if mystyle == "playerplate" then
		healthHeight = C.db["Nameplate"]["PPHealthHeight"]
	elseif mystyle == "raid" then
		if self.isPartyFrame then
			healthHeight = C.db["UFs"]["PartyHeight"]
		elseif self.isPartyPet then
			healthHeight = C.db["UFs"]["PartyPetHeight"]
		elseif C.db["UFs"]["SimpleMode"] then
			healthHeight = 20*C.db["UFs"]["SimpleRaidScale"]/10
		else
			healthHeight = C.db["UFs"]["RaidHeight"]
		end
	else
		healthHeight = retVal(self, C.db["UFs"]["PlayerHeight"], C.db["UFs"]["FocusHeight"], C.db["UFs"]["BossHeight"], C.db["UFs"]["PetHeight"])
	end

	health:SetHeight(healthHeight)
	health.bg:SetVertexColor(.6, .6, .6, 1)
	health.bg.multiplier = .25
	health.sd = health.bd.sdTex

	self.Health = health

	UF:UpdateHealthBarColor(self)
end

function UF:UpdateRaidHealthMethod()
	for _, frame in pairs(oUF.objects) do
		if frame.mystyle == "raid" then
			frame:SetHealthUpdateMethod(C.db["UFs"]["FrequentHealth"])
			frame:SetHealthUpdateSpeed(C.db["UFs"]["HealthFrequency"])
			frame.Health:ForceUpdate()
		end
	end
end

function UF:CreateHealthText(self)
	local isSimpleMode = (C.db["UFs"]["SimpleMode"] and not self.isPartyFrame)

	local mystyle = self.mystyle
	local textFrame = B.CreateParentFrame(self, 1, self.Health)
	if mystyle == "nameplate" then
		textFrame:SetFrameLevel(self:GetFrameLevel() + 2)
	end

	local name = B.CreateFS(textFrame, retVal(self, 13, 12, 12, 12, C.db["Nameplate"]["NameTextSize"]), "", false, "LEFT", 3, 0)
	name:SetJustifyH("LEFT")
	if mystyle == "raid" then
		name:SetWidth(self:GetWidth()*.95)
		name:SetJustifyH("CENTER")
		name:ClearAllPoints()
		if self.isPartyPet then
			name:SetPoint("BOTTOM", self, "CENTER", 0, 0)
		elseif isSimpleMode then
			name:SetJustifyH("LEFT")
			name:SetPoint("LEFT", 4, 0)
		else
			name:SetPoint("CENTER")
		end
		name:SetScale(C.db["UFs"]["RaidTextScale"])
	elseif mystyle == "nameplate" then
		name:ClearAllPoints()
		name:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, 5)
		name:SetPoint("BOTTOMRIGHT", self, "TOPRIGHT", 0, 5)
	else
		name:SetWidth(self:GetWidth()*.55)
	end

	if mystyle == "player" then
		self:Tag(name, "[color][name]")
	elseif mystyle == "target" then
		self:Tag(name, "[fulllevel] [color][name][flag]")
	elseif mystyle == "focus" then
		self:Tag(name, "[color][name][flag]")
	elseif mystyle == "nameplate" then
		self:Tag(name, "[nplevel][name]")
	elseif mystyle == "arena" then
		self:Tag(name, "[arenaspec] [color][name]")
	elseif mystyle == "raid" and C.db["UFs"]["SimpleMode"] and C.db["UFs"]["ShowTeamIndex"] and not self.isPartyPet and not self.isPartyFrame then
		self:Tag(name, "[group].[color][name]")
	else
		self:Tag(name, "[color][name]")
	end

	local hpval = B.CreateFS(textFrame, retVal(self, 14, 13, 13, 13, C.db["Nameplate"]["HealthTextSize"]), "", false, "RIGHT", -3, 0)
	hpval:SetJustifyH("RIGHT")
	if mystyle == "raid" then
		self:Tag(hpval, "[raidhp]")
		hpval:SetJustifyH("CENTER")
		hpval:ClearAllPoints()
		if self.isPartyPet then
			hpval:SetPoint("TOP", self, "CENTER", 0, 0)
			self:Tag(hpval, "[health]")
		elseif isSimpleMode then
			hpval:SetJustifyH("RIGHT")
			hpval:SetPoint("RIGHT", -4, 0)
		else
			hpval:SetPoint("BOTTOM")
		end
		hpval:SetScale(C.db["UFs"]["RaidTextScale"])
	elseif mystyle == "nameplate" then
		hpval:ClearAllPoints()
		hpval:SetPoint("RIGHT", self, "TOPRIGHT", 0, 0)
		self:Tag(hpval, "[nphp]")
	else
		self:Tag(hpval, "[health]")
	end

	self.nameText = name
	self.healthValue = hpval
end

function UF:UpdateRaidHPMode()
	for _, frame in pairs(oUF.objects) do
		if frame.mystyle == "raid" then
			frame.healthValue:UpdateTag()
		end
	end
end

local function UpdatePowerColorByIndex(power, index)
	power.colorPower = (index == 2)
	power.colorClass = (index ~= 2)
	power.colorReaction = (index ~= 2)
	if power.SetColorTapping then
		power:SetColorTapping(index ~= 2)
	else
		power.colorTapping = (index ~= 2)
	end
	if power.SetColorDisconnected then
		power:SetColorDisconnected(index ~= 2)
	else
		power.colorDisconnected = (index ~= 2)
	end
end

function UF:UpdatePowerBarColor(self, force)
	local power = self.Power
	local mystyle = self.mystyle
	if mystyle == "playerplate" then
		power.colorPower = true
	elseif mystyle == "raid" then
		UpdatePowerColorByIndex(power, C.db["UFs"]["RaidHealthColor"])
	else
		UpdatePowerColorByIndex(power, C.db["UFs"]["HealthColor"])
	end

	if force then
		power:ForceUpdate()
	end
end

function UF:CreatePowerBar(self)
	local power = B.CreateSB(self)
	power:SetFrameLevel(self:GetFrameLevel())
	power:SetPoint("BOTTOMLEFT", self)
	power:SetPoint("BOTTOMRIGHT", self)
	B.SmoothSB(power)

	local powerHeight
	local mystyle = self.mystyle

	if mystyle == "playerplate" then
		powerHeight = C.db["Nameplate"]["PPPowerHeight"]
	elseif mystyle == "raid" then
		if self.isPartyFrame then
			powerHeight = C.db["UFs"]["PartyPowerHeight"]
		elseif self.isPartyPet then
			powerHeight = C.db["UFs"]["PartyPetPowerHeight"]
		elseif C.db["UFs"]["SimpleMode"] then
			powerHeight = 2*C.db["UFs"]["SimpleRaidScale"]/10
		else
			powerHeight = C.db["UFs"]["RaidPowerHeight"]
		end
	else
		powerHeight = retVal(self, C.db["UFs"]["PlayerPowerHeight"], C.db["UFs"]["FocusPowerHeight"], C.db["UFs"]["BossPowerHeight"], C.db["UFs"]["PetPowerHeight"])
	end

	power:SetHeight(powerHeight)
	power.bg:SetAlpha(1)
	power.bg.multiplier = .25
	if power.bd.sdTex then power.bd.sdTex:Hide() end

	self.Power = power

	power.frequentUpdates = true
	UF:UpdatePowerBarColor(self)

	barHeight = self.Power:GetHeight()

	if self.Health.sd then
		self.Health.sd:SetOutside(self.Health.bd, 4, 4, self.Power.bd)
	end
end

function UF:CreatePowerText(self)
	local textFrame = B.CreateParentFrame(self, 1, self.Power)
	local ppval = B.CreateFS(textFrame, retVal(self, 13, 12, 12, 12), "", false, "RIGHT", -3, 0)

	local mystyle = self.mystyle
	if mystyle == "raid" then
		ppval:SetScale(C.db["UFs"]["RaidTextScale"])
	elseif mystyle == "player" or mystyle == "target" then
		ppval:SetPoint("RIGHT", -3, C.db["UFs"]["PlayerPowerOffset"])
	elseif mystyle == "boss" or mystyle == "arena" then
		ppval:SetPoint("RIGHT", -3, C.db["UFs"]["BossPowerOffset"])
	elseif mystyle == "focus" then
		ppval:SetPoint("RIGHT", -3, C.db["UFs"]["FocusPowerOffset"])
	end

	self:Tag(ppval, "[power]")
	self.powerText = ppval
end

local textScaleFrames = {
	["player"] = true,
	["target"] = true,
	["focus"] = true,
	["pet"] = true,
	["tot"] = true,
	["fot"] = true,
	["boss"] = true,
	["arena"] = true,
}
function UF:UpdateTextScale()
	local scale = C.db["UFs"]["UFTextScale"]
	for _, frame in pairs(oUF.objects) do
		local style = frame.mystyle
		if style and textScaleFrames[style] then
			frame.nameText:SetScale(scale)
			frame.healthValue:SetScale(scale)
			if frame.powerText then frame.powerText:SetScale(scale) end
			local castbar = frame.Castbar
			if castbar then
				castbar.Text:SetScale(scale)
				castbar.Time:SetScale(scale)
				if castbar.Lag then castbar.Lag:SetScale(scale) end
			end
			UF:UpdateHealthBarColor(frame, true)
			UF:UpdatePowerBarColor(frame, true)
		end
	end
end

function UF:UpdateRaidTextScale()
	local scale = C.db["UFs"]["RaidTextScale"]
	for _, frame in pairs(oUF.objects) do
		if frame.mystyle == "raid" then
			frame.nameText:SetScale(scale)
			frame.healthValue:SetScale(scale)
			if frame.powerText then frame.powerText:SetScale(scale) end
			UF:UpdateHealthBarColor(frame, true)
			UF:UpdatePowerBarColor(frame, true)
		end
	end
end

function UF:CreatePortrait(self)
	if not C.db["UFs"]["Portrait"] then return end

	local portrait = CreateFrame("PlayerModel", nil, self)
	portrait:SetFrameLevel(self:GetFrameLevel())
	portrait:SetAllPoints()
	portrait:SetAlpha(.25)
	self.Portrait = portrait
end

function UF:CreateIcons(self)
	local mystyle = self.mystyle

	if mystyle == "player" then
		local combat = self:CreateTexture(nil, "OVERLAY")
		combat:SetPoint("CENTER", self, "BOTTOMLEFT")
		combat:SetSize(28, 28)
		combat:SetAtlas(DB.objectTex)
		self.CombatIndicator = combat

		local resting = self:CreateTexture(nil, "OVERLAY")
		resting:SetPoint("CENTER", self, "TOPLEFT")
		resting:SetSize(18, 18)
		resting:SetTexture(DB.restingTex)
		self.RestingIndicator = resting
	elseif mystyle == "target" then
		local quest = self:CreateTexture(nil, "OVERLAY")
		quest:SetPoint("LEFT", self, "TOPLEFT", 2, 0)
		quest:SetSize(18, 18)
		self.QuestIndicator = quest
	end

	local phase = self:CreateTexture(nil, "OVERLAY")
	phase:SetSize(24, 24)
	phase:SetPoint("CENTER", self, "TOP", 0, 0)
	if mystyle == "raid" then
		phase:SetPoint("BOTTOM", self, "BOTTOM", 0, -2)
	end
	self.PhaseIndicator = phase

	local size = 20
	if mystyle == "raid" then size = 14 end

	local groupRole = self:CreateTexture(nil, "OVERLAY")
	groupRole:SetSize(size, size)
	groupRole:SetPoint("RIGHT", self, "TOPRIGHT", -2, 1)
	if mystyle == "raid" then
		groupRole:SetPoint("TOPRIGHT", self, "TOPRIGHT", 2, 2)
	end
	self.GroupRoleIndicator = groupRole

	local leader = self:CreateTexture(nil, "OVERLAY")
	leader:SetAtlas("Soulbinds_Tree_Conduit_Icon_Attack")
	leader:SetSize(size, size)
	leader:SetPoint("RIGHT", groupRole, "LEFT", 4, 0)
	self.LeaderIndicator = leader

	local assistant = self:CreateTexture(nil, "OVERLAY")
	assistant:SetAtlas("Soulbinds_Tree_Conduit_Icon_Utility")
	assistant:SetSize(size, size)
	assistant:SetPoint("RIGHT", groupRole, "LEFT", 4, 0)
	self.AssistantIndicator = assistant
end

function UF:CreateRaidMark(self)
	local mystyle = self.mystyle

	local raidTarget = self:CreateTexture(nil, "OVERLAY")
	if mystyle == "player" then
		raidTarget:SetPoint("RIGHT", self, "TOPRIGHT", -40, 2)
	elseif mystyle == "nameplate" then
		raidTarget:SetPoint("BOTTOMRIGHT", self, "TOPLEFT", -1, 1)
	elseif mystyle == "raid" then
		raidTarget:SetPoint("TOP", self, "TOP", 0, 0)
	else
		raidTarget:SetPoint("CENTER", self, "TOP", 0, 0)
	end

	local size = retVal(self, 18, 13, 12, 12, 32)
	raidTarget:SetSize(size, size)
	self.RaidTargetIndicator = raidTarget
end

local function createBarMover(bar, text, value, anchor)
	local mover = B.Mover(bar, text, value, anchor, bar:GetHeight()+bar:GetWidth()+3, bar:GetHeight()+3)
	bar:ClearAllPoints()
	bar:SetPoint("RIGHT", mover)
	bar.mover = mover
end

function UF:CreateCastBar(self)
	local mystyle = self.mystyle
	if mystyle ~= "nameplate" and not C.db["UFs"]["Castbars"] then return end

	local cb = B.CreateSB(self, true)
	cb:SetSize(self:GetWidth(), self:GetHeight())

	if mystyle == "player" then
		cb:SetFrameLevel(10)
		cb:SetSize(C.db["UFs"]["PlayerCBWidth"], C.db["UFs"]["PlayerCBHeight"])
		createBarMover(cb, L["Player Castbar"], "PlayerCB", C.UFs.PlayerCB)
	elseif mystyle == "target" then
		cb:SetFrameLevel(10)
		cb:SetSize(C.db["UFs"]["TargetCBWidth"], C.db["UFs"]["TargetCBHeight"])
		createBarMover(cb, L["Target Castbar"], "TargetCB", C.UFs.TargetCB)
	elseif mystyle == "focus" then
		cb:SetFrameLevel(10)
		cb:SetSize(C.db["UFs"]["FocusCBWidth"], C.db["UFs"]["FocusCBHeight"])
		createBarMover(cb, L["Focus Castbar"], "FocusCB", C.UFs.FocusCB)
	elseif mystyle == "boss" or mystyle == "arena" then
		cb:SetFrameLevel(10)
		cb:ClearAllPoints()
		cb:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, -C.margin)
		cb:SetPoint("TOPRIGHT", self, "BOTTOMRIGHT", 0, -C.margin)
		cb:SetHeight(10)
	elseif mystyle == "nameplate" then
		cb:ClearAllPoints()
		cb:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, -5)
		cb:SetPoint("TOPRIGHT", self, "BOTTOMRIGHT", 0, -5)
		cb:SetHeight(self:GetHeight())
	end

	local timer = B.CreateFS(cb, retVal(self, 12, 12, 12, 12, C.db["Nameplate"]["NameTextSize"]), "", false, "RIGHT", -2, 0)
	local name = B.CreateFS(cb, retVal(self, 12, 12, 12, 12, C.db["Nameplate"]["NameTextSize"]), "", false, "LEFT", 2, 0)
	name:SetPoint("RIGHT", timer, "LEFT", -5, 0)
	name:SetJustifyH("LEFT")

	if mystyle ~= "boss" and mystyle ~= "arena" then
		cb.Icon = cb:CreateTexture(nil, "ARTWORK")
		cb.Icon:SetSize(cb:GetHeight(), cb:GetHeight())
		cb.Icon:SetPoint("BOTTOMRIGHT", cb, "BOTTOMLEFT", -C.margin, 0)
		B.ReskinIcon(cb.Icon)
	end

	if mystyle == "player" then
		if C.db["UFs"]["LagString"] then
			local safe = cb:CreateTexture(nil, "OVERLAY")
			safe:SetTexture(DB.normTex)
			safe:SetVertexColor(1, 0, 0, .6)
			safe:SetPoint("TOPRIGHT")
			safe:SetPoint("BOTTOMRIGHT")
			cb.SafeZone = safe

			local lag = B.CreateFS(cb, 10)
			lag:ClearAllPoints()
			lag:SetPoint("BOTTOM", cb, "TOP", 0, 2)
			cb.Lag = lag

			self:RegisterEvent("GLOBAL_MOUSE_UP", B.OnCastSent, true) -- Fix quests with WorldFrame interaction
			self:RegisterEvent("GLOBAL_MOUSE_DOWN", B.OnCastSent, true)
			self:RegisterEvent("CURRENT_SPELL_CAST_CHANGED", B.OnCastSent, true)
		end
	elseif mystyle == "nameplate" then
		name:SetPoint("LEFT", cb, "BOTTOMLEFT", 0, 0)
		timer:SetPoint("RIGHT", cb, "BOTTOMRIGHT", 0, 0)

		local shield = cb:CreateTexture(nil, "OVERLAY")
		shield:SetAtlas("nameplates-InterruptShield")
		shield:SetSize(18, 18)
		shield:SetPoint("CENTER", cb, "BOTTOM", 0, 0)
		cb.Shield = shield

		local iconSize = self:GetHeight()*2 + 5
		cb.Icon:SetSize(iconSize, iconSize)
		cb.Icon:SetPoint("BOTTOMRIGHT", cb, "BOTTOMLEFT", -5, 0)
		cb.timeToHold = .5

		cb.glowFrame = B.CreateGlowFrame(cb, iconSize)
		cb.glowFrame:SetPoint("CENTER", cb.Icon)

		local spellTarget = B.CreateFS(cb, C.db["Nameplate"]["NameTextSize"]+3)
		spellTarget:ClearAllPoints()
		spellTarget:SetJustifyH("CENTER")
		spellTarget:SetPoint("TOP", cb, "BOTTOM", 0, -5)
		cb.spellTarget = spellTarget
	end

	if mystyle == "nameplate" or mystyle == "boss" or mystyle == "arena" then
		cb.decimal = "%.1f"
	else
		cb.decimal = "%.2f"
	end

	cb.Time = timer
	cb.Text = name
	cb.OnUpdate = B.OnCastbarUpdate
	cb.PostCastStart = B.PostCastStart
	cb.PostCastUpdate = B.PostCastUpdate
	cb.PostCastStop = B.PostCastStop
	cb.PostCastFail = B.PostCastFailed
	cb.PostCastInterruptible = B.PostUpdateInterruptible

	self.Castbar = cb
end

local function reskinTimerBar(bar)
	bar:SetSize(280, 18)
	B.StripTextures(bar)

	local statusbar = _G[bar:GetDebugName().."StatusBar"]
	if statusbar then
		statusbar:SetAllPoints()
		statusbar:SetStatusBarTexture(DB.normTex)
	else
		bar:SetStatusBarTexture(DB.normTex)
	end

	local bg = B.CreateBDFrame(bar, 0, -C.mult)
	B.CreateBT(bg)
end

function UF:ReskinMirrorBars()
	local previous
	for i = 1, 3 do
		local bar = _G["MirrorTimer"..i]
		reskinTimerBar(bar)

		local text = _G["MirrorTimer"..i.."Text"]
		text:ClearAllPoints()
		text:SetPoint("CENTER")

		if previous then
			bar:SetPoint("TOP", previous, "BOTTOM", 0, -5)
		end
		previous = bar
	end
end

function UF:ReskinTimerTrakcer(self)
	local function updateTimerTracker()
		for _, timer in pairs(TimerTracker.timerList) do
			if timer.bar and not timer.bar.styled then
				reskinTimerBar(timer.bar)

				timer.bar.styled = true
			end
		end
	end
	self:RegisterEvent("START_TIMER", updateTimerTracker, true)
end

-- Auras Relevant
function UF.PostCreateIcon(element, button)
	local fontsize = element.fontSize or element.size*.6
	local fontSize = B.Round(fontsize)

	local textFrame = B.CreateParentFrame(button)
	button.timer = B.CreateFS(textFrame, fontSize)
	button.count = B.CreateFS(textFrame, fontSize, "", false, "BOTTOMRIGHT", 4, -4)
	button.count:SetJustifyH("RIGHT")

	button.glowFrame = B.CreateGlowFrame(button, element.size)
	button.icbg = B.ReskinIcon(button.icon)
	button.icbg:SetFrameLevel(button:GetFrameLevel())

	button.HL = button:CreateTexture(nil, "HIGHLIGHT")
	button.HL:SetColorTexture(1, 1, 1, .25)
	button.HL:SetInside(button.icbg)

	button.cd:SetReverse(true)
	button.cd:SetInside(button.icbg)

	button.overlay:SetTexture("")
	button.stealable:SetTexture("")

	button:HookScript("OnMouseDown", Auras.RemoveSpellFromIgnoreList)
end

local filteredStyle = {
	["target"] = true,
	["nameplate"] = true,
	["boss"] = true,
	["arena"] = true,
}

function UF.PostUpdateIcon(element, _, button, _, _, duration, expiration, debuffType)
	if duration then button.icbg:Show() end

	local style = element.__owner.mystyle
	if style == "nameplate" then
		button:SetSize(element.size, element.size - 4)
	else
		button:SetSize(element.size, element.size)
	end

	if button.isDebuff and filteredStyle[style] and not button.isPlayer then
		button.icon:SetDesaturated(true)
	else
		button.icon:SetDesaturated(false)
	end

	if style == "raid" and not button.isDebuff then
		button.icbg:SetBackdropBorderColor(0, 1, 0)
	elseif button.isDebuff and element.showDebuffType then
		local color = oUF.colors.debuff[debuffType] or oUF.colors.debuff.none
		button.icbg:SetBackdropBorderColor(color[1], color[2], color[3])
	else
		button.icbg:SetBackdropBorderColor(0, 0, 0)
	end

	if element.disableCooldown then
		if duration and duration > 0 then
			button.expiration = expiration
			button:SetScript("OnUpdate", B.CooldownOnUpdate)
			button.timer:Show()
		else
			button:SetScript("OnUpdate", nil)
			button.timer:Hide()
		end
	end

	if button.glowFrame and button.stealable and button.stealable:IsShown() then
		B.ShowOverlayGlow(button.glowFrame)
	else
		B.HideOverlayGlow(button.glowFrame)
	end

	local fontsize = element.fontSize or element.size*.6
	local fontSize = B.Round(fontsize)
	button.timer:SetFont(DB.Font[1], fontSize, DB.Font[3])
	button.count:SetFont(DB.Font[1], fontSize, DB.Font[3])
end

local function bolsterPreUpdate(element)
	element.bolster = 0
	element.bolsterIndex = nil
end

local function bolsterPostUpdate(element)
	if not element.bolsterIndex then return end
	for _, button in pairs(element) do
		if button == element.bolsterIndex then
			button.count:SetText(element.bolster)
			return
		end
	end
end

function UF.PostUpdateGapIcon(_, _, icon)
	if icon.icbg and icon.icbg:IsShown() then
		icon.icbg:Hide()
	end

	if icon.glowFrame and icon.glowFrame:IsShown() then
		B.HideOverlayGlow(icon.glowFrame)
	end
end

function UF.CustomFilter(element, unit, button, name, _, _, _, duration, _, caster, isStealable, _, spellID, _, _, _, nameplateShowAll)
	local style = element.__owner.mystyle
	local isPlayerCast = (caster == "player" or caster == "pet" or caster == "vehicle")
	if name and spellID == 209859 then
		element.bolster = element.bolster + 1
		if not element.bolsterIndex then
			element.bolsterIndex = button
			return true
		end
	elseif style == "raid" then
		if C.RaidBuffs["WARNING"][spellID] or C.RaidBuffs["ALL"][spellID] or NDuiADB["RaidAuraWatch"][spellID] then
			element.__owner.rawSpellID = spellID
			return true
		else
			element.__owner.rawSpellID = nil
		end
	elseif style == "nameplate" or style == "boss" or style == "arena" or style == "focus" then
		if element.__owner.isNameOnly then
			return NDuiADB["NameplateFilter"][1][spellID] or C.WhiteList[spellID]
		elseif NDuiADB["NameplateFilter"][2][spellID] or C.BlackList[spellID] then
			return false
		elseif element.showStealableBuffs and isStealable and not UnitIsPlayer(unit) then
			return true
		elseif NDuiADB["NameplateFilter"][1][spellID] or C.WhiteList[spellID] then
			return true
		else
			local auraFilter = C.db["Nameplate"]["AuraFilter"]
			return (auraFilter == 3 and nameplateShowAll) or (auraFilter ~= 1 and isPlayerCast)
		end
	elseif (element.onlyShowPlayer and button.isPlayer) or (not element.onlyShowPlayer and name) then
		return true
	end
end

local buffWhiteList = {
	-- 通灵战潮
	[328126] = true, -- 被遗忘的铸锤
	[328325] = true, -- 染血长枪
	[328399] = true, -- 释放的心能
	[325189] = true, -- 被遗忘的盾牌
	[335161] = true, -- 残存心能
	-- 赤红深渊
	--[340433] = true, -- 堕罪之赐
}
function UF.RaidBuffFilter(_, _, _, _, _, _, _, _, _, caster, _, _, spellID, canApplyAura, isBossAura)
	if isBossAura or buffWhiteList[spellID] then
		return true
	else
		local hasCustom, alwaysShowMine, showForMySpec = SpellGetVisibilityInfo(spellID, UnitAffectingCombat("player") and "RAID_INCOMBAT" or "RAID_OUTOFCOMBAT")
		local isPlayerSpell = (caster == "player" or caster == "pet" or caster == "vehicle")
		if hasCustom then
			return showForMySpec or (alwaysShowMine and isPlayerSpell)
		else
			return isPlayerSpell and canApplyAura and not SpellIsSelfBuff(spellID)
		end
	end
end

local debuffBlackList = {
	[206151] = true,
}
function UF.RaidDebuffFilter(element, _, _, _, _, _, _, _, _, caster, _, _, spellID, _, isBossAura)
	local parent = element.__owner
	if debuffBlackList[spellID] then
		return false
	elseif (C.db["UFs"]["RaidAuraIndicator"] and UF.CornerSpells[spellID]) or (parent.RaidDebuffs and parent.RaidDebuffs.spellID == spellID) or parent.rawSpellID == spellID then
		return false
	elseif isBossAura or SpellIsPriorityAura(spellID) then
		return true
	else
		local hasCustom, alwaysShowMine, showForMySpec = SpellGetVisibilityInfo(spellID, UnitAffectingCombat("player") and "RAID_INCOMBAT" or "RAID_OUTOFCOMBAT")
		if hasCustom then
			return showForMySpec or (alwaysShowMine and (caster == "player" or caster == "pet" or caster == "vehicle"))
		else
			return true
		end
	end
end

local function UpdateIconSize(w, n, s)
	return (w-(n-1)*s)/n
end

function UF:UpdateAuraContainer(parent, element, maxAuras)
	local width = parent:GetWidth()
	local iconsPerRow = element.iconsPerRow
	local maxLines = iconsPerRow and B.Round(maxAuras/iconsPerRow) or 1
	element.size = iconsPerRow and UpdateIconSize(width, iconsPerRow, element.spacing) or element.size

	element:SetWidth(width)
	element:SetHeight((element.size + element.spacing) * maxLines)
end

function UF:UpdateTargetAuras()
	local frame = _G.oUF_Target
	if not frame then return end

	local element = frame.Auras
	element.iconsPerRow = C.db["UFs"]["TargetAurasPerRow"]

	UF:UpdateAuraContainer(frame, element, element.numBuffs + element.numDebuffs)
	element:ForceUpdate()
end

function UF:GetStyleNums()
	if self.isPartyFrame then
		return C.db["UFs"]["PartyAuraNums"]
	elseif C.db["UFs"]["SimpleMode"] then
		return 0
	else
		return C.db["UFs"]["RaidAuraNums"]
	end
end

function UF:CreateAuras(self)
	local bu = CreateFrame("Frame", nil, self)
	bu.gap = false
	bu.spacing = C.margin
	bu.tooltipAnchor = "ANCHOR_BOTTOMLEFT"
	bu.initialAnchor = "BOTTOMLEFT"
	bu["growth-x"] = "RIGHT"
	bu["growth-y"] = "DOWN"

	local mystyle = self.mystyle
	if mystyle == "target" then
		bu.initialAnchor = "TOPLEFT"
		bu:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, -6)
		bu.numBuffs = 22
		bu.numDebuffs = 22
		bu.iconsPerRow = C.db["UFs"]["TargetAurasPerRow"]
		bu.gap = true
	elseif mystyle == "raid" then
		bu.initialAnchor = "RIGHT"
		bu:SetPoint("RIGHT", self, "CENTER", -5, 0)
		bu.size = B.Round(self:GetHeight()*.6*C.db["UFs"]["RaidAuraScale"])
		bu.numTotal = 1
		bu.disableCooldown = true
		bu.disableMouse = C.db["UFs"]["AurasClickThrough"]
	elseif mystyle == "nameplate" then
		bu.initialAnchor = "BOTTOMLEFT"
		bu["growth-y"] = "UP"
		bu.numTotal = 18
		bu.iconsPerRow = 6
		bu.disableMouse = true
		if C.db["Nameplate"]["ShowPlayerPlate"] and C.db["Nameplate"]["NameplateClassPower"] then
			bu:SetPoint("BOTTOMLEFT", self.nameText, "TOPLEFT", 0, 10 + _G.oUF_ClassPowerBar:GetHeight())
		else
			bu:SetPoint("BOTTOMLEFT", self.nameText, "TOPLEFT", 0, 5)
		end
	end

	UF:UpdateAuraContainer(self, bu, bu.numTotal or bu.numBuffs + bu.numDebuffs)

	bu.showDebuffType = true
	bu.showStealableBuffs = true
	bu.CustomFilter = UF.CustomFilter
	bu.PostCreateIcon = UF.PostCreateIcon
	bu.PostUpdateIcon = UF.PostUpdateIcon
	bu.PostUpdateGapIcon = UF.PostUpdateGapIcon
	bu.PreUpdate = bolsterPreUpdate
	bu.PostUpdate = bolsterPostUpdate

	self.Auras = bu
end

function UF:CreateBuffs(self)
	local bu = CreateFrame("Frame", nil, self)
	bu.num = 6
	bu.iconsPerRow = 6
	bu.spacing = C.margin
	bu.tooltipAnchor = "ANCHOR_BOTTOMLEFT"
	bu.initialAnchor = "BOTTOMLEFT"
	bu["growth-x"] = "RIGHT"
	bu["growth-y"] = "UP"

	local mystyle = self.mystyle
	if mystyle == "raid" then
		bu.initialAnchor = "TOPLEFT"
		bu["growth-x"] = "RIGHT"
		bu:SetPoint("TOPLEFT", self, "TOPLEFT", 0, 0)
		bu.num = UF.GetStyleNums(self)
		bu.iconsPerRow = UF.GetStyleNums(self)
		bu.disableMouse = C.db["UFs"]["AurasClickThrough"]
		bu.CustomFilter = UF.RaidBuffFilter
	else
		bu:SetPoint("BOTTOMLEFT", self.AlternativePower or self, "TOPLEFT", 0, C.margin)
		bu.CustomFilter = UF.CustomFilter
	end

	UF:UpdateAuraContainer(self, bu, bu.num)

	bu.onlyShowPlayer = false
	bu.showStealableBuffs = true
	bu.PostCreateIcon = UF.PostCreateIcon
	bu.PostUpdateIcon = UF.PostUpdateIcon

	self.Buffs = bu
end

function UF:CreateDebuffs(self)
	local bu = CreateFrame("Frame", nil, self)
	bu.spacing = C.margin
	bu.tooltipAnchor = "ANCHOR_BOTTOMLEFT"
	bu.initialAnchor = "TOPRIGHT"
	bu["growth-x"] = "LEFT"
	bu["growth-y"] = "DOWN"

	local mystyle = self.mystyle
	if mystyle == "player" then
		bu:SetPoint("TOPRIGHT", self.AdditionalPower, "BOTTOMRIGHT", 0, -6)
		bu.num = 21
		bu.iconsPerRow = 7
	elseif mystyle == "boss" or mystyle == "arena" then
		bu["growth-y"] = "UP"
		bu:SetPoint("TOPRIGHT", self, "TOPLEFT", -5, 0)
		bu.num = 10
		bu.size = self:GetHeight()
		bu.CustomFilter = UF.CustomFilter
	elseif mystyle == "tot" then
		bu:SetPoint("TOPRIGHT", self, "BOTTOMRIGHT", 0, -6)
		bu.num = 10
		bu.iconsPerRow = 5
	elseif mystyle == "focus" then
		bu.initialAnchor = "TOPLEFT"
		bu["growth-x"] = "RIGHT"
		bu:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, -6)
		bu.num = 14
		bu.iconsPerRow = 7
		bu.CustomFilter = UF.CustomFilter
	elseif mystyle == "raid" then
		bu.initialAnchor = "BOTTOMRIGHT"
		bu["growth-x"] = "LEFT"
		bu:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 0, 0)
		bu.num = UF.GetStyleNums(self)
		bu.iconsPerRow = UF.GetStyleNums(self)
		bu.disableMouse = C.db["UFs"]["AurasClickThrough"]
		bu.CustomFilter = UF.RaidDebuffFilter
	end

	UF:UpdateAuraContainer(self, bu, bu.num)

	bu.showDebuffType = true
	bu.PostCreateIcon = UF.PostCreateIcon
	bu.PostUpdateIcon = UF.PostUpdateIcon

	self.Debuffs = bu
end

local function refreshAurasElements(self)
	local buffs = self.Buffs
	if buffs then buffs:ForceUpdate() end

	local debuffs = self.Debuffs
	if debuffs then debuffs:ForceUpdate() end
end

function UF:RefreshAurasByCombat(self)
	self:RegisterEvent("PLAYER_REGEN_ENABLED", refreshAurasElements, true)
	self:RegisterEvent("PLAYER_REGEN_DISABLED", refreshAurasElements, true)
end

-- Class Powers
function UF.PostUpdateClassPower(element, cur, max, diff, powerType, chargedIndex)
	if not cur or cur == 0 then
		for i = 1, 6 do
			element[i].bg:Hide()
		end

		element.prevColor = nil
	else
		for i = 1, max do
			element[i].bg:Show()
		end

		element.thisColor = cur == max and 1 or 2
		if not element.prevColor or element.prevColor ~= element.thisColor then
			local r, g, b = 1, 0, 0
			if element.thisColor == 2 then
				local color = element.__owner.colors.power[powerType]
				r, g, b = color[1], color[2], color[3]
			end
			for i = 1, #element do
				element[i]:SetStatusBarColor(r, g, b)
			end
			element.prevColor = element.thisColor
		end
	end

	if diff then
		for i = 1, max do
			element[i]:SetWidth((barWidth - (max-1)*C.margin)/max)
		end
		for i = max + 1, 6 do
			element[i].bg:Hide()
		end
	end

	if chargedIndex and chargedIndex ~= element.thisCharge then
		local bar = element[chargedIndex]
		element.chargeStar:SetParent(bar)
		element.chargeStar:SetPoint("CENTER", bar)
		element.chargeStar:Show()
		element.thisCharge = chargedIndex
	else
		element.chargeStar:Hide()
		element.thisCharge = nil
	end
end

function UF:OnUpdateRunes(elapsed)
	local duration = self.duration + elapsed
	self.duration = duration
	self:SetValue(duration)

	if self.timer then
		local remain = self.runeDuration - duration
		if remain > 0 then
			self.timer:SetText(B.FormatTime(remain))
		else
			self.timer:SetText(nil)
		end
	end
end

function UF.PostUpdateRunes(element, runemap)
	for index, runeID in next, runemap do
		local rune = element[index]
		local start, duration, runeReady = GetRuneCooldown(runeID)
		if rune:IsShown() then
			if runeReady then
				rune:SetAlpha(1)
				rune:SetScript("OnUpdate", nil)
				if rune.timer then rune.timer:SetText(nil) end
			elseif start then
				rune:SetAlpha(.6)
				rune.runeDuration = duration
				rune:SetScript("OnUpdate", UF.OnUpdateRunes)
			end
		end
	end
end

function UF:CreateClassPower(self)
	barWidth = self:GetWidth()*.6

	if self.mystyle == "playerplate" then
		barWidth = C.db["Nameplate"]["NameplateClassPower"] and C.db["Nameplate"]["PlateWidth"] or C.db["Nameplate"]["PPWidth"]
		barHeight = C.db["Nameplate"]["PPBarHeight"]
	end

	local bar = CreateFrame("Frame", "oUF_ClassPowerBar", self.Health)
	bar:SetSize(barWidth, barHeight)
	bar:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, C.margin)

	local bars = {}
	for i = 1, 6 do
		bars[i] = B.CreateSB(bar)
		bars[i]:SetHeight(barHeight)
		bars[i]:SetWidth((barWidth - 5*C.margin) / 6)

		if i == 1 then
			bars[i]:SetPoint("BOTTOMLEFT")
		else
			bars[i]:SetPoint("LEFT", bars[i-1], "RIGHT", C.margin, 0)
		end

		if DB.MyClass == "DEATHKNIGHT" and C.db["UFs"]["RuneTimer"] then
			bars[i].timer = B.CreateFS(bars[i], 13)
		end

		bars[i].bg.multiplier = .25
	end

	if DB.MyClass == "DEATHKNIGHT" then
		bars.colorSpec = true
		bars.sortOrder = "asc"
		bars.PostUpdate = UF.PostUpdateRunes
		bars.__max = 6
		self.Runes = bars
	else
		local chargeStar = bar:CreateTexture()
		chargeStar:SetAtlas("VignetteKill")
		chargeStar:SetSize(24, 24)
		chargeStar:Hide()
		bars.chargeStar = chargeStar

		bars.PostUpdate = UF.PostUpdateClassPower
		self.ClassPower = bars
	end
end

function UF.PostUpdateStaggerBarColor(element)
	local cur = element.cur or 0
	local max = element.max or 1
	local mult = element.bg.multiplier or 1

	if cur and max then
		local r, g, b = B.SmoothColor(cur, max, true)
		element:SetStatusBarColor(r, g, b)
		element.bg:SetVertexColor(r*mult, g*mult, b*mult)
	end
end

function UF:StaggerBar(self)
	if DB.MyClass ~= "MONK" then return end

	local stagger = B.CreateSB(self)
	stagger:SetSize(barWidth, barHeight)
	stagger:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, C.margin)
	B.SmoothSB(stagger)

	local text = B.CreateFS(stagger, 14)
	text:SetJustifyH("CENTER")
	self:Tag(text, "[stagger]")

	stagger.bg:SetAlpha(1)
	stagger.bg.multiplier = .25

	self.Stagger = stagger
	self.Stagger.PostUpdateColor = UF.PostUpdateStaggerBarColor
end

function UF.PostUpdateAddPower(element, cur, max)
	if element.Text and max > 0 then
		local per = B.ColorText(cur/max * 100)
		element.Text:SetText(per)
	end
end

function UF:CreateAddPower(self)
	local bar = B.CreateSB(self)
	bar:SetPoint("TOPLEFT", self.Power, "BOTTOMLEFT", 0, -C.margin)
	bar:SetPoint("TOPRIGHT", self.Power, "BOTTOMRIGHT", 0, -C.margin)
	bar:SetHeight(barHeight)
	B.SmoothSB(bar)

	bar.bg:SetAlpha(1)
	bar.bg.multiplier = .25
	bar.colorPower = true

	local text = B.CreateFS(bar, 12)

	self.AdditionalPower = bar
	self.AdditionalPower.Text = text
	self.AdditionalPower.PostUpdate = UF.PostUpdateAddPower
	self.AdditionalPower.displayPairs = {
		["DRUID"] = {
			[1] = true,
			[3] = true,
			[8] = true,
		},
		["SHAMAN"] = {
			[11] = true,
		},
		["PRIEST"] = {
			[13] = true,
		}
	}
end

function UF.PostUpdateAltPower(element, _, cur, _, max)
	if cur and max then
		local r, g, b = B.SmoothColor(cur, max, true)
		element:SetStatusBarColor(r, g, b)
	end
end

function UF:CreateAltPower(self)
	local bar = B.CreateSB(self)
	bar:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, C.margin)
	bar:SetPoint("BOTTOMRIGHT", self, "TOPRIGHT", 0, C.margin)
	bar:SetHeight(barHeight)
	B.SmoothSB(bar)

	local text = B.CreateFS(bar, 14)
	text:SetJustifyH("CENTER")
	self:Tag(text, "[altpower]")

	self.AlternativePower = bar
	self.AlternativePower.PostUpdate = UF.PostUpdateAltPower
end

function UF:CreateExpRepBar(self)
	local bar = B.CreateSB(self)
	bar:SetPoint("TOPLEFT", self, "TOPRIGHT", 5, 0)
	bar:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 10, 0)
	bar:SetOrientation("VERTICAL")
	B.SmoothSB(bar)

	local rest = CreateFrame("StatusBar", nil, bar)
	rest:SetAllPoints(bar)
	rest:SetStatusBarTexture(DB.normTex)
	rest:SetStatusBarColor(0, .4, 1, .6)
	rest:SetOrientation("VERTICAL")
	bar.restBar = rest

	B:GetModule("Misc"):SetupScript(bar)
end

function UF:CreatePrediction(self)
	local frame = B.CreateParentFrame(self, 0)

	local mhpb = frame:CreateTexture(nil, "BORDER", nil, 5)
	mhpb:SetWidth(C.mult)
	mhpb:SetTexture(DB.normTex)
	mhpb:SetVertexColor(0, 1, .5, .5)

	local ohpb = frame:CreateTexture(nil, "BORDER", nil, 5)
	ohpb:SetWidth(C.mult)
	ohpb:SetTexture(DB.normTex)
	ohpb:SetVertexColor(0, 1, 0, .5)

	local abb = frame:CreateTexture(nil, "BORDER", nil, 5)
	abb:SetWidth(C.mult)
	abb:SetTexture(DB.normTex)
	abb:SetVertexColor(.5, 1, 1, .5)

	local abbo = frame:CreateTexture(nil, "ARTWORK", nil, 1)
	abbo:SetAllPoints(abb)
	abbo:SetTexture("Interface\\RaidFrame\\Shield-Overlay", true, true)
	abbo.tileSize = 32

	local oag = frame:CreateTexture(nil, "ARTWORK", nil, 1)
	oag:SetWidth(15)
	oag:SetTexture("Interface\\RaidFrame\\Shield-Overshield")
	oag:SetBlendMode("ADD")
	oag:SetAlpha(.5)
	oag:SetPoint("TOPLEFT", self.Health, "TOPRIGHT", -5, 2)
	oag:SetPoint("BOTTOMLEFT", self.Health, "BOTTOMRIGHT", -5, -2)

	local hab = CreateFrame("StatusBar", nil, frame)
	hab:SetPoint("TOPLEFT", self.Health)
	hab:SetPoint("BOTTOMRIGHT", self.Health:GetStatusBarTexture())
	hab:SetReverseFill(true)
	hab:SetStatusBarTexture(DB.normTex)
	hab:SetStatusBarColor(0, .5, .8, .5)

	local ohg = frame:CreateTexture(nil, "ARTWORK", nil, 1)
	ohg:SetWidth(15)
	ohg:SetTexture("Interface\\RaidFrame\\Absorb-Overabsorb")
	ohg:SetBlendMode("ADD")
	ohg:SetAlpha(.5)
	ohg:SetPoint("TOPRIGHT", self.Health, "TOPLEFT", 5, 2)
	ohg:SetPoint("BOTTOMRIGHT", self.Health, "BOTTOMLEFT", 5, -2)

	self.HealPredictionAndAbsorb = {
		myBar = mhpb,
		otherBar = ohpb,
		absorbBar = abb,
		absorbBarOverlay = abbo,
		overAbsorbGlow = oag,
		healAbsorbBar = hab,
		overHealAbsorbGlow = ohg,
		maxOverflow = 1,
	}

	self.predicFrame = frame
end

function UF:CreateSwing(self)
	if not C.db["UFs"]["Castbars"] then return end

	local bar = CreateFrame("StatusBar", nil, self)
	local width = C.db["UFs"]["PlayerCBWidth"] - C.db["UFs"]["PlayerCBHeight"] - 5
	bar:SetSize(width, 3)
	bar:SetPoint("TOP", self.Castbar.mover, "BOTTOM", 0, -5)

	local two = B.CreateSB(bar, true, .8, .8, .8)
	two:Hide()
	two:SetAllPoints()

	local main = B.CreateSB(bar, true, .8, .8, .8)
	main:Hide()
	main:SetAllPoints()

	local off = B.CreateSB(bar, true, .8, .8, .8)
	off:Hide()
	off:SetPoint("TOPLEFT", bar, "BOTTOMLEFT", 0, -3)
	off:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", 0, -6)

	if C.db["UFs"]["SwingTimer"] then
		bar.Text = B.CreateFS(bar, 12)
		bar.TextMH = B.CreateFS(main, 12)
		bar.TextOH = B.CreateFS(off, 12, "", false, "CENTER", 1, -5)
	end

	self.Swing = bar
	self.Swing.Twohand = two
	self.Swing.Mainhand = main
	self.Swing.Offhand = off
	self.Swing.hideOoc = true
end

function UF:CreateQuakeTimer(self)
	if not C.db["UFs"]["Castbars"] then return end

	local bar = B.CreateSB(self, true, 0, 1, 0)
	bar:SetSize(C.db["UFs"]["PlayerCBWidth"], C.db["UFs"]["PlayerCBHeight"])
	bar:Hide()

	bar.SpellName = B.CreateFS(bar, 12, "", false, "LEFT", 2, 0)
	bar.Text = B.CreateFS(bar, 12, "", false, "RIGHT", -2, 0)
	createBarMover(bar, L["QuakeTimer"], "QuakeTimer", {"BOTTOM", UIParent, "BOTTOM", 0, 200})

	local icon = bar:CreateTexture(nil, "ARTWORK")
	icon:SetSize(bar:GetHeight(), bar:GetHeight())
	icon:SetPoint("RIGHT", bar, "LEFT", -C.margin, 0)
	B.ReskinIcon(icon)
	bar.Icon = icon

	self.QuakeTimer = bar
end

function UF:CreateFCT(self)
	if not C.db["UFs"]["CombatText"] then return end

	local parentFrame = B.CreateParentFrame(UIParent)
	local fcf = CreateFrame("Frame", "oUF_CombatTextFrame", parentFrame)
	fcf:SetSize(32, 32)

	B.Mover(fcf, L["CombatText"], "TargetCombatText", {"BOTTOM", self, "TOP", 0, 150})

	for i = 1, 36 do
		fcf[i] = parentFrame:CreateFontString("$parentText", "OVERLAY")
	end

	fcf.font = DB.Font[1]
	fcf.fontFlags = DB.Font[3]
	fcf.abbreviateNumbers = true
	self.FloatingCombatFeedback = fcf

	-- Default CombatText
	SetCVar("enableFloatingCombatText", 0)
	B.HideOption(InterfaceOptionsCombatPanelEnableFloatingCombatText)
end

function UF:CreatePVPClassify(self)
	local bu = self:CreateTexture(nil, "ARTWORK")
	bu:SetSize(30, 30)
	bu:SetPoint("LEFT", self, "RIGHT", 5, -2)

	self.PvPClassificationIndicator = bu
end

local function updatePartySync(self)
	local hasJoined = C_QuestSession.HasJoined()
	if (hasJoined) then
		self.QuestSyncIndicator:Show()
	else
		self.QuestSyncIndicator:Hide()
	end
end

function UF:CreateQuestSync(self)
	local sync = self:CreateTexture(nil, "OVERLAY")
	sync:SetPoint("CENTER", self, "BOTTOMLEFT", 16, 0)
	sync:SetSize(28, 28)
	sync:SetAtlas("QuestSharing-DialogIcon")
	sync:Hide()

	self.QuestSyncIndicator = sync
	self:RegisterEvent("QUEST_SESSION_LEFT", updatePartySync, true)
	self:RegisterEvent("QUEST_SESSION_JOINED", updatePartySync, true)
	self:RegisterEvent("PLAYER_ENTERING_WORLD", updatePartySync, true)
end