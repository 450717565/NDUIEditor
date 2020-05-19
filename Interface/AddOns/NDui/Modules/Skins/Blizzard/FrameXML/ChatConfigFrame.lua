local B, C, L, DB = unpack(select(2, ...))

tinsert(C.defaultThemes, function()
	B.ReskinFrame(ChatConfigFrame)

	B.ReskinArrow(ChatConfigMoveFilterUpButton, "up")
	B.ReskinArrow(ChatConfigMoveFilterDownButton, "down")

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

	local lists = {ChatConfigCategoryFrame, ChatConfigBackgroundFrame, ChatConfigCombatSettingsFilters, CombatConfigColorsHighlighting, CombatConfigColorsColorizeUnitName, CombatConfigColorsColorizeSpellNames, CombatConfigColorsColorizeDamageNumber, CombatConfigColorsColorizeDamageSchool, CombatConfigColorsColorizeEntireLine}
	for _, list in pairs(lists) do
		B.StripTextures(list)
	end

	local buttons = {CombatLogDefaultButton, ChatConfigCombatSettingsFiltersCopyFilterButton, ChatConfigCombatSettingsFiltersAddFilterButton, ChatConfigCombatSettingsFiltersDeleteButton, CombatConfigSettingsSaveButton, ChatConfigFrameOkayButton, ChatConfigFrameDefaultButton, ChatConfigFrameRedockButton}
	for _, button in pairs(buttons) do
		B.ReskinButton(button)
	end

	local line = B.CreateLine(ChatConfigCategoryFrame)
	line:SetPoint("RIGHT", 0, 0)

	hooksecurefunc("ChatConfig_CreateCheckboxes", function(frame, checkBoxTable)
		if not frame.styled then
			B.StripTextures(frame)

			for index in pairs(checkBoxTable) do
				local checkBoxName = frame:GetName().."CheckBox"..index
				local checkbox = _G[checkBoxName]
				B.StripTextures(checkbox)
				B.CreateBDFrame(checkbox, 0, -C.mult*2)

				local swatch = _G[checkBoxName.."ColorSwatch"]
				if swatch then
					B.ReskinColorSwatch(_G[checkBoxName.."ColorSwatch"])
				end

				B.ReskinCheck(_G[checkBoxName.."Check"])
			end

			frame.styled = true
		end
	end)

	hooksecurefunc("ChatConfig_CreateTieredCheckboxes", function(frame, checkBoxTable)
		if not frame.styled then
			for index, value in pairs(checkBoxTable) do
				local checkBoxName = frame:GetName().."CheckBox"..index
				B.ReskinCheck(_G[checkBoxName])

				if value.subTypes then
					for k in pairs(value.subTypes) do
						B.ReskinCheck(_G[checkBoxName.."_"..k])
					end
				end
			end

			frame.styled = true
		end
	end)

	hooksecurefunc("ChatConfig_CreateColorSwatches", function(frame, swatchTable)
		if not frame.styled then
			B.StripTextures(frame)

			for index in pairs(swatchTable) do
				local swatchName = frame:GetName().."Swatch"..index
				local swatch = _G[swatchName]
				B.StripTextures(swatch)
				B.CreateBDFrame(swatch, 0, -C.mult*2)
				B.ReskinColorSwatch(_G[swatchName.."ColorSwatch"])
			end

			frame.styled = true
		end
	end)

	hooksecurefunc(ChatConfigFrameChatTabManager, "UpdateWidth", function(self)
		for tab in self.tabPool:EnumerateActive() do
			if not tab.styled then
				B.StripTextures(tab)
				B.CreateBGFrame(tab, C.mult, -10, -C.mult, 0)

				tab.styled = true
			end
		end
	end)

	-- CombatConfig
	B.ReskinInput(CombatConfigSettingsNameEditBox)
	B.ReskinRadio(CombatConfigColorsColorizeEntireLineBySource)
	B.ReskinRadio(CombatConfigColorsColorizeEntireLineByTarget)
	B.ReskinColorSwatch(CombatConfigColorsColorizeSpellNamesColorSwatch)
	B.ReskinColorSwatch(CombatConfigColorsColorizeDamageNumberColorSwatch)
	B.ReskinScroll(ChatConfigCombatSettingsFiltersScrollFrameScrollBar)
	B.CreateBGFrame(ChatConfigCombatSettingsFilters, 3, -3, 0, 2)

	local checks = {CombatConfigColorsHighlightingLine, CombatConfigColorsHighlightingAbility, CombatConfigColorsHighlightingDamage, CombatConfigColorsHighlightingSchool, CombatConfigColorsColorizeUnitNameCheck, CombatConfigColorsColorizeSpellNamesCheck, CombatConfigColorsColorizeSpellNamesSchoolColoring, CombatConfigColorsColorizeDamageNumberCheck, CombatConfigColorsColorizeDamageNumberSchoolColoring, CombatConfigColorsColorizeDamageSchoolCheck, CombatConfigColorsColorizeEntireLineCheck, CombatConfigFormattingShowTimeStamp, CombatConfigFormattingShowBraces, CombatConfigFormattingUnitNames, CombatConfigFormattingSpellNames, CombatConfigFormattingItemNames, CombatConfigFormattingFullText, CombatConfigSettingsShowQuickButton, CombatConfigSettingsSolo, CombatConfigSettingsParty, CombatConfigSettingsRaid}
	for _, check in pairs(checks) do
		B.ReskinCheck(check)
	end

	for i = 1, 5 do
		local tab = _G["CombatConfigTab"..i]
		B.StripTextures(tab)
		B.CreateBGFrame(tab, C.mult, -10, -C.mult, 0)
	end
end)