local _, ns = ...
local B, C, L, DB = unpack(ns)

local oUF = ns.oUF or oUF
local UF = B:RegisterModule("UnitFrames")
local format, floor, abs = string.format, math.floor, math.abs
local pairs, next = pairs, next

-- Custom colors
oUF.colors.smooth = {1, 0, 0, .85, .8, .45, .1, .1, .1}
oUF.colors.power.MANA = {0, .4, 1}
oUF.colors.power.SOUL_SHARDS = {.58, .51, .79}
oUF.colors.power.HOLY_POWER = {.88, .88, .06}
oUF.colors.power.CHI = {0, 1, .59}
oUF.colors.power.ARCANE_CHARGES = {.41, .8, .94}

-- Various values
local function retVal(self, val1, val2, val3, val4, val5)
	local mystyle = self.mystyle
	if mystyle == "player" or mystyle == "target" then
		return val1
	elseif mystyle == "focus" or mystyle == "party" then
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
	self:HookScript("OnEnter", function()
		UnitFrame_OnEnter(self)
		self.Highlight:Show()
	end)
	self:HookScript("OnLeave", function()
		UnitFrame_OnLeave(self)
		self.Highlight:Hide()
	end)
end

function UF:CreateHealthBar(self)
	local mystyle = self.mystyle
	local specialStyle = mystyle == "raid" or mystyle == "party"

	local health = CreateFrame("StatusBar", nil, self)
	health:SetAllPoints()
	health:SetFrameLevel(self:GetFrameLevel() - 2)
	B.SmoothBar(health)

	local bg = B.CreateSB(health, false, .1, .1, .1)
	bg:SetVertexColor(.6, .6, .6, 1)
	bg.multiplier = .25

	local healthHeight
	if mystyle == "PlayerPlate" then
		healthHeight = NDuiDB["Nameplate"]["PPHeight"]
	elseif mystyle == "raid" then
		if NDuiDB["UFs"]["SimpleMode"] then
			local scale = NDuiDB["UFs"]["SimpleRaidScale"]/10
			healthHeight = 20*scale - 2*scale - C.mult
		else
			healthHeight = NDuiDB["UFs"]["RaidHeight"]
		end
	elseif mystyle == "party" then
		healthHeight = NDuiDB["UFs"]["PartyHeight"]
	elseif mystyle == "partypet" then
		healthHeight = NDuiDB["UFs"]["PartyPetHeight"]
	else
		healthHeight = retVal(self, NDuiDB["UFs"]["PlayerHeight"], NDuiDB["UFs"]["FocusHeight"], NDuiDB["UFs"]["BossHeight"], NDuiDB["UFs"]["PetHeight"])
	end

	if mystyle == "PlayerPlate" then
		health.colorHealth = true
	elseif (specialStyle and NDuiDB["UFs"]["RaidHPColor"] == 2) or (not specialStyle and NDuiDB["UFs"]["UFsHPColor"] == 2) then
		health.colorClass = true
		health.colorTapping = true
		health.colorReaction = true
		health.colorDisconnected = true
	elseif (specialStyle and NDuiDB["UFs"]["RaidHPColor"] == 3) or (not specialStyle and NDuiDB["UFs"]["UFsHPColor"] == 3) then
		health.colorSmooth = true
	end

	health:SetHeight(healthHeight)
	health.bd.Tex:Hide()
	self.Health = health
end

