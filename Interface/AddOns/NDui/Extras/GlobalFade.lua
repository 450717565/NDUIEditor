local _, ns = ...
local B, C, L, DB = unpack(ns)
local Extras = B:GetModule("Extras")
local Bar = B:GetModule("ActionBar")
-----------------
-- Credit: ElvUI
-----------------
local FadeFrames = {
	["GlobalFadeActionBar"] = {
		"NDui_ActionBar1",
		"NDui_ActionBar2",
		"NDui_ActionBar3",
		"NDui_ActionBar4",
		"NDui_ActionBar5",
		"NDui_CustomBar",
		"NDui_ActionBarPet",
		"NDui_ActionBarStance",
	},
	["GlobalFadeUnitFrame"] = {
		"oUF_Player",
		"oUF_Pet",
		"oUF_Focus",
		"oUF_FoT",
	},
}

function Extras:FadeBlingTexture(cooldown, alpha)
	if not cooldown then return end
	cooldown:SetBlingTexture(alpha > 0.5 and DB.newItemFlash or DB.blankTex)
end

function Extras:FadeBlings(alpha)
	for _, button in pairs(Bar.buttons) do
		Extras:FadeBlingTexture(button.cooldown, alpha)
	end
end

function Extras:Fade_OnEnter()
	if not Extras.fadeParent.mouseLock then
		Extras:UIFrameFadeIn(Extras.fadeParent, .2, Extras.fadeParent:GetAlpha(), 1)
		Extras:FadeBlings(1)
	end
end

function Extras:Fade_OnLeave()
	if not Extras.fadeParent.mouseLock then
		Extras:UIFrameFadeOut(Extras.fadeParent, Extras.fadeDuration, Extras.fadeParent:GetAlpha(), Extras.fadeAlpha)
		Extras:FadeBlings(Extras.fadeAlpha)
	end
end

function Extras:FadeParent_OnEvent(event)
	if UnitCastingInfo("player") or UnitChannelInfo("player") or UnitExists("target")
	or UnitAffectingCombat("player") or (UnitHealth("player") ~= UnitHealthMax("player"))
	or event == "ACTIONBAR_SHOWGRID" then
		self.mouseLock = true
		Extras:UIFrameFadeIn(self, .2, self:GetAlpha(), 1)
		Extras:FadeBlings(1)
	else
		self.mouseLock = false
		Extras:UIFrameFadeOut(self, Extras.fadeDuration, self:GetAlpha(), Extras.fadeAlpha)
		Extras:FadeBlings(Extras.fadeAlpha)
	end
end

local function updateAfterCombat(event)
	Extras:UpdateFadeFrame()
	B:UnregisterEvent(event, updateAfterCombat)
end

function Extras:UpdateFadeFrame()
	if InCombatLockdown() then
		B:RegisterEvent("PLAYER_REGEN_ENABLED", updateAfterCombat)
		return
	end

	for key, frames in pairs(FadeFrames) do
		if C.db["Extras"][key] then
			for _, v in pairs(frames) do
				local f = _G[v]
				if f then
					f:SetParent(Extras.fadeParent)
					if key ~= "ActionBar" then
						f:HookScript("OnEnter", Extras.Fade_OnEnter)
						f:HookScript("OnLeave", Extras.Fade_OnLeave)
					end
				end
			end
		end
	end

	if not C.db["Extras"]["GlobalFadeActionBar"] then return end

	for _, button in ipairs(Bar.buttons) do
		button:HookScript("OnEnter", Extras.Fade_OnEnter)
		button:HookScript("OnLeave", Extras.Fade_OnLeave)
	end
end

function Extras:GlobalFade()
	if not C.db["Extras"]["GlobalFade"] then return end

	Extras.fadeAlpha = C.db["Extras"]["GlobalFadeAlpha"]
	Extras.fadeDuration = C.db["Extras"]["GlobalFadeDuration"]

	Extras.fadeParent = CreateFrame("Frame", "NDui_Plus_Fader", _G.UIParent, "SecureHandlerStateTemplate")
	RegisterStateDriver(Extras.fadeParent, 'visibility', '[petbattle] hide; show')
	Extras.fadeParent:SetAlpha(Extras.fadeAlpha)
	Extras.fadeParent:SetScript("OnEvent", Extras.FadeParent_OnEvent)

	if C.db["Extras"]["GlobalFadeCombat"] then
		Extras.fadeParent:RegisterEvent("PLAYER_REGEN_DISABLED")
		Extras.fadeParent:RegisterEvent("PLAYER_REGEN_ENABLED")
	end

	if C.db["Extras"]["GlobalFadeTarget"] then
		Extras.fadeParent:RegisterEvent("PLAYER_TARGET_CHANGED")
	end

	if C.db["Extras"]["GlobalFadeCast"] then
		Extras.fadeParent:RegisterUnitEvent("UNIT_SPELLCAST_START", "player")
		Extras.fadeParent:RegisterUnitEvent("UNIT_SPELLCAST_STOP", "player")
		Extras.fadeParent:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_START", "player")
		Extras.fadeParent:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_STOP", "player")
	end

	if C.db["Extras"]["GlobalFadeHealth"] then
		Extras.fadeParent:RegisterUnitEvent("UNIT_HEALTH", "player")
	end

	if C.db["Extras"]["GlobalFadeActionBar"] then
		Extras.fadeParent:RegisterEvent("ACTIONBAR_SHOWGRID")
		Extras.fadeParent:RegisterEvent("ACTIONBAR_HIDEGRID")
	end

	C_Timer.After(.5, Extras.UpdateFadeFrame)
end