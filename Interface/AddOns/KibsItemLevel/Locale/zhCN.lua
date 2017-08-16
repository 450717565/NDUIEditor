-- Translate this addon to your language at:
-- https://wow.curseforge.com/projects/kibs-item-level-continued/localization

local addonName = "KibsItemLevel"
local addonNamespace = LibStub and LibStub(addonName .. "-1.0", true)
if not addonNamespace then return end

local L = LibStub and LibStub('AceLocale-3.0'):NewLocale(addonName, 'zhCN')

if not L then
    return
end

L["Unknown enchant %d"] = "\230\156\170\231\159\165\233\153\132\233\173\148（ID）：%d"
L["Missing enchant"] = "\231\188\186\229\164\177\233\153\132\233\173\148"
L["Missing relic"] = "\231\188\186\229\164\177\229\156\163\231\137\169"
L["Missing gem"] = "\231\188\186\229\164\177\229\174\157\231\159\179"
L["Avg. equipped item level: %.1f (%d/%d)"] = "\229\185\179\229\157\135\232\163\133\229\164\135\231\173\137\231\186\167：%.1f (%d/%d)"
L["Avg. equipped item level: %.1f"] = "\229\185\179\229\157\135\232\163\133\229\164\135\231\173\137\231\186\167：%.1f"
