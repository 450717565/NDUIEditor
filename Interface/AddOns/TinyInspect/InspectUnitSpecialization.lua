
-------------------------------------
-- 顯示天賦信息
-- @Author: M
-- @DepandsOn: InspectUnit.lua
-------------------------------------
local B, C, L, DB = unpack(NDui)

hooksecurefunc("ShowInspectItemListFrame", function(unit, parent, itemLevel, maxLevel)
	local frame = parent.inspectFrame
	if (not frame) then return end
	if (not frame.specicon) then
		frame.specicon = frame:CreateTexture(nil, "BORDER")
		frame.specicon:SetSize(42, 42)
		frame.specicon:SetPoint("TOPRIGHT", -16, -15)
		frame.specicon:SetMask("Interface\\Minimap\\UI-Minimap-Background")
		frame.spectext = B.CreateFS(frame, 10, "")
		frame.spectext:ClearAllPoints()
		frame.spectext:SetPoint("BOTTOM", frame.specicon, "BOTTOM")
		frame.spectext:SetJustifyH("CENTER")
	end
	local _, specID, specName, specIcon
	if (unit == "player") then
		specID = GetSpecialization()
		_, specName, _, specIcon = GetSpecializationInfo(specID)
	else
		specID = GetInspectSpecialization(unit)
		_, specName, _, specIcon = GetSpecializationInfoByID(specID)
	end
	if (specIcon) then
		frame.spectext:SetText(specName)
		frame.specicon:SetTexture(specIcon)
		frame.specicon:Show()
	else
		frame.spectext:SetText("")
		frame.specicon:Hide()
	end
end)
