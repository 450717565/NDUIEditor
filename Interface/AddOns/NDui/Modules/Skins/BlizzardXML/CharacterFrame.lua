local _, ns = ...
local B, C, L, DB = unpack(ns)

local slots = DB.Slots
local cr, cg, cb = DB.cr, DB.cg, DB.cb

-- 角色
local function Update_AzeriteItem(self)
	if not self.styled then
		self.AzeriteTexture:SetAlpha(0)
		self.RankFrame.Texture:Hide()

		self.RankFrame.Label:ClearAllPoints()
		self.RankFrame.Label:SetPoint("TOP", self, 1, -1)
		B.ReskinText(self.RankFrame.Label, 0, 1, 1)

		self.styled = true
	end
end

local function Update_AzeriteEmpoweredItem(self)
	self.AzeriteTexture:SetAtlas("AzeriteIconFrame")
	self.AzeriteTexture:SetDrawLayer("BORDER", 1)
	self.AzeriteTexture:SetInside(self.icbg)
end

local function Update_Cosmetic(self)
	local itemLink = GetInventoryItemLink("player", self:GetID())
	self.IconOverlay:SetShown(itemLink and IsCosmeticItem(itemLink))
end

local function Update_PaperDollItemSlotButton(self)
	self.icon:SetShown(GetInventoryItemTexture("player", self:GetID()) ~= nil)
	Update_Cosmetic(self)
	B.ReskinHLTex(self, self.icbg)
end

local function Update_PaperDollEquipmentManagerPane()
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
end

local function Reskin_EquipmentFlyoutCreateButton()
	local buttons = #EquipmentFlyoutFrame.buttons
	local button = EquipmentFlyoutFrame.buttons[buttons]
	B.StripTextures(button)

	local icbg = B.ReskinIcon(button.icon)
	B.ReskinHLTex(button, icbg)

	local border = button.IconBorder
	B.ReskinBorder(border, icbg)
end

local function Update_EquipmentFlyoutDisplayButton(button)
	local location = button.location
	local border = button.IconBorder
	if not location or not border then return end

	border:SetShown(location < EQUIPMENTFLYOUT_FIRST_SPECIAL_LOCATION)
end

C.OnLoginThemes["CharacterFrame"] = function()
	-- CharacterFrame
	B.ReskinFrame(CharacterFrame)
	B.ReskinFrameTab(CharacterFrame, 3)

	B.StripTextures(CharacterModelFrame, 0)
	B.StripTextures(CharacterModelFrameControlFrame)

	for i = 1, #slots do
		local slot = _G["Character"..slots[i].."Slot"]
		B.StripTextures(slot)
		slot.ignoreTexture:SetTexture("Interface\\PaperDollInfoFrame\\UI-GearManager-LeaveItem-Transparent")

		local icbg = B.ReskinIcon(slot.icon)

		local border = slot.IconBorder
		B.ReskinBorder(border, icbg)

		local popout = slot.popoutButton
		B.StripTextures(popout)

		local cooldown = _G["Character"..slots[i].."SlotCooldown"]
		cooldown:SetInside(icbg)

		local overlay = slot.IconOverlay
		overlay:SetAtlas("CosmeticIconFrame")

		local tex = popout:CreateTexture(nil, "OVERLAY")
		tex:SetSize(14, 14)
		if slot.verticalFlyout then
			tex:SetTexture(DB.arrowTex.."down")
			tex:SetPoint("TOP", slot, "BOTTOM", 0, 1)
		else
			tex:SetTexture(DB.arrowTex.."right")
			tex:SetPoint("LEFT", slot, "RIGHT", -1, 0)
		end

		slot.icbg = icbg
		popout.Tex = tex

		B.Hook_OnEnter(popout)
		B.Hook_OnLeave(popout)

		hooksecurefunc(slot, "DisplayAsAzeriteItem", Update_AzeriteItem)
		hooksecurefunc(slot, "DisplayAsAzeriteEmpoweredItem", Update_AzeriteEmpoweredItem)
	end

	hooksecurefunc("PaperDollItemSlotButton_Update", Update_PaperDollItemSlotButton)

	-- CharacterStatsPane
	local StatsPane = CharacterStatsPane
	B.StripTextures(StatsPane)

	local ItemLevelFrame = StatsPane.ItemLevelFrame
	ItemLevelFrame:SetHeight(20)
	ItemLevelFrame.Background:Hide()

	local categorys = {
		StatsPane.ItemLevelCategory,
		StatsPane.AttributesCategory,
		StatsPane.EnhancementsCategory,
	}
	for _, category in pairs(categorys) do
		category:SetHeight(30)
		category.Background:Hide()
		B.ReskinText(category.Title, cr, cg, cb)

		local line = B.CreateLines(category, "H", true)
		line:SetPoint("BOTTOM", 0, 5)
	end

	-- PaperDollSidebarTabs
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

		local bg = B.CreateBDFrame(tab)
		B.ReskinHLTex(tab.Highlight, bg)
		B.ReskinHLTex(tab.Hider, bg)

		tab.Icon:SetInside(bg)
		if i == 1 then
			tab.Icon:SetTexCoord(.15, .85, .15, .85)
		end
	end

	B.ReskinScroll(PaperDollTitlesPaneScrollBar)
	for i = 1, 17 do
		local button = _G["PaperDollTitlesPaneButton"..i]
		button:DisableDrawLayer("BACKGROUND")
		B.ReskinHLTex(button, button, true)

		local selected = button.SelectedBar
		selected:SetColorTexture(cr, cg, cb, .5)
	end

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

	hooksecurefunc("PaperDollEquipmentManagerPane_Update", Update_PaperDollEquipmentManagerPane)

	-- GearManagerDialogPopup
	GearManagerDialogPopup:SetHeight(525)
	GearManagerDialogPopup:HookScript("OnShow", function(self)
		self:ClearAllPoints()
		self:SetPoint("TOPLEFT", PaperDollFrame, "TOPRIGHT", 10, 0)
	end)

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
		B.ReskinHLTex(bu, icbg)
	end

	-- EquipmentFlyoutFrame
	local Buttons = EquipmentFlyoutFrameButtons
	Buttons.bg1:SetAlpha(0)
	Buttons:DisableDrawLayer("ARTWORK")

	local Highlight = EquipmentFlyoutFrameHighlight
	Highlight:SetOutside(nil, 7, 7)

	local NavigationFrame = EquipmentFlyoutFrame.NavigationFrame
	B.ReskinFrame(NavigationFrame)
	B.ReskinArrow(NavigationFrame.PrevButton, "left")
	B.ReskinArrow(NavigationFrame.NextButton, "right")
	NavigationFrame:ClearAllPoints()
	NavigationFrame:SetPoint("TOP", Buttons, "BOTTOM", 0, -3)

	hooksecurefunc("EquipmentFlyout_CreateButton", Reskin_EquipmentFlyoutCreateButton)
	hooksecurefunc("EquipmentFlyout_DisplayButton", Update_EquipmentFlyoutDisplayButton)
