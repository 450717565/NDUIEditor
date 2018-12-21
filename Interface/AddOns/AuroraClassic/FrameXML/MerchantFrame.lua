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
		bu.IconBorder:SetAlpha(0)

		local ic = F.ReskinIcon(bu.icon, true)
		F.ReskinTexture(bu, false, ic)

		local item = _G["MerchantItem"..i]
		F.StripTextures(item, true)

		local bg = F.CreateBDFrame(item, .25)
		bg:SetPoint("TOPLEFT", ic, "TOPRIGHT", 2, 4)
		bg:SetPoint("BOTTOMRIGHT", 0, 0)

		local name = _G["MerchantItem"..i.."Name"]
		name:ClearAllPoints()
		name:SetPoint("TOPLEFT", bg, "TOPLEFT", 2, -2)

		local money = _G["MerchantItem"..i.."MoneyFrame"]
		money:ClearAllPoints()
		money:SetPoint("BOTTOMLEFT", bg, "BOTTOMLEFT", 2, 2)

		local currency = _G["MerchantItem"..i.."AltCurrencyFrame"]
		currency:ClearAllPoints()
		currency:SetPoint("BOTTOMLEFT", bg, "BOTTOMLEFT", 2, 3)
		currency.SetPoint = F.dummy

		for j = 1, 3 do
			local acTex = _G["MerchantItem"..i.."AltCurrencyFrameItem"..j.."Texture"]
			F.ReskinIcon(acTex)
		end
	end

	hooksecurefunc("MerchantFrame_UpdateMerchantInfo", function()
		local numMerchantItems = GetMerchantNumItems()
		for i = 1, MERCHANT_ITEMS_PER_PAGE do
			local index = ((MerchantFrame.page - 1) * MERCHANT_ITEMS_PER_PAGE) + i
			if index <= numMerchantItems then
				local bu = _G["MerchantItem"..i.."ItemButton"]
				local name = _G["MerchantItem"..i.."Name"]
				if bu.link then
					local _, _, quality = GetItemInfo(bu.link)
					if quality then
						local r, g, b = GetItemQualityColor(quality)
						name:SetTextColor(r, g, b)
					else
						name:SetTextColor(1, 1, 1)
					end
				else
					name:SetTextColor(1, 1, 1)
				end
			end
		end

		local name = GetBuybackItemLink(GetNumBuybackItems())
		if name then
			local _, _, quality = GetItemInfo(name)
			local r, g, b = GetItemQualityColor(quality or 1)

			MerchantBuyBackItemName:SetTextColor(r, g, b)
		end
	end)

	hooksecurefunc("MerchantFrame_UpdateBuybackInfo", function()
		for i = 1, BUYBACK_ITEMS_PER_PAGE do
			local itemLink = GetBuybackItemLink(i)
			local name = _G["MerchantItem"..i.."Name"]

			if itemLink then
				local _, _, quality = GetItemInfo(itemLink)
				local r, g, b = GetItemQualityColor(quality)

				name:SetTextColor(r, g, b)
			else
				name:SetTextColor(1, 1, 1)
			end
		end
	end)

	local backIC = F.ReskinIcon(MerchantBuyBackItemItemButtonIconTexture, true)

	local backBU = MerchantBuyBackItemItemButton
	F.StripTextures(backBU)
	F.ReskinTexture(backBU, false, backIC)
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

	hooksecurefunc("MerchantFrame_UpdateCurrencies", function()
		for i = 1, MAX_MERCHANT_CURRENCIES do
			local bu = _G["MerchantToken"..i]
			if bu and not bu.reskinned then
				local ic = _G["MerchantToken"..i.."Icon"]
				local co = _G["MerchantToken"..i.."Count"]

				ic:SetDrawLayer("OVERLAY")
				ic:SetPoint("LEFT", co, "RIGHT", 2, 0)
				co:SetPoint("TOPLEFT", bu, "TOPLEFT", -2, 0)
				F.ReskinIcon(ic, true)

				bu.reskinned = true
			end
		end
	end)

	hooksecurefunc("MerchantFrame_UpdateRepairButtons", function()
		if CanGuildBankRepair() then
			MerchantRepairText:ClearAllPoints()
			MerchantRepairText:SetPoint("BOTTOMLEFT", MerchantRepairItemButton, "TOPLEFT", -2, 4)
		end
	end)
end)