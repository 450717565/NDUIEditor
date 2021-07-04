local _, ns = ...
local oUF = ns.oUF
local B, C, L, DB = unpack(ns)
local Misc = B:GetModule("Misc")

local _G = getfenv(0)
local next, strmatch = next, string.match
local InCombatLockdown = InCombatLockdown

local modifier = "shift" -- shift, alt or ctrl
local mouseButton = "1" -- 1 = left, 2 = right, 3 = middle, 4 and 5 = thumb buttons if there are any
local pending = {}

function Misc:Focuser_Setup()
	if not self or self.focuser then return end
	if self:GetDebugName() and strmatch(self:GetDebugName(), "oUF_NPs") then return end

	if not InCombatLockdown() then
		self:SetAttribute(modifier.."-type"..mouseButton, "focus")
		self.focuser = true
		pending[self] = nil
	else
		pending[self] = true
	end
end

function Misc:Focuser_CreateFrameHook(name, _, template)
	if name and template == "SecureUnitButtonTemplate" then
		Misc.Focuser_Setup(_G[name])
	end
end

function Misc.Focuser_OnEvent(event)
	if event == "PLAYER_REGEN_ENABLED" then
		if next(pending) then
			for frame in pairs(pending) do
				Misc.Focuser_Setup(frame)
			end
		end
	else
		for _, object in pairs(oUF.objects) do
			if not object.focuser then
				Misc.Focuser_Setup(object)
			end
		end
	end
end

function Misc:Focuser()
	if not C.db["Misc"]["Focuser"] then return end

	-- Keybinding override so that models can be shift/alt/ctrl+clicked
	local f = CreateFrame("CheckButton", "FocuserButton", UIParent, "SecureActionButtonTemplate")
	f:SetAttribute("type1", "macro")
	f:SetAttribute("macrotext", "/focus mouseover")
	SetOverrideBindingClick(FocuserButton, true, modifier.."-BUTTON"..mouseButton, "FocuserButton")

	hooksecurefunc("CreateFrame", Misc.Focuser_CreateFrameHook)
	Misc:Focuser_OnEvent()
	B:RegisterEvent("PLAYER_REGEN_ENABLED", Misc.Focuser_OnEvent)
	B:RegisterEvent("GROUP_ROSTER_UPDATE", Misc.Focuser_OnEvent)
end
Misc:RegisterMisc("Focuser", Misc.Focuser)