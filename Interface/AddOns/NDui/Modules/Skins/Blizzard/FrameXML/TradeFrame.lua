local B, C, L, DB = unpack(select(2, ...))

tinsert(C.defaultThemes, function()
	B.ReskinFrame(TradeFrame)

	B.ReskinButton(TradeFrameTradeButton)
	B.ReskinButton(TradeFrameCancelButton)
	B.ReskinInput(TradePlayerInputMoneyFrameGold)
	B.ReskinInput(TradePlayerInputMoneyFrameSilver)
	B.ReskinInput(TradePlayerInputMoneyFrameCopper)

	TradeFrame.RecipientOverlay:Hide()
	TradePlayerEnchantInset:Hide()
	TradePlayerInputMoneyInset:Hide()
	TradePlayerItemsInset:Hide()
	TradeRecipientEnchantInset:Hide()
	TradeRecipientItemsInset:Hide()
	TradeRecipientMoneyInset:Hide()

	TradeRecipientMoneyBg:Hide()
	TradePlayerInputMoneyFrameSilver:SetPoint("LEFT", TradePlayerInputMoneyFrameGold, "RIGHT", 1, 0)
	TradePlayerInputMoneyFrameCopper:SetPoint("LEFT", TradePlayerInputMoneyFrameSilver, "RIGHT", 1, 0)

	local function reskinButton(bu)
		bu:SetNormalTexture("")
		bu:SetPushedTexture("")

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