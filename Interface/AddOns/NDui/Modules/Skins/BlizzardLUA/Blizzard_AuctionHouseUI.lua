local _, ns = ...
local B, C, L, DB = unpack(ns)

local cr, cg, cb = DB.cr, DB.cg, DB.cb

local function ReskinAH_Button(self)
	B.ReskinButton(self)
	self:SetSize(22, 22)
end

local function Reskin_ItemDisplay(self)
	B.StripTextures(self)
	B.CreateBDFrame(self, 0, 3)

	local ItemButton = self.ItemButton
	B.CleanTextures(ItemButton)

	if ItemButton.IconMask then ItemButton.IconMask:Hide() end
	if ItemButton.CircleMask then ItemButton.CircleMask:Hide() end
	if ItemButton.EmptyBackground then ItemButton.EmptyBackground:Hide() end

	local icbg = B.ReskinIcon(ItemButton.Icon)
	B.ReskinBorder(ItemButton.IconBorder, icbg)
	B.ReskinHighlight(ItemButton.Highlight, icbg)
end

local function Reskin_SellFrame(self)
	B.StripTextures(self)

	Reskin_ItemDisplay(self.ItemDisplay)

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

local function Reskin_ListIcon(self)
	if not self.tableBuilder then return end

	for i = 1, 22 do
		local row = self.tableBuilder.rows[i]
		if row then
			row.HighlightTexture:SetColorTexture(1, 1, 1, .25)
			row.SelectedHighlight:SetColorTexture(cr, cg, cb, .25)

			for j = 1, 4 do
				local cell = row.cells and row.cells[j]
				if cell then
					if cell.Icon then
						if not cell.icbg then
							cell.icbg = B.ReskinIcon(cell.Icon)

							if cell.IconBorder then
								cell.IconBorder:SetAlpha(0)
								cell.IconBorder:Hide()
							end
						end

						cell.icbg:SetShown(cell.Icon:IsShown())
					end

					if cell.MoneyDisplay then
						local ip1, ip2, ip3 = cell.MoneyDisplay:GetPoint()
						cell.MoneyDisplay:ClearAllPoints()
						cell.MoneyDisplay:SetPoint(ip1, ip2, ip3, 5, 0)
					end
				end
			end
		end
	end
end

local function Reskin_SummaryIcon(self)
	for i = 1, 23 do
		local child = select(i, self.ScrollFrame.scrollChild:GetChildren())
		if child and child.Icon then
			if not child.icbg then
				child.HighlightTexture:SetColorTexture(1, 1, 1, .25)
				child.icbg = B.ReskinIcon(child.Icon)

				if child.IconBorder then
					child.IconBorder:SetAlpha(0)
					child.IconBorder:Hide()
				end
			end

			child.icbg:SetShown(child.Icon:IsShown())
		end
	end
end

local function Reskin_ListHeader(self)
	local headers = {self.HeaderContainer:GetChildren()}
	local maxHeaders = self.HeaderContainer:GetNumChildren()
	for index, header in pairs(headers) do
		if header then
			if not header.bg then
				header:DisableDrawLayer("BACKGROUND")
				header.bg = B.CreateBDFrame(header)
				B.ReskinHighlight(header, header.bg, true)
			end

			if header.bg then
				header.bg:SetPoint("BOTTOMRIGHT", index < maxHeaders and -6 or 0, -2)
			end
		end
	end

	Reskin_ListIcon(self)
end

local function Reskin_SellList(self, hasHeader)
	B.StripTextures(self)
	B.ReskinScroll(self.ScrollFrame.scrollBar)

	if self.RefreshFrame then
		ReskinAH_Button(self.RefreshFrame.RefreshButton)
	end

	if self.ScrollFrame.ArtOverlay then
		local SelectedHighlight = self.ScrollFrame.ArtOverlay.SelectedHighlight
		SelectedHighlight:SetColorTexture(cr, cg, cb, .25)
	end

	if hasHeader then
		B.CreateBDFrame(self.ScrollFrame)
		hooksecurefunc(self, "RefreshScrollFrame", Reskin_ListHeader)
	else
		hooksecurefunc(self, "RefreshListDisplay", Reskin_SummaryIcon)
	end
end

