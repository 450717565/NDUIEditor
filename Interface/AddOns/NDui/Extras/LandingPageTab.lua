local _, ns = ...
local B, C, L, DB = unpack(ns)

if IsAddOnLoaded("MissionReports") then return end

local tabs = {}
local datas = {
	{Enum.GarrisonType.Type_9_0, GARRISON_TYPE_9_0_LANDING_PAGE_TITLE, [[Interface\Icons\Inv_torghast]]},
	{Enum.GarrisonType.Type_8_0, GARRISON_TYPE_8_0_LANDING_PAGE_TITLE, [[Interface\Icons\Achievement_nzothraid_nzoth]]},
	{Enum.GarrisonType.Type_7_0, ORDER_HALL_LANDING_PAGE_TITLE, [[Interface\Icons\Achievement_boss_argus_worldsoul]]},
	{Enum.GarrisonType.Type_6_0, GARRISON_LANDING_PAGE_TITLE, [[Interface\Icons\Achievement_boss_hellfire_archimonde]]},
}

local function Select_LandingPage(self)
	HideUIPanel(GarrisonLandingPage)
	ShowGarrisonLandingPage(self.pageID)
end

local function Setup_LandingPage(event, addon)
	if addon == "Blizzard_GarrisonUI" then
		for index, data in pairs(datas) do
			local tab = CreateFrame("CheckButton", nil, GarrisonLandingPage, "SpellBookSkillLineTabTemplate")
			tab:SetNormalTexture(data[3])
			tab:SetFrameStrata("LOW")
			tab:SetScript("OnClick", Select_LandingPage)
			tab:Show()

			tab:ClearAllPoints()
			if index == 1 then
				tab:SetPoint("TOPLEFT", GarrisonLandingPage, "TOPRIGHT", 2, -25)
			else
				tab:SetPoint("TOP", tabs[index-1], "BOTTOM", 0, -25)
			end

			B.ReskinSideTab(tab)

			tab.pageID = data[1]
			tab.tooltip = data[2]
			table.insert(tabs, tab)
		end

		B:UnregisterEvent(event, Setup_LandingPage)
	end
end
B:RegisterEvent("ADDON_LOADED", Setup_LandingPage)

local function Update_LandingPage(pageID)
	for _, tab in pairs(tabs) do
		local available = not not (C_Garrison.GetGarrisonInfo(tab.pageID))
		tab:SetEnabled(available)
		tab:GetNormalTexture():SetDesaturated(not available)
		tab:SetChecked(tab.pageID == pageID)
	end
end
hooksecurefunc("ShowGarrisonLandingPage", Update_LandingPage)