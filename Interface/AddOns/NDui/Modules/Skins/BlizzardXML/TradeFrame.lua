local _, ns = ...
local B, C, L, DB = unpack(ns)

local function Reskin_ItemButton(self)
	local item = _G[self]
	B.StripTextures(item)

	local button = _G[self.."ItemButton"]
	B.StripTextures(button)

	local icbg = B.ReskinIcon(button.icon)
	B.ReskinHLTex(button, icbg)

	local bubg = B.CreateBGFrame(item, 2, 0, -15, 0, icbg)
	B.ReskinBorder(button.IconBorder, icbg, bubg)
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

	local texts = {
		TradeFramePlayerNameText,
		TradeFrameRecipientNameText,
	}
	for index, text in pairs(texts) do
		text:SetWidth(150)
		text:SetJustifyH("CENTER")
		text:ClearAllPoints()
		if index == 1 then
			text:SetPoint("TOPRIGHT", TradeFrame, "TOP", -5, -10)
		else
			text:SetPoint("TOPLEFT", TradeFrame, "TOP", 5, -10)
		end
	end

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
		Reskin_ItemButton("TradePlayerItem"..i)
		Reskin_ItemButton("TradeRecipientItem"..i)
	end
end)