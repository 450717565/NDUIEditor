local _, ns = ...
local B, C, L, DB = unpack(ns)

local function Reskin_BlackMarketScrollFrame()
	local buttons = BlackMarketScrollFrame.buttons
	for i = 1, #buttons do
		local button = buttons[i]
		if button and not button.styled then
			B.StripTextures(button)

			local item = button.Item
			B.CleanTextures(item)
			item.IconBorder:SetAlpha(0)

			local icbg = B.ReskinIcon(item.IconTexture)
			B.ReskinHLTex(item, icbg)

			local bubg = B.CreateBGFrame(button, 2, 0, 0, 0, icbg)
			B.ReskinHLTex(button, bubg, true)
			B.ReskinHLTex(button.Selection, bubg, true)

			button.icbg = icbg
			button.bubg = bubg

			button.styled = true
		end

		if button:IsShown() and button.itemLink then
			local _, _, quality = GetItemInfo(button.itemLink)
			local r, g, b = B.GetQualityColor(quality)
			button.Name:SetTextColor(r, g, b)
			button.icbg:SetBackdropBorderColor(r, g, b)
			button.bubg:SetBackdropBorderColor(r, g, b)
		else
			button.icbg:SetBackdropBorderColor(0, 0, 0)
			button.bubg:SetBackdropBorderColor(0, 0, 0)
		end
	end
end

local function Reskin_BlackMarketFrame(self)
	local hotDeal = self.HotDeal
	if hotDeal:IsShown() and hotDeal.itemLink then
		local _, _, quality = GetItemInfo(hotDeal.itemLink)
		local r, g, b = B.GetQualityColor(quality)
		hotDeal.Name:SetTextColor(r, g, b)
	end
end

C.LUAThemes["Blizzard_BlackMarketUI"] = function()
	B.ReskinFrame(BlackMarketFrame)

	B.ReskinButton(BlackMarketFrame.BidButton)
	B.ReskinInput(BlackMarketBidPriceGold)
	B.ReskinScroll(BlackMarketScrollFrameScrollBar)

	local MoneyFrameBorder = BlackMarketFrame.MoneyFrameBorder
	B.StripTextures(MoneyFrameBorder)

	local HotDeal = BlackMarketFrame.HotDeal
	B.StripTextures(HotDeal)
	B.CreateBDFrame(HotDeal)
	local icbg = B.ReskinIcon(HotDeal.Item.IconTexture)
	B.ReskinBorder(HotDeal.Item.IconBorder, icbg)

	local headers = {
		"ColumnName",
		"ColumnLevel",
		"ColumnType",
		"ColumnDuration",
		"ColumnHighBidder",
		"ColumnCurrentBid",
	}
	for _, header in pairs(headers) do
		local header = BlackMarketFrame[header]
		B.StripTextures(header)
		B.CreateBGFrame(header, 2, -2, -2, -5)
	end

	hooksecurefunc("BlackMarketScrollFrame_Update", Reskin_BlackMarketScrollFrame)
	hooksecurefunc("BlackMarketFrame_UpdateHotItem", Reskin_BlackMarketFrame)
end