local _, ns = ...
local B, C, L, DB = unpack(ns)

local function Reskin_Slot(self, index)
	local button = _G[self..index]
	local icon = _G[self..index.."IconTexture"]

	if button and icon then
		B.StripTextures(button)

		local icbg = B.ReskinIcon(icon)
		B.ReskinHLTex(button, icbg)
		B.ReskinCPTex(button, icbg)

		button.icbg = icbg
	end
end

C.OnLoginThemes["PetStableFrame"] = function()
	if DB.MyClass ~= "HUNTER" then return end

	B.ReskinFrame(PetStableFrame)
	B.ReskinArrow(PetStablePrevPageButton, "left")
	B.ReskinArrow(PetStableNextPageButton, "right")
	B.ReskinArrow(PetStableModelRotateLeftButton, "left")
	B.ReskinArrow(PetStableModelRotateRightButton, "right")
	B.ReskinIcon(PetStableSelectedPetIcon)
	B.ReskinIcon(PetStableDietTexture)

	B.StripTextures(PetStableModel)
	B.CreateBDFrame(PetStableModel, 0, -C.mult)

	PetStableModelShadow:Hide()

	PetStableDiet:SetSize(24, 24)
	PetStableDietTexture:SetTexture("Interface\\Icons\\PetBattle_Health")

	PetStableModelRotateLeftButton:ClearAllPoints()
	PetStableModelRotateLeftButton:SetPoint("BOTTOMRIGHT", PetStableModel, "BOTTOM", -1, 2)
	PetStableModelRotateRightButton:ClearAllPoints()
	PetStableModelRotateRightButton:SetPoint("BOTTOMLEFT", PetStableModel, "BOTTOM", 1, 2)

	PetStableDiet:ClearAllPoints()
	PetStableDiet:SetPoint("BOTTOMRIGHT", PetStableModel, "TOPRIGHT", 0, 5)
	PetStableSelectedPetIcon:ClearAllPoints()
	PetStableSelectedPetIcon:SetPoint("BOTTOMLEFT", PetStableModel, "TOPLEFT", 0, 5)

	PetStableNameText:SetJustifyH("LEFT")
	PetStableNameText:ClearAllPoints()
	PetStableNameText:SetPoint("BOTTOMLEFT", PetStableSelectedPetIcon, "RIGHT", 3, 1)
	PetStableTypeText:SetJustifyH("LEFT")
	PetStableTypeText:ClearAllPoints()
	PetStableTypeText:SetPoint("TOPLEFT", PetStableSelectedPetIcon, "RIGHT", 3, -1)

	for i = 1, NUM_PET_ACTIVE_SLOTS do
		Reskin_Slot("PetStableActivePet", i)

		local button = _G["PetStableActivePet"..i]
		B.ReskinBGBorder(button.Checked, button.icbg)

		local petName = _G["PetStableActivePet"..i.."PetName"]
		petName:ClearAllPoints()
		petName:SetPoint("BOTTOM", button, "TOP", 0, 1)
	end

	for i = 1, NUM_PET_STABLE_SLOTS do
		Reskin_Slot("PetStableStabledPet", i)
	end
end