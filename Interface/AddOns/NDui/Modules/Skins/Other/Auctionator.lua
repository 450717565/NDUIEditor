local _, ns = ...
local B, C, L, DB = unpack(ns)
local Skins = B:GetModule("Skins")

local cr, cg, cb = DB.cr, DB.cg, DB.cb

local function Reskin_Buttons(self, buttons)
	for _, key in pairs(buttons) do
		local button = self[key]
		if button then
			B.ReskinButton(button)
		end
	end
end

local function Reskin_ItemDialog(self)
	B.ReskinFrame(self)
	B.ReskinInput(self.SearchContainer.SearchString)
	B.ReskinCheck(self.SearchContainer.IsExact)
	B.ReskinDropDown(self.FilterKeySelector)
	Reskin_Buttons(self, {"Finished", "Cancel", "ResetAllButton"})

	for _, key in pairs({"LevelRange", "ItemLevelRange", "PriceRange", "CraftedLevelRange"}) do
		local minMax = self[key]
		if minMax then
			B.ReskinInput(minMax.MaxBox)
			B.ReskinInput(minMax.MinBox)
		end
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

local function Reskin_ListHeader(self)
	local headers = {self.HeaderContainer:GetChildren()}
	local maxHeaders = self.HeaderContainer:GetNumChildren()
	for index, header in pairs(headers) do
		if header then
			if not header.bg then
				header:DisableDrawLayer("BACKGROUND")
				header.bg = B.CreateBDFrame(header)
				B.ReskinHLTex(header, header.bg, true)
			end

			if header.bg then
				header.bg:SetPoint("BOTTOMRIGHT", index < maxHeaders and -6 or 0, -2)
			end
		end
	end

	local scrollFrame = self.ScrollFrame
	B.ReskinScroll(scrollFrame.scrollBar)
	scrollFrame:ClearAllPoints()
	scrollFrame:SetPoint("TOPLEFT", self.HeaderContainer, "BOTTOMLEFT", -1, -4)
	scrollFrame:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 0, 0)

	local bg = B.CreateBDFrame(scrollFrame)
	bg:ClearAllPoints()
	bg:SetPoint("TOPLEFT", scrollFrame, 16, 1)
	bg:SetPoint("BOTTOMRIGHT", scrollFrame, 0, 0)

	Reskin_ListIcon(self)
end

local function Reskin_SimplePanel(self)
	B.ReskinFrame(self)

	if self.ScrollFrame then
		B.CreateBDFrame(self.ScrollFrame)
		B.ReskinScroll(self.ScrollFrame.ScrollBar)
	end

	if self.CloseDialog then
		B.ReskinClose(self.CloseDialog)
	end
end

local function Reskin_Input(self)
	local bg = B.ReskinInput(self, 24)
	bg:SetPoint("TOPLEFT", -2, 4)
end

local function Reskin_BagItem(button)
	button.Icon:SetInside(nil, 2, 2)

	B.StripTextures(button, 1)
	local icbg = B.ReskinIcon(button.Icon)
	B.ReskinHLTex(button, icbg)
	B.ReskinBorder(button.IconBorder, icbg)

	button.IconBorder:Hide()
	button.IconBorder.Show = B.Dummy
end

local function Reskin_BagList(self)
	B.StripTextures(self.SectionTitle)
	B.ReskinButton(self.SectionTitle)

	for _, button in pairs(self.buttons) do
		if button and not button.styled then
			Reskin_BagItem(button)

			button.styled = true
		end
	end

	local origGet = self.buttonPool.Get
	self.buttonPool.Get = function(self)
		local button = origGet(self)
		if not button.styled then
			Reskin_BagItem(button)

			button.styled = true
		end

		return button
	end
end

