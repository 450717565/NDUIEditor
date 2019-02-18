local B, C, L, DB, F, M = unpack(select(2, ...))

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
	end
end

B:RegisterEvent("PLAYER_ENTERING_WORLD", Reskins)