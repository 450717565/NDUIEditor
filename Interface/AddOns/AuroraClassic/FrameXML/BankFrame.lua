local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	if not AuroraConfig.bags then return end

	local r, g, b = C.r, C.g, C.b

	-- [[ Bank ]]
	F.ReskinPortraitFrame(BankFrame, true)
	F.Reskin(BankFramePurchaseButton)
	F.ReskinTab(BankFrameTab1)
	F.ReskinTab(BankFrameTab2)
	F.ReskinInput(BankItemSearchBox)

	F.StripTextures(BankSlotsFrame, true)
	BankFrameMoneyFrameInset:Hide()
	BankFrameMoneyFrameBorder:Hide()

	local function styleBankButton(bu)
		bu:SetNormalTexture("")
		bu:SetPushedTexture("")

		local ic = F.ReskinIcon(bu.icon, true)
		F.ReskinTexture(bu, false, ic)

		local questTexture = bu.IconQuestTexture

		if questTexture then
			questTexture:SetDrawLayer("BACKGROUND")
			questTexture:SetSize(1, 1)
		end

		local border = bu.IconBorder
		F.ReskinTexture(border, false, bu, true)

		local searchOverlay = bu.searchOverlay
		searchOverlay:SetPoint("TOPLEFT", -C.mult, C.mult)
		searchOverlay:SetPoint("BOTTOMRIGHT", C.mult, -C.mult)
	end

	for i = 1, 28 do
		styleBankButton(_G["BankFrameItem"..i])
	end

	for i = 1, 7 do
		styleBankButton(BankSlotsFrame["Bag"..i])
	end

	BankItemAutoSortButton:GetNormalTexture():SetTexCoord(.17, .83, .17, .83)
	BankItemAutoSortButton:GetPushedTexture():SetTexCoord(.17, .83, .17, .83)
	BankItemAutoSortButton:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)
	BankItemAutoSortButton:GetHighlightTexture():SetAllPoints()
	F.CreateBDFrame(BankItemAutoSortButton, .25)

	hooksecurefunc("BankFrameItemButton_Update", function(button)
		if not button.isBag and button.IconQuestTexture:IsShown() then
			button.IconBorder:SetVertexColor(1, 1, 0)
		end
	end)

	-- [[ Reagent bank ]]
	ReagentBankFrame:DisableDrawLayer("BACKGROUND")
	ReagentBankFrame:DisableDrawLayer("BORDER")
	ReagentBankFrame:DisableDrawLayer("ARTWORK")

	F.Reskin(ReagentBankFrame.DespositButton)
	F.Reskin(ReagentBankFrameUnlockInfoPurchaseButton)

	-- make button more visible
	ReagentBankFrameUnlockInfoBlackBG:SetColorTexture(.1, .1, .1)

	local reagentButtonsStyled = false
	ReagentBankFrame:HookScript("OnShow", function()
		if not reagentButtonsStyled then
			for i = 1, 98 do
				styleBankButton(_G["ReagentBankFrameItem"..i])
			end
			reagentButtonsStyled = true
		end
	end)
end)