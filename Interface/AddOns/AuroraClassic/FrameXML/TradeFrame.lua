local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	F.ReskinPortraitFrame(TradeFrame, true)
	TradeFrame.RecipientOverlay:Hide()
	TradePlayerEnchantInset:Hide()
	TradePlayerInputMoneyInset:Hide()
	TradePlayerItemsInset:Hide()
	TradeRecipientEnchantInset:Hide()
	TradeRecipientItemsInset:Hide()
	TradeRecipientMoneyInset:Hide()

	F.Reskin(TradeFrameTradeButton)
	F.Reskin(TradeFrameCancelButton)
	F.ReskinInput(TradePlayerInputMoneyFrameGold)
	F.ReskinInput(TradePlayerInputMoneyFrameSilver)
	F.ReskinInput(TradePlayerInputMoneyFrameCopper)

	TradeRecipientMoneyBg:Hide()
	TradePlayerInputMoneyFrameSilver:SetPoint("LEFT", TradePlayerInputMoneyFrameGold, "RIGHT", 1, 0)
	TradePlayerInputMoneyFrameCopper:SetPoint("LEFT", TradePlayerInputMoneyFrameSilver, "RIGHT", 1, 0)

	local function reskinButton(bu)
		bu:SetNormalTexture("")
		bu:SetPushedTexture("")

		local ic = F.ReskinIcon(bu.icon, true)
		F.ReskinTexture(bu, false, ic)
		F.ReskinTexture(bu.IconBorder, false, bu, true)
	end

	for i = 1, MAX_TRADE_ITEMS do
		F.StripTextures(_G["TradePlayerItem"..i])
		F.StripTextures(_G["TradeRecipientItem"..i])

		reskinButton(_G["TradePlayerItem"..i.."ItemButton"])
		reskinButton(_G["TradeRecipientItem"..i.."ItemButton"])
	end
end)