function UF:CreateHealthText(self)
	local mystyle = self.mystyle
	local minorStyle = mystyle ~= "pet" and mystyle ~= "tot" and mystyle ~= "fot"

	local textFrame = CreateFrame("Frame", nil, self)
	textFrame:SetAllPoints(self.Health)

	local name = B.CreateFS(textFrame, retVal(self, 13, 12, 12, 12, NDuiDB["Nameplate"]["NameTextSize"]), "", false, "LEFT", 3, 0)
	name:SetJustifyH("LEFT")

	if mystyle == "raid" then
		name:SetWidth(self:GetWidth()*.95)
		name:ClearAllPoints()
		if NDuiDB["UFs"]["SimpleMode"] then
			name:SetWidth(self:GetWidth()*.65)
			name:SetPoint("LEFT", 4, 0)
		elseif NDuiDB["UFs"]["RaidBuffIndicator"] then
			name:SetJustifyH("CENTER")
			if NDuiDB["UFs"]["RaidHPMode"] ~= 1 then
				name:SetPoint("TOP", 0, -3)
			else
				name:SetPoint("CENTER")
			end
		else
			name:SetPoint("TOPLEFT", 2, -2)
		end
	elseif mystyle == "nameplate" then
		name:SetWidth(self:GetWidth()*.85)
		name:ClearAllPoints()
		name:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, 5)
	elseif minorStyle then
		name:SetWidth(self:GetWidth()*.95)
		name:ClearAllPoints()
		name:SetPoint("TOPLEFT", 0, -3)
	else
		name:SetWidth(self:GetWidth()*.55)
	end

	if mystyle == "player" then
		self:Tag(name, " [color][name]")
	elseif mystyle == "target" or mystyle == "party" then
		self:Tag(name, "[fulllevel] [color][name][flag]")
	elseif mystyle == "focus" then
		self:Tag(name, "[color][name][flag]")
	elseif mystyle == "nameplate" then
		self:Tag(name, "[nplv][name]")
	elseif mystyle == "arena" then
		self:Tag(name, "[arenaspec] [color][name]")
	else
		self:Tag(name, "[color][name]")
	end

	local hpval = B.CreateFS(textFrame, retVal(self, 14, 13, 13, 13, NDuiDB["Nameplate"]["HealthTextSize"]), "", false, "RIGHT", -3, 0)
	hpval:SetJustifyH("RIGHT")
	if mystyle == "raid" then
		hpval:ClearAllPoints()
		if NDuiDB["UFs"]["SimpleMode"] then
			hpval:SetPoint("RIGHT", -4, 0)
		elseif NDuiDB["UFs"]["RaidBuffIndicator"] then
			hpval:SetPoint("BOTTOM", 0, 1)
			hpval:SetJustifyH("CENTER")
		else
			hpval:SetPoint("BOTTOMRIGHT", -2, 2)
		end
		self:Tag(hpval, "[raidhp]")
	elseif mystyle == "nameplate" then
		hpval:ClearAllPoints()
		hpval:SetPoint("RIGHT", self, 0, 5)
		self:Tag(hpval, "[nphp]")
	elseif minorStyle then
		hpval:ClearAllPoints()
		hpval:SetPoint("BOTTOMRIGHT", 0, 3)
		self:Tag(hpval, "[health]")
	else
		self:Tag(hpval, "[health]")
	end

	self.nameText = name
	self.healthValue = hpval
end

function UF:UpdateRaidNameText()
	for _, frame in pairs(oUF.objects) do
		if frame.mystyle == "raid" then
			local name = frame.nameText
			name:ClearAllPoints()
			if NDuiDB["UFs"]["SimpleMode"] then
				name:SetPoint("LEFT", 4, 0)
			elseif NDuiDB["UFs"]["RaidBuffIndicator"] then
				name:SetJustifyH("CENTER")
				if NDuiDB["UFs"]["RaidHPMode"] ~= 1 then
					name:SetPoint("TOP", 0, -3)
				else
					name:SetPoint("CENTER")
				end
			else
				name:SetPoint("TOPLEFT", 2, -2)
			end
			frame.healthValue:UpdateTag()
		end
	end
end

function UF:CreatePowerBar(self)
	local mystyle = self.mystyle
	local specialStyle = mystyle == "raid" or mystyle == "party"

	local power = CreateFrame("StatusBar", nil, self)
	power:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, -3)
	power:SetPoint("TOPRIGHT", self, "BOTTOMRIGHT", 0, -3)
	power:SetFrameLevel(self:GetFrameLevel() - 2)
	B.SmoothBar(power)

	local bg = B.CreateSB(power)
	bg:SetAlpha(1)
	bg.multiplier = .25

	local powerHeight
	if mystyle == "PlayerPlate" then
		powerHeight = NDuiDB["Nameplate"]["PPHeight"]
	elseif mystyle == "raid" then
		if NDuiDB["UFs"]["SimpleMode"] then
			powerHeight = 2*NDuiDB["UFs"]["SimpleRaidScale"]/10
		else
			powerHeight = NDuiDB["UFs"]["RaidPowerHeight"]
		end
	elseif mystyle == "party" then
		powerHeight = NDuiDB["UFs"]["PartyPowerHeight"]
	elseif mystyle == "partypet" then
		powerHeight = NDuiDB["UFs"]["PartyPetPowerHeight"]
	else
		powerHeight = retVal(self, NDuiDB["UFs"]["PlayerPowerHeight"], NDuiDB["UFs"]["FocusPowerHeight"], NDuiDB["UFs"]["BossPowerHeight"], NDuiDB["UFs"]["PetPowerHeight"])
	end

	if (specialStyle and NDuiDB["UFs"]["RaidHPColor"] == 2) or (not specialStyle and NDuiDB["UFs"]["UFsHPColor"] == 2) or mystyle == "PlayerPlate" then
		power.colorPower = true
	else
		power.colorClass = true
		power.colorTapping = true
		power.colorDisconnected = true
		power.colorReaction = true
	end
	power.frequentUpdates = true

	power:SetHeight(powerHeight)
	power.bd.Tex:Hide()
	self.Power = power
end

