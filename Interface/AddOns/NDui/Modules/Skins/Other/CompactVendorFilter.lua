local _, ns = ...
local B, C, L, DB = unpack(ns)
local SKIN = B:GetModule("Skins")

function SKIN:CompactVendorFilter()
	if not IsAddOnLoaded("CompactVendorFilter") then return end

	local button = VladsVendorFilterMenuButton
	B.ReskinArrow(button, "down")
	button:SetScale(1)
	button:ClearAllPoints()
	button:SetPoint("RIGHT", MerchantFrameCloseButton, "LEFT", -3, 0)
end

C.OnLoginThemes["CompactVendorFilter"] = SKIN.CompactVendorFilter