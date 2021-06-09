local _, ns = ...
local B, C, L, DB = unpack(ns)

C.LUAThemes["Blizzard_ArchaeologyUI"] = function()
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

	local titles = {
		ArchaeologyFrameArtifactPageHistoryTitle,
		ArchaeologyFrameCompletedPage.titleBig,
		ArchaeologyFrameCompletedPageTitleMid,
		ArchaeologyFrameCompletedPageTitleTop,
		ArchaeologyFrameHelpPageDigTitle,
		ArchaeologyFrameHelpPageTitle,
		ArchaeologyFrameSummaryPageTitle,
	}
	for _, title in pairs(titles) do
		B.ReskinText(title, 1, .8, 0)
	end

	local texts = {
		ArchaeologyFrameArtifactPageHistoryScrollChildText,
		ArchaeologyFrameCompletedPage.infoText,
		ArchaeologyFrameCompletedPagePageText,
		ArchaeologyFrameHelpPageHelpScrollHelpText,
		ArchaeologyFrameSummaryPagePageText,
	}
	for _, text in pairs(texts) do
		B.ReskinText(text, 1, 1, 1)
	end

	-- SummaryPage
	B.ReskinArrow(ArchaeologyFrameSummaryPagePrevPageButton, "left")
	B.ReskinArrow(ArchaeologyFrameSummaryPageNextPageButton, "right")

	for i = 1, ARCHAEOLOGY_MAX_RACES do
		local button = _G["ArchaeologyFrameSummaryPageRace"..i]
		B.ReskinText(button.raceName, 1, 1, 1)
	end

	-- CompletedPage
	B.ReskinArrow(ArchaeologyFrameCompletedPagePrevPageButton, "left")
	B.ReskinArrow(ArchaeologyFrameCompletedPageNextPageButton, "right")

	for i = 1, ARCHAEOLOGY_MAX_COMPLETED_SHOWN do
		local buttons = "ArchaeologyFrameCompletedPageArtifact"..i

		local button = _G[buttons]
		B.StripTextures(button)

		local icbg = B.ReskinIcon(_G[buttons.."Icon"])
		local bubg = B.CreateBGFrame(button, 2, 0, 0, 0, icbg)
		B.ReskinHLTex(button, bubg, true)

		local name = _G[buttons.."ArtifactName"]
		B.ReskinText(name, 1, .8, 0)
		name:SetWordWrap(false)
		name:ClearAllPoints()
		name:SetPoint("TOPLEFT", bubg, "TOPLEFT", 4, 2)

		local text = _G[buttons.."ArtifactSubText"]
		B.ReskinText(text, 1, 1, 1)
		text:SetWordWrap(false)
		text:ClearAllPoints()
		text:SetPoint("BOTTOMLEFT", bubg, "BOTTOMLEFT", 4, 7)
	end
end