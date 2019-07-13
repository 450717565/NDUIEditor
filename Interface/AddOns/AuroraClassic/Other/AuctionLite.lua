local F, C = unpack(select(2, ...))

C.login["AuctionLite"] = function()
	F.ReskinArrow(BuyAdvancedButton, "down")
	F.ReskinArrow(SellRememberButton, "down")
	F.ReskinArrow(BuySummaryButton, "left")
	F.StripTextures(SellRememberButton)

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

	local inputs = {BuyName, BuyQuantity, SellStacks, SellSize, SellBidPriceGold, SellBidPriceSilver, SellBidPriceCopper, SellBuyoutPriceGold, SellBuyoutPriceSilver, SellBuyoutPriceCopper}
	for _, input in pairs(inputs) do
		F.ReskinInput(input)
	end

	local buttons = {BuySearchButton, BuyScanButton, BuyBidButton, BuyBuyoutButton, BuyCancelAuctionButton, BuyCancelSearchButton, SellCreateAuctionButton, SellStacksMaxButton, SellSizeMaxButton}
	for _, button in pairs(buttons) do
		F.ReskinButton(button)
	end

	local radios = {SellShortAuctionButton, SellMediumAuctionButton, SellLongAuctionButton, SellPerItemButton, SellPerStackButton}
	for _, radio in pairs(radios) do
		radio:SetSize(20, 20)
		F.ReskinRadio(radio)
	end

	local textures = {SellItemNameButton, SellBuyoutEachButton, SellBuyoutAllButton}
	for _, texture in pairs(textures) do
		F.ReskinTexture(button, button, true)
	end

	local scrolls = {BuyScrollFrameScrollBar, SellScrollFrameScrollBar}
	for _, scroll in pairs(scrolls) do
		F.ReskinScroll(scroll)
	end
end