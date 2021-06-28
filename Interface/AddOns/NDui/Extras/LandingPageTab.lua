local _, ns = ...
local B, C, L, DB = unpack(ns)

local tabs = {}
local datas = {
	{Enum.GarrisonType.Type_9_0, GARRISON_TYPE_9_0_LANDING_PAGE_TITLE, [[Interface\Icons\INV_Torghast]]},
	{Enum.GarrisonType.Type_8_0, GARRISON_TYPE_8_0_LANDING_PAGE_TITLE, [[Interface\Icons\Achievement_NzothRaid_Nzoth]]},
	{Enum.GarrisonType.Type_7_0, ORDER_HALL_LANDING_PAGE_TITLE, [[Interface\Icons\Achievement_Boss_Argus_WorldSoul]]},
	{Enum.GarrisonType.Type_6_0, GARRISON_LANDING_PAGE_TITLE, [[Interface\Icons\Achievement_Boss_HellFire_Archimonde]]},
}

local function Select_LandingPage(self)
	HideUIPanel(GarrisonLandingPage)
	ShowGarrisonLandingPage(self.pageID)
end

local function Setup_LandingPage()
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
end

local function Update_LandingPage(pageID)
	for _, tab in pairs(tabs) do
		local available = not not (C_Garrison.GetGarrisonInfo(tab.pageID))
		tab:SetEnabled(available)
		tab:GetNormalTexture():SetDesaturated(not available)
		tab:SetChecked(tab.pageID == pageID)
	end
end

local function Setup_LandingPageTab()
	if IsAddOnLoaded("MissionReports") then return end

	Setup_LandingPage()
	hooksecurefunc("ShowGarrisonLandingPage", Update_LandingPage)
end

B.LoadWithAddOn("Blizzard_GarrisonUI", Setup_LandingPageTab)