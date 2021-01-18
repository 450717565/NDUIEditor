local _, ns = ...
local B, C, L, DB = unpack(ns)

C.LUAThemes["Blizzard_FlightMap"] = function()
	if IsAddOnLoaded("WorldFlightMap") then return end

	local BorderFrame = FlightMapFrame.BorderFrame

	local bg = B.ReskinFrame(BorderFrame)
	bg:SetParent(FlightMapFrame)
	bg:SetOutside(FlightMapFrame.ScrollContainer)

	local TitleText = BorderFrame.TitleText
	TitleText:ClearAllPoints()
	TitleText:SetPoint("TOP", bg, 0, -6)
end