function UF:CreatePowerText(self)
	local textFrame = CreateFrame("Frame", nil, self)
	textFrame:SetAllPoints(self.Power)

	local ppval = B.CreateFS(textFrame, retVal(self, 13, 12, 12, 12), "", false, "RIGHT", -3, 0)
	self:Tag(ppval, "[color][power]")

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
	["party"] = true,
}
function UF:UpdateTextScale()
	local scale = NDuiDB["UFs"]["UFTextScale"]
	for _, frame in pairs(oUF.objects) do
		local style = frame.mystyle
		if style and textScaleFrames[style] then
			frame.nameText:SetScale(scale)
			frame.healthValue:SetScale(scale)
			if frame.powerText then frame.powerText:SetScale(scale) end
		end
	end
end

function UF:CreatePortrait(self)
	if not NDuiDB["UFs"]["Portrait"] then return end
	if (self.mystyle == "party" and NDuiDB["UFs"]["RaidHPColor"] > 1) or (self.mystyle ~= "party" and NDuiDB["UFs"]["UFsHPColor"] > 1) then return end

	local portrait = CreateFrame("PlayerModel", nil, self.Health)
	portrait:SetAllPoints()
	portrait:SetAlpha(.25)
	self.Portrait = portrait

	self.Health.bg:ClearAllPoints()
	self.Health.bg:SetPoint("BOTTOMLEFT", self.Health:GetStatusBarTexture(), "BOTTOMRIGHT", 0, 0)
	self.Health.bg:SetPoint("TOPRIGHT", self.Health)
	self.Health.bg:SetParent(self)
end

local roleTexCoord = {
	["TANK"] = {.5, .75, 0, 1},
	["HEALER"] = {.75, 1, 0, 1},
	["DAMAGER"] = {.25, .5, 0, 1},
}
local function postUpdateRole(element, role)
	if element:IsShown() then
		element:SetTexCoord(unpack(roleTexCoord[role]))
	end
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
		resting:SetTexture("Interface\\PLAYERFRAME\\DruidEclipse")
		resting:SetTexCoord(.445, .55, .648, .905)
		resting:SetVertexColor(.6, .8, 1)
		self.RestingIndicator = resting
	elseif mystyle == "target" then
		local quest = self:CreateTexture(nil, "OVERLAY")
		quest:SetPoint("TOPLEFT", self, 0, 8)
		quest:SetSize(16, 16)
		self.QuestIndicator = quest
	end

	local phase = self:CreateTexture(nil, "OVERLAY")
	phase:SetPoint("TOP", self, 0, 12)
	phase:SetSize(22, 22)
	self.PhaseIndicator = phase

	local groupRole = self:CreateTexture(nil, "OVERLAY")
	groupRole:SetPoint("TOPRIGHT", self, 0, 8)
	groupRole:SetSize(12, 12)
	groupRole:SetTexture("Interface\\LFGFrame\\LFGROLE")
	groupRole.PostUpdate = postUpdateRole
	self.GroupRoleIndicator = groupRole

	local leader = self:CreateTexture(nil, "OVERLAY")
	leader:SetPoint("RIGHT", self.GroupRoleIndicator, "LEFT")
	leader:SetSize(12, 12)
	self.LeaderIndicator = leader

	local assistant = self:CreateTexture(nil, "OVERLAY")
	assistant:SetPoint("RIGHT", self.GroupRoleIndicator, "LEFT")
	assistant:SetSize(12, 12)
	self.AssistantIndicator = assistant
end

