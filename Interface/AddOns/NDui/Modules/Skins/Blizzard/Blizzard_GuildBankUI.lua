local B, C, L, DB = unpack(select(2, ...))

C.themes["Blizzard_GuildBankUI"] = function()
	B.ReskinFrame(GuildBankFrame)
	B.ReskinInput(GuildItemSearchBox)

	B.ReskinFrame(GuildBankPopupFrame)
	B.ReskinInput(GuildBankPopupEditBox)

	B.ReskinFrameTab(GuildBankFrame, 4)

	B.StripTextures(GuildBankEmblemFrame, 0)
	B.StripTextures(GuildBankMoneyFrameBackground)

	GuildBankPopupFrame:SetHeight(525)
	GuildBankFrameWithdrawButton:ClearAllPoints()
	GuildBankFrameWithdrawButton:SetPoint("RIGHT", GuildBankFrameDepositButton, "LEFT", -1, 0)

	local buttons = {GuildBankFrameWithdrawButton, GuildBankFrameDepositButton, GuildBankFramePurchaseButton, GuildBankPopupOkayButton, GuildBankPopupCancelButton, GuildBankInfoSaveButton}
	for _, button in pairs(buttons) do
		B.ReskinButton(button)
	end

	local scrolls = {GuildBankTransactionsScrollFrameScrollBar, GuildBankInfoScrollFrameScrollBar, GuildBankPopupScrollFrameScrollBar}
	for _, scroll in pairs(scrolls) do
		B.ReskinScroll(scroll)
	end

	for i = 1, 8 do
		local tab = "GuildBankTab"..i

		local tb = _G[tab]
		B.StripTextures(tb)

		local bu = _G[tab.."Button"]
		B.StripTextures(bu)
		bu:SetSize(32, 32)

		local icon = _G[tab.."ButtonIconTexture"]
		local icbg = B.ReskinIcon(icon)
		B.ReskinHighlight(bu, icbg)
		B.ReskinChecked(bu, icbg)

		if i == 1 then
			tb:ClearAllPoints()
			tb:SetPoint("TOPLEFT", GuildBankFrame, "TOPRIGHT", 1, -25)
		end
	end

	for i = 1, NUM_GUILDBANK_COLUMNS do
		local frame = "GuildBankColumn"..i

		B.StripTextures(_G[frame])

		for j = 1, NUM_SLOTS_PER_GUILDBANK_GROUP do
			local bu = _G[frame.."Button"..j]
			B.CleanTextures(bu)

			local icbg = B.ReskinIcon(bu.icon)
			B.ReskinHighlight(bu, icbg)

			local border = bu.IconBorder
			B.ReskinBorder(border, icbg)

			local searchOverlay = bu.searchOverlay
			searchOverlay:SetAllPoints(icbg)
		end
	end

	GuildBankPopupFrame:HookScript("OnShow", function(self)
		self:ClearAllPoints()
		self:SetPoint("TOPLEFT", GuildBankFrame, "TOPRIGHT", 42, 0)

		for i = 1, NUM_GUILDBANK_ICONS_PER_ROW * NUM_GUILDBANK_ICON_ROWS do
			local button = "GuildBankPopupButton"..i

			local bu = _G[button]
			local ic = _G[button.."Icon"]

			if not bu.styled then
				B.StripTextures(bu)

				local icbg = B.ReskinIcon(ic)
				B.ReskinChecked(bu, icbg)
				B.ReskinHighlight(bu, icbg)

				bu.styled = true
			end
		end
	end)
end