local B, C, L, DB = unpack(select(2, ...))
local Skins = B:GetModule("Skins")

function Skins:BuyEmAll()
	if not IsAddOnLoaded("BuyEmAll") then return end

	B.ReskinFrame(BuyEmAllFrame)
	B.ReskinArrow(BuyEmAllLeftButton, "left")
	B.ReskinArrow(BuyEmAllRightButton, "right")

	BuyEmAllCurrencyFrame:ClearAllPoints()
	BuyEmAllCurrencyFrame:SetPoint("TOP", 0, -40)

	local buttons = {BuyEmAllOkayButton, BuyEmAllCancelButton, BuyEmAllStackButton, BuyEmAllMaxButton}
	for _, button in pairs(buttons) do
		B.ReskinButton(button)
	end

	hooksecurefunc(BuyEmAllFrame, "Show", function(self)
		self:ClearAllPoints()
		self:SetPoint("TOPLEFT", MerchantFrame, "TOPRIGHT", 3, -25)
	end)
end