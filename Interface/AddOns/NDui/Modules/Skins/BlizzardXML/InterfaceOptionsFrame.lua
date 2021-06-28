local _, ns = ...
local B, C, L, DB = unpack(ns)

local cr, cg, cb = DB.cr, DB.cg, DB.cb

local function Reskin_InterfaceAddOnsList()
	for i = 1, #INTERFACEOPTIONS_ADDONCATEGORIES do
		local buttons = "InterfaceOptionsFrameAddOnsButton"..i
		local button = _G[buttons]

		if not button then return end

		button.highlight:SetTexture(DB.bgTex)
		button.highlight:SetAlpha(.25)

		local toggle = _G[buttons.."Toggle"]
		if toggle and not toggle.styled then
			B.ReskinCollapse(toggle)

			toggle.styled = true
		end

		toggle:SetPushedTexture("")
	end
end

local function Reskin_InterfaceOptionsFrame(self)
	if self.styled then return end

	B.ReskinFrame(self)

	local lists = {
		InterfaceOptionsFrameAddOns,
		InterfaceOptionsFrameCategories,
		InterfaceOptionsFramePanelContainer,
		InterfaceOptionsFrameTab1,
		InterfaceOptionsFrameTab2,
	}
	for _, list in pairs(lists) do
		B.StripTextures(list)
	end

	local buttons = {
		"InterfaceOptionsFrameOkay",
		"InterfaceOptionsFrameCancel",
		"InterfaceOptionsFrameDefaults",
	}
	for _, button in pairs(buttons) do
		B.ReskinButton(_G[button])
	end

	for i = 1, 10 do
		local button = _G["InterfaceOptionsFrameCategoriesButton"..i]
		button.highlight:SetTexture(DB.bgTex)
		button.highlight:SetAlpha(.25)
	end

	local aLine = B.CreateLines(InterfaceOptionsFrameAddOns, "V")
	aLine:SetPoint("RIGHT", 10, 0)

	local cLine = B.CreateLines(InterfaceOptionsFrameCategories, "V")
	cLine:SetPoint("RIGHT", 10, 0)

	local examples = InterfaceOptionsAccessibilityPanel.ColorblindFilterExamples
	for i = 1, 6 do
		local icon = examples["ExampleIcon"..i]
		B.ReskinIcon(icon)

		local border = examples["ExampleIcon"..i.."Border"]
		border:Hide()
	end

	InterfaceOptionsAccessibilityPanel.ColorblindFiltersSeparator:Hide()
	InterfaceOptionsFrameOkay:ClearAllPoints()
	InterfaceOptionsFrameOkay:SetPoint("RIGHT", InterfaceOptionsFrameCancel, "LEFT", -1, 0)

	if CompactUnitFrameProfilesGeneralOptionsFrameAutoActivateBG then
		CompactUnitFrameProfilesGeneralOptionsFrameAutoActivateBG:Hide()
	end

	if CompactUnitFrameProfilesSeparator then
		CompactUnitFrameProfilesSeparator:SetColorTexture(cr, cg, cb, C.alpha)
	end

	local panels = {
		"CompactUnitFrameProfiles",
		"CompactUnitFrameProfilesGeneralOptionsFrame",
		"InterfaceOptionsAccessibilityPanel",
		"InterfaceOptionsActionBarsPanel",
		"InterfaceOptionsCameraPanel",
		"InterfaceOptionsCombatPanel",
		"InterfaceOptionsControlsPanel",
		"InterfaceOptionsDisplayPanel",
		"InterfaceOptionsMousePanel",
		"InterfaceOptionsNamesPanel",
		"InterfaceOptionsNamesPanelEnemy",
		"InterfaceOptionsNamesPanelFriendly",
		"InterfaceOptionsNamesPanelUnitNameplates",
		"InterfaceOptionsSocialPanel",
	}
	if DB.isNewPatch then
		tinsert(panels, "InterfaceOptionsColorblindPanel")
	end
	B.ReskinOptions(panels)

	self.styled = true
end

C.OnLoginThemes["InterfaceOptionsFrame"] = function()
	InterfaceOptionsFrame:HookScript("OnShow", Reskin_InterfaceOptionsFrame)
	hooksecurefunc("InterfaceAddOnsList_Update", Reskin_InterfaceAddOnsList)
end