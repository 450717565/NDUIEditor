local _, ns = ...
local B, C, L, DB = unpack(ns)

local function Reskin_EssenceList(self)
	for i, button in pairs(self.buttons) do
		if not button.styled then
			local icbg = B.ReskinIcon(button.Icon)

			local bubg = B.CreateBGFrame(button, 2, 0, 0, 0, icbg)
			B.ReskinHighlight(button, bubg, true)
			B.ReskinHighlight(button.PendingGlow, bubg, true)

			button.styled = true
		end
		button.Background:SetTexture("")
	end
end

C.LUAThemes["Blizzard_AzeriteEssenceUI"] = function()
	B.ReskinFrame(AzeriteEssenceUI)

	for _, milestoneFrame in pairs(AzeriteEssenceUI.Milestones) do
		if milestoneFrame.LockedState then
			B.ReskinText(milestoneFrame.LockedState.UnlockLevelText, 1, 0, 0)
		end
	end

	local ItemModelScene = AzeriteEssenceUI.ItemModelScene
	B.CreateBDFrame(ItemModelScene, 0, -C.mult)

	local PowerLevelBadgeFrame = AzeriteEssenceUI.PowerLevelBadgeFrame
	B.StripTextures(PowerLevelBadgeFrame)
	B.ReskinText(PowerLevelBadgeFrame.Label, 0, 1, 1)
	PowerLevelBadgeFrame:ClearAllPoints()
	PowerLevelBadgeFrame:SetPoint("TOPLEFT", ItemModelScene, 3, 0)

	local EssenceList = AzeriteEssenceUI.EssenceList
	B.ReskinScroll(EssenceList.ScrollBar)

	local HeaderButton = EssenceList.HeaderButton
	HeaderButton:DisableDrawLayer("BORDER")
	HeaderButton:DisableDrawLayer("BACKGROUND")
	local bgTex = B.CreateBDFrame(HeaderButton)
	bgTex:SetOutside(HeaderButton.ExpandedIcon, 4, 6)
	HeaderButton.bgTex = bgTex

	B.SetupHook(HeaderButton)

	hooksecurefunc(EssenceList, "Refresh", Reskin_EssenceList)
end