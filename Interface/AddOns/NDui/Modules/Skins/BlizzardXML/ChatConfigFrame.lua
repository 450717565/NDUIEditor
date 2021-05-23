local _, ns = ...
local B, C, L, DB = unpack(ns)

local function Reskin_UpdateWidth(self)
	for tab in self.tabPool:EnumerateActive() do
		if not tab.styled then
			B.StripTextures(tab)
			B.CreateBGFrame(tab, 1, -10, -1, 0)

			tab.styled = true
		end
	end
end

local function Reskin_CreateCheckboxes(frame, checkBoxTable)
	if not frame.styled then
		B.StripTextures(frame)

		local nameString = frame:GetDebugName().."CheckBox"
		for index in pairs(checkBoxTable) do
			local buttonName = nameString..index

			local button = _G[buttonName]
			B.StripTextures(button)
			B.CreateBDFrame(button, 0, 1)

			local check = _G[buttonName.."Check"]
			B.ReskinCheck(check)

			local swatch = _G[buttonName.."ColorSwatch"]
			if swatch then
				B.ReskinColorSwatch(swatch)
			end
		end

		frame.styled = true
	end
end

local function Reskin_CreateTieredCheckboxes(frame, checkBoxTable)
	if not frame.styled then
		B.StripTextures(frame)

		local nameString = frame:GetDebugName().."CheckBox"
		for index, value in pairs(checkBoxTable) do
			local buttonName = nameString..index
			local check = _G[buttonName]
			B.ReskinCheck(check)

			if value.subTypes then
				for i in pairs(value.subTypes) do
					local checks = _G[buttonName.."_"..i]
					B.ReskinCheck(checks)
				end
			end
		end

		frame.styled = true
	end
end

local function Reskin_CreateColorSwatches(frame, swatchTable)
	if not frame.styled then
		B.StripTextures(frame)

		local nameString = frame:GetDebugName().."Swatch"
		for index in pairs(swatchTable) do
			local buttonName = frame:GetDebugName().."Swatch"..index
			local button = _G[buttonName]
			local swatch = _G[buttonName.."ColorSwatch"]

			B.StripTextures(button)
			B.CreateBDFrame(button, 0, 1)
			B.ReskinColorSwatch(swatch)
		end

		frame.styled = true
	end
end

