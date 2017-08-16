-- Translate this addon to your language at:
-- https://wow.curseforge.com/projects/kibs-item-level-continued/localization

local addonName = "KibsItemLevel"
local addonNamespace = LibStub and LibStub(addonName .. "-1.0", true)
if not addonNamespace then return end

local L = LibStub and LibStub('AceLocale-3.0'):NewLocale(addonName, 'enUS', true, true)

if not L then
    return
end

L["Avg. equipped item level: %.1f"] = true
L["Avg. equipped item level: %.1f (%d/%d)"] = true
L["Debug output"] = true
L["Functionality and style settings."] = true
L["Kibs Item Level"] = true
L["Missing enchant"] = true
L["Missing gem"] = true
L["Missing relic"] = true
L["Show on Character Sheet"] = true
L["Show on Inspection Frame"] = true
L["Show upgrades, e.g. (4/4)"] = true
L["Smaller ilvl text"] = true
L["toc.notes"] = "Enhances Character and Inspection panes by adding item level, icons for gems and enchants, and more!"
L["Unknown enchant #%d"] = true

