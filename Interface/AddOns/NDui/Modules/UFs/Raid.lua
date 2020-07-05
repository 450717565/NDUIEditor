local _, ns = ...
local B, C, L, DB = unpack(ns)
local oUF = ns.oUF or oUF
local UF = B:GetModule("UnitFrames")

local strmatch, format, wipe, tinsert = string.match, string.format, table.wipe, table.insert
local pairs, ipairs, next, tonumber, unpack, gsub = pairs, ipairs, next, tonumber, unpack, gsub
local UnitAura, GetSpellInfo = UnitAura, GetSpellInfo
local InCombatLockdown = InCombatLockdown
local GetTime, GetSpellCooldown, IsInRaid, IsInGroup, IsPartyLFG = GetTime, GetSpellCooldown, IsInRaid, IsInGroup, IsPartyLFG
local C_ChatInfo_SendAddonMessage = C_ChatInfo.SendAddonMessage
local C_ChatInfo_RegisterAddonMessagePrefix = C_ChatInfo.RegisterAddonMessagePrefix

-- RaidFrame Elements
function UF:CreateRaidIcons(self)
	local parent = CreateFrame("Frame", nil, self)
	parent:SetAllPoints()
	parent:SetFrameLevel(self:GetFrameLevel() + 3)

	local readyCheck = parent:CreateTexture(nil, "OVERLAY")
	readyCheck:SetSize(16, 16)
	readyCheck:SetPoint("CENTER", 1, 0)
	self.ReadyCheckIndicator = readyCheck

	local resurrect = parent:CreateTexture(nil, "OVERLAY")
	resurrect:SetSize(20, 20)
	resurrect:SetPoint("CENTER", 1, 0)
	self.ResurrectIndicator = resurrect

	local summon = parent:CreateTexture(nil, "OVERLAY")
	summon:SetSize(32, 32)
	summon:SetPoint("CENTER", 1, 0)
	self.SummonIndicator = summon

	local raidRole = parent:CreateTexture(nil, "OVERLAY")
	raidRole:SetSize(12, 12)
	raidRole:SetPoint("LEFT", self, "TOPLEFT", 2, 0)
	if self.mystyle == "raid" then
		raidRole:SetPoint("TOPLEFT", self, "TOPLEFT", 0, 0)
	end
	self.RaidRoleIndicator = raidRole
end

function UF:UpdateTargetBorder()
	if UnitIsUnit("target", self.unit) then
		self.TargetBorder:Show()
	else
		self.TargetBorder:Hide()
	end
end

function UF:CreateTargetBorder(self)
	local color = NDuiDB["Nameplate"]["SelectedColor"]

	local targetBorder = B.CreateSD(self, true)
	targetBorder:SetBackdropBorderColor(color.r, color.g, color.b)
	targetBorder:SetOutside(self.Health.bd, B.Scale(3), B.Scale(3), self.Power.bd)
	targetBorder:Hide()
	self.Shadow = nil

	self.TargetBorder = targetBorder
	self:RegisterEvent("PLAYER_TARGET_CHANGED", UF.UpdateTargetBorder, true)
	self:RegisterEvent("GROUP_ROSTER_UPDATE", UF.UpdateTargetBorder, true)
end

function UF:UpdateThreatBorder(_, unit)
	if unit ~= self.unit then return end

	local element = self.ThreatIndicator
	local status = UnitThreatSituation(unit)

	if status and status > 1 then
		local r, g, b = GetThreatStatusColor(status)
		element:SetBackdropBorderColor(r, g, b)
		element:Show()
	else
		element:Hide()
	end
end

function UF:CreateThreatBorder(self)
	local threatIndicator = B.CreateSD(self, true)
	threatIndicator:SetOutside(self.Health.bd, B.Scale(3), B.Scale(3), self.Power.bd)
	threatIndicator:Hide()
	self.Shadow = nil

	self.ThreatIndicator = threatIndicator
	self.ThreatIndicator.Override = UF.UpdateThreatBorder
end

local debuffList = {}
function UF:UpdateRaidDebuffs()
	wipe(debuffList)
	for instName, value in pairs(C.RaidDebuffs) do
		for spell, priority in pairs(value) do
			if not (NDuiADB["RaidDebuffs"][instName] and NDuiADB["RaidDebuffs"][instName][spell]) then
				if not debuffList[instName] then debuffList[instName] = {} end
				debuffList[instName][spell] = priority
			end
		end
	end
	for instName, value in pairs(NDuiADB["RaidDebuffs"]) do
		for spell, priority in pairs(value) do
			if priority > 0 then
				if not debuffList[instName] then debuffList[instName] = {} end
				debuffList[instName][spell] = priority
			end
		end
	end
