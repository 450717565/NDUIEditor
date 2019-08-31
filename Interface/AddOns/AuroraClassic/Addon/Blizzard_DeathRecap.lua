local F, C = unpack(select(2, ...))

C.themes["Blizzard_DeathRecap"] = function()
	F.StripTextures(DeathRecapFrame, true)
	F.CreateBD(DeathRecapFrame)
	F.CreateSD(DeathRecapFrame)
	F.ReskinButton(DeathRecapFrame.CloseButton)
	F.ReskinClose(DeathRecapFrame.CloseXButton)

	for i = 1, NUM_DEATH_RECAP_EVENTS do
		local SpellInfo = DeathRecapFrame["Recap"..i].SpellInfo
		SpellInfo.IconBorder:Hide()
		F.ReskinIcon(SpellInfo.Icon)
	end
end