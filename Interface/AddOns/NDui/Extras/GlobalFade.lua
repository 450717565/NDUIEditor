local _, ns = ...
local B, C, L, DB = unpack(ns)
local EX = B:GetModule("Extras")
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

function EX:FadeBlingTexture(cooldown, alpha)
	if not cooldown then return end
	cooldown:SetBlingTexture(alpha > 0.5 and DB.newItemFlash or DB.blankTex)
end

function EX:FadeBlings(alpha)
	for _, button in pairs(Bar.buttons) do
		EX:FadeBlingTexture(button.cooldown, alpha)
	end
end

function EX:Fade_OnEnter()
	if not EX.fadeParent.mouseLock then
		EX:UIFrameFadeIn(EX.fadeParent, .2, EX.fadeParent:GetAlpha(), 1)
		EX:FadeBlings(1)
	end
end

function EX:Fade_OnLeave()
	if not EX.fadeParent.mouseLock then
		EX:UIFrameFadeOut(EX.fadeParent, EX.fadeDuration, EX.fadeParent:GetAlpha(), EX.fadeAlpha)
		EX:FadeBlings(EX.fadeAlpha)
	end
end

function EX:FadeParent_OnEvent(event)
	if UnitCastingInfo("player") or UnitChannelInfo("player") or UnitExists("target")
	or UnitAffectingCombat("player") or (UnitHealth("player") ~= UnitHealthMax("player"))
	or event == "ACTIONBAR_SHOWGRID" then
		self.mouseLock = true
		EX:UIFrameFadeIn(self, .2, self:GetAlpha(), 1)
		EX:FadeBlings(1)
	else
		self.mouseLock = false
		EX:UIFrameFadeOut(self, EX.fadeDuration, self:GetAlpha(), EX.fadeAlpha)
		EX:FadeBlings(EX.fadeAlpha)
	end
end

local function updateAfterCombat(event)
	EX:UpdateFadeFrame()
	B:UnregisterEvent(event, updateAfterCombat)
end

function EX:UpdateFadeFrame()
	if InCombatLockdown() then
		B:RegisterEvent("PLAYER_REGEN_ENABLED", updateAfterCombat)
		return
	end

	for key, frames in pairs(FadeFrames) do
		if C.db["Extras"][key] then
			for _, v in pairs(frames) do
				local f = _G[v]
				if f then
					f:SetParent(EX.fadeParent)
					if key ~= "ActionBar" then
						f:HookScript("OnEnter", EX.Fade_OnEnter)
						f:HookScript("OnLeave", EX.Fade_OnLeave)
					end
				end
			end
		end
	end

	if not C.db["Extras"]["GlobalFadeActionBar"] then return end

	for _, button in ipairs(Bar.buttons) do
		button:HookScript("OnEnter", EX.Fade_OnEnter)
		button:HookScript("OnLeave", EX.Fade_OnLeave)
	end
end

function EX:GlobalFade()
	if not C.db["Extras"]["GlobalFade"] then return end

	EX.fadeAlpha = C.db["Extras"]["GlobalFadeAlpha"]
	EX.fadeDuration = C.db["Extras"]["GlobalFadeDuration"]

	EX.fadeParent = CreateFrame("Frame", "NDui_Plus_Fader", _G.UIParent, "SecureHandlerStateTemplate")
	RegisterStateDriver(EX.fadeParent, 'visibility', '[petbattle] hide; show')
	EX.fadeParent:SetAlpha(EX.fadeAlpha)
	EX.fadeParent:SetScript("OnEvent", EX.FadeParent_OnEvent)

	if C.db["Extras"]["GlobalFadeCombat"] then
		EX.fadeParent:RegisterEvent("PLAYER_REGEN_DISABLED")
		EX.fadeParent:RegisterEvent("PLAYER_REGEN_ENABLED")
	end

	if C.db["Extras"]["GlobalFadeTarget"] then
		EX.fadeParent:RegisterEvent("PLAYER_TARGET_CHANGED")
	end

	if C.db["Extras"]["GlobalFadeCast"] then
		EX.fadeParent:RegisterUnitEvent("UNIT_SPELLCAST_START", "player")
		EX.fadeParent:RegisterUnitEvent("UNIT_SPELLCAST_STOP", "player")
		EX.fadeParent:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_START", "player")
		EX.fadeParent:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_STOP", "player")
	end

	if C.db["Extras"]["GlobalFadeHealth"] then
		EX.fadeParent:RegisterUnitEvent("UNIT_HEALTH", "player")
	end

	if C.db["Extras"]["GlobalFadeActionBar"] then
		EX.fadeParent:RegisterEvent("ACTIONBAR_SHOWGRID")
		EX.fadeParent:RegisterEvent("ACTIONBAR_HIDEGRID")
	end

	C_Timer.After(.5, EX.UpdateFadeFrame)
end