-- Translate this addon to your language at:
-- https://wow.curseforge.com/projects/kibs-item-level-continued/localization

local addonName = "KibsItemLevel"
local addonNamespace = LibStub and LibStub(addonName .. "-1.0", true)
if not addonNamespace then return end

local L = LibStub and LibStub('AceLocale-3.0'):NewLocale(addonName, 'ptBR')

if not L then
    return
end

L["Avg. equipped item level: %.1f"] = "M\195\169dia do item equipado: %.1f"
L["Avg. equipped item level: %.1f (%d/%d)"] = "M\195\169dia do item equipado: %.1f (%d/%d)"
L["Debug output"] = "Sa\195\173da de depura\195\167\195\163o"
L["Functionality and style settings."] = "Funcionalidade e ajustes de estilo."
L["Kibs Item Level"] = "Kibs Item Level (Cont\195\173nuo)"
L["Missing enchant"] = "Encantamento perdido"
L["Missing gem"] = "Gema perdida"
L["Missing relic"] = "Rel\195\173quia perdida"
L["Show on Character Sheet"] = "Exibir na aba do personagem"
L["Show on Inspection Frame"] = "Exibir na janela de Inspe\195\167\195\163o"
L["Show upgrades, e.g. (4/4)"] = "Exibir melhorias, ex. (4/4)"
L["Smaller ilvl text"] = "Pequeno texto do ilvl"
L["toc.notes"] = "Aprimora os pain\195\169is de Personagem e Inspe\195\167\195\163o, adicionando o n\195\173vel do item, \195\173cones para gemas e encantamentos e muito mais!"
L["Unknown enchant #%d"] = "Encantamento desconhecido #%d"

