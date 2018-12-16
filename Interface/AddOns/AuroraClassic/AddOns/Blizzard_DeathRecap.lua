local F, C = unpack(select(2, ...))

C.themes["Blizzard_DeathRecap"] = function()
	F.StripTextures(DeathRecapFrame, true)
	F.CreateBD(DeathRecapFrame)
	F.CreateSD(DeathRecapFrame)
	F.Reskin(DeathRecapFrame.CloseButton)
	F.ReskinClose(DeathRecapFrame.CloseXButton)

	for i = 1, NUM_DEATH_RECAP_EVENTS do
		local recap = DeathRecapFrame["Recap"..i].SpellInfo
		recap.IconBorder:Hide()
		F.ReskinIcon(recap.Icon, true)
	end
end