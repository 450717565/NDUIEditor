local _, ns = ...
local B, C, L, DB = unpack(ns)

local function Reskin_UpdateRepairButtons()
	MerchantRepairAllButton:ClearAllPoints()
	MerchantRepairAllButton:SetPoint("BOTTOMLEFT", MerchantFrame, "BOTTOMLEFT", 70, 30)

	MerchantRepairItemButton:ClearAllPoints()
	MerchantRepairItemButton:SetPoint("RIGHT", MerchantRepairAllButton, "LEFT", -5, 0)

	MerchantGuildBankRepairButton:ClearAllPoints()
	MerchantGuildBankRepairButton:SetPoint("LEFT", MerchantRepairAllButton, "RIGHT", 5, 0)

	MerchantRepairText:Hide()
end

local function Reskin_UpdateCurrencies()
	local token = "MerchantToken"

	for index = 1, MAX_MERCHANT_CURRENCIES do
		local tokenButton = _G[token..index]
		if tokenButton and not tokenButton.styled then
			B.ReskinIcon(tokenButton.icon)

			if index > 1 then
				tokenButton:ClearAllPoints()
				tokenButton:SetPoint("RIGHT", _G[token..(index-1)], "LEFT", -15, 0)
			end

			tokenButton.count:ClearAllPoints()
			tokenButton.count:SetPoint("RIGHT", tokenButton.icon, "LEFT", 0, 0)

			tokenButton.styled = true
		end
	end
end

C.OnLoginThemes["MerchantFrame"] = function()
	B.ReskinFrame(MerchantFrame)
	B.ReskinFrameTab(MerchantFrame, 2)

	B.ReskinDropDown(MerchantFrameLootFilter)
	B.ReskinArrow(MerchantPrevPageButton, "left")
	B.ReskinArrow(MerchantNextPageButton, "right")

	local currencys = {"MerchantMoney", "MerchantExtraCurrency"}
	for _, frame in pairs(currencys) do
		local inset = _G[frame.."Inset"]
		B.StripTextures(inset)

		local bg = _G[frame.."Bg"]
		B.StripTextures(bg)
	end

	for i = 1, BUYBACK_ITEMS_PER_PAGE do
		local item = _G["MerchantItem"..i]
		B.ReskinMerchantItem(item)

		for j = 1, 3 do
			local texture = _G["MerchantItem"..i.."AltCurrencyFrameItem"..j.."Texture"]
			B.ReskinIcon(texture)
		end
	end

	B.ReskinMerchantItem(MerchantBuyBackItem)

	local RepairItem = MerchantRepairItemButton:GetRegions()
	RepairItem:SetTexture("Interface\\Icons\\INV_Hammer_17")

	local RepairAll = MerchantRepairAllButton:GetRegions()
	RepairAll:SetTexture("Interface\\Icons\\Ability_Repair")

	local RepairGuild = MerchantGuildBankRepairButton:GetRegions()
	RepairGuild:SetTexture("Interface\\Icons\\ACHIEVEMENT_GUILDPERK_CASHFLOW_RANK2")

	local buttons = {
		MerchantGuildBankRepairButton,
		MerchantRepairAllButton,
		MerchantRepairItemButton,
	}
	for _, button in pairs(buttons) do
		B.CleanTextures(button)
	end

	local repairs = {
		RepairAll,
		RepairGuild,
		RepairItem,
	}
	for _, repair in pairs(repairs) do
		local parent = repair:GetParent()
		local icbg = B.ReskinIcon(repair)

		B.ReskinHLTex(parent, icbg)
	end

	hooksecurefunc("MerchantFrame_UpdateCurrencies", Reskin_UpdateCurrencies)
	hooksecurefunc("MerchantFrame_UpdateMerchantInfo", B.UpdateMerchantInfo)
	hooksecurefunc("MerchantFrame_UpdateRepairButtons", Reskin_UpdateRepairButtons)
end