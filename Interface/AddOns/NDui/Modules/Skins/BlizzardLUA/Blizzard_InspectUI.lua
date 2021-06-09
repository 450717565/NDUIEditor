local _, ns = ...
local B, C, L, DB = unpack(ns)

local slots = DB.Slots

local function Update_Cosmetic(self)
	local unit = InspectFrame.unit
	local itemLink = unit and GetInventoryItemLink(unit, self:GetID())
	self.IconOverlay:SetShown(itemLink and IsCosmeticItem(itemLink))
end

local function Update_InspectPaperDollItemSlotButton(button)
	button.icon:SetShown(button.hasItem)
	Update_Cosmetic(button)
end

local function Update_InspectSpecIcon(self)
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

local function Update_InspectTalentFrame(self, event, unit)
	if not InspectFrame:IsShown() then return end
	if event == "INSPECT_READY" and InspectFrame.unit and UnitGUID(InspectFrame.unit) == unit then
		Update_InspectSpecIcon(self.InspectSpec)
	end
end

C.LUAThemes["Blizzard_InspectUI"] = function()
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

	for i = 1, #slots do
		local slot = _G["Inspect"..slots[i].."Slot"]
		B.StripTextures(slot)

		local icbg = B.ReskinIcon(slot.icon)
		B.ReskinHLTex(slot, icbg)

		local border = slot.IconBorder
		B.ReskinBorder(border, icbg)

		local overlay = slot.IconOverlay
		overlay:SetAtlas("CosmeticIconFrame")
		overlay:SetInside(icbg)
	end

	--InspectTalentFrame
	local InspectSpec = InspectTalentFrame.InspectSpec
	InspectSpec.ring:Hide()
	B.ReskinIcon(InspectSpec.specIcon)
	B.ReskinRoleIcon(InspectSpec.roleIcon)
	B.ReskinText(InspectSpec.roleName, 1, 1, 1)

	for i = 1, 7 do
		local row = InspectTalentFrame.InspectTalents["tier"..i]
		for j = 1, 3 do
			local bu = row["talent"..j]
			B.StripTextures(bu)
			B.ReskinIcon(bu.icon)
		end
	end

	InspectSpec:HookScript("OnShow", Update_InspectSpecIcon)
	InspectTalentFrame:HookScript("OnEvent", Update_InspectTalentFrame)
end