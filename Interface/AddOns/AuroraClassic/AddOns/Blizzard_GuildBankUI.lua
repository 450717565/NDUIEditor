local F, C = unpack(select(2, ...))

C.themes["Blizzard_GuildBankUI"] = function()
	local lists = {GuildBankEmblemFrame, GuildBankMoneyFrameBackground, GuildBankTransactionsScrollFrame, GuildBankInfoScrollFrame}
	for _, list in next, lists do
		F.StripTextures(list, true)
	end

	local buttons = {GuildBankFrameWithdrawButton, GuildBankFrameDepositButton, GuildBankFramePurchaseButton, GuildBankPopupOkayButton, GuildBankPopupCancelButton, GuildBankInfoSaveButton}
	for _, button in next, buttons do
		F.ReskinButton(button)
	end

	F.ReskinFrame(GuildBankFrame)
	F.ReskinScroll(GuildBankTransactionsScrollFrameScrollBar)
	F.ReskinScroll(GuildBankInfoScrollFrameScrollBar)
	F.ReskinScroll(GuildBankPopupScrollFrameScrollBar)
	F.ReskinInput(GuildItemSearchBox)

	for i = 1, 4 do
		local tab = _G["GuildBankFrameTab"..i]
		F.ReskinTab(tab)

		if i ~= 1 then
			tab:SetPoint("LEFT", _G["GuildBankFrameTab"..i-1], "RIGHT", -15, 0)
		end
	end

	F.ReskinFrame(GuildBankPopupFrame)
	F.CreateBDFrame(GuildBankPopupEditBox, 0)
	GuildBankPopupFrame:SetPoint("TOPLEFT", GuildBankFrame, "TOPRIGHT", 2, -30)
	GuildBankPopupFrame:SetHeight(525)

	GuildBankFrameWithdrawButton:SetPoint("RIGHT", GuildBankFrameDepositButton, "LEFT", -2, 0)

	for i = 1, NUM_GUILDBANK_COLUMNS do
		F.StripTextures(_G["GuildBankColumn"..i])
		for j = 1, NUM_SLOTS_PER_GUILDBANK_GROUP do
			local bu = _G["GuildBankColumn"..i.."Button"..j]
			F.StripTextures(bu)

			local bg = F.ReskinIcon(bu.icon)
			F.ReskinTexture(bu, bg, false)

			local searchOverlay = bu.searchOverlay
			searchOverlay:SetAllPoints(bg)

			local border = bu.IconBorder
			F.ReskinBorder(border, bu)
		end
	end

	hooksecurefunc("GuildBankFrame_Update", function()
		for i = 1, NUM_GUILDBANK_COLUMNS do
			for j = 1, NUM_SLOTS_PER_GUILDBANK_GROUP do
				local bu = _G["GuildBankColumn"..i.."Button"..j]
				bu.IconBorder:SetTexture(C.media.bdTex)
			end
		end
	end)

	GuildBankTab1:ClearAllPoints()
	GuildBankTab1:SetPoint("TOPLEFT", GuildBankFrame, "TOPRIGHT", 2, -25)
	for i = 1, 8 do
		local tb = _G["GuildBankTab"..i]
		F.StripTextures(tb)

		local bu = _G["GuildBankTab"..i.."Button"]
		F.StripTextures(bu)
		bu:SetSize(34, 34)
		bu:SetCheckedTexture(C.media.checked)

		local a1, p, a2, x, y = bu:GetPoint()
		bu:SetPoint(a1, p, a2, x + 1, y)

		local ic = _G["GuildBankTab"..i.."ButtonIconTexture"]
		local bg = F.ReskinIcon(ic)
		F.ReskinTexture(bu, bg, false)
	end

	GuildBankPopupFrame:HookScript("OnShow", function()
		for i = 1, NUM_GUILDBANK_ICONS_PER_ROW * NUM_GUILDBANK_ICON_ROWS do
			local bu = _G["GuildBankPopupButton"..i]

			if not bu.styled then
				bu:SetCheckedTexture(C.media.checked)
				select(2, bu:GetRegions()):Hide()
				F.ReskinIcon(_G["GuildBankPopupButton"..i.."Icon"])

				bu.styled = true
			end
		end
	end)
end