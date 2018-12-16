local F, C = unpack(select(2, ...))

C.themes["Blizzard_AuctionUI"] = function()
	local r, g, b = C.r, C.g, C.b

	local frames = {AuctionFrame, BrowseScrollFrame, BrowseFilterScrollFrame, BidScrollFrame, AuctionsScrollFrame, AuctionProgressFrame}
	for _, frame in next, frames do
		F.StripTextures(frame, true)
	end

	F.SetBD(AuctionFrame, 10, -10, 0, 10)
	F.CreateBD(AuctionProgressFrame)
	F.CreateSD(AuctionProgressFrame)
	F.ReskinStatusBar(AuctionProgressBar, true, true)
	F.ReskinClose(AuctionProgressFrameCancelButton, "LEFT", AuctionProgressBar, "RIGHT", 4, 0)

	AuctionProgressBar.Text:ClearAllPoints()
	AuctionProgressBar.Text:SetPoint("CENTER")

	hooksecurefunc("FilterButton_SetUp", function(button)
		button:SetNormalTexture("")
	end)

	do
		local last = 1
		AuctionFrame:HookScript("OnShow", function()
			local tab = _G["AuctionFrameTab"..last]

			while tab do
				F.ReskinTab(tab)
				last = last + 1
				tab = _G["AuctionFrameTab"..last]
			end
		end)
	end

	local buttons = {BrowseBidButton, BrowseBuyoutButton, BrowseCloseButton, BrowseSearchButton, BrowseResetButton, BidBidButton, BidBuyoutButton, BidCloseButton, AuctionsCloseButton, AuctionsCancelAuctionButton, AuctionsCreateAuctionButton, AuctionsNumStacksMaxButton, AuctionsStackSizeMaxButton}
	for _, button in next, buttons do
		F.StripTextures(button, true)
		F.Reskin(button)
	end
	AuctionsStackSizeMaxButton:SetSize(100, 20)
	AuctionsStackSizeMaxButton:SetPoint("LEFT", AuctionsStackSizeEntry, "RIGHT", 2, 0)
	AuctionsNumStacksMaxButton:SetSize(100, 20)
	AuctionsNumStacksMaxButton:SetPoint("LEFT", AuctionsNumStacksEntry, "RIGHT", 2, 0)

	BrowseBuyoutButton:SetPoint("RIGHT", BrowseCloseButton, "LEFT", -2, 0)
	BrowseBidButton:SetPoint("RIGHT", BrowseBuyoutButton, "LEFT", -2, 0)
	BidBuyoutButton:SetPoint("RIGHT", BidCloseButton, "LEFT", -2, 0)
	BidBidButton:SetPoint("RIGHT", BidBuyoutButton, "LEFT", -2, 0)
	AuctionsCancelAuctionButton:SetPoint("RIGHT", AuctionsCloseButton, "LEFT", -2, 0)

	BrowseBidPriceSilver:SetPoint("LEFT", BrowseBidPriceGold, "RIGHT", 1, 0)
	BrowseBidPriceCopper:SetPoint("LEFT", BrowseBidPriceSilver, "RIGHT", 1, 0)
	BidBidPriceSilver:SetPoint("LEFT", BidBidPriceGold, "RIGHT", 1, 0)
	BidBidPriceCopper:SetPoint("LEFT", BidBidPriceSilver, "RIGHT", 1, 0)
	StartPriceSilver:SetPoint("LEFT", StartPriceGold, "RIGHT", 1, 0)
	StartPriceCopper:SetPoint("LEFT", StartPriceSilver, "RIGHT", 1, 0)
	BuyoutPriceSilver:SetPoint("LEFT", BuyoutPriceGold, "RIGHT", 1, 0)
	BuyoutPriceCopper:SetPoint("LEFT", BuyoutPriceSilver, "RIGHT", 1, 0)

	local function reskinAuctionButtons(button, i)
		local bu = _G[button..i]
		local it = _G[button..i.."Item"]
		local ic = _G[button..i.."ItemIconTexture"]

		if bu and it then
			F.StripTextures(bu)
			F.StripTextures(it)

			local bg = F.CreateBDFrame(bu, .25)
			bg:SetPoint("TOPLEFT")
			bg:SetPoint("BOTTOMRIGHT", 0, 5)

			bu:SetHighlightTexture(C.media.backdrop)
			local hl = bu:GetHighlightTexture()
			hl:SetVertexColor(r, g, b, .25)
			hl:SetPoint("TOPLEFT", it, "TOPRIGHT", 2, -1)
			hl:SetPoint("BOTTOMRIGHT", -1, 6)

			it:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)
			it.IconBorder:SetAlpha(0)
			F.ReskinIcon(ic, true)
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

	AuctionsItemButton:SetSize(30, 30)
	F.StripTextures(AuctionsItemButton, true)
	F.CreateBDFrame(AuctionsItemButton, .25)

	local auctionhandler = CreateFrame("Frame")
	auctionhandler:RegisterEvent("NEW_AUCTION_UPDATE")
	auctionhandler:SetScript("OnEvent", function()
		local AuctionsItemButtonIconTexture = AuctionsItemButton:GetNormalTexture()
		if AuctionsItemButtonIconTexture then
			AuctionsItemButtonIconTexture:SetTexCoord(.08, .92, .08, .92)
		end
	end)

	F.ReskinClose(AuctionFrameCloseButton, "TOPRIGHT", AuctionFrame, "TOPRIGHT", -4, -14)
	F.ReskinScroll(BrowseScrollFrameScrollBar)
	F.ReskinScroll(AuctionsScrollFrameScrollBar)
	F.ReskinScroll(BrowseFilterScrollFrameScrollBar)
	F.ReskinDropDown(PriceDropDown)
	F.ReskinDropDown(DurationDropDown)
	F.ReskinInput(BrowseName)
	F.ReskinArrow(BrowsePrevPageButton, "left")
	F.ReskinArrow(BrowseNextPageButton, "right")
	F.ReskinCheck(ExactMatchCheckButton)
	F.ReskinCheck(IsUsableCheckButton)
	F.ReskinCheck(ShowOnPlayerCheckButton)

	BrowsePrevPageButton:SetPoint("TOPLEFT", BrowseSearchButton, "BOTTOMLEFT", 0, -5)
	BrowseNextPageButton:SetPoint("TOPRIGHT", BrowseResetButton, "BOTTOMRIGHT", 0, -5)

	F.StripTextures(BrowseDropDown, true)
	F.Reskin(BrowseDropDownButton, true)

	local a1, p, a2, x, y = BrowseDropDownButton:GetPoint()
	BrowseDropDownButton:SetPoint(a1, p, a2, x, y-4)
	BrowseDropDownButton:SetSize(16, 16)

	local tex = BrowseDropDownButton:CreateTexture(nil, "OVERLAY")
	tex:SetTexture(C.media.arrowDown)
	tex:SetSize(8, 8)
	tex:SetPoint("CENTER")
	tex:SetVertexColor(1, 1, 1)
	BrowseDropDownButton.bgTex = tex

	local bg = F.CreateBDFrame(BrowseDropDown, 0)
	bg:SetPoint("TOPLEFT", 16, -5)
	bg:SetPoint("BOTTOMRIGHT", 109, 11)
	F.CreateGradient(bg)

	local colourArrow = F.colourArrow
	local clearArrow = F.clearArrow

	BrowseDropDownButton:HookScript("OnEnter", colourArrow)
	BrowseDropDownButton:HookScript("OnLeave", clearArrow)

	local inputs = {BrowseMinLevel, BrowseMaxLevel, BrowseBidPriceGold, BrowseBidPriceSilver, BrowseBidPriceCopper, BidBidPriceGold, BidBidPriceSilver, BidBidPriceCopper, StartPriceGold, StartPriceSilver, StartPriceCopper, BuyoutPriceGold, BuyoutPriceSilver, BuyoutPriceCopper, AuctionsStackSizeEntry, AuctionsNumStacksEntry}
	for _, input in next, inputs do
		F.ReskinInput(input)
	end

	local p1, p2, p3, x, y = BrowseMinLevel:GetPoint()
	BrowseMinLevel:SetPoint(p1, p2, p3, x, y+2)

	-- Tutorial
	F.ReskinPortraitFrame(WowTokenGameTimeTutorial, true)
	F.Reskin(StoreButton)

	local left = WowTokenGameTimeTutorial.LeftDisplay
	left.Label:SetTextColor(1, .8, 0)
	left.Tutorial1:SetTextColor(1, .5, 0)

	local right = WowTokenGameTimeTutorial.RightDisplay
	right.Label:SetTextColor(1, .8, 0)
	right.Tutorial1:SetTextColor(1, .5, 0)

	-- Token
	do
		local Buyout = BrowseWowTokenResults.Buyout
		local Token = BrowseWowTokenResults.Token
		local icon = Token.Icon
		local iconBorder = Token.IconBorder

		F.StripTextures(Token)
		F.Reskin(Buyout)

		local bg = F.ReskinIcon(icon, true)
		bg:SetBackdropBorderColor(0, .8, 1)
		bg.Shadow:SetBackdropBorderColor(0, .8, 1)
	end
end