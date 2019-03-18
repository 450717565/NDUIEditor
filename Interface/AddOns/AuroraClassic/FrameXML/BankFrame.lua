local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	if not AuroraConfig.bags then return end

	-- [[ Bank ]]
	F.ReskinFrame(BankFrame)
	F.ReskinButton(BankFramePurchaseButton)
	F.ReskinInput(BankItemSearchBox)
	F.ReskinSort(BankItemAutoSortButton)

	F.StripTextures(BankSlotsFrame)
	F.StripTextures(BankFrameMoneyFrame)

	F.SetupTabStyle(BankFrame, 3)

	local function styleBankButton(bu)
		F.CleanTextures(bu)

		local questTexture = bu.IconQuestTexture
		if questTexture then questTexture:SetAlpha(0) end

		local slotTexture = bu.SlotHighlightTexture
		if slotTexture then F.ReskinBorder(slotTexture, bu) end

		local border = bu.IconBorder
		F.ReskinBorder(border, bu)

		local icbg = F.ReskinIcon(bu.icon)
		F.ReskinTexture(bu, icbg, false)

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
	F.StripTextures(ReagentBankFrame)
	F.ReskinButton(ReagentBankFrame.DespositButton)
	F.ReskinButton(ReagentBankFrameUnlockInfoPurchaseButton)

	ReagentBankFrame:DisableDrawLayer("ARTWORK")
	ReagentBankFrame:DisableDrawLayer("BACKGROUND")
	ReagentBankFrame:DisableDrawLayer("BORDER")

	local styled = false
	ReagentBankFrame:HookScript("OnShow", function()
		if not styled then
			for i = 1, 98 do
				styleBankButton(_G["ReagentBankFrameItem"..i])
			end

			styled = true
		end
	end)
end)