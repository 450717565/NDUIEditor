local _, ns = ...
local B, C, L, DB, P = unpack(ns)
local EX = B:GetModule("Extras")

--------------------------
-- Credit: ElvUI_WindTools
--------------------------

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
		icon.icbg = B.CreateBDFrame(icon, 0, -C.mult)
	end

	if not icon.line then
		local line = parent:CreateTexture(nil, "ARTWORK")
		line:SetTexture(DB.normTex)
		line:SetHeight(C.margin)
		line:SetPoint("TOPLEFT", icon.icbg, "BOTTOMLEFT", 0, -C.mult)
		line:SetPoint("TOPRIGHT", icon.icbg, "BOTTOMRIGHT", 0, -C.mult)
		icon.line = line
	end

	if role then
		icon:SetTexture(DB.rolesTex)
		icon:SetTexCoord(B.GetRoleTexCoord(role))
		icon:SetSize(18, 18)
		icon:SetAlpha(1)
		icon.icbg:SetAlpha(1)
	else
		icon:SetAlpha(0)
		icon.icbg:SetAlpha(0)
	end

	if class then
		local r, g, b = B.ClassColor(class)
		icon.line:SetVertexColor(r, g, b)
		icon.line:SetAlpha(1)
	else
		icon.line:SetAlpha(0)
	end
end

function EX.Enumerate_Update(Enumerate)
	local button = Enumerate:GetParent():GetParent()
	if not button.resultID then return end

	local result = C_LFGList.GetSearchResultInfo(button.resultID)
	if not result then return end

	local cache = {
		TANK = {},
		HEALER = {},
		DAMAGER = {}
	}

	for i = 1, result.numMembers do
		local role, class = C_LFGList.GetSearchResultMemberInfo(button.resultID, i)
		tinsert(cache[role], class)
	end

	for i = 5, 1, -1 do
		local icon = Enumerate["Icon"..i]
		if icon and icon.SetTexture then
			if #cache.TANK > 0 then
				EX:Enumerate_Reskin(Enumerate, icon, "TANK", cache.TANK[1])
				tremove(cache.TANK, 1)
			elseif #cache.HEALER > 0 then
				EX:Enumerate_Reskin(Enumerate, icon, "HEALER", cache.HEALER[1])
				tremove(cache.HEALER, 1)
			elseif #cache.DAMAGER > 0 then
				EX:Enumerate_Reskin(Enumerate, icon, "DAMAGER", cache.DAMAGER[1])
				tremove(cache.DAMAGER, 1)
			else
				EX:Enumerate_Reskin(Enumerate, icon)
			end

			icon:ClearAllPoints()
			if i == 5 then
				icon:SetPoint("LEFT", Enumerate, "LEFT", 15, 0)
			else
				icon:SetPoint("LEFT", Enumerate["Icon"..(i+1)], "RIGHT", 2+C.mult, 0)
			end
		end
	end
end

function EX.RoleCount_Update(self)
	if not self.styled then
		B.ReskinRole(self.TankIcon, "TANK")
		B.ReskinRole(self.HealerIcon, "HEALER")
		B.ReskinRole(self.DamagerIcon, "DPS")

		self.styled = true
	end
end

function EX:LFGListEnhance()
	HandleMeetingStone()
	hooksecurefunc("LFGListGroupDataDisplayEnumerate_Update", EX.Enumerate_Update)
	hooksecurefunc("LFGListGroupDataDisplayRoleCount_Update", EX.RoleCount_Update)
end