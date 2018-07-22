-- Aurora Reskin
if IsAddOnLoaded("AuroraClassic") then
	local F, C = unpack(AuroraClassic)
	local Delay = CreateFrame("Frame")
	Delay:RegisterEvent("PLAYER_ENTERING_WORLD")
	Delay:SetScript("OnEvent", function()
		Delay:UnregisterEvent("PLAYER_ENTERING_WORLD")
		local r, g, b = C.r, C.g, C.b

		-- 区域技能按钮
		local zb = ZoneAbilityFrame.SpellButton
		zb.Style:Hide()
		F.ReskinIconStyle(zb)

		-- 特殊任务按钮
		ExtraQuestButtonArtwork:Hide()

		-- 顶部信息板
		UIWidgetTopCenterContainerFrame:ClearAllPoints()
		UIWidgetTopCenterContainerFrame:SetPoint("TOP", 0, -30)

		if IsAddOnLoaded("!BaudErrorFrame") then
			F.CreateBD(BaudErrorFrame)
			F.CreateSD(BaudErrorFrame)
			F.CreateSD(BaudErrorFrameListScrollBox)
			F.CreateSD(BaudErrorFrameDetailScrollBox)
			F.ReskinScroll(BaudErrorFrameListScrollBoxScrollBarScrollBar)
			F.ReskinScroll(BaudErrorFrameDetailScrollFrameScrollBar)

			local boxHL = BaudErrorFrameListScrollBoxHighlightTexture
			boxHL:SetTexture(C.media.backdrop)
			boxHL:SetVertexColor(r, g, b, .5)

			local Buttonlist = {"ClearButton", "CloseButton", "ReloadUIButton"}
			for k, v in pairs(Buttonlist) do
				F.Reskin(_G["BaudErrorFrame"..v])
			end
		end

		if IsAddOnLoaded("!Libs") then
			-- LibUIDropDownMenu
			local function SkinDDM(info, level)
				for i = 1, L_UIDROPDOWNMENU_MAXLEVELS do
					F.CreateBD(_G["L_DropDownList"..i.."MenuBackdrop"])
					F.CreateSD(_G["L_DropDownList"..i.."MenuBackdrop"])
					for j = 1, L_UIDROPDOWNMENU_MAXBUTTONS do
						local arrow = _G["L_DropDownList"..i.."Button"..j.."ExpandArrow"]
						arrow:SetNormalTexture(C.media.arrowRight)
						arrow:SetSize(10, 10)

						local hl = _G["L_DropDownList"..i.."Button"..j.."Highlight"]
						hl:SetColorTexture(r, g, b, .25)

						local check = _G["L_DropDownList"..i.."Button"..j.."Check"]
						check:SetDesaturated(true)
						check:SetSize(20, 20)
						check:SetTexCoord(0, 1, 0, 1)
						check:SetTexture("Interface\\Buttons\\UI-CheckBox-Check")
						check:SetVertexColor(r, g, b, 1)

						local uncheck = _G["L_DropDownList"..i.."Button"..j.."UnCheck"]
						uncheck:SetTexture("")
					end
				end
			end
			hooksecurefunc("L_UIDropDownMenu_AddButton", SkinDDM)
		end

		if IsAddOnLoaded("APIInterface") then
			APIIListsInsetLeft.Bg:Hide()
			F.CreateBD(APII_Core)
			F.CreateSD(APII_Core)
			F.ReskinClose(APII_Core.CloseButton)
			F.ReskinInput(APIILists.searchBox)
			F.ReskinScroll(APIIListsSystemListScrollBar)

			local list = {"TitleBackground", "InsetTopBorder", "InsetBottomBorder", "InsetLeftBorder", "InsetRightBorder", "InsetTopLeftCorner", "InsetTopRightCorner", "InsetBotLeftCorner", "InsetBotRightCorner"}
			for k, v in pairs(list) do
				_G["APIIListsInsetLeft"..v]:Hide()
			end
			for i = 1, 16 do
				select(i, APII_Core:GetRegions()):Hide()
			end
		end

		if IsAddOnLoaded("AuctionLite") then
			F.ReskinArrow(BuyAdvancedButton, "down")
			F.ReskinArrow(SellRememberButton, "down")
			F.ReskinArrow(BuySummaryButton, "left")
			SellRememberButtonDisabledTexture:Hide()
			SellRememberButtonHighlightTexture:Hide()
			SellSize:SetWidth(40)
			SellSize:ClearAllPoints()
			SellSize:SetPoint("LEFT", SellStacks, "RIGHT", 66, 0)
			SellBidPriceSilver:SetPoint("LEFT", SellBidPriceGold, "RIGHT", 1, 0)
			SellBidPriceCopper:SetPoint("LEFT", SellBidPriceSilver, "RIGHT", 1, 0)
			SellBuyoutPriceSilver:SetPoint("LEFT", SellBuyoutPriceGold, "RIGHT", 1, 0)
			SellBuyoutPriceCopper:SetPoint("LEFT", SellBuyoutPriceSilver, "RIGHT", 1, 0)
			BuyBuyoutButton:ClearAllPoints()
			BuyBuyoutButton:SetPoint("RIGHT", BuyCancelAuctionButton, "LEFT", -1, 0)
			BuyBidButton:ClearAllPoints()
			BuyBidButton:SetPoint("RIGHT", BuyBuyoutButton, "LEFT", -1, 0)

			local sellitemhandler = CreateFrame("Frame")
			sellitemhandler:RegisterEvent("NEW_AUCTION_UPDATE")
			sellitemhandler:SetScript("OnEvent", function()
			local SellItemButtonIconTexture = SellItemButton:GetNormalTexture()
				if SellItemButtonIconTexture then
					SellItemButtonIconTexture:SetTexCoord(.08, .92, .08, .92)
					SellItemButtonIconTexture:SetPoint("TOPLEFT", 1, -1)
					SellItemButtonIconTexture:SetPoint("BOTTOMRIGHT", -1, 1)
				end
			end)

			F.CreateBD(SellItemButton, .25)
			F.CreateSD(SellItemButton)

			local Inputlist = {"BuyName", "BuyQuantity", "SellStacks", "SellSize", "SellBidPriceGold", "SellBidPriceSilver", "SellBidPriceCopper", "SellBuyoutPriceGold", "SellBuyoutPriceSilver", "SellBuyoutPriceCopper"}
			for k, v in pairs(Inputlist) do
				F.ReskinInput(_G[v])
			end
			local Buttonlist = {"BuySearchButton", "BuyScanButton", "BuyBidButton", "BuyBuyoutButton", "BuyCancelAuctionButton", "BuyCancelSearchButton", "SellCreateAuctionButton", "SellStacksMaxButton", "SellSizeMaxButton"}
			for k, v in pairs(Buttonlist) do
				F.Reskin(_G[v])
			end
			local Radiolist = {"SellShortAuctionButton", "SellMediumAuctionButton", "SellLongAuctionButton", "SellPerItemButton", "SellPerStackButton"}
			for k, v in pairs(Radiolist) do
				F.ReskinRadio(_G[v])
			end
			local Scrolllist = {"BuyScrollFrame", "SellScrollFrame"}
			for k, v in pairs(Scrolllist) do
				F.ReskinScroll(_G[v.."ScrollBar"])
				for i = 1, 2 do
					select(i, _G[v]:GetRegions()):Hide()
				end
			end
		end

		if IsAddOnLoaded("BaudAuction") then
			F.CreateBD(BaudAuctionProgress)
			F.CreateSD(BaudAuctionProgress)
			BaudAuctionProgressBar:SetPoint("CENTER", 0, -5)
			BaudAuctionProgressBarBorder:Hide()
			F.ReskinScroll(BaudAuctionBrowseScrollBoxScrollBarScrollBar)
			F.ReskinStatusBar(BaudAuctionProgressBar, true)

			local boxHL = BaudAuctionBrowseScrollBoxHighlight
			boxHL:SetTexture(C.media.backdrop)
			boxHL:SetPoint("LEFT", 4, 0)
			boxHL:SetPoint("RIGHT", 10, 0)

			for i = 1, 2 do
				select(i, BaudAuctionBrowseScrollBoxScrollBar:GetRegions()):Hide()
			end
			for k = 1, 19 do
				F.ReskinIcon(_G["BaudAuctionBrowseScrollBoxEntry"..k.."Texture"])
			end
		end

		if IsAddOnLoaded("BuyEmAll") then
			F.CreateBD(BuyEmAllFrame)
			F.CreateSD(BuyEmAllFrame)
			F.ReskinArrow(BuyEmAllLeftButton, "left")
			F.ReskinArrow(BuyEmAllRightButton, "right")

			local list = {"OkayButton", "CancelButton", "StackButton", "MaxButton"}
			for k, v in pairs(list) do
				F.Reskin(_G["BuyEmAll"..v])
			end

			for i = 1, 3 do
				select(i, BuyEmAllFrame:GetRegions()):Hide()
			end
		end

		if IsAddOnLoaded("Immersion") then
			local talkbox = ImmersionFrame.TalkBox.MainFrame
			F.ReskinClose(talkbox.CloseButton, "TOPRIGHT", talkbox, "TOPRIGHT", -20, -20)
		end

		if IsAddOnLoaded("ls_Toasts") then
			local LST = unpack(ls_Toasts)
			LST:RegisterSkin("ndui", {
				name = "NDui",
				border = {
					--color = {0, 0, 0},
					offset = 0,
					size = 1,
					texture = {1, 1, 1, 1},
				},
				title = {
					flags = "OUTLINE",
					shadow = false,
				},
				text = {
					flags = "OUTLINE",
					shadow = false,
				},
				bonus = {
					hidden = false,
				},
				dragon = {
					hidden = false,
				},
				icon = {
					tex_coords = {.08, .92, .08, .92},
				},
				icon_border = {
					--color = {0, 0, 0},
					offset = 0,
					size = 1,
					texture = {1, 1, 1, 1},
				},
				icon_highlight = {
					hidden = true,
				},
				icon_text_1 = {
					flags = "OUTLINE",
					shadow = false,
				},
				icon_text_2 = {
					flags = "OUTLINE",
					shadow = false,
				},
				skull = {
					hidden = false,
				},
				slot = {
					tex_coords = {.08, .92, .08, .92},
				},
				slot_border = {
					--color = {0, 0, 0},
					offset = 0,
					size = 1,
					texture = {1, 1, 1, 1},
				},
			})
			LST:SetSkin("ndui")
		end

		if IsAddOnLoaded("Overachiever") then
			if not IsAddOnLoaded("Blizzard_AchievementUI") then
				LoadAddOn("Blizzard_AchievementUI")
			end

			for i = 4, 6 do
				F.ReskinTab(_G["AchievementFrameTab"..i])
			end

			local Framelist = {"SearchFrame", "SuggestionsFrame", "WatchFrame"}
			for k, v in pairs(Framelist) do
				_G["Overachiever_"..v]:DisableDrawLayer("ARTWORK")
				_G["Overachiever_"..v]:DisableDrawLayer("BACKGROUND")
			end

			local Checklist = {"SearchFrameFullListCheckbox", "SuggestionsFrameShowHiddenCheckbox", "WatchFrameCopyDestCheckbox"}
			for k, v in pairs(Checklist) do
				F.ReskinCheck(_G["Overachiever_"..v])
			end

			local Droplist = {"SearchFrameSortDrop", "SearchFrameTypeDrop", "SuggestionsFrameSortDrop", "SuggestionsFrameSubzoneDrop", "SuggestionsFrameDiffDrop", "SuggestionsFrameRaidSizeDrop", "WatchFrameSortDrop", "WatchFrameListDrop", "WatchFrameDefListDrop", "WatchFrameDestinationListDrop"}
			for k, v in pairs(Droplist) do
				_G["Overachiever_"..v]:SetWidth(210)
				F.ReskinDropDown(_G["Overachiever_"..v])
			end

			local Inputlist = {"SearchFrameNameEdit", "SearchFrameDescEdit", "SearchFrameCriteriaEdit", "SearchFrameRewardEdit", "SearchFrameAnyEdit", "SuggestionsFrameZoneOverrideEdit"}
			for k, v in pairs(Inputlist) do
				F.ReskinInput(_G["Overachiever_"..v])
			end

			local Scrolllist = {"SearchFrameContainerScrollBar", "SuggestionsFrameContainerScrollBar", "WatchFrameContainerScrollBar"}
			for k, v in pairs(Scrolllist) do
				F.ReskinScroll(_G["Overachiever_"..v])
			end

			local Buttonlist = {"SearchFrameContainerButton", "SuggestionsFrameContainerButton", "WatchFrameContainerButton"}
			for k, v in pairs(Buttonlist) do
				for i = 1, 7 do
					local bu = _G["Overachiever_"..v..i]
					local buic = _G["Overachiever_"..v..i.."Icon"]
					bu:DisableDrawLayer("BORDER")
					bu.background:SetTexture(C.media.backdrop)
					bu.background:SetVertexColor(0, 0, 0, .25)
					bu.description:SetTextColor(.9, .9, .9)
					bu.description.SetTextColor = F.dummy
					bu.description:SetShadowOffset(1, -1)
					bu.description.SetShadowOffset = F.dummy

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

					local Hidelist = {"TitleBackground", "Glow", "IconOverlay"}
					for l, w in pairs(Hidelist) do
						_G["Overachiever_"..v..i..w]:Hide()
					end

					local Alphalist = {"RewardBackground", "PlusMinus", "Highlight", "GuildCornerL", "GuildCornerR"}
					for l, w in pairs(Alphalist) do
						_G["Overachiever_"..v..i..w]:SetAlpha(0)
					end
				end
			end
		end

		if IsAddOnLoaded("Simulationcraft") then
			F.CreateBD(SimcCopyFrame)
			F.CreateSD(SimcCopyFrame)
			F.Reskin(SimcCopyFrameButton)
			F.ReskinScroll(SimcCopyFrameScrollScrollBar)
		end

		if IsAddOnLoaded("TinyInspect") then
			for i = 1, 9 do
				select(i, TinyInspectRaidFrame:GetRegions()):Hide()
				select(i, TinyInspectRaidFrame.panel:GetRegions()):Hide()
			end

			F.CreateBD(TinyInspectRaidFrame)
			F.CreateSD(TinyInspectRaidFrame)
			F.CreateBD(TinyInspectRaidFrame.panel)
			F.CreateSD(TinyInspectRaidFrame.panel)
		end

		if IsAddOnLoaded("WhisperPop") then
			F.CreateBD(WhisperPopFrame)
			F.CreateSD(WhisperPopFrame)
			F.CreateBD(WhisperPopMessageFrame)
			F.CreateSD(WhisperPopMessageFrame)
			F.ReskinArrow(WhisperPopScrollingMessageFrameButtonDown, "down")
			F.ReskinArrow(WhisperPopScrollingMessageFrameButtonEnd, "down")
			F.ReskinArrow(WhisperPopScrollingMessageFrameButtonUp, "up")
			F.ReskinCheck(WhisperPopMessageFrameProtectCheck)
			F.ReskinIconStyle(WhisperPopFrameConfig)
			F.ReskinIconStyle(WhisperPopNotifyButton)
			F.ReskinScroll(WhisperPopFrameListScrollBar)

			local list = {"WhisperPopFrameListDelete", "WhisperPopFrameTopCloseButton", "WhisperPopMessageFrameTopCloseButton"}
			for k, v in pairs(list) do
				F.ReskinClose(_G[v])
			end
		end

		if IsAddOnLoaded("WorldQuestTab") then
			WQT_TabNormal.TabBg:Hide()
			WQT_TabNormal.Hider:Hide()
			WQT_TabNormal.Highlight:SetTexture("")
			WQT_TabWorld.TabBg:Hide()
			WQT_TabWorld.Hider:Hide()
			WQT_TabWorld.Highlight:SetTexture("")
			F.Reskin(WQT_TabNormal)
			F.Reskin(WQT_TabWorld)
			F.ReskinDropDown(WQT_WorldQuestFrameSortButton)
			F.ReskinFilterButton(WQT_WorldQuestFrameFilterButton)
			F.ReskinScroll(WQT_QuestScrollFrameScrollBar)

			for i = 1, 2 do
				select(i, WQT_QuestScrollFrameScrollBar:GetRegions()):Hide()
			end
			for r = 1, 15 do
				local bu = _G["WQT_QuestScrollFrameButton"..r]
				local re = bu.reward
				re:SetSize(26, 26)
				re.icon:SetTexCoord(.08, .92, .08, .92)
				re.iconBorder:Hide()
				F.CreateBDFrame(re.icon)
			end
		end

	end)
end