function UF:CreateRaidMark(self)
	local mystyle = self.mystyle
	local raidTarget = self:CreateTexture(nil, "OVERLAY")

	if self.LeaderIndicator and mystyle ~= "raid" then
		raidTarget:SetPoint("RIGHT", self.LeaderIndicator, "LEFT", -2, 0)
	elseif mystyle == "nameplate" then
		raidTarget:SetPoint("RIGHT", self, "TOPLEFT", -5, 0)
	else
		raidTarget:SetPoint("BOTTOM", self, "TOP", 0, -2)
	end

	local size = retVal(self, 14, 13, 12, 12, 28)
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
	if mystyle ~= "nameplate" and not NDuiDB["UFs"]["Castbars"] then return end

	local cb = CreateFrame("StatusBar", "oUF_Castbar"..mystyle, self)
	B.CreateSB(cb, true)

	if mystyle == "player" then
		cb:SetSize(NDuiDB["UFs"]["PlayerCBWidth"], NDuiDB["UFs"]["PlayerCBHeight"])
		createBarMover(cb, L["Player Castbar"], "PlayerCB", C.UFs.Playercb)
	elseif mystyle == "target" then
		cb:SetSize(NDuiDB["UFs"]["TargetCBWidth"], NDuiDB["UFs"]["TargetCBHeight"])
		createBarMover(cb, L["Target Castbar"], "TargetCB", C.UFs.Targetcb)
	elseif mystyle == "focus" then
		cb:SetSize(NDuiDB["UFs"]["FocusCBWidth"], NDuiDB["UFs"]["FocusCBHeight"])
		createBarMover(cb, L["Focus Castbar"], "FocusCB", C.UFs.Focuscb)
	elseif mystyle == "boss" or mystyle == "arena" then
		cb:SetPoint("TOPRIGHT", self.Power, "BOTTOMRIGHT", 0, -3)
		cb:SetSize(self:GetWidth(), 10)
	elseif mystyle == "nameplate" then
		cb:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, -5)
		cb:SetPoint("TOPRIGHT", self, "BOTTOMRIGHT", 0, -5)
		cb:SetHeight(self:GetHeight())
	end

	local timer = B.CreateFS(cb, retVal(self, 12, 12, 12, 12), "", false, "RIGHT", -2, 0)
	local name = B.CreateFS(cb, retVal(self, 12, 12, 12, 12), "", false, "LEFT", 2, 0)
	name:SetPoint("RIGHT", timer, "LEFT", -5, 0)
	name:SetJustifyH("LEFT")

	if mystyle ~= "boss" and mystyle ~= "arena" then
		cb.Icon = cb:CreateTexture(nil, "ARTWORK")
		cb.Icon:SetSize(cb:GetHeight(), cb:GetHeight())
		cb.Icon:SetPoint("BOTTOMRIGHT", cb, "BOTTOMLEFT", -3, 0)
		B.ReskinIcon(cb.Icon)
	end

	if mystyle == "player" then
		local safe = cb:CreateTexture(nil,"OVERLAY")
		safe:SetTexture(DB.normTex)
		safe:SetVertexColor(1, 0, 0, .6)
		safe:SetAllPoints()
		cb:SetFrameLevel(10)
		cb.SafeZone = safe

		if NDuiDB["UFs"]["LagString"] then
			local lag = B.CreateFS(cb, 10, "", false, "CENTER", -6, 17)
			cb.Lag = lag
			self:RegisterEvent("CURRENT_SPELL_CAST_CHANGED", B.OnCastSent, true)
		end
	elseif mystyle == "nameplate" then
		name:SetPoint("LEFT", cb, 0, -5)
		timer:SetPoint("RIGHT", cb, 0, -5)

		local shield = cb:CreateTexture(nil, "OVERLAY")
		shield:SetAtlas("nameplates-InterruptShield")
		shield:SetSize(18, 18)
		shield:SetPoint("CENTER", 0, -5)
		cb.Shield = shield

		local iconSize = self:GetHeight()*2 + 5
		cb.Icon:SetSize(iconSize, iconSize)
		cb.Icon:SetPoint("BOTTOMRIGHT", cb, "BOTTOMLEFT", -5, 0)
		cb.timeToHold = .5
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
	cb.PostChannelStart = B.PostCastStart
	cb.PostCastStop = B.PostCastStop
	cb.PostChannelStop = B.PostChannelStop
	cb.PostCastFailed = B.PostCastFailed
	cb.PostCastInterrupted = B.PostCastFailed
	cb.PostCastInterruptible = B.PostUpdateInterruptible
	cb.PostCastNotInterruptible = B.PostUpdateInterruptible

	self.Castbar = cb
end

local function reskinTimerBar(bar)
	bar:SetSize(280, 17)
	B.StripTextures(bar)

	local statusbar = _G[bar:GetName().."StatusBar"]
	if statusbar then
		statusbar:SetAllPoints()
		statusbar:SetStatusBarTexture(DB.normTex)
	else
		bar:SetStatusBarTexture(DB.normTex)
	end

	B.CreateBDFrame(bar, .25)
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
	local fontSize = element.fontSize or element.size*.6
	local parentFrame = CreateFrame("Frame", nil, button)
	parentFrame:SetAllPoints()
	parentFrame:SetFrameLevel(button:GetFrameLevel() + 3)
	button.count = B.CreateFS(parentFrame, fontSize, "", false, "BOTTOMRIGHT", 4, -4)
	button.cd:SetReverse(true)

	button.HL = button:CreateTexture(nil, "HIGHLIGHT")
	button.HL:SetColorTexture(1, 1, 1, .25)
	button.HL:SetAllPoints()

	button.overlay:SetTexture(nil)
	button.stealable:SetTexture(nil)

	button.glowFrame = B.CreateGlowFrame(button, element.size)
	button.bd = B.ReskinIcon(button.icon)

	if element.disableCooldown then button.timer = B.CreateFS(button, 12) end
end

local filteredStyle = {
	["target"] = true,
	["nameplate"] = true,
	["boss"] = true,
	["arena"] = true,
}

function UF.PostUpdateIcon(element, _, button, _, _, duration, expiration, debuffType)
	if duration then button.bd:Show() end

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

	if style == "raid" and NDuiDB["UFs"]["RaidBuffIndicator"] then
		button.bd:SetBackdropBorderColor(1, 0, 0)
	elseif element.showDebuffType and button.isDebuff then
		local color = oUF.colors.debuff[debuffType] or oUF.colors.debuff.none
		button.bd:SetBackdropBorderColor(color[1], color[2], color[3])
	else
		button.bd:SetBackdropBorderColor(0, 0, 0)
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
	if icon.bd and icon.bd:IsShown() then
		icon.bd:Hide()
	end

	if icon.glowFrame then
		B.HideOverlayGlow(icon.glowFrame)
	end
