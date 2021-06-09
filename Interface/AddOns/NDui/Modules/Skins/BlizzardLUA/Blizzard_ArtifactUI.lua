local _, ns = ...
local B, C, L, DB = unpack(ns)

C.LUAThemes["Blizzard_ArtifactUI"] = function()
	local bg = B.ReskinFrame(ArtifactFrame)
	B.ReskinFrameTab(ArtifactFrame, 2)

	B.StripTextures(ArtifactFrame.BorderFrame)
	B.StripTextures(ArtifactFrame.ForgeBadgeFrame)
	B.StripTextures(ArtifactFrame.PerksTab)
	B.StripTextures(ArtifactFrame.PerksTab.DisabledFrame)

	local Model = ArtifactFrame.PerksTab.Model
	Model:SetAlpha(.5)
	Model:SetInside(bg)

	-- AppearancesTab
	local AppearancesTab = ArtifactFrame.AppearancesTab
	B.StripTextures(AppearancesTab)

	for i = 1, 6 do
		local SetPool = AppearancesTab.appearanceSetPool:Acquire()
		B.ReskinText(SetPool.Name, .9, .8, .5)
		B.StripTextures(SetPool)
		B.CreateBGFrame(SetPool, 10, -5, -10, 5)

		for j = 1, 4 do
			local SlotPool = AppearancesTab.appearanceSlotPool:Acquire()

			local slotbg = B.CreateBDFrame(SlotPool)
			B.ReskinHLTex(SlotPool, slotbg, false, true)
			B.ReskinSpecialBorder(SlotPool.Selected, slotbg, true)

			SlotPool.Border:SetAlpha(0)
			SlotPool.Background:Hide()

			SlotPool.SwatchTexture:SetTexCoord(.2, .8, .2, .8)
			SlotPool.SwatchTexture:SetInside(slotbg)

			SlotPool.UnobtainableCover:SetTexCoord(.2, .8, .2, .8)
			SlotPool.UnobtainableCover:SetInside(slotbg)
		end
	end

end