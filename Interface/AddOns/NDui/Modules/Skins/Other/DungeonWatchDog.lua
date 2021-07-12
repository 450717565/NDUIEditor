local _, ns = ...
local B, C, L, DB = unpack(ns)
local SKIN = B:GetModule("Skins")

local function Update_FrameAnchor(self)
	self:ClearAllPoints()
	self:SetPoint("RIGHT", PVEFrameCloseButton, "LEFT", -3, 0)
end

function SKIN:DungeonWatchDog()
	if not IsAddOnLoaded("DungeonWatchDog") then return end

	local button = select(11, LFGListFrame.SearchPanel:GetChildren())
	B.ReskinButton(button)
	button:SetSize(40, 20)

	button:HookScript("OnShow", Update_FrameAnchor)
end

C.OnLoginThemes["DungeonWatchDog"] = SKIN.DungeonWatchDog