local _, ns = ...
local B, C, L, DB = unpack(ns)
local Misc = B:GetModule("Misc")

--[[
	QuickJoin 优化系统自带的预创建功能
	1.修复简中语系的一个报错
	2.双击搜索结果，快速申请
	3.自动隐藏部分窗口
]]

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
	C_Timer.After(1, Misc.DialogHideInSecond)
end

function Misc:QuickJoin()
	for i = 1, 10 do
		local bu = _G["LFGListSearchPanelScrollFrameButton"..i]
		if bu then
			bu:HookScript("OnDoubleClick", Misc.HookApplicationClick)
		end
	end

	hooksecurefunc("LFGListInviteDialog_Accept", function()
		if PVEFrame:IsShown() then HideUIPanel(PVEFrame) end
	end)

	hooksecurefunc("StaticPopup_Show", Misc.HookDialogOnShow)
	hooksecurefunc("LFGListInviteDialog_Show", Misc.HookDialogOnShow)
end
Misc:RegisterMisc("QuickJoin", Misc.QuickJoin)