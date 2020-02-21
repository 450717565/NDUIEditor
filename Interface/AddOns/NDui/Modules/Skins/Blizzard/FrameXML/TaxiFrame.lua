local B, C, L, DB = unpack(select(2, ...))

tinsert(C.defaultThemes, function()
	local bg = B.ReskinFrame(TaxiFrame, "noKill")
	bg:SetOutside(TaxiRouteMap)

	local CloseButton = TaxiFrame.CloseButton
	CloseButton:ClearAllPoints()
	CloseButton:SetPoint("TOPRIGHT", bg, -6, -6)

	local TitleText = TaxiFrame.TitleText
	TitleText:ClearAllPoints()
	TitleText:SetPoint("TOP", bg, 0, -6)
end)