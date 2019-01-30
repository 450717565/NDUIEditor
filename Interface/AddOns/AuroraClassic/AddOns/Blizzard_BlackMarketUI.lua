local F, C = unpack(select(2, ...))

C.themes["Blizzard_BlackMarketUI"] = function()
	F.ReskinFrame(BlackMarketFrame)
	F.StripTextures(BlackMarketFrame.MoneyFrameBorder, true)

	F.ReskinButton(BlackMarketFrame.BidButton)
	F.ReskinInput(BlackMarketBidPriceGold)
	F.ReskinScroll(BlackMarketScrollFrameScrollBar)

	local HotDeal = BlackMarketFrame.HotDeal
	F.StripTextures(HotDeal, true)
	F.CreateBDFrame(HotDeal, 0)
	F.ReskinIcon(HotDeal.Item.IconTexture)

	local headers = {"ColumnName", "ColumnLevel", "ColumnType", "ColumnDuration", "ColumnHighBidder", "ColumnCurrentBid"}
	for _, header in pairs(headers) do
		local header = BlackMarketFrame[header]
		F.StripTextures(header, true)

		local bg = F.CreateBDFrame(header, 0)
		bg:SetPoint("TOPLEFT", 2, -2)
		bg:SetPoint("BOTTOMRIGHT", -1, -3)
	end

	hooksecurefunc("BlackMarketScrollFrame_Update", function()
		local buttons = BlackMarketScrollFrame.buttons
		for i = 1, #buttons do
			local bu = buttons[i]
			if not bu.reskinned then
				F.StripTextures(bu)

				bu.Item:SetNormalTexture("")
				bu.Item:SetPushedTexture("")
				bu.Item.IconBorder:SetAlpha(0)

				local ic = F.ReskinIcon(bu.Item.IconTexture)
				F.ReskinTexture(bu.Item, ic, false)

				local bg = F.CreateBDFrame(bu, 0)
				bg:SetPoint("TOPLEFT", ic, "TOPRIGHT", 2, 0)
				bg:SetPoint("BOTTOMRIGHT", 0, 3)

				F.ReskinTexture(bu, bg, false)
				F.ReskinTexture(bu.Selection, bg, true)

				bu.reskinned = true
			end

			if bu:IsShown() and bu.itemLink then
				local _, _, quality = GetItemInfo(bu.itemLink)
				bu.Name:SetTextColor(GetItemQualityColor(quality))
			end
		end
	end)

	hooksecurefunc("BlackMarketFrame_UpdateHotItem", function(self)
		local hotDeal = self.HotDeal
		if hotDeal:IsShown() and hotDeal.itemLink then
			local _, _, quality = GetItemInfo(hotDeal.itemLink)
			hotDeal.Name:SetTextColor(GetItemQualityColor(quality))
		end
		F.ReskinBorder(hotDeal.Item.IconBorder, hotDeal.Item)
	end)
end