local B, C, L, DB = unpack(select(2, ...))
local Skins = B:GetModule("Skins")

function Skins:WorldQuestTab()
	if not IsAddOnLoaded("WorldQuestTab") then return end

	B.StripTextures(WQT_WorldQuestFrame, 0)
	B.StripTextures(WQT_QuestScrollFrame.DetailFrame)
	B.StripTextures(WQT_QuestLogFiller)

	B.ReskinFrame(WQT_OverlayFrame)
	B.StripTextures(WQT_OverlayFrame.DetailFrame)

	B.ReskinDropDown(WQT_WorldQuestFrameSortButton)
	B.ReskinFilter(WQT_WorldQuestFrameFilterButton)
	B.ReskinScroll(WQT_QuestScrollFrameScrollBar)

	for _, tab in pairs({WQT_TabNormal, WQT_TabWorld}) do
		B.StripTextures(tab, 2)
		B.ReskinButton(tab)

		local icon = tab.Icon
		icon:ClearAllPoints()
		icon:SetPoint("CENTER")

		B.ReskinHighlight(tab.Hider, tab)
	end

	for i = 1, 15 do
		local button = _G["WQT_QuestScrollFrameButton"..i]

		local Reward = button.Reward
		Reward:ClearAllPoints()
		Reward:SetPoint("RIGHT", button, "RIGHT", -5, 0)
		Reward.Icon:SetDrawLayer("ARTWORK")
		local icbg = B.ReskinIcon(Reward.Icon)
		B.ReskinBorder(Reward.IconBorder, icbg)

		local Faction = button.Faction
		Faction.Ring:Hide()

		local Title = button.Title
		Title:ClearAllPoints()
		Title:SetPoint("BOTTOMLEFT", Faction, "RIGHT", 0, 0)

		local Time = button.Time
		Time:ClearAllPoints()
		Time:SetPoint("TOPLEFT", Faction, "RIGHT", 5, 0)
	end
end