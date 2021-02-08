local _, ns = ...
local B, C, L, DB = unpack(ns)

local function Reskin_ReadyCheckFrame(self)
	if self.initiator and UnitIsUnit("player", self.initiator) then
		self:Hide()
	end
end

tinsert(C.XMLThemes, function()
	B.ReskinFrame(ReadyCheckFrame)
	B.ReskinButton(ReadyCheckFrameYesButton)
	B.ReskinButton(ReadyCheckFrameNoButton)
	B.StripTextures(ReadyCheckListenerFrame)

	ReadyCheckPortrait:SetAlpha(0)
	ReadyCheckFrame:HookScript("OnShow", Reskin_ReadyCheckFrame)
end)

tinsert(C.XMLThemes, function()
	B.ReskinFrame(RolePollPopup)
	B.ReskinButton(RolePollPopupAcceptButton)

	B.ReskinRole(RolePollPopupRoleButtonTank, "TANK")
	B.ReskinRole(RolePollPopupRoleButtonHealer, "HEALER")
	B.ReskinRole(RolePollPopupRoleButtonDPS, "DPS")
end)