local _, ns = ...
local B, C, L, DB = unpack(ns)
local Skins = B:GetModule("Skins")

function Skins:CompactVendorFilter()
	if not IsAddOnLoaded("CompactVendorFilter") then return end

	local button = VladsVendorFilterMenuButton
	B.ReskinArrow(button, "down")
	button:SetScale(1)
	button:ClearAllPoints()
	button:SetPoint("RIGHT", MerchantFrameCloseButton, "LEFT", -3, 0)
end