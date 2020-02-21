local B, C, L, DB = unpack(select(2, ...))

C.themes["Blizzard_FlightMap"] = function()
	if IsAddOnLoaded("WorldFlightMap") then return end

	local BorderFrame = FlightMapFrame.BorderFrame

	local bg = B.ReskinFrame(BorderFrame)
	bg:SetParent(FlightMapFrame)
	bg:SetOutside(FlightMapFrame.ScrollContainer)

	local CloseButton = BorderFrame.CloseButton
	CloseButton:ClearAllPoints()
	CloseButton:SetPoint("TOPRIGHT", bg, -6, -6)

	local TitleText = BorderFrame.TitleText
	TitleText:ClearAllPoints()
	TitleText:SetPoint("TOP", bg, 0, -6)
end