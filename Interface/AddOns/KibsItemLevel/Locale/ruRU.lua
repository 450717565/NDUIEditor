-- Translate this addon to your language at:
-- https://wow.curseforge.com/projects/kibs-item-level-continued/localization

local addonName = "KibsItemLevel"
local addonNamespace = LibStub and LibStub(addonName .. "-1.0", true)
if not addonNamespace then return end

local L = LibStub and LibStub('AceLocale-3.0'):NewLocale(addonName, 'ruRU')

if not L then
    return
end

L["Avg. equipped item level: %.1f"] = "\208\161\209\128\208\181\208\180\208\189\208\184\208\185 \209\131\209\128\208\190\208\178\208\181\208\189\209\140 \208\191\209\128\208\181\208\180\208\188\208\181\209\130\208\190\208\178: %.1f"
L["Avg. equipped item level: %.1f (%d/%d)"] = "\208\161\209\128\208\181\208\180\208\189\208\184\208\185 \209\131\209\128\208\190\208\178\208\181\208\189\209\140 \208\191\209\128\208\181\208\180\208\188\208\181\209\130\208\190\208\178: %.1f (%d/%d)"
L["Debug output"] = "\208\146\209\139\208\178\208\190\208\180 \208\190\209\130\208\187\208\176\208\180\208\190\209\135\208\189\208\190\208\185 \208\184\208\189\209\132\208\190\209\128\208\188\208\176\209\134\208\184\208\184"
L["Functionality and style settings."] = "\208\157\208\176\209\129\209\130\209\128\208\190\208\185\208\186\208\184 \209\132\209\131\208\189\208\186\209\134\208\184\208\190\208\189\208\176\208\187\209\140\208\189\208\190\209\129\209\130\208\184 \208\184 \208\178\208\189\208\181\209\136\208\189\208\181\208\179\208\190 \208\178\208\184\208\180\208\176."
L["Kibs Item Level"] = true
L["Missing enchant"] = "\208\167\208\176\209\128\209\139 \208\190\209\130\209\129\209\131\209\130\209\129\209\130\208\178\209\131\209\142\209\130"
L["Missing gem"] = "\208\161\208\176\208\188\208\190\209\134\208\178\208\181\209\130 \208\190\209\130\209\129\209\131\209\130\209\129\209\130\208\178\209\131\208\181\209\130"
--Translation missing 
-- L["Missing relic"] = ""
L["Show on Character Sheet"] = "\208\159\208\190\208\186\208\176\208\183\209\139\208\178\208\176\209\130\209\140 \208\191\209\128\208\184 \208\190\209\129\208\188\208\190\209\130\209\128\208\181 \209\129\208\178\208\190\208\181\208\179\208\190 \208\191\208\181\209\128\209\129\208\190\208\189\208\176\208\182\208\176"
L["Show on Inspection Frame"] = "\208\159\208\190\208\186\208\176\208\183\209\139\208\178\208\176\209\130\209\140 \208\191\209\128\208\184 \208\190\209\129\208\188\208\190\209\130\209\128\208\181 \209\135\209\131\208\182\208\184\209\133 \208\191\208\181\209\128\209\129\208\190\208\189\208\176\208\182\208\181\208\185"
L["Show upgrades, e.g. (4/4)"] = "\208\159\208\190\208\186\208\176\208\183\209\139\208\178\208\176\209\130\209\140 \209\131\208\187\209\131\209\135\209\136\208\181\208\189\208\184\209\143, \208\189\208\176\208\191\209\128\208\184\208\188\208\181\209\128 (4/4)"
L["Smaller ilvl text"] = "\208\163\208\188\208\181\208\189\209\140\209\136\208\181\208\189\208\189\209\139\208\185 \209\130\208\181\208\186\209\129\209\130 \209\131\209\128\208\190\208\178\208\189\209\143 \208\191\209\128\208\181\208\180\208\188\208\181\209\130\208\190\208\178"
L["toc.notes"] = "\208\160\208\176\209\129\209\136\208\184\209\128\209\143\208\181\209\130 \208\178\208\190\208\183\208\188\208\190\208\182\208\189\208\190\209\129\209\130\208\184 \208\190\208\186\208\190\208\189 \"\208\159\208\181\209\128\209\129\208\190\208\189\208\176\208\182\" \208\184 \"\208\158\209\129\208\188\208\190\209\130\209\128\208\181\209\130\209\140\": \208\190\209\130\208\190\208\177\209\128\208\176\208\182\208\176\208\181\209\130 \209\131\209\128\208\190\208\178\208\181\208\189\209\140 \208\191\209\128\208\181\208\180\208\188\208\181\209\130\208\190\208\178, \208\184\208\186\208\190\208\189\208\186\208\184 \208\186\208\176\208\188\208\189\208\181\208\185 \208\184 \209\135\208\176\209\128, \208\184 \209\141\209\130\208\190 \208\181\209\137\209\145 \208\189\208\181 \208\178\209\129\209\145!"
L["Unknown enchant #%d"] = "\208\157\208\181\208\184\208\183\208\178\208\181\209\129\209\130\208\189\209\139\208\181 \209\135\208\176\209\128\209\139 #%d"

