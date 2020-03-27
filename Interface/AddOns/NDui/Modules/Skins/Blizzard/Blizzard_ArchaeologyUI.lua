local B, C, L, DB = unpack(select(2, ...))

C.themes["Blizzard_ArchaeologyUI"] = function()
	B.ReskinFrame(ArchaeologyFrame)
	B.ReskinButton(ArchaeologyFrameArtifactPageBackButton)
	B.ReskinButton(ArchaeologyFrameArtifactPageSolveFrameSolveButton)
	B.ReskinDropDown(ArchaeologyFrameRaceFilter)
	B.ReskinIcon(ArchaeologyFrameArtifactPageIcon)
	B.ReskinStatusBar(ArchaeologyFrameArtifactPageSolveFrameStatusBar)
	B.ReskinStatusBar(ArchaeologyFrameRankBar)

	ArchaeologyFrameArtifactPageIconBG:Hide()
	ArchaeologyFrameInfoButton:ClearAllPoints()
	ArchaeologyFrameInfoButton:SetPoint("TOPLEFT", 3, -3)

	ArchaeologyFrameSummarytButton:ClearAllPoints()
	ArchaeologyFrameSummarytButton:SetPoint("TOPLEFT", ArchaeologyFrame, "TOPRIGHT", 2, -25)
	ArchaeologyFrameCompletedButton:ClearAllPoints()
	ArchaeologyFrameCompletedButton:SetPoint("TOP", ArchaeologyFrameSummarytButton, "BOTTOM", 0, 0)

	local DigsiteBar = ArcheologyDigsiteProgressBar
	B.StripTextures(DigsiteBar)
	B.ReskinStatusBar(DigsiteBar.FillBar)
	DigsiteBar.FillBar:SetHeight(15)
	DigsiteBar.BarTitle:ClearAllPoints()
	DigsiteBar.BarTitle:SetPoint("CENTER")

	local titles = {ArchaeologyFrameSummaryPageTitle, ArchaeologyFrameCompletedPageTitleTop, ArchaeologyFrameCompletedPageTitleMid, ArchaeologyFrameArtifactPageHistoryTitle, ArchaeologyFrameHelpPageTitle, ArchaeologyFrameHelpPageDigTitle, ArchaeologyFrameCompletedPage.titleBig}
	for _, title in pairs(titles) do
		title:SetTextColor(1, .8, 0)
	end

	local texets = {ArchaeologyFrameCompletedPagePageText, ArchaeologyFrameSummaryPagePageText, ArchaeologyFrameArtifactPageHistoryScrollChildText, ArchaeologyFrameHelpPageHelpScrollHelpText, ArchaeologyFrameCompletedPage.infoText}
	for _, texet in pairs(texets) do
		texet:SetTextColor(1, 1, 1)
	end

	-- SummaryPage
	B.ReskinArrow(ArchaeologyFrameSummaryPagePrevPageButton, "left")
	B.ReskinArrow(ArchaeologyFrameSummaryPageNextPageButton, "right")

	for i = 1, ARCHAEOLOGY_MAX_RACES do
		local bu = _G["ArchaeologyFrameSummaryPageRace"..i]
		bu.raceName:SetTextColor(1, 1, 1)
	end

	-- CompletedPage
	B.ReskinArrow(ArchaeologyFrameCompletedPagePrevPageButton, "left")
	B.ReskinArrow(ArchaeologyFrameCompletedPageNextPageButton, "right")

	for i = 1, ARCHAEOLOGY_MAX_COMPLETED_SHOWN do
		local button = "ArchaeologyFrameCompletedPageArtifact"..i

		local bu = _G[button]
		B.StripTextures(bu)

		local icbg = B.ReskinIcon(_G[button.."Icon"])
		local bubg = B.CreateBDFrame(bu, 0)
		bubg:SetPoint("TOPLEFT", icbg, "TOPRIGHT", 2, 0)
		bubg:SetPoint("BOTTOMRIGHT", 0, -1)
		B.ReskinHighlight(bu, bubg, true)

		local name = _G[button.."ArtifactName"]
		name:SetWordWrap(false)
		name:SetTextColor(1, .8, 0)
		name:ClearAllPoints()
		name:SetPoint("TOPLEFT", bubg, "TOPLEFT", 4, 2)

		local text = _G[button.."ArtifactSubText"]
		text:SetWordWrap(false)
		text:SetTextColor(1, 1, 1)
		text:ClearAllPoints()
		text:SetPoint("BOTTOMLEFT", bubg, "BOTTOMLEFT", 4, 7)
	end
end