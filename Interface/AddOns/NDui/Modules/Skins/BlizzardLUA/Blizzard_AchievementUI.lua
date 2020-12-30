local _, ns = ...
local B, C, L, DB = unpack(ns)
local Skins = B:GetModule("Skins")

local cr, cg, cb = DB.r, DB.g, DB.b

local function Reskin_DisplayAchievement(button, category, index)
	local completed = select(4, GetAchievementInfo(category, index))
	local bu = button.player or button

	if completed then
		if bu.accountWide then
			B.ReskinText(bu.label, 0, .8, 1)
		else
			B.ReskinText(bu.label, 1, .8, 0)
		end

		if bu.reward then B.ReskinText(bu.reward, 0, 1, 0) end
		if bu.description then B.ReskinText(bu.description, 1, 1, 1) end
		if bu.hiddenDescription then B.ReskinText(bu.hiddenDescription, 1, 1, 1) end
	else
		if bu.accountWide then
			B.ReskinText(bu.label, 0, .8, 1, .5)
		else
			B.ReskinText(bu.label, 1, .8, 0, .5)
		end

		if bu.reward then B.ReskinText(bu.reward, 0, 1, 0, .5) end
		if bu.description then B.ReskinText(bu.description, 1, 1, 1, .5) end
		if bu.hiddenDescription then B.ReskinText(bu.hiddenDescription, 1, 1, 1, .5) end
	end
end

local function Reskin_DisplayButton(button)
	if not button.styled then
		B.StripTextures(button)

		local bubg = B.CreateBDFrame(button, 0, 1)
		B.ReskinHighlight(button, bubg, true)

		button.styled = true
	end
end

local function Reskin_GetProgressBar(index)
	local bar = _G["AchievementFrameProgressBar"..index]
	if not bar.styled then
		B.ReskinStatusBar(bar)

		bar.styled = true
	end
end

local function Reskin_UpdateAchievements()
	for i = 1, 4 do
		local button = "AchievementFrameSummaryAchievement"..i

		local bu = _G[button]
		B.ReskinText(bu.description, 1, 1, 1)

		if bu.accountWide then
			B.ReskinText(bu.label, 0, .8, 1)
		else
			B.ReskinText(bu.label, 1, .8, 0)
		end

		if not bu.styled then
			B.StripTextures(bu, 0)
			B.CreateBDFrame(bu, 0, 2)

			local hl = _G[button.."Highlight"]
			hl:SetOutside(nil, 1, 1)

			local io = _G[button.."IconOverlay"]
			io:Hide()

			local ic = _G[button.."IconTexture"]
			B.ReskinIcon(ic)

			bu.styled = true
		end
	end
end

local function Reskin_DisplayCriteria(_, id)
	for i = 1, GetAchievementNumCriteria(id) do
		local name = _G["AchievementFrameCriteria"..i.."Name"]
		if name and select(2, name:GetTextColor()) == 0 then
			B.ReskinText(name, 1, 1, 1)
		end

		local meta = _G["AchievementFrameMeta"..i]
		if meta and select(2, meta.label:GetTextColor()) == 0 then
			B.ReskinText(meta.label, 1, 1, 1)
		end
	end
end

local function Fixed_DisplayProgressiveAchievement()
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
end

