local F, C = unpack(select(2, ...))

C.themes["Blizzard_ObliterumUI"] = function()
	local obliterum = ObliterumForgeFrame

	F.ReskinFrame(obliterum)
	F.ReskinButton(obliterum.ObliterateButton)
	F.ReskinIcon(obliterum.ItemSlot.Icon)
end