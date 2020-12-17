local B, C, L, DB = unpack(select(2, ...))
local Skins = B:GetModule("Skins")

function Skins:WorldQuestTab()
	if not IsAddOnLoaded("WorldQuestTab") then return end

	B.StripTextures(WQT_OverlayFrame)
	B.StripTextures(WQT_OverlayFrame.DetailFrame)
	B.StripTextures(WQT_QuestLogFiller)
	B.StripTextures(WQT_QuestScrollFrame.DetailFrame)
	B.StripTextures(WQT_SettingsFrame)
	B.StripTextures(WQT_WorldQuestFrame, 0)

	B.ReskinClose(WQT_OverlayFrame.CloseButton)
	B.ReskinButton(WQT_WorldQuestFrameSettingsButton)
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
		for k = 1, 3 do
			local reward = button.Rewards["Reward"..k]
			if reward then
				if not reward.styled then
					local icbg = B.ReskinIcon(reward.Icon)
					B.ReskinBorder(reward.IconBorder, icbg)

					reward.styled = true
				end

				reward:ClearAllPoints()
				if k == 1 then
					reward:SetPoint("RIGHT", button, "RIGHT", -5, 0)
				else
					reward:SetPoint("RIGHT", button.Rewards["Reward"..(k-1)].icbg, "LEFT", -2, 0)
				end
			end
		end

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