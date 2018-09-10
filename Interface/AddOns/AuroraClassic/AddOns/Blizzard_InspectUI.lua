local F, C = unpack(select(2, ...))

C.themes["Blizzard_InspectUI"] = function()
	F.ReskinPortraitFrame(InspectFrame, true)

	F.StripTextures(InspectModelFrame, true)
	F.StripTextures(InspectPVPFrame, true)
	F.StripTextures(InspectTalentFrame, true)
	InspectGuildFrameBG:Hide()

	F.Reskin(InspectPaperDollFrame.ViewButton)
	InspectPaperDollFrame.ViewButton:ClearAllPoints()
	InspectPaperDollFrame.ViewButton:SetPoint("TOP", InspectFrame, 0, -44)

	-- Character
	local slots = {
		"Head", "Neck", "Shoulder", "Shirt", "Chest", "Waist", "Legs", "Feet", "Wrist",
		"Hands", "Finger0", "Finger1", "Trinket0", "Trinket1", "Back", "MainHand",
		"SecondaryHand", "Tabard",
	}

	for i = 1, #slots do
		local slot = _G["Inspect"..slots[i].."Slot"]
		local border = slot.IconBorder

		F.StripTextures(slot)

		slot:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)

		border:SetPoint("TOPLEFT", -1.2, 1.2)
		border:SetPoint("BOTTOMRIGHT", 1.2, -1.2)
		border:SetDrawLayer("BACKGROUND")
		F.CreateBDFrame(slot, .25)
		slot.icon:SetTexCoord(.08, .92, .08, .92)
	end

	hooksecurefunc("InspectPaperDollItemSlotButton_Update", function(button)
		button.IconBorder:SetTexture(C.media.backdrop)
		button.icon:SetShown(button.hasItem)
	end)

	-- Talents
	local inspectSpec = InspectTalentFrame.InspectSpec
	inspectSpec.ring:Hide()

	for i = 1, 7 do
		local row = InspectTalentFrame.InspectTalents["tier"..i]
		for j = 1, 3 do
			local bu = row["talent"..j]

			F.StripTextures(bu)

			bu.icon:SetDrawLayer("ARTWORK")
			bu.icon:SetTexCoord(.08, .92, .08, .92)

			F.CreateBDFrame(bu.icon, .25)
		end
	end

	inspectSpec.specIcon:SetTexCoord(.08, .92, .08, .92)
	F.CreateBDFrame(inspectSpec.specIcon, .25)

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

	for i = 1, 4 do
		local tab = _G["InspectFrameTab"..i]
		F.ReskinTab(tab)
		if i ~= 1 then
			tab:SetPoint("LEFT", _G["InspectFrameTab"..i-1], "RIGHT", -15, 0)
		end
	end
end