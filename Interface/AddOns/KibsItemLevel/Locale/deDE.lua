-- Translate this addon to your language at:
-- https://wow.curseforge.com/projects/kibs-item-level-continued/localization

local addonName = "KibsItemLevel"
local addonNamespace = LibStub and LibStub(addonName .. "-1.0", true)
if not addonNamespace then return end

local L = LibStub and LibStub('AceLocale-3.0'):NewLocale(addonName, 'deDE')

if not L then
    return
end

L["Avg. equipped item level: %.1f"] = "Durchschn. angelegte Gegenstandsstufe: %.1f"
L["Avg. equipped item level: %.1f (%d/%d)"] = "Durchschn. angelegte Gegenstandsstufe: %.1f (%d/%d)"
L["Debug output"] = "Debugausgabe"
L["Functionality and style settings."] = "Funktionalit\195\164ts- und Stileinstellungen"
L["Kibs Item Level"] = true
L["Missing enchant"] = "Fehlende Verzauberung"
L["Missing gem"] = "Fehlender Edelstein"
L["Missing relic"] = "Fehlendes Relikt"
L["Show on Character Sheet"] = "Im Charakterinfo-Fenster anzeigen"
L["Show on Inspection Frame"] = "Im Betrachten-Fenster anzeigen"
L["Show upgrades, e.g. (4/4)"] = "Aufwertungen anzeigen, z.B. (4/4)"
L["Smaller ilvl text"] = "Kleinerer Gegenstandsstufentext"
L["toc.notes"] = [=[Verbessert das Charakter- und Betrachtungsfenster durch Hinzuf\195\188gen von Gegenstandsstufe, Symbolen f\195\188r Edelsteine \226\128\139\226\128\139und Verzauberungen und vieles mehr!
]=]
L["Unknown enchant #%d"] = "Unbekannte Verzauberung #%d"

