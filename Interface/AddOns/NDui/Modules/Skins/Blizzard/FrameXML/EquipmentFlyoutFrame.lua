local B, C, L, DB = unpack(select(2, ...))

tinsert(C.defaultThemes, function()
	local NavigationFrame = EquipmentFlyoutFrame.NavigationFrame
	B.ReskinFrame(NavigationFrame)
	B.ReskinArrow(NavigationFrame.PrevButton, "left")
	B.ReskinArrow(NavigationFrame.NextButton, "right")

	local Buttons = EquipmentFlyoutFrameButtons
	Buttons.bg1:SetAlpha(0)
	Buttons:DisableDrawLayer("ARTWORK")

	local Highlight = EquipmentFlyoutFrameHighlight
	Highlight:Hide()

	hooksecurefunc("EquipmentFlyout_CreateButton", function()
		local buttons = #EquipmentFlyoutFrame.buttons
		local button = EquipmentFlyoutFrame.buttons[buttons]
		B.StripTextures(button)

		local icbg = B.ReskinIcon(button.icon)
		B.ReskinTexture(button, icbg)

		local border = button.IconBorder
		B.ReskinBorder(border, icbg)
	end)
end)