local _, ns = ...
local B, C, L, DB = unpack(ns)

local function Reskin_ItemButton(self)
	B.CleanTextures(self)

	local icbg = B.ReskinIcon(self.icon)
	B.ReskinHighlight(self, icbg)
	B.ReskinBorder(self.IconBorder, icbg)
end

tinsert(C.XMLThemes, function()
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

	local insets = {
		TradePlayerEnchantInset,
		TradePlayerInputMoneyInset,
		TradePlayerItemsInset,
		TradeRecipientEnchantInset,
		TradeRecipientItemsInset,
		TradeRecipientMoneyInset,
		TradeRecipientMoneyBg,
	}
	for _, inset in pairs(insets) do
		inset:Hide()
	end

	local highlights = {
		TradeHighlightPlayer,
		TradeHighlightPlayerEnchant,
		TradeHighlightRecipient,
		TradeHighlightRecipientEnchant,
	}
	for _, highlight in pairs(highlights) do
		B.StripTextures(highlight)

		local bg = B.CreateBDFrame(highlight, 0, 0, true)
		bg:SetBackdropColor(0, 1, 0, .25)
		bg:SetBackdropBorderColor(0, 1, 0, 1)
	end

	for i = 1, MAX_TRADE_ITEMS do
		B.StripTextures(_G["TradePlayerItem"..i])
		B.StripTextures(_G["TradeRecipientItem"..i])

		Reskin_ItemButton(_G["TradePlayerItem"..i.."ItemButton"])
		Reskin_ItemButton(_G["TradeRecipientItem"..i.."ItemButton"])
	end
end)