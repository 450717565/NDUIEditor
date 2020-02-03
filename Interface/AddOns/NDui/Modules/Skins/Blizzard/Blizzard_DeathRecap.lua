local B, C, L, DB = unpack(select(2, ...))

C.themes["Blizzard_DeathRecap"] = function()
	B.StripTextures(DeathRecapFrame)
	B.SetBDFrame(DeathRecapFrame)
	B.ReskinButton(DeathRecapFrame.CloseButton)
	B.ReskinClose(DeathRecapFrame.CloseXButton)

	for i = 1, NUM_DEATH_RECAP_EVENTS do
		local SpellInfo = DeathRecapFrame["Recap"..i].SpellInfo
		SpellInfo.IconBorder:Hide()
		B.ReskinIcon(SpellInfo.Icon)
	end
end