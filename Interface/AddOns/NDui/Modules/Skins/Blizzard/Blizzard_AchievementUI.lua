local B, C, L, DB = unpack(select(2, ...))

C.themes["Blizzard_AchievementUI"] = function()
	local cr, cg, cb = DB.r, DB.g, DB.b

	B.ReskinFrame(AchievementFrame)

	AchievementFrameHeaderPoints:ClearAllPoints()
	AchievementFrameHeaderPoints:SetPoint("BOTTOM", AchievementFrameSummaryAchievementsHeaderTitle, "TOP", 0, 8)

	AchievementFrameComparisonHeader:ClearAllPoints()
	AchievementFrameComparisonHeader:SetPoint("BOTTOMRIGHT", AchievementFrame, "TOPRIGHT", -10, 8)

	AchievementFrameTab1:ClearAllPoints()
	AchievementFrameTab1:SetPoint("TOPLEFT", AchievementFrame, "BOTTOMLEFT", 10, 2)

	AchievementFrameHeaderTitle:Hide()
	AchievementFrameSummaryAchievementsEmptyText:SetText("")

	select(1, AchievementFrameSummary:GetChildren()):Hide()
	select(2, AchievementFrameAchievements:GetChildren()):Hide()
	select(3, AchievementFrameStats:GetChildren()):Hide()
	select(5, AchievementFrameComparison:GetChildren()):Hide()

	local frames = {AchievementFrameHeader, AchievementFrameCategories, AchievementFrameSummary, AchievementFrameSummaryCategoriesHeader, AchievementFrameSummaryAchievementsHeader, AchievementFrameStatsBG, AchievementFrameAchievements, AchievementFrameComparison, AchievementFrameComparisonHeader}
	for _, frame in pairs(frames) do
		B.StripTextures(frame, 0)
	end

	local scrolls = {AchievementFrameAchievementsContainerScrollBar, AchievementFrameCategoriesContainerScrollBar, AchievementFrameStatsContainerScrollBar, AchievementFrameComparisonContainerScrollBar, AchievementFrameComparisonStatsContainerScrollBar}
	for _, scroll in pairs(scrolls) do
		B.ReskinScroll(scroll)
	end

	local statusBar = AchievementFrameSummaryCategoriesStatusBar
	B.ReskinStatusBar(statusBar)
	local barTitle = AchievementFrameSummaryCategoriesStatusBarTitle
	barTitle:SetTextColor(1, 1, 1)
	barTitle:ClearAllPoints()
	barTitle:SetPoint("LEFT", statusBar, "LEFT", 6, 0)
	local barText = AchievementFrameSummaryCategoriesStatusBarText
	barText:ClearAllPoints()
	barText:SetPoint("RIGHT", statusBar, "RIGHT", -5, 0)

	local searchBox = AchievementFrame.searchBox
	searchBox:ClearAllPoints()
	searchBox:SetPoint("RIGHT", AchievementFrameCloseButton, "LEFT", -5, 0)
	B.StripTextures(AchievementFrame.searchPreviewContainer)
	B.ReskinInput(searchBox, 17, 100)

	for i = 1, 5 do
		B.ReskinSearchBox(AchievementFrame.searchPreviewContainer["searchPreview"..i])
	end
	B.ReskinSearchBox(AchievementFrame.searchPreviewContainer.showAllSearchResults)
	B.ReskinSearchResult(AchievementFrame)

	local dropDown = AchievementFrameFilterDropDown
	B.ReskinDropDown(dropDown)
	dropDown:ClearAllPoints()
	dropDown:SetPoint("RIGHT", searchBox, "LEFT", 0, 0)

	for i = 1, 12 do
		local bars = "AchievementFrameSummaryCategoriesCategory"..i

		local bar = _G[bars]
		B.ReskinStatusBar(bar)

		bar.label:SetTextColor(1, 1, 1)
		bar.label:ClearAllPoints()
		bar.label:SetPoint("LEFT", bar, "LEFT", 6, 0)
		bar.text:ClearAllPoints()
		bar.text:SetPoint("RIGHT", bar, "RIGHT", -5, 0)

		local highlight = _G[bars.."ButtonHighlight"]
		highlight:SetAlpha(0)
	end

	for i = 1, 7 do
		local button = "AchievementFrameAchievementsContainerButton"..i

		local bu = _G[button]
		B.StripTextures(bu, 0)
		B.CreateBDFrame(bu, 0, -C.mult*2)

		local hl = _G[button.."Highlight"]
		hl:SetAlpha(0)

		local io = _G[button.."IconOverlay"]
		io:Hide()

		local ic = _G[button.."IconTexture"]
		local icbg = B.ReskinIcon(ic)

		local ch = _G[button.."Tracked"]
		ch:SetSize(22, 22)
		ch:ClearAllPoints()
		ch:SetPoint("TOPLEFT", icbg, "BOTTOMLEFT", -2, 0)
		B.ReskinCheck(ch)
	end

	for i = 1, 20 do
		local bu = _G["AchievementFrameStatsContainerButton"..i]
		B.StripTextures(bu)

		local hl = bu:GetHighlightTexture()
		hl:SetColorTexture(cr, cg, cb, .25)
		hl:SetBlendMode("BLEND")
	end

	hooksecurefunc("AchievementFrame_UpdateTabs", function()
		B.SetupTabStyle(AchievementFrame, 3)
	end)

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
			B.ReskinStatusBar(bar)

			bar.styled = true
		end
	end)

	hooksecurefunc("AchievementButton_DisplayAchievement", function(button, category, achievement)
		local completed = select(4, GetAchievementInfo(category, achievement))
		if completed then
			if button.accountWide then
				button.label:SetTextColor(0, .8, 1)
			else
				button.label:SetTextColor(1, .8, 0)
			end
			button.reward:SetTextColor(0, 1, 0)
			button.description:SetTextColor(1, 1, 1)
			button.hiddenDescription:SetTextColor(1, 1, 1)
		else
			if button.accountWide then
				button.label:SetTextColor(0, .8, 1, .5)
			else
				button.label:SetTextColor(1, .8, 0, .5)
			end
			button.reward:SetTextColor(0, 1, 0, .5)
			button.description:SetTextColor(1, 1, 1, .5)
			button.hiddenDescription:SetTextColor(1, 1, 1, .5)
		end
	end)

	hooksecurefunc("AchievementFrameCategories_Update", function()
		for i = 1, 19 do
			local bu = _G["AchievementFrameCategoriesContainerButton"..i]
			if not bu.styled then
				B.StripTextures(bu)

				local bubg = B.CreateBDFrame(bu, 0, -C.mult*2)
				B.ReskinHighlight(bu, bubg, true)

				bu.styled = true
			end
		end
	end)

	hooksecurefunc("AchievementFrameSummary_UpdateAchievements", function()
		for i = 1, 4 do
			local button = "AchievementFrameSummaryAchievement"..i

			local bu = _G[button]
			bu.description:SetTextColor(1, 1, 1)

			if bu.accountWide then
				bu.label:SetTextColor(0, .8, 1)
			else
				bu.label:SetTextColor(1, .8, 0)
			end

			if not bu.styled then
				B.StripTextures(bu, 0)
				B.CreateBDFrame(bu, 0, -3)

				local hl = _G[button.."Highlight"]
				hl:SetAlpha(0)

				local io = _G[button.."IconOverlay"]
				io:Hide()

				local ic = _G[button.."IconTexture"]
				B.ReskinIcon(ic)

				bu.styled = true
			end
		end
	end)

	-- Comparison
	local summaries = {AchievementFrameComparisonSummaryPlayer, AchievementFrameComparisonSummaryFriend}
	for _, summary in pairs(summaries) do
		B.StripTextures(summary)
		B.CreateBDFrame(summary, 0, -C.mult*2)
	end

	local bars = {AchievementFrameComparisonSummaryPlayerStatusBar, AchievementFrameComparisonSummaryFriendStatusBar}
	for _, bar in pairs(bars) do
		B.ReskinStatusBar(bar)

		local name = bar:GetName()

		local title = _G[name.."Title"]
		title:SetTextColor(1, 1, 1)
		title:ClearAllPoints()
		title:SetPoint("LEFT", bar, "LEFT", 6, 0)

		local text = _G[name.."Text"]
		text:ClearAllPoints()
		text:SetPoint("RIGHT", bar, "RIGHT", -5, 0)
	end

	for i = 1, 9 do
		local button = "AchievementFrameComparisonContainerButton"..i

		for _, bu in pairs({"Player", "Friend"}) do
			B.StripTextures(_G[button..bu], 0)
			B.CreateBDFrame(_G[button..bu], 0, -C.mult*2)
		end

		for _, io in pairs({"PlayerIconOverlay", "FriendIconOverlay"}) do
			_G[button..io]:Hide()
		end

		for _, ic in pairs({"PlayerIconTexture", "FriendIconTexture"}) do
			B.ReskinIcon(_G[button..ic])
		end
	end

	for i = 1, 20 do
		B.StripTextures(_G["AchievementFrameComparisonStatsContainerButton"..i])
	end

	hooksecurefunc("AchievementFrameComparison_DisplayAchievement", function(button, category, index)
		local completed = select(4, GetAchievementInfo(category, index))
		local player = button.player

		if completed then
			if player.accountWide then
				player.label:SetTextColor(0, .8, 1)
			else
				player.label:SetTextColor(1, .8, 0)
			end
			player.description:SetTextColor(1, 1, 1)
		else
			if player.accountWide then
				player.label:SetTextColor(0, .8, 1, .5)
			else
				player.label:SetTextColor(1, .8, 0, .5)
			end
			player.description:SetTextColor(1, 1, 1, .5)
		end
	end)

	-- Font width fix
	hooksecurefunc("AchievementObjectives_DisplayProgressiveAchievement", function()
		local index = 1
		while true do
			local mini = _G["AchievementFrameMiniAchievement"..index]
			if not mini then return end

			if not mini.styled then
				mini.points:SetWidth(22)
				mini.points:ClearAllPoints()
				mini.points:SetPoint("BOTTOMRIGHT", 2, 2)

				mini.styled = true
			end

			index = index + 1
		end
	end)
end