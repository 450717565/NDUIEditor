local B, C, L, DB = unpack(select(2, ...))

C.themes["Blizzard_AzeriteEssenceUI"] = function()
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
	local bdTex = B.CreateBDFrame(HeaderButton, 0)
	bdTex:SetPoint("TOPLEFT", HeaderButton.ExpandedIcon, -4, 6)
	bdTex:SetPoint("BOTTOMRIGHT", HeaderButton.ExpandedIcon, 4, -6)
	HeaderButton.bdTex = bdTex

	B.Hook_OnEnter(HeaderButton)
	B.Hook_OnLeave(HeaderButton)
	B.Hook_OnMouseDown(HeaderButton)
	B.Hook_OnMouseUp(HeaderButton)

	hooksecurefunc(EssenceList, "Refresh", function(self)
		for i, button in pairs(self.buttons) do
			if not button.styled then
				local icbg = B.ReskinIcon(button.Icon)

				local bubg = B.CreateBG(button, icbg, 2)
				B.ReskinHighlight(button, bubg, true)
				B.ReskinHighlight(button.PendingGlow, bubg, true)

				button.styled = true
			end
			button.Background:SetTexture("")
		end
	end)
end