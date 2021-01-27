local _, ns = ...
local B, C, L, DB = unpack(ns)
local S = B:GetModule("Skins")

C.LUAThemes["Blizzard_AzeriteUI"] = function()
	B.ReskinFrame(AzeriteEmpoweredItemUI)
	AzeriteEmpoweredItemUI.ClipFrame.BackgroundFrame.Bg:Hide()
end

local function Reskin_EssenceList(self)
	for i, button in pairs(self.buttons) do
		if button and not button.styled then
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

local function Reskin_ReforgeUI(self, index)
	B.StripTextures(self, index)
	B.ReskinClose(self.CloseButton)
	B.CreateBG(self)

	local Background = self.Background
	B.CreateBDFrame(Background, 0, -C.mult)

	local ItemSlot = self.ItemSlot
	B.ReskinIcon(ItemSlot.Icon)

	local ButtonFrame = self.ButtonFrame
	B.StripTextures(ButtonFrame, 0)
	ButtonFrame.MoneyFrameEdge:SetAlpha(0)

	local bubg = B.CreateBDFrame(ButtonFrame)
	bubg:SetPoint("TOPLEFT", ButtonFrame.MoneyFrameEdge, 2, 0)
	bubg:SetPoint("BOTTOMRIGHT", ButtonFrame.MoneyFrameEdge, 0, 2)

	if ButtonFrame.Currency then B.ReskinIcon(ButtonFrame.Currency.icon) end
	if ButtonFrame.ActionButton then B.ReskinButton(ButtonFrame.ActionButton) end
	if ButtonFrame.AzeriteRespecButton then B.ReskinButton(ButtonFrame.AzeriteRespecButton) end
end

C.LUAThemes["Blizzard_AzeriteRespecUI"] = function()
	Reskin_ReforgeUI(AzeriteRespecFrame, 15)
end

C.LUAThemes["Blizzard_ItemInteractionUI"] = function()
	Reskin_ReforgeUI(ItemInteractionFrame)
end