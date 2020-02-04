local B, C, L, DB = unpack(select(2, ...))
local S = B:GetModule("Skins")

function S:WorldQuestTab()
	if not IsAddOnLoaded("WorldQuestTab") then return end

	WQT_TabNormal.TabBg:Hide()
	WQT_TabNormal.Hider:Hide()
	WQT_TabNormal.Highlight:SetTexture("")
	WQT_TabNormal.Icon:SetPoint("CENTER")

	WQT_TabWorld:ClearAllPoints()
	WQT_TabWorld:SetPoint("LEFT", WQT_TabNormal, "RIGHT", 2, 0)
	WQT_TabWorld.TabBg:Hide()
	WQT_TabWorld.Hider:Hide()
	WQT_TabWorld.Highlight:SetTexture("")
	WQT_TabWorld.Icon:SetPoint("CENTER")

	B.StripTextures(WQT_WorldQuestFrame)
	B.StripTextures(WQT_QuestScrollFrame.DetailFrame)
	B.ReskinButton(WQT_TabNormal)
	B.ReskinButton(WQT_TabWorld)
	B.ReskinDropDown(WQT_WorldQuestFrameSortButton)
	B.ReskinFilter(WQT_WorldQuestFrameFilterButton)
	B.ReskinScroll(WQT_QuestScrollFrameScrollBar)

	WQT_WorldQuestFrame.FilterBar:GetRegions():Hide()

	for r = 1, 15 do
		local bu = _G["WQT_QuestScrollFrameButton"..r]

		local rw = bu.Reward
		rw:SetSize(26, 26)
		rw.IconBorder:Hide()
		B.ReskinIcon(rw.Icon)

		local fac = bu.Faction
		B.ReskinIcon(fac.Icon)

		local tm = bu.Time
		tm:ClearAllPoints()
		tm:SetPoint("LEFT", fac, "RIGHT", 5, -7)
	end
end