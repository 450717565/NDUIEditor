local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	F.CreateBD(ChatConfigFrame)
	F.CreateSD(ChatConfigFrame)
	ChatConfigFrameHeader:SetAlpha(0)
	ChatConfigFrameHeader:SetPoint("TOP")

	hooksecurefunc("ChatConfig_CreateCheckboxes", function(frame, checkBoxTable)
		if frame.styled then return end

		frame:SetBackdrop(nil)
		for index in ipairs(checkBoxTable) do
			local checkBoxName = frame:GetName().."CheckBox"..index
			local checkbox = _G[checkBoxName]

			checkbox:SetBackdrop(nil)
			local bg = F.CreateBDFrame(checkbox, .25)
			bg:SetPoint("TOPLEFT", 0, -.5)
			bg:SetPoint("BOTTOMRIGHT", 0, .5)

			local swatch = _G[checkBoxName.."ColorSwatch"]
			if swatch then
				F.ReskinColourSwatch(_G[checkBoxName.."ColorSwatch"])
			end
			F.ReskinCheck(_G[checkBoxName.."Check"])
		end

		frame.styled = true
	end)

	hooksecurefunc("ChatConfig_CreateTieredCheckboxes", function(frame, checkBoxTable)
		if frame.styled then return end

		for index, value in ipairs(checkBoxTable) do
			local checkBoxName = frame:GetName().."CheckBox"..index
			F.ReskinCheck(_G[checkBoxName])

			if value.subTypes then
				for k in ipairs(value.subTypes) do
					F.ReskinCheck(_G[checkBoxName.."_"..k])
				end
			end
		end

		frame.styled = true
	end)

	hooksecurefunc("ChatConfig_CreateColorSwatches", function(frame, swatchTable)
		if frame.styled then return end

		frame:SetBackdrop(nil)
		for index in ipairs(swatchTable) do
			local swatchName = frame:GetName().."Swatch"..index
			local swatch = _G[swatchName]

			swatch:SetBackdrop(nil)
			local bg = F.CreateBDFrame(swatch)
			bg:SetPoint("TOPLEFT", 0, -.5)
			bg:SetPoint("BOTTOMRIGHT", 0, .5)

			F.ReskinColourSwatch(_G[swatchName.."ColorSwatch"])
		end

		frame.styled = true
	end)

	hooksecurefunc(ChatConfigFrameChatTabManager, "UpdateWidth", function(self)
		for tab in self.tabPool:EnumerateActive() do
			if not tab.styled then
				F.StripTextures(tab)

				tab.styled = true
			end
		end
	end)

	for i = 1, 5 do
		F.StripTextures(_G["CombatConfigTab"..i], true)
	end

	local line = ChatConfigFrame:CreateTexture()
	line:SetSize(1, 460)
	line:SetPoint("TOPLEFT", ChatConfigCategoryFrame, "TOPRIGHT")
	line:SetColorTexture(1, 1, 1, .25)

	local frames = {ChatConfigCategoryFrame, ChatConfigBackgroundFrame, ChatConfigCombatSettingsFilters, CombatConfigColorsHighlighting, CombatConfigColorsColorizeUnitName, CombatConfigColorsColorizeSpellNames, CombatConfigColorsColorizeDamageNumber, CombatConfigColorsColorizeDamageSchool, CombatConfigColorsColorizeEntireLine}
	for _, frame in next, frames do
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

	for _, box in next, combatBoxes do
		F.ReskinCheck(box)
	end

	local bg = F.CreateBDFrame(ChatConfigCombatSettingsFilters, .25)
	bg:SetPoint("TOPLEFT", 3, 0)
	bg:SetPoint("BOTTOMRIGHT", 0, 1)

	F.Reskin(CombatLogDefaultButton)
	F.Reskin(ChatConfigCombatSettingsFiltersCopyFilterButton)
	F.Reskin(ChatConfigCombatSettingsFiltersAddFilterButton)
	F.Reskin(ChatConfigCombatSettingsFiltersDeleteButton)
	F.Reskin(CombatConfigSettingsSaveButton)
	F.Reskin(ChatConfigFrameOkayButton)
	F.Reskin(ChatConfigFrameDefaultButton)
	F.Reskin(ChatConfigFrameRedockButton)
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