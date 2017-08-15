local addonName = "KibsItemLevel"
local addonNamespace = LibStub and LibStub(addonName .. "-1.0", true)
if not addonNamespace or addonNamespace.loaded.Localization then return end
addonNamespace.loaded.Localization = true

addonNamespace.L = LibStub("AceLocale-3.0"):GetLocale(addonName)
