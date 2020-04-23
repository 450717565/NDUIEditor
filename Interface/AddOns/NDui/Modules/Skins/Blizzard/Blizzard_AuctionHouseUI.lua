local B, C, L, DB = unpack(select(2, ...))

C.themes["Blizzard_AuctionHouseUI"] = function()
	local cr, cg, cb = DB.r, DB.g, DB.b

	local function reskinAuctionButton(self)
		B.ReskinButton(self)
		self:SetSize(22, 22)
	end

	local function reskinItemDisplay(self)
		B.StripTextures(self)

		B.CreateBDFrame(self, 0, -3)

		local ItemButton = self.ItemButton
		B.CleanTextures(ItemButton)

		if ItemButton.IconMask then ItemButton.IconMask:Hide() end
		if ItemButton.CircleMask then ItemButton.CircleMask:Hide() end
		if ItemButton.EmptyBackground then ItemButton.EmptyBackground:Hide() end

		local icbg = B.ReskinIcon(ItemButton.Icon)
		B.ReskinBorder(ItemButton.IconBorder, icbg)
		B.ReskinHighlight(ItemButton.Highlight, icbg)
	end

	local function reskinSellPanel(self)
		B.StripTextures(self)

		reskinItemDisplay(self.ItemDisplay)

		B.ReskinButton(self.PostButton)
		B.ReskinButton(self.QuantityInput.MaxButton)
		B.ReskinDropDown(self.DurationDropDown.DropDown)
		B.ReskinInput(self.QuantityInput.InputBox)
		B.ReskinInput(self.PriceInput.MoneyInputFrame.GoldBox)
		B.ReskinInput(self.PriceInput.MoneyInputFrame.SilverBox)

		if self.BuyoutModeCheckButton then
			B.ReskinCheck(self.BuyoutModeCheckButton)
			self.BuyoutModeCheckButton:SetSize(28, 28)
		end

		if self.SecondaryPriceInput then
			B.ReskinInput(self.SecondaryPriceInput.MoneyInputFrame.GoldBox)
			B.ReskinInput(self.SecondaryPriceInput.MoneyInputFrame.SilverBox)
		end
	end

	local function reskinListIcon(self)
		if not self.tableBuilder then return end

		for i = 1, 22 do
			local row = self.tableBuilder.rows[i]
			if row then
				row.HighlightTexture:SetColorTexture(1, 1, 1, .25)
				row.SelectedHighlight:SetColorTexture(cr, cg, cb, .25)

				for j = 1, 4 do
					local cell = row.cells and row.cells[j]
					if cell and cell.Icon then
						if not cell.styled then
							cell.Icon.bg = B.ReskinIcon(cell.Icon)
							if cell.IconBorder then
								cell.IconBorder:SetAlpha(0)
								cell.IconBorder:Hide()
							end

							cell.styled = true
						end

						cell.Icon.bg:SetShown(cell.Icon:IsShown())
					end
				end
			end
		end
	end

	local function reskinSummaryIcon(self)
		for i = 1, 23 do
			local child = select(i, self.ScrollFrame.scrollChild:GetChildren())
			if child and child.Icon then
				if not child.styled then
					child.HighlightTexture:SetColorTexture(1, 1, 1, .25)
					child.Icon.bg = B.ReskinIcon(child.Icon)
					if child.IconBorder then
						child.IconBorder:SetAlpha(0)
						child.IconBorder:Hide()
					end

					child.styled = true
				end
				child.Icon.bg:SetShown(child.Icon:IsShown())
			end
		end
	end

	local function reskinListHeader(self)
		local maxHeaders = self.HeaderContainer:GetNumChildren()
		for i = 1, maxHeaders do
			local header = select(i, self.HeaderContainer:GetChildren())
			if header and not header.styled then
				header:DisableDrawLayer("BACKGROUND")
				header.bg = B.CreateBDFrame(header, 0)
				B.ReskinHighlight(header, header.bg, true)

				header.styled = true
			end

			if header.bg then
				header.bg:SetPoint("BOTTOMRIGHT", i < maxHeaders and -5 or 0, -2)
			end
		end

		reskinListIcon(self)
	end

	local function reskinSellList(self, hasHeader)
		B.StripTextures(self)
		B.ReskinScroll(self.ScrollFrame.scrollBar)

		if self.RefreshFrame then
			reskinAuctionButton(self.RefreshFrame.RefreshButton)
		end

		if self.ScrollFrame.ArtOverlay then
			local SelectedHighlight = self.ScrollFrame.ArtOverlay.SelectedHighlight
			SelectedHighlight:SetColorTexture(cr, cg, cb, .25)
		end

		if hasHeader then
			B.CreateBDFrame(self.ScrollFrame, 0)
			hooksecurefunc(self, "RefreshScrollFrame", reskinListHeader)
		else
			hooksecurefunc(self, "RefreshScrollFrame", reskinSummaryIcon)
		end
	end

	local function reskinItemList(self, hasHeader)
		B.StripTextures(self)
		B.CreateBDFrame(self.ScrollFrame, 0)
		B.ReskinScroll(self.ScrollFrame.scrollBar)

		if self.RefreshFrame then
			reskinAuctionButton(self.RefreshFrame.RefreshButton)
		end
		if hasHeader then
			hooksecurefunc(self, "RefreshScrollFrame", reskinListHeader)
		end
	end

	B.ReskinFrame(AuctionHouseFrame)

	B.StripTextures(AuctionHouseFrame.MoneyFrameInset)
	B.StripTextures(AuctionHouseFrame.MoneyFrameBorder)
	B.CreateBDFrame(AuctionHouseFrame.MoneyFrameBorder, 0)
	B.ReskinTab(AuctionHouseFrameBuyTab)
	B.ReskinTab(AuctionHouseFrameSellTab)
	B.ReskinTab(AuctionHouseFrameAuctionsTab)

	AuctionHouseFrameBuyTab:ClearAllPoints()
	AuctionHouseFrameBuyTab:SetPoint("TOPLEFT", AuctionHouseFrame, "BOTTOMLEFT", 15, 2)
	AuctionHouseFrameSilver:ClearAllPoints()
	AuctionHouseFrameSilver:SetPoint("LEFT", AuctionHouseFrameGold, "RIGHT", 4, 0)
	AuctionHouseFrameAuctionsFrameSilver:ClearAllPoints()
	AuctionHouseFrameAuctionsFrameSilver:SetPoint("LEFT", AuctionHouseFrameAuctionsFrameGold, "RIGHT", 4, 0)

	local SearchBar = AuctionHouseFrame.SearchBar
	B.ReskinInput(SearchBar.SearchBox)
	B.ReskinButton(SearchBar.SearchButton)
	B.ReskinFilter(SearchBar.FilterButton)
	B.ReskinClose(SearchBar.FilterButton.ClearFiltersButton, "RIGHT", SearchBar.FilterButton, "LEFT", -3, 0)
	B.ReskinInput(SearchBar.FilterButton.LevelRangeFrame.MinLevel)
	B.ReskinInput(SearchBar.FilterButton.LevelRangeFrame.MaxLevel)
	reskinAuctionButton(SearchBar.FavoritesSearchButton)

	local CategoriesList = AuctionHouseFrame.CategoriesList
	B.StripTextures(CategoriesList)
	B.ReskinScroll(CategoriesList.ScrollFrame.ScrollBar)
	hooksecurefunc("FilterButton_SetUp", function(button)
		button.NormalTexture:SetAlpha(0)
		button.HighlightTexture:SetColorTexture(1, 1, 1, .25)
		button.SelectedTexture:SetColorTexture(cr, cg, cb, .25)
	end)

	local ItemBuyFrame = AuctionHouseFrame.ItemBuyFrame
	B.ReskinButton(ItemBuyFrame.BackButton)
	B.ReskinButton(ItemBuyFrame.BidFrame.BidButton)
	B.ReskinButton(ItemBuyFrame.BuyoutFrame.BuyoutButton)
	B.ReskinInput(AuctionHouseFrameGold)
	B.ReskinInput(AuctionHouseFrameSilver)
	reskinItemDisplay(ItemBuyFrame.ItemDisplay)
	reskinItemList(ItemBuyFrame.ItemList, true)

	local CommoditiesBuyFrame = AuctionHouseFrame.CommoditiesBuyFrame
	B.ReskinButton(CommoditiesBuyFrame.BackButton)
	local BuyDisplay = CommoditiesBuyFrame.BuyDisplay
	B.StripTextures(BuyDisplay)
	B.ReskinInput(BuyDisplay.QuantityInput.InputBox)
	B.ReskinButton(BuyDisplay.BuyButton)
	reskinItemDisplay(BuyDisplay.ItemDisplay)
	reskinItemList(CommoditiesBuyFrame.ItemList)

	local BuyDialog = AuctionHouseFrame.BuyDialog
	B.ReskinFrame(BuyDialog)
	B.ReskinButton(BuyDialog.BuyNowButton)
	B.ReskinButton(BuyDialog.CancelButton)

	local WoWTokenResults = AuctionHouseFrame.WoWTokenResults
	B.StripTextures(WoWTokenResults)
	B.StripTextures(WoWTokenResults.TokenDisplay)
	B.CreateBDFrame(WoWTokenResults.TokenDisplay, 0)
	B.ReskinButton(WoWTokenResults.Buyout)
	B.ReskinScroll(WoWTokenResults.DummyScrollBar)

	local WoWTokenSellFrame = AuctionHouseFrame.WoWTokenSellFrame
	B.StripTextures(WoWTokenSellFrame)
	B.ReskinButton(WoWTokenSellFrame.PostButton)
	B.StripTextures(WoWTokenSellFrame.DummyItemList)
	B.CreateBDFrame(WoWTokenSellFrame.DummyItemList, 0)
	B.ReskinScroll(WoWTokenSellFrame.DummyItemList.DummyScrollBar)
	reskinAuctionButton(WoWTokenSellFrame.DummyRefreshButton)
	reskinItemDisplay(WoWTokenSellFrame.ItemDisplay)

	local GameTimeTutorial = WoWTokenResults.GameTimeTutorial
	B.ReskinFrame(GameTimeTutorial)
	B.ReskinButton(GameTimeTutorial.RightDisplay.StoreButton)
	GameTimeTutorial.LeftDisplay.Label:SetTextColor(1, 1, 1)
	GameTimeTutorial.LeftDisplay.Tutorial1:SetTextColor(1, .8, 0)
	GameTimeTutorial.RightDisplay.Label:SetTextColor(1, 1, 1)
	GameTimeTutorial.RightDisplay.Tutorial1:SetTextColor(1, .8, 0)

	local MultisellProgressFrame = AuctionHouseMultisellProgressFrame
	B.ReskinFrame(MultisellProgressFrame)
	local ProgressBar = MultisellProgressFrame.ProgressBar
	B.ReskinStatusBar(ProgressBar)
	B.ReskinIcon(ProgressBar.Icon)
	B.ReskinClose(MultisellProgressFrame.CancelButton, "LEFT", ProgressBar, "RIGHT", 3, 0)
	ProgressBar.Icon:ClearAllPoints()
	ProgressBar.Icon:SetPoint("RIGHT", ProgressBar, "LEFT", -3, 0)

	reskinItemDisplay(AuctionHouseFrameAuctionsFrame.ItemDisplay)
	reskinItemList(AuctionHouseFrame.BrowseResultsFrame.ItemList, true)
	reskinSellList(AuctionHouseFrame.CommoditiesSellList, true)
	reskinSellList(AuctionHouseFrame.ItemSellList, true)
	reskinSellList(AuctionHouseFrameAuctionsFrame.AllAuctionsList, true)
	reskinSellList(AuctionHouseFrameAuctionsFrame.BidsList, true)
	reskinSellList(AuctionHouseFrameAuctionsFrame.CommoditiesList, true)
	reskinSellList(AuctionHouseFrameAuctionsFrame.ItemList, true)
	reskinSellList(AuctionHouseFrameAuctionsFrame.SummaryList)
	reskinSellPanel(AuctionHouseFrame.CommoditiesSellFrame)
	reskinSellPanel(AuctionHouseFrame.ItemSellFrame)

	B.StripTextures(AuctionHouseFrameAuctionsFrameAuctionsTab)
	B.StripTextures(AuctionHouseFrameAuctionsFrameBidsTab)
	B.ReskinInput(AuctionHouseFrameAuctionsFrameGold)
	B.ReskinInput(AuctionHouseFrameAuctionsFrameSilver)
	B.ReskinButton(AuctionHouseFrameAuctionsFrame.CancelAuctionButton)
	B.ReskinButton(AuctionHouseFrameAuctionsFrame.BidFrame.BidButton)
	B.ReskinButton(AuctionHouseFrameAuctionsFrame.BuyoutFrame.BuyoutButton)
end