end

-- 声望
local function Reskin_ReputationFrameBars()
	local numFactions = GetNumFactions()
	local factionOffset = FauxScrollFrame_GetOffset(ReputationListScrollFrame)

	for i = 1, NUM_FACTIONS_DISPLAYED do
		local factionIndex = factionOffset + i
		local atWarWith = select(7, GetFactionInfo(factionIndex))
		local factionRow = _G["ReputationBar"..i]
		local factionBar = _G["ReputationBar"..i.."ReputationBar"]

		local atWarBar = _G["ReputationBar"..i.."ReputationBarAtWarHighlight1"]
		atWarBar:SetColorTexture(1, 0, 0)

		if factionIndex <= numFactions then
			if factionBar then
				B.StripTextures(factionRow)

				if not factionBar.styled then
					B.ReskinStatusBar(factionBar, true)

					factionBar.styled = true
				end
			end

			if atWarWith then
				atWarBar:Show()
			else
				atWarBar:Hide()
			end
		end
	end
end

C.OnLoginThemes["ReputationFrame"] = function()
	B.ReskinFrame(ReputationDetailFrame)
	B.ReskinClose(ReputationDetailCloseButton)
	B.ReskinScroll(ReputationListScrollFrameScrollBar)

	local checks = {
		ReputationDetailAtWarCheckBox,
		ReputationDetailInactiveCheckBox,
		ReputationDetailLFGBonusReputationCheckBox,
		ReputationDetailMainScreenCheckBox,
	}
	for _, check in pairs(checks) do
		B.ReskinCheck(check)
	end

	ReputationDetailFrame:ClearAllPoints()
	ReputationDetailFrame:SetPoint("TOPLEFT", ReputationFrame, "TOPRIGHT", 3, -25)

	for i = 1, NUM_FACTIONS_DISPLAYED do
		B.ReskinCollapse(_G["ReputationBar"..i.."ExpandOrCollapseButton"])
	end

	hooksecurefunc("ReputationFrame_Update", Reskin_ReputationFrameBars)
end

-- 货币
local function Reskin_TokenFrameButtons()
	local buttons = TokenFrameContainer.buttons
	if not buttons then return end

	for i = 1, #buttons do
		local bu = buttons[i]
		bu.highlight:SetInside(nil, 1, 0)
		bu.highlight:SetColorTexture(cr, cg, cb, .25)

		if not bu.styled then
			bu.categoryMiddle:SetAlpha(0)
			bu.categoryLeft:SetAlpha(0)
			bu.categoryRight:SetAlpha(0)

			bu.icbg = B.ReskinIcon(bu.icon)

			if bu.expandIcon then
				bu.expBg = B.CreateBDFrame(bu.expandIcon, 0, -4)
			end

			bu.styled = true
		end

		if bu.isHeader then
			bu.icbg:Hide()
			bu.expBg:Show()
		else
			bu.icbg:Show()
			bu.expBg:Hide()
		end
	end
end

C.OnLoginThemes["TokenFrame"] = function()
	B.ReskinFrame(TokenFramePopup)
	B.ReskinCheck(TokenFramePopupInactiveCheckBox)
	B.ReskinCheck(TokenFramePopupBackpackCheckBox)
	B.ReskinScroll(TokenFrameContainerScrollBar)

	TokenFrame:HookScript("OnShow", Reskin_TokenFrameButtons)
	hooksecurefunc("TokenFrame_Update", Reskin_TokenFrameButtons)
	hooksecurefunc(TokenFrameContainer, "update", Reskin_TokenFrameButtons)
end