tinsert(C.XMLThemes, function()
	B.ReskinFrame(ChatConfigFrame)

	B.ReskinArrow(ChatConfigMoveFilterUpButton, "up")
	B.ReskinArrow(ChatConfigMoveFilterDownButton, "down")

	B.ReskinInput(CombatConfigSettingsNameEditBox)
	B.ReskinRadio(CombatConfigColorsColorizeEntireLineBySource)
	B.ReskinRadio(CombatConfigColorsColorizeEntireLineByTarget)
	B.ReskinColorSwatch(CombatConfigColorsColorizeSpellNamesColorSwatch)
	B.ReskinColorSwatch(CombatConfigColorsColorizeDamageNumberColorSwatch)
	B.ReskinScroll(ChatConfigCombatSettingsFiltersScrollFrameScrollBar)
	B.CreateBGFrame(ChatConfigCombatSettingsFilters, 3, -3, 0, 2)

	ChatConfigMoveFilterUpButton:SetSize(26, 26)
	ChatConfigMoveFilterDownButton:SetSize(26, 26)

	ChatConfigFrameRedockButton:ClearAllPoints()
	ChatConfigFrameRedockButton:SetPoint("LEFT", ChatConfigFrameDefaultButton, "RIGHT", 1, 0)
	ChatConfigCombatSettingsFiltersAddFilterButton:ClearAllPoints()
	ChatConfigCombatSettingsFiltersAddFilterButton:SetPoint("RIGHT", ChatConfigCombatSettingsFiltersDeleteButton, "LEFT", -1, 0)
	ChatConfigCombatSettingsFiltersCopyFilterButton:ClearAllPoints()
	ChatConfigCombatSettingsFiltersCopyFilterButton:SetPoint("RIGHT", ChatConfigCombatSettingsFiltersAddFilterButton, "LEFT", -1, 0)
	ChatConfigMoveFilterUpButton:ClearAllPoints()
	ChatConfigMoveFilterUpButton:SetPoint("TOPLEFT", ChatConfigCombatSettingsFilters, "BOTTOMLEFT", 3, 0)
	ChatConfigMoveFilterDownButton:ClearAllPoints()
	ChatConfigMoveFilterDownButton:SetPoint("LEFT", ChatConfigMoveFilterUpButton, "RIGHT", 1, 0)

	local lists = {
		ChatConfigBackgroundFrame,
		ChatConfigCategoryFrame,
		ChatConfigCombatSettingsFilters,
	}
	for _, list in pairs(lists) do
		B.StripTextures(list)
	end

	local buttons = {
		ChatConfigCombatSettingsFiltersAddFilterButton,
		ChatConfigCombatSettingsFiltersCopyFilterButton,
		ChatConfigCombatSettingsFiltersDeleteButton,
		ChatConfigFrameDefaultButton,
		ChatConfigFrameOkayButton,
		ChatConfigFrameRedockButton,
		CombatConfigSettingsSaveButton,
		CombatLogDefaultButton,
	}
	for _, button in pairs(buttons) do
		B.ReskinButton(button)
	end

	local checks = {
		CombatConfigColorsColorizeDamageNumberCheck,
		CombatConfigColorsColorizeDamageNumberSchoolColoring,
		CombatConfigColorsColorizeDamageSchoolCheck,
		CombatConfigColorsColorizeEntireLineCheck,
		CombatConfigColorsColorizeSpellNamesCheck,
		CombatConfigColorsColorizeSpellNamesSchoolColoring,
		CombatConfigColorsColorizeUnitNameCheck,
		CombatConfigColorsHighlightingAbility,
		CombatConfigColorsHighlightingDamage,
		CombatConfigColorsHighlightingLine,
		CombatConfigColorsHighlightingSchool,
		CombatConfigFormattingFullText,
		CombatConfigFormattingItemNames,
		CombatConfigFormattingShowBraces,
		CombatConfigFormattingShowTimeStamp,
		CombatConfigFormattingSpellNames,
		CombatConfigFormattingUnitNames,
		CombatConfigSettingsParty,
		CombatConfigSettingsRaid,
		CombatConfigSettingsShowQuickButton,
		CombatConfigSettingsSolo,
	}
	for _, check in pairs(checks) do
		B.ReskinCheck(check)
	end

	local frames = {
		CombatConfigColorsColorizeDamageNumber,
		CombatConfigColorsColorizeDamageSchool,
		CombatConfigColorsColorizeEntireLine,
		CombatConfigColorsColorizeSpellNames,
		CombatConfigColorsColorizeUnitName,
		CombatConfigColorsHighlighting,
	}
	for _, frame in pairs(frames) do
		B.StripTextures(frame)
		B.CreateBDFrame(frame, 0, 1)
	end

	local line = B.CreateLines(ChatConfigCategoryFrame, "V")
	line:SetPoint("RIGHT", 0, 0)

	for i = 1, 5 do
		local tab = _G["CombatConfigTab"..i]
		B.StripTextures(tab)
		B.CreateBGFrame(tab, 1, -10, -1, 0)
	end

	hooksecurefunc("ChatConfig_CreateCheckboxes", Reskin_CreateCheckboxes)
	hooksecurefunc("ChatConfig_CreateTieredCheckboxes", Reskin_CreateTieredCheckboxes)
	hooksecurefunc("ChatConfig_CreateColorSwatches", Reskin_CreateColorSwatches)
	hooksecurefunc(ChatConfigFrameChatTabManager, "UpdateWidth", Reskin_UpdateWidth)
end)