end

function UF.CustomFilter(element, unit, button, name, _, _, _, _, _, caster, isStealable, _, spellID, _, _, _, nameplateShowAll)
	local style = element.__owner.mystyle
	if name and spellID == 209859 then
		element.bolster = element.bolster + 1
		if not element.bolsterIndex then
			element.bolsterIndex = button
			return true
		end
	elseif style == "raid" or style == "party" then
		if NDuiDB["UFs"]["RaidBuffIndicator"] then
			return C.RaidBuffs["ALL"][spellID] or NDuiADB["RaidAuraWatch"][spellID]
		else
			return (button.isPlayer or caster == "pet") and NDuiADB["CornerBuffs"][DB.MyClass][spellID] or C.RaidBuffs["ALL"][spellID] or C.RaidBuffs["WARNING"][spellID]
		end
	elseif style == "nameplate" or style == "boss" or style == "arena" or style == "focus" then
		if NDuiADB["NameplateFilter"][2][spellID] or C.BlackList[spellID] then
			return false
		elseif element.showStealableBuffs and isStealable and not UnitIsPlayer(unit) then
			return true
		elseif NDuiADB["NameplateFilter"][1][spellID] or C.WhiteList[spellID] then
			return true
		else
			return nameplateShowAll or (caster == "player" or caster == "pet" or caster == "vehicle")
		end
	elseif (element.onlyShowPlayer and button.isPlayer) or (not element.onlyShowPlayer and name) then
		return true
	end
end

local function auraIconSize(w, n, s)
	return (w-(n-1)*s)/n
end

local function auraSetSize(self, bu)
	local width = self:GetWidth()
	local maxAuras = bu.num or bu.numTotal or (bu.numBuffs + bu.numDebuffs)
	local maxLines = bu.iconsPerRow and floor(maxAuras/bu.iconsPerRow + .5) or 1

	bu.size = bu.iconsPerRow and auraIconSize(width, bu.iconsPerRow, bu.spacing) or bu.size
	bu:SetWidth(width)
	bu:SetHeight((bu.size + bu.spacing) * maxLines)
end

function UF:CreateAuras(self)
	local mystyle = self.mystyle
	local bu = CreateFrame("Frame", nil, self)
	bu:SetFrameLevel(self:GetFrameLevel() + 2)
	bu.spacing = 0
	bu.gap = false
	bu.initialAnchor = "BOTTOMLEFT"
	bu["growth-x"] = "RIGHT"
	bu["growth-y"] = "DOWN"
	if mystyle == "target" then
		bu:SetPoint("TOPLEFT", self.Power, "BOTTOMLEFT", 0, -6)
		bu.numBuffs = 22
		bu.numDebuffs = 22
		bu.spacing = 5
		bu.iconsPerRow = 9
		bu.gap = true
		bu.initialAnchor = "TOPLEFT"
	elseif mystyle == "raid" then
		if NDuiDB["UFs"]["RaidBuffIndicator"] then
			bu.initialAnchor = "LEFT"
			bu:SetPoint("LEFT", self, 15, 0)
			bu.size = 18*NDuiDB["UFs"]["SimpleRaidScale"]/10
			bu.numTotal = 1
			bu.disableCooldown = true
		else
			bu:SetPoint("BOTTOMLEFT", self.Health)
			bu.numTotal = NDuiDB["UFs"]["SimpleMode"] and 0 or 6
			bu.iconsPerRow = 6
			bu.spacing = 3
		end
		bu.disableMouse = NDuiDB["UFs"]["AurasClickThrough"]
	elseif mystyle == "nameplate" then
		if NDuiDB["Nameplate"]["ShowPlayerPlate"] and NDuiDB["Nameplate"]["NameplateClassPower"] then
			bu:SetPoint("BOTTOMLEFT", self.nameText, "TOPLEFT", 0, 5 + _G.oUF_ClassPowerBar:GetHeight())
		else
			bu:SetPoint("BOTTOMLEFT", self.nameText, "TOPLEFT", 0, 5)
		end
		bu.numTotal = NDuiDB["Nameplate"]["maxAuras"]
		bu.spacing = 3
		bu.disableMouse = true
		bu.iconsPerRow = NDuiDB["Nameplate"]["AutoPerRow"]
		bu.showDebuffType = NDuiDB["Nameplate"]["ColorBorder"]
		bu["growth-y"] = "UP"
	end

	auraSetSize(self, bu)

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
	bu.spacing = 5
	bu["growth-x"] = "RIGHT"
	bu["growth-y"] = "UP"
	bu.onlyShowPlayer = false

	if self.mystyle == "party" then
		bu:SetPoint("TOPLEFT", self.nameText, "BOTTOMLEFT", 5, 2)
		bu.num = 6
		bu.size = self:GetHeight()*.6
		bu.CustomFilter = UF.CustomFilter
		bu.initialAnchor = "BOTTOMLEFT"
	else
		bu:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, 5)
		bu.num = 12
		bu.iconsPerRow = 6
		bu.initialAnchor = "BOTTOMLEFT"
	end

	auraSetSize(self, bu)

	bu.showStealableBuffs = true
	bu.PostCreateIcon = UF.PostCreateIcon
	bu.PostUpdateIcon = UF.PostUpdateIcon

	self.Buffs = bu