local function Reskin_ItemList(self, hasHeader)
	B.StripTextures(self)
	B.CreateBDFrame(self.ScrollFrame)
	B.ReskinScroll(self.ScrollFrame.scrollBar)

	if self.RefreshFrame then
		ReskinAH_Button(self.RefreshFrame.RefreshButton)
	end
	if hasHeader then
		hooksecurefunc(self, "RefreshScrollFrame", Reskin_ListHeader)
	end
end

local function Reskin_FilterButton(button)
	button.NormalTexture:SetAlpha(0)
	button.HighlightTexture:SetColorTexture(1, 1, 1, .25)
	button.SelectedTexture:SetColorTexture(cr, cg, cb, .25)
end

local function Update_PriceSelection(self)
	local item = self:GetItem()
	if item then
		local itemID = C_Item.GetItemID(item)
		local itemLink = C_Item.GetItemLink(item)

		if itemID and itemLink then
			local sr_1 = C_AuctionHouse.GetCommoditySearchResultInfo(itemID, 1)
			local sr_2 = C_AuctionHouse.GetCommoditySearchResultInfo(itemID, 2)

			if sr_1 and self:GetUnitPrice() == sr_1.unitPrice then
				local itemSeller = sr_1.owners[1] or ""
				local itemPrice = GetMoneyString(sr_1.unitPrice)

				if sr_1.quantity <= 3 then
					if sr_2 and sr_2.unitPrice > sr_1.unitPrice * 1.1 then
						self:GetCommoditiesSellList():SetSelectedEntry(sr_2)
						print(format("%s %s (|cffff0000%s|r) 疑似钓鱼价，已为您避开。", itemLink, itemPrice, itemSeller))
					end
				end
			end
		end
	end
end

