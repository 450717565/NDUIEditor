local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	MerchantMoneyInset:DisableDrawLayer("BORDER")
	MerchantExtraCurrencyInset:DisableDrawLayer("BORDER")
	BuybackBG:SetAlpha(0)
	MerchantMoneyBg:Hide()
	MerchantMoneyInsetBg:Hide()
	MerchantFrameBottomLeftBorder:SetAlpha(0)
	MerchantFrameBottomRightBorder:SetAlpha(0)
	MerchantExtraCurrencyBg:SetAlpha(0)
	MerchantExtraCurrencyInsetBg:Hide()
	MerchantPrevPageButton:GetRegions():Hide()
	MerchantNextPageButton:GetRegions():Hide()
	select(2, MerchantPrevPageButton:GetRegions()):Hide()
	select(2, MerchantNextPageButton:GetRegions()):Hide()

	F.ReskinPortraitFrame(MerchantFrame, true)
	F.ReskinDropDown(MerchantFrameLootFilter)
	F.ReskinArrow(MerchantPrevPageButton, "left")
	F.ReskinArrow(MerchantNextPageButton, "right")

	MerchantFrameTab1:ClearAllPoints()
	MerchantFrameTab1:SetPoint("CENTER", MerchantFrame, "BOTTOMLEFT", 50, -14)
	MerchantFrameTab2:SetPoint("LEFT", MerchantFrameTab1, "RIGHT", -15, 0)

	for i = 1, 2 do
		F.ReskinTab(_G["MerchantFrameTab"..i])
	end

	MerchantNameText:SetDrawLayer("ARTWORK")

	for i = 1, BUYBACK_ITEMS_PER_PAGE do
		_G["MerchantItem"..i.."SlotTexture"]:Hide()
		_G["MerchantItem"..i.."NameFrame"]:Hide()
		_G["MerchantItem"..i.."Name"]:SetHeight(20)

		local button = _G["MerchantItem"..i]
		button.bd = CreateFrame("Frame", nil, button)
		button.bd:SetPoint("TOPLEFT", 39, 0)
		button.bd:SetPoint("BOTTOMRIGHT")
		button.bd:SetFrameLevel(0)
		F.CreateBD(button.bd, .25)
		F.CreateSD(button.bd)

		local mo = _G["MerchantItem"..i.."MoneyFrame"]
		local a3, p2, a4, x, y = mo:GetPoint()
		mo:SetPoint(a3, p2, a4, x+1, y+4)

		local bu = _G["MerchantItem"..i.."ItemButton"]
		local a1, p, a2 = bu:GetPoint()
		bu:SetPoint(a1, p, a2, -4, -2)
		bu:SetNormalTexture("")
		bu:SetPushedTexture("")
		bu:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)
		bu:SetSize(40, 40)
		bu.IconBorder:SetAlpha(0)
		F.CreateBDFrame(bu, 0)

		local ic = bu.icon
		ic:SetTexCoord(.08, .92, .08, .92)

		for j = 1, 3 do
			local acTex = _G["MerchantItem"..i.."AltCurrencyFrameItem"..j.."Texture"]
			acTex:SetTexCoord(.08, .92, .08, .92)
			F.CreateBDFrame(acTex)
		end
	end

	hooksecurefunc("MerchantFrame_UpdateMerchantInfo", function()
		local numMerchantItems = GetMerchantNumItems()
		for i = 1, MERCHANT_ITEMS_PER_PAGE do
			local index = ((MerchantFrame.page - 1) * MERCHANT_ITEMS_PER_PAGE) + i
			if index <= numMerchantItems then
				local _, _, price, _, _, _, extendedCost = GetMerchantItemInfo(index)
				if extendedCost and (price <= 0) then
					_G["MerchantItem"..i.."AltCurrencyFrame"]:SetPoint("BOTTOMLEFT", "MerchantItem"..i.."NameFrame", "BOTTOMLEFT", 0, 35)
				end

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

	local bmo = MerchantBuyBackItemMoneyFrame
	local b1, b2, b3, bx, by = bmo:GetPoint()
	bmo:SetPoint(b1, b2, b3, bx+3, by+1)

	MerchantBuyBackItemSlotTexture:SetAlpha(0)
	F.CreateBD(MerchantBuyBackItem, .25)
	F.CreateSD(MerchantBuyBackItem)

	MerchantBuyBackItemItemButton:SetNormalTexture("")
	MerchantBuyBackItemItemButton:SetPushedTexture("")
	MerchantBuyBackItemItemButton:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)
	MerchantBuyBackItemItemButtonIconTexture:SetTexCoord(.08, .92, .08, .92)
	MerchantBuyBackItemItemButton.IconBorder:SetAlpha(0)
	F.CreateBDFrame(MerchantBuyBackItemItemButton, 0)

	MerchantBuyBackItemNameFrame:Hide()
	MerchantBuyBackItemName:SetHeight(25)
	MerchantBuyBackItemName:ClearAllPoints()
	MerchantBuyBackItemName:SetPoint("LEFT", MerchantBuyBackItemSlotTexture, "RIGHT", -5, 9)

	MerchantGuildBankRepairButton:SetPushedTexture("")
	MerchantGuildBankRepairButton:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)
	F.CreateBDFrame(MerchantGuildBankRepairButton)
	MerchantGuildBankRepairButtonIcon:SetTexCoord(0.595, 0.8075, 0.05, 0.52)

	MerchantRepairAllButton:SetPushedTexture("")
	MerchantRepairAllButton:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)
	F.CreateBDFrame(MerchantRepairAllButton)
	MerchantRepairAllIcon:SetTexCoord(0.31375, 0.53, 0.06, 0.52)

	MerchantRepairItemButton:SetPushedTexture("")
	MerchantRepairItemButton:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)
	F.CreateBDFrame(MerchantRepairItemButton)
	local ic = MerchantRepairItemButton:GetRegions()
	ic:SetTexture("Interface\\Icons\\INV_Hammer_20")
	ic:SetTexCoord(.08, .92, .08, .92)

	hooksecurefunc("MerchantFrame_UpdateCurrencies", function()
		for i = 1, MAX_MERCHANT_CURRENCIES do
			local bu = _G["MerchantToken"..i]
			if bu and not bu.reskinned then
				local ic = _G["MerchantToken"..i.."Icon"]
				local co = _G["MerchantToken"..i.."Count"]

				ic:SetTexCoord(.08, .92, .08, .92)
				ic:SetDrawLayer("OVERLAY")
				ic:SetPoint("LEFT", co, "RIGHT", 2, 0)
				co:SetPoint("TOPLEFT", bu, "TOPLEFT", -2, 0)

				F.CreateBDFrame(ic)
				bu.reskinned = true
			end
		end
	end)

	hooksecurefunc("MerchantFrame_UpdateRepairButtons", function()
		if CanGuildBankRepair() then
			MerchantRepairText:SetPoint("CENTER", MerchantFrame, "BOTTOMLEFT", 65, 73)
		end
	end)
end)