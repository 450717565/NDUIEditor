local B, C, L, DB = unpack(select(2, ...))

tinsert(C.defaultThemes, function()
	local cr, cg, cb = DB.r, DB.g, DB.b
	local slots = DB.Slots

	B.ReskinFrame(CharacterFrame)
	B.SetupTabStyle(CharacterFrame, 3)

	B.StripTextures(CharacterModelFrame, 0)
	B.StripTextures(CharacterModelFrameControlFrame)

	-- [[ Item buttons ]]
	local function UpdateAzeriteItem(self)
		if not self.styled then
			self.AzeriteTexture:SetAlpha(0)
			self.RankFrame.Texture:Hide()

			self.RankFrame.Label:ClearAllPoints()
			self.RankFrame.Label:SetPoint("TOP", self, 1, -1)
			self.RankFrame.Label:SetTextColor(0, 1, 1)

			self.styled = true
		end

		local hl = self:GetHighlightTexture()
		hl:SetColorTexture(1, 1, 1, .25)
		hl:SetInside(self.icbg)
	end

	local function UpdateAzeriteEmpoweredItem(self)
		self.AzeriteTexture:SetAtlas("AzeriteIconFrame")
		self.AzeriteTexture:SetDrawLayer("BORDER", 1)
		self.AzeriteTexture:SetInside(self.icbg)
	end

	local function UpdateCorruption(self)
		local itemLink = GetInventoryItemLink("player", self:GetID())
		self.IconOverlay:SetShown(itemLink and IsCorruptedItem(itemLink))
		self.IconOverlay:SetInside(self.icbg)
	end

	for i = 1, #slots do
		local slot = _G["Character"..slots[i].."Slot"]
		B.StripTextures(slot)
		slot.ignoreTexture:SetTexture("Interface\\PaperDollInfoFrame\\UI-GearManager-LeaveItem-Transparent")
		slot.IconOverlay:SetAtlas("Nzoth-inventory-icon")

		local icbg = B.ReskinIcon(slot.icon)

		local border = slot.IconBorder
		B.ReskinBorder(border, icbg)

		local popout = slot.popoutButton
		B.StripTextures(popout)

		local cooldown = _G["Character"..slots[i].."SlotCooldown"]
		cooldown:SetInside(icbg)

		local corrupted = slot.CorruptedHighlightTexture
		corrupted:SetAtlas("Nzoth-charactersheet-item-glow")
		corrupted:ClearAllPoints()
		corrupted:Point("TOPLEFT", icbg, -15, 15)
		corrupted:Point("BOTTOMRIGHT", icbg, 14, -14)

		local bgTex = popout:CreateTexture(nil, "OVERLAY")
		if slot.verticalFlyout then
			bgTex:SetSize(14, 8)
			bgTex:SetTexture(DB.arrowDown)
			bgTex:SetPoint("TOP", slot, "BOTTOM", 0, 1)
		else
			bgTex:SetSize(8, 14)
			bgTex:SetTexture(DB.arrowRight)
			bgTex:SetPoint("LEFT", slot, "RIGHT", -1, 0)
		end

		slot.icbg = icbg
		popout.bgTex = bgTex

		B.Hook_OnEnter(popout)
		B.Hook_OnLeave(popout)

		hooksecurefunc(slot, "DisplayAsAzeriteItem", UpdateAzeriteItem)
		hooksecurefunc(slot, "DisplayAsAzeriteEmpoweredItem", UpdateAzeriteEmpoweredItem)
	end

	hooksecurefunc("PaperDollItemSlotButton_Update", function(button)
		button.icon:SetShown(GetInventoryItemTexture("player", button:GetID()) ~= nil)
		UpdateCorruption(button)
		B.ReskinHighlight(button, button.icbg)
	end)

	-- [[ Stats pane ]]
	local StatsPane = CharacterStatsPane
	B.StripTextures(StatsPane)

	local ItemLevelFrame = StatsPane.ItemLevelFrame
	ItemLevelFrame:SetHeight(20)
	ItemLevelFrame.Background:Hide()

	local categorys = {StatsPane.ItemLevelCategory, StatsPane.AttributesCategory, StatsPane.EnhancementsCategory}
	for _, category in pairs(categorys) do
		category:SetHeight(30)
		category.Background:Hide()
		category.Title:SetTextColor(cr, cg, cb)

		local width, height = 95, C.mult*2

		local left = CreateFrame("Frame", nil, category)
		left:SetPoint("TOPRIGHT", category, "BOTTOM", 0, 5)
		B.CreateGA(left, width, height, "Horizontal", cr, cg, cb, 0, DB.Alpha)

		local right = CreateFrame("Frame", nil, category)
		right:SetPoint("TOPLEFT", category, "BOTTOM", 0, 5)
		B.CreateGA(right, width, height, "Horizontal", cr, cg, cb, DB.Alpha, 0)
	end

	-- [[ Sidebar tabs ]]
	local SidebarTabs = PaperDollSidebarTabs
	B.StripTextures(SidebarTabs)
	SidebarTabs:ClearAllPoints()
	SidebarTabs:SetPoint("BOTTOM", CharacterFrameInsetRight, "TOP", 0, 0)

	local SidebarTab3 = PaperDollSidebarTab3
	SidebarTab3:ClearAllPoints()
	SidebarTab3:SetPoint("RIGHT", SidebarTabs, "RIGHT", -17, 0)

	for i = 1, #PAPERDOLL_SIDEBARS do
		local tab = _G["PaperDollSidebarTab"..i]
		tab:SetSize(31, 33)
		tab.TabBg:Hide()

		local bg = B.CreateBDFrame(tab, 0)
		B.ReskinHighlight(tab.Highlight, bg)
		B.ReskinHighlight(tab.Hider, bg)

		if i == 1 then
			tab.Icon:SetTexCoord(0.16, 0.86, 0.16, 0.86)
			tab.Icon.SetTexCoord = B.Dummy
		end
		tab.Icon:SetInside(bg)
	end

	-- PaperDollTitlesPane
	B.ReskinScroll(PaperDollTitlesPaneScrollBar)
	for i = 1, 17 do
		local button = _G["PaperDollTitlesPaneButton"..i]
		button:DisableDrawLayer("BACKGROUND")
		B.ReskinHighlight(button, button, true)

		local selected = button.SelectedBar
		selected:SetColorTexture(cr, cg, cb, .5)
	end

	-- PaperDollEquipmentManager
	local EquipSet = PaperDollEquipmentManagerPaneEquipSet
	B.ReskinButton(EquipSet)
	EquipSet:SetWidth(85)
	EquipSet:ClearAllPoints()
	EquipSet:SetPoint("TOPLEFT", 0, -2)

	local SaveSet = PaperDollEquipmentManagerPaneSaveSet
	B.ReskinButton(SaveSet)
	SaveSet:SetWidth(85)
	SaveSet:ClearAllPoints()
	SaveSet:SetPoint("LEFT", EquipSet, "RIGHT", 2, 0)

	B.ReskinScroll(PaperDollEquipmentManagerPaneScrollBar)

	hooksecurefunc("PaperDollEquipmentManagerPane_Update", function()
		local buttons = PaperDollEquipmentManagerPane.buttons
		for i = 1, #buttons do
			local button = buttons[i]
			button:DisableDrawLayer("BACKGROUND")

			if not button.styled then
				B.ReskinIcon(button.icon)
				button.HighlightBar:SetColorTexture(cr, cg, cb, .5)
				button.SelectedBar:SetColorTexture(cr, cg, cb, .5)

				button.styled = true
			end
		end
	end)

	-- GearManagerDialogPopup
	GearManagerDialogPopup:SetHeight(525)
	B.ReskinFrame(GearManagerDialogPopup)
	B.ReskinScroll(GearManagerDialogPopupScrollFrameScrollBar)
	B.ReskinButton(GearManagerDialogPopupOkay)
	B.ReskinButton(GearManagerDialogPopupCancel)
	B.ReskinInput(GearManagerDialogPopupEditBox)

	for i = 1, NUM_GEARSET_ICONS_SHOWN do
		local button = "GearManagerDialogPopupButton"..i
		local bu = _G[button]
		B.StripTextures(bu)

		local icbg = B.ReskinIcon(bu.icon)
		B.ReskinHighlight(bu, icbg)
	end
end)