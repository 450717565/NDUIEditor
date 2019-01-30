local F, C = unpack(select(2, ...))

C.themes["Blizzard_InspectUI"] = function()
	F.ReskinFrame(InspectFrame)

	F.StripTextures(InspectModelFrame, true)
	F.StripTextures(InspectPVPFrame, true)
	F.StripTextures(InspectTalentFrame, true)
	InspectGuildFrameBG:Hide()

	F.ReskinButton(InspectPaperDollFrame.ViewButton)
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
		F.StripTextures(slot)

		local ic = F.ReskinIcon(slot.icon)
		F.ReskinTexture(slot, ic, false)

		local border = slot.IconBorder
		F.ReskinBorder(border, slot)
	end

	hooksecurefunc("InspectPaperDollItemSlotButton_Update", function(button)
		button.IconBorder:SetTexture(C.media.bdTex)
		button.icon:SetShown(button.hasItem)
	end)

	-- Talents
	local inspectSpec = InspectTalentFrame.InspectSpec
	inspectSpec.ring:Hide()
	F.ReskinIcon(inspectSpec.specIcon)

	for i = 1, 7 do
		local row = InspectTalentFrame.InspectTalents["tier"..i]
		for j = 1, 3 do
			local bu = row["talent"..j]
			F.StripTextures(bu)
			F.ReskinIcon(bu.icon)
			bu.icon:SetDrawLayer("ARTWORK")
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