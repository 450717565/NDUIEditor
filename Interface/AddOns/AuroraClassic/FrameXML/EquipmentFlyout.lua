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
		local border = bu.IconBorder

		bu:SetNormalTexture("")
		bu:SetPushedTexture("")
		bu:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)
		F.CreateBDFrame(bu)

		border:SetTexture(C.media.backdrop)
		border.SetTexture = F.dummy
		border:SetPoint("TOPLEFT", -1.2, 1.2)
		border:SetPoint("BOTTOMRIGHT", 1.2, -1.2)
		border:SetDrawLayer("BACKGROUND", 1)

		bu.icon:SetTexCoord(.08, .92, .08, .92)
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