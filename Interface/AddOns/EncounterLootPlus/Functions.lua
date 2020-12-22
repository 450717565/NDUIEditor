local _, ELP = ...

local pattern = "^%+([0-9,]+) ([^ ]+)$"
local patternMore = "%+([0-9,]+) ([^ ]-)\124?r?$" --"附魔：+200 急速" "|cffffffff+150 急速|r"
local ATTRS = {
    [STAT_CRITICAL_STRIKE]  = 1, --CR_CRIT_MELEE,
    [STAT_HASTE]            = 2, --CR_HASTE_MELEE,
    [STAT_VERSATILITY]      = 3, --CR_VERSATILITY_DAMAGE_DONE,
    [STAT_MASTERY]          = 4, --CR_MASTERY,
    [ITEM_MOD_STRENGTH_SHORT] = 5, --LE_UNIT_STAT_STRENGTH
    [ITEM_MOD_AGILITY_SHORT] = 6, --LE_UNIT_STAT_AGILITY
    [ITEM_MOD_INTELLECT_SHORT] = 8, --LE_UNIT_STAT_INTELLECT
    [STAT_AVOIDANCE] = 11, --ITEM_MOD_CR_AVOIDANCE_SHORT 闪避
    [STAT_LIFESTEAL] = 12, --ITEM_MOD_CR_LIFESTEAL_SHORT 吸血
    [STAT_SPEED] = 13, --ITEM_MOD_CR_SPEED_SHORT 加速

    CONDUIT_TYPE = 9, --1-效能导灵器, 2-耐久导灵器, 3-灵巧导灵器, 橙装记忆和小宠物是其他
}
local CONDUIT_TYPES = {
    [CONDUIT_TYPE_POTENCY] = 1,
    [CONDUIT_TYPE_FINESSE] = 2,
    [CONDUIT_TYPE_ENDURANCE] = 3,
}

local cache, primary_stats = {}, {}
--如果提供tbl，则总是返回tbl，否则返回新的table或者数字1
--如果 includeGemEnchant, 那么当装备只有附魔和宝石时，对应属性是负值
function ELP.U1GetItemStats(link, slot, tbl, includeGemEnchant, classID, specID)
    local stats
    if tbl then wipe(tbl) stats = tbl end

	local tipname = "ELPScanTooltip"
	local tip = _G[tipname] or CreateFrame("GameTooltip", tipname, nil, "GameTooltipTemplate")
    tip:SetOwner(WorldFrame, "ANCHOR_NONE")
    if slot == nil then
        tip:SetHyperlink(link, classID, specID)
    else
        tip:SetInventoryItem(link, slot)
    end
    local line2 = _G[tipname .. "TextLeft2"]:GetText()
    if CONDUIT_TYPES[line2] then
        stats = stats or {}
        stats[ATTRS.CONDUIT_TYPE] = CONDUIT_TYPES[line2]
    end
    for i = 5, tip:NumLines(), 1 do
        local txt = _G[tipname .. "TextLeft"..i]:GetText()
        if txt then
            local _, _, value, attr = txt:find(pattern)
            if attr and ATTRS[attr] then
                local value = tonumber((value:gsub(",", "")))
                stats = stats or {}
                stats[ATTRS[attr]] = math.abs(stats[ATTRS[attr]] or 0) + value
                --通过文字颜色获取天赋主属性
                if specID and specID > 0 and ATTRS[attr] > 4 then
                    local r,g,b = _G[tipname .. "TextLeft"..i]:GetTextColor()
                    if r > 0.99 then
                        primary_stats[specID] = ATTRS[attr] - 4
                    end
                end
            end
        end
    end

    return stats or 1
end

function ELP.copy(fromTable, toTable)
	toTable = toTable or {}
	if not fromTable then return end
	for k,v in pairs(fromTable) do
		toTable[k] = v;
	end
	return toTable;
end