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

		local setbg = B.CreateBDFrame(SetPool, 0)
		setbg:SetPoint("TOPLEFT", 10, -5)
		setbg:SetPoint("BOTTOMRIGHT", -10, 5)

		for j = 1, 4 do
			local SlotPool = AppearancesTab.appearanceSlotPool:Acquire()
			SlotPool.Border:SetAlpha(0)
			SlotPool.Background:Hide()
			SlotPool.SwatchTexture:SetTexCoord(.2, .8, .2, .8)
			SlotPool.SwatchTexture:SetAllPoints()
			SlotPool.UnobtainableCover:SetTexCoord(.20, .80, .15, .75)
			SlotPool.UnobtainableCover:SetAllPoints()

			local slotbg = B.CreateBDFrame(SlotPool, 0)
			B.ReskinTexture(SlotPool, slotbg)
			B.ReskinBorder(SlotPool.Selected, slotbg, true)
		end
	end

end