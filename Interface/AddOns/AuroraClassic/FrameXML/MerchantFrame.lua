local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	function F.ReskinMerchantItem(x)
		local bu = _G["MerchantItem"..x.."ItemButton"]
		F.StripTextures(bu)
		F.ReskinBorder(bu.IconBorder, bu)

		local icbg = F.ReskinIcon(bu.icon)
		F.ReskinTexture(bu, icbg, false)

		local item = _G["MerchantItem"..x]
		F.StripTextures(item, true)

		local name = _G["MerchantItem"..x.."Name"]
		name:SetWordWrap(false)
		name:ClearAllPoints()
		name:SetPoint("TOPLEFT", icbg, "TOPRIGHT", 4, 2)

		local money = _G["MerchantItem"..x.."MoneyFrame"]
		money:ClearAllPoints()
		money:SetPoint("BOTTOMLEFT", icbg, "BOTTOMRIGHT", 4, 2)

		for y = 1, 3 do
			F.ReskinIcon(_G["MerchantItem"..x.."AltCurrencyFrameItem"..y.."Texture"], true)
		end
	end

	F.StripTextures(MerchantMoneyBg, true)
	F.StripTextures(MerchantMoneyInset, true)
	F.StripTextures(MerchantExtraCurrencyBg, true)
	F.StripTextures(MerchantExtraCurrencyInset, true)

	F.ReskinFrame(MerchantFrame)
	F.ReskinDropDown(MerchantFrameLootFilter)
	F.ReskinArrow(MerchantPrevPageButton, "left")
	F.ReskinArrow(MerchantNextPageButton, "right")

	MerchantFrameTab1:ClearAllPoints()
	MerchantFrameTab1:SetPoint("CENTER", MerchantFrame, "BOTTOMLEFT", 50, -14)
	MerchantFrameTab2:SetPoint("LEFT", MerchantFrameTab1, "RIGHT", -15, 0)
	F.ReskinTab(MerchantFrameTab1)
	F.ReskinTab(MerchantFrameTab2)

	for x = 1, BUYBACK_ITEMS_PER_PAGE do
		F.ReskinMerchantItem(x)
	end

	local backIC = F.ReskinIcon(MerchantBuyBackItemItemButtonIconTexture, false, 0)

	local backBU = MerchantBuyBackItemItemButton
	F.StripTextures(backBU)
	F.ReskinTexture(backBU, backIC, false)
	backBU.IconBorder:SetAlpha(0)

	local backIT = MerchantBuyBackItem
	F.StripTextures(backIT, true)

	local itemBG = F.CreateBDFrame(backIT, 0)
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
	for _, repair in pairs(repairs) do
		repair:SetPushedTexture("")
		repair:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)
		F.CreateBDFrame(repair, 0)
	end

	MerchantGuildBankRepairButtonIcon:SetTexCoord(0.595, 0.8075, 0.05, 0.52)
	MerchantRepairAllIcon:SetTexCoord(0.31375, 0.53, 0.06, 0.52)
	local ic = MerchantRepairItemButton:GetRegions()
	ic:SetTexture("Interface\\Icons\\INV_Hammer_20")
	ic:SetTexCoord(.08, .92, .08, .92)

	hooksecurefunc("MerchantFrame_UpdateMerchantInfo", function()
		for i = 1, MERCHANT_ITEMS_PER_PAGE do
			local money = _G["MerchantItem"..i.."MoneyFrame"]
			local currency = _G["MerchantItem"..i.."AltCurrencyFrame"]

			currency:ClearAllPoints()
			currency:SetPoint("LEFT", money, "LEFT", 0, 2)
		end
	end)

	hooksecurefunc("MerchantFrame_UpdateRepairButtons", function()
		if CanGuildBankRepair() then
			MerchantRepairText:ClearAllPoints()
			MerchantRepairText:SetPoint("BOTTOMLEFT", MerchantRepairItemButton, "TOPLEFT", -2, 4)
		end
	end)
end)