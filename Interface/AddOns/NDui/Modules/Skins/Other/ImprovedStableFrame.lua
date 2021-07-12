local _, ns = ...
local B, C, L, DB = unpack(ns)
local SKIN = B:GetModule("Skins")

function SKIN:ImprovedStableFrame()
	if not IsAddOnLoaded("ImprovedStableFrame") then return end

	B.StripTextures(ImprovedStableFrameSlots)
	B.ReskinInput(ISF_SearchInput, 20, 307)

	ISF_SearchInput:ClearAllPoints()
	ISF_SearchInput:SetPoint("TOP", ImprovedStableFrameSlots, "TOP", 0, -3)

	PetStableStabledPet1:ClearAllPoints()
	PetStableStabledPet1:SetPoint("TOPLEFT", ISF_SearchInput, "BOTTOMLEFT", -2, -5)

	for i = 1, NUM_PET_STABLE_SLOTS do
		local button = _G["PetStableStabledPet"..i]
		button:SetScale(1)
		button:SetSize(24, 24)
	end
end

C.OnLoginThemes["ImprovedStableFrame"] = SKIN.ImprovedStableFrame