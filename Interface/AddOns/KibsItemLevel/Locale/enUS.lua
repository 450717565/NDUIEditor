-- Translate this addon to your language at:
-- https://wow.curseforge.com/projects/kibs-item-level-continued/localization

local addonName = "KibsItemLevel"
local addonNamespace = LibStub and LibStub(addonName .. "-1.0", true)
if not addonNamespace then return end

local L = LibStub and LibStub('AceLocale-3.0'):NewLocale(addonName, 'enUS', true, true)

if not L then
    return
end

L["Debug output"] = true
L["Functionality and style settings."] = true
L["Kibs Item Level"] = true
L["Show on Character Sheet"] = true
L["Show on Inspection Frame"] = true
L["Show upgrades, e.g. (4/4)"] = true
L["Smaller ilvl text"] = true
L["toc.notes"] = "Enhances Character and Inspection panes by adding item level, icons for gems and enchants, and more!"

L["Unknown enchant %d"] = "未知附魔（ID）：%d"
L["Missing enchant"] = "缺失附魔"
L["Missing relic"] = "缺失圣物"
L["Missing gem"] = "缺失宝石"
L["Avg. equipped item level: %.1f (%d/%d)"] = "平均装备等级：%.1f (%d/%d)"
L["Avg. equipped item level: %.1f"] = "平均装备等级：%.1f"