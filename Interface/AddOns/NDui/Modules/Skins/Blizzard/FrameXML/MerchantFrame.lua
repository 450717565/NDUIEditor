local B, C, L, DB = unpack(select(2, ...))

tinsert(C.defaultThemes, function()
	B.ReskinFrame(MerchantFrame)
	B.SetupTabStyle(MerchantFrame, 2)

	B.ReskinDropDown(MerchantFrameLootFilter)
	B.ReskinArrow(MerchantPrevPageButton, "left")
	B.ReskinArrow(MerchantNextPageButton, "right")

	for _, frame in pairs({"MerchantMoney", "MerchantExtraCurrency"}) do
		local inset = _G[frame.."Inset"]
		B.StripTextures(inset)

		local bg = _G[frame.."Bg"]
		B.StripTextures(bg)
	end

	for i = 1, BUYBACK_ITEMS_PER_PAGE do
		B.ReskinMerchantItem(i)
	end

	local backIC = B.ReskinIcon(MerchantBuyBackItemItemButtonIconTexture)

	local backBU = MerchantBuyBackItemItemButton
	B.StripTextures(backBU)
	B.ReskinHighlight(backBU, backIC)
	backBU.IconBorder:SetAlpha(0)

	local backIT = MerchantBuyBackItem
	B.StripTextures(backIT)

	local itemBG = B.CreateBGFrame(backIT, 2, 0, 0, 0, backIC)

	local backName = MerchantBuyBackItemName
	backName:SetWordWrap(false)
	backName:ClearAllPoints()
	backName:SetPoint("TOPLEFT", itemBG, "TOPLEFT", 2, 4)

	local backMoney = MerchantBuyBackItemMoneyFrame
	backMoney:ClearAllPoints()
	backMoney:SetPoint("BOTTOMLEFT", itemBG, "BOTTOMLEFT", 2, 2)

	local RepairItem = MerchantRepairItemButton:GetRegions()
	RepairItem:SetTexture("Interface\\Icons\\INV_Hammer_17")

	local RepairAll = MerchantRepairAllButton:GetRegions()
	RepairAll:SetTexture("Interface\\Icons\\Ability_Repair")

	local RepairGuild = MerchantGuildBankRepairButton:GetRegions()
	RepairGuild:SetTexture("Interface\\Icons\\ACHIEVEMENT_GUILDPERK_CASHFLOW_RANK2")

	local buttons = {MerchantGuildBankRepairButton, MerchantRepairAllButton, MerchantRepairItemButton}
	for _, button in pairs(buttons) do
		B.CleanTextures(button)
	end

	local repairs = {RepairItem, RepairAll, RepairGuild}
	for _, repair in pairs(repairs) do
		local parent = repair:GetParent()
		local icbg = B.ReskinIcon(repair)

		B.ReskinHighlight(parent, icbg)
	end

	hooksecurefunc("MerchantFrame_UpdateMerchantInfo", B.UpdateMerchantInfo)

	hooksecurefunc("MerchantFrame_UpdateRepairButtons", function()
		MerchantRepairAllButton:ClearAllPoints()
		MerchantRepairAllButton:SetPoint("BOTTOMLEFT", MerchantFrame, "BOTTOMLEFT", 70, 30)

		MerchantRepairItemButton:ClearAllPoints()
		MerchantRepairItemButton:SetPoint("RIGHT", MerchantRepairAllButton, "LEFT", -5, 0)

		MerchantGuildBankRepairButton:ClearAllPoints()
		MerchantGuildBankRepairButton:SetPoint("LEFT", MerchantRepairAllButton, "RIGHT", 5, 0)

		MerchantRepairText:Hide()
	end)

	hooksecurefunc("MerchantFrame_UpdateCurrencies", function()
		local token = "MerchantToken"
		local currencies = {GetMerchantCurrencies()}

		if #currencies ~= 0 then
			local numCurrencies = #currencies
			for index = 1, numCurrencies do
				local tokenButton = _G[token..index]
				if tokenButton and not tokenButton.styled then
					B.ReskinIcon(tokenButton.icon)

					if index > 1 then
						tokenButton:ClearAllPoints()
						tokenButton:SetPoint("RIGHT", _G[token..(index-1)], "LEFT", -10, 0)
					end

					tokenButton.styled = true
				end
			end
		end
	end)
end)