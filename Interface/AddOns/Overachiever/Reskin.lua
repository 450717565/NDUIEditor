if not IsAddOnLoaded("Aurora") then return end
----------------------------------------------------
-- Reskin the Overachiever in Aurora style, siweia
----------------------------------------------------

-- main
if not IsAddOnLoaded("Blizzard_AchievementUI") then
	LoadAddOn("Blizzard_AchievementUI")
end

local Delay = CreateFrame("Frame")
Delay:RegisterEvent("PLAYER_ENTERING_WORLD")
Delay:SetScript("OnEvent", function()
	Delay:UnregisterEvent("PLAYER_ENTERING_WORLD")
	local F, C = unpack(Aurora)

	-- main tabs
	F.ReskinTab(AchievementFrameTab4)
	F.ReskinTab(AchievementFrameTab5)
	F.ReskinTab(AchievementFrameTab6)

	-- search frame
	Overachiever_SearchFrame:DisableDrawLayer("BACKGROUND")
	Overachiever_SearchFrame:DisableDrawLayer("ARTWORK")
	F.ReskinInput(Overachiever_SearchFrameNameEdit)
	F.ReskinInput(Overachiever_SearchFrameDescEdit)
	F.ReskinInput(Overachiever_SearchFrameCriteriaEdit)
	F.ReskinInput(Overachiever_SearchFrameRewardEdit)
	F.ReskinInput(Overachiever_SearchFrameAnyEdit)
	F.ReskinCheck(Overachiever_SearchFrameFullListCheckbox)
	F.ReskinScroll(Overachiever_SearchFrameContainerScrollBar)
	F.ReskinScroll(Overachiever_SuggestionsFrameContainerScrollBar)
	F.ReskinDropDown(Overachiever_SearchFrameSortDrop)
	F.ReskinDropDown(Overachiever_SearchFrameTypeDrop)
	Overachiever_SearchFrameSortDrop:SetWidth(210)
	Overachiever_SearchFrameTypeDrop:SetWidth(210)

	for i = 1, 7 do
		local bu = _G["Overachiever_SearchFrameContainerButton"..i]
		local buic = _G["Overachiever_SearchFrameContainerButton"..i.."Icon"]
		bu:DisableDrawLayer("BORDER")
		bu.background:SetTexture(C.media.backdrop)
		bu.background:SetVertexColor(0, 0, 0, .25)
		bu.description:SetTextColor(.9, .9, .9)
		bu.description.SetTextColor = F.dummy
		bu.description:SetShadowOffset(1, -1)
		bu.description.SetShadowOffset = F.dummy
		_G["Overachiever_SearchFrameContainerButton"..i.."TitleBackground"]:Hide()
		_G["Overachiever_SearchFrameContainerButton"..i.."Glow"]:Hide()
		_G["Overachiever_SearchFrameContainerButton"..i.."RewardBackground"]:SetAlpha(0)
		_G["Overachiever_SearchFrameContainerButton"..i.."PlusMinus"]:SetAlpha(0)
		_G["Overachiever_SearchFrameContainerButton"..i.."Highlight"]:SetAlpha(0)
		_G["Overachiever_SearchFrameContainerButton"..i.."IconOverlay"]:Hide()
		_G["Overachiever_SearchFrameContainerButton"..i.."GuildCornerL"]:SetAlpha(0)
		_G["Overachiever_SearchFrameContainerButton"..i.."GuildCornerR"]:SetAlpha(0)

		local bg = CreateFrame("Frame", nil, bu)
		bg:SetPoint("TOPLEFT", 2, -2)
		bg:SetPoint("BOTTOMRIGHT", -2, 2)
		bu.icon.texture:SetTexCoord(.08, .92, .08, .92)
		F.CreateBD(bg, 0)
		F.CreateSD(bg)
		F.CreateBDFrame(bu.icon.texture)

		local ch = bu.tracked
		ch:SetSize(22, 22)
		ch:ClearAllPoints()
		ch:SetPoint("TOPLEFT", buic, "BOTTOMLEFT", 1.5, 8)
		F.ReskinCheck(ch)
	end

	-- suggestion frame
	Overachiever_SuggestionsFrame:DisableDrawLayer("BACKGROUND")
	Overachiever_SuggestionsFrame:DisableDrawLayer("ARTWORK")
	F.ReskinInput(Overachiever_SuggestionsFrameZoneOverrideEdit)
	F.ReskinDropDown(Overachiever_SuggestionsFrameSortDrop)
	F.ReskinDropDown(Overachiever_SuggestionsFrameSubzoneDrop)
	F.ReskinDropDown(Overachiever_SuggestionsFrameDiffDrop)
	F.ReskinDropDown(Overachiever_SuggestionsFrameRaidSizeDrop)
	F.ReskinCheck(Overachiever_SuggestionsFrameShowHiddenCheckbox)
	Overachiever_SuggestionsFrameSortDrop:SetWidth(210)
	Overachiever_SuggestionsFrameSubzoneDrop:SetWidth(210)
	Overachiever_SuggestionsFrameDiffDrop:SetWidth(210)
	Overachiever_SuggestionsFrameRaidSizeDrop:SetWidth(210)

	for i = 1, 7 do
		local bu = _G["Overachiever_SuggestionsFrameContainerButton"..i]
		local buic = _G["Overachiever_SuggestionsFrameContainerButton"..i.."Icon"]
		bu:DisableDrawLayer("BORDER")
		bu.background:SetTexture(C.media.backdrop)
		bu.background:SetVertexColor(0, 0, 0, .25)
		bu.description:SetTextColor(.9, .9, .9)
		bu.description.SetTextColor = F.dummy
		bu.description:SetShadowOffset(1, -1)
		bu.description.SetShadowOffset = F.dummy
		_G["Overachiever_SuggestionsFrameContainerButton"..i.."TitleBackground"]:Hide()
		_G["Overachiever_SuggestionsFrameContainerButton"..i.."Glow"]:Hide()
		_G["Overachiever_SuggestionsFrameContainerButton"..i.."RewardBackground"]:SetAlpha(0)
		_G["Overachiever_SuggestionsFrameContainerButton"..i.."PlusMinus"]:SetAlpha(0)
		_G["Overachiever_SuggestionsFrameContainerButton"..i.."Highlight"]:SetAlpha(0)
		_G["Overachiever_SuggestionsFrameContainerButton"..i.."IconOverlay"]:Hide()
		_G["Overachiever_SuggestionsFrameContainerButton"..i.."GuildCornerL"]:SetAlpha(0)
		_G["Overachiever_SuggestionsFrameContainerButton"..i.."GuildCornerR"]:SetAlpha(0)

		local bg = CreateFrame("Frame", nil, bu)
		bg:SetPoint("TOPLEFT", 2, -2)
		bg:SetPoint("BOTTOMRIGHT", -2, 2)
		bu.icon.texture:SetTexCoord(.08, .92, .08, .92)
		F.CreateBD(bg, 0)
		F.CreateSD(bg)
		F.CreateBDFrame(bu.icon.texture)

		local ch = bu.tracked
		ch:SetSize(22, 22)
		ch:ClearAllPoints()
		ch:SetPoint("TOPLEFT", buic, "BOTTOMLEFT", 1.5, 8)
		F.ReskinCheck(ch)
	end

	-- watch frame
	Overachiever_WatchFrame:DisableDrawLayer("BACKGROUND")
	Overachiever_WatchFrame:DisableDrawLayer("ARTWORK")
	F.ReskinDropDown(Overachiever_WatchFrameSortDrop)
	F.ReskinDropDown(Overachiever_WatchFrameListDrop)
	F.ReskinDropDown(Overachiever_WatchFrameDefListDrop)
	F.ReskinDropDown(Overachiever_WatchFrameDestinationListDrop)
	F.ReskinCheck(Overachiever_WatchFrameCopyDestCheckbox)
	Overachiever_WatchFrameSortDrop:SetWidth(210)
	Overachiever_WatchFrameListDrop:SetWidth(210)
	Overachiever_WatchFrameDefListDrop:SetWidth(210)
	Overachiever_WatchFrameDestinationListDrop:SetWidth(210)

	for i = 1, 7 do
		local bu = _G["Overachiever_WatchFrameContainerButton"..i]
		local buic = _G["Overachiever_WatchFrameContainerButton"..i.."Icon"]
		bu:DisableDrawLayer("BORDER")
		bu.background:SetTexture(C.media.backdrop)
		bu.background:SetVertexColor(0, 0, 0, .25)
		bu.description:SetTextColor(.9, .9, .9)
		bu.description.SetTextColor = F.dummy
		bu.description:SetShadowOffset(1, -1)
		bu.description.SetShadowOffset = F.dummy
		_G["Overachiever_WatchFrameContainerButton"..i.."TitleBackground"]:Hide()
		_G["Overachiever_WatchFrameContainerButton"..i.."Glow"]:Hide()
		_G["Overachiever_WatchFrameContainerButton"..i.."RewardBackground"]:SetAlpha(0)
		_G["Overachiever_WatchFrameContainerButton"..i.."PlusMinus"]:SetAlpha(0)
		_G["Overachiever_WatchFrameContainerButton"..i.."Highlight"]:SetAlpha(0)
		_G["Overachiever_WatchFrameContainerButton"..i.."IconOverlay"]:Hide()
		_G["Overachiever_WatchFrameContainerButton"..i.."GuildCornerL"]:SetAlpha(0)
		_G["Overachiever_WatchFrameContainerButton"..i.."GuildCornerR"]:SetAlpha(0)

		local bg = CreateFrame("Frame", nil, bu)
		bg:SetPoint("TOPLEFT", 2, -2)
		bg:SetPoint("BOTTOMRIGHT", -2, 2)
		bu.icon.texture:SetTexCoord(.08, .92, .08, .92)
		F.CreateBD(bg, 0)
		F.CreateSD(bg)
		F.CreateBDFrame(bu.icon.texture)

		local ch = bu.tracked
		ch:SetSize(22, 22)
		ch:ClearAllPoints()
		ch:SetPoint("TOPLEFT", buic, "BOTTOMLEFT", 1.5, 8)
		F.ReskinCheck(ch)
	end
end)