C.LUAThemes["Blizzard_AchievementUI"] = function()
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
	B.ReskinText(barTitle, 1, 1, 1)
	barTitle:ClearAllPoints()
	barTitle:SetPoint("LEFT", statusBar, "LEFT", 6, 0)
	local barText = AchievementFrameSummaryCategoriesStatusBarText
	barText:ClearAllPoints()
	barText:SetPoint("RIGHT", statusBar, "RIGHT", -5, 0)

	local searchBox = AchievementFrame.searchBox
	searchBox:ClearAllPoints()
	searchBox:SetPoint("RIGHT", AchievementFrameCloseButton, "LEFT", -5, 0)
	B.ReskinInput(searchBox, 18, 100)

	local searchPreviewContainer = AchievementFrame.searchPreviewContainer
	searchPreviewContainer:ClearAllPoints()
	searchPreviewContainer:SetPoint("TOPLEFT", AchievementFrame, "TOPRIGHT", 10, -C.mult)
	B.StripTextures(searchPreviewContainer)
	local bg = B.CreateBG(searchPreviewContainer)
	bg:SetOutside(searchPreviewContainer.searchPreview1, 1, 1, searchPreviewContainer.showAllSearchResults)

	for i = 1, 5 do
		Skins.ReskinSearchBox(searchPreviewContainer["searchPreview"..i])
	end
	Skins.ReskinSearchBox(searchPreviewContainer.showAllSearchResults)
	Skins.ReskinSearchResult(AchievementFrame)

	local dropDown = AchievementFrameFilterDropDown
	B.ReskinDropDown(dropDown)
	dropDown:ClearAllPoints()
	dropDown:SetPoint("RIGHT", searchBox, "LEFT", 0, 0)

	for i = 1, 12 do
		local bars = "AchievementFrameSummaryCategoriesCategory"..i

		local bar = _G[bars]
		B.ReskinStatusBar(bar)

		B.ReskinText(bar.label, 1, 1, 1)
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
		B.CreateBDFrame(bu, 0, 1)

		local hl = _G[button.."Highlight"]
		hl:SetOutside(nil, 2, 2)

		local io = _G[button.."IconOverlay"]
		io:Hide()

		local ic = _G[button.."IconTexture"]
		local icbg = B.ReskinIcon(ic)

		local ch = _G[button.."Tracked"]
		ch:SetSize(22, 22)
		ch:ClearAllPoints()
		ch:SetPoint("TOPLEFT", icbg, "BOTTOMLEFT", -3.5, 0)
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
		B.ReskinFrameTab(AchievementFrame, 3)
	end)

	hooksecurefunc("AchievementButton_GetProgressBar", Reskin_GetProgressBar)
	hooksecurefunc("AchievementFrameSummary_UpdateAchievements", Reskin_UpdateAchievements)
	hooksecurefunc("AchievementObjectives_DisplayCriteria", Reskin_DisplayCriteria)
	hooksecurefunc("AchievementFrameCategories_DisplayButton", Reskin_DisplayButton)
	hooksecurefunc("AchievementButton_DisplayAchievement", Reskin_DisplayAchievement)

	-- Comparison
	local summaries = {AchievementFrameComparisonSummaryPlayer, AchievementFrameComparisonSummaryFriend}
	for _, summary in pairs(summaries) do
		B.StripTextures(summary)
		B.CreateBDFrame(summary, 0, 1)
	end

	local bars = {AchievementFrameComparisonSummaryPlayerStatusBar, AchievementFrameComparisonSummaryFriendStatusBar}
	for _, bar in pairs(bars) do
		B.ReskinStatusBar(bar)

		local name = bar:GetDebugName()

		local title = _G[name.."Title"]
		B.ReskinText(title, 1, 1, 1)
		title:ClearAllPoints()
		title:SetPoint("LEFT", bar, "LEFT", 6, 0)

		local text = _G[name.."Text"]
		text:ClearAllPoints()
		text:SetPoint("RIGHT", bar, "RIGHT", -5, 0)
	end

	for i = 1, 9 do
		local button = "AchievementFrameComparisonContainerButton"..i

		for _, name in pairs({"Player", "Friend"}) do
			B.StripTextures(_G[button..name], 0)
			B.CreateBDFrame(_G[button..name], 0, 1)
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

	hooksecurefunc("AchievementFrameComparison_DisplayAchievement", Reskin_DisplayAchievement)

	-- Font width fix
	hooksecurefunc("AchievementObjectives_DisplayProgressiveAchievement", Fixed_DisplayProgressiveAchievement)
end