local B, C, L, DB = unpack(select(2, ...))

local function Reskins()
	B:UnregisterEvent("PLAYER_ENTERING_WORLD", Reskins)

	if IsAddOnLoaded("!BaudErrorFrame") then
		B.StripTextures(BaudErrorFrameListScrollBox, true)
		B.StripTextures(BaudErrorFrameDetailScrollBox, true)

		B.CreateBD(BaudErrorFrame)
		B.CreateSD(BaudErrorFrame)
		B.CreateTex(BaudErrorFrame)

		B.CreateBD(BaudErrorFrameListScrollBox)
		B.CreateSD(BaudErrorFrameListScrollBox)
		B.CreateBD(BaudErrorFrameDetailScrollBox)
		B.CreateSD(BaudErrorFrameDetailScrollBox)

		local boxHL = BaudErrorFrameListScrollBoxHighlightTexture
		boxHL:SetTexture(DB.bdTex)
		boxHL:SetVertexColor(DB.CC.r, DB.CC.g, DB.CC.b, .25)

		for _, button in next, {BaudErrorFrameClearButton, BaudErrorFrameCloseButton, BaudErrorFrameReloadUIButton} do
			B.CreateBC(button)
		end
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
		local F, C = unpack(AuroraClassic)
		local r, g, b = C.r, C.g, C.b

		if IsAddOnLoaded("!BaudErrorFrame") then
			F.ReskinScroll(BaudErrorFrameListScrollBoxScrollBarScrollBar)
			F.ReskinScroll(BaudErrorFrameDetailScrollFrameScrollBar)
		end
	--[[
		if IsAddOnLoaded("!Libs") then
			-- LibUIDropDownMenu
			local function isCheckTexture(check)
				if check:GetTexture() == "Interface\\Common\\UI-DropDownRadioChecks" then
					return true
				end
			end

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
						if isCheckTexture(check) then
							check:SetSize(20, 20)
							check:SetTexCoord(0, 1, 0, 1)
							check:SetTexture("Interface\\Buttons\\UI-CheckBox-Check")
							check:SetVertexColor(r, g, b, 1)
							check:SetDesaturated(true)
						end

						local uncheck = _G["L_DropDownList"..i.."Button"..j.."UnCheck"]
						if isCheckTexture(uncheck) then uncheck:SetTexture("") end
					end
				end
			end
			hooksecurefunc("L_UIDropDownMenu_AddButton", SkinDDM)
		end
	]]
		if IsAddOnLoaded("AuctionLite") then
			F.StripTextures(SellRememberButton, true)
			F.ReskinArrow(BuyAdvancedButton, "down")
			F.ReskinArrow(SellRememberButton, "down")
			F.ReskinArrow(BuySummaryButton, "left")
			SellSize:SetWidth(40)
			SellSize:ClearAllPoints()
			SellSize:SetPoint("LEFT", SellStacks, "RIGHT", 66, 0)
			SellBidPriceSilver:SetPoint("LEFT", SellBidPriceGold, "RIGHT", 1, 0)
			SellBidPriceCopper:SetPoint("LEFT", SellBidPriceSilver, "RIGHT", 1, 0)
			SellBuyoutPriceSilver:SetPoint("LEFT", SellBuyoutPriceGold, "RIGHT", 1, 0)
			SellBuyoutPriceCopper:SetPoint("LEFT", SellBuyoutPriceSilver, "RIGHT", 1, 0)
			BuyBuyoutButton:SetPoint("RIGHT", BuyCancelAuctionButton, "LEFT", -2, 0)
			BuyBidButton:SetPoint("RIGHT", BuyBuyoutButton, "LEFT", -2, 0)

			F.StripTextures(SellItemButton, true)
			F.CreateBDFrame(SellItemButton, .25)

			local sellitemhandler = CreateFrame("Frame")
			sellitemhandler:RegisterEvent("NEW_AUCTION_UPDATE")
			sellitemhandler:SetScript("OnEvent", function()
				local SellItemButtonIconTexture = SellItemButton:GetNormalTexture()
				if SellItemButtonIconTexture then
					SellItemButtonIconTexture:SetTexCoord(.08, .92, .08, .92)
				end
			end)

			for i = 1, 16 do
				local btn = _G["SellButton" .. i]
				local hl = btn:GetHighlightTexture()
				hl:SetColorTexture(r, g, b, .25)
				hl:SetPoint("TOPLEFT", 0, 2)
				hl:SetPoint("BOTTOMRIGHT", 2, 2)
			end

			local Inputlist = {BuyName, BuyQuantity, SellStacks, SellSize, SellBidPriceGold, SellBidPriceSilver, SellBidPriceCopper, SellBuyoutPriceGold, SellBuyoutPriceSilver, SellBuyoutPriceCopper}
			for _, input in next, Inputlist do
				F.ReskinInput(input)
			end

			local Buttonlist = {BuySearchButton, BuyScanButton, BuyBidButton, BuyBuyoutButton, BuyCancelAuctionButton, BuyCancelSearchButton, SellCreateAuctionButton, SellStacksMaxButton, SellSizeMaxButton}
			for _, button in next, Buttonlist do
				F.Reskin(button)
			end

			local Radiolist = {SellShortAuctionButton, SellMediumAuctionButton, SellLongAuctionButton, SellPerItemButton, SellPerStackButton}
			for _, radio in next, Radiolist do
				radio:SetSize(20, 20)
				F.ReskinRadio(radio)
			end

			local Scrolllist = {"BuyScrollFrame", "SellScrollFrame"}
			for k, v in pairs(Scrolllist) do
				F.StripTextures(_G[v])
				F.ReskinScroll(_G[v.."ScrollBar"])
			end
		end

		if IsAddOnLoaded("BaudAuction") then
			F.StripTextures(BaudAuctionBrowseScrollBoxScrollBar, true)
			F.CreateBD(BaudAuctionProgress)
			F.CreateSD(BaudAuctionProgress)
			F.ReskinScroll(BaudAuctionBrowseScrollBoxScrollBarScrollBar)

			BaudAuctionProgressBar:SetPoint("CENTER", 0, -5)
			F.ReskinStatusBar(BaudAuctionProgressBar, true, true)

			local boxHL = BaudAuctionBrowseScrollBoxHighlight
			boxHL:SetTexture(C.media.backdrop)
			boxHL:SetPoint("LEFT", 4, 0)
			boxHL:SetPoint("RIGHT", 10, 0)

			for k = 1, 19 do
				F.ReskinIcon(_G["BaudAuctionBrowseScrollBoxEntry"..k.."Texture"])
			end
		end

		if IsAddOnLoaded("BuyEmAll") then
			F.StripTextures(BuyEmAllFrame, true)
			F.CreateBD(BuyEmAllFrame)
			F.CreateSD(BuyEmAllFrame)
			F.ReskinArrow(BuyEmAllLeftButton, "left")
			F.ReskinArrow(BuyEmAllRightButton, "right")
			BuyEmAllCurrencyFrame:ClearAllPoints()
			BuyEmAllCurrencyFrame:SetPoint("TOP", 0, -40)

			local lists = {BuyEmAllOkayButton, BuyEmAllCancelButton, BuyEmAllStackButton, BuyEmAllMaxButton}
			for _, list in next, lists do
				F.Reskin(list)
			end
		end

		if IsAddOnLoaded("Immersion") then
			local talkbox = ImmersionFrame.TalkBox.MainFrame
			F.ReskinClose(talkbox.CloseButton, "TOPRIGHT", talkbox, "TOPRIGHT", -20, -20)
		end

		if IsAddOnLoaded("ExtVendor") then
			MerchantFrameSearchBox:SetHeight(22)
			F.ReskinInput(MerchantFrameSearchBox)

			MerchantFrameSellJunkButtonIcon:SetTexCoord(.08, .92, .08, .92)
			F.CreateBDFrame(MerchantFrameSellJunkButton, .25)

			F.Reskin(MerchantFrameFilterButton)

			for i = 13, 20 do
				local item = _G["MerchantItem"..i]
				F.StripTextures(item, true)
				item.bd = F.CreateBDFrame(item, .25)
				item.bd:SetPoint("TOPLEFT", 40, 2)
				item.bd:SetPoint("BOTTOMRIGHT", 0, -2)

				local button = _G["MerchantItem"..i.."ItemButton"]
				F.StripTextures(button)
				button:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)
				button:SetSize(40, 40)
				button.IconBorder:SetAlpha(0)
				F.CreateBDFrame(button, .25)

				local b1, b2, b3 = button:GetPoint()
				button:SetPoint(b1, b2, b3, -4, -2)

				local ic = button.icon
				ic:SetTexCoord(.08, .92, .08, .92)

				local name = _G["MerchantItem"..i.."Name"]
				local n1, n2, n3 = name:GetPoint()
				name:SetPoint(n1, n2, n3, -10, 5)

				local money = _G["MerchantItem"..i.."MoneyFrame"]
				local m1, m2, m3, m4, m5 = money:GetPoint()
				money:SetPoint(m1, m2, m3, m4-2, m5)

				for j = 1, 3 do
					local acTex = _G["MerchantItem"..i.."AltCurrencyFrameItem"..j.."Texture"]
					F.ReskinIcon(acTex)
				end
			end
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
				F.StripTextures(_G["Overachiever_"..v], true)
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

					F.StripTextures(bu, true)
					_G["Overachiever_"..v..i.."Highlight"]:SetAlpha(0)
					_G["Overachiever_"..v..i.."IconOverlay"]:Hide()

					bu.description:SetTextColor(.9, .9, .9)
					bu.description.SetTextColor = F.dummy
					bu.description:SetShadowOffset(1, -1)
					bu.description.SetShadowOffset = F.dummy

					bu.icon.texture:SetTexCoord(.08, .92, .08, .92)
					F.CreateBDFrame(bu.icon.texture, .25)

					local bg = F.CreateBDFrame(bu, .25)
					bg:SetPoint("TOPLEFT", 1, -1)
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
			F.CreateBD(SimcCopyFrame)
			F.CreateSD(SimcCopyFrame)
			F.Reskin(SimcCopyFrameButton)
			F.ReskinScroll(SimcCopyFrameScrollScrollBar)
		end

		if IsAddOnLoaded("PremadeGroupsFilter") then
			local dialog = PremadeGroupsFilterDialog
			F.StripTextures(dialog, true)
			F.StripTextures(dialog.Advanced, true)
			F.StripTextures(dialog.Expression, true)
			F.CreateBD(dialog)
			F.CreateSD(dialog)
			F.CreateBDFrame(dialog.Expression, .25)
			F.ReskinClose(dialog.CloseButton)
			F.Reskin(dialog.ResetButton)
			F.Reskin(dialog.RefreshButton)
			F.ReskinDropDown(dialog.Difficulty.DropDown)
			F.ReskinCheck(UsePFGButton)

			dialog.Defeated.Title:ClearAllPoints()
			dialog.Defeated.Title:SetPoint("LEFT", dialog.Defeated.Act, "RIGHT", 10, 0)
			dialog.Difficulty.DropDown:ClearAllPoints()
			dialog.Difficulty.DropDown:SetPoint("RIGHT", dialog.Difficulty, "RIGHT", 13, -3)

			local buttons = {dialog.Defeated.Act, dialog.Difficulty.Act, dialog.Dps.Act, dialog.Heals.Act, dialog.Ilvl.Act, dialog.Members.Act, dialog.Noilvl.Act, dialog.Tanks.Act}
			for _, button in next, buttons do
				local p1, p2, p3, x, y = button:GetPoint()
				button:SetPoint(p1, p2, p3, 0, -3)
				button:SetSize(24, 24)
				F.ReskinCheck(button)
			end

			local inputs = {dialog.Defeated.Min, dialog.Dps.Min, dialog.Heals.Min, dialog.Ilvl.Min, dialog.Members.Min, dialog.Tanks.Min, dialog.Defeated.Max, dialog.Dps.Max, dialog.Heals.Max, dialog.Ilvl.Max, dialog.Members.Max, dialog.Tanks.Max}
			for _, input in next, inputs do
				F.ReskinInput(input)
			end
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

			local listHL = WhisperPopFrameListHighlightTexture
			listHL:SetTexture(C.media.backdrop)
			listHL:SetVertexColor(r, g, b, .25)

			local lists = {WhisperPopFrameListDelete, WhisperPopFrameTopCloseButton, WhisperPopMessageFrameTopCloseButton}
			for _, list in next, lists do
				F.ReskinClose(list)
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

			F.StripTextures(WQT_WorldQuestFrame, true)
			F.StripTextures(WQT_QuestScrollFrame.DetailFrame, true)
			F.Reskin(WQT_TabNormal)
			F.Reskin(WQT_TabWorld)
			F.ReskinDropDown(WQT_WorldQuestFrameSortButton)
			F.ReskinFilterButton(WQT_WorldQuestFrameFilterButton)
			F.ReskinScroll(WQT_QuestScrollFrameScrollBar)

			WQT_WorldQuestFrame.FilterBar:GetRegions():Hide()

			for r = 1, 15 do
				local bu = _G["WQT_QuestScrollFrameButton"..r]

				local rw = bu.Reward
				rw:SetSize(26, 26)
				rw.Icon:SetTexCoord(.08, .92, .08, .92)
				rw.IconBorder:Hide()
				F.CreateBDFrame(rw.Icon, .25)

				local fac = bu.Faction
				fac.Icon:SetTexCoord(.08, .92, .08, .92)
				F.CreateBDFrame(fac.Icon, .25)

				local tm = bu.Time
				tm:ClearAllPoints()
				tm:SetPoint("LEFT", fac, "RIGHT", 5, -7)
			end
		end
	end
end

B:RegisterEvent("PLAYER_ENTERING_WORLD", Reskins)