end

local function buttonOnEnter(self)
	if not self.index then return end
	GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT")
	GameTooltip:ClearLines()
	GameTooltip:SetUnitAura(self.__owner.unit, self.index, self.filter)
	GameTooltip:Show()
end

function UF:CreateRaidDebuffs(self)
	local partyStyle = self.mystyle == "party"
	local scale = NDuiDB["UFs"]["RaidDebuffScale"]
	local fontSize = partyStyle and 16 or 12
	local iconSize = B.Round(self:GetHeight()*(partyStyle and .9 or .6))

	local bu = CreateFrame("Frame", nil, self)
	bu:SetSize(iconSize, iconSize)
	bu:SetPoint("LEFT", self, "CENTER", 5, 0)
	bu:SetFrameLevel(self:GetFrameLevel() + 3)
	bu:SetScale(scale)
	bu:Hide()

	bu.glowFrame = B.CreateGlowFrame(bu, iconSize)
	bu.bd = B.CreateBDFrame(bu)

	bu.icon = bu:CreateTexture(nil, "ARTWORK")
	bu.icon:SetInside(bu.bd)
	bu.icon:SetTexCoord(unpack(DB.TexCoord))

	local parentFrame = CreateFrame("Frame", nil, bu)
	parentFrame:SetAllPoints()
	parentFrame:SetFrameLevel(bu:GetFrameLevel() + 6)
	bu.count = B.CreateFS(parentFrame, fontSize, "", false, "BOTTOMRIGHT", 6, -3)
	bu.timer = B.CreateFS(parentFrame, fontSize, "", false, "CENTER", 1, 0)

	if not NDuiDB["UFs"]["AurasClickThrough"] then
		bu:SetScript("OnEnter", buttonOnEnter)
		bu:SetScript("OnLeave", B.HideTooltip)
	end

	bu.ShowDispellableDebuff = true
	bu.ShowDebuffBorder = true
	bu.FilterDispellableDebuff = true
	if NDuiDB["UFs"]["InstanceAuras"] then
		if not next(debuffList) then UF:UpdateRaidDebuffs() end
		bu.Debuffs = debuffList
	end
	self.RaidDebuffs = bu
end

local keyList = {
	[1] = {KEY_BUTTON1, "", "%s1"},					-- 左键
	[2] = {KEY_BUTTON1, "ALT", "ALT-%s1"},			-- ALT+左键
	[3] = {KEY_BUTTON1, "CTRL", "CTRL-%s1"},		-- CTRL+左键
	[4] = {KEY_BUTTON1, "SHIFT", "SHIFT-%s1"},		-- SHIFT+左键

	[5] = {KEY_BUTTON2, "", "%s2"},					-- 右键
	[6] = {KEY_BUTTON2, "ALT", "ALT-%s2"},			-- ALT+右键
	[7] = {KEY_BUTTON2, "CTRL", "CTRL-%s2"},		-- CTRL+右键
	[8] = {KEY_BUTTON2, "SHIFT", "SHIFT-%s2"},		-- SHIFT+右键

	[9] = {KEY_BUTTON3, "", "%s3"},					-- 中键
	[10] = {KEY_BUTTON3, "ALT", "ALT-%s3"},			-- ALT+中键
	[11] = {KEY_BUTTON3, "CTRL", "CTRL-%s3"},		-- CTRL+中键
	[12] = {KEY_BUTTON3, "SHIFT", "SHIFT-%s3"},		-- SHIFT+中键

	[13] = {KEY_BUTTON4, "", "%s4"},				-- 鼠标键4
	[14] = {KEY_BUTTON4, "ALT", "ALT-%s4"},			-- ALT+鼠标键4
	[15] = {KEY_BUTTON4, "CTRL", "CTRL-%s4"},		-- CTRL+鼠标键4
	[16] = {KEY_BUTTON4, "SHIFT", "SHIFT-%s4"},		-- SHIFT+鼠标键4

	[17] = {KEY_BUTTON5, "", "%s5"},				-- 鼠标键5
	[18] = {KEY_BUTTON5, "ALT", "ALT-%s5"},			-- ALT+鼠标键5
	[19] = {KEY_BUTTON5, "CTRL", "CTRL-%s5"},		-- CTRL+鼠标键5
	[20] = {KEY_BUTTON5, "SHIFT", "SHIFT-%s5"},		-- SHIFT+鼠标键5

	[21] = {L["WheelUp"], "", "%s6"},				-- 滚轮上
	[22] = {L["WheelUp"], "ALT", "%s7"},			-- ALT+滚轮上
	[23] = {L["WheelUp"], "CTRL", "%s8"},			-- CTRL+滚轮上
	[24] = {L["WheelUp"], "SHIFT", "%s9"},			-- SHIFT+滚轮上

	[25] = {L["WheelDown"], "", "%s10"},			-- 滚轮下
	[26] = {L["WheelDown"], "ALT", "%s11"},			-- ALT+滚轮下
	[27] = {L["WheelDown"], "CTRL", "%s12"},		-- CTRL+滚轮下
	[28] = {L["WheelDown"], "SHIFT", "%s13"},		-- SHIFT+滚轮下
}

