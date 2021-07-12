local _, ns = ...
local B, C, L, DB = unpack(ns)
local AB = B:GetModule("ActionBar")

local next, pairs, unpack = next, pairs, unpack
local HasAction, IsUsableAction, IsActionInRange = HasAction, IsUsableAction, IsActionInRange

local UPDATE_DELAY = .2
local buttonColors, buttonsToUpdate = {}, {}
local updater = CreateFrame("Frame")

local colors = {
	["normal"] = {1, 1, 1},
	["oor"] = {.8, .1, .1},
	["oom"] = {.5, .5, 1},
	["unusable"] = {.3, .3, .3}
}

function AB:OnUpdateRange(elapsed)
	self.elapsed = (self.elapsed or UPDATE_DELAY) - elapsed
	if self.elapsed <= 0 then
		self.elapsed = UPDATE_DELAY

		if not AB:UpdateButtons() then
			self:Hide()
		end
	end
end
updater:SetScript("OnUpdate", AB.OnUpdateRange)

function AB:UpdateButtons()
	if next(buttonsToUpdate) then
		for button in pairs(buttonsToUpdate) do
			self.UpdateButtonUsable(button)
		end
		return true
	end

	return false
end

function AB:UpdateButtonStatus()
	local action = self.action

	if action and self:IsVisible() and HasAction(action) then
		buttonsToUpdate[self] = true
	else
		buttonsToUpdate[self] = nil
	end

	if next(buttonsToUpdate) then
		updater:Show()
	end
end

function AB:UpdateButtonUsable(force)
	if force then
		buttonColors[self] = nil
	end

	local action = self.action
	local isUsable, notEnoughMana = IsUsableAction(action)

	if isUsable then
		local inRange = IsActionInRange(action)
		if inRange == false then
			AB.SetButtonColor(self, "oor")
		else
			AB.SetButtonColor(self, "normal")
		end
	elseif notEnoughMana then
		AB.SetButtonColor(self, "oom")
	else
		AB.SetButtonColor(self, "unusable")
	end
end

function AB:SetButtonColor(colorIndex)
	if buttonColors[self] == colorIndex then return end
	buttonColors[self] = colorIndex

	local r, g, b = unpack(colors[colorIndex])
	self.icon:SetVertexColor(r, g, b)
end

function AB:Register()
	self:HookScript("OnShow", AB.UpdateButtonStatus)
	self:HookScript("OnHide", AB.UpdateButtonStatus)
	self:SetScript("OnUpdate", nil)
	AB.UpdateButtonStatus(self)
end

local function button_UpdateUsable(button)
	AB.UpdateButtonUsable(button, true)
end

function AB:RegisterButtonRange(button)
	if button.Update then
		AB.Register(button)
		hooksecurefunc(button, "Update", AB.UpdateButtonStatus)
		hooksecurefunc(button, "UpdateUsable", button_UpdateUsable)
	end
end