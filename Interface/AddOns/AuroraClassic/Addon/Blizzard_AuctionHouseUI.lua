local F, C = unpack(select(2, ...))

C.themes["Blizzard_AuctionHouseUI"] = function()
	local cr, cg, cb = C.r, C.g, C.b

	local function reskinAuctionButton(self)
		F.ReskinButton(self)
		self:SetSize(22,22)
	end

	local function reskinSellPanel(self)
		F.StripTextures(self)

		local ItemDisplay = self.ItemDisplay
		F.StripTextures(ItemDisplay)
		F.CreateBDFrame(ItemDisplay, 0)

		local ItemButton = ItemDisplay.ItemButton
		F.CleanTextures(ItemButton)
		ItemButton.EmptyBackground:Hide()
		if ItemButton.IconMask then ItemButton.IconMask:Hide() end

		local icbg = F.ReskinIcon(ItemButton.Icon)
		F.ReskinBorder(ItemButton.IconBorder, ItemButton.Icon)
		F.ReskinTexture(ItemButton.Highlight, icbg)

		F.ReskinButton(self.PostButton)
		F.ReskinButton(self.QuantityInput.MaxButton)
		F.ReskinDropDown(self.DurationDropDown.DropDown)
		F.ReskinInput(self.QuantityInput.InputBox)
		F.ReskinInput(self.PriceInput.MoneyInputFrame.GoldBox)
		F.ReskinInput(self.PriceInput.MoneyInputFrame.SilverBox)

		if self.BuyoutModeCheckButton then
			F.ReskinCheck(self.BuyoutModeCheckButton)
		end

		if self.SecondaryPriceInput then
			F.ReskinInput(self.SecondaryPriceInput.MoneyInputFrame.GoldBox)
			F.ReskinInput(self.SecondaryPriceInput.MoneyInputFrame.SilverBox)
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
							cell.Icon.bg = F.ReskinIcon(cell.Icon)
							if cell.IconBorder then cell.IconBorder:Hide() end

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
					child.IconBorder:SetAlpha(0)
					child.HighlightTexture:SetColorTexture(1, 1, 1, .25)
					child.Icon.bg = F.ReskinIcon(child.Icon)

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
				header.bg = F.CreateBDFrame(header, 0)
				F.ReskinTexture(header, header.bg, true)

				header.styled = true
			end

			if header.bg then
				header.bg:SetPoint("BOTTOMRIGHT", i < maxHeaders and -5 or 1, -2)
			end
		end

		reskinListIcon(self)
	end

	local function reskinSellList(self, hasHeader)
		F.StripTextures(self)
		F.ReskinScroll(self.ScrollFrame.scrollBar)

		if self.RefreshFrame then
			reskinAuctionButton(self.RefreshFrame.RefreshButton)
		end

		if self.ScrollFrame.ArtOverlay then
			local SelectedHighlight = self.ScrollFrame.ArtOverlay.SelectedHighlight
			SelectedHighlight:SetColorTexture(cr, cg, cb, .25)
		end

		if hasHeader then
			F.CreateBDFrame(self.ScrollFrame, 0)
			hooksecurefunc(self, "RefreshScrollFrame", reskinListHeader)
		else
			hooksecurefunc(self, "RefreshScrollFrame", reskinSummaryIcon)
		end
	end

	local function reskinItemDisplay(self)
		local ItemDisplay = self.ItemDisplay
		F.StripTextures(ItemDisplay)

		local bubg = F.CreateBDFrame(ItemDisplay, 0)
		bubg:SetPoint("TOPLEFT", 3, -3)
		bubg:SetPoint("BOTTOMRIGHT", -3, 0)

		local ItemButton = ItemDisplay.ItemButton
		ItemButton.CircleMask:Hide()
		ItemButton.IconBorder:SetAlpha(0)
		F.ReskinIcon(ItemButton.Icon)
	end

	local function reskinItemList(self)
		F.StripTextures(self)
		F.CreateBDFrame(self.ScrollFrame, 0)
		F.ReskinScroll(self.ScrollFrame.scrollBar)

		if self.RefreshFrame then
			reskinAuctionButton(self.RefreshFrame.RefreshButton)
		end
	end

	F.ReskinFrame(AuctionHouseFrame)

	F.StripTextures(AuctionHouseFrame.MoneyFrameInset)
	F.StripTextures(AuctionHouseFrame.MoneyFrameBorder)
	F.CreateBDFrame(AuctionHouseFrame.MoneyFrameBorder, 0)
	F.ReskinTab(AuctionHouseFrameBuyTab)
	F.ReskinTab(AuctionHouseFrameSellTab)
	F.ReskinTab(AuctionHouseFrameAuctionsTab)

	AuctionHouseFrameBuyTab:ClearAllPoints()
	AuctionHouseFrameBuyTab:SetPoint("TOPLEFT", AuctionHouseFrame, "BOTTOMLEFT", 15, 2)
	AuctionHouseFrameSilver:ClearAllPoints()
	AuctionHouseFrameSilver:SetPoint("LEFT", AuctionHouseFrameGold, "RIGHT", 4, 0)
	AuctionHouseFrameAuctionsFrameSilver:ClearAllPoints()
	AuctionHouseFrameAuctionsFrameSilver:SetPoint("LEFT", AuctionHouseFrameAuctionsFrameGold, "RIGHT", 4, 0)

	local SearchBar = AuctionHouseFrame.SearchBar
	F.ReskinInput(SearchBar.SearchBox)
	F.ReskinButton(SearchBar.SearchButton)
	F.ReskinFilter(SearchBar.FilterButton)
	F.ReskinClose(SearchBar.FilterButton.ClearFiltersButton, "RIGHT", SearchBar.FilterButton, "LEFT", -2, 0)
	F.ReskinInput(SearchBar.FilterButton.LevelRangeFrame.MinLevel)
	F.ReskinInput(SearchBar.FilterButton.LevelRangeFrame.MaxLevel)
	reskinAuctionButton(SearchBar.FavoritesSearchButton)

	local CategoriesList = AuctionHouseFrame.CategoriesList
	F.StripTextures(CategoriesList)
	F.ReskinScroll(CategoriesList.ScrollFrame.ScrollBar)
	hooksecurefunc("FilterButton_SetUp", function(button)
		button.NormalTexture:SetAlpha(0)
		button.HighlightTexture:SetColorTexture(1, 1, 1, .25)
		button.SelectedTexture:SetColorTexture(cr, cg, cb, .25)
	end)

	local ItemList = AuctionHouseFrame.BrowseResultsFrame.ItemList
	reskinItemList(ItemList)
	hooksecurefunc(ItemList, "RefreshScrollFrame", reskinListHeader)

	local ItemBuyFrame = AuctionHouseFrame.ItemBuyFrame
	F.ReskinButton(ItemBuyFrame.BackButton)
	F.ReskinButton(ItemBuyFrame.BidFrame.BidButton)
	F.ReskinButton(ItemBuyFrame.BuyoutFrame.BuyoutButton)
	F.ReskinInput(AuctionHouseFrameGold)
	F.ReskinInput(AuctionHouseFrameSilver)
	reskinItemDisplay(ItemBuyFrame)
	local ItemList = ItemBuyFrame.ItemList
	reskinItemList(ItemList)
	hooksecurefunc(ItemList, "RefreshScrollFrame", reskinListHeader)

	local CommoditiesBuyFrame = AuctionHouseFrame.CommoditiesBuyFrame
	F.ReskinButton(CommoditiesBuyFrame.BackButton)
	local BuyDisplay = CommoditiesBuyFrame.BuyDisplay
	F.StripTextures(BuyDisplay)
	F.ReskinInput(BuyDisplay.QuantityInput.InputBox)
	F.ReskinButton(BuyDisplay.BuyButton)
	reskinItemDisplay(BuyDisplay)
	local ItemList = CommoditiesBuyFrame.ItemList
	reskinItemList(ItemList)

	local BuyDialog = AuctionHouseFrame.BuyDialog
	F.ReskinFrame(BuyDialog)
	F.ReskinButton(BuyDialog.BuyNowButton)
	F.ReskinButton(BuyDialog.CancelButton)

	reskinSellPanel(AuctionHouseFrame.ItemSellFrame)
	reskinSellPanel(AuctionHouseFrame.CommoditiesSellFrame)
	reskinSellList(AuctionHouseFrame.CommoditiesSellList, true)
	reskinSellList(AuctionHouseFrame.ItemSellList, true)
	reskinSellList(AuctionHouseFrameAuctionsFrame.SummaryList)
	reskinSellList(AuctionHouseFrameAuctionsFrame.AllAuctionsList, true)
	reskinSellList(AuctionHouseFrameAuctionsFrame.BidsList, true)
	reskinSellList(AuctionHouseFrameAuctionsFrame.CommoditiesList, true)
	reskinItemDisplay(AuctionHouseFrameAuctionsFrame)

	F.StripTextures(AuctionHouseFrameAuctionsFrameAuctionsTab)
	F.StripTextures(AuctionHouseFrameAuctionsFrameBidsTab)
	F.ReskinInput(AuctionHouseFrameAuctionsFrameGold)
	F.ReskinInput(AuctionHouseFrameAuctionsFrameSilver)
	F.ReskinButton(AuctionHouseFrameAuctionsFrame.CancelAuctionButton)
	F.ReskinButton(AuctionHouseFrameAuctionsFrame.BidFrame.BidButton)
	F.ReskinButton(AuctionHouseFrameAuctionsFrame.BuyoutFrame.BuyoutButton)
end