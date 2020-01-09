local F, C = unpack(select(2, ...))

C.themes["Blizzard_AuctionUI"] = function()
	F.ReskinFrame(AuctionFrame)

	F.ReskinFrame(AuctionProgressFrame)
	F.ReskinStatusBar(AuctionProgressBar)
	F.ReskinClose(AuctionProgressFrameCancelButton, "LEFT", AuctionProgressBar, "RIGHT", 4, 0)
	F.ReskinDropDown(PriceDropDown)
	F.ReskinDropDown(DurationDropDown)
	F.ReskinArrow(BrowsePrevPageButton, "left")
	F.ReskinArrow(BrowseNextPageButton, "right")

	BrowsePrevPageButton:ClearAllPoints()
	BrowsePrevPageButton:SetPoint("TOPLEFT", BrowseSearchButton, "BOTTOMLEFT", 0, -5)
	BrowseNextPageButton:ClearAllPoints()
	BrowseNextPageButton:SetPoint("TOPRIGHT", BrowseResetButton, "BOTTOMRIGHT", 0, -5)

	AuctionsStackSizeMaxButton:SetSize(100, 20)
	AuctionsStackSizeMaxButton:ClearAllPoints()
	AuctionsStackSizeMaxButton:SetPoint("LEFT", AuctionsStackSizeEntry, "RIGHT", 1, 0)
	AuctionsNumStacksMaxButton:SetSize(100, 20)
	AuctionsNumStacksMaxButton:ClearAllPoints()
	AuctionsNumStacksMaxButton:SetPoint("LEFT", AuctionsNumStacksEntry, "RIGHT", 1, 0)

	BrowseBuyoutButton:ClearAllPoints()
	BrowseBuyoutButton:SetPoint("RIGHT", BrowseCloseButton, "LEFT", -1, 0)
	BrowseBidButton:ClearAllPoints()
	BrowseBidButton:SetPoint("RIGHT", BrowseBuyoutButton, "LEFT", -1, 0)
	BidBuyoutButton:ClearAllPoints()
	BidBuyoutButton:SetPoint("RIGHT", BidCloseButton, "LEFT", -1, 0)
	BidBidButton:ClearAllPoints()
	BidBidButton:SetPoint("RIGHT", BidBuyoutButton, "LEFT", -1, 0)
	AuctionsCancelAuctionButton:ClearAllPoints()
	AuctionsCancelAuctionButton:SetPoint("RIGHT", AuctionsCloseButton, "LEFT", -1, 0)

	BrowseBidPriceSilver:ClearAllPoints()
	BrowseBidPriceSilver:SetPoint("LEFT", BrowseBidPriceGold, "RIGHT", 1, 0)
	BrowseBidPriceCopper:ClearAllPoints()
	BrowseBidPriceCopper:SetPoint("LEFT", BrowseBidPriceSilver, "RIGHT", 1, 0)
	BidBidPriceSilver:ClearAllPoints()
	BidBidPriceSilver:SetPoint("LEFT", BidBidPriceGold, "RIGHT", 1, 0)
	BidBidPriceCopper:ClearAllPoints()
	BidBidPriceCopper:SetPoint("LEFT", BidBidPriceSilver, "RIGHT", 1, 0)
	StartPriceSilver:ClearAllPoints()
	StartPriceSilver:SetPoint("LEFT", StartPriceGold, "RIGHT", 1, 0)
	StartPriceCopper:ClearAllPoints()
	StartPriceCopper:SetPoint("LEFT", StartPriceSilver, "RIGHT", 1, 0)
	BuyoutPriceSilver:ClearAllPoints()
	BuyoutPriceSilver:SetPoint("LEFT", BuyoutPriceGold, "RIGHT", 1, 0)
	BuyoutPriceCopper:ClearAllPoints()
	BuyoutPriceCopper:SetPoint("LEFT", BuyoutPriceSilver, "RIGHT", 1, 0)

	local p1, p2, p3, x, y = BrowseMinLevel:GetPoint()
	BrowseMinLevel:SetPoint(p1, p2, p3, x, y+2)

	local itemButton = AuctionsItemButton
	itemButton:SetSize(30, 30)
	F.StripTextures(itemButton)
	F.CreateBDFrame(itemButton, 0)
	F.ReskinBorder(itemButton.IconBorder, itemButton)

	local sorts = {BrowseQualitySort, BrowseLevelSort, BrowseDurationSort, BrowseHighBidderSort, BrowseCurrentBidSort, BidQualitySort, BidLevelSort, BidDurationSort, BidBuyoutSort, BidStatusSort, BidBidSort, AuctionsQualitySort, AuctionsDurationSort, AuctionsHighBidderSort, AuctionsBidSort}
	for _, sort in pairs(sorts) do
		F.StripTextures(sort)
		F.ReskinTexture(sort, sort, true)
	end

	local buttons = {BrowseBidButton, BrowseBuyoutButton, BrowseCloseButton, BrowseSearchButton, BrowseResetButton, BidBidButton, BidBuyoutButton, BidCloseButton, AuctionsCloseButton, AuctionsCancelAuctionButton, AuctionsCreateAuctionButton, AuctionsNumStacksMaxButton, AuctionsStackSizeMaxButton}
	for _, button in pairs(buttons) do
		F.StripTextures(button)
		F.ReskinButton(button)
	end

	local inputs = {BrowseName, BrowseMinLevel, BrowseMaxLevel, BrowseBidPriceGold, BrowseBidPriceSilver, BrowseBidPriceCopper, BidBidPriceGold, BidBidPriceSilver, BidBidPriceCopper, StartPriceGold, StartPriceSilver, StartPriceCopper, BuyoutPriceGold, BuyoutPriceSilver, BuyoutPriceCopper, AuctionsStackSizeEntry, AuctionsNumStacksEntry}
	for _, input in pairs(inputs) do
		F.ReskinInput(input)
	end

	local checks = {ExactMatchCheckButton, IsUsableCheckButton, ShowOnPlayerCheckButton}
	for _, check in pairs(checks) do
		F.ReskinCheck(check)
	end

	local scrolls = {BrowseScrollFrameScrollBar, AuctionsScrollFrameScrollBar, BrowseFilterScrollFrameScrollBar, BidScrollFrameScrollBar}
	for _, scroll in pairs(scrolls) do
		F.ReskinScroll(scroll)
	end

	local function reskinAuctionButtons(button, i)
		local bu = _G[button..i]
		local it = _G[button..i.."Item"]
		local ic = _G[button..i.."ItemIconTexture"]

		if bu and it then
			F.StripTextures(bu)
			F.StripTextures(it)
			it.IconBorder:SetAlpha(0)

			local icbg = F.ReskinIcon(ic)
			F.ReskinTexture(it, icbg)

			local bubg = F.CreateBDFrame(bu, 0)
			bubg:SetPoint("TOPLEFT", icbg, "TOPRIGHT", 2, 0)
			bubg:SetPoint("BOTTOMRIGHT", 0, 3)
			F.ReskinTexture(bu, bubg, true)
		end
	end

	for i = 1, NUM_BROWSE_TO_DISPLAY do
		reskinAuctionButtons("BrowseButton", i)
	end

	for i = 1, NUM_BIDS_TO_DISPLAY do
		reskinAuctionButtons("BidButton", i)
	end

	for i = 1, NUM_AUCTIONS_TO_DISPLAY do
		reskinAuctionButtons("AuctionsButton", i)
	end

	hooksecurefunc("FilterButton_SetUp", function(button)
		F.CleanTextures(button)
		F.ReskinTexture(button, button, true)
	end)

	do
		F.StripTextures(BrowseDropDown)
		F.ReskinButton(BrowseDropDownButton, true)
		F.SetupArrowTex(BrowseDropDownButton, "down")

		local a1, p, a2, x, y = BrowseDropDownButton:GetPoint()
		BrowseDropDownButton:SetPoint(a1, p, a2, x, y-4)
		BrowseDropDownButton:SetSize(16, 16)

		local bg = F.CreateBDFrame(BrowseDropDown, 0)
		bg:SetPoint("TOPLEFT", BrowseDropDown, "TOPLEFT", 16, -5)
		bg:SetPoint("BOTTOMRIGHT", BrowseDropDownButton, "BOTTOMLEFT", -1, 0)

		local text = BrowseDropDownText
		text:SetJustifyH("CENTER")
		text:ClearAllPoints()
		text:SetPoint("CENTER", bg, 1, 0)

		BrowseDropDownButton:HookScript("OnEnter", F.TexOnEnter)
		BrowseDropDownButton:HookScript("OnLeave", F.TexOnLeave)
	end

	AuctionFrame:HookScript("OnShow", function()
		local index = 1
		while true do
			local tab = _G["AuctionFrameTab"..index]
			if not tab then return end

			if not tab.styled then
				F.ReskinTab(tab)

				tab.styled = true
			end

			index = index + 1
		end
	end)

	AuctionFrameTab1:ClearAllPoints()
	AuctionFrameTab1:SetPoint("TOPLEFT", AuctionFrame, "BOTTOMLEFT", 15, 1)

	-- Tutorial
	do
		local Tutorial = WowTokenGameTimeTutorial
		F.ReskinFrame(Tutorial)
		F.ReskinButton(StoreButton)

		local left = Tutorial.LeftDisplay
		left.Label:SetTextColor(1, .8, 0)
		left.Tutorial1:SetTextColor(1, 1, 1)

		local right = Tutorial.RightDisplay
		right.Label:SetTextColor(1, .8, 0)
		right.Tutorial1:SetTextColor(1, 1, 1)
	end

	-- Token
	do
		local Buyout = BrowseWowTokenResults.Buyout
		F.ReskinButton(Buyout)

		local Token = BrowseWowTokenResults.Token
		F.StripTextures(Token)
		F.ReskinIcon(Token.Icon)
		F.ReskinBorder(Token.IconBorder, Token.Icon)
	end
end