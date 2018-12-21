local F, C = unpack(select(2, ...))

C.themes["Blizzard_FlightMap"] = function()
	F.StripTextures(FlightMapFrame.BorderFrame, true)
	F.ReskinPortraitFrame(FlightMapFrame, true)
end