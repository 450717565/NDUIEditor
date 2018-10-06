local F, C = unpack(select(2, ...))

C.themes["Blizzard_ItemUpgradeUI"] = function()
	local ItemButton = ItemUpgradeFrame.ItemButton
	F.StripTextures(ItemUpgradeFrame, true)
	F.StripTextures(ItemUpgradeFrameMoneyFrame, true)
	F.StripTextures(ItemUpgradeFrame.ButtonFrame, true)
	F.StripTextures(ItemButton, true)

	F.CreateBD(ItemButton, .25)
	F.CreateSD(ItemButton)
	ItemButton:SetHighlightTexture("")
	ItemButton:SetPushedTexture("")
	ItemButton.IconTexture:SetPoint("TOPLEFT", 1, -1)
	ItemButton.IconTexture:SetPoint("BOTTOMRIGHT", -1, 1)

	local bg = F.CreateBDFrame(ItemButton, .25)
	bg:SetSize(341, 50)
	bg:SetPoint("LEFT", ItemButton, "RIGHT", -1, 0)

	ItemButton:HookScript("OnEnter", function(self)
		self:SetBackdropBorderColor(1, .56, .85)
	end)
	ItemButton:HookScript("OnLeave", function(self)
		self:SetBackdropBorderColor(0, 0, 0)
	end)

	ItemButton.Cost.Icon:SetTexCoord(.08, .92, .08, .92)
	ItemButton.Cost.Icon.bg = F.CreateBDFrame(ItemButton.Cost.Icon)

	hooksecurefunc("ItemUpgradeFrame_Update", function()
		if GetItemUpgradeItemInfo() then
			ItemButton.IconTexture:SetTexCoord(.08, .92, .08, .92)
			ItemButton.Cost.Icon.bg:Show()
		else
			ItemButton.IconTexture:SetTexture("")
			ItemButton.Cost.Icon.bg:Hide()
		end
	end)

	local currency = ItemUpgradeFrameMoneyFrame.Currency
	currency.icon:SetPoint("LEFT", currency.count, "RIGHT", 1, 0)
	currency.icon:SetTexCoord(.08, .92, .08, .92)
	F.CreateBDFrame(currency.icon)

	local bg = F.CreateBDFrame(ItemUpgradeFrame)
	bg:SetAllPoints(ItemUpgradeFrame)

	F.ReskinPortraitFrame(ItemUpgradeFrame)
	F.Reskin(ItemUpgradeFrameUpgradeButton)
end