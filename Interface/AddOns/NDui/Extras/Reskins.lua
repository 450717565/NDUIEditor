local B, C, L, DB = unpack(select(2, ...))

local function Reskins()
	B:UnregisterEvent("PLAYER_ENTERING_WORLD", Reskins)

	if IsAddOnLoaded("!BaudErrorFrame") then
		B.CreateBD(BaudErrorFrame)
		B.CreateSD(BaudErrorFrame)
		B.CreateTex(BaudErrorFrame)
		B.StripTextures(BaudErrorFrameListScrollBox)
		B.CreateBD(BaudErrorFrameListScrollBox)
		B.CreateSD(BaudErrorFrameListScrollBox)
		B.StripTextures(BaudErrorFrameDetailScrollBox)
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
		UsePFGButton.text:SetWidth(UsePFGButton.text:GetStringWidth()+2)

		local dialog = PremadeGroupsFilterDialog
		dialog.Defeated.Title:ClearAllPoints()
		dialog.Defeated.Title:SetPoint("LEFT", dialog.Defeated.Act, "RIGHT", 12, 0)
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

		if IsAddOnLoaded("ExtVendor") then
			MerchantFrameSearchBox:SetHeight(22)
			F.ReskinInput(MerchantFrameSearchBox)

			MerchantFrameSellJunkButtonIcon:SetTexCoord(.08, .92, .08, .92)
			F.CreateBDFrame(MerchantFrameSellJunkButton)

			F.Reskin(MerchantFrameFilterButton)

			for i = 13, 20 do
				_G["MerchantItem"..i.."SlotTexture"]:Hide()
				_G["MerchantItem"..i.."NameFrame"]:Hide()
				_G["MerchantItem"..i.."Name"]:SetHeight(20)

				local button = _G["MerchantItem"..i]
				button.bd = CreateFrame("Frame", nil, button)
				button.bd:SetPoint("TOPLEFT", 39, 0)
				button.bd:SetPoint("BOTTOMRIGHT")
				button.bd:SetFrameLevel(0)
				F.CreateBD(button.bd, .25)
				F.CreateSD(button.bd)

				local mo = _G["MerchantItem"..i.."MoneyFrame"]
				local a3, p2, a4, x, y = mo:GetPoint()
				mo:SetPoint(a3, p2, a4, x+1, y+4)

				local bu = _G["MerchantItem"..i.."ItemButton"]
				local a1, p, a2 = bu:GetPoint()
				bu:SetPoint(a1, p, a2, -4, -2)
				bu:SetNormalTexture("")
				bu:SetPushedTexture("")
				bu:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)
				bu:SetSize(40, 40)
				bu.IconBorder:SetAlpha(0)
				F.CreateBDFrame(bu, 0)

				local ic = bu.icon
				ic:SetTexCoord(.08, .92, .08, .92)
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
				_G["Overachiever_"..v]:DisableDrawLayer("ARTWORK")
				_G["Overachiever_"..v]:DisableDrawLayer("BACKGROUND")
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

		if IsAddOnLoaded("PremadeGroupsFilter") then
			local dialog = PremadeGroupsFilterDialog
			F.StripTextures(dialog, true)
			F.StripTextures(dialog.Advanced, true)
			F.StripTextures(dialog.Expression, true)
			F.CreateBD(dialog)
			F.CreateSD(dialog)
			F.CreateBD(dialog.Expression)
			F.CreateSD(dialog.Expression)
			F.ReskinClose(dialog.CloseButton)
			F.Reskin(dialog.ResetButton)
			F.Reskin(dialog.RefreshButton)
			F.ReskinDropDown(dialog.Difficulty.DropDown)
			F.ReskinCheck(UsePFGButton)

			local buttons = {dialog.Defeated.Act, dialog.Difficulty.Act, dialog.Dps.Act, dialog.Heals.Act, dialog.Ilvl.Act, dialog.Members.Act, dialog.Noilvl.Act, dialog.Tanks.Act}
			for _, button in next, buttons do
				local p1, p2, p3, _, _ = button:GetPoint()
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

			local list = {"WhisperPopFrameListDelete", "WhisperPopFrameTopCloseButton", "WhisperPopMessageFrameTopCloseButton"}
			for k, v in pairs(list) do
				F.ReskinClose(_G[v])
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
			F.Reskin(WQT_TabNormal)
			F.Reskin(WQT_TabWorld)
			F.ReskinDropDown(WQT_WorldQuestFrameSortButton)
			F.ReskinFilterButton(WQT_WorldQuestFrameFilterButton)
			F.ReskinScroll(WQT_QuestScrollFrameScrollBar)

			WQT_WorldQuestFrame.filterBar:GetRegions():Hide()

			local WQTDF = WQT_QuestScrollFrame.DetailFrame
			WQTDF.TopDetail:Hide()
			WQTDF.BottomDetail:Hide()

			for i = 1, 2 do
				select(i, WQT_QuestScrollFrameScrollBar:GetRegions()):Hide()
			end
			for r = 1, 15 do
				local bu = _G["WQT_QuestScrollFrameButton"..r]

				local rw = bu.reward
				rw:SetSize(26, 26)
				rw.icon:SetTexCoord(.08, .92, .08, .92)
				rw.iconBorder:Hide()
				F.CreateBDFrame(rw.icon)

				local fac = bu.faction
				fac.icon:SetTexCoord(.08, .92, .08, .92)
				F.CreateBDFrame(fac.icon)

				local tm = bu.time
				tm:ClearAllPoints()
				tm:SetPoint("LEFT", fac, "RIGHT", 5, -7)
			end
		end
	end
end

B:RegisterEvent("PLAYER_ENTERING_WORLD", Reskins)