end

function UF:CreateDebuffs(self)
	local mystyle = self.mystyle
	local bu = CreateFrame("Frame", nil, self)
	bu.spacing = 5
	bu.showDebuffType = true
	bu.initialAnchor = "TOPRIGHT"
	bu["growth-x"] = "LEFT"
	bu["growth-y"] = "DOWN"
	if mystyle == "player" then
		bu:SetPoint("TOPRIGHT", self.AdditionalPower, "BOTTOMRIGHT", 0, -6)
		bu.num = 21
		bu.iconsPerRow = 7
	elseif mystyle == "boss" or mystyle == "arena" then
		bu:SetPoint("TOPRIGHT", self, "TOPLEFT", -5, 0)
		bu.num = 10
		bu.size = self:GetHeight()+self.Power:GetHeight()+3
		bu.CustomFilter = UF.CustomFilter
		bu["growth-y"] = "UP"
	elseif mystyle == "tot" then
		bu:SetPoint("TOPRIGHT", self.Power, "BOTTOMRIGHT", 0, -6)
		bu.num = 10
		bu.iconsPerRow = 5
	elseif mystyle == "focus" then
		bu:SetPoint("TOPLEFT", self.Power, "BOTTOMLEFT", 0, -6)
		bu.num = 14
		bu.iconsPerRow = 7
		bu.CustomFilter = UF.CustomFilter
		bu.initialAnchor = "TOPLEFT"
		bu["growth-x"] = "RIGHT"
	elseif mystyle == "party" then
		bu:SetPoint("TOPLEFT", self, "TOPRIGHT", 5, 0)
		bu.num = 10
		bu.size = self:GetHeight()+self.Power:GetHeight()+3
		bu.initialAnchor = "TOPLEFT"
		bu["growth-x"] = "RIGHT"
	end

	auraSetSize(self, bu)

	bu.PostCreateIcon = UF.PostCreateIcon
	bu.PostUpdateIcon = UF.PostUpdateIcon

	self.Debuffs = bu
end

-- Class Powers
local barWidth, barMargin = C.UFs.BarWidth, C.UFs.BarMargin

function UF.PostUpdateClassPower(element, cur, max, diff, powerType)
	if not cur or cur == 0 then
		for i = 1, 6 do
			element[i].bg:Hide()
		end
	else
		for i = 1, max do
			element[i].bg:Show()
		end
	end

	if diff then
		for i = 1, max do
			element[i]:SetWidth((barWidth - (max-1)*barMargin)/max)
		end
		for i = max + 1, 6 do
			element[i].bg:Hide()
		end
	end

	if NDuiDB["Nameplate"]["ShowPlayerPlate"] and NDuiDB["Nameplate"]["MaxPowerGlow"] then
		if (powerType == "COMBO_POINTS" or powerType == "HOLY_POWER") and element.__owner.unit ~= "vehicle" and cur == max then
			for i = 1, 6 do
				if element[i]:IsShown() then
					B.ShowOverlayGlow(element[i].glow)
				end
			end
		else
			for i = 1, 6 do
				B.HideOverlayGlow(element[i].glow)
			end
		end
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
	local barHeight = self.Power:GetHeight()
	if self.mystyle == "PlayerPlate" then
		barWidth, barHeight = self:GetWidth(), NDuiDB["Extras"]["PPCPHeight"]
	end

	local bar = CreateFrame("Frame", "oUF_ClassPowerBar", self.Health)
	bar:SetSize(barWidth, barHeight)
	bar:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, 3)

	local bars = {}
	for i = 1, 6 do
		bars[i] = CreateFrame("StatusBar", nil, bar)
		bars[i]:SetHeight(barHeight)
		bars[i]:SetWidth((barWidth - 5*barMargin) / 6)
		bars[i]:SetFrameLevel(self:GetFrameLevel() + 5)

		if i == 1 then
			bars[i]:SetPoint("LEFT")
		else
			bars[i]:SetPoint("LEFT", bars[i-1], "RIGHT", barMargin, 0)
		end

		local bg = B.CreateSB(bars[i])
		bg.multiplier = .25

		if DB.MyClass == "DEATHKNIGHT" and NDuiDB["UFs"]["RuneTimer"] then
			bars[i].timer = B.CreateFS(bars[i], 13, "", false, "CENTER", .5, 0)
		end

		if NDuiDB["Nameplate"]["ShowPlayerPlate"] then
			bars[i].glow = CreateFrame("Frame", nil, bars[i])
			bars[i].glow:SetPoint("TOPLEFT", -3, 2)
			bars[i].glow:SetPoint("BOTTOMRIGHT", 3, -2)
		end
	end

	if DB.MyClass == "DEATHKNIGHT" then
		bars.colorSpec = true
		bars.sortOrder = "asc"
		bars.PostUpdate = UF.PostUpdateRunes
		self.Runes = bars
	else
		bars.PostUpdate = UF.PostUpdateClassPower
		self.ClassPower = bars
	end
