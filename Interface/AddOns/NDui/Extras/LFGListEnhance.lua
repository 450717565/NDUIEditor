local _, ns = ...
local B, C, L, DB, P = unpack(ns)
local EX = B:GetModule("Extras")

--------------------------
-- Credit: ElvUI_WindTools
--------------------------

local roleCache = {
	TANK = {},
	HEALER = {},
	DAMAGER = {}
}

local roleAtlas = {
	["TANK"] = "Soulbinds_Tree_Conduit_Icon_Protect",
	["HEALER"] = "ui_adv_health",
	["DAMAGER"] = "ui_adv_atk",
}

local function HandleRoleAnchor(self, role)
	local Count = self[role.."Count"]
	Count:SetWidth(24)
	Count:SetJustifyH("CENTER")
	Count:SetFontObject(Game13Font)
	Count:SetPoint("RIGHT", self[role.."Icon"], "LEFT", 1, 0)
end

local function HandleMeetingStone()
	if IsAddOnLoaded("MeetingStone") or IsAddOnLoaded("MeetingStonePlus") then
		local NetEaseEnv = LibStub("NetEaseEnv-1.0")

		for k in pairs(NetEaseEnv._NSInclude) do
			if type(k) == "table" then
				local module = k.Addon and k.Addon.GetClass and k.Addon:GetClass("MemberDisplay")
				if module and module.SetActivity then
					local original = module.SetActivity
					module.SetActivity = function(self, activity)
						self.resultID = activity and activity.GetID and activity:GetID() or nil
						original(self, activity)
					end
				end
			end
		end
	end
end

function EX:Enumerate_Reskin(parent, icon, role, class)
	if not icon.icbg then
		icon:SetSize(18, 18)
		icon.icbg = B.CreateBDFrame(icon, 0, -C.mult)
	end

	if not icon.role then
		icon.role = parent:CreateTexture(nil, "OVERLAY")
		icon.role:SetSize(18, 18)
		icon.role:SetPoint("CENTER", icon, "TOP")
	end

	if role then
		icon.role:SetAtlas(roleAtlas[role])
	end

	if class then
		icon:SetTexture(DB.classTex)
		icon:SetTexCoord(B.GetClassTexCoord(class))
		icon:SetAlpha(1)
		icon.role:SetAlpha(1)
		icon.icbg:SetAlpha(1)
	else
		icon:SetAlpha(0)
		icon.role:SetAlpha(0)
		icon.icbg:SetAlpha(0)
	end
end

function EX.Enumerate_Update(Enumerate)
	local button = Enumerate:GetParent():GetParent()
	if not button.resultID then return end

	local result = C_LFGList.GetSearchResultInfo(button.resultID)
	if not result then return end

	for i = 1, result.numMembers do
		local role, class = C_LFGList.GetSearchResultMemberInfo(button.resultID, i)
		tinsert(roleCache[role], class)
	end

	for i = 5, 1, -1 do
		local icon = Enumerate["Icon"..i]
		if icon and icon.SetTexture then
			if #roleCache.TANK > 0 then
				EX:Enumerate_Reskin(Enumerate, icon, "TANK", roleCache.TANK[1])
				tremove(roleCache.TANK, 1)
			elseif #roleCache.HEALER > 0 then
				EX:Enumerate_Reskin(Enumerate, icon, "HEALER", roleCache.HEALER[1])
				tremove(roleCache.HEALER, 1)
			elseif #roleCache.DAMAGER > 0 then
				EX:Enumerate_Reskin(Enumerate, icon, "DAMAGER", roleCache.DAMAGER[1])
				tremove(roleCache.DAMAGER, 1)
			else
				EX:Enumerate_Reskin(Enumerate, icon)
			end

			icon:ClearAllPoints()
			if i == 5 then
				icon:SetPoint("LEFT", Enumerate, "LEFT", 10, 0)
			else
				icon:SetPoint("LEFT", Enumerate["Icon"..(i+1)], "RIGHT", B.Scale(4), 0)
			end
		end
	end
end

function EX.RoleCount_Update(self)
	if not self.styled then
		B.ReskinRole(self.TankIcon, "TANK")
		B.ReskinRole(self.HealerIcon, "HEALER")
		B.ReskinRole(self.DamagerIcon, "DPS")

		self.DamagerIcon:ClearAllPoints()
		self.DamagerIcon:SetPoint("RIGHT", self, "RIGHT", -10, 0)
		self.HealerIcon:ClearAllPoints()
		self.HealerIcon:SetPoint("RIGHT", self.DamagerIcon, "LEFT", -24, 0)
		self.TankIcon:ClearAllPoints()
		self.TankIcon:SetPoint("RIGHT", self.HealerIcon, "LEFT", -24, 0)

		HandleRoleAnchor(self, "Tank")
		HandleRoleAnchor(self, "Healer")
		HandleRoleAnchor(self, "Damager")

		if self.Count then self.Count:SetWidth(25) end

		self.styled = true
	end
end

function EX:LFGListEnhance()
	HandleMeetingStone()
	hooksecurefunc("LFGListGroupDataDisplayEnumerate_Update", EX.Enumerate_Update)
	hooksecurefunc("LFGListGroupDataDisplayRoleCount_Update", EX.RoleCount_Update)
end