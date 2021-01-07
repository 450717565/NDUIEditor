local _, ns = ...
local B, C, L, DB = unpack(ns)
local Skins = B:GetModule("Skins")

function Skins:Other()
	if IsAddOnLoaded("EasyScrap") then
		EasyScrapParentFrame:ClearAllPoints()
		EasyScrapParentFrame:SetPoint("LEFT", ScrappingMachineFrame, "RIGHT", 3, 0)
	end
end