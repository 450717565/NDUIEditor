local F, C = unpack(select(2, ...))

C.themes["AuctionLite"] = function()
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