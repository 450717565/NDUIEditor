local B, C, L, DB = unpack(select(2, ...))

C.themes["Blizzard_InspectUI"] = function()
	local slots = DB.Slots

	B.ReskinFrame(InspectFrame)
	B.ReskinFrameTab(InspectFrame, 4)

	B.StripTextures(InspectModelFrame, 0)
	B.StripTextures(InspectModelFrameControlFrame)
	B.StripTextures(InspectPVPFrame)
	B.StripTextures(InspectTalentFrame)

	InspectGuildFrameBG:Hide()

	--InspectPaperDollFrame
	B.ReskinButton(InspectPaperDollFrame.ViewButton)
	InspectPaperDollFrame.ViewButton:ClearAllPoints()
	InspectPaperDollFrame.ViewButton:SetPoint("BOTTOM", InspectModelFrame, "TOP", 0, 0)

	local function UpdateCorruption(self)
		local unit = InspectFrame.unit
		local itemLink = unit and GetInventoryItemLink(unit, self:GetID())
		self.Eye:SetShown(itemLink and IsCorruptedItem(itemLink))
		self.HL:SetShown(itemLink and IsCorruptedItem(itemLink))
	end

	for i = 1, #slots do
		local slot = _G["Inspect"..slots[i].."Slot"]
		B.StripTextures(slot)

		local icbg = B.ReskinIcon(slot.icon)
		B.ReskinHighlight(slot, icbg)

		local border = slot.IconBorder
		B.ReskinBorder(border, icbg)

		if not slot.Eye then
			slot.Eye = slot:CreateTexture(nil, "OVERLAY")
			slot.Eye:SetAtlas("Nzoth-inventory-icon")
			slot.Eye:SetInside(icbg)
		end

		if not slot.HL then
			slot.HL = slot:CreateTexture(nil, "OVERLAY")
			slot.HL:SetAtlas("Nzoth-charactersheet-item-glow")
			slot.HL:ClearAllPoints()
			slot.HL:Point("TOPLEFT", icbg, -15, 15)
			slot.HL:Point("BOTTOMRIGHT", icbg, 14, -14)
		end
	end

	hooksecurefunc("InspectPaperDollItemSlotButton_Update", function(button)
		button.icon:SetShown(button.hasItem)
		UpdateCorruption(button)
	end)

	--InspectTalentFrame
	local InspectSpec = InspectTalentFrame.InspectSpec
	InspectSpec.ring:Hide()
	B.ReskinIcon(InspectSpec.specIcon)
	B.ReskinRoleIcon(InspectSpec.roleIcon)

	for i = 1, 7 do
		local row = InspectTalentFrame.InspectTalents["tier"..i]
		for j = 1, 3 do
			local bu = row["talent"..j]
			B.StripTextures(bu)
			B.ReskinIcon(bu.icon)
		end
	end

	local function updateIcon(self)
		local spec = nil
		if INSPECTED_UNIT ~= nil then
			spec = GetInspectSpecialization(INSPECTED_UNIT)
		end
		if spec ~= nil and spec > 0 then
			local role = GetSpecializationRoleByID(spec)
			if role ~= nil then
				local _, _, _, icon = GetSpecializationInfoByID(spec)
				self.specIcon:SetTexture(icon)
				self.roleIcon:SetTexCoord(B.GetRoleTexCoord(role))
			end
		end
	end

	InspectSpec:HookScript("OnShow", updateIcon)
	InspectTalentFrame:HookScript("OnEvent", function(self, event, unit)
		if not InspectFrame:IsShown() then return end
		if event == "INSPECT_READY" and InspectFrame.unit and UnitGUID(InspectFrame.unit) == unit then
			updateIcon(self.InspectSpec)
		end
	end)
end