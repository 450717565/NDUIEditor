local F, C = unpack(select(2, ...))

C.themes["Blizzard_GuildBankUI"] = function()
	F.ReskinFrame(GuildBankFrame)
	F.ReskinInput(GuildItemSearchBox)

	F.ReskinFrame(GuildBankPopupFrame)
	F.ReskinInput(GuildBankPopupEditBox)

	GuildBankPopupFrame:SetHeight(525)
	GuildBankPopupFrame:ClearAllPoints()
	GuildBankPopupFrame:SetPoint("TOPLEFT", GuildBankFrame, "TOPRIGHT", 2, -30)
	GuildBankFrameWithdrawButton:ClearAllPoints()
	GuildBankFrameWithdrawButton:SetPoint("RIGHT", GuildBankFrameDepositButton, "LEFT", -1, 0)

	local lists = {GuildBankEmblemFrame, GuildBankMoneyFrameBackground, GuildBankTransactionsScrollFrame, GuildBankInfoScrollFrame, GuildBankPopupScrollFrame}
	for _, list in pairs(lists) do
		F.StripTextures(list, true)
	end

	local buttons = {GuildBankFrameWithdrawButton, GuildBankFrameDepositButton, GuildBankFramePurchaseButton, GuildBankPopupOkayButton, GuildBankPopupCancelButton, GuildBankInfoSaveButton}
	for _, button in pairs(buttons) do
		F.ReskinButton(button)
	end

	local scrolls = {GuildBankTransactionsScrollFrameScrollBar, GuildBankInfoScrollFrameScrollBar, GuildBankPopupScrollFrameScrollBar}
	for _, scroll in pairs(scrolls) do
		F.ReskinScroll(scroll)
	end

	for i = 1, 8 do
		local tab = "GuildBankTab"..i

		local tb = _G[tab]
		F.StripTextures(tb)

		local bu = _G[tab.."Button"]
		F.StripTextures(bu)
		bu:SetSize(34, 34)

		local icon = _G[tab.."ButtonIconTexture"]
		local icbg = F.ReskinIcon(icon)
		F.ReskinTexture(bu, icbg, false)
		F.ReskinTexed(bu, icbg)

		if i == 1 then
			tb:ClearAllPoints()
			tb:SetPoint("TOPLEFT", GuildBankFrame, "TOPRIGHT", 0, -25)
		end
	end

	for i = 1, 4 do
		local tab = _G["GuildBankFrameTab"..i]
		F.ReskinTab(tab)

		tab:ClearAllPoints()
		if i ~= 1 then
			tab:SetPoint("LEFT", _G["GuildBankFrameTab"..(i-1)], "RIGHT", -15, 0)
		else
			tab:SetPoint("TOPLEFT", GuildBankFrame, "BOTTOMLEFT", 15, 2)
		end
	end

	for i = 1, NUM_GUILDBANK_COLUMNS do
		F.StripTextures(_G["GuildBankColumn"..i])

		for j = 1, NUM_SLOTS_PER_GUILDBANK_GROUP do
			local bu = _G["GuildBankColumn"..i.."Button"..j]
			F.CleanTextures(bu)

			local icbg = F.ReskinIcon(bu.icon)
			F.ReskinTexture(bu, icbg, false)

			local border = bu.IconBorder
			F.ReskinBorder(border, bu)

			local searchOverlay = bu.searchOverlay
			searchOverlay:SetAllPoints(icbg)
		end
	end

	GuildBankPopupFrame:HookScript("OnShow", function()
		for i = 1, NUM_GUILDBANK_ICONS_PER_ROW * NUM_GUILDBANK_ICON_ROWS do
			local button = "GuildBankPopupButton"..i

			local bu = _G[button]
			local ic = _G[button.."Icon"]

			if not bu.styled then
				F.StripTextures(bu)

				local icbg = F.ReskinIcon(ic)
				F.ReskinTexed(bu, icbg)
				F.ReskinTexture(bu, icbg, false)

				bu.styled = true
			end
		end
	end)
end