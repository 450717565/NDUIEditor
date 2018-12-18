-----------------------------------------------
-- oUF_FloatingCombatFeedback, by lightspark
-- NDui MOD
-----------------------------------------------
local _, ns = ...
local B, C, L, DB = unpack(ns)
local oUF = ns.oUF or oUF
assert(oUF, "oUF FloatingCombatFeedback was unable to locate oUF install")

local _G = getfenv(0)
local pairs = pairs
local cos, sin, mmax = cos, sin, math.max
local tremove, tinsert = table.remove, table.insert

local BreakUpLargeNumbers = _G.BreakUpLargeNumbers
local ENTERING_COMBAT = _G.ENTERING_COMBAT
local LEAVING_COMBAT = _G.LEAVING_COMBAT

local function removeString(self, i, string)
	tremove(self.FeedbackToAnimate, i)
	string:SetText(nil)
	string:SetAlpha(0)
	string:Hide()

	return string
end

local function getAvailableString(self)
	for i = 1, self.__max do
		if not self[i]:IsShown() then
			return self[i]
		end
	end

	return removeString(self, 1, self.FeedbackToAnimate[1])
end

local function fountainScroll(self)
	return self.x + self.xDirection * self.scrollHeight * (1 - cos(90 * self.elapsed / self.scrollTime)),
		self.y + self.yDirection * self.scrollHeight * sin(90 * self.elapsed / self.scrollTime)
end

local function standardScroll(self)
	return self.x, self.y + self.yDirection * self.scrollHeight * self.elapsed / self.scrollTime
end

local function onUpdate(self, elapsed)
	for index, string in pairs(self.FeedbackToAnimate) do
		if string.elapsed >= string.scrollTime then
			removeString(self, index, string)
		else
			string.elapsed = string.elapsed + elapsed

			string:SetPoint("CENTER", self, "CENTER", self.Scroll(string))

			if (string.elapsed >= self.fadeout) then
				string:SetAlpha(mmax(1 - (string.elapsed - self.fadeout) / (self.scrollTime - self.fadeout), 0))
			end
		end
	end

	if #self.FeedbackToAnimate == 0 then
		self:SetScript("OnUpdate", nil)
	end
end

local function onShow(self)
	for index, string in pairs(self.FeedbackToAnimate) do
		removeString(self, index, string)
	end
end

local eventFilter = {
	["SWING_DAMAGE"] = {suffix = "DAMAGE", index = 12, iconType = "swing", autoAttack = true},
	["RANGE_DAMAGE"] = {suffix = "DAMAGE", index = 15, iconType = "range", autoAttack = true},
	["SPELL_DAMAGE"] = {suffix = "DAMAGE", index = 15, iconType = "spell"},
	["SPELL_PERIODIC_DAMAGE"] = {suffix = "DAMAGE", index = 15, iconType = "spell", isPeriod = true},
	["SPELL_BUILDING_DAMAGE"] = {suffix = "DAMAGE", index = 15, iconType = "spell"},

	["SPELL_HEAL"] = {suffix = "HEAL", index = 15, iconType = "spell"},
	["SPELL_PERIODIC_HEAL"] = {suffix = "HEAL", index = 15, iconType = "spell", isPeriod = true},

	["SWING_MISSED"] = {suffix = "MISS", index = 12, iconType = "swing", autoAttack = true},
	["RANGE_MISSED"] = {suffix = "MISS", index = 15, iconType = "range", autoAttack = true},
	["SPELL_MISSED"] = {suffix = "MISS", index = 15, iconType = "spell"},

	["ENVIRONMENTAL_DAMAGE"] = {suffix = "ENVIRONMENT", index = 12, iconType = "env"},
}

local envTexture = {
	["Drowning"] = "spell_shadow_demonbreath",
	["Falling"] = "ability_rogue_quickrecovery",
	["Fatigue"] = "ability_creature_cursed_05",
	["Fire"] = "spell_fire_fire",
	["Lava"] = "ability_rhyolith_lavapool",
	["Slime"] = "inv_misc_slime_02",
}

local function getFloatingIconTexture(iconType, spellID, isPet)
	local texture
	if iconType == "spell" then
		texture = GetSpellTexture(spellID)
	elseif iconType == "swing" then
		if isPet then
			texture = PET_ATTACK_TEXTURE
		else
			texture = GetSpellTexture(6603)
		end
	elseif iconType == "range" then
		texture = GetSpellTexture(75)
	elseif iconType == "env" then
		texture = envTexture[spellID] or "ability_creature_cursed_05"
		texture = "Interface\\Icons\\"..texture
	end

	return texture
end

local function formatNumber(self, amount)
	local element = self.FloatingCombatFeedback

	if element.abbreviateNumbers then
		return B.Numb(amount)
	else
		return BreakUpLargeNumbers(amount)
	end
end

