local B, C, L, DB = unpack(select(2, ...))

C.themes["Blizzard_AzeriteEssenceUI"] = function()
	local cr, cg, cb = DB.r, DB.g, DB.b

	B.ReskinFrame(AzeriteEssenceUI)

	for _, milestoneFrame in pairs(AzeriteEssenceUI.Milestones) do
		if milestoneFrame.LockedState then
			milestoneFrame.LockedState.UnlockLevelText:SetTextColor(1, 0, 0)
		end
	end

	local ItemModelScene = AzeriteEssenceUI.ItemModelScene
	B.CreateBDFrame(ItemModelScene, 0)

	local PowerLevelBadgeFrame = AzeriteEssenceUI.PowerLevelBadgeFrame
	B.StripTextures(PowerLevelBadgeFrame)
	PowerLevelBadgeFrame:ClearAllPoints()
	PowerLevelBadgeFrame:SetPoint("TOPLEFT", ItemModelScene, 3, 0)
	PowerLevelBadgeFrame.Label:SetTextColor(0, 1, 1)

	local EssenceList = AzeriteEssenceUI.EssenceList
	B.ReskinScroll(EssenceList.ScrollBar)

	local HeaderButton = EssenceList.HeaderButton
	HeaderButton:DisableDrawLayer("BORDER")
	HeaderButton:DisableDrawLayer("BACKGROUND")
	local bubg = B.CreateBDFrame(HeaderButton, 0)
	bubg:SetPoint("TOPLEFT", HeaderButton.ExpandedIcon, -4, 6)
	bubg:SetPoint("BOTTOMRIGHT", HeaderButton.ExpandedIcon, 4, -6)
	HeaderButton:SetScript("OnEnter", function()
		bubg:SetBackdropColor(cr, cg, cb, .25)
	end)
	HeaderButton:SetScript("OnLeave", function()
		bubg:SetBackdropColor(0, 0, 0, 0)
	end)

	hooksecurefunc(EssenceList, "Refresh", function(self)
		for i, button in ipairs(self.buttons) do
			if not button.styled then
				local icbg = B.ReskinIcon(button.Icon)

				local bubg = B.CreateBDFrame(button, 0)
				bubg:SetPoint("TOPLEFT", icbg, "TOPRIGHT", 2, 0)
				bubg:SetPoint("BOTTOMRIGHT", 0, 5)
				B.ReskinTexture(button, bubg, true)
				B.ReskinTexture(button.PendingGlow, bubg, true)

				button.styled = true
			end
			button.Background:SetTexture("")
		end
	end)
end