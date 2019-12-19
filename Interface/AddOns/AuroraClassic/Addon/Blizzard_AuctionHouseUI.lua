local F, C = unpack(select(2, ...))

C.themes["Blizzard_AuctionHouseUI"] = function()
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

		F.ReskinInput(self.QuantityInput.InputBox)
		F.ReskinButton(self.QuantityInput.MaxButton)
		F.ReskinInput(self.PriceInput.MoneyInputFrame.GoldBox)
		F.ReskinInput(self.PriceInput.MoneyInputFrame.SilverBox)
		if self.SecondaryPriceInput then
			F.ReskinInput(self.SecondaryPriceInput.MoneyInputFrame.GoldBox)
			F.ReskinInput(self.SecondaryPriceInput.MoneyInputFrame.SilverBox)
		end
		F.ReskinDropDown(self.DurationDropDown.DropDown)
		F.ReskinButton(self.PostButton)
		if self.BuyoutModeCheckButton then F.ReskinCheck(self.BuyoutModeCheckButton) end
	end

	local function reskinListIcon(self)
		if not self.tableBuilder then return end

		for i = 1, 22 do
			local row = self.tableBuilder.rows[i]
			if row then
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
				header.bg:SetPoint("BOTTOMRIGHT", i < maxHeaders and -5 or 0, -2)
			end
		end

		reskinListIcon(self)
	end

	local function reskinSellList(self, hasHeader)
		F.StripTextures(self)

		if self.RefreshFrame then
			reskinAuctionButton(self.RefreshFrame.RefreshButton)
		end
		F.ReskinScroll(self.ScrollFrame.scrollBar)
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
		local bg = F.CreateBDFrame(ItemDisplay, 0)
		bg:SetPoint("TOPLEFT", 3, -3)
		bg:SetPoint("BOTTOMRIGHT", -3, 0)
		local ItemButton = ItemDisplay.ItemButton
		ItemButton.CircleMask:Hide()
		ItemButton.IconBorder:SetAlpha(0)
		F.ReskinIcon(ItemButton.Icon)
	end

	F.ReskinFrame(AuctionHouseFrame)
	F.StripTextures(AuctionHouseFrame.MoneyFrameBorder)
	F.CreateBDFrame(AuctionHouseFrame.MoneyFrameBorder, .25)
	F.StripTextures(AuctionHouseFrame.MoneyFrameInset)
	F.ReskinTab(AuctionHouseFrameBuyTab)
	F.ReskinTab(AuctionHouseFrameSellTab)
	F.ReskinTab(AuctionHouseFrameAuctionsTab)

	--AuctionHouseFrameBuyTab:ClearAllPoints()
	--AuctionHouseFrameBuyTab:SetPoint("TOPLEFT", AuctionHouseFrame, "BOTTOMLEFT", 15, 1)

	local SearchBar = AuctionHouseFrame.SearchBar
	reskinAuctionButton(SearchBar.FavoritesSearchButton)
	F.ReskinInput(SearchBar.SearchBox)
	F.ReskinFilterButton(SearchBar.FilterButton)
	F.ReskinButton(SearchBar.SearchButton)
	F.ReskinInput(SearchBar.FilterButton.LevelRangeFrame.MinLevel)
	F.ReskinInput(SearchBar.FilterButton.LevelRangeFrame.MaxLevel)

	F.StripTextures(AuctionHouseFrame.CategoriesList)
	F.ReskinScroll(AuctionHouseFrame.CategoriesList.ScrollFrame.ScrollBar)

	hooksecurefunc("FilterButton_SetUp", function(button)
		button.NormalTexture:SetAlpha(0)
		button.SelectedTexture:SetColorTexture(0, .6, 1, .3)
		button.HighlightTexture:SetColorTexture(1, 1, 1, .1)
	end)

	local ItemList = AuctionHouseFrame.BrowseResultsFrame.ItemList
	F.StripTextures(ItemList, 3)
	F.CreateBDFrame(ItemList.ScrollFrame, .25)
	F.ReskinScroll(ItemList.ScrollFrame.scrollBar)
	hooksecurefunc(ItemList, "RefreshScrollFrame", reskinListHeader)

	local itemBuyFrame = AuctionHouseFrame.ItemBuyFrame
	F.ReskinButton(itemBuyFrame.BackButton)
	F.ReskinButton(itemBuyFrame.BidFrame.BidButton)
	F.ReskinButton(itemBuyFrame.BuyoutFrame.BuyoutButton)
	F.ReskinInput(AuctionHouseFrameGold)
	F.ReskinInput(AuctionHouseFrameSilver)
	reskinItemDisplay(itemBuyFrame)
	local ItemList = itemBuyFrame.ItemList
	F.StripTextures(ItemList)
	reskinAuctionButton(ItemList.RefreshFrame.RefreshButton)
	F.CreateBDFrame(ItemList.ScrollFrame, .25)
	F.ReskinScroll(ItemList.ScrollFrame.scrollBar)
	hooksecurefunc(ItemList, "RefreshScrollFrame", reskinListHeader)

	local CommoditiesBuyFrame = AuctionHouseFrame.CommoditiesBuyFrame
	F.ReskinButton(CommoditiesBuyFrame.BackButton)
	local BuyDisplay = CommoditiesBuyFrame.BuyDisplay
	F.StripTextures(BuyDisplay)
	F.ReskinInput(BuyDisplay.QuantityInput.InputBox)
	F.ReskinButton(BuyDisplay.BuyButton)
	reskinItemDisplay(BuyDisplay)
	local ItemList = CommoditiesBuyFrame.ItemList
	F.StripTextures(ItemList)
	F.CreateBDFrame(ItemList, .25)
	reskinAuctionButton(ItemList.RefreshFrame.RefreshButton)
	F.ReskinScroll(ItemList.ScrollFrame.scrollBar)

	local WoWTokenResults = AuctionHouseFrame.WoWTokenResults
	F.StripTextures(WoWTokenResults)
	F.StripTextures(WoWTokenResults.TokenDisplay)
	F.CreateBDFrame(WoWTokenResults.TokenDisplay, .25)
	F.ReskinButton(WoWTokenResults.Buyout)
	F.ReskinScroll(WoWTokenResults.DummyScrollBar)

	reskinSellPanel(AuctionHouseFrame.ItemSellFrame)
	reskinSellPanel(AuctionHouseFrame.CommoditiesSellFrame)
	reskinSellList(AuctionHouseFrame.CommoditiesSellList, true)
	reskinSellList(AuctionHouseFrame.ItemSellList, true)
	reskinSellList(AuctionHouseFrameAuctionsFrame.SummaryList)
	reskinSellList(AuctionHouseFrameAuctionsFrame.AllAuctionsList, true)
	reskinSellList(AuctionHouseFrameAuctionsFrame.BidsList, true)
	reskinSellList(AuctionHouseFrameAuctionsFrame.CommoditiesList, true)
	reskinItemDisplay(AuctionHouseFrameAuctionsFrame)

	F.ReskinTab(AuctionHouseFrameAuctionsFrameAuctionsTab)
	F.ReskinTab(AuctionHouseFrameAuctionsFrameBidsTab)
	F.ReskinInput(AuctionHouseFrameAuctionsFrameGold)
	F.ReskinInput(AuctionHouseFrameAuctionsFrameSilver)
	F.ReskinButton(AuctionHouseFrameAuctionsFrame.CancelAuctionButton)
	F.ReskinButton(AuctionHouseFrameAuctionsFrame.BidFrame.BidButton)
	F.ReskinButton(AuctionHouseFrameAuctionsFrame.BuyoutFrame.BuyoutButton)

	local BuyDialog = AuctionHouseFrame.BuyDialog
	F.ReskinFrame(BuyDialog)
	F.ReskinButton(BuyDialog.BuyNowButton)
	F.ReskinButton(BuyDialog.CancelButton)
end