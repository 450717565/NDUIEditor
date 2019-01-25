local F, C = unpack(select(2, ...))

C.themes["Blizzard_AchievementUI"] = function()
	local cr, cg, cb = C.r, C.g, C.b

	F.ReskinFrame(AchievementFrame)

	AchievementFrameHeaderPoints:ClearAllPoints()
	AchievementFrameHeaderPoints:SetPoint("BOTTOM", AchievementFrameSummaryAchievementsHeaderTitle, "TOP", 0, 8)

	AchievementFrameComparisonHeader:ClearAllPoints()
	AchievementFrameComparisonHeader:SetPoint("BOTTOMRIGHT", AchievementFrame, "TOPRIGHT", -10, 8)

	AchievementFrameHeaderTitle:Hide()
	AchievementFrameSummaryAchievementsEmptyText:SetText("")

	select(1, AchievementFrameSummary:GetChildren()):Hide()
	select(2, AchievementFrameAchievements:GetChildren()):Hide()
	select(3, AchievementFrameStats:GetChildren()):Hide()
	select(5, AchievementFrameComparison:GetChildren()):Hide()

	local frames = {AchievementFrameHeader, AchievementFrameCategories, AchievementFrameSummary, AchievementFrameSummaryCategoriesHeader, AchievementFrameSummaryAchievementsHeader, AchievementFrameStatsBG, AchievementFrameAchievements, AchievementFrameComparison, AchievementFrameComparisonHeader}
	for _, frame in next, frames do
		F.StripTextures(frame, true)
	end

	local scrolls = {AchievementFrameAchievementsContainerScrollBar, AchievementFrameCategoriesContainerScrollBar, AchievementFrameStatsContainerScrollBar, AchievementFrameScrollFrameScrollBar, AchievementFrameComparisonContainerScrollBar, AchievementFrameComparisonStatsContainerScrollBar}
	for _, scroll in next, scrolls do
		F.ReskinScroll(scroll)
	end

	local statusBar = AchievementFrameSummaryCategoriesStatusBar
	F.ReskinStatusBar(statusBar, true)
	local barTitle = AchievementFrameSummaryCategoriesStatusBarTitle
	barTitle:SetTextColor(1, 1, 1)
	barTitle:SetPoint("LEFT", statusBar, "LEFT", 6, 0)
	local barText = AchievementFrameSummaryCategoriesStatusBarText
	barText:SetPoint("RIGHT", statusBar, "RIGHT", -5, 0)

	local searchBox = AchievementFrame.searchBox
	searchBox:ClearAllPoints()
	searchBox:SetPoint("RIGHT", AchievementFrameCloseButton, "LEFT", -5, 0)
	F.StripTextures(AchievementFrame.searchPreviewContainer)
	F.ReskinInput(searchBox, 17, 100)

	F.ReskinSearchBox(AchievementFrame.showAllSearchResults)
	for i = 1, 5 do
		F.ReskinSearchBox(AchievementFrame.searchPreview[i])
	end

	local dropDown = AchievementFrameFilterDropDown
	F.ReskinDropDown(dropDown)
	dropDown:ClearAllPoints()
	dropDown:SetPoint("RIGHT", searchBox, "LEFT", 0, 0)

	local searchResults = AchievementFrame.searchResults
	searchResults:SetPoint("BOTTOMLEFT", AchievementFrame, "BOTTOMRIGHT", 20, 0)
	F.StripTextures(searchResults)
	F.ReskinClose(searchResults.closeButton)

	local bg = F.CreateBDFrame(searchResults)
	bg:SetPoint("TOPLEFT", -10, 0)
	bg:SetPoint("BOTTOMRIGHT")

	for i = 1, 8 do
		local bu = _G["AchievementFrameScrollFrameButton"..i]
		F.StripTextures(bu)

		local icbg = F.ReskinIcon(bu.icon, true)

		local bubg = F.CreateBDFrame(bu, .25)
		bubg:SetPoint("TOPLEFT", icbg, "TOPRIGHT", 2, 2)
		bubg:SetPoint("BOTTOMRIGHT", -2, 3)
		F.ReskinTexture(bu, bubg, true)

		local name = bu.name
		name:ClearAllPoints()
		name:SetPoint("TOPLEFT", bubg, 4, -6)

		local path = bu.path
		path:ClearAllPoints()
		path:SetPoint("BOTTOMLEFT", bubg, 4, 4)

		local type = bu.resultType
		type:ClearAllPoints()
		type:SetPoint("RIGHT", bubg, -2, 0)
	end

	for i = 1, 12 do
		local bar = _G["AchievementFrameSummaryCategoriesCategory"..i]
		F.ReskinStatusBar(bar, true)

		bar.label:SetTextColor(1, 1, 1)
		bar.label:SetPoint("LEFT", bar, "LEFT", 6, 0)
		bar.text:SetPoint("RIGHT", bar, "RIGHT", -5, 0)

		local highlight = _G["AchievementFrameSummaryCategoriesCategory"..i.."ButtonHighlight"]
		highlight:SetAlpha(0)
	end

	for i = 1, 7 do
		local bu = _G["AchievementFrameAchievementsContainerButton"..i]
		F.StripTextures(bu, true)

		local hl = _G["AchievementFrameAchievementsContainerButton"..i.."Highlight"]
		hl:SetAlpha(0)

		local io = _G["AchievementFrameAchievementsContainerButton"..i.."IconOverlay"]
		io:Hide()

		local ic = _G["AchievementFrameAchievementsContainerButton"..i.."IconTexture"]
		local icbg = F.ReskinIcon(ic, true)

		local ch = _G["AchievementFrameAchievementsContainerButton"..i.."Tracked"]
		ch:SetSize(22, 22)
		ch:ClearAllPoints()
		ch:SetPoint("TOPLEFT", icbg, "BOTTOMLEFT", -2, 0)
		F.ReskinCheck(ch)

		local bubg = F.CreateBDFrame(bu, .25)
		bubg:SetPoint("TOPLEFT", C.mult, -C.mult)
		bubg:SetPoint("BOTTOMRIGHT", -C.mult, C.mult)
	end

	for i = 1, 20 do
		local bu = _G["AchievementFrameStatsContainerButton"..i]
		F.StripTextures(bu)

		local hl = bu:GetHighlightTexture()
		hl:SetColorTexture(cr, cg, cb, .25)
		hl:SetBlendMode("BLEND")
	end

	for i = 1, 3 do
		F.ReskinTab(_G["AchievementFrameTab"..i])
	end

	hooksecurefunc("AchievementObjectives_DisplayCriteria", function(_, id)
		for i = 1, GetAchievementNumCriteria(id) do
			local name = _G["AchievementFrameCriteria"..i.."Name"]
			if name and select(2, name:GetTextColor()) == 0 then
				name:SetTextColor(1, 1, 1)
			end

			local meta = _G["AchievementFrameMeta"..i]
			if meta and select(2, meta.label:GetTextColor()) == 0 then
				meta.label:SetTextColor(1, 1, 1)
			end
		end
	end)

	hooksecurefunc("AchievementButton_GetProgressBar", function(index)
		local bar = _G["AchievementFrameProgressBar"..index]
		if not bar.styled then
			F.ReskinStatusBar(bar, true)

			bar.styled = true
		end
	end)

	hooksecurefunc("AchievementButton_DisplayAchievement", function(button, category, achievement)
		local completed = select(4, GetAchievementInfo(category, achievement))
		if completed then
			if button.accountWide then
				button.label:SetTextColor(.1, .5, .9)
			else
				button.label:SetTextColor(.9, .8, .1)
			end
			button.description:SetTextColor(.9, .9, .9)
		else
			if button.accountWide then
				button.label:SetTextColor(.1, .5, .9, .5)
			else
				button.label:SetTextColor(.9, .8, .1, .5)
			end
			button.description:SetTextColor(.9, .9, .9, .5)
		end
	end)

	hooksecurefunc("AchievementFrameCategories_Update", function()
		for i = 1, 19 do
			local bu = _G["AchievementFrameCategoriesContainerButton"..i]
			if not bu.styled then
				F.StripTextures(bu)

				local bubg = F.CreateBDFrame(bu, .25)
				bubg:SetPoint("TOPLEFT", C.mult, -C.mult)
				bubg:SetPoint("BOTTOMRIGHT", -C.mult, C.mult)
				F.ReskinTexture(bu, bubg, true)

				bu.styled = true
			end
		end
	end)

	hooksecurefunc("AchievementFrameSummary_UpdateAchievements", function()
		for i = 1, 4 do
			local bu = _G["AchievementFrameSummaryAchievement"..i]
			bu.description:SetTextColor(.9, .9, .9)

			if bu.accountWide then
				bu.label:SetTextColor(.1, .5, .9)
			else
				bu.label:SetTextColor(.9, .8, .1)
			end

			if not bu.styled then
				F.StripTextures(bu, true)

				local hl = _G["AchievementFrameSummaryAchievement"..i.."Highlight"]
				hl:SetAlpha(0)

				local io = _G["AchievementFrameSummaryAchievement"..i.."IconOverlay"]
				io:Hide()

				local ic = _G["AchievementFrameSummaryAchievement"..i.."IconTexture"]
				F.ReskinIcon(ic, true)

				local bubg = F.CreateBDFrame(bu, .25)
				bubg:SetPoint("TOPLEFT", 2, -2)
				bubg:SetPoint("BOTTOMRIGHT", -2, 2)

				bu.styled = true
			end
		end
	end)

	-- Comparison
	local summaries = {AchievementFrameComparisonSummaryPlayer, AchievementFrameComparisonSummaryFriend}
	for _, summary in next, summaries do
		F.StripTextures(summary)

		local bg = F.CreateBDFrame(summary, .25)
		bg:SetPoint("TOPLEFT", C.mult, -C.mult)
		bg:SetPoint("BOTTOMRIGHT", -C.mult, C.mult)
	end

	local bars = {AchievementFrameComparisonSummaryPlayerStatusBar, AchievementFrameComparisonSummaryFriendStatusBar}
	for _, bar in next, bars do
		F.ReskinStatusBar(bar, true)

		local name = bar:GetName()
		_G[name.."Title"]:SetTextColor(1, 1, 1)
		_G[name.."Title"]:SetPoint("LEFT", bar, "LEFT", 6, 0)
		_G[name.."Text"]:SetPoint("RIGHT", bar, "RIGHT", -5, 0)
	end

	for i = 1, 9 do
		local button = "AchievementFrameComparisonContainerButton"..i

		for _, bu in next, {"Player", "Friend"} do
			F.StripTextures(_G[button..bu], true)

			local bubg = F.CreateBDFrame(_G[button..bu], .25)
			bubg:SetPoint("TOPLEFT", C.mult, -C.mult)
			bubg:SetPoint("BOTTOMRIGHT", -C.mult, C.mult)
		end

		for _, io in next, {"PlayerIconOverlay", "FriendIconOverlay"} do
			_G[button..io]:Hide()
		end

		for _, ic in next, {"PlayerIconTexture", "FriendIconTexture"} do
			F.ReskinIcon(_G[button..ic], true)
		end
	end

	for i = 1, 20 do
		F.StripTextures(_G["AchievementFrameComparisonStatsContainerButton"..i])
	end

	hooksecurefunc("AchievementFrameComparison_DisplayAchievement", function(button, category, index)
		local completed = select(4, GetAchievementInfo(category, index))
		local player = button.player

		if completed then
			if player.accountWide then
				player.label:SetTextColor(.1, .5, .9)
			else
				player.label:SetTextColor(.9, .8, .1)
			end
			player.description:SetTextColor(.9, .9, .9)
		else
			if player.accountWide then
				player.label:SetTextColor(.1, .5, .9, .5)
			else
				player.label:SetTextColor(.9, .8, .1, .5)
			end
			player.description:SetTextColor(.9, .9, .9, .5)
		end
	end)

	-- Font width fix
	hooksecurefunc("AchievementObjectives_DisplayProgressiveAchievement", function()
		local index = 1
		local mini = _G["AchievementFrameMiniAchievement"..index]
		while mini do
			if not mini.styled then
				mini.points:SetWidth(22)
				mini.points:ClearAllPoints()
				mini.points:SetPoint("BOTTOMRIGHT", 2, 2)
				mini.styled = true
			end

			index = index + 1
			mini = _G["AchievementFrameMiniAchievement"..index]
		end
	end)
end