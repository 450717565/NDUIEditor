local F, C = unpack(select(2, ...))

C.themes["Blizzard_FlightMap"] = function()
	F.StripTextures(FlightMapFrame.BorderFrame)
	F.CreateBD(FlightMapFrame)
	F.CreateSD(FlightMapFrame)
	FlightMapFramePortrait:Hide()
	F.ReskinClose(FlightMapFrameCloseButton)
	FlightMapFrameBg:Hide()
	FlightMapFrame.ScrollContainer.Child.TiledBackground:Hide()
end