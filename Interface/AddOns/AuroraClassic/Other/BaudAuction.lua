local F, C = unpack(select(2, ...))

C.themes["BaudAuction"] = function()
	F.StripTextures(BaudAuctionBrowseScrollBoxScrollBar)
	F.ReskinFrame(BaudAuctionProgress)
	F.ReskinScroll(BaudAuctionBrowseScrollBoxScrollBarScrollBar)

	BaudAuctionProgressBar:SetPoint("CENTER", 0, -5)
	F.ReskinStatusBar(BaudAuctionProgressBar)

	local boxHL = BaudAuctionBrowseScrollBoxHighlight
	boxHL:SetTexture(C.media.bdTex)
	boxHL:SetPoint("LEFT", 4, 0)
	boxHL:SetPoint("RIGHT", 10, 0)

	for i = 1, 7 do
		local col = _G["BaudAuctionFrameCol"..i]
		F.StripTextures(col)
		F.ReskinTexture(col, col, true)
	end

	for k = 1, 19 do
		F.ReskinIcon(_G["BaudAuctionBrowseScrollBoxEntry"..k.."Texture"], true)
	end
end