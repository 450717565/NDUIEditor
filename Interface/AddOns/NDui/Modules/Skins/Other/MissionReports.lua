local _, ns = ...
local B, C, L, DB = unpack(ns)
local SKIN = B:GetModule("Skins")

function SKIN:MissionReports()
	if not IsAddOnLoaded("MissionReports") then return end

	for index = 11, 14 do
		local tab = select(index, GarrisonLandingPage:GetChildren())
		if tab and not tab.styled then
			B.ReskinSideTab(tab)

			tab:ClearAllPoints()
			if index == 11 then
				tab:SetPoint("TOPLEFT", GarrisonLandingPage, "TOPRIGHT", 2, -25)
			else
				tab:SetPoint("TOP", select((index-1), GarrisonLandingPage:GetChildren()), "BOTTOM", 0, -25)
			end

			tab.styled = true
		end
	end
end

C.OnLoginThemes["Blizzard_GarrisonUI"] = SKIN.MissionReports