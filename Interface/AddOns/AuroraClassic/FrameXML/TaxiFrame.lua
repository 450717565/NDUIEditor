local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	F.StripTextures(TaxiFrame, true)
	F.SetBD(TaxiFrame, 3, -23, -5, 3)
	F.ReskinClose(TaxiFrame.CloseButton, "TOPRIGHT", TaxiRouteMap, "TOPRIGHT", -6, -6)
end)