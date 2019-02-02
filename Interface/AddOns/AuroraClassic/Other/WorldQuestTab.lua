local F, C = unpack(select(2, ...))

C.themes["WorldQuestTab"] = function()
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

	F.StripTextures(WQT_WorldQuestFrame)
	F.StripTextures(WQT_QuestScrollFrame.DetailFrame)
	F.ReskinButton(WQT_TabNormal)
	F.ReskinButton(WQT_TabWorld)
	F.ReskinDropDown(WQT_WorldQuestFrameSortButton)
	F.ReskinFilter(WQT_WorldQuestFrameFilterButton)
	F.ReskinScroll(WQT_QuestScrollFrameScrollBar)

	WQT_WorldQuestFrame.FilterBar:GetRegions():Hide()

	for r = 1, 15 do
		local bu = _G["WQT_QuestScrollFrameButton"..r]

		local rw = bu.Reward
		rw:SetSize(26, 26)
		rw.IconBorder:Hide()
		F.ReskinIcon(rw.Icon)

		local fac = bu.Faction
		F.ReskinIcon(fac.Icon)

		local tm = bu.Time
		tm:ClearAllPoints()
		tm:SetPoint("LEFT", fac, "RIGHT", 5, -7)
	end
end