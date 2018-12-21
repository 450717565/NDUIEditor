local F, C = unpack(select(2, ...))

C.themes["Blizzard_ObliterumUI"] = function()
	local obliterum = ObliterumForgeFrame

	F.ReskinPortraitFrame(obliterum, true)
	F.Reskin(obliterum.ObliterateButton)
	F.ReskinIcon(obliterum.ItemSlot.Icon, true)
end