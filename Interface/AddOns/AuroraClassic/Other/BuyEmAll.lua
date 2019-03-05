local F, C = unpack(select(2, ...))

C.themes["BuyEmAll"] = function()
	F.ReskinFrame(BuyEmAllFrame)
	F.ReskinArrow(BuyEmAllLeftButton, "left")
	F.ReskinArrow(BuyEmAllRightButton, "right")

	BuyEmAllCurrencyFrame:ClearAllPoints()
	BuyEmAllCurrencyFrame:SetPoint("TOP", 0, -40)

	local buttons = {BuyEmAllOkayButton, BuyEmAllCancelButton, BuyEmAllStackButton, BuyEmAllMaxButton}
	for _, button in pairs(buttons) do
		F.ReskinButton(button)
	end

	hooksecurefunc(BuyEmAllFrame, "Show", function(self)
		self:ClearAllPoints()
		self:SetPoint("TOPLEFT", MerchantFrame, "TOPRIGHT", 4, 0)
	end)
end