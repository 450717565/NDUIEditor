local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	function F.ReskinMerchantItem(x)
		local frame = "MerchantItem"..x

		local item = _G[frame]
		F.StripTextures(item)

		local button = _G[frame.."ItemButton"]
		F.StripTextures(button)
		F.ReskinBorder(button.IconBorder, button)

		local icbg = F.ReskinIcon(button.icon)
		F.ReskinTexture(button, icbg, false)

		local name = _G[frame.."Name"]
		name:SetWordWrap(false)
		name:ClearAllPoints()
		name:SetPoint("TOPLEFT", icbg, "TOPRIGHT", 4, 2)

		local money = _G[frame.."MoneyFrame"]
		money:ClearAllPoints()
		money:SetPoint("BOTTOMLEFT", icbg, "BOTTOMRIGHT", 4, 2)

		for y = 1, 3 do
			F.ReskinIcon(_G[frame.."AltCurrencyFrameItem"..y.."Texture"], true)
		end
	end

	F.ReskinFrame(MerchantFrame)
	F.SetupTabStyle(MerchantFrame, 2)

	F.ReskinDropDown(MerchantFrameLootFilter)
	F.ReskinArrow(MerchantPrevPageButton, "left")
	F.ReskinArrow(MerchantNextPageButton, "right")

	for _, frame in pairs({"MerchantMoney", "MerchantExtraCurrency"}) do
		local inset = _G[frame.."Inset"]
		F.StripTextures(inset)

		local bg = _G[frame.."Bg"]
		F.StripTextures(bg)
	end

	for i = 1, BUYBACK_ITEMS_PER_PAGE do
		F.ReskinMerchantItem(i)
	end

	local backIC = F.ReskinIcon(MerchantBuyBackItemItemButtonIconTexture)

	local backBU = MerchantBuyBackItemItemButton
	F.StripTextures(backBU)
	F.ReskinTexture(backBU, backIC, false)
	backBU.IconBorder:SetAlpha(0)

	local backIT = MerchantBuyBackItem
	F.StripTextures(backIT)

	local itemBG = F.CreateBDFrame(backIT, 0)
	itemBG:SetPoint("TOPLEFT", backIC, "TOPRIGHT", 2, 0)
	itemBG:SetPoint("BOTTOMRIGHT", 0, -1.5)

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
		F.CleanTextures(button)
	end

	local repairs = {RepairItem, RepairAll, RepairGuild}
	for _, repair in pairs(repairs) do
		local parent = repair:GetParent()
		local icbg = F.ReskinIcon(repair)

		F.ReskinTexture(parent, icbg, false)
	end

	hooksecurefunc("MerchantFrame_UpdateMerchantInfo", function()
		for i = 1, MERCHANT_ITEMS_PER_PAGE do
			local money = _G["MerchantItem"..i.."MoneyFrame"]
			local currency = _G["MerchantItem"..i.."AltCurrencyFrame"]

			currency:ClearAllPoints()
			currency:SetPoint("LEFT", money, "LEFT", 0, 2)
		end
	end)

	hooksecurefunc("MerchantFrame_UpdateRepairButtons", function()
		MerchantRepairAllButton:ClearAllPoints()
		MerchantRepairAllButton:SetPoint("BOTTOMLEFT", MerchantFrame, "BOTTOMLEFT", 70, 30)

		MerchantRepairItemButton:ClearAllPoints()
		MerchantRepairItemButton:SetPoint("RIGHT", MerchantRepairAllButton, "LEFT", -5, 0)

		MerchantGuildBankRepairButton:ClearAllPoints()
		MerchantGuildBankRepairButton:SetPoint("LEFT", MerchantRepairAllButton, "RIGHT", 5, 0)

		MerchantRepairText:Hide()
	end)
end)