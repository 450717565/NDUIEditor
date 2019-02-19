local F, C = unpack(select(2, ...))

C.themes["Blizzard_ArtifactUI"] = function()
	F.ReskinFrame(ArtifactFrame)
	F.StripTextures(ArtifactFrame.PerksTab)
	F.StripTextures(ArtifactFrame.ForgeBadgeFrame)

	F.ReskinTab(ArtifactFrameTab1)
	F.ReskinTab(ArtifactFrameTab2)

	ArtifactFrame.PerksTab.Model:SetAlpha(.5)
	ArtifactFrameTab1:ClearAllPoints()
	ArtifactFrameTab1:SetPoint("TOPLEFT", ArtifactFrame, "BOTTOMLEFT", 15, 2)

	-- AppearancesTab
	local AppearancesTab = ArtifactFrame.AppearancesTab
	F.StripTextures(AppearancesTab)

	for i = 1, 6 do
		local SetPool = AppearancesTab.appearanceSetPool:Acquire()
		SetPool.Name:SetTextColor(.9, .8, .5)
		F.StripTextures(SetPool)

		local setbg = F.CreateBDFrame(SetPool, 0)
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

			local slotbg = F.CreateBDFrame(SlotPool, 0)
			F.ReskinTexture(SlotPool, slotbg, false)

			local sl = SlotPool.Selected
			F.ReskinBorder(sl, SlotPool, true)
		end
	end

end