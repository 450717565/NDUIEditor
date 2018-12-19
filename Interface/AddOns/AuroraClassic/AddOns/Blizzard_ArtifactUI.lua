local F, C = unpack(select(2, ...))

C.themes["Blizzard_ArtifactUI"] = function()
	local r, g, b = C.r, C.g, C.b

	F.ReskinPortraitFrame(ArtifactFrame, true)
	F.StripTextures(ArtifactFrame.BorderFrame, true)
	F.StripTextures(ArtifactFrame.PerksTab, true)
	F.StripTextures(ArtifactFrame.PerksTab.DisabledFrame, true)
	F.StripTextures(ArtifactFrame.ForgeBadgeFrame, true)

	F.ReskinTab(ArtifactFrameTab1)
	F.ReskinTab(ArtifactFrameTab2)

	ArtifactFrame.PerksTab.Model:SetAlpha(.5)
	ArtifactFrameTab1:ClearAllPoints()
	ArtifactFrameTab1:SetPoint("TOPLEFT", ArtifactFrame, "BOTTOMLEFT", 10, 2)

	-- Appearance

	F.StripTextures(ArtifactFrame.AppearancesTab, true)
	for i = 1, 6 do
		local set = ArtifactFrame.AppearancesTab.appearanceSetPool:Acquire()
		set.Name:SetTextColor(.9, .8, .5)
		F.StripTextures(set, true)

		local bg = F.CreateBDFrame(set, .25)
		bg:SetPoint("TOPLEFT", 10, -5)
		bg:SetPoint("BOTTOMRIGHT", -10, 5)
		F.CreateGradient(bg)

		for j = 1, 4 do
			local slot = ArtifactFrame.AppearancesTab.appearanceSlotPool:Acquire()
			slot.Border:SetAlpha(0)
			slot.Background:Hide()
			F.CreateBDFrame(slot, .25)

			slot.SwatchTexture:SetTexCoord(.2, .8, .2, .8)
			slot.SwatchTexture:SetAllPoints()
			slot.Selected:SetDrawLayer("BACKGROUND")

			F.ReskinTexture(slot, "hl", true)
			F.ReskinTexture(slot, "tx", true)
		end
	end
end