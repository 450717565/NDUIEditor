local F, C = unpack(select(2, ...))

C.themes["Blizzard_InspectUI"] = function()
	F.ReskinFrame(InspectFrame)

	F.StripTextures(InspectModelFrame, true)
	F.StripTextures(InspectPVPFrame)
	F.StripTextures(InspectTalentFrame)

	F.SetupTabStyle(InspectFrame, 4)

	InspectGuildFrameBG:Hide()

	--InspectPaperDollFrame
	F.ReskinButton(InspectPaperDollFrame.ViewButton)
	InspectPaperDollFrame.ViewButton:ClearAllPoints()
	InspectPaperDollFrame.ViewButton:SetPoint("BOTTOM", InspectModelFrame, "TOP", 0, 0)

	local slots = {"Head", "Neck", "Shoulder", "Back", "Chest", "Shirt", "Tabard", "Wrist", "Hands", "Waist", "Legs", "Feet", "Finger0", "Finger1", "Trinket0", "Trinket1", "MainHand", "SecondaryHand"}
	for i = 1, #slots do
		local slot = _G["Inspect"..slots[i].."Slot"]
		F.StripTextures(slot)

		local icbg = F.ReskinIcon(slot.icon)
		F.ReskinTexture(slot, icbg)

		local border = slot.IconBorder
		F.ReskinBorder(border, slot)
	end

	hooksecurefunc("InspectPaperDollItemSlotButton_Update", function(button)
		button.icon:SetShown(button.hasItem)
	end)

	--InspectTalentFrame
	local inspectSpec = InspectTalentFrame.InspectSpec
	inspectSpec.ring:Hide()
	F.ReskinIcon(inspectSpec.specIcon)
	F.ReskinRoleIcon(inspectSpec.roleIcon)

	for i = 1, 7 do
		local row = InspectTalentFrame.InspectTalents["tier"..i]
		for j = 1, 3 do
			local bu = row["talent"..j]
			F.StripTextures(bu)
			F.ReskinIcon(bu.icon)
		end
	end

	local function updateIcon(self)
		local spec = nil
		if INSPECTED_UNIT ~= nil then
			spec = GetInspectSpecialization(INSPECTED_UNIT)
		end
		if spec ~= nil and spec > 0 then
			local role1 = GetSpecializationRoleByID(spec)
			if role1 ~= nil then
				local _, _, _, icon = GetSpecializationInfoByID(spec)
				self.specIcon:SetTexture(icon)
				self.roleIcon:SetTexCoord(F.GetRoleTexCoord(role1))
			end
		end
	end

	inspectSpec:HookScript("OnShow", updateIcon)
	InspectTalentFrame:HookScript("OnEvent", function(self, event, unit)
		if not InspectFrame:IsShown() then return end
		if event == "INSPECT_READY" and InspectFrame.unit and UnitGUID(InspectFrame.unit) == unit then
			updateIcon(self.InspectSpec)
		end
	end)
end