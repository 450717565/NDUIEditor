local _, ns = ...
local B, C, L, DB = unpack(ns)
local SKIN = B:GetModule("Skins")

function SKIN:Other()
	if IsAddOnLoaded("EasyScrap") then
		EasyScrapParentFrame:ClearAllPoints()
		EasyScrapParentFrame:SetPoint("LEFT", ScrappingMachineFrame, "RIGHT", 3, 0)
	end
end

C.OnLoginThemes["Other"] = SKIN.Other