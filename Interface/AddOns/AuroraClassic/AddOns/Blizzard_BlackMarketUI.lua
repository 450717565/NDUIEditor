local F, C = unpack(select(2, ...))

C.themes["Blizzard_BlackMarketUI"] = function()
	local r, g, b = C.r, C.g, C.b

	F.StripTextures(BlackMarketFrame, true)
	F.StripTextures(BlackMarketFrame.Inset, true)
	F.StripTextures(BlackMarketFrame.HotDeal, true)
	F.StripTextures(BlackMarketFrame.MoneyFrameBorder, true)

	F.CreateBDFrame(BlackMarketFrame.HotDeal.Item)
	BlackMarketFrame.HotDeal.Item.IconTexture:SetTexCoord(.08, .92, .08, .92)

	local headers = {"ColumnName", "ColumnLevel", "ColumnType", "ColumnDuration", "ColumnHighBidder", "ColumnCurrentBid"}
	for _, header in pairs(headers) do
		local header = BlackMarketFrame[header]
		F.StripTextures(header, true)

		local bg = F.CreateBDFrame(header, .25)
		bg:SetPoint("TOPLEFT", 2, -2)
		bg:SetPoint("BOTTOMRIGHT", -1, -3)
		bg:SetFrameLevel(header:GetFrameLevel()-1)
	end

	F.CreateBD(BlackMarketFrame)
	F.CreateSD(BlackMarketFrame)
	F.CreateBDFrame(BlackMarketFrame.HotDeal, .25)
	F.Reskin(BlackMarketFrame.BidButton)
	F.ReskinClose(BlackMarketFrame.CloseButton)
	F.ReskinInput(BlackMarketBidPriceGold)
	F.ReskinScroll(BlackMarketScrollFrameScrollBar)

	hooksecurefunc("BlackMarketScrollFrame_Update", function()
		local buttons = BlackMarketScrollFrame.buttons
		for i = 1, #buttons do
			local bu = buttons[i]
			if not bu.reskinned then
				F.StripTextures(bu)

				bu.Item:SetNormalTexture("")
				bu.Item:SetPushedTexture("")
				bu.Item:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)
				bu.Item.IconTexture:SetTexCoord(.08, .92, .08, .92)
				bu.Item.IconBorder:Hide()
				F.CreateBDFrame(bu.Item)

				local bg = F.CreateBDFrame(bu)
				bg:SetPoint("TOPLEFT")
				bg:SetPoint("BOTTOMRIGHT", 0, 5)
				bg:SetFrameLevel(bu:GetFrameLevel()-1)

				bu:SetHighlightTexture(C.media.backdrop)
				local hl = bu:GetHighlightTexture()
				hl:SetVertexColor(r, g, b, .25)
				hl:SetPoint("TOPLEFT", bu.Item, "TOPRIGHT", 2, -1)
				hl:SetPoint("BOTTOMRIGHT", -1, 6)

				bu.Selection:ClearAllPoints()
				bu.Selection:SetPoint("TOPLEFT", 0, -1)
				bu.Selection:SetPoint("BOTTOMRIGHT", -1, 6)
				bu.Selection:SetTexture(C.media.backdrop)
				bu.Selection:SetVertexColor(r, g, b, .1)

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
		hotDeal.Item.IconBorder:Hide()
	end)
end