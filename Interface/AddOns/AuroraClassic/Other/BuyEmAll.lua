local F, C = unpack(select(2, ...))

C.themes["BuyEmAll"] = function()
	F.ReskinFrame(BuyEmAllFrame)
	F.ReskinArrow(BuyEmAllLeftButton, "left")
	F.ReskinArrow(BuyEmAllRightButton, "right")
	BuyEmAllCurrencyFrame:ClearAllPoints()
	BuyEmAllCurrencyFrame:SetPoint("TOP", 0, -40)

	local lists = {BuyEmAllOkayButton, BuyEmAllCancelButton, BuyEmAllStackButton, BuyEmAllMaxButton}
	for _, list in next, lists do
		F.ReskinButton(list)
	end
end