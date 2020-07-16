local B, C, L, DB = unpack(select(2, ...))

C.themes["Blizzard_ArtifactUI"] = function()
	B.ReskinFrame(ArtifactFrame)
	B.StripTextures(ArtifactFrame.PerksTab)
	B.StripTextures(ArtifactFrame.ForgeBadgeFrame)

	B.SetupTabStyle(ArtifactFrame, 2)

	ArtifactFrame.PerksTab.Model:SetAlpha(.5)

	-- AppearancesTab
	local AppearancesTab = ArtifactFrame.AppearancesTab
	B.StripTextures(AppearancesTab)

	for i = 1, 6 do
		local SetPool = AppearancesTab.appearanceSetPool:Acquire()
		SetPool.Name:SetTextColor(.9, .8, .5)
		B.StripTextures(SetPool)
		B.CreateBGFrame(SetPool, 10, -5, -10, 5)

		for j = 1, 4 do
			local SlotPool = AppearancesTab.appearanceSlotPool:Acquire()

			local slotbg = B.CreateBDFrame(SlotPool, 0)
			B.ReskinHighlight(SlotPool, slotbg)
			B.ReskinBorder(SlotPool.Selected, slotbg, true)

			SlotPool.Border:SetAlpha(0)
			SlotPool.Background:Hide()

			SlotPool.SwatchTexture:SetTexCoord(.2, .8, .2, .8)
			SlotPool.SwatchTexture:SetInside(slotbg)

			SlotPool.UnobtainableCover:SetTexCoord(.2, .8, .2, .8)
			SlotPool.UnobtainableCover:SetInside(slotbg)
		end
	end

end