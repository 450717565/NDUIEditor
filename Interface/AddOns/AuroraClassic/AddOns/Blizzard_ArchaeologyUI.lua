local F, C = unpack(select(2, ...))

C.themes["Blizzard_ArchaeologyUI"] = function()
	F.ReskinFrame(ArchaeologyFrame)
	F.ReskinButton(ArchaeologyFrameArtifactPageBackButton)
	F.ReskinButton(ArchaeologyFrameArtifactPageSolveFrameSolveButton)
	F.ReskinDropDown(ArchaeologyFrameRaceFilter)
	F.ReskinIcon(ArchaeologyFrameArtifactPageIcon)
	F.ReskinStatusBar(ArchaeologyFrameArtifactPageSolveFrameStatusBar)
	F.ReskinStatusBar(ArchaeologyFrameRankBar)

	ArchaeologyFrameArtifactPageIconBG:Hide()
	ArchaeologyFrameInfoButton:ClearAllPoints()
	ArchaeologyFrameInfoButton:SetPoint("TOPLEFT", 3, -3)

	ArchaeologyFrameSummarytButton:ClearAllPoints()
	ArchaeologyFrameSummarytButton:SetPoint("TOPLEFT", ArchaeologyFrame, "TOPRIGHT", 0, -25)
	ArchaeologyFrameCompletedButton:ClearAllPoints()
	ArchaeologyFrameCompletedButton:SetPoint("TOP", ArchaeologyFrameSummarytButton, "BOTTOM", 0, 0)

	local titles = {ArchaeologyFrameSummaryPageTitle, ArchaeologyFrameCompletedPageTitleTop, ArchaeologyFrameCompletedPageTitleMid, ArchaeologyFrameArtifactPageHistoryTitle, ArchaeologyFrameHelpPageTitle, ArchaeologyFrameHelpPageDigTitle}
	for _, title in next, titles do
		title:SetTextColor(1, .8, 0)
	end

	local texets = {ArchaeologyFrameCompletedPagePageText, ArchaeologyFrameSummaryPagePageText, ArchaeologyFrameArtifactPageHistoryScrollChildText, ArchaeologyFrameHelpPageHelpScrollHelpText}
	for _, texet in next, texets do
		texet:SetTextColor(1, 1, 1)
	end

	-- SummaryPage
	F.ReskinArrow(ArchaeologyFrameSummaryPagePrevPageButton, "left")
	F.ReskinArrow(ArchaeologyFrameSummaryPageNextPageButton, "right")

	for i = 1, ARCHAEOLOGY_MAX_RACES do
		local bu = _G["ArchaeologyFrameSummaryPageRace"..i]
		bu.raceName:SetTextColor(1, 1, 1)
	end

	-- CompletedPage
	F.ReskinArrow(ArchaeologyFrameCompletedPagePrevPageButton, "left")
	F.ReskinArrow(ArchaeologyFrameCompletedPageNextPageButton, "right")

	for i = 1, ARCHAEOLOGY_MAX_COMPLETED_SHOWN do
		local button = "ArchaeologyFrameCompletedPageArtifact"..i

		local bu = _G[button]
		F.StripTextures(bu)

		local icbg = F.ReskinIcon(_G[button.."Icon"])

		local bubg = F.CreateBDFrame(bu, 0)
		bubg:SetPoint("TOPLEFT", icbg, "TOPRIGHT", 2, 0)
		bubg:SetPoint("BOTTOMRIGHT", 0, -1)
		F.ReskinTexture(bu, bubg, true)

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