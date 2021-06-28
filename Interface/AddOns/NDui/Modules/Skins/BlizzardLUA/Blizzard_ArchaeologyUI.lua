local _, ns = ...
local B, C, L, DB = unpack(ns)

local function Update_RankBarPoint()
	B.UpdatePoint(ArchaeologyFrameRankBar, "TOP", ArchaeologyFrame, "TOP", 0, -30)
end

C.OnLoadThemes["Blizzard_ArchaeologyUI"] = function()
	B.ReskinFrame(ArchaeologyFrame)
	B.ReskinButton(ArchaeologyFrameArtifactPageBackButton)
	B.ReskinButton(ArchaeologyFrameArtifactPageSolveFrameSolveButton)
	B.ReskinDropDown(ArchaeologyFrameRaceFilter)
	B.ReskinIcon(ArchaeologyFrameArtifactPageIcon)
	B.ReskinStatusBar(ArchaeologyFrameArtifactPageSolveFrameStatusBar)
	B.ReskinStatusBar(ArchaeologyFrameRankBar)

	ArchaeologyFrameArtifactPageIconBG:Hide()

	ArchaeologyFrameInset:ClearAllPoints()
	ArchaeologyFrameInset:SetPoint("TOPLEFT", ArchaeologyFrame, "TOPLEFT", 0, -30)
	ArchaeologyFrameInset:SetPoint("BOTTOMRIGHT", ArchaeologyFrame, "BOTTOMRIGHT", 0, 0)

	ArchaeologyFrameSummaryPage:SetInside(ArchaeologyFrameInset)
	ArchaeologyFrameCompletedPage:SetInside(ArchaeologyFrameInset)
	ArchaeologyFrameArtifactPage:SetInside(ArchaeologyFrameInset)

	ArchaeologyFrameRaceFilter:HookScript("OnShow", Update_RankBarPoint)
	ArchaeologyFrameRaceFilter:HookScript("OnHide", Update_RankBarPoint)

	B.UpdatePoint(ArchaeologyFrameCompletedButton, "TOP", ArchaeologyFrameSummarytButton, "BOTTOM", 0, 0)
	B.UpdatePoint(ArchaeologyFrameCompletedPageArtifact1, "TOPRIGHT", ArchaeologyFrameCompletedPage, "TOP", -10, -85)
	B.UpdatePoint(ArchaeologyFrameInfoButton, "TOPLEFT", ArchaeologyFrame, "TOPLEFT", 3, -3)
	B.UpdatePoint(ArchaeologyFrameSummaryPageRace1, "TOPLEFT", ArchaeologyFrameSummaryPage, "TOPLEFT", 88, -85)
	B.UpdatePoint(ArchaeologyFrameSummarytButton, "TOPLEFT", ArchaeologyFrame, "TOPRIGHT", 2, -25)
	B.UpdatePoint(ArchaeologyFrameRankBar, "TOP", ArchaeologyFrame, "TOP", 0, -30)

	local DigsiteBar = ArcheologyDigsiteProgressBar
	DigsiteBar.FillBar:SetHeight(15)
	B.StripTextures(DigsiteBar)
	B.ReskinStatusBar(DigsiteBar.FillBar)
	B.UpdatePoint(DigsiteBar.BarTitle, "CENTER", DigsiteBar, "CENTER")

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
		name:SetWordWrap(false)
		B.ReskinText(name, 1, .8, 0)
		B.UpdatePoint(name, "TOPLEFT", bubg, "TOPLEFT", 4, 2)

		local text = _G[buttons.."ArtifactSubText"]
		text:SetWordWrap(false)
		B.ReskinText(text, 1, 1, 1)
		B.UpdatePoint(text, "BOTTOMLEFT", bubg, "BOTTOMLEFT", 4, 7)
	end
end