local B, C, L, DB = unpack(select(2, ...))

tinsert(C.defaultThemes, function()
	local class = select(2, UnitClass("player"))
	if class ~= "HUNTER" then return end

	B.ReskinFrame(PetStableFrame)
	B.ReskinArrow(PetStablePrevPageButton, "left")
	B.ReskinArrow(PetStableNextPageButton, "right")
	B.ReskinArrow(PetStableModelRotateLeftButton, "left")
	B.ReskinArrow(PetStableModelRotateRightButton, "right")
	B.ReskinIcon(PetStableSelectedPetIcon)

	B.CreateBDFrame(PetStableModel, 0)
	PetStableModelShadow:Hide()

	local function reskinSlot(button, i)
		local bu = _G[button..i]
		local ic = _G[button..i.."IconTexture"]

		if bu and ic then
			B.StripTextures(bu)

			local icbg = B.ReskinIcon(ic)
			B.ReskinHighlight(bu, icbg)

			bu.icbg = icbg
		end
	end

	for i = 1, NUM_PET_ACTIVE_SLOTS do
		reskinSlot("PetStableActivePet", i)

		local bu = _G["PetStableActivePet"..i]
		B.ReskinChecked(bu.Checked, bu.icbg)
	end

	for i = 1, NUM_PET_STABLE_SLOTS do
		reskinSlot("PetStableStabledPet", i)
	end
end)