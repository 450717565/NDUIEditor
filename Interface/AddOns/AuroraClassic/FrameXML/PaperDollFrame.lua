local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	local r, g, b = C.r, C.g, C.b

	-- [[ Item buttons ]]
	local function colourPopout(self)
		local aR, aG, aB
		local glow = self:GetParent().IconBorder

		if glow:IsShown() then
			aR, aG, aB = glow:GetVertexColor()
		else
			aR, aG, aB = r, g, b
		end

		self.arrow:SetVertexColor(aR, aG, aB)
	end

	local function clearPopout(self)
		self.arrow:SetVertexColor(1, 1, 1)
	end

	local function UpdateAzeriteItem(self)
		if not self.styled then
			self.AzeriteTexture:SetAlpha(0)
			self.RankFrame.Texture:SetTexture("")
			self.RankFrame.Label:ClearAllPoints()
			self.RankFrame.Label:SetPoint("BOTTOM", 1, 5)
			self.RankFrame.Label:SetTextColor(0, 1, 1)

			self.styled = true
		end
		self:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)
		self:GetHighlightTexture():SetAllPoints()
	end

	local function UpdateAzeriteEmpoweredItem(self)
		self.AzeriteTexture:SetAtlas("AzeriteIconFrame")
		self.AzeriteTexture:SetAllPoints()
		self.AzeriteTexture:SetDrawLayer("BORDER", 1)
	end

	local slots = {
		"Head", "Neck", "Shoulder", "Shirt", "Chest", "Waist", "Legs", "Feet", "Wrist",
		"Hands", "Finger0", "Finger1", "Trinket0", "Trinket1", "Back", "MainHand",
		"SecondaryHand", "Tabard",
	}

	for i = 1, #slots do
		local slot = _G["Character"..slots[i].."Slot"]
		F.StripTextures(slot)

		local bg = F.ReskinIcon(slot.icon, true)
		F.ReskinTexture(slot, bg, false)
		slot.SetHighlightTexture = F.dummy

		local border = slot.IconBorder
		F.ReskinTexture(border, slot, false, true)

		local popout = slot.popoutButton
		popout:SetNormalTexture("")
		popout:SetHighlightTexture("")

		local arrow = popout:CreateTexture(nil, "OVERLAY")
		if slot.verticalFlyout then
			arrow:SetSize(14, 8)
			arrow:SetTexture(C.media.arrowDown)
			arrow:SetPoint("TOP", slot, "BOTTOM", 0, 1)
		else
			arrow:SetSize(8, 14)
			arrow:SetTexture(C.media.arrowRight)
			arrow:SetPoint("LEFT", slot, "RIGHT", -1, 0)
		end
		popout.arrow = arrow

		popout:HookScript("OnEnter", clearPopout)
		popout:HookScript("OnLeave", colourPopout)

		hooksecurefunc(slot, "DisplayAsAzeriteItem", UpdateAzeriteItem)
		hooksecurefunc(slot, "DisplayAsAzeriteEmpoweredItem", UpdateAzeriteEmpoweredItem)
	end

	hooksecurefunc("PaperDollItemSlotButton_Update", function(button)
		-- also fires for bag slots, we don't want that
		if button.popoutButton then
			button.IconBorder:SetTexture(C.media.bdTex)
			button.icon:SetShown(button.hasItem)
			colourPopout(button.popoutButton)
		end
	end)

	-- [[ Stats pane ]]
	local pane = CharacterStatsPane
	pane.ClassBackground:Hide()
	local category = {pane.ItemLevelCategory, pane.AttributesCategory, pane.EnhancementsCategory}
	for _, v in pairs(category) do
		v:SetSize(190, 25)
		F.StripTextures(v)

		local bg = F.CreateBDFrame(v, .25)
		F.CreateGradient(bg)
	end

	-- [[ Sidebar tabs ]]
	for i = 1, #PAPERDOLL_SIDEBARS do
		local tab = _G["PaperDollSidebarTab"..i]
		tab.TabBg:Hide()

		local bg = F.CreateBDFrame(tab, .25)
		bg:SetPoint("TOPLEFT", 2, -3)
		bg:SetPoint("BOTTOMRIGHT", 0, -1)
		bg:SetFrameLevel(0)

		if i == 1 then
			for i = 1, 4 do
				local region = select(i, tab:GetRegions())
				region:SetTexCoord(0.16, 0.86, 0.16, 0.86)
				region.SetTexCoord = F.dummy
			end
		end

		F.ReskinTexture(tab.Hider, bg, false)
		F.ReskinTexture(tab.Highlight, bg, false)
	end

	-- [[ Equipment manager ]]
	GearManagerDialogPopup:SetHeight(525)
	F.StripTextures(GearManagerDialogPopup.BorderBox, true)
	F.ReskinFrame(GearManagerDialogPopup)

	F.StripTextures(GearManagerDialogPopupScrollFrame, true)
	F.StripTextures(PaperDollSidebarTabs, true)
	F.StripTextures(PaperDollEquipmentManagerPaneEquipSet, true)

	F.ReskinScroll(GearManagerDialogPopupScrollFrameScrollBar)
	F.ReskinButton(GearManagerDialogPopupOkay)
	F.ReskinButton(GearManagerDialogPopupCancel)
	F.ReskinInput(GearManagerDialogPopupEditBox)
	F.ReskinScroll(PaperDollTitlesPaneScrollBar)
	F.ReskinScroll(PaperDollEquipmentManagerPaneScrollBar)
	F.ReskinButton(PaperDollEquipmentManagerPaneEquipSet)
	F.ReskinButton(PaperDollEquipmentManagerPaneSaveSet)
	PaperDollEquipmentManagerPaneEquipSet:SetWidth(85)
	PaperDollEquipmentManagerPaneSaveSet:SetWidth(85)
	PaperDollEquipmentManagerPaneSaveSet:SetPoint("LEFT", PaperDollEquipmentManagerPaneEquipSet, "RIGHT", 2, 0)

	for i = 1, NUM_GEARSET_ICONS_SHOWN do
		local bu = _G["GearManagerDialogPopupButton"..i]
		bu:SetCheckedTexture(C.media.checked)
		select(2, bu:GetRegions()):Hide()

		local ic = F.ReskinIcon(_G["GearManagerDialogPopupButton"..i.."Icon"], true)
		F.ReskinTexture(bu, ic, false)
	end

	local sets = false
	PaperDollSidebarTab3:HookScript("OnClick", function()
		if sets == false then
			for i = 1, 9 do
				_G["PaperDollEquipmentManagerPaneButton"..i.."BgTop"]:SetAlpha(0)
				_G["PaperDollEquipmentManagerPaneButton"..i.."BgMiddle"]:SetAlpha(0)
				_G["PaperDollEquipmentManagerPaneButton"..i.."BgBottom"]:SetAlpha(0)

				local bu = _G["PaperDollEquipmentManagerPaneButton"..i]
				bu.HighlightBar:SetColorTexture(r, g, b, .25)
				bu.SelectedBar:SetColorTexture(r, g, b, .25)

				local sp = _G["PaperDollEquipmentManagerPaneButton"..i.."Stripe"]
				sp:Hide()
				sp.Show = F.dummy

				local ic = _G["PaperDollEquipmentManagerPaneButton"..i.."Icon"]
				F.ReskinIcon(ic, true)
			end

			sets = true
		end
	end)

	local titles = false
	hooksecurefunc("PaperDollTitlesPane_Update", function()
		if titles == false then
			for i = 1, 17 do
				_G["PaperDollTitlesPaneButton"..i]:DisableDrawLayer("BACKGROUND")
			end
			titles = true
		end
	end)
end)