end

function UF:StaggerBar(self)
	if DB.MyClass ~= "MONK" then return end

	local width, height = self:GetWidth()*.6, self.Power:GetHeight()
	if self.mystyle == "PlayerPlate" then
		width, height = self:GetWidth(), NDuiDB["Extras"]["PPCPHeight"]
	end

	local stagger = CreateFrame("StatusBar", nil, self.Health)
	stagger:SetSize(width, height)
	stagger:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, 3)
	stagger:SetFrameLevel(self:GetFrameLevel() + 5)
	B.SmoothBar(stagger)

	local bg = B.CreateSB(stagger)
	bg:SetAlpha(1)
	bg.multiplier = .25

	local text = B.CreateFS(stagger, 13)
	text:SetJustifyH("CENTER")
	self:Tag(text, "[monkstagger]")

	self.Stagger = stagger
end

function UF.PostUpdateAltPower(element, _, cur, _, max)
	if cur and max then
		local v = tonumber(format("%.1f", cur/max))
		local r, g, b = v, 1 - v, 0

		element:SetStatusBarColor(r, g, b)
	end
end

function UF:CreateAltPower(self)
	local bar = CreateFrame("StatusBar", nil, self)
	bar:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, 3)
	bar:SetPoint("BOTTOMRIGHT", self, "TOPRIGHT", 0, 3)
	bar:SetHeight(self.Power:GetHeight())
	B.CreateSB(bar)

	local text = B.CreateFS(bar, 14)
	text:SetJustifyH("CENTER")
	self:Tag(text, "[altpower]")

	self.AlternativePower = bar
	self.AlternativePower.PostUpdate = UF.PostUpdateAltPower
end

function UF:CreateExpRepBar(self)
	local bar = CreateFrame("StatusBar", nil, self)
	bar:SetPoint("TOPRIGHT", self, "TOPLEFT", -5, 0)
	bar:SetPoint("BOTTOMLEFT", self.Power, "BOTTOMLEFT", -10, 0)
	bar:SetOrientation("VERTICAL")
	B.CreateSB(bar)

	local rest = CreateFrame("StatusBar", nil, bar)
	rest:SetAllPoints(bar)
	rest:SetStatusBarTexture(DB.normTex)
	rest:SetStatusBarColor(0, .4, 1, .6)
	rest:SetFrameLevel(bar:GetFrameLevel() - 1)
	rest:SetOrientation("VERTICAL")
	bar.restBar = rest

	B:GetModule("Misc"):SetupScript(bar)
end

function UF:CreatePrediction(self)
	local mhpb = self:CreateTexture(nil, "BORDER", nil, 5)
	mhpb:SetWidth(1)
	mhpb:SetTexture(DB.normTex)
	mhpb:SetVertexColor(0, 1, .5, .5)

	local ohpb = self:CreateTexture(nil, "BORDER", nil, 5)
	ohpb:SetWidth(1)
	ohpb:SetTexture(DB.normTex)
	ohpb:SetVertexColor(0, 1, 0, .5)

	local abb = self:CreateTexture(nil, "BORDER", nil, 5)
	abb:SetWidth(1)
	abb:SetTexture(DB.normTex)
	abb:SetVertexColor(.66, 1, 1, .7)

	local abbo = self:CreateTexture(nil, "ARTWORK", nil, 1)
	abbo:SetAllPoints(abb)
	abbo:SetTexture("Interface\\RaidFrame\\Shield-Overlay", true, true)
	abbo.tileSize = 32

	local oag = self:CreateTexture(nil, "ARTWORK", nil, 1)
	oag:SetWidth(4)
	oag:SetAlpha(.5)
	oag:SetTexture(DB.normTex)
	oag:SetBlendMode("ADD")
	oag:SetVertexColor(0, 1, 1)
	oag:SetPoint("TOPLEFT", self.Health.bd, "TOPRIGHT", -2, 0)
	oag:SetPoint("BOTTOMLEFT", self.Health.bd, "BOTTOMRIGHT", -2, 0)

	local hab = CreateFrame("StatusBar", nil, self)
	hab:SetPoint("TOP")
	hab:SetPoint("BOTTOM")
	hab:SetPoint("RIGHT", self.Health:GetStatusBarTexture())
	hab:SetWidth(self.Health:GetWidth())
	hab:SetReverseFill(true)
	hab:SetStatusBarTexture(DB.normTex)
	hab:SetStatusBarColor(0, .5, .8, .5)

	local ohg = self:CreateTexture(nil, "ARTWORK", nil, 1)
	ohg:SetWidth(4)
	ohg:SetAlpha(.5)
	ohg:SetTexture(DB.normTex)
	ohg:SetBlendMode("ADD")
	ohg:SetVertexColor(0, 1, 1)
	ohg:SetPoint("TOPLEFT", self.Health.bd, "TOPRIGHT", -2, 0)
	ohg:SetPoint("BOTTOMLEFT", self.Health.bd, "BOTTOMRIGHT", -2, 0)

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
end

