local _, ns = ...
local B, C, L, DB = unpack(ns)

local function Reskin_Slot(self, index)
	local button = _G[self..index]
	local icon = _G[self..index.."IconTexture"]

	if button and icon then
		B.StripTextures(button)

		local icbg = B.ReskinIcon(icon)
		B.ReskinHLTex(button, icbg)

		button.icbg = icbg
	end
end

tinsert(C.XMLThemes, function()
	local class = select(2, UnitClass("player"))
	if class ~= "HUNTER" then return end

	B.ReskinFrame(PetStableFrame)
	B.ReskinArrow(PetStablePrevPageButton, "left")
	B.ReskinArrow(PetStableNextPageButton, "right")
	B.ReskinArrow(PetStableModelRotateLeftButton, "left")
	B.ReskinArrow(PetStableModelRotateRightButton, "right")
	B.ReskinIcon(PetStableSelectedPetIcon)
	B.ReskinIcon(PetStableDietTexture)

	B.CreateBDFrame(PetStableModel)

	PetStableDietTexture:SetTexture("Interface\\Icons\\PetBattle_Health")
	PetStableModelShadow:Hide()
	PetStableModelRotateLeftButton:ClearAllPoints()
	PetStableModelRotateLeftButton:SetPoint("BOTTOMRIGHT", PetStableModel, "BOTTOM", -1, 2)
	PetStableModelRotateRightButton:ClearAllPoints()
	PetStableModelRotateRightButton:SetPoint("BOTTOMLEFT", PetStableModel, "BOTTOM", 1, 2)

	for i = 1, NUM_PET_ACTIVE_SLOTS do
		Reskin_Slot("PetStableActivePet", i)

		local button = _G["PetStableActivePet"..i]
		B.ReskinSpecialBorder(button.Checked, button.icbg)
	end

	for i = 1, NUM_PET_STABLE_SLOTS do
		Reskin_Slot("PetStableStabledPet", i)
	end
end)