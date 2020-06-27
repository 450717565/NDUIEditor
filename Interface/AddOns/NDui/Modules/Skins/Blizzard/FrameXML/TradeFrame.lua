local B, C, L, DB = unpack(select(2, ...))

tinsert(C.defaultThemes, function()
	B.ReskinFrame(TradeFrame)

	B.ReskinButton(TradeFrameTradeButton)
	B.ReskinButton(TradeFrameCancelButton)
	B.ReskinInput(TradePlayerInputMoneyFrameGold)
	B.ReskinInput(TradePlayerInputMoneyFrameSilver)
	B.ReskinInput(TradePlayerInputMoneyFrameCopper)

	TradeFrame.RecipientOverlay:Hide()
	TradeRecipientMoneyBg:Hide()

	TradePlayerInputMoneyFrameSilver:ClearAllPoints()
	TradePlayerInputMoneyFrameSilver:SetPoint("LEFT", TradePlayerInputMoneyFrameGold, "RIGHT", 1, 0)
	TradePlayerInputMoneyFrameCopper:ClearAllPoints()
	TradePlayerInputMoneyFrameCopper:SetPoint("LEFT", TradePlayerInputMoneyFrameSilver, "RIGHT", 1, 0)

	local insets = {TradePlayerEnchantInset, TradePlayerInputMoneyInset ,TradePlayerItemsInset, TradeRecipientEnchantInset, TradeRecipientItemsInset, TradeRecipientMoneyInset, TradeRecipientMoneyBg}
	for _, inset in pairs(insets) do
		inset:Hide()
	end

	local highlights = {TradeHighlightPlayer, TradeHighlightPlayerEnchant, TradeHighlightRecipient, TradeHighlightRecipientEnchant}
	for _, highlight in pairs(highlights) do
		B.StripTextures(highlight)

		local bg = B.CreateBDFrame(highlight, .25, nil, true)
		bg:SetBackdropColor(0, 1, 0, .25)
		bg:SetBackdropBorderColor(0, 1, 0, 1)
	end

	local function reskinButton(bu)
		B.CleanTextures(bu)

		local icbg = B.ReskinIcon(bu.icon)
		B.ReskinHighlight(bu, icbg)
		B.ReskinBorder(bu.IconBorder, icbg)
	end

	for i = 1, MAX_TRADE_ITEMS do
		B.StripTextures(_G["TradePlayerItem"..i])
		B.StripTextures(_G["TradeRecipientItem"..i])

		reskinButton(_G["TradePlayerItem"..i.."ItemButton"])
		reskinButton(_G["TradeRecipientItem"..i.."ItemButton"])
	end
end)