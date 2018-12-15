local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	local class = select(2, UnitClass("player"))
	if class ~= "HUNTER" then return end

	F.ReskinPortraitFrame(PetStableFrame, true)
	F.StripTextures(PetStableLeftInset, true)
	F.StripTextures(PetStableBottomInset, true)
	F.ReskinArrow(PetStablePrevPageButton, "left")
	F.ReskinArrow(PetStableNextPageButton, "right")
	F.ReskinArrow(PetStableModelRotateLeftButton, "left")
	F.ReskinArrow(PetStableModelRotateRightButton, "right")

	F.CreateBDFrame(PetStableModel, .25)
	PetStableModelShadow:Hide()

	PetStableSelectedPetIcon:SetTexCoord(.08, .92, .08, .92)
	F.CreateBDFrame(PetStableSelectedPetIcon, .25)

	local function reskinSlot(button, i)
		local bu = _G[button..i]
		local ic = _G[button..i.."IconTexture"]

		if bu and ic then
			F.StripTextures(bu)

			ic:SetTexCoord(.08, .92, .08, .92)
			local bg = F.CreateBDFrame(bu, .25)

			bu:SetHighlightTexture(C.media.backdrop)
			local hl = bu:GetHighlightTexture()
			hl:SetVertexColor(1, 1, 1, .25)
			hl:SetPoint("TOPLEFT", bg, 1, -1)
			hl:SetPoint("BOTTOMRIGHT", bg, -1, 1)
		end
	end

	for i = 1, NUM_PET_ACTIVE_SLOTS do
		reskinSlot("PetStableActivePet", i)

		local bu = _G["PetStableActivePet"..i]
		bu.Checked:SetTexture(C.media.checked)
	end

	for i = 1, NUM_PET_STABLE_SLOTS do
		reskinSlot("PetStableStabledPet", i)
	end
end)