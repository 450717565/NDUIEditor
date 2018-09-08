local F, C = unpack(select(2, ...))

C.themes["Blizzard_FlightMap"] = function()
	F.StripTextures(FlightMapFrame, true)
	F.StripTextures(FlightMapFrame.BorderFrame, true)
	F.CreateBD(FlightMapFrame)
	F.CreateSD(FlightMapFrame)
	F.ReskinClose(FlightMapFrameCloseButton)
end