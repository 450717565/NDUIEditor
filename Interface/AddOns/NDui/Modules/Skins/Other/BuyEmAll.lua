local _, ns = ...
local B, C, L, DB = unpack(ns)
local SKIN = B:GetModule("Skins")

local function Update_FrameAnchor(self)
	B.UpdatePoint(self, "TOPLEFT", MerchantFrame, "TOPRIGHT", 3, -25)
end

local function Update_MoneyFrame(self)
	if self.AltCurrencyMode == false then
		BuyEmAllCurrency1:SetTexture("Interface\\Icons\\INV_Misc_Coin_01")
		BuyEmAllCurrency2:SetTexture("Interface\\Icons\\INV_Misc_Coin_03")
		BuyEmAllCurrency3:SetTexture("Interface\\Icons\\INV_Misc_Coin_05")
	end

	BuyEmAllCurrency1.icbg:SetShown(BuyEmAllCurrency1:GetTexture() ~= nil)
	BuyEmAllCurrency2.icbg:SetShown(BuyEmAllCurrency2:GetTexture() ~= nil)
	BuyEmAllCurrency3.icbg:SetShown(BuyEmAllCurrency3:GetTexture() ~= nil)
end

function SKIN:BuyEmAll()
	if not IsAddOnLoaded("BuyEmAll") then return end

	B.ReskinFrame(BuyEmAllFrame)
	B.ReskinArrow(BuyEmAllLeftButton, "left")
	B.ReskinArrow(BuyEmAllRightButton, "right")
	B.UpdatePoint(BuyEmAllCurrencyFrame, "TOP", BuyEmAllFrame, "TOP", 0, -40)

	local buttons = {
		BuyEmAllCancelButton,
		BuyEmAllMaxButton,
		BuyEmAllOkayButton,
		BuyEmAllStackButton,
	}
	for _, button in pairs(buttons) do
		B.ReskinButton(button)
	end

	for i = 1, 3 do
		local currency = _G["BuyEmAllCurrency"..i]
		currency.icbg = B.ReskinIcon(currency)
	end

	hooksecurefunc(BuyEmAllFrame, "Show", Update_FrameAnchor)
	hooksecurefunc(BuyEmAll, "UpdateDisplay", Update_MoneyFrame)
end

C.OnLoginThemes["BuyEmAll"] = SKIN.BuyEmAll