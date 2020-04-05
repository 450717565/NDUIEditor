local B, C, L, DB = unpack(select(2, ...))

C.themes["Blizzard_BlackMarketUI"] = function()
	B.ReskinFrame(BlackMarketFrame)
	B.StripTextures(BlackMarketFrame.MoneyFrameBorder)

	B.ReskinButton(BlackMarketFrame.BidButton)
	B.ReskinInput(BlackMarketBidPriceGold)
	B.ReskinScroll(BlackMarketScrollFrameScrollBar)

	local HotDeal = BlackMarketFrame.HotDeal
	B.StripTextures(HotDeal)
	B.CreateBDFrame(HotDeal, 0)
	local icbg = B.ReskinIcon(HotDeal.Item.IconTexture)
	B.ReskinBorder(HotDeal.Item.IconBorder, icbg)

	local headers = {"ColumnName", "ColumnLevel", "ColumnType", "ColumnDuration", "ColumnHighBidder", "ColumnCurrentBid"}
	for _, header in pairs(headers) do
		local header = BlackMarketFrame[header]
		B.StripTextures(header)

		local bg = B.CreateBDFrame(header, 0)
		bg:SetPoint("TOPLEFT", 2, -2)
		bg:SetPoint("BOTTOMRIGHT", -2, -3)
	end

	hooksecurefunc("BlackMarketScrollFrame_Update", function()
		local buttons = BlackMarketScrollFrame.buttons
		for i = 1, #buttons do
			local bu = buttons[i]
			if not bu.styled then
				B.StripTextures(bu)
				B.CleanTextures(bu.Item)
				bu.Item.IconBorder:SetAlpha(0)

				local icbg = B.ReskinIcon(bu.Item.IconTexture)
				B.ReskinHighlight(bu.Item, icbg)

				local bubg = B.CreateBDFrame(bu, 0)
				bubg:SetPoint("TOPLEFT", icbg, "TOPRIGHT", 2, 0)
				bubg:SetPoint("BOTTOMRIGHT", 0, 4+C.mult)

				B.ReskinHighlight(bu, bubg, true)
				B.ReskinHighlight(bu.Selection, bubg, true)

				bu.styled = true
			end

			if bu:IsShown() and bu.itemLink then
				local _, _, quality = GetItemInfo(bu.itemLink)
				local r, g, b = GetItemQualityColor(quality or 1)
				bu.Name:SetTextColor(r, g, b)
			end
		end
	end)

	hooksecurefunc("BlackMarketFrame_UpdateHotItem", function(self)
		local hotDeal = self.HotDeal
		if hotDeal:IsShown() and hotDeal.itemLink then
			local _, _, quality = GetItemInfo(hotDeal.itemLink)
			local r, g, b = GetItemQualityColor(quality or 1)
			hotDeal.Name:SetTextColor(r, g, b)
		end
	end)
end