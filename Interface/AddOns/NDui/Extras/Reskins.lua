local B, C, L, DB = unpack(select(2, ...))

local function Reskins()
	B:UnregisterEvent("PLAYER_ENTERING_WORLD", Reskins)

	local cr, cg, cb = DB.r, DB.g, DB.b

	if IsAddOnLoaded("!BaudErrorFrame") then
		B.StripTextures(BaudErrorFrameListScrollBox)
		B.StripTextures(BaudErrorFrameDetailScrollBox)

		B.SetBackground(BaudErrorFrame)

		B.CreateBD(BaudErrorFrameListScrollBox, .25)
		B.CreateSD(BaudErrorFrameListScrollBox)
		B.CreateBD(BaudErrorFrameDetailScrollBox, .25)
		B.CreateSD(BaudErrorFrameDetailScrollBox)

		local boxHL = BaudErrorFrameListScrollBoxHighlightTexture
		boxHL:SetTexture(DB.bdTex)
		boxHL:SetVertexColor(cr, cg, cb, .25)

		for _, button in next, {BaudErrorFrameClearButton, BaudErrorFrameCloseButton, BaudErrorFrameReloadUIButton} do
			B.CreateBC(button, .25)
		end
	end

	if IsAddOnLoaded("DungeonWatchDog") then
		select(11, LFGListFrame.SearchPanel:GetChildren()):Hide()
	end

	if IsAddOnLoaded("PremadeGroupsFilter") then
		local rebtn = LFGListFrame.SearchPanel.RefreshButton
		UsePFGButton:SetSize(32, 32)
		UsePFGButton:ClearAllPoints()
		UsePFGButton:SetPoint("RIGHT", rebtn, "LEFT", -55, 0)
		UsePFGButton.text:SetText(FILTER)
		UsePFGButton.text:SetWidth(UsePFGButton.text:GetStringWidth())

		local dialog = PremadeGroupsFilterDialog
		dialog.Defeated.Title:ClearAllPoints()
		dialog.Defeated.Title:SetPoint("LEFT", dialog.Defeated.Act, "RIGHT", 2, 0)
	end

	if IsAddOnLoaded("AuroraClassic") then
		local F = unpack(AuroraClassic)

		if IsAddOnLoaded("!BaudErrorFrame") then
			F.ReskinScroll(BaudErrorFrameListScrollBoxScrollBarScrollBar)
			F.ReskinScroll(BaudErrorFrameDetailScrollFrameScrollBar)
		end

		if IsAddOnLoaded("AuctionLite") then
			F.ReskinArrow(BuyAdvancedButton, "down")
			F.ReskinArrow(SellRememberButton, "down")
			F.ReskinArrow(BuySummaryButton, "left")

			SellSize:SetWidth(40)
			SellSize:ClearAllPoints()
			SellSize:SetPoint("LEFT", SellStacks, "RIGHT", 66, 0)

			SellBidPriceSilver:ClearAllPoints()
			SellBidPriceSilver:SetPoint("LEFT", SellBidPriceGold, "RIGHT", 1, 0)
			SellBidPriceCopper:ClearAllPoints()
			SellBidPriceCopper:SetPoint("LEFT", SellBidPriceSilver, "RIGHT", 1, 0)
			SellBuyoutPriceSilver:ClearAllPoints()
			SellBuyoutPriceSilver:SetPoint("LEFT", SellBuyoutPriceGold, "RIGHT", 1, 0)
			SellBuyoutPriceCopper:ClearAllPoints()
			SellBuyoutPriceCopper:SetPoint("LEFT", SellBuyoutPriceSilver, "RIGHT", 1, 0)
			BuyBuyoutButton:ClearAllPoints()
			BuyBuyoutButton:SetPoint("RIGHT", BuyCancelAuctionButton, "LEFT", -1, 0)
			BuyBidButton:ClearAllPoints()
			BuyBidButton:SetPoint("RIGHT", BuyBuyoutButton, "LEFT", -1, 0)

			do
				F.StripTextures(SellItemButton)
				F.CreateBDFrame(SellItemButton, 0)
				local frame = CreateFrame("Frame")
				frame:RegisterEvent("NEW_AUCTION_UPDATE")
				frame:SetScript("OnEvent", function()
					local icon = SellItemButton:GetNormalTexture()
					if icon then icon:SetTexCoord(.08, .92, .08, .92) end
				end)
			end

			for i = 1, 16 do
				local sell = _G["SellButton"..i]
				F.ReskinTexture(sell, sell, true)

				local buy = _G["BuyButton"..i]
				F.ReskinTexture(buy, buy, true)
			end

			local Framelist = {SellRememberButton, BuyScrollFrame, SellScrollFrame}
			for _, frame in next, Framelist do
				F.StripTextures(frame)
			end

			local Inputlist = {BuyName, BuyQuantity, SellStacks, SellSize, SellBidPriceGold, SellBidPriceSilver, SellBidPriceCopper, SellBuyoutPriceGold, SellBuyoutPriceSilver, SellBuyoutPriceCopper}
			for _, input in next, Inputlist do
				F.ReskinInput(input)
			end

			local Buttonlist = {BuySearchButton, BuyScanButton, BuyBidButton, BuyBuyoutButton, BuyCancelAuctionButton, BuyCancelSearchButton, SellCreateAuctionButton, SellStacksMaxButton, SellSizeMaxButton}
			for _, button in next, Buttonlist do
				F.ReskinButton(button)
			end

			local Radiolist = {SellShortAuctionButton, SellMediumAuctionButton, SellLongAuctionButton, SellPerItemButton, SellPerStackButton}
			for _, radio in next, Radiolist do
				radio:SetSize(20, 20)
				F.ReskinRadio(radio)
			end

			local Buttonlist = {SellItemNameButton, SellBuyoutEachButton, SellBuyoutAllButton}
			for _, button in next, Buttonlist do
				F.ReskinTexture(button, button, true)
			end

			local Scrolllist = {BuyScrollFrameScrollBar, SellScrollFrameScrollBar}
			for _, scroll in next, Scrolllist do
				F.ReskinScroll(scroll)
			end
		end

		if IsAddOnLoaded("BaudAuction") then
			F.StripTextures(BaudAuctionBrowseScrollBoxScrollBar)
			F.ReskinFrame(BaudAuctionProgress)
			F.ReskinScroll(BaudAuctionBrowseScrollBoxScrollBarScrollBar)

			BaudAuctionProgressBar:SetPoint("CENTER", 0, -5)
			F.ReskinStatusBar(BaudAuctionProgressBar)

			local boxHL = BaudAuctionBrowseScrollBoxHighlight
			boxHL:SetTexture(DB.bdTex)
			boxHL:SetPoint("LEFT", 4, 0)
			boxHL:SetPoint("RIGHT", 10, 0)

			for i = 1, 7 do
				local col = _G["BaudAuctionFrameCol"..i]
				F.ReskinTexture(col, col, true)
			end

			for k = 1, 19 do
				F.ReskinIcon(_G["BaudAuctionBrowseScrollBoxEntry"..k.."Texture"], true)
			end
		end

		if IsAddOnLoaded("BuyEmAll") then
			F.ReskinFrame(BuyEmAllFrame)
			F.ReskinArrow(BuyEmAllLeftButton, "left")
			F.ReskinArrow(BuyEmAllRightButton, "right")
			BuyEmAllCurrencyFrame:ClearAllPoints()
			BuyEmAllCurrencyFrame:SetPoint("TOP", 0, -40)

			local lists = {BuyEmAllOkayButton, BuyEmAllCancelButton, BuyEmAllStackButton, BuyEmAllMaxButton}
			for _, list in next, lists do
				F.ReskinButton(list)
			end
		end

		if IsAddOnLoaded("Immersion") then
			local talkbox = ImmersionFrame.TalkBox.MainFrame
			F.ReskinClose(talkbox.CloseButton, "TOPRIGHT", talkbox, "TOPRIGHT", -20, -20)
		end

		if IsAddOnLoaded("ExtVendor") then
			F.ReskinFrame(ExtVendor_SellJunkPopup)
			F.ReskinButton(ExtVendor_SellJunkPopupYesButton)
			F.ReskinButton(ExtVendor_SellJunkPopupNoButton)

			F.ReskinInput(MerchantFrameSearchBox, 22)
			F.ReskinButton(MerchantFrameFilterButton)

			local ic = F.ReskinIcon(MerchantFrameSellJunkButtonIcon)
			F.ReskinTexture(MerchantFrameSellJunkButton, ic, false)
			MerchantFrameSellJunkButton:SetPushedTexture(DB.textures.pushed)

			for i = 13, 20 do
				local bu = _G["MerchantItem"..i.."ItemButton"]
				F.StripTextures(bu)
				F.ReskinBorder(bu.IconBorder, bu)

				local ic = F.ReskinIcon(bu.icon)
				F.ReskinTexture(bu, ic, false)

				local item = _G["MerchantItem"..i]
				F.StripTextures(item)

				local name = _G["MerchantItem"..i.."Name"]
				name:ClearAllPoints()
				name:SetPoint("TOPLEFT", ic, "TOPRIGHT", 4, 1)

				local money = _G["MerchantItem"..i.."MoneyFrame"]
				money:ClearAllPoints()
				money:SetPoint("LEFT", ic, "BOTTOMRIGHT", 4, 2)

				for j = 1, 3 do
					F.ReskinIcon(_G["MerchantItem"..i.."AltCurrencyFrameItem"..j.."Texture"], true)
				end
			end
		end

		if IsAddOnLoaded("ls_Toasts") then
			local E = unpack(ls_Toasts)
			E:RegisterSkin("ndui", {
				name = "NDui",
				border = {
					offset = 0,
					size = C.mult,
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
					offset = 0,
					size = C.mult,
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
					offset = 0,
					size = C.mult,
					texture = {1, 1, 1, 1},
				},
			})
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
				F.StripTextures(_G["Overachiever_"..v])
				_G["Overachiever_"..v]:GetChildren():Hide()
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

					F.StripTextures(bu)
					F.ReskinIcon(bu.icon.texture)
					_G["Overachiever_"..v..i.."Highlight"]:SetAlpha(0)
					_G["Overachiever_"..v..i.."IconOverlay"]:Hide()

					bu.description:SetTextColor(.9, .9, .9)
					bu.description.SetTextColor = F.Dummy
					bu.description:SetShadowOffset(C.mult, -C.mult)
					bu.description.SetShadowOffset = F.Dummy

					local bg = F.CreateBDFrame(bu, 0)
					bg:SetPoint("TOPLEFT", C.mult, -C.mult)
					bg:SetPoint("BOTTOMRIGHT", 0, 2)

					local ch = bu.tracked
					ch:SetSize(22, 22)
					ch:ClearAllPoints()
					ch:SetPoint("TOPLEFT", buic, "BOTTOMLEFT", 2, 8)
					F.ReskinCheck(ch)
				end
			end
		end

		if IsAddOnLoaded("Simulationcraft") then
			F.ReskinFrame(SimcCopyFrame)
			F.ReskinButton(SimcCopyFrameButton)
			F.ReskinScroll(SimcCopyFrameScrollScrollBar)
		end

		if IsAddOnLoaded("PremadeGroupsFilter") then
			local dialog = PremadeGroupsFilterDialog
			F.StripTextures(dialog.Advanced)
			F.StripTextures(dialog.Expression)
			F.ReskinFrame(dialog)
			F.ReskinButton(dialog.ResetButton)
			F.ReskinButton(dialog.RefreshButton)
			F.ReskinDropDown(dialog.Difficulty.DropDown)
			F.ReskinCheck(UsePFGButton)
			F.CreateBDFrame(dialog.Expression, 0)

			dialog.Defeated.Title:ClearAllPoints()
			dialog.Defeated.Title:SetPoint("LEFT", dialog.Defeated.Act, "RIGHT", 10, 0)
			dialog.Difficulty.DropDown:ClearAllPoints()
			dialog.Difficulty.DropDown:SetPoint("RIGHT", dialog.Difficulty, "RIGHT", 13, -3)

			local buttons = {dialog.Defeated, dialog.Difficulty, dialog.Dps, dialog.Heals, dialog.Ilvl, dialog.Members, dialog.Noilvl, dialog.Tanks}
			for _, button in next, buttons do
				local btn = button["Act"]
				local p1, p2, p3, x, y = btn:GetPoint()
				btn:SetPoint(p1, p2, p3, 0, -3)
				btn:SetSize(24, 24)
				F.ReskinCheck(btn)
			end

			local inputs = {dialog.Defeated, dialog.Dps, dialog.Heals, dialog.Ilvl, dialog.Members, dialog.Tanks}
			for _, input in next, inputs do
				local min = input["Min"]
				local max = input["Max"]
				F.ReskinInput(min)
				F.ReskinInput(max)
			end
		end

		if IsAddOnLoaded("WhisperPop") then
			F.ReskinFrame(WhisperPopFrame, true)
			F.ReskinFrame(WhisperPopMessageFrame, true)
			F.ReskinArrow(WhisperPopScrollingMessageFrameButtonDown, "down")
			F.ReskinArrow(WhisperPopScrollingMessageFrameButtonEnd, "down")
			F.ReskinArrow(WhisperPopScrollingMessageFrameButtonUp, "up")
			F.ReskinCheck(WhisperPopMessageFrameProtectCheck)
			F.ReskinScroll(WhisperPopFrameListScrollBar)

			local listHL = WhisperPopFrameListHighlightTexture
			listHL:SetTexture(DB.bdTex)
			listHL:SetVertexColor(cr, cg, cb, .25)

			local lists = {WhisperPopFrameListDelete, WhisperPopFrameTopCloseButton, WhisperPopMessageFrameTopCloseButton}
			for _, list in next, lists do
				F.ReskinClose(list)
			end

			local buttons = {"WhisperPopFrameConfig", "WhisperPopNotifyButton"}
			for _, button in pairs(buttons) do
				local bu = _G[button]
				bu:SetNormalTexture("")
				bu:SetPushedTexture("")

				local ic = _G[button.."Icon"]
				ic:SetDrawLayer("ARTWORK")

				local bg = F.ReskinIcon(ic)
				F.ReskinTexture(bu, bg, false)

				if bu.SetCheckedTexture then
					bu:SetCheckedTexture(DB.textures.checked)
				end
			end
		end

		if IsAddOnLoaded("WorldQuestTab") then
			WQT_TabNormal.TabBg:Hide()
			WQT_TabNormal.Hider:Hide()
			WQT_TabNormal.Highlight:SetTexture("")
			WQT_TabNormal.Icon:SetPoint("CENTER")

			WQT_TabWorld:ClearAllPoints()
			WQT_TabWorld:SetPoint("LEFT", WQT_TabNormal, "RIGHT", 2, 0)
			WQT_TabWorld.TabBg:Hide()
			WQT_TabWorld.Hider:Hide()
			WQT_TabWorld.Highlight:SetTexture("")
			WQT_TabWorld.Icon:SetPoint("CENTER")

			F.StripTextures(WQT_WorldQuestFrame)
			F.StripTextures(WQT_QuestScrollFrame.DetailFrame)
			F.ReskinButton(WQT_TabNormal)
			F.ReskinButton(WQT_TabWorld)
			F.ReskinDropDown(WQT_WorldQuestFrameSortButton)
			F.ReskinFilter(WQT_WorldQuestFrameFilterButton)
			F.ReskinScroll(WQT_QuestScrollFrameScrollBar)

			WQT_WorldQuestFrame.FilterBar:GetRegions():Hide()

			for r = 1, 15 do
				local bu = _G["WQT_QuestScrollFrameButton"..r]

				local rw = bu.Reward
				rw:SetSize(26, 26)
				rw.IconBorder:Hide()
				F.ReskinIcon(rw.Icon)

				local fac = bu.Faction
				F.ReskinIcon(fac.Icon)

				local tm = bu.Time
				tm:ClearAllPoints()
				tm:SetPoint("LEFT", fac, "RIGHT", 5, -7)
			end
		end
	end
end

B:RegisterEvent("PLAYER_ENTERING_WORLD", Reskins)