function UF.PostUpdateAddPower(element, _, cur, max)
	if element.Text and max > 0 then
		local perc = cur/max * 100
		if perc == 100 then
			perc = ""
			element:SetAlpha(0)
		else
			perc = format("%.1f%%", perc)
			element:SetAlpha(1)
		end
		element.Text:SetText(perc)
	end
end

function UF:CreateAddPower(self)
	local bar = CreateFrame("StatusBar", nil, self)
	bar:SetPoint("TOPLEFT", self.Power, "BOTTOMLEFT", 0, -3)
	bar:SetPoint("TOPRIGHT", self.Power, "BOTTOMRIGHT", 0, -3)
	bar:SetHeight(self.Power:GetHeight())
	B.SmoothBar(bar)
	bar.colorPower = true

	local bg = B.CreateSB(bar)
	bg:SetAlpha(1)
	bg.multiplier = .25

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

function UF:CreateSwing(self)
	if not NDuiDB["UFs"]["Castbars"] then return end

	local bar = CreateFrame("StatusBar", nil, self)
	local width = NDuiDB["UFs"]["PlayerCBWidth"] - NDuiDB["UFs"]["PlayerCBHeight"] - 5
	bar:SetSize(width, 5)
	bar:SetPoint("TOP", self.Castbar.mover, "BOTTOM", 0, -5)

	local two = CreateFrame("StatusBar", nil, bar)
	two:Hide()
	two:SetAllPoints()
	B.CreateSB(two, true)

	local main = CreateFrame("StatusBar", nil, bar)
	main:Hide()
	main:SetAllPoints()
	B.CreateSB(main, true)

	local off = CreateFrame("StatusBar", nil, bar)
	off:Hide()
	off:SetPoint("TOPLEFT", bar, "BOTTOMLEFT", 0, -3)
	off:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", 0, -6)
	B.CreateSB(off, true)

	if NDuiDB["UFs"]["SwingTimer"] then
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
	if not NDuiDB["UFs"]["Castbars"] then return end

	local bar = CreateFrame("StatusBar", nil, self)
	bar:SetSize(NDuiDB["UFs"]["PlayerCBWidth"], NDuiDB["UFs"]["PlayerCBHeight"])
	B.CreateSB(bar, true, 0, 1, 0)

	bar.SpellName = B.CreateFS(bar, 12, "", false, "LEFT", 2, 0)
	bar.Text = B.CreateFS(bar, 12, "", false, "RIGHT", -2, 0)
	createBarMover(bar, L["QuakeTimer"], "QuakeTimer", {"BOTTOM", UIParent, "BOTTOM", 0, 180})

	local icon = bar:CreateTexture(nil, "ARTWORK")
	icon:SetSize(bar:GetHeight(), bar:GetHeight())
	icon:SetPoint("RIGHT", bar, "LEFT", -3, 0)
	B.ReskinIcon(icon)
	bar.Icon = icon

	self.QuakeTimer = bar
end

function UF:CreateFCT(self)
	if not NDuiDB["UFs"]["CombatText"] then return end

	local parentFrame = CreateFrame("Frame", nil, UIParent)
	local fcf = CreateFrame("Frame", "oUF_CombatTextFrame", parentFrame)
	fcf:SetSize(32, 32)

	if self.mystyle == "player" then
		B.Mover(fcf, L["CombatText"], "PlayerCombatText", {"BOTTOM", self, "TOPLEFT", 0, 120})
	else
		B.Mover(fcf, L["CombatText"], "TargetCombatText", {"BOTTOM", self, "TOPRIGHT", 0, 120})
	end

	for i = 1, 36 do
		fcf[i] = parentFrame:CreateFontString("$parentText", "OVERLAY")
	end

	fcf.font = DB.Font[1]
	fcf.fontFlags = DB.Font[3]
	fcf.showPets = NDuiDB["UFs"]["PetCombatText"]
	fcf.showHots = NDuiDB["UFs"]["HotsDots"]
	fcf.showAutoAttack = NDuiDB["UFs"]["AutoAttack"]
	fcf.showOverHealing = NDuiDB["UFs"]["FCTOverHealing"]
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