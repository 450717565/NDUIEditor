local B, C, L, DB = unpack(select(2, ...))

tinsert(C.defaultThemes, function()
	if NDuiDB["Bags"]["Enable"] then return end

	-- [[ Bank ]]
	B.ReskinFrame(BankFrame)
	B.ReskinButton(BankFramePurchaseButton)
	B.ReskinInput(BankItemSearchBox)
	B.ReskinSort(BankItemAutoSortButton)

	B.StripTextures(BankSlotsFrame)
	B.StripTextures(BankFrameMoneyFrame)

	B.ReskinFrameTab(BankFrame, 3)

	local function styleBankButton(bu)
		B.CleanTextures(bu)

		local questTexture = bu.IconQuestTexture
		if questTexture then questTexture:SetAlpha(0) end

		local icbg = B.ReskinIcon(bu.icon)
		B.ReskinHighlight(bu, icbg)

		local border = bu.IconBorder
		B.ReskinBorder(border, icbg)

		local slotTexture = bu.SlotHighlightTexture
		if slotTexture then B.ReskinSpecialBorder(slotTexture, icbg) end

		local searchOverlay = bu.searchOverlay
		searchOverlay:SetAllPoints(icbg)
	end

	for i = 1, 28 do
		styleBankButton(_G["BankFrameItem"..i])
	end

	for i = 1, 7 do
		styleBankButton(BankSlotsFrame["Bag"..i])
	end

	hooksecurefunc("BankFrameItemButton_Update", function(button)
		if not button.isBag and button.IconQuestTexture:IsShown() then
			button.IconBorder:SetVertexColor(1, 1, 0)
		end
	end)

	-- [[ Reagent bank ]]
	B.StripTextures(ReagentBankFrame)
	B.ReskinButton(ReagentBankFrame.DespositButton)
	B.ReskinButton(ReagentBankFrameUnlockInfoPurchaseButton)

	ReagentBankFrame:DisableDrawLayer("ARTWORK")
	ReagentBankFrame:DisableDrawLayer("BACKGROUND")
	ReagentBankFrame:DisableDrawLayer("BORDER")

	ReagentBankFrame:HookScript("OnShow", function(self)
		if not self.styled then
			for i = 1, 98 do
				local item = _G["ReagentBankFrameItem"..i]
				styleBankButton(item)
				BankFrameItemButton_Update(item)
			end

			self.styled = true
		end
	end)
end)