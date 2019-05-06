local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	local NavigationFrame = EquipmentFlyoutFrame.NavigationFrame
	F.ReskinFrame(NavigationFrame)
	F.ReskinArrow(NavigationFrame.PrevButton, "left")
	F.ReskinArrow(NavigationFrame.NextButton, "right")

	local Buttons = EquipmentFlyoutFrameButtons
	Buttons.bg1:SetAlpha(0)
	Buttons:DisableDrawLayer("ARTWORK")

	local Highlight = EquipmentFlyoutFrameHighlight
	Highlight:Hide()

	hooksecurefunc("EquipmentFlyout_CreateButton", function()
		local buttons = #EquipmentFlyoutFrame.buttons
		local button = EquipmentFlyoutFrame.buttons[buttons]
		F.StripTextures(button)

		local icbg = F.ReskinIcon(button.icon)
		F.ReskinTexture(button, icbg, false)

		local border = button.IconBorder
		F.ReskinBorder(border, button)
	end)
end)