function Skins:Auctionator()
	if not IsAddOnLoaded("Auctionator") then return end

	local styled
	hooksecurefunc(_G.Auctionator.Events, "OnAuctionHouseShow", function()
		if styled then return end

		for _, tab in pairs(_G.AuctionatorAHTabsContainer.Tabs) do
			B.ReskinTab(tab)
		end

		local SplashScreen = _G.AuctionatorSplashScreen
		if SplashScreen then
			B.ReskinFrame(SplashScreen)
			B.ReskinScroll(SplashScreen.ScrollFrame.ScrollBar)
			B.ReskinCheck(SplashScreen.HideCheckbox.CheckBox)
		end

		local ShoppingList = _G.AuctionatorShoppingListFrame
		if ShoppingList then
			B.ReskinDropDown(ShoppingList.ListDropdown)
			Reskin_ListHeader(ShoppingList.ResultsListing)
			Reskin_Buttons(ShoppingList, {"CreateList", "DeleteList", "Rename", "Import", "Export", "AddItem", "ManualSearch", "ExportCSV"})
			Reskin_ItemDialog(ShoppingList.addItemDialog)
			Reskin_ItemDialog(ShoppingList.editItemDialog)
			Reskin_SimplePanel(ShoppingList.exportDialog)
			Reskin_Buttons(ShoppingList.exportDialog, {"Export", "SelectAll", "UnselectAll"})

			for _, cb in pairs(ShoppingList.exportDialog.checkBoxPool) do
				B.ReskinCheck(cb.CheckBox)
			end
			hooksecurefunc(ShoppingList.exportDialog, "AddToPool", function(self)
				B.ReskinCheck(self.checkBoxPool[#self.checkBoxPool].CheckBox)
			end)

			B.StripTextures(ShoppingList.ShoppingResultsInset)
			B.ReskinButton(ShoppingList.importDialog.Import)
			Reskin_SimplePanel(ShoppingList.importDialog)

			B.StripTextures(ShoppingList.ScrollList)
			B.CreateBDFrame(ShoppingList.ScrollList.ScrollFrame)
			B.ReskinScroll(ShoppingList.ScrollList.ScrollFrame.scrollBar)

			B.ReskinButton(ShoppingList.exportCSVDialog.Close)
			B.ReskinButton(ShoppingList.itemHistoryDialog.Close)
			Reskin_SimplePanel(ShoppingList.exportCSVDialog)
			Reskin_SimplePanel(ShoppingList.itemHistoryDialog)
			Reskin_ListHeader(ShoppingList.itemHistoryDialog.ResultsListing)
		end

		local SellingFrame = _G.AuctionatorSellingFrame
		if SellingFrame then
			local itemFrame = SellingFrame.SaleItemFrame
			Reskin_BagItem(itemFrame.Icon)
			Reskin_Input(itemFrame.Quantity.InputBox)
			Reskin_Input(itemFrame.Price.MoneyInput.GoldBox)
			Reskin_Input(itemFrame.Price.MoneyInput.SilverBox)
			Reskin_Buttons(itemFrame, {"PostButton", "SkipButton", "MaxButton"})

			for _, bu in pairs(itemFrame.Duration.radioButtons) do
				B.ReskinRadio(bu.RadioButton)
			end

			for i = 1, itemFrame:GetNumChildren() do
				local child = select(i, itemFrame:GetChildren())
				if child.iconAtlas and child.iconAtlas == "UI-RefreshButton" then
					B.ReskinButton(child)
					child:SetSize(22, 22)
				end
			end

			B.StripTextures(SellingFrame.BagInset)
			B.StripTextures(SellingFrame.BagListing.ScrollFrame.Background)
			B.ReskinScroll(SellingFrame.BagListing.ScrollFrame.ScrollBar)

			for _, key in pairs({"Favourites", "WeaponItems", "ArmorItems", "ContainerItems", "GemItems", "EnhancementItems", "ConsumableItems", "GlyphItems", "TradeGoodItems", "RecipeItems", "BattlePetItems", "QuestItems", "MiscItems"}) do
				local items = SellingFrame.BagListing.ScrollFrame.ItemListingFrame[key]
				if items then
					Reskin_BagList(items)
				end
			end

			B.StripTextures(SellingFrame.CurrentItemInset)
			B.StripTextures(SellingFrame.HistoricalPriceInset)

			Reskin_ListHeader(SellingFrame.CurrentItemListing)
			Reskin_ListHeader(SellingFrame.HistoricalPriceListing)
			Reskin_ListHeader(SellingFrame.PostingHistoryListing)

			for _, tab in pairs(SellingFrame.HistoryTabsContainer.Tabs) do
				B.ReskinTab(tab)
			end
		end

		local CancellingFrame = _G.AuctionatorCancellingFrame
		if CancellingFrame then
			B.StripTextures(CancellingFrame.HistoricalPriceInset)
			B.ReskinInput(CancellingFrame.SearchFilter)

			Reskin_ListHeader(CancellingFrame.ResultsListing)

			for i = 1, CancellingFrame:GetNumChildren() do
				local child = select(i, CancellingFrame:GetChildren())
				if child.iconAtlas and child.iconAtlas == "UI-RefreshButton" then
					B.ReskinButton(child)
					child:SetSize(22, 22)
				elseif child.StartScanButton and child.CancelNextButton then
					B.ReskinButton(child.StartScanButton)
					B.ReskinButton(child.CancelNextButton)
				end
			end
		end

		local ConfigFrame = _G.AuctionatorConfigFrame
		if ConfigFrame then
			B.StripTextures(ConfigFrame)
			B.CreateBDFrame(ConfigFrame)
			Reskin_Buttons(ConfigFrame, {"ScanButton", "OptionsButton"})

			for _, key in pairs({"DiscordLink", "BugReportLink", "TechnicalRoadmap"}) do
				local eb = ConfigFrame[key]
				if eb then
					B.ReskinInput(eb.InputBox)
				end
			end
		end

		styled = true
	end)
end