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
		recap.Icon:SetTexCoord(.08, .92, .08, .92)
		F.CreateBDFrame(recap.Icon, .25)
	end
end