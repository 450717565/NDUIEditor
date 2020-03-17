local B, C, L, DB = unpack(select(2, ...))

tinsert(C.defaultThemes, function()
	local Buttons = EquipmentFlyoutFrameButtons
	Buttons.bg1:SetAlpha(0)
	Buttons:DisableDrawLayer("ARTWORK")

	local Highlight = EquipmentFlyoutFrameHighlight
	Highlight:Hide()

	local NavigationFrame = EquipmentFlyoutFrame.NavigationFrame
	B.ReskinFrame(NavigationFrame)
	B.ReskinArrow(NavigationFrame.PrevButton, "left")
	B.ReskinArrow(NavigationFrame.NextButton, "right")
	NavigationFrame:ClearAllPoints()
	NavigationFrame:SetPoint("TOP", Buttons, "BOTTOM", 0, -3)

	hooksecurefunc("EquipmentFlyout_CreateButton", function()
		local buttons = #EquipmentFlyoutFrame.buttons
		local button = EquipmentFlyoutFrame.buttons[buttons]
		B.StripTextures(button)

		local icbg = B.ReskinIcon(button.icon)
		B.ReskinHighlight(button, icbg)

		local border = button.IconBorder
		B.ReskinBorder(border, icbg)

		if not button.Eye then
			button.Eye = button:CreateTexture(nil, "OVERLAY")
			button.Eye:SetAtlas("Nzoth-inventory-icon")
			button.Eye:SetInside(icbg)
		end
	end)

	hooksecurefunc("EquipmentFlyout_DisplayButton", function(button)
		local location = button.location
		local border = button.IconBorder
		if not location or not border then return end

		local _, _, bags, voidStorage, slot, bag = EquipmentManager_UnpackLocation(location)
		if voidStorage then
			button.Eye:Hide()
			return
		end

		local itemLink
		if bags then
			itemLink = GetContainerItemLink(bag, slot)
		else
			itemLink = GetInventoryItemLink("player", slot)
		end

		button.Eye:SetShown(itemLink and IsCorruptedItem(itemLink))
	end)
end)