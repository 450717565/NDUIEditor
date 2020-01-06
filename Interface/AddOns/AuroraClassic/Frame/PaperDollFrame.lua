local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	local cr, cg, cb = C.r, C.g, C.b

	-- [[ Item buttons ]]
	local function UpdateAzeriteItem(self)
		if not self.styled then
			self.AzeriteTexture:SetAlpha(0)
			self.RankFrame.Texture:Hide()

			self.RankFrame.Label:ClearAllPoints()
			self.RankFrame.Label:SetPoint("BOTTOM", 1, 5)
			self.RankFrame.Label:SetTextColor(0, 1, 1)

			self.styled = true
		end

		local hl = self:GetHighlightTexture()
		hl:SetColorTexture(1, 1, 1, .25)
		hl:SetAllPoints()
	end

	local function UpdateAzeriteEmpoweredItem(self)
		self.AzeriteTexture:SetAtlas("AzeriteIconFrame")
		self.AzeriteTexture:SetAllPoints()
	end

	local slots = {"Head", "Neck", "Shoulder", "Back", "Chest", "Shirt", "Tabard", "Wrist", "Hands", "Waist", "Legs", "Feet", "Finger0", "Finger1", "Trinket0", "Trinket1", "MainHand", "SecondaryHand"}

	for i = 1, #slots do
		local slot = _G["Character"..slots[i].."Slot"]
		F.StripTextures(slot)
		slot.ignoreTexture:SetTexture("Interface\\PaperDollInfoFrame\\UI-GearManager-LeaveItem-Transparent")

		local icbg = F.ReskinIcon(slot.icon)
		F.ReskinTexture(slot, icbg)
		slot.SetHighlightTexture = F.Dummy

		local border = slot.IconBorder
		F.ReskinBorder(border, slot)

		local popout = slot.popoutButton
		F.StripTextures(popout)

		local bgTex = popout:CreateTexture(nil, "OVERLAY")
		if slot.verticalFlyout then
			bgTex:SetSize(14, 8)
			bgTex:SetTexture(C.media.arrowDown)
			bgTex:SetPoint("TOP", slot, "BOTTOM", 0, 1)
		else
			bgTex:SetSize(8, 14)
			bgTex:SetTexture(C.media.arrowRight)
			bgTex:SetPoint("LEFT", slot, "RIGHT", -1, 0)
		end
		popout.bgTex = bgTex

		popout:HookScript("OnEnter", F.TexOnEnter)
		popout:HookScript("OnLeave", F.TexOnLeave)

		hooksecurefunc(slot, "DisplayAsAzeriteItem", UpdateAzeriteItem)
		hooksecurefunc(slot, "DisplayAsAzeriteEmpoweredItem", UpdateAzeriteEmpoweredItem)

		local cooldown = _G["Character"..slots[i].."SlotCooldown"]
		cooldown:SetPoint("TOPLEFT", icbg, C.mult, -C.mult)
		cooldown:SetPoint("BOTTOMRIGHT", icbg, -C.mult, C.mult)
	end

	hooksecurefunc("PaperDollItemSlotButton_Update", function(self)
		self.icon:SetShown(GetInventoryItemTexture("player", self:GetID()) ~= nil)
	end)

	-- [[ Stats pane ]]
	local StatsPane = CharacterStatsPane
	F.StripTextures(StatsPane)

	local ItemLevelFrame = StatsPane.ItemLevelFrame
	ItemLevelFrame:SetHeight(20)
	ItemLevelFrame.Background:Hide()

	local categorys = {StatsPane.ItemLevelCategory, StatsPane.AttributesCategory, StatsPane.EnhancementsCategory}
	for _, category in pairs(categorys) do
		category:SetHeight(30)
		category.Background:Hide()
		category.Title:SetTextColor(cr, cg, cb)

		local width, height = 95, C.pixel

		local left = CreateFrame("Frame", nil, category)
		left:SetPoint("TOPRIGHT", category, "BOTTOM", 0, 5)
		F.CreateGA(left, width, height, "Horizontal", cr, cg, cb, 0, .8)

		local right = CreateFrame("Frame", nil, category)
		right:SetPoint("TOPLEFT", category, "BOTTOM", 0, 5)
		F.CreateGA(right, width, height, "Horizontal", cr, cg, cb, .8, 0)
	end

	-- [[ Sidebar tabs ]]
	F.StripTextures(PaperDollSidebarTabs)
	for i = 1, #PAPERDOLL_SIDEBARS do
		local tab = _G["PaperDollSidebarTab"..i]
		tab.TabBg:Hide()

		local bg = F.CreateBDFrame(tab, 0)
		bg:SetPoint("TOPLEFT", 2, -3)
		bg:SetPoint("BOTTOMRIGHT", 0, -1)
		bg:SetFrameLevel(0)

		if i == 1 then
			tab.Icon:SetTexCoord(0.16, 0.86, 0.16, 0.86)
			tab.Icon.SetTexCoord = F.Dummy
		end

		F.ReskinTexture(tab, bg)
		F.ReskinTexture(tab.Hider, bg)
	end

	-- PaperDollTitlesPane
	F.ReskinScroll(PaperDollTitlesPaneScrollBar)
	for i = 1, 17 do
		local button = _G["PaperDollTitlesPaneButton"..i]
		button:DisableDrawLayer("BACKGROUND")
		F.ReskinTexture(button, button, true)

		local selected = button.SelectedBar
		F.ReskinTexture(selected, button, true, .5)
	end

	-- PaperDollEquipmentManager
	local EquipSet = PaperDollEquipmentManagerPaneEquipSet
	F.ReskinButton(EquipSet)
	EquipSet:SetWidth(85)
	EquipSet:ClearAllPoints()
	EquipSet:SetPoint("TOPLEFT", 0, -2)

	local SaveSet = PaperDollEquipmentManagerPaneSaveSet
	F.ReskinButton(SaveSet)
	SaveSet:SetWidth(85)
	SaveSet:ClearAllPoints()
	SaveSet:SetPoint("LEFT", EquipSet, "RIGHT", 2, 0)

	F.ReskinScroll(PaperDollEquipmentManagerPaneScrollBar)

	hooksecurefunc("PaperDollEquipmentManagerPane_Update", function()
		local buttons = PaperDollEquipmentManagerPane.buttons
		for i = 1, #buttons do
			local button = buttons[i]
			button:DisableDrawLayer("BACKGROUND")

			if not button.styled then
				F.ReskinIcon(button.icon)
				F.ReskinTexture(button.HighlightBar, button, true, .5)
				F.ReskinTexture(button.SelectedBar, button, true, .5)

				button.styled = true
			end
		end
	end)

	-- GearManagerDialogPopup
	GearManagerDialogPopup:SetHeight(525)
	F.ReskinFrame(GearManagerDialogPopup)
	F.ReskinScroll(GearManagerDialogPopupScrollFrameScrollBar)
	F.ReskinButton(GearManagerDialogPopupOkay)
	F.ReskinButton(GearManagerDialogPopupCancel)
	F.ReskinInput(GearManagerDialogPopupEditBox)

	for i = 1, NUM_GEARSET_ICONS_SHOWN do
		local button = "GearManagerDialogPopupButton"..i
		local bu = _G[button]
		F.StripTextures(bu)

		local icbg = F.ReskinIcon(bu.icon)
		F.ReskinTexture(bu, icbg)
		F.ReskinTexed(bu, icbg)
	end
end)