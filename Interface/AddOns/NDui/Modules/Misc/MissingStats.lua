local B, C, L, DB = unpack(select(2, ...))
local module = NDui:GetModule("Misc")

--[[
	给角色属性面板添加额外的数据，同时使其支持滚动，防止数据溢出。
]]
function module:MissingStats()
	if not NDuiDB["Misc"]["MissingStats"] then return end

	local statPanel = CreateFrame("Frame", nil, CharacterFrameInsetRight)
	statPanel:SetSize(200, 350)
	statPanel:SetPoint("TOP", 0, -5)
	local scrollFrame = CreateFrame("ScrollFrame", nil, statPanel, "UIPanelScrollFrameTemplate")
	scrollFrame:SetAllPoints()
	scrollFrame.ScrollBar:Hide()
	scrollFrame.ScrollBar.Show = B.Dummy
	local stat = CreateFrame("Frame", nil, scrollFrame)
	stat:SetSize(200, 1)
	scrollFrame:SetScrollChild(stat)
	CharacterStatsPane:ClearAllPoints()
	CharacterStatsPane:SetParent(stat)
	CharacterStatsPane:SetAllPoints(stat)
	hooksecurefunc("PaperDollFrame_UpdateSidebarTabs", function()
		if (not _G[PAPERDOLL_SIDEBARS[1].frame]:IsShown()) then
			statPanel:Hide()
		else
			statPanel:Show()
		end
	end)

hooksecurefunc("PaperDollFrame_SetItemLevel", function(self, unit)
	if unit ~= "player" then return end

	local total, equip = GetAverageItemLevel()
	if total > 0 then total = string.format("%.1f", total) end
	if equip > 0 then equip = string.format("%.1f", equip) end

	local ilvl = equip
	if total ~= equip then
		ilvl = total .. " / " .. equip
	end

	CharacterStatsPane.ItemLevelFrame.Value:SetText(ilvl)
	CharacterStatsPane.ItemLevelFrame.Value:SetFont(STANDARD_TEXT_FONT, 20, "OUTLINE")

	self.tooltip = "|cffffffff".. STAT_AVERAGE_ITEM_LEVEL .. " " .. ilvl
end)

-- Change default data
PAPERDOLL_STATCATEGORIES = {
	[1] = {
		categoryFrame = "AttributesCategory",
		stats = {
			[1] = { stat = "STRENGTH", hideAt = 0, primary = LE_UNIT_STAT_STRENGTH },
			[2] = { stat = "AGILITY", hideAt = 0, primary = LE_UNIT_STAT_AGILITY },
			[3] = { stat = "INTELLECT", hideAt = 0, primary = LE_UNIT_STAT_INTELLECT },
			[4] = { stat = "STAMINA", hideAt = 0 },
			[5] = { stat = "ARMOR", hideAt = 0 },
			[6] = { stat = "ATTACK_DAMAGE", hideAt = 0 },
			[7] = { stat = "ATTACK_AP", hideAt = 0, primary = LE_UNIT_STAT_STRENGTH },
			[8] = { stat = "ATTACK_ATTACKSPEED", hideAt = 0, primary = LE_UNIT_STAT_STRENGTH },
			[9] = { stat = "ATTACK_AP", hideAt = 0, primary = LE_UNIT_STAT_AGILITY },
			[10] = { stat = "ATTACK_ATTACKSPEED", hideAt = 0, primary = LE_UNIT_STAT_AGILITY },
			[11] = { stat = "SPELLPOWER", hideAt = 0, primary = LE_UNIT_STAT_INTELLECT },
			[12] = { stat = "MANAREGEN", hideAt = 0, primary = LE_UNIT_STAT_INTELLECT },
			[13] = { stat = "ENERGY_REGEN", hideAt = 0, primary = LE_UNIT_STAT_AGILITY },
			[14] = { stat = "FOCUS_REGEN", hideAt = 0, primary = LE_UNIT_STAT_AGILITY },
			[15] = { stat = "RUNE_REGEN", hideAt = 0, primary = LE_UNIT_STAT_STRENGTH },
			[16] = { stat = "MOVESPEED", hideAt = 0 },
		},
	},
	[2] = {
		categoryFrame = "EnhancementsCategory",
		stats = {
			[1] = { stat = "CRITCHANCE", hideAt = 0 },
			[2] = { stat = "HASTE", hideAt = 0 },
			[3] = { stat = "MASTERY", hideAt = 0 },
			[4] = { stat = "VERSATILITY", hideAt = 0 },
			[5] = { stat = "AVOIDANCE", hideAt = 0 },
			[6] = { stat = "LIFESTEAL", hideAt = 0 },
			[7] = { stat = "DODGE", hideAt = 0, roles = { "TANK" } },
			[8] = { stat = "BLOCK", hideAt = 0, roles = { "TANK" } },
			[9] = { stat = "PARRY", hideAt = 0, roles = { "TANK" } },
		},
	},
}

local StatusTab = {
	[STAT_CRITICAL_STRIKE] = true,
	[STAT_MASTERY] = true,
	[STAT_HASTE] = true,
	[STAT_VERSATILITY] = true,

	[STAT_LIFESTEAL] = true,
	[STAT_AVOIDANCE] = true,

	[STAT_DODGE] = true,
	[STAT_BLOCK] = true,
	[STAT_PARRY] = true,
}

function PaperDollFrame_SetLabelAndText(statFrame, label, text, isPercentage, numericValue)
	if statFrame.Label then
		statFrame.Label:SetFormattedText(STAT_FORMAT, label)
	end

	if isPercentage then
		text = format("%.1f%%", numericValue + 0.5)
	end

	if StatusTab[label] then
		text = format("%.2f%%", numericValue)
	end

	statFrame.Value:SetText(text)
	statFrame.numericValue = numericValue
end

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

-- Fix Movespeed
PAPERDOLL_STATINFO["MOVESPEED"].updateFunc = function(statFrame, unit)
	PaperDollFrame_SetMovementSpeed(statFrame, unit)
end

function MovementSpeed_OnEnter(statFrame)
	GameTooltip:SetOwner(statFrame, "ANCHOR_RIGHT")
	GameTooltip:SetText(HIGHLIGHT_FONT_COLOR_CODE..format(PAPERDOLLFRAME_TOOLTIP_FORMAT, STAT_MOVEMENT_SPEED).." "..format("%d%%", statFrame.speed + .5)..FONT_COLOR_CODE_CLOSE)
	GameTooltip:AddLine(format(STAT_MOVEMENT_GROUND_TOOLTIP, statFrame.runSpeed + .5))
	if statFrame.unit ~= "pet" then
		GameTooltip:AddLine(format(STAT_MOVEMENT_FLIGHT_TOOLTIP, statFrame.flightSpeed + .5))
	end
	GameTooltip:AddLine(format(STAT_MOVEMENT_SWIM_TOOLTIP, statFrame.swimSpeed + .5))
	GameTooltip:Show()
end

	function PaperDollFrame_SetMovementSpeed(statFrame, unit)
		statFrame.wasSwimming = nil
		statFrame.unit = unit
		MovementSpeed_OnUpdate(statFrame)
		statFrame.onEnterFunc = MovementSpeed_OnEnter
		statFrame:Show()
	end
end