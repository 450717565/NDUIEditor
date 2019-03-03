local F, C = unpack(select(2, ...))

C.themes["Blizzard_ObliterumUI"] = function()
	F.ReskinFrame(ObliterumForgeFrame)
	F.ReskinButton(ObliterumForgeFrame.ObliterateButton)
	F.ReskinIcon(ObliterumForgeFrame.ItemSlot.Icon)
end