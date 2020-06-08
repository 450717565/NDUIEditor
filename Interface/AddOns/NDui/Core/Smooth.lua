local _, ns = ...
local B, C, L, DB = unpack(ns)

-- ls_UI, lightspark
local next, Lerp = next, Lerp
local abs = math.abs

local activeObjects = {}
local handledObjects = {}

local TARGET_FPS = 60
local AMOUNT = .4

local function clamp(v, min, max)
	min = min or 0
	max = max or 1
	v = tonumber(v)

	if v > max then
		return max
	elseif v < min then
		return min
	end

	return v
end

local function isCloseEnough(new, target, range)
	if range > 0 then
		return abs((new - target) / range) <= .001
	end

	return true
end

local frame = CreateFrame("Frame")

local function onUpdate(_, elapsed)
	for object, target in next, activeObjects do
		local new = Lerp(object._value, target, clamp(AMOUNT * elapsed * TARGET_FPS))
		if isCloseEnough(new, target, object._max - object._min) then
			new = target
			activeObjects[object] = nil
		end

		object:SetValue_(new)
		object._value = new
	end
end

local function bar_SetSmoothedValue(self, value)
	self._value = self:GetValue()
	activeObjects[self] = clamp(value, self._min, self._max)
end

local function bar_SetSmoothedMinMaxValues(self, min, max)
	self:SetMinMaxValues_(min, max)

	if self._max and self._max ~= max then
		local ratio = 1
		if max ~= 0 and self._max and self._max ~= 0 then
			ratio = max / (self._max or max)
		end

		local target = activeObjects[self]
		if target then
			activeObjects[self] = target * ratio
		end

		local cur = self._value
		if cur then
			self:SetValue_(cur * ratio)
			self._value = cur * ratio
		end
	end

	self._min = min
	self._max = max
end

function B:SmoothBar()
	self._min, self._max = self:GetMinMaxValues()
	self._value = self:GetValue()

	self.SetValue_ = self.SetValue
	self.SetMinMaxValues_ = self.SetMinMaxValues
	self.SetValue = bar_SetSmoothedValue
	self.SetMinMaxValues = bar_SetSmoothedMinMaxValues

	handledObjects[self] = true

	if not frame:GetScript("OnUpdate") then
		frame:SetScript("OnUpdate", onUpdate)
	end
end

function B:DesmoothBar()
	if activeObjects[self] then
		self:SetValue_(activeObjects[self])
		activeObjects[self] = nil
	end

	if self.SetValue_ then
		self.SetValue = self.SetValue_
		self.SetValue_ = nil
	end

	if self.SetMinMaxValues_ then
		self.SetMinMaxValues = self.SetMinMaxValues_
		self.SetMinMaxValues_ = nil
	end

	handledObjects[self] = nil

	if not next(handledObjects) then
		frame:SetScript("OnUpdate", nil)
	end
end

function B:SetSmoothingAmount()
	AMOUNT = clamp(self, .2, .8)
end