local defaultSpellList = {
	["DRUID"] = {
		[2] = 88423,		-- 驱散
		[5] = 774,			-- 回春术
		[6] = 33763,		-- 生命绽放
	},
	["HUNTER"] = {
		[21] = 90361,		-- 灵魂治愈
		[25] = 34477,		-- 误导
	},
	["ROGUE"] = {
		[6] = 57934,		-- 嫁祸
	},
	["WARRIOR"] = {
		[6] = 198304,		-- 拦截
	},
	["SHAMAN"] = {
		[2] = 77130,		-- 驱散
		[5] = 61295,		-- 激流
		[6] = 546,			-- 水上行走
	},
	["PALADIN"] = {
		[2] = 4987,			-- 驱散
		[5] = 20473,		-- 神圣震击
		[6] = 1022,			-- 保护祝福
	},
	["PRIEST"] = {
		[2] = 527,			-- 驱散
		[5] = 17,			-- 真言术盾
		[6] = 1706,			-- 漂浮术
	},
	["MONK"] = {
		[2] = 115450,		-- 驱散
		[5] = 119611,		-- 复苏之雾
	},
	["MAGE"] = {
		[6] = 130,			-- 缓落
	},
	["DEMONHUNTER"] = {},
	["WARLOCK"] = {},
	["DEATHKNIGHT"] = {},
}

function UF:DefaultClickSets()
	if not next(NDuiDB["RaidClickSets"]) then
		for k, v in pairs(defaultSpellList[DB.MyClass]) do
			local clickSet = keyList[k][2]..keyList[k][1]
			NDuiDB["RaidClickSets"][clickSet] = {keyList[k][1], keyList[k][2], v}
		end
	end
end

local wheelBindingIndex = {
	["MOUSEWHEELUP"] = 6,
	["ALT-MOUSEWHEELUP"] = 7,
	["CTRL-MOUSEWHEELUP"] = 8,
	["SHIFT-MOUSEWHEELUP"] = 9,
	["MOUSEWHEELDOWN"] = 10,
	["ALT-MOUSEWHEELDOWN"] = 11,
	["CTRL-MOUSEWHEELDOWN"] = 12,
	["SHIFT-MOUSEWHEELDOWN"] = 13,
}

local onEnterString = "self:ClearBindings();"
local onLeaveString = onEnterString
for keyString, keyIndex in pairs(wheelBindingIndex) do
	onEnterString = format("%sself:SetBindingClick(0, \"%s\", self:GetName(), \"Button%d\");", onEnterString, keyString, keyIndex)
end
local onMouseString = "if not self:IsUnderMouse(false) then self:ClearBindings(); end"

local function setupMouseWheelCast(self)
	local found
	for _, data in pairs(NDuiDB["RaidClickSets"]) do
		if strmatch(data[1], L["Wheel"]) then
			found = true
			break
		end
	end

	if found then
		self:SetAttribute("clickcast_onenter", onEnterString)
		self:SetAttribute("clickcast_onleave", onLeaveString)
		self:SetAttribute("_onshow", onLeaveString)
		self:SetAttribute("_onhide", onLeaveString)
		self:SetAttribute("_onmousedown", onMouseString)
	end
end

