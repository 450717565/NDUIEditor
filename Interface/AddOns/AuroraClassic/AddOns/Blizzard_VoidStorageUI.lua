local F, C = unpack(select(2, ...))

C.themes["Blizzard_VoidStorageUI"] = function()
	F.StripTextures(VoidStorageFrame, true)
	F.StripTextures(VoidStorageBorderFrame, true)
	F.CreateBD(VoidStorageFrame)
	F.CreateSD(VoidStorageFrame)

	F.StripTextures(VoidStoragePurchaseFrame, true)
	F.CreateBD(VoidStoragePurchaseFrame)
	F.CreateSD(VoidStoragePurchaseFrame)

	F.Reskin(VoidStoragePurchaseButton)
	F.Reskin(VoidStorageHelpBoxButton)
	F.Reskin(VoidStorageTransferButton)
	F.ReskinClose(VoidStorageBorderFrame.CloseButton)
	F.ReskinInput(VoidItemSearchBox)

	F.StripTextures(VoidStorageCostFrame, true)

	local frames = {VoidStorageDepositFrame, VoidStorageWithdrawFrame, VoidStorageStorageFrame}
	for _, frame in next, frames do
		F.StripTextures(frame, true)
		F.CreateBDFrame(frame, .25)
	end

	for _, voidButton in next, {"VoidStorageDepositButton", "VoidStorageWithdrawButton"} do
		for i = 1, 9 do
			local bu = _G[voidButton..i]
			bu.icon:SetTexCoord(.08, .92, .08, .92)
			F.StripTextures(bu)
			F.CreateBDFrame(bu, .25)

			bu:SetHighlightTexture(C.media.backdrop)
			local hl = bu:GetHighlightTexture()
			hl:SetVertexColor(1, 1, 1, .25)

			local border = bu.IconBorder
			border:SetTexture(C.media.backdrop)
			border.SetTexture = F.dummy
			border:SetPoint("TOPLEFT", -C.mult, C.mult)
			border:SetPoint("BOTTOMRIGHT", C.mult, -C.mult)
			border:SetDrawLayer("BACKGROUND")
		end
	end

	for i = 1, 80 do
		local bu = _G["VoidStorageStorageButton"..i]
		F.StripTextures(bu)
		F.CreateBDFrame(bu, .25)

		local icon = _G["VoidStorageStorageButton"..i.."IconTexture"]
		icon:SetTexCoord(.08, .92, .08, .92)

		local border = bu.IconBorder
		border:SetTexture(C.media.backdrop)
		border.SetTexture = F.dummy
		border:SetPoint("TOPLEFT", -C.mult, C.mult)
		border:SetPoint("BOTTOMRIGHT", C.mult, -C.mult)
		border:SetDrawLayer("BACKGROUND")

		local searchOverlay = bu.searchOverlay
		searchOverlay:SetPoint("TOPLEFT", -C.mult, C.mult)
		searchOverlay:SetPoint("BOTTOMRIGHT", C.mult, -C.mult)

		bu:SetHighlightTexture(C.media.backdrop)
		local hl = bu:GetHighlightTexture()
		hl:SetVertexColor(1, 1, 1, .25)
	end

	for i = 1, 2 do
		local tab = VoidStorageFrame["Page"..i]
		tab:GetRegions():Hide()
		tab:SetCheckedTexture(C.media.checked)
		tab:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)
		tab:GetNormalTexture():SetTexCoord(.08, .92, .08, .92)
		F.CreateBDFrame(tab)
	end
	VoidStorageFrame.Page1:ClearAllPoints()
	VoidStorageFrame.Page1:SetPoint("TOPLEFT", VoidStorageFrame, "TOPRIGHT", 4, -50)
end