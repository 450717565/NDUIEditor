local F, C = unpack(select(2, ...))

C.themes["Blizzard_BlackMarketUI"] = function()
	F.ReskinFrame(BlackMarketFrame)
	F.StripTextures(BlackMarketFrame.MoneyFrameBorder)

	F.ReskinButton(BlackMarketFrame.BidButton)
	F.ReskinInput(BlackMarketBidPriceGold)
	F.ReskinScroll(BlackMarketScrollFrameScrollBar)

	local HotDeal = BlackMarketFrame.HotDeal
	F.StripTextures(HotDeal)
	F.CreateBDFrame(HotDeal, 0)
	F.ReskinIcon(HotDeal.Item.IconTexture)

	local headers = {"ColumnName", "ColumnLevel", "ColumnType", "ColumnDuration", "ColumnHighBidder", "ColumnCurrentBid"}
	for _, header in next, headers do
		local header = BlackMarketFrame[header]
		F.StripTextures(header)

		local bg = F.CreateBDFrame(header, 0)
		bg:SetPoint("TOPLEFT", 2, -2)
		bg:SetPoint("BOTTOMRIGHT", -1, -3)
	end

	hooksecurefunc("BlackMarketScrollFrame_Update", function()
		local buttons = BlackMarketScrollFrame.buttons
		for i = 1, #buttons do
			local bu = buttons[i]
			if not bu.styled then
				F.StripTextures(bu)

				bu.Item:SetNormalTexture("")
				bu.Item:SetPushedTexture("")
				bu.Item.IconBorder:SetAlpha(0)

				local icbg = F.ReskinIcon(bu.Item.IconTexture)
				F.ReskinTexture(bu.Item, icbg, false)

				local bubg = F.CreateBDFrame(bu, 0)
				bubg:SetPoint("TOPLEFT", icbg, "TOPRIGHT", 2, 0)
				bubg:SetPoint("BOTTOMRIGHT", 0, 3)

				F.ReskinTexture(bu, bubg, false)
				F.ReskinTexture(bu.Selection, bubg, true)

				bu.styled = true
			end

			if bu:IsShown() and bu.itemLink then
				local _, _, quality = GetItemInfo(bu.itemLink)
				local color = BAG_ITEM_QUALITY_COLORS[quality or 1]
				bu.Name:SetTextColor(color.r, color.g, color.b)
			end
		end
	end)

	hooksecurefunc("BlackMarketFrame_UpdateHotItem", function(self)
		local hotDeal = self.HotDeal
		if hotDeal:IsShown() and hotDeal.itemLink then
			local _, _, quality = GetItemInfo(hotDeal.itemLink)
			local color = BAG_ITEM_QUALITY_COLORS[quality or 1]
			hotDeal.Name:SetTextColor(color.r, color.g, color.b)
		end
		F.ReskinBorder(hotDeal.Item.IconBorder, hotDeal.Item)
	end)
end