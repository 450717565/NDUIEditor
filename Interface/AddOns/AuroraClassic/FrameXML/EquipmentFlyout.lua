local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	EquipmentFlyoutFrameHighlight:Hide()
	EquipmentFlyoutFrameButtons.bg1:SetAlpha(0)
	EquipmentFlyoutFrameButtons:DisableDrawLayer("ARTWORK")

	F.CreateBD(EquipmentFlyoutFrame.NavigationFrame)
	F.CreateSD(EquipmentFlyoutFrame.NavigationFrame)
	F.ReskinArrow(EquipmentFlyoutFrame.NavigationFrame.PrevButton, "left")
	F.ReskinArrow(EquipmentFlyoutFrame.NavigationFrame.NextButton, "right")

	hooksecurefunc("EquipmentFlyout_CreateButton", function()
		local bu = EquipmentFlyoutFrame.buttons[#EquipmentFlyoutFrame.buttons]
		bu:SetNormalTexture("")
		bu:SetPushedTexture("")

		local ic = F.ReskinIcon(bu.icon, true)
		F.ReskinTexture(bu, false, ic)

		local border = bu.IconBorder
		F.ReskinTexture(border, false, bu, true)
	end)

	hooksecurefunc("EquipmentFlyout_DisplayButton", function(button)
		local location = button.location
		local border = button.IconBorder
		if not location or location < 0 or not border then return end

		if location == EQUIPMENTFLYOUT_PLACEINBAGS_LOCATION then
			border:Hide()
		else
			border:Show()
		end
	end)
end)