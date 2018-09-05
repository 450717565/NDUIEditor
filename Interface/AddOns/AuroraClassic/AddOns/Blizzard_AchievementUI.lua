local F, C = unpack(select(2, ...))

C.themes["Blizzard_AchievementUI"] = function()
	local r, g, b = C.r, C.g, C.b

	local frames = {AchievementFrame, AchievementFrameHeader, AchievementFrameSummary, AchievementFrameSummaryCategoriesHeader, AchievementFrameSummaryAchievementsHeader, AchievementFrameCategories, AchievementFrameCategoriesContainerScrollBar, AchievementFrameAchievements, AchievementFrameComparison, AchievementFrameComparisonHeader, AchievementFrameStatsBG}
	for _, frame in next, frames do
		F.StripTextures(frame, true)
	end
	F.CreateBD(AchievementFrame)
	F.CreateSD(AchievementFrame)
	AchievementFrameHeaderTitle:Hide()
	AchievementFrameSummary:GetChildren():Hide()
	select(2, AchievementFrameAchievements:GetChildren()):Hide()
	select(5, AchievementFrameComparison:GetChildren()):Hide()
	select(3, AchievementFrameStats:GetChildren()):Hide()

	do
		local first = true
		hooksecurefunc("AchievementFrameCategories_Update", function()
			if first then
				for i = 1, 19 do
					local bu = _G["AchievementFrameCategoriesContainerButton"..i]
					F.StripTextures(bu)

					local bg = F.CreateBDFrame(bu, .25)
					bg:SetPoint("TOPLEFT", 0, -1)
					bg:SetPoint("BOTTOMRIGHT")

					bu:SetHighlightTexture(C.media.backdrop)
					local hl = bu:GetHighlightTexture()
					hl:SetVertexColor(r, g, b, .25)
					hl:SetPoint("TOPLEFT", 1, -2)
					hl:SetPoint("BOTTOMRIGHT", -1, 1)
				end
				first = false
			end
		end)
	end

	AchievementFrameHeaderPoints:ClearAllPoints()
	AchievementFrameHeaderPoints:SetPoint("BOTTOM", AchievementFrameSummaryAchievementsHeaderTitle, "TOP", 0, 6)
	AchievementFrameFilterDropDown:ClearAllPoints()
	AchievementFrameFilterDropDown:SetPoint("TOPRIGHT", -120, 1)
	AchievementFrameFilterDropDownText:ClearAllPoints()
	AchievementFrameFilterDropDownText:SetPoint("CENTER", -9, 2)

	AchievementFrameSummaryCategoriesStatusBarTitle:SetTextColor(1, 1, 1)
	AchievementFrameSummaryCategoriesStatusBarTitle:SetPoint("LEFT", AchievementFrameSummaryCategoriesStatusBar, "LEFT", 6, 0)
	AchievementFrameSummaryCategoriesStatusBarText:SetPoint("RIGHT", AchievementFrameSummaryCategoriesStatusBar, "RIGHT", -5, 0)
	F.ReskinStatusBar(AchievementFrameSummaryCategoriesStatusBar, true, true)

	for i = 1, 3 do
		F.ReskinTab(_G["AchievementFrameTab"..i])
	end

	for i = 1, 7 do
		local bu = _G["AchievementFrameAchievementsContainerButton"..i]
		local buic = _G["AchievementFrameAchievementsContainerButton"..i.."Icon"]

		F.StripTextures(bu, true)
		_G["AchievementFrameAchievementsContainerButton"..i.."Highlight"]:SetAlpha(0)
		_G["AchievementFrameAchievementsContainerButton"..i.."IconOverlay"]:Hide()

		bu.description:SetTextColor(.9, .9, .9)
		bu.description.SetTextColor = F.dummy
		bu.description:SetShadowOffset(1, -1)
		bu.description.SetShadowOffset = F.dummy

		bu.icon.texture:SetTexCoord(.08, .92, .08, .92)
		F.CreateBDFrame(bu.icon.texture, .25)

		local bg = F.CreateBDFrame(bu, .25)
		bg:SetPoint("TOPLEFT", 1, -1)
		bg:SetPoint("BOTTOMRIGHT", 0, 2)

		local ch = bu.tracked
		ch:SetSize(22, 22)
		ch:ClearAllPoints()
		ch:SetPoint("TOPLEFT", buic, "BOTTOMLEFT", 2, 8)
		F.ReskinCheck(ch)
	end

	hooksecurefunc("AchievementButton_DisplayAchievement", function(button, category, achievement)
		local _, _, _, completed = GetAchievementInfo(category, achievement)
		if completed then
			if button.accountWide then
				button.label:SetTextColor(0, .6, 1)
			else
				button.label:SetTextColor(.9, .9, .9)
			end
		else
			if button.accountWide then
				button.label:SetTextColor(0, .3, .5)
			else
				button.label:SetTextColor(.65, .65, .65)
			end
		end
	end)

	hooksecurefunc("AchievementObjectives_DisplayCriteria", function(_, id)
		for i = 1, GetAchievementNumCriteria(id) do
			local name = _G["AchievementFrameCriteria"..i.."Name"]
			if name and select(2, name:GetTextColor()) == 0 then
				name:SetTextColor(1, 1, 1)
			end

			local bu = _G["AchievementFrameMeta"..i]
			if bu and select(2, bu.label:GetTextColor()) == 0 then
				bu.label:SetTextColor(1, 1, 1)
			end
		end
	end)

	hooksecurefunc("AchievementButton_GetProgressBar", function(index)
		local bar = _G["AchievementFrameProgressBar"..index]
		if not bar.reskinned then
			F.ReskinStatusBar(bar, true, true)
			bar.reskinned = true
		end
	end)

	-- this is hidden behind other stuff in default UI
	AchievementFrameSummaryAchievementsEmptyText:SetText("")

	hooksecurefunc("AchievementFrameSummary_UpdateAchievements", function()
		for i = 1, ACHIEVEMENTUI_MAX_SUMMARY_ACHIEVEMENTS do
			local bu = _G["AchievementFrameSummaryAchievement"..i]

			if bu.accountWide then
				bu.label:SetTextColor(0, .6, 1)
			else
				bu.label:SetTextColor(.9, .9, .9)
			end

			if not bu.reskinned then
				F.StripTextures(bu, true)
				_G["AchievementFrameSummaryAchievement"..i.."Highlight"]:SetAlpha(0)
				_G["AchievementFrameSummaryAchievement"..i.."IconOverlay"]:Hide()

				local bg = F.CreateBDFrame(bu, .25)
				bg:SetPoint("TOPLEFT", 2, -2)
				bg:SetPoint("BOTTOMRIGHT", -2, 2)

				local bd = _G["AchievementFrameSummaryAchievement"..i.."Background"]
				bd:SetTexture(C.media.backdrop)
				bd:SetVertexColor(0, 0, 0, .25)

				local text = _G["AchievementFrameSummaryAchievement"..i.."Description"]
				text:SetTextColor(.9, .9, .9)
				text.SetTextColor = F.dummy
				text:SetShadowOffset(1, -1)
				text.SetShadowOffset = F.dummy

				local ic = _G["AchievementFrameSummaryAchievement"..i.."IconTexture"]
				ic:SetTexCoord(.08, .92, .08, .92)
				F.CreateBDFrame(ic)

				bu.reskinned = true
			end
		end
	end)

	for i = 1, 12 do
		local bu = _G["AchievementFrameSummaryCategoriesCategory"..i]
		local label = _G["AchievementFrameSummaryCategoriesCategory"..i.."Label"]

		_G["AchievementFrameSummaryCategoriesCategory"..i.."ButtonHighlight"]:SetAlpha(0)

		label:SetTextColor(1, 1, 1)
		label:SetPoint("LEFT", bu, "LEFT", 6, 0)
		bu.text:SetPoint("RIGHT", bu, "RIGHT", -5, 0)
		F.ReskinStatusBar(bu, true, true)
	end

	for i = 1, 20 do
		local bu = _G["AchievementFrameStatsContainerButton"..i]
		F.StripTextures(bu)
		bu:GetHighlightTexture():SetColorTexture(r, g, b, .25)
		bu:GetHighlightTexture():SetBlendMode("BLEND")
	end
	AchievementFrameComparisonHeader:ClearAllPoints()
	AchievementFrameComparisonHeader:SetPoint("BOTTOMRIGHT", AchievementFrame, "TOPRIGHT", -10, 8)

	local headerbg = F.CreateBDFrame(AchievementFrameComparisonHeader)
	headerbg:SetPoint("TOPLEFT", 20, -20)
	headerbg:SetPoint("BOTTOMRIGHT", -28, -5)
	headerbg:SetFrameLevel(AchievementFrameComparisonHeader:GetFrameLevel()-1)

	local summaries = {AchievementFrameComparisonSummaryPlayer, AchievementFrameComparisonSummaryFriend}
	for _, frame in pairs(summaries) do
		F.StripTextures(frame, true)

		local bg = F.CreateBDFrame(frame, 0)
		bg:SetPoint("TOPLEFT", 2, -2)
		bg:SetPoint("BOTTOMRIGHT", -2, 0)
		bg:SetFrameLevel(frame:GetFrameLevel()-1)
	end

	local bars = {AchievementFrameComparisonSummaryPlayerStatusBar, AchievementFrameComparisonSummaryFriendStatusBar}
	for _, bar in pairs(bars) do
		F.ReskinStatusBar(bar, true, true)

		local name = bar:GetName()
		_G[name.."Title"]:SetTextColor(1, 1, 1)
		_G[name.."Title"]:SetPoint("LEFT", bar, "LEFT", 6, 0)
		_G[name.."Text"]:SetPoint("RIGHT", bar, "RIGHT", -5, 0)
	end

	for i = 1, 9 do
		local buttons = {_G["AchievementFrameComparisonContainerButton"..i.."Player"], _G["AchievementFrameComparisonContainerButton"..i.."Friend"]}
		for _, button in pairs(buttons) do
			F.StripTextures(button, true)

			local bg = F.CreateBDFrame(button, 0)
			bg:SetPoint("TOPLEFT", 2, 0)
			bg:SetPoint("BOTTOMRIGHT", -2, 2)
		end
		_G["AchievementFrameComparisonContainerButton"..i.."PlayerIconOverlay"]:Hide()
		_G["AchievementFrameComparisonContainerButton"..i.."FriendIconOverlay"]:Hide()

		local text = _G["AchievementFrameComparisonContainerButton"..i.."PlayerDescription"]
		text:SetTextColor(.9, .9, .9)
		text.SetTextColor = F.dummy
		text:SetShadowOffset(1, -1)
		text.SetShadowOffset = F.dummy

		local ic = _G["AchievementFrameComparisonContainerButton"..i.."PlayerIconTexture"]
		ic:SetTexCoord(.08, .92, .08, .92)
		F.CreateBDFrame(ic, .25)

		local ic = _G["AchievementFrameComparisonContainerButton"..i.."FriendIconTexture"]
		ic:SetTexCoord(.08, .92, .08, .92)
		F.CreateBDFrame(ic, .25)
	end

	F.ReskinClose(AchievementFrameCloseButton)
	F.ReskinScroll(AchievementFrameAchievementsContainerScrollBar)
	F.ReskinScroll(AchievementFrameStatsContainerScrollBar)
	F.ReskinScroll(AchievementFrameCategoriesContainerScrollBar)
	F.ReskinScroll(AchievementFrameComparisonContainerScrollBar)
	F.ReskinDropDown(AchievementFrameFilterDropDown)

	local sbox = AchievementFrame.searchBox
	sbox:SetSize(100, 17)
	sbox:ClearAllPoints()
	sbox:SetPoint("RIGHT", AchievementFrameCloseButton, "LEFT", -5, 0)
	F.ReskinInput(AchievementFrame.searchBox)

	F.StripTextures(AchievementFrame.searchPreviewContainer, true)
	local function styleSearchButton(result)
		F.StripTextures(result)

		if result.icon then
			F.ReskinIcon(result.icon)
		end

		local bd = F.CreateBDFrame(result, .25)
		bd:SetPoint("TOPLEFT")
		bd:SetPoint("BOTTOMRIGHT", 0, 1)

		result:SetHighlightTexture(C.media.backdrop)
		local hl = result:GetHighlightTexture()
		hl:SetVertexColor(r, g, b, .25)
		hl:SetPoint("TOPLEFT", 1, -1)
		hl:SetPoint("BOTTOMRIGHT", -1, 2)
	end

	for i = 1, 5 do
		styleSearchButton(AchievementFrame.searchPreview[i])
	end
	styleSearchButton(AchievementFrame.showAllSearchResults)

	do
		local result = AchievementFrame.searchResults
		result:SetPoint("BOTTOMLEFT", AchievementFrame, "BOTTOMRIGHT", 10, 0)
		F.StripTextures(result, true)

		local bg = F.CreateBDFrame(result)
		bg:SetPoint("TOPLEFT", -10, 0)
		bg:SetPoint("BOTTOMRIGHT")

		F.ReskinClose(result.closeButton)
		F.ReskinScroll(AchievementFrameScrollFrameScrollBar)
		for i = 1, 8 do
			local bu = _G["AchievementFrameScrollFrameButton"..i]
			F.StripTextures(bu)

			local bd = F.CreateBDFrame(bu, .25)
			bd:SetPoint("TOPLEFT", 2, -2)
			bd:SetPoint("BOTTOMRIGHT", -1, 1)

			bu.icon:SetTexCoord(.08, .92, .08, .92)
			F.CreateBDFrame(bu.icon, .25)

			bu:SetHighlightTexture(C.media.backdrop)
			local hl = bu:GetHighlightTexture()
			hl:SetVertexColor(r, g, b, .25)
			hl:SetPoint("TOPLEFT", 3, -3)
			hl:SetPoint("BOTTOMRIGHT", -2, 2)
		end
	end

	for i = 1, 20 do
		local bu = _G["AchievementFrameComparisonStatsContainerButton"..i]
		F.StripTextures(bu, true)
	end
	F.ReskinScroll(AchievementFrameComparisonStatsContainerScrollBar)

	-- Font width fix
	hooksecurefunc("AchievementObjectives_DisplayProgressiveAchievement", function()
		local index = 1
		local mini = _G["AchievementFrameMiniAchievement"..index]
		while mini do
			if not mini.fontStyled then
				mini.points:SetWidth(22)
				mini.points:ClearAllPoints()
				mini.points:SetPoint("BOTTOMRIGHT", 2, 2)
				mini.fontStyled = true
			end

			index = index + 1
			mini = _G["AchievementFrameMiniAchievement"..index]
		end
	end)
end