C.LUAThemes["Blizzard_AuctionHouseUI"] = function()
	B.ReskinFrame(AuctionHouseFrame)

	B.StripTextures(AuctionHouseFrame.MoneyFrameInset)
	B.StripTextures(AuctionHouseFrame.MoneyFrameBorder)
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
	ReskinAH_Button(SearchBar.FavoritesSearchButton)
	local FilterButton = SearchBar.FilterButton
	B.ReskinFilter(FilterButton)
	B.ReskinInput(FilterButton.LevelRangeFrame.MinLevel)
	B.ReskinInput(FilterButton.LevelRangeFrame.MaxLevel)
	local ClearFiltersButton = FilterButton.ClearFiltersButton
	B.ReskinClose(ClearFiltersButton)
	ClearFiltersButton:ClearAllPoints()
	ClearFiltersButton:SetPoint("RIGHT", FilterButton, "LEFT", -3, 0)

	local CategoriesList = AuctionHouseFrame.CategoriesList
	B.StripTextures(CategoriesList)
	B.ReskinScroll(CategoriesList.ScrollFrame.ScrollBar)
	hooksecurefunc("FilterButton_SetUp", Reskin_FilterButton)

	local ItemBuyFrame = AuctionHouseFrame.ItemBuyFrame
	B.ReskinButton(ItemBuyFrame.BackButton)
	B.ReskinButton(ItemBuyFrame.BidFrame.BidButton)
	B.ReskinButton(ItemBuyFrame.BuyoutFrame.BuyoutButton)
	B.ReskinInput(AuctionHouseFrameGold)
	B.ReskinInput(AuctionHouseFrameSilver)
	Reskin_ItemDisplay(ItemBuyFrame.ItemDisplay)
	Reskin_ItemList(ItemBuyFrame.ItemList, true)

	local CommoditiesBuyFrame = AuctionHouseFrame.CommoditiesBuyFrame
	B.ReskinButton(CommoditiesBuyFrame.BackButton)
	local BuyDisplay = CommoditiesBuyFrame.BuyDisplay
	B.StripTextures(BuyDisplay)
	B.ReskinInput(BuyDisplay.QuantityInput.InputBox)
	B.ReskinButton(BuyDisplay.BuyButton)
	Reskin_ItemDisplay(BuyDisplay.ItemDisplay)
	Reskin_ItemList(CommoditiesBuyFrame.ItemList)

	local BuyDialog = AuctionHouseFrame.BuyDialog
	B.ReskinFrame(BuyDialog)
	B.ReskinButton(BuyDialog.BuyNowButton)
	B.ReskinButton(BuyDialog.CancelButton)

	local WoWTokenResults = AuctionHouseFrame.WoWTokenResults
	B.StripTextures(WoWTokenResults)
	B.StripTextures(WoWTokenResults.TokenDisplay)
	B.ReskinButton(WoWTokenResults.Buyout)
	B.ReskinScroll(WoWTokenResults.DummyScrollBar)

	local Name = WoWTokenResults.TokenDisplay.Name
	Name:SetJustifyH("Center")
	Name:ClearAllPoints()
	Name:SetPoint("BOTTOM", WoWTokenResults.InvisiblePriceFrame, "TOP", 0, 0)

	local ItemButton = WoWTokenResults.TokenDisplay.ItemButton
	ItemButton:ClearAllPoints()
	ItemButton:SetPoint("CENTER", Name, "TOP", 0, 10)

	local WoWTokenSellFrame = AuctionHouseFrame.WoWTokenSellFrame
	B.StripTextures(WoWTokenSellFrame)
	B.ReskinButton(WoWTokenSellFrame.PostButton)
	B.StripTextures(WoWTokenSellFrame.DummyItemList)
	B.CreateBDFrame(WoWTokenSellFrame.DummyItemList)
	B.ReskinScroll(WoWTokenSellFrame.DummyItemList.DummyScrollBar)
	ReskinAH_Button(WoWTokenSellFrame.DummyRefreshButton)
	Reskin_ItemDisplay(WoWTokenSellFrame.ItemDisplay)

	local GameTimeTutorial = WoWTokenResults.GameTimeTutorial
	B.ReskinFrame(GameTimeTutorial)
	B.ReskinButton(GameTimeTutorial.RightDisplay.StoreButton)
	B.ReskinText(GameTimeTutorial.LeftDisplay.Label, 1, 1, 1)
	B.ReskinText(GameTimeTutorial.LeftDisplay.Tutorial1, 1, .8, 0)
	B.ReskinText(GameTimeTutorial.RightDisplay.Label, 1, 1, 1)
	B.ReskinText(GameTimeTutorial.RightDisplay.Tutorial1, 1, .8, 0)

	local MultisellProgressFrame = AuctionHouseMultisellProgressFrame
	B.ReskinFrame(MultisellProgressFrame)
	local ProgressBar = MultisellProgressFrame.ProgressBar
	B.ReskinStatusBar(ProgressBar)
	local Icon = ProgressBar.Icon
	B.ReskinIcon(Icon)
	Icon:ClearAllPoints()
	Icon:SetPoint("RIGHT", ProgressBar, "LEFT", -3, 0)
	local CancelButton = MultisellProgressFrame.CancelButton
	B.ReskinClose(CancelButton)
	CancelButton:ClearAllPoints()
	CancelButton:SetPoint("LEFT", ProgressBar, "RIGHT", 3, 0)

	Reskin_ItemDisplay(AuctionHouseFrameAuctionsFrame.ItemDisplay)
	Reskin_ItemList(AuctionHouseFrame.BrowseResultsFrame.ItemList, true)
	Reskin_SellList(AuctionHouseFrame.CommoditiesSellList, true)
	Reskin_SellList(AuctionHouseFrame.ItemSellList, true)
	Reskin_SellList(AuctionHouseFrameAuctionsFrame.AllAuctionsList, true)
	Reskin_SellList(AuctionHouseFrameAuctionsFrame.BidsList, true)
	Reskin_SellList(AuctionHouseFrameAuctionsFrame.CommoditiesList, true)
	Reskin_SellList(AuctionHouseFrameAuctionsFrame.ItemList, true)
	Reskin_SellList(AuctionHouseFrameAuctionsFrame.SummaryList)
	Reskin_SellFrame(AuctionHouseFrame.CommoditiesSellFrame)
	Reskin_SellFrame(AuctionHouseFrame.ItemSellFrame)

	B.StripTextures(AuctionHouseFrameAuctionsFrameAuctionsTab)
	B.StripTextures(AuctionHouseFrameAuctionsFrameBidsTab)
	B.ReskinInput(AuctionHouseFrameAuctionsFrameGold)
	B.ReskinInput(AuctionHouseFrameAuctionsFrameSilver)
	B.ReskinButton(AuctionHouseFrameAuctionsFrame.CancelAuctionButton)
	B.ReskinButton(AuctionHouseFrameAuctionsFrame.BidFrame.BidButton)
	B.ReskinButton(AuctionHouseFrameAuctionsFrame.BuyoutFrame.BuyoutButton)

	-- 钓鱼价避开
	hooksecurefunc(AuctionHouseFrame.CommoditiesSellFrame, "UpdatePriceSelection", Update_PriceSelection)
end