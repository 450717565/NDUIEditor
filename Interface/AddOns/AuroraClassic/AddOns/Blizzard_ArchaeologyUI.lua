local F, C = unpack(select(2, ...))

C.themes["Blizzard_ArchaeologyUI"] = function()
	F.StripTextures(ArchaeologyFrame, true)
	F.StripTextures(ArchaeologyFrameInset, true)
	F.CreateBD(ArchaeologyFrame)
	F.CreateSD(ArchaeologyFrame)
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

		local bd = F.CreateBDFrame(button, .25)
		bd:SetPoint("TOPLEFT", -1, 1)
		bd:SetPoint("BOTTOMRIGHT", 1, -1)
		bd:SetFrameLevel(button:GetFrameLevel()-1)

		local hl = button:GetHighlightTexture()
		hl:SetAllPoints()
		hl:SetVertexColor(1, 1, 1, .5)

		local icon = _G[bu.."Icon"]
		F.ReskinIcon(icon)

		local name = _G[bu.."ArtifactName"]
		name:SetTextColor(1, 1, 1)
		name:ClearAllPoints()
		name:SetPoint("TOPLEFT", icon, "TOPRIGHT", 5, 3)

		local text = _G[bu.."ArtifactSubText"]
		text:SetTextColor(1, 1, 1)
		text:ClearAllPoints()
		text:SetPoint("BOTTOMLEFT", icon, "BOTTOMRIGHT", 5, 5)
	end

	ArchaeologyFrameInfoButton:SetPoint("TOPLEFT", 3, -3)
	ArchaeologyFrameSummarytButton:SetPoint("TOPLEFT", ArchaeologyFrame, "TOPRIGHT", 1, -50)
	ArchaeologyFrameSummarytButton:SetFrameLevel(ArchaeologyFrame:GetFrameLevel()-1)
	ArchaeologyFrameCompletedButton:SetPoint("TOPLEFT", ArchaeologyFrame, "TOPRIGHT", 1, -120)
	ArchaeologyFrameCompletedButton:SetFrameLevel(ArchaeologyFrame:GetFrameLevel()-1)

	F.ReskinDropDown(ArchaeologyFrameRaceFilter)
	F.ReskinClose(ArchaeologyFrameCloseButton)
	F.ReskinScroll(ArchaeologyFrameArtifactPageHistoryScrollScrollBar)
	F.ReskinArrow(ArchaeologyFrameCompletedPagePrevPageButton, "left")
	F.ReskinArrow(ArchaeologyFrameCompletedPageNextPageButton, "right")
	ArchaeologyFrameCompletedPagePrevPageButtonIcon:Hide()
	ArchaeologyFrameCompletedPageNextPageButtonIcon:Hide()
	F.ReskinArrow(ArchaeologyFrameSummaryPagePrevPageButton, "left")
	F.ReskinArrow(ArchaeologyFrameSummaryPageNextPageButton, "right")
	ArchaeologyFrameSummaryPagePrevPageButtonIcon:Hide()
	ArchaeologyFrameSummaryPageNextPageButtonIcon:Hide()

	F.ReskinStatusBar(ArchaeologyFrameRankBar, true, true)
	F.ReskinStatusBar(ArchaeologyFrameArtifactPageSolveFrameStatusBar, true, true)
	ArchaeologyFrameArtifactPageIcon:SetTexCoord(.08, .92, .08, .92)
	F.CreateBDFrame(ArchaeologyFrameArtifactPageIcon)
end