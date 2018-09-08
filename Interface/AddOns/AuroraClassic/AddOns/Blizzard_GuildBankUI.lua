local F, C = unpack(select(2, ...))

C.themes["Blizzard_GuildBankUI"] = function()
	local lists = {GuildBankFrame, GuildBankEmblemFrame, GuildBankMoneyFrameBackground, GuildBankTransactionsScrollFrame, GuildBankInfoScrollFrame}
	for _, list in next, lists do
		F.StripTextures(list, true)
	end

	local buttons = {GuildBankFrameWithdrawButton, GuildBankFrameDepositButton, GuildBankFramePurchaseButton, GuildBankPopupOkayButton, GuildBankPopupCancelButton, GuildBankInfoSaveButton}
	for _, button in next, buttons do
		F.Reskin(button)
	end

	F.CreateBD(GuildBankFrame)
	F.CreateSD(GuildBankFrame)
	F.ReskinClose(GuildBankFrame.CloseButton)
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

	F.CreateBD(GuildBankPopupFrame)
	F.CreateSD(GuildBankPopupFrame)
	F.CreateBDFrame(GuildBankPopupEditBox, .25)
	GuildBankPopupFrame:SetPoint("TOPLEFT", GuildBankFrame, "TOPRIGHT", 2, -30)
	GuildBankPopupFrame:SetHeight(525)

	GuildBankFrameWithdrawButton:SetPoint("RIGHT", GuildBankFrameDepositButton, "LEFT", -2, 0)

	for i = 1, NUM_GUILDBANK_COLUMNS do
		F.StripTextures(_G["GuildBankColumn"..i])
		for j = 1, NUM_SLOTS_PER_GUILDBANK_GROUP do
			local bu = _G["GuildBankColumn"..i.."Button"..j]
			F.StripTextures(bu)
			F.CreateBDFrame(bu, .25)

			bu.icon:SetTexCoord(.08, .92, .08, .92)

			local border = bu.IconBorder
			border:SetTexture(C.media.backdrop)
			border.SetTexture = F.dummy
			border:SetPoint("TOPLEFT", -1.2, 1.2)
			border:SetPoint("BOTTOMRIGHT", 1.2, -1.2)
			border:SetDrawLayer("BACKGROUND")

			local searchOverlay = bu.searchOverlay
			searchOverlay:SetPoint("TOPLEFT", -1.2, 1.2)
			searchOverlay:SetPoint("BOTTOMRIGHT", 1.2, -1.2)

			bu:SetHighlightTexture(C.media.backdrop)
			local hl = bu:GetHighlightTexture()
			hl:SetVertexColor(1, 1, 1, .25)
		end
	end

	hooksecurefunc("GuildBankFrame_Update", function()
		for i = 1, NUM_GUILDBANK_COLUMNS do
			for j = 1, NUM_SLOTS_PER_GUILDBANK_GROUP do
				local bu = _G["GuildBankColumn"..i.."Button"..j]
				bu.IconBorder:SetTexture(C.media.backdrop)
			end
		end
	end)

	for i = 1, 8 do
		local tb = _G["GuildBankTab"..i]
		F.StripTextures(tb)

		local bu = _G["GuildBankTab"..i.."Button"]
		F.StripTextures(bu)
		F.CreateBDFrame(bu)
		bu:SetSize(34, 34)
		bu:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)
		bu:SetCheckedTexture(C.media.checked)

		local a1, p, a2, x, y = bu:GetPoint()
		bu:SetPoint(a1, p, a2, x + 1, y)

		local ic = _G["GuildBankTab"..i.."ButtonIconTexture"]
		ic:SetTexCoord(.08, .92, .08, .92)
	end

	GuildBankPopupFrame:HookScript("OnShow", function()
		for i = 1, NUM_GUILDBANK_ICONS_PER_ROW * NUM_GUILDBANK_ICON_ROWS do
			local bu = _G["GuildBankPopupButton"..i]

			if not bu.styled then
				bu:SetCheckedTexture(C.media.checked)
				select(2, bu:GetRegions()):Hide()

				_G["GuildBankPopupButton"..i.."Icon"]:SetTexCoord(.08, .92, .08, .92)

				F.CreateBDFrame(_G["GuildBankPopupButton"..i.."Icon"], .25)
				bu.styled = true
			end
		end
	end)
end