local function onEvent(self, event, ...)
	local element = self.FloatingCombatFeedback
	local multiplier = 1
	local text, color, texture, critMark
	local unit = self.unit
	local grey = {r = .5, g = .5, b = .5}

	if event == "COMBAT_LOG_EVENT_UNFILTERED" then
		local _, eventType, _, sourceGUID, _, sourceFlags, _, destGUID, _, _, _, spellID, _, school = ...
		local isPlayer = UnitGUID("player") == sourceGUID
		local atTarget = UnitGUID("target") == destGUID
		local atPlayer = UnitGUID("player") == destGUID
		local isVehicle = element.showPets and sourceFlags == DB.GuardianFlags
		local isPet = element.showPets and sourceFlags == DB.MyPetFlags

		if (unit == "target" and (isPlayer or isPet or isVehicle) and atTarget) or (unit == "player" and atPlayer) then
			local value = eventFilter[eventType]
			if not value then return end

			if value.suffix == "DAMAGE" then
				if value.autoAttack and not element.showAutoAttack then return end
				if value.isPeriod and not element.showHots then return end

				local amount, _, _, _, _, _, critical, _, crushing = select(value.index, ...)
				texture = getFloatingIconTexture(value.iconType, spellID, isPet)
				text = "-"..formatNumber(self, amount)

				if critical or crushing then
					multiplier = C.mult
					critMark = true
				end
			elseif value.suffix == "HEAL" then
				if value.isPeriod and not element.showHots then return end

				local amount, overhealing, _, critical = select(value.index, ...)
				texture = getFloatingIconTexture(value.iconType, spellID)
				local overhealText = ""
				if overhealing > 0 then
					amount = amount - overhealing
					overhealText = " ("..formatNumber(self, overhealing)..")"
				end
				if amount == 0 and not element.showOverHealing then return end
				text = "+"..formatNumber(self, amount)..overhealText

				if critical then
					multiplier = C.mult
					critMark = true
				end
			elseif value.suffix == "MISS" then
				local missType = select(value.index, ...)
				texture = getFloatingIconTexture(value.iconType, spellID, isPet)
				text = _G["COMBAT_TEXT_"..missType]
			elseif value.suffix == "ENVIRONMENT" then
				local envType, amount = select(value.index, ...)
				texture = getFloatingIconTexture(value.iconType, envType)
				text = "-"..formatNumber(self, amount)
			end

			local ColorArrayBySchool = _G.CombatLog_Color_ColorArrayBySchool
			color = ColorArrayBySchool(school) or grey
		end
	elseif event == "PLAYER_REGEN_DISABLED" then
		texture = ""
		text = ENTERING_COMBAT
		color = {r = 1, g = 0, b = 0}
		multiplier = 1.3
	elseif event == "PLAYER_REGEN_ENABLED" then
		texture = ""
		text = LEAVING_COMBAT
		color = {r = 0, g = 1, b = 0}
		multiplier = 1.3
	end

	if text and texture then
		local string = getAvailableString(element)

		string:SetFont(DB.Font[1], element.fontHeight * multiplier, DB.Font[3])
		string:SetFormattedText("|T%s:14:14:-2:0:64:64:5:59:5:59|t%s", texture, (critMark and "*" or "")..text)
		string:SetTextColor(color.r, color.g, color.b)
		string.elapsed = 0
		string.scrollHeight = element.scrollHeight
		string.scrollTime = element.scrollTime
		string.xDirection = element.xDirection
		string.yDirection = element.yDirection
		string.x = element.xOffset * string.xDirection
		string.y = element.yOffset * string.yDirection
		string:SetPoint("CENTER", element, "CENTER", string.x, string.y)
		string:SetAlpha(1)
		string:Show()

		tinsert(element.FeedbackToAnimate, string)

		element.xDirection = element.xDirection * -1

		if not element:GetScript("OnUpdate") then
			element.Scroll = element.mode == "Fountain" and fountainScroll or standardScroll

			element:SetScript("OnUpdate", onUpdate)
		end
	end
end

local function Update(self, event, ...)
	if event == "COMBAT_LOG_EVENT_UNFILTERED" then
		onEvent(self, event, CombatLogGetCurrentEventInfo())
	else
		onEvent(self, event, ...)
	end
end

local function Path(self, ...)
	return (self.FloatingCombatFeedback.Override or Update) (self, ...)
end

local function ForceUpdate(element)
	return Path(element.__owner, 'ForceUpdate', element.__owner.unit)
end

local function Enable(self, unit)
	local element = self.FloatingCombatFeedback

	if not element then return end

	element.__owner = self
	element.__max = #element
	element.xDirection = 1
	element.scrollHeight = 160
	element.scrollTime = element.scrollTime or 2
	element.fadeout = element.scrollTime / 3
	element.yDirection = element.yDirection or 1
	element.fontHeight = element.fontHeight or 18
	element.abbreviateNumbers = element.abbreviateNumbers
	element.ForceUpdate = ForceUpdate
	element.FeedbackToAnimate = {}

	if element.mode == "Fountain" then
		element.Scroll = fountainScroll
		element.xOffset = element.xOffset or 6
		element.yOffset = element.yOffset or 8
	else
		element.Scroll = standardScroll
		element.xOffset = element.xOffset or 30
		element.yOffset = element.yOffset or 8
	end

	for i = 1, element.__max do
		element[i]:Hide()
	end

	element:HookScript("OnShow", onShow)

	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED", Path)
	if unit == "player" then
		self:RegisterEvent("PLAYER_REGEN_DISABLED", Path)
		self:RegisterEvent("PLAYER_REGEN_ENABLED", Path)
	end

	return true
end

local function Disable(self)
	local element = self.FloatingCombatFeedback

	if element then
		self:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED", Path)
		self:UnregisterEvent("PLAYER_REGEN_DISABLED", Path)
		self:UnregisterEvent("PLAYER_REGEN_ENABLED", Path)
	end
end

oUF:AddElement("FloatingCombatFeedback", Path, Enable, Disable)