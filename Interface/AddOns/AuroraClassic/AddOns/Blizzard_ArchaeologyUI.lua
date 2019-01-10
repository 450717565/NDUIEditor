local F, C = unpack(select(2, ...))

C.themes["Blizzard_ArchaeologyUI"] = function()
	F.ReskinPortraitFrame(ArchaeologyFrame, true)
	F.Reskin(ArchaeologyFrameArtifactPageSolveFrameSolveButton)
	F.Reskin(ArchaeologyFrameArtifactPageBackButton)

	local texets = {ArchaeologyFrameSummaryPageTitle, ArchaeologyFrameArtifactPageHistoryTitle, ArchaeologyFrameArtifactPageHistoryScrollChildText, ArchaeologyFrameHelpPageTitle, ArchaeologyFrameHelpPageDigTitle, ArchaeologyFrameHelpPageHelpScrollHelpText, ArchaeologyFrameCompletedPageTitle, ArchaeologyFrameCompletedPageTitleTop, ArchaeologyFrameCompletedPageTitleMid, ArchaeologyFrameCompletedPagePageText, ArchaeologyFrameSummaryPagePageText}
	for _, texet in next, texets do
		texet:SetTextColor(1, 1, 1)
	end
	ArchaeologyFrameCompletedPage:GetRegions():SetTextColor(1, 1, 1)

	for i = 1, ARCHAEOLOGY_MAX_RACES do
		_G["ArchaeologyFrameSummaryPageRace"..i]:GetRegions():SetTextColor(1, 1, 1)
	end

	for i = 1, ARCHAEOLOGY_MAX_COMPLETED_SHOWN do
		local bu = "ArchaeologyFrameCompletedPageArtifact"..i

		local button = _G[bu]
		F.StripTextures(button)
		
		local icon = F.ReskinIcon(_G[bu.."Icon"], true)

		local bg = F.CreateBDFrame(button, .25)
		bg:SetPoint("TOPLEFT", icon, "TOPRIGHT", 2, 0)
		bg:SetPoint("BOTTOMRIGHT", 0, -1)

		F.ReskinTexture(button, true, bg)

		local name = _G[bu.."ArtifactName"]
		name:SetTextColor(1, 1, 1)
		name:ClearAllPoints()
		name:SetPoint("TOPLEFT", icon, "TOPRIGHT", 9, 3)

		local text = _G[bu.."ArtifactSubText"]
		text:SetTextColor(1, 1, 1)
		text:ClearAllPoints()
		text:SetPoint("BOTTOMLEFT", icon, "BOTTOMRIGHT", 9, 7)
	end

	ArchaeologyFrameInfoButton:SetPoint("TOPLEFT", 3, -3)
	ArchaeologyFrameSummarytButton:SetPoint("TOPLEFT", ArchaeologyFrame, "TOPRIGHT", 1, -50)
	ArchaeologyFrameSummarytButton:SetFrameLevel(ArchaeologyFrame:GetFrameLevel() - 1)
	ArchaeologyFrameCompletedButton:SetPoint("TOPLEFT", ArchaeologyFrame, "TOPRIGHT", 1, -120)
	ArchaeologyFrameCompletedButton:SetFrameLevel(ArchaeologyFrame:GetFrameLevel() - 1)

	F.ReskinDropDown(ArchaeologyFrameRaceFilter)
	F.ReskinScroll(ArchaeologyFrameArtifactPageHistoryScrollScrollBar)
	F.ReskinArrow(ArchaeologyFrameCompletedPagePrevPageButton, "left")
	F.ReskinArrow(ArchaeologyFrameCompletedPageNextPageButton, "right")
	F.ReskinArrow(ArchaeologyFrameSummaryPagePrevPageButton, "left")
	F.ReskinArrow(ArchaeologyFrameSummaryPageNextPageButton, "right")

	F.ReskinStatusBar(ArchaeologyFrameRankBar, true, true)
	F.ReskinStatusBar(ArchaeologyFrameArtifactPageSolveFrameStatusBar, true, true)
	F.ReskinIcon(ArchaeologyFrameArtifactPageIcon, true)
end