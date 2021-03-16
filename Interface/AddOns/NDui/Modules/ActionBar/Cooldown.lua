local _, ns = ...
local B, C, L, DB = unpack(ns)
local CD = B:RegisterModule("Cooldown")

local FONT_SIZE = 19
local MIN_DURATION = 2.5                    -- the minimum duration to show cooldown text for
local MIN_SCALE = 0.5                       -- the minimum scale we want to show cooldown counts at, anything below this will be hidden
local ICON_SIZE = 36
local hideNumbers, active, hooked = {}, {}, {}
local pairs, strfind = pairs, string.find
local GetTime, GetActionCooldown = GetTime, GetActionCooldown

function CD:StopTimer()
	self.enabled = nil
	self:Hide()
end

function CD:ForceUpdate()
	self.nextUpdate = 0
	self:Show()
end

function CD:OnSizeChanged(width, height)
	local fontScale = B.Round((width+height)/2) / ICON_SIZE
	if fontScale == self.fontScale then return end
	self.fontScale = fontScale

	if fontScale < MIN_SCALE then
		self:Hide()
	else
		self.text:SetFont(DB.Font[1], fontScale * FONT_SIZE, DB.Font[3])

		if self.enabled then
			CD.ForceUpdate(self)
		end
	end
end

function CD:TimerOnUpdate(elapsed)
	if self.nextUpdate > 0 then
		self.nextUpdate = self.nextUpdate - elapsed
	else
		local remain = self.duration - (GetTime() - self.start)
		if remain > 0 then
			local getTime, nextUpdate = B.FormatTime(remain)
			self.text:SetText(getTime)
			self.nextUpdate = nextUpdate
		else
			CD.StopTimer(self)
		end
	end
end

function CD:ScalerOnSizeChanged(...)
	CD.OnSizeChanged(self.timer, ...)
end

function CD:OnCreate()
	local scaler = B.CreateParentFrame(self)

	local timer = B.CreateParentFrame(scaler)
	timer:Hide()
	timer:SetScript("OnUpdate", CD.TimerOnUpdate)
	scaler.timer = timer

	local text = timer:CreateFontString(nil, "BACKGROUND")
	text:SetPoint("CENTER", 1, 0)
	text:SetJustifyH("CENTER")
	timer.text = text

	CD.OnSizeChanged(timer, scaler:GetSize())
	scaler:SetScript("OnSizeChanged", CD.ScalerOnSizeChanged)

	self.timer = timer
	return timer
end

function CD:StartTimer(start, duration)
	if self:IsForbidden() then return end
	if self.noCooldownCount or hideNumbers[self] then return end

	local frameName = self:GetDebugName()
	if C.db["ActionBar"]["OverrideWA"] and frameName and strfind(frameName, "WeakAuras") then
		self.noCooldownCount = true
		return
	end

	if start > 0 and duration > MIN_DURATION then
		local timer = self.timer or CD.OnCreate(self)
		timer.start = start
		timer.duration = duration
		timer.enabled = true
		timer.nextUpdate = 0

		-- wait for blizz to fix itself
		local parent = self:GetParent()
		local charge = parent and parent.chargeCooldown
		local chargeTimer = charge and charge.timer
		if chargeTimer and chargeTimer ~= timer then
			CD.StopTimer(chargeTimer)
		end

		if timer.fontScale >= MIN_SCALE then
			timer:Show()
		end
	elseif self.timer then
		CD.StopTimer(self.timer)
	end

	-- hide cooldown flash if barFader enabled
	if self:GetParent().__faderParent then
		if self:GetEffectiveAlpha() > 0 then
			self:Show()
		else
			self:Hide()
		end
	end
end

function CD:HideCooldownNumbers()
	hideNumbers[self] = true
	if self.timer then CD.StopTimer(self.timer) end
end

function CD:CooldownOnShow()
	active[self] = true
end

function CD:CooldownOnHide()
	active[self] = nil
end

local function shouldUpdateTimer(self, start)
	local timer = self.timer
	if not timer then
		return true
	end
	return timer.start ~= start
end

function CD:CooldownUpdate()
	local button = self:GetParent()
	local start, duration = GetActionCooldown(button.action)

	if shouldUpdateTimer(self, start) then
		CD.StartTimer(self, start, duration)
	end
end

function CD:ActionbarUpateCooldown()
	for cooldown in pairs(active) do
		CD.CooldownUpdate(cooldown)
	end
end

function CD:RegisterActionButton()
	local cooldown = self.cooldown
	if not hooked[cooldown] then
		cooldown:HookScript("OnShow", CD.CooldownOnShow)
		cooldown:HookScript("OnHide", CD.CooldownOnHide)

		hooked[cooldown] = true
	end
end

function CD:OnLogin()
	if not C.db["ActionBar"]["Cooldown"] then return end

	local cooldownIndex = getmetatable(ActionButton1Cooldown).__index
	hooksecurefunc(cooldownIndex, "SetCooldown", CD.StartTimer)

	hooksecurefunc("CooldownFrame_SetDisplayAsPercentage", CD.HideCooldownNumbers)

	B:RegisterEvent("ACTIONBAR_UPDATE_COOLDOWN", CD.ActionbarUpateCooldown)

	if _G["ActionBarButtonEventsFrame"].frames then
		for _, frame in pairs(_G["ActionBarButtonEventsFrame"].frames) do
			CD.RegisterActionButton(frame)
		end
	end
	hooksecurefunc(ActionBarButtonEventsFrameMixin, "RegisterFrame", CD.RegisterActionButton)

	-- Hide Default Cooldown
	SetCVar("countdownForCooldowns", 0)
	B.HideOption(InterfaceOptionsActionBarsPanelCountdownCooldowns)
end