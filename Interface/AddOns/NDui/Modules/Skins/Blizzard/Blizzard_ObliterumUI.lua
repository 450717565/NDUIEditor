local B, C, L, DB = unpack(select(2, ...))

C.themes["Blizzard_ObliterumUI"] = function()
	B.ReskinFrame(ObliterumForgeFrame)
	B.ReskinButton(ObliterumForgeFrame.ObliterateButton)
	B.ReskinIcon(ObliterumForgeFrame.ItemSlot.Icon)
end