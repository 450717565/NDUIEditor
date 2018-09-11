local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	if not AuroraConfig.bags then return end

	local r, g, b = C.r, C.g, C.b

	-- [[ Bank ]]
	F.ReskinPortraitFrame(BankFrame)
	F.Reskin(BankFramePurchaseButton)
	F.ReskinTab(BankFrameTab1)
	F.ReskinTab(BankFrameTab2)
	F.ReskinInput(BankItemSearchBox)

	F.StripTextures(BankSlotsFrame, true)
	BankFrameMoneyFrameInset:Hide()
	BankFrameMoneyFrameBorder:Hide()

	local function onEnter(self)
		self.bg:SetBackdropBorderColor(r, g, b)
	end

	local function onLeave(self)
		self.bg:SetBackdropBorderColor(0, 0, 0)
	end

	local function styleBankButton(bu)
		local border = bu.IconBorder
		local questTexture = bu.IconQuestTexture
		local searchOverlay = bu.searchOverlay

		questTexture:SetDrawLayer("BACKGROUND")
		questTexture:SetSize(1, 1)

		border:SetTexture(C.media.backdrop)
		border.SetTexture = F.dummy
		border:SetPoint("TOPLEFT", -1.2, 1.2)
		border:SetPoint("BOTTOMRIGHT", 1.2, -1.2)
		border:SetDrawLayer("BACKGROUND", 1)

		searchOverlay:SetPoint("TOPLEFT", -1.2, 1.2)
		searchOverlay:SetPoint("BOTTOMRIGHT", 1.2, -1.2)

		bu:SetNormalTexture("")
		bu:SetPushedTexture("")
		bu:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)

		bu.icon:SetTexCoord(.08, .92, .08, .92)
		F.CreateBDFrame(bu, .25)

		bu:HookScript("OnEnter", onEnter)
		bu:HookScript("OnLeave", onLeave)
	end

	for i = 1, 28 do
		styleBankButton(_G["BankFrameItem"..i])
	end

	for i = 1, 7 do
		local bag = BankSlotsFrame["Bag"..i]
		local _, highlightFrame = bag:GetChildren()
		local border = bag.IconBorder
		local searchOverlay = bag.searchOverlay

		bag:SetNormalTexture("")
		bag:SetPushedTexture("")
		bag:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)

		highlightFrame:GetRegions():SetTexture(C.media.checked)

		border:SetTexture(C.media.backdrop)
		border.SetTexture = F.dummy
		border:SetPoint("TOPLEFT", -1.2, 1.2)
		border:SetPoint("BOTTOMRIGHT", 1.2, -1.2)
		border:SetDrawLayer("BACKGROUND", 1)

		searchOverlay:SetPoint("TOPLEFT", -1.2, 1.2)
		searchOverlay:SetPoint("BOTTOMRIGHT", 1.2, -1.2)

		bag.icon:SetTexCoord(.08, .92, .08, .92)

		F.CreateBDFrame(bag, .25)

		bag:HookScript("OnEnter", onEnter)
		bag:HookScript("OnLeave", onLeave)
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