local function setupClickSets(self)
	if self.clickCastRegistered then return end

	for _, data in pairs(NDuiDB["RaidClickSets"]) do
		local key, modKey, value = unpack(data)
		if key == KEY_BUTTON1 and modKey == "SHIFT" then self.focuser = true end

		for _, v in ipairs(keyList) do
			if v[1] == key and v[2] == modKey then
				if tonumber(value) then
					local name = GetSpellInfo(value)
					self:SetAttribute(format(v[3], "type"), "spell")
					self:SetAttribute(format(v[3], "spell"), name)
				elseif value == "target" then
					self:SetAttribute(format(v[3], "type"), "target")
				elseif value == "focus" then
					self:SetAttribute(format(v[3], "type"), "focus")
				elseif value == "follow" then
					self:SetAttribute(format(v[3], "type"), "macro")
					self:SetAttribute(format(v[3], "macrotext"), "/follow mouseover")
				elseif strmatch(value, "/") then
					self:SetAttribute(format(v[3], "type"), "macro")
					value = gsub(value, "~", "\n")
					self:SetAttribute(format(v[3], "macrotext"), value)
				end
				break
			end
		end
	end

	setupMouseWheelCast(self)
	self:RegisterForClicks("AnyDown")

	self.clickCastRegistered = true
end

local pendingFrames = {}
function UF:CreateClickSets(self)
	if not NDuiDB["UFs"]["RaidClickSets"] then return end

	if InCombatLockdown() then
		pendingFrames[self] = true
	else
		setupClickSets(self)
		pendingFrames[self] = nil
	end
end

function UF:DelayClickSets()
	if not next(pendingFrames) then return end

	for frame in next, pendingFrames do
		UF:CreateClickSets(frame)
	end
end

function UF:AddClickSetsListener()
	if not NDuiDB["UFs"]["RaidClickSets"] then return end

	B:RegisterEvent("PLAYER_REGEN_ENABLED", UF.DelayClickSets)
end

local counterOffsets = {
	["TOPLEFT"] = {{6, 1}, {"LEFT", "RIGHT", -2, 0}},
	["TOPRIGHT"] = {{-6, 1}, {"RIGHT", "LEFT", 2, 0}},
	["BOTTOMLEFT"] = {{6, 1},{"LEFT", "RIGHT", -2, 0}},
	["BOTTOMRIGHT"] = {{-6, 1}, {"RIGHT", "LEFT", 2, 0}},
	["LEFT"] = {{6, 1}, {"LEFT", "RIGHT", -2, 0}},
	["RIGHT"] = {{-6, 1}, {"RIGHT", "LEFT", 2, 0}},
	["TOP"] = {{0, 0}, {"RIGHT", "LEFT", 2, 0}},
	["BOTTOM"] = {{0, 0}, {"RIGHT", "LEFT", 2, 0}},
}

function UF:BuffIndicatorOnUpdate(elapsed)
	B.CooldownOnUpdate(self, elapsed)
end

local found = {}
local auraFilter = {"HELPFUL", "HARMFUL"}

function UF:UpdateBuffIndicator(event, unit)
	if event == "UNIT_AURA" and self.unit ~= unit then return end

	local spellList = NDuiADB["CornerBuffs"][DB.MyClass]
	local buttons = self.BuffIndicator
	unit = self.unit

	wipe(found)
	for _, filter in next, auraFilter do
		for i = 1, 32 do
			local name, texture, count, _, duration, expiration, caster, _, _, spellID = UnitAura(unit, i, filter)
			if not name then break end
			local value = spellList[spellID]
			if value and (value[3] or caster == "player" or caster == "pet") then
				for _, bu in pairs(buttons) do
					if bu.anchor == value[1] then
						if NDuiDB["UFs"]["BuffIndicatorType"] == 3 then
							if duration and duration > 0 then
								bu.expiration = expiration
								bu:SetScript("OnUpdate", UF.BuffIndicatorOnUpdate)
							else
								bu:SetScript("OnUpdate", nil)
							end
							bu.timer:SetTextColor(unpack(value[2]))
						else
							if duration and duration > 0 then
								bu.cd:SetCooldown(expiration - duration, duration)
								bu.cd:Show()
							else
								bu.cd:Hide()
							end
							if NDuiDB["UFs"]["BuffIndicatorType"] == 1 then
								bu.icon:SetVertexColor(unpack(value[2]))
							else
								bu.icon:SetTexture(texture)
							end
						end
						if count > 1 then bu.count:SetText(count) end
						bu:Show()
						found[bu.anchor] = true
						break
					end
				end
			end
		end
	end

	for _, bu in pairs(buttons) do
		if not found[bu.anchor] then
			bu:Hide()
		end
	end
