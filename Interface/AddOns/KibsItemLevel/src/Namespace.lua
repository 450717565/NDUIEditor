local addonName = "KibsItemLevel"
local addonNamespace = LibStub:NewLibrary(addonName .. "-1.0", 1)
if not addonNamespace then return end
addonNamespace.loaded = {}
