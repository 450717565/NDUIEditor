local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	select(2, MerchantPrevPageButton:GetRegions()):Hide()
	select(2, MerchantNextPageButton:GetRegions()):Hide()

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
		local item = _G["MerchantItem"..i]
		F.StripTextures(item, true)
		item.bg = F.CreateBDFrame(item, .25)
		item.bg:SetPoint("TOPLEFT", 40, 2)
		item.bg:SetPoint("BOTTOMRIGHT", 0, -2)

		local button = _G["MerchantItem"..i.."ItemButton"]
		F.StripTextures(button)
		button:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)
		button:SetSize(40, 40)
		button.IconBorder:SetAlpha(0)
		F.CreateBDFrame(button, .25)

		local b1, b2, b3 = button:GetPoint()
		button:SetPoint(b1, b2, b3, -4, -2)

		local ic = button.icon
		ic:SetTexCoord(.08, .92, .08, .92)

		local name = _G["MerchantItem"..i.."Name"]
		local n1, n2, n3 = name:GetPoint()
		name:SetPoint(n1, n2, n3, -10, 5)

		local money = _G["MerchantItem"..i.."MoneyFrame"]
		local m1, m2, m3, m4, m5 = money:GetPoint()
		money:SetPoint(m1, m2, m3, m4-2, m5)

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

	F.StripTextures(MerchantBuyBackItem, true)
	F.CreateBDFrame(MerchantBuyBackItem, .25)
	F.StripTextures(MerchantBuyBackItemItemButton)
	MerchantBuyBackItemItemButton:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)
	MerchantBuyBackItemItemButtonIconTexture:SetTexCoord(.08, .92, .08, .92)
	MerchantBuyBackItemItemButton.IconBorder:SetAlpha(0)
	F.CreateBDFrame(MerchantBuyBackItemItemButton, .25)

	local backName = MerchantBuyBackItemName
	backName:SetWordWrap(false)
	backName:ClearAllPoints()
	backName:SetPoint("TOPLEFT", MerchantBuyBackItemItemButton, "TOPRIGHT", 3, 5)
	local backMoney = MerchantBuyBackItemMoneyFrame
	backMoney:ClearAllPoints()
	backMoney:SetPoint("BOTTOMLEFT", MerchantBuyBackItemItemButton, "BOTTOMRIGHT", 3, 1)

	MerchantGuildBankRepairButton:SetPushedTexture("")
	MerchantGuildBankRepairButton:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)
	F.CreateBDFrame(MerchantGuildBankRepairButton, .25)
	MerchantGuildBankRepairButtonIcon:SetTexCoord(0.595, 0.8075, 0.05, 0.52)

	MerchantRepairAllButton:SetPushedTexture("")
	MerchantRepairAllButton:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)
	F.CreateBDFrame(MerchantRepairAllButton, .25)
	MerchantRepairAllIcon:SetTexCoord(0.31375, 0.53, 0.06, 0.52)

	MerchantRepairItemButton:SetPushedTexture("")
	MerchantRepairItemButton:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)
	F.CreateBDFrame(MerchantRepairItemButton, .25)
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

				F.CreateBDFrame(ic, .25)
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