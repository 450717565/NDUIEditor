local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	F.ReskinFrame(ChatConfigFrame)
	F.ReskinHeader(ChatConfigFrame)

	F.ReskinArrow(ChatConfigMoveFilterUpButton, "up")
	F.ReskinArrow(ChatConfigMoveFilterDownButton, "down")

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
		F.StripTextures(list)
	end

	local buttons = {CombatLogDefaultButton, ChatConfigCombatSettingsFiltersCopyFilterButton, ChatConfigCombatSettingsFiltersAddFilterButton, ChatConfigCombatSettingsFiltersDeleteButton, CombatConfigSettingsSaveButton, ChatConfigFrameOkayButton, ChatConfigFrameDefaultButton, ChatConfigFrameRedockButton}
	for _, button in pairs(buttons) do
		F.ReskinButton(button)
	end

	local line = F.CreateLine(ChatConfigCategoryFrame)
	line:SetPoint("RIGHT", 0, 0)

	hooksecurefunc("ChatConfig_CreateCheckboxes", function(frame, checkBoxTable)
		if not frame.styled then
			F.StripTextures(frame)

			for index in pairs(checkBoxTable) do
				local checkBoxName = frame:GetName().."CheckBox"..index
				local checkbox = _G[checkBoxName]
				F.StripTextures(checkbox)
				F.CreateBDFrame(checkbox, 0, -C.pixel)

				local swatch = _G[checkBoxName.."ColorSwatch"]
				if swatch then
					F.ReskinColourSwatch(_G[checkBoxName.."ColorSwatch"])
				end

				F.ReskinCheck(_G[checkBoxName.."Check"])
			end

			frame.styled = true
		end
	end)

	hooksecurefunc("ChatConfig_CreateTieredCheckboxes", function(frame, checkBoxTable)
		if not frame.styled then
			for index, value in pairs(checkBoxTable) do
				local checkBoxName = frame:GetName().."CheckBox"..index
				F.ReskinCheck(_G[checkBoxName])

				if value.subTypes then
					for k in pairs(value.subTypes) do
						F.ReskinCheck(_G[checkBoxName.."_"..k])
					end
				end
			end

			frame.styled = true
		end
	end)

	hooksecurefunc("ChatConfig_CreateColorSwatches", function(frame, swatchTable)
		if not frame.styled then
			F.StripTextures(frame)

			for index in pairs(swatchTable) do
				local swatchName = frame:GetName().."Swatch"..index
				local swatch = _G[swatchName]
				F.StripTextures(swatch)
				F.CreateBDFrame(swatch, 0, -C.pixel)
				F.ReskinColourSwatch(_G[swatchName.."ColorSwatch"])
			end

			frame.styled = true
		end
	end)

	hooksecurefunc(ChatConfigFrameChatTabManager, "UpdateWidth", function(self)
		for tab in self.tabPool:EnumerateActive() do
			if not tab.styled then
				F.StripTextures(tab)

				local bg = F.CreateBDFrame(tab, 0)
				bg:SetPoint("TOPLEFT", C.mult, -10)
				bg:SetPoint("BOTTOMRIGHT", -C.mult, 0)

				tab.styled = true
			end
		end
	end)

	-- CombatConfig
	F.ReskinInput(CombatConfigSettingsNameEditBox)
	F.ReskinRadio(CombatConfigColorsColorizeEntireLineBySource)
	F.ReskinRadio(CombatConfigColorsColorizeEntireLineByTarget)
	F.ReskinColourSwatch(CombatConfigColorsColorizeSpellNamesColorSwatch)
	F.ReskinColourSwatch(CombatConfigColorsColorizeDamageNumberColorSwatch)
	F.ReskinScroll(ChatConfigCombatSettingsFiltersScrollFrameScrollBar)

	local checks = {CombatConfigColorsHighlightingLine, CombatConfigColorsHighlightingAbility, CombatConfigColorsHighlightingDamage, CombatConfigColorsHighlightingSchool, CombatConfigColorsColorizeUnitNameCheck, CombatConfigColorsColorizeSpellNamesCheck, CombatConfigColorsColorizeSpellNamesSchoolColoring, CombatConfigColorsColorizeDamageNumberCheck, CombatConfigColorsColorizeDamageNumberSchoolColoring, CombatConfigColorsColorizeDamageSchoolCheck, CombatConfigColorsColorizeEntireLineCheck, CombatConfigFormattingShowTimeStamp, CombatConfigFormattingShowBraces, CombatConfigFormattingUnitNames, CombatConfigFormattingSpellNames, CombatConfigFormattingItemNames, CombatConfigFormattingFullText, CombatConfigSettingsShowQuickButton, CombatConfigSettingsSolo, CombatConfigSettingsParty, CombatConfigSettingsRaid}
	for _, check in pairs(checks) do
		F.ReskinCheck(check)
	end

	local bg = F.CreateBDFrame(ChatConfigCombatSettingsFilters, 0)
	bg:SetPoint("TOPLEFT", 3, -3)
	bg:SetPoint("BOTTOMRIGHT", 0, 2)

	for i = 1, 5 do
		local tab = _G["CombatConfigTab"..i]
		F.StripTextures(tab)

		local bg = F.CreateBDFrame(tab, 0)
		bg:SetPoint("TOPLEFT", C.mult, -10)
		bg:SetPoint("BOTTOMRIGHT", -C.mult, 0)
	end
end)