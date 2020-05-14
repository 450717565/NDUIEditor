local _, ns = ...
local B, C, L, DB = unpack(ns)
local M = B:GetModule("Misc")

local format, max = string.format, math.max
local BreakUpLargeNumbers, GetMeleeHaste, UnitAttackSpeed = BreakUpLargeNumbers, GetMeleeHaste, UnitAttackSpeed
local GetAverageItemLevel, C_PaperDollInfo_GetMinItemLevel = GetAverageItemLevel, C_PaperDollInfo.GetMinItemLevel
local PaperDollFrame_SetLabelAndText = PaperDollFrame_SetLabelAndText

function M:MissingStats()
	if not NDuiDB["Misc"]["MissingStats"] then return end
	if IsAddOnLoaded("DejaCharacterStats") then return end

	local fontOutline = NDuiDB["Skins"]["FontOutline"] and "OUTLINE" or ""

	local statPanel = CreateFrame("Frame", nil, CharacterFrameInsetRight)
	statPanel:SetSize(200, 350)
	statPanel:SetPoint("TOP", 0, -5)

	local scrollFrame = CreateFrame("ScrollFrame", nil, statPanel, "UIPanelScrollFrameTemplate")
	scrollFrame:SetAllPoints()
	scrollFrame.ScrollBar:SetAlpha(0)

	local stat = CreateFrame("Frame", nil, scrollFrame)
	stat:SetSize(200, 1)
	scrollFrame:SetScrollChild(stat)
	CharacterStatsPane:ClearAllPoints()
	CharacterStatsPane:SetParent(stat)
	CharacterStatsPane:SetAllPoints(stat)

	hooksecurefunc("PaperDollFrame_UpdateSidebarTabs", function()
		statPanel:SetShown(_G[PAPERDOLL_SIDEBARS[1].frame]:IsShown())
	end)

	-- Change default data
	PAPERDOLL_STATCATEGORIES = {
		[1] = {
			categoryFrame = "AttributesCategory",
			stats = {
				{stat = "STRENGTH", hideAt = 0, primary = LE_UNIT_STAT_STRENGTH},
				{stat = "AGILITY", hideAt = 0, primary = LE_UNIT_STAT_AGILITY},
				{stat = "INTELLECT", hideAt = 0, primary = LE_UNIT_STAT_INTELLECT},
				{stat = "STAMINA", hideAt = 0},
				{stat = "ARMOR", hideAt = 0},
				{stat = "ATTACK_DAMAGE", hideAt = 0},
				{stat = "ATTACK_AP", hideAt = 0, primary = LE_UNIT_STAT_STRENGTH},
				{stat = "ATTACK_ATTACKSPEED", hideAt = 0, primary = LE_UNIT_STAT_STRENGTH},
				{stat = "ATTACK_AP", hideAt = 0, primary = LE_UNIT_STAT_AGILITY},
				{stat = "ATTACK_ATTACKSPEED", hideAt = 0, primary = LE_UNIT_STAT_AGILITY},
				{stat = "SPELLPOWER", hideAt = 0, primary = LE_UNIT_STAT_INTELLECT},
				{stat = "RUNE_REGEN", hideAt = 0, primary = LE_UNIT_STAT_STRENGTH},
				{stat = "ENERGY_REGEN", hideAt = 0, primary = LE_UNIT_STAT_AGILITY},
				{stat = "FOCUS_REGEN", hideAt = 0, primary = LE_UNIT_STAT_AGILITY},
				{stat = "MANAREGEN", hideAt = 0, primary = LE_UNIT_STAT_INTELLECT},
				{stat = "MOVESPEED", hideAt = 0},
			},
		},
		[2] = {
			categoryFrame = "EnhancementsCategory",
			stats = {
				{stat = "STAGGER", hideAt = 0, roles = { "TANK" }},
				{stat = "CRITCHANCE", hideAt = 0},
				{stat = "HASTE", hideAt = 0},
				{stat = "MASTERY", hideAt = 0},
				{stat = "VERSATILITY", hideAt = 0},
				{stat = "AVOIDANCE", hideAt = 0},
				{stat = "LIFESTEAL", hideAt = 0},
				{stat = "DODGE", hideAt = 0, roles = { "TANK" }},
				{stat = "BLOCK", hideAt = 0, roles = { "TANK" }},
				{stat = "PARRY", hideAt = 0, roles = { "TANK" }},
			},
		},
	}

	local StatusTab = {
		[STAGGER] = true,
		[STAT_AVOIDANCE] = true,
		[STAT_BLOCK] = true,
		[STAT_CRITICAL_STRIKE] = true,
		[STAT_DODGE] = true,
		[STAT_HASTE] = true,
		[STAT_LIFESTEAL] = true,
		[STAT_MASTERY] = true,
		[STAT_PARRY] = true,
		[STAT_VERSATILITY] = true,
	}

	hooksecurefunc("PaperDollFrame_SetLabelAndText", function(statFrame, label, text, isPercentage, numericValue)
		if StatusTab[label] then
			text = format("%.2f%%", numericValue)
		end

		statFrame.Value:SetText(text)
		statFrame.numericValue = numericValue
	end)

	hooksecurefunc("PaperDollFrame_SetItemLevel", function(statFrame, unit)
		if unit ~= "player" then return end

		local total, equip = GetAverageItemLevel()
		if total > 0 then total = format("%.1f", total) end
		if equip > 0 then equip = format("%.1f", equip) end

		local ilvl = equip
		if total ~= equip then
			ilvl = equip.." / "..total
		end

		statFrame.Value:SetText(ilvl)
		statFrame.Value:SetFont(STANDARD_TEXT_FONT, 20, fontOutline)

		statFrame.tooltip = "|cffffffff"..STAT_AVERAGE_ITEM_LEVEL..L[":"].."|r"..ilvl
	end)

	PAPERDOLL_STATINFO["ENERGY_REGEN"].updateFunc = function(statFrame, unit)
		statFrame.numericValue = 0
		PaperDollFrame_SetEnergyRegen(statFrame, unit)
	end

	PAPERDOLL_STATINFO["RUNE_REGEN"].updateFunc = function(statFrame, unit)
		statFrame.numericValue = 0
		PaperDollFrame_SetRuneRegen(statFrame, unit)
	end

	PAPERDOLL_STATINFO["FOCUS_REGEN"].updateFunc = function(statFrame, unit)
		statFrame.numericValue = 0
		PaperDollFrame_SetFocusRegen(statFrame, unit)
	end
end
M:RegisterMisc("MissingStats", M.MissingStats)