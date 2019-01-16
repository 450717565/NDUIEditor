local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	F.StripTextures(MerchantMoneyBg, true)
	F.StripTextures(MerchantMoneyInset, true)
	F.StripTextures(MerchantExtraCurrencyBg, true)
	F.StripTextures(MerchantExtraCurrencyInset, true)

	F.ReskinPortraitFrame(MerchantFrame, true)
	F.ReskinDropDown(MerchantFrameLootFilter)
	F.ReskinArrow(MerchantPrevPageButton, "left")
	F.ReskinArrow(MerchantNextPageButton, "right")

	MerchantFrameTab1:ClearAllPoints()
	MerchantFrameTab1:SetPoint("CENTER", MerchantFrame, "BOTTOMLEFT", 50, -14)
	MerchantFrameTab2:SetPoint("LEFT", MerchantFrameTab1, "RIGHT", -15, 0)
	F.ReskinTab(MerchantFrameTab1)
	F.ReskinTab(MerchantFrameTab2)

	MerchantNameText:SetDrawLayer("ARTWORK")

	for i = 1, BUYBACK_ITEMS_PER_PAGE do
		local bu = _G["MerchantItem"..i.."ItemButton"]
		F.StripTextures(bu)
		F.ReskinTexture(bu.IconBorder, bu, false, true)

		local ic = F.ReskinIcon(bu.icon, true)
		F.ReskinTexture(bu, ic, false)

		local item = _G["MerchantItem"..i]
		F.StripTextures(item, true)

		local name = _G["MerchantItem"..i.."Name"]
		name:ClearAllPoints()
		name:SetPoint("TOPLEFT", ic, "TOPRIGHT", 4, 1)

		local money = _G["MerchantItem"..i.."MoneyFrame"]
		money:ClearAllPoints()
		money:SetPoint("LEFT", ic, "BOTTOMRIGHT", 4, 2)

		for j = 1, 3 do
			F.ReskinIcon(_G["MerchantItem"..i.."AltCurrencyFrameItem"..j.."Texture"])
		end
	end

	local backIC = F.ReskinIcon(MerchantBuyBackItemItemButtonIconTexture, true)

	local backBU = MerchantBuyBackItemItemButton
	F.StripTextures(backBU)
	F.ReskinTexture(backBU, backIC, false)
	backBU.IconBorder:SetAlpha(0)

	local backIT = MerchantBuyBackItem
	F.StripTextures(backIT, true)

	local itemBG = F.CreateBDFrame(backIT, .25)
	itemBG:SetPoint("TOPLEFT", backIC, "TOPRIGHT", 2, 0)
	itemBG:SetPoint("BOTTOMRIGHT", 0, -2)

	local backName = MerchantBuyBackItemName
	backName:SetWordWrap(false)
	backName:ClearAllPoints()
	backName:SetPoint("TOPLEFT", itemBG, "TOPLEFT", 2, 4)

	local backMoney = MerchantBuyBackItemMoneyFrame
	backMoney:ClearAllPoints()
	backMoney:SetPoint("BOTTOMLEFT", itemBG, "BOTTOMLEFT", 2, 2)

	local repairs = {MerchantGuildBankRepairButton, MerchantRepairAllButton, MerchantRepairItemButton}
	for _, repair in next, repairs do
		repair:SetPushedTexture("")
		repair:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)
		F.CreateBDFrame(repair, .25)
	end

	MerchantGuildBankRepairButtonIcon:SetTexCoord(0.595, 0.8075, 0.05, 0.52)
	MerchantRepairAllIcon:SetTexCoord(0.31375, 0.53, 0.06, 0.52)
	local ic = MerchantRepairItemButton:GetRegions()
	ic:SetTexture("Interface\\Icons\\INV_Hammer_20")
	ic:SetTexCoord(.08, .92, .08, .92)

	hooksecurefunc("MerchantFrame_UpdateRepairButtons", function()
		if CanGuildBankRepair() then
			MerchantRepairText:ClearAllPoints()
			MerchantRepairText:SetPoint("BOTTOMLEFT", MerchantRepairItemButton, "TOPLEFT", -2, 4)
		end
	end)
end)