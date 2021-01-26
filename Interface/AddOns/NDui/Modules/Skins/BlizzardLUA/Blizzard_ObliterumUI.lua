local _, ns = ...
local B, C, L, DB = unpack(ns)

C.LUAThemes["Blizzard_ObliterumUI"] = function()
	B.ReskinFrame(ObliterumForgeFrame)
	B.ReskinButton(ObliterumForgeFrame.ObliterateButton)
	B.ReskinIcon(ObliterumForgeFrame.ItemSlot.Icon)
end