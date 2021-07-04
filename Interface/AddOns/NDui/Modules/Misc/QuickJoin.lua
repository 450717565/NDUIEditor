local _, ns = ...
local B, C, L, DB = unpack(ns)
local Misc = B:GetModule("Misc")

--[[
	QuickJoin 优化系统自带的预创建功能
	1.修复简中语系的一个报错
	2.双击搜索结果，快速申请
	3.自动隐藏部分窗口
]]

local select, wipe, sort = select, wipe, sort
local UnitClass, UnitGroupRolesAssigned = UnitClass, UnitGroupRolesAssigned
local StaticPopup_Hide, HideUIPanel = StaticPopup_Hide, HideUIPanel
local C_Timer_After = C_Timer.After
local C_LFGList_GetSearchResultMemberInfo = C_LFGList.GetSearchResultMemberInfo
local ApplicationViewerFrame = _G.LFGListFrame.ApplicationViewer
local LFG_LIST_GROUP_DATA_ATLASES = _G.LFG_LIST_GROUP_DATA_ATLASES

function Misc:HookApplicationClick()
	if LFGListFrame.SearchPanel.SignUpButton:IsEnabled() then
		LFGListFrame.SearchPanel.SignUpButton:Click()
	end
	if LFGListApplicationDialog:IsShown() and LFGListApplicationDialog.SignUpButton:IsEnabled() then
		LFGListApplicationDialog.SignUpButton:Click()
	end
end

local pendingFrame
function Misc:DialogHideInSecond()
	if not pendingFrame then return end

	if pendingFrame.informational then
		StaticPopupSpecial_Hide(pendingFrame)
	elseif pendingFrame == "LFG_LIST_ENTRY_EXPIRED_TOO_MANY_PLAYERS" then
		StaticPopup_Hide(pendingFrame)
	end
	pendingFrame = nil
end

function Misc:HookDialogOnShow()
	pendingFrame = self
	C_Timer_After(1, Misc.DialogHideInSecond)
end

function Misc:HookInviteDialog()
	if PVEFrame:IsShown() then HideUIPanel(PVEFrame) end
end

-- 搜索列表显示职业和职责图标

local roleCache = {}
local roleOrder = {
	["TANK"] = 1,
	["HEALER"] = 2,
	["DAMAGER"] = 3,
	["NONE"] = 3,
}
local roleAtlas = {
	[1] = "Soulbinds_Tree_Conduit_Icon_Protect",
	[2] = "ui_adv_health",
	[3] = "ui_adv_atk",
}

local function SortRoleOrder(a, b)
	if a and b then
		return a[1] < b[1]
	end
end

local function GetPartyMemberInfo(index)
	local class, _, _, _, _, _, role = select(6, GetRaidRosterInfo(index))
	return role, class
end

local function GetCorrectRoleInfo(self, index)
	if self.resultID then
		return C_LFGList_GetSearchResultMemberInfo(self.resultID, index)
	elseif self == ApplicationViewerFrame then
		return GetPartyMemberInfo(index)
	end
end

local function UpdateGroupRoles(self)
	wipe(roleCache)

	if not self.__owner then
		self.__owner = self:GetParent():GetParent()
	end

	for i = 1, 5 do
		local role, class = GetCorrectRoleInfo(self.__owner, i)
		local roleIndex = role and roleOrder[role]
		if class and roleIndex then
			tinsert(roleCache, {roleIndex, class})
		end
	end

	sort(roleCache, SortRoleOrder)
end

function Misc:ReplaceGroupRoles(numPlayers, _, disabled)
	if not self then return end

	UpdateGroupRoles(self)

	for i = 1, 5 do
		local icon = self.Icons[i]
		if not icon.icbg then
			icon:SetSize(18, 18)
			if i == 1 then
				B.UpdatePoint(icon, "RIGHT", self, "RIGHT", -10, 0)
			else
				B.UpdatePoint(icon, "RIGHT", self.Icons[i-1], "LEFT", -4, 0)
			end
			icon.icbg = B.CreateBDFrame(icon, 0, -C.mult)
		end

		if not icon.role then
			icon.role = self:CreateTexture(nil, "OVERLAY")
			icon.role:SetSize(18, 18)
			icon.role:SetPoint("CENTER", icon, "TOP")
		end

		if i > numPlayers then
			icon.icbg:Hide()
			icon.role:Hide()
		else
			icon.icbg:Show()
			icon.role:Show()
		end

		icon.role:SetDesaturated(disabled)
	end

	local iconIndex = numPlayers
	for i = 1, #roleCache do
		local roleInfo = roleCache[i]
		if roleInfo then
			local icon = self.Icons[iconIndex]
			local role, class = roleInfo[1], roleInfo[2]
			icon:SetTexture(DB.classTex)
			icon:SetTexCoord(B.GetClassTexCoord(class))
			icon.role:SetAtlas(roleAtlas[role])

			iconIndex = iconIndex - 1
		end
	end

	for i = 1, iconIndex do
		self.Icons[i]:Hide()
		self.Icons[i].icbg:Hide()
		self.Icons[i].role:Hide()
	end
end

function Misc:QuickJoin()
	for i = 1, 10 do
		local button = _G["LFGListSearchPanelScrollFrameButton"..i]
		if button then
			button:HookScript("OnDoubleClick", Misc.HookApplicationClick)
		end
	end

	hooksecurefunc("StaticPopup_Show", Misc.HookDialogOnShow)
	hooksecurefunc("LFGListInviteDialog_Show", Misc.HookDialogOnShow)
	hooksecurefunc("LFGListInviteDialog_Accept", Misc.HookInviteDialog)
	hooksecurefunc("LFGListGroupDataDisplayEnumerate_Update", Misc.ReplaceGroupRoles)
end
Misc:RegisterMisc("QuickJoin", Misc.QuickJoin)