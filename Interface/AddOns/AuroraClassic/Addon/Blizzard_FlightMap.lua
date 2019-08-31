local F, C = unpack(select(2, ...))

C.themes["Blizzard_FlightMap"] = function()
	local BorderFrame = FlightMapFrame.BorderFrame

	local bg = F.ReskinFrame(BorderFrame)
	bg:SetParent(FlightMapFrame)
	bg:SetPoint("TOPLEFT", 0, -18)
	bg:SetPoint("BOTTOMRIGHT", 0, -C.mult/2)

	local CloseButton = BorderFrame.CloseButton
	CloseButton:ClearAllPoints()
	CloseButton:SetPoint("TOPRIGHT", bg, -6, -6)

	local TitleText = BorderFrame.TitleText
	TitleText:ClearAllPoints()
	TitleText:SetPoint("TOP", bg, 0, -6)
end