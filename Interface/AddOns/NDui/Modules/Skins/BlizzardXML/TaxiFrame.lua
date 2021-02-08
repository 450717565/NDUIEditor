local _, ns = ...
local B, C, L, DB = unpack(ns)

tinsert(C.XMLThemes, function()
	local bg = B.ReskinFrame(TaxiFrame, "none")
	bg:SetOutside(TaxiRouteMap)

	local TitleText = TaxiFrame.TitleText
	TitleText:ClearAllPoints()
	TitleText:SetPoint("TOP", bg, 0, -6)
end)