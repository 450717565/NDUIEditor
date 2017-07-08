if IsAddOnLoaded("Aurora") then
	local F = unpack(Aurora)
	F.ReskinScroll(BaudAuctionBrowseScrollBoxScrollBarScrollBar)
	F.CreateBD(BaudAuctionProgress)
	F.CreateSD(BaudAuctionProgress)
	--F.ReskinClose(BaudAuctionCancelButton)

	BaudAuctionProgressBar:SetPoint("CENTER", 12, -5)
	BaudAuctionProgressBarIcon:SetTexCoord(.08, .92, .08, .92)
	BaudAuctionProgressBarIcon:SetPoint("RIGHT", BaudAuctionProgressBar, "LEFT", -2, 0)
	BaudAuctionProgressBarBorder:Hide()
	F.ReskinStatusBar(BaudAuctionProgressBar)
	F.CreateBDFrame(BaudAuctionProgressBarIcon)

	for i = 1, 2 do
		select(i, BaudAuctionBrowseScrollBoxScrollBar:GetRegions()):Hide()
	end

	for k = 1, 19 do
		F.ReskinIcon(_G["BaudAuctionBrowseScrollBoxEntry"..k.."Texture"])
	end
end