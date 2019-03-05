local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	F.ReskinFrame(ChatConfigFrame)
	ChatConfigFrameHeader:SetAlpha(0)
	ChatConfigFrameHeader:SetPoint("TOP")

	hooksecurefunc("ChatConfig_CreateCheckboxes", function(frame, checkBoxTable)
		if not frame.styled then
			F.StripTextures(frame, true)

			for index in pairs(checkBoxTable) do
				local checkBoxName = frame:GetName().."CheckBox"..index
				local checkbox = _G[checkBoxName]

				F.StripTextures(checkbox, true)

				local bg = F.CreateBDFrame(checkbox, 0)
				bg:SetPoint("TOPLEFT", C.mult, -C.mult)
				bg:SetPoint("BOTTOMRIGHT", -C.mult, C.mult)

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
			F.StripTextures(frame, true)

			for index in pairs(swatchTable) do
				local swatchName = frame:GetName().."Swatch"..index
				local swatch = _G[swatchName]

				F.StripTextures(swatch, true)
				local bg = F.CreateBDFrame(swatch, 0)
				bg:SetPoint("TOPLEFT", C.mult, -C.mult)
				bg:SetPoint("BOTTOMRIGHT", -C.mult, C.mult)

				F.ReskinColourSwatch(_G[swatchName.."ColorSwatch"])
			end

			frame.styled = true
		end
	end)

	hooksecurefunc(ChatConfigFrameChatTabManager, "UpdateWidth", function(self)
		for tab in self.tabPool:EnumerateActive() do
			if not tab.styled then
				F.StripTextures(tab, true)

				tab.styled = true
			end
		end
	end)

	for i = 1, 5 do
		F.StripTextures(_G["CombatConfigTab"..i], true)
	end

	local line = ChatConfigFrame:CreateTexture()
	line:SetSize(C.mult, 460)
	line:SetPoint("TOPLEFT", ChatConfigCategoryFrame, "TOPRIGHT")
	line:SetColorTexture(1, 1, 1, .25)

	local frames = {ChatConfigCategoryFrame, ChatConfigBackgroundFrame, ChatConfigCombatSettingsFilters, CombatConfigColorsHighlighting, CombatConfigColorsColorizeUnitName, CombatConfigColorsColorizeSpellNames, CombatConfigColorsColorizeDamageNumber, CombatConfigColorsColorizeDamageSchool, CombatConfigColorsColorizeEntireLine}
	for _, frame in pairs(frames) do
		F.StripTextures(frame, true)
	end

	local combatBoxes = {
		CombatConfigColorsHighlightingLine,
		CombatConfigColorsHighlightingAbility,
		CombatConfigColorsHighlightingDamage,
		CombatConfigColorsHighlightingSchool,
		CombatConfigColorsColorizeUnitNameCheck,
		CombatConfigColorsColorizeSpellNamesCheck,
		CombatConfigColorsColorizeSpellNamesSchoolColoring,
		CombatConfigColorsColorizeDamageNumberCheck,
		CombatConfigColorsColorizeDamageNumberSchoolColoring,
		CombatConfigColorsColorizeDamageSchoolCheck,
		CombatConfigColorsColorizeEntireLineCheck,
		CombatConfigFormattingShowTimeStamp,
		CombatConfigFormattingShowBraces,
		CombatConfigFormattingUnitNames,
		CombatConfigFormattingSpellNames,
		CombatConfigFormattingItemNames,
		CombatConfigFormattingFullText,
		CombatConfigSettingsShowQuickButton,
		CombatConfigSettingsSolo,
		CombatConfigSettingsParty,
		CombatConfigSettingsRaid
	}

	for _, box in pairs(combatBoxes) do
		F.ReskinCheck(box)
	end

	local bg = F.CreateBDFrame(ChatConfigCombatSettingsFilters, 0)
	bg:SetPoint("TOPLEFT", 3, 0)
	bg:SetPoint("BOTTOMRIGHT", 0, 1)

	F.ReskinButton(CombatLogDefaultButton)
	F.ReskinButton(ChatConfigCombatSettingsFiltersCopyFilterButton)
	F.ReskinButton(ChatConfigCombatSettingsFiltersAddFilterButton)
	F.ReskinButton(ChatConfigCombatSettingsFiltersDeleteButton)
	F.ReskinButton(CombatConfigSettingsSaveButton)
	F.ReskinButton(ChatConfigFrameOkayButton)
	F.ReskinButton(ChatConfigFrameDefaultButton)
	F.ReskinButton(ChatConfigFrameRedockButton)
	F.ReskinArrow(ChatConfigMoveFilterUpButton, "up")
	F.ReskinArrow(ChatConfigMoveFilterDownButton, "down")
	F.ReskinInput(CombatConfigSettingsNameEditBox)
	F.ReskinRadio(CombatConfigColorsColorizeEntireLineBySource)
	F.ReskinRadio(CombatConfigColorsColorizeEntireLineByTarget)
	F.ReskinColourSwatch(CombatConfigColorsColorizeSpellNamesColorSwatch)
	F.ReskinColourSwatch(CombatConfigColorsColorizeDamageNumberColorSwatch)
	F.ReskinScroll(ChatConfigCombatSettingsFiltersScrollFrameScrollBar)
	ChatConfigCombatSettingsFiltersScrollFrameScrollBarBorder:Hide()

	ChatConfigFrameRedockButton:ClearAllPoints()
	ChatConfigFrameRedockButton:SetPoint("LEFT", ChatConfigFrameDefaultButton, "RIGHT", 2, 0)
	ChatConfigMoveFilterUpButton:SetSize(28, 28)
	ChatConfigMoveFilterDownButton:SetSize(28, 28)

	ChatConfigCombatSettingsFiltersAddFilterButton:SetPoint("RIGHT", ChatConfigCombatSettingsFiltersDeleteButton, "LEFT", -1, 0)
	ChatConfigCombatSettingsFiltersCopyFilterButton:SetPoint("RIGHT", ChatConfigCombatSettingsFiltersAddFilterButton, "LEFT", -1, 0)
	ChatConfigMoveFilterUpButton:SetPoint("TOPLEFT", ChatConfigCombatSettingsFilters, "BOTTOMLEFT", 3, 0)
	ChatConfigMoveFilterDownButton:SetPoint("LEFT", ChatConfigMoveFilterUpButton, "RIGHT", 1, 0)
end)