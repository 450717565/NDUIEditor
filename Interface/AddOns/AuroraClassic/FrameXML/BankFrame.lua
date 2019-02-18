local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	if not AuroraConfig.bags then return end

	-- [[ Bank ]]
	F.ReskinFrame(BankFrame)
	F.ReskinButton(BankFramePurchaseButton)
	F.ReskinTab(BankFrameTab1)
	F.ReskinTab(BankFrameTab2)
	F.ReskinInput(BankItemSearchBox)

	F.StripTextures(BankSlotsFrame, true)
	BankFrameMoneyFrameInset:Hide()
	BankFrameMoneyFrameBorder:Hide()

	local function styleBankButton(bu)
		bu:SetNormalTexture("")
		bu:SetPushedTexture("")

		local questTexture = bu.IconQuestTexture
		if questTexture then questTexture:SetAlpha(0) end

		local ic = F.ReskinIcon(bu.icon)
		F.ReskinTexture(bu, ic, false)

		local border = bu.IconBorder
		F.ReskinBorder(border, bu)

		local searchOverlay = bu.searchOverlay
		searchOverlay:SetAllPoints(ic)
	end

	for i = 1, 28 do
		styleBankButton(_G["BankFrameItem"..i])
	end

	for i = 1, 7 do
		local slots = BankSlotsFrame["Bag"..i]
		styleBankButton(slots)

		slots:SetCheckedTexture(C.media.checked)
		local ck = slots:GetCheckedTexture()
		ck:SetPoint("TOPLEFT", -C.mult, C.mult)
		ck:SetPoint("BOTTOMRIGHT", C.mult, -C.mult)
	end

	BankItemAutoSortButton:GetNormalTexture():SetTexCoord(.17, .83, .17, .83)
	BankItemAutoSortButton:GetPushedTexture():SetTexCoord(.17, .83, .17, .83)
	BankItemAutoSortButton:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)
	BankItemAutoSortButton:GetHighlightTexture():SetAllPoints()
	F.CreateBDFrame(BankItemAutoSortButton, 0)

	hooksecurefunc("BankFrameItemButton_Update", function(button)
		if not button.isBag and button.IconQuestTexture:IsShown() then
			button.IconBorder:SetVertexColor(1, 1, 0)
		end
	end)

	-- [[ Reagent bank ]]
	ReagentBankFrame:DisableDrawLayer("BACKGROUND")
	ReagentBankFrame:DisableDrawLayer("BORDER")
	ReagentBankFrame:DisableDrawLayer("ARTWORK")

	F.ReskinButton(ReagentBankFrame.DespositButton)
	F.ReskinButton(ReagentBankFrameUnlockInfoPurchaseButton)

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