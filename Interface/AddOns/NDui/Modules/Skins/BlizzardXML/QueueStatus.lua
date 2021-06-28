local _, ns = ...
local B, C, L, DB = unpack(ns)

local LFD_NUM_ROLES = LFD_NUM_ROLES

local function Reskin_Entry(self)
	if self.styled then return end

	B.ReskinRole(self.TanksFound, "TANK")
	B.ReskinRole(self.HealersFound, "HEALER")
	B.ReskinRole(self.DamagersFound, "DPS")

	for i = 1, LFD_NUM_ROLES do
		local roleIcon = self["RoleIcon"..i]
		roleIcon.icbg = B.ReskinRoleIcon(roleIcon)
		if i > 1 then
			roleIcon:SetPoint("RIGHT", self["RoleIcon"..(i-1)], "LEFT", -4, 0)
		end
	end

	self.styled = true
end

local function Update_TexCoord(entry, index, role)
	local roleIcon = entry["RoleIcon"..index]
	roleIcon:SetTexCoord(B.GetRoleTexCoord(role))
	roleIcon:Show()
	roleIcon.icbg:Show()
end

local function Reskin_SetMinimalDisplay(entry)
	Reskin_Entry(entry)

	for i = 1, LFD_NUM_ROLES do
		local roleIcon = entry["RoleIcon"..i]
		roleIcon.icbg:Hide()
	end
end

local function Reskin_SetFullDisplay(entry, _, _, _, isTank, isHealer, isDPS)
	Reskin_Entry(entry)

	local nextRoleIcon = 1
	if isDPS then
		Update_TexCoord(entry, nextRoleIcon, "DPS")
		nextRoleIcon = nextRoleIcon + 1
	end
	if isHealer then
		Update_TexCoord(entry, nextRoleIcon, "HEALER")
		nextRoleIcon = nextRoleIcon + 1
	end
	if isTank then
		Update_TexCoord(entry, nextRoleIcon, "TANK")
		nextRoleIcon = nextRoleIcon + 1
	end

	for i = nextRoleIcon, LFD_NUM_ROLES do
		local roleIcon = entry["RoleIcon"..i]
		roleIcon:Hide()
		roleIcon.icbg:Hide()
	end
end

C.OnLoginThemes["QueueStatus"] = function()
	hooksecurefunc("QueueStatusEntry_SetMinimalDisplay", Reskin_SetMinimalDisplay)
	hooksecurefunc("QueueStatusEntry_SetFullDisplay", Reskin_SetFullDisplay)
end