end

function UF:RefreshBuffIndicator(bu)
	if NDuiDB["UFs"]["BuffIndicatorType"] == 3 then
		local point, anchorPoint, x, y = unpack(counterOffsets[bu.anchor][2])
		bu.timer:Show()
		bu.count:ClearAllPoints()
		bu.count:SetPoint(point, bu.timer, anchorPoint, x, y)
		bu.icon:Hide()
		bu.cd:Hide()
		bu.bg:Hide()
	else
		bu:SetScript("OnUpdate", nil)
		bu.timer:Hide()
		bu.count:ClearAllPoints()
		bu.count:SetPoint("CENTER", unpack(counterOffsets[bu.anchor][1]))
		if NDuiDB["UFs"]["BuffIndicatorType"] == 1 then
			bu.icon:SetTexture(DB.bdTex)
		else
			bu.icon:SetVertexColor(1, 1, 1)
		end
		bu.icon:Show()
		bu.cd:Show()
		bu.bg:Show()
	end
end

function UF:CreateBuffIndicator(self)
	if not NDuiDB["UFs"]["RaidBuffIndicator"] then return end
	if NDuiDB["UFs"]["SimpleMode"] and self.mystyle ~= "party" then return end

	local anchors = {"TOPLEFT", "TOP", "TOPRIGHT", "LEFT", "RIGHT", "BOTTOMLEFT", "BOTTOM", "BOTTOMRIGHT"}
	local buttons = {}
	for _, anchor in pairs(anchors) do
		local bu = CreateFrame("Frame", nil, self)
		bu:SetFrameLevel(self:GetFrameLevel()+10)
		bu:SetSize(10, 10)
		bu:SetScale(NDuiDB["UFs"]["BuffIndicatorScale"])
		bu:SetPoint(anchor)
		bu:Hide()

		bu.bg = B.CreateBDFrame(bu)
		bu.icon = bu:CreateTexture(nil, "BORDER")
		bu.icon:SetInside(bu.bg)
		bu.icon:SetTexCoord(unpack(DB.TexCoord))
		bu.cd = CreateFrame("Cooldown", nil, bu, "CooldownFrameTemplate")
		bu.cd:SetInside(bu.bg)
		bu.cd:SetReverse(true)
		bu.cd:SetHideCountdownNumbers(true)
		bu.timer = B.CreateFS(bu, 12, "", false, "CENTER", -counterOffsets[anchor][2][3], 0)
		bu.count = B.CreateFS(bu, 12, "")

		bu.anchor = anchor
		tinsert(buttons, bu)

		UF:RefreshBuffIndicator(bu)
	end

	self.BuffIndicator = buttons
	self:RegisterEvent("UNIT_AURA", UF.UpdateBuffIndicator)
	self:RegisterEvent("GROUP_ROSTER_UPDATE", UF.UpdateBuffIndicator, true)
end

function UF:RefreshRaidFrameIcons()
	for _, frame in pairs(oUF.objects) do
		if frame.mystyle == "raid" or frame.mystyle == "party" then
			if frame.RaidDebuffs then
				frame.RaidDebuffs:SetScale(NDuiDB["UFs"]["RaidDebuffScale"])
			end
			if frame.BuffIndicator then
				for _, bu in pairs(frame.BuffIndicator) do
					bu:SetScale(NDuiDB["UFs"]["BuffIndicatorScale"])
					UF:RefreshBuffIndicator(bu)
				end
			end
		end
	end
end

local watchingList = {}
function UF:PartyWatcherPostUpdate(button, unit, spellID)
	local guid = UnitGUID(unit)
	if not watchingList[guid] then watchingList[guid] = {} end
	watchingList[guid][spellID] = button
end

function UF:HandleCDMessage(...)
	local prefix, msg = ...
	if prefix ~= "ZenTracker" then return end

	local _, msgType, guid, spellID, duration, remaining = strsplit(":", msg)
	if msgType == "U" then
		spellID = tonumber(spellID)
		duration = tonumber(duration)
		remaining = tonumber(remaining)
		local button = watchingList[guid] and watchingList[guid][spellID]
		if button then
			local start = GetTime() + remaining - duration
			if start > 0 and duration > 1.5 then
				button.CD:SetCooldown(start, duration)
			end
		end
	end
