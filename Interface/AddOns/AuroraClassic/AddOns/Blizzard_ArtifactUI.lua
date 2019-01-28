local F, C = unpack(select(2, ...))

C.themes["Blizzard_ArtifactUI"] = function()
	local r, g, b = C.r, C.g, C.b

	F.ReskinFrame(ArtifactFrame)
	F.StripTextures(ArtifactFrame.PerksTab)
	F.StripTextures(ArtifactFrame.ForgeBadgeFrame)

	F.ReskinTab(ArtifactFrameTab1)
	F.ReskinTab(ArtifactFrameTab2)

	ArtifactFrame.PerksTab.Model:SetAlpha(.5)
	ArtifactFrameTab1:ClearAllPoints()
	ArtifactFrameTab1:SetPoint("TOPLEFT", ArtifactFrame, "BOTTOMLEFT", 10, 2)

	-- AppearancesTab
	local AppearancesTab = ArtifactFrame.AppearancesTab
	F.StripTextures(AppearancesTab)

	for i = 1, 6 do
		local SetPool = AppearancesTab.appearanceSetPool:Acquire()
		SetPool.Name:SetTextColor(.9, .8, .5)
		F.StripTextures(SetPool)

		local setbg = F.CreateBDFrame(SetPool, .25)
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

			local slotbg = F.CreateBDFrame(SlotPool, .25)
			F.ReskinTexture(SlotPool.HighlightTexture, slotbg, false)

			local sl = SlotPool.Selected
			F.ReskinTexture(sl, SlotPool, true, true)
			sl:SetColorTexture(r, g, b, 1)
		end
	end

end