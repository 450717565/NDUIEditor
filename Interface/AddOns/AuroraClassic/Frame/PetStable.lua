local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	local class = select(2, UnitClass("player"))
	if class ~= "HUNTER" then return end

	F.ReskinFrame(PetStableFrame)
	F.ReskinArrow(PetStablePrevPageButton, "left")
	F.ReskinArrow(PetStableNextPageButton, "right")
	F.ReskinArrow(PetStableModelRotateLeftButton, "left")
	F.ReskinArrow(PetStableModelRotateRightButton, "right")
	F.ReskinIcon(PetStableSelectedPetIcon)

	F.CreateBDFrame(PetStableModel, 0)
	PetStableModelShadow:Hide()

	local function reskinSlot(button, i)
		local bu = _G[button..i]
		local ic = _G[button..i.."IconTexture"]

		if bu and ic then
			F.StripTextures(bu)

			local icbg = F.ReskinIcon(ic)
			F.ReskinTexture(bu, icbg)

			bu.bg = icbg
		end
	end

	for i = 1, NUM_PET_ACTIVE_SLOTS do
		reskinSlot("PetStableActivePet", i)

		local bu = _G["PetStableActivePet"..i]
		F.ReskinTexed(bu.Checked, bu.bg)
	end

	for i = 1, NUM_PET_STABLE_SLOTS do
		reskinSlot("PetStableStabledPet", i)
	end
end)