end

local lastUpdate = 0
function UF:SendCDMessage()
	local thisTime = GetTime()
	if thisTime - lastUpdate >= 5 then
		local value = watchingList[UF.myGUID]
		if value then
			for spellID in pairs(value) do
				local start, duration, enabled = GetSpellCooldown(spellID)
				if enabled ~= 0 and start ~= 0 then
					local remaining = start + duration - thisTime
					if remaining < 0 then remaining = 0 end
					C_ChatInfo_SendAddonMessage("ZenTracker", format("3:U:%s:%d:%.2f:%.2f:%s", UF.myGUID, spellID, duration, remaining, "-"), IsPartyLFG() and "INSTANCE_CHAT" or "PARTY") -- sync to others
				end
			end
		end
		lastUpdate = thisTime
	end
end

local lastSyncTime = 0
function UF:UpdateSyncStatus()
	if IsInGroup() and not IsInRaid() and NDuiDB["UFs"]["PartyFrame"] then
		local thisTime = GetTime()
		if thisTime - lastSyncTime > 5 then
			C_ChatInfo_SendAddonMessage("ZenTracker", format("3:H:%s:0::0:1", UF.myGUID), IsPartyLFG() and "INSTANCE_CHAT" or "PARTY") -- handshake to ZenTracker
			lastSyncTime = thisTime
		end
		B:RegisterEvent("SPELL_UPDATE_COOLDOWN", UF.SendCDMessage)
	else
		B:UnregisterEvent("SPELL_UPDATE_COOLDOWN", UF.SendCDMessage)
	end
end

function UF:SyncWithZenTracker()
	if not NDuiDB["UFs"]["PartyWatcherSync"] then return end

	UF.myGUID = UnitGUID("player")
	C_ChatInfo_RegisterAddonMessagePrefix("ZenTracker")
	B:RegisterEvent("CHAT_MSG_ADDON", UF.HandleCDMessage)

	UF:UpdateSyncStatus()
	B:RegisterEvent("GROUP_ROSTER_UPDATE", UF.UpdateSyncStatus)
end

local function tooltipOnEnter(self)
	GameTooltip:ClearLines()
	GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT", 0, 0)
	if self.spellID then
		GameTooltip:SetSpellByID(self.spellID)
		GameTooltip:Show()
	end
end

function UF:InterruptIndicator(self)
	if not NDuiDB["UFs"]["PartyWatcher"] then return end

	local buttons = {}
	local maxIcons = 10
	local iconSize = self:GetHeight()+self.Power:GetHeight()+B.Scale(3)+2*C.mult

	local otherSide = NDuiDB["UFs"]["PWOnRight"]
	local point1 = otherSide and "TOPLEFT" or "TOPRIGHT"
	local point2 = otherSide and "TOPRIGHT" or "TOPLEFT"
	local point3 = otherSide and "LEFT" or "RIGHT"
	local point4 = otherSide and "RIGHT" or "LEFT"
	local xOffset = otherSide and 3 or -3

	for i = 1, maxIcons do
		local bu = CreateFrame("Frame", nil, self)
		bu:SetSize(iconSize, iconSize)
		B.AuraIcon(bu)
		bu.CD:SetReverse(false)
		if i == 1 then
			bu:SetPoint(point1, self, point2, xOffset, C.mult)
		else
			bu:SetPoint(point3, buttons[i-1], point4, xOffset, 0)
		end
		bu:Hide()

		bu:SetScript("OnEnter", tooltipOnEnter)
		bu:SetScript("OnLeave", B.HideTooltip)

		buttons[i] = bu
	end

	buttons.__max = maxIcons
	buttons.PartySpells = NDuiADB["PartyWatcherSpells"]
	buttons.TalentCDFix = C.TalentCDFix
	self.PartyWatcher = buttons
	if NDuiDB["UFs"]["PartyWatcherSync"] then
		self.PartyWatcher.PostUpdate = UF.PartyWatcherPostUpdate
	end
end

function UF:CreatePartyAltPower(self)
	if not NDuiDB["UFs"]["PartyAltPower"] then return end

	local altPower = B.CreateFS(self, 16)
	altPower:ClearAllPoints()
	altPower:SetPoint("CENTER", self, "TOP")
	self:Tag(altPower, "[altpower]")
end