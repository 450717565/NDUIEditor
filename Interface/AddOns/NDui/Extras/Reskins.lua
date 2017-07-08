-- Aurora Reskin
if IsAddOnLoaded("Aurora") then
	local F, C = unpack(Aurora)
	local Delay = CreateFrame("Frame")
	Delay:RegisterEvent("PLAYER_ENTERING_WORLD")
	Delay:SetScript("OnEvent", function()
		Delay:UnregisterEvent("PLAYER_ENTERING_WORLD")

		-- 区域技能按钮
		local zb = ZoneAbilityFrame.SpellButton
		zb.Style:Hide()
		F.ReskinIconStyle(zb)

		if IsAddOnLoaded("!BaudErrorFrame") then
			F.CreateBD(BaudErrorFrame)
			F.CreateSD(BaudErrorFrame)
			F.CreateSD(BaudErrorFrameListScrollBox)
			F.CreateSD(BaudErrorFrameDetailScrollBox)
			F.Reskin(BaudErrorFrameClearButton)
			F.Reskin(BaudErrorFrameCloseButton)
			F.Reskin(BaudErrorFrameReloadUIButton)
			F.ReskinScroll(BaudErrorFrameListScrollBoxScrollBarScrollBar)
			F.ReskinScroll(BaudErrorFrameDetailScrollFrameScrollBar)
		end

		if IsAddOnLoaded("APIInterface") then
			APIIListsInsetLeft.Bg:Hide()

			F.CreateBD(APII_Core)
			F.CreateSD(APII_Core)
			F.ReskinClose(APII_Core.CloseButton)
			F.ReskinInput(APIILists.searchBox)
			F.ReskinScroll(APIIListsSystemListScrollBar)

			local list = {"TitleBackground", "InsetTopBorder", "InsetBottomBorder", "InsetLeftBorder", "InsetRightBorder", "InsetTopLeftCorner", "InsetTopRightCorner", "InsetBotLeftCorner", "InsetBotRightCorner"}
			for i = 1, #list do
				_G["APIIListsInsetLeft"..list[i]]:Hide()
			end

			for i = 1, 16 do
				select(i, APII_Core:GetRegions()):Hide()
			end
		end

		if IsAddOnLoaded("Overachiever") then
			if not IsAddOnLoaded("Blizzard_AchievementUI") then
				LoadAddOn("Blizzard_AchievementUI")
			end
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
		end

		if IsAddOnLoaded("QuestNotifier") then
			F.ReskinCheck(QNOchk_Switch)
			F.ReskinCheck(QNOchk_Instance)
			F.ReskinCheck(QNOchk_Raid)
			F.ReskinCheck(QNOchk_Party)
			F.ReskinCheck(QNOchk_Solo)
			F.ReskinCheck(QNOchk_Sound)
			F.ReskinCheck(QNOchk_Debug)
			F.ReskinCheck(QNOchk_NoDetail)
			F.ReskinCheck(QNOchk_CompleteX)
		end

		if IsAddOnLoaded("WhisperPop") then
			F.CreateBD(WhisperPopFrame)
			F.CreateSD(WhisperPopFrame)
			F.CreateBD(WhisperPopMessageFrame)
			F.CreateSD(WhisperPopMessageFrame)

			F.ReskinCheck(WhisperPopMessageFrameProtectCheck)
			F.ReskinClose(WhisperPopFrameListDelete)
			F.ReskinClose(WhisperPopFrameTopCloseButton)
			F.ReskinClose(WhisperPopMessageFrameTopCloseButton)
			F.ReskinArrow(WhisperPopScrollingMessageFrameButtonUp, "up")
			F.ReskinArrow(WhisperPopScrollingMessageFrameButtonDown, "down")
			F.ReskinArrow(WhisperPopScrollingMessageFrameButtonEnd, "down")
			F.ReskinScroll(WhisperPopFrameListScrollBar)

			local wpbtn = {"WhisperPopNotifyButton", "WhisperPopFrameConfig"}
			for i = 1, #wpbtn do
				F.ReskinIconStyle(_G[wpbtn[i]])
			end
		end

		if IsAddOnLoaded("LibUIDropDownMenu") then
			for i = 1, L_UIDROPDOWNMENU_MAXLEVELS do
				F.CreateBD(_G["L_DropDownList"..i.."MenuBackdrop"])
				F.CreateSD(_G["L_DropDownList"..i.."MenuBackdrop"])
			end
		end

		if IsAddOnLoaded("BuyEmAll") then
			F.CreateBD(BuyEmAllFrame)
			F.CreateSD(BuyEmAllFrame)
			F.Reskin(BuyEmAllOkayButton)
			F.Reskin(BuyEmAllCancelButton)
			F.Reskin(BuyEmAllStackButton)
			F.Reskin(BuyEmAllMaxButton)
			F.ReskinArrow(BuyEmAllLeftButton, "left")
			F.ReskinArrow(BuyEmAllRightButton, "right")
			for i = 1, 3 do
				select(i, BuyEmAllFrame:GetRegions()):Hide()
			end
		end

		if IsAddOnLoaded("BaudAuction") then
			F.ReskinScroll(BaudAuctionBrowseScrollBoxScrollBarScrollBar)
			F.CreateBD(BaudAuctionProgress)
			F.CreateSD(BaudAuctionProgress)
			--F.ReskinClose(BaudAuctionCancelButton)

			BaudAuctionProgressBar:SetPoint("CENTER", 12, -5)
			BaudAuctionProgressBarIcon:SetTexCoord(.08, .92, .08, .92)
			BaudAuctionProgressBarIcon:SetPoint("RIGHT", BaudAuctionProgressBar, "LEFT", -2, 0)
			BaudAuctionProgressBarBorder:Hide()
			F.ReskinStatusBar(BaudAuctionProgressBar)
			F.CreateBDFrame(BaudAuctionProgressBarIcon)

			for i = 1, 2 do
				select(i, BaudAuctionBrowseScrollBoxScrollBar:GetRegions()):Hide()
			end

			for k = 1, 19 do
				F.ReskinIcon(_G["BaudAuctionBrowseScrollBoxEntry"..k.."Texture"])
			end
		end

		if IsAddOnLoaded("HandyNotes_WorldMapButton") then
			F.SetBD(HandyNotesWorldMapButton)
		end
	end)
end