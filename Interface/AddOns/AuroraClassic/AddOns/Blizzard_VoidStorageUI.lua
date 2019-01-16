local F, C = unpack(select(2, ...))

C.themes["Blizzard_VoidStorageUI"] = function()
	F.ReskinPortraitFrame(VoidStorageBorderFrame, true)

	F.CreateBD(VoidStoragePurchaseFrame)
	F.CreateSD(VoidStoragePurchaseFrame)

	F.Reskin(VoidStoragePurchaseButton)
	F.Reskin(VoidStorageHelpBoxButton)
	F.Reskin(VoidStorageTransferButton)
	F.ReskinInput(VoidItemSearchBox)

	local frames = {VoidStorageFrame, VoidStorageCostFrame, VoidStorageDepositFrame, VoidStoragePurchaseFrame, VoidStorageWithdrawFrame, VoidStorageStorageFrame}
	for _, frame in next, frames do
		F.StripTextures(frame, true)
	end

	for _, voidButton in next, {"VoidStorageDepositButton", "VoidStorageWithdrawButton"} do
		for i = 1, 9 do
			local bu = _G[voidButton..i]
			F.StripTextures(bu)

			local ic = F.ReskinIcon(bu.icon, true)
			F.ReskinTexture(bu, ic, false)

			local border = bu.IconBorder
			F.ReskinTexture(border, bu, false, true)
		end
	end

	for i = 1, 80 do
		local bu = _G["VoidStorageStorageButton"..i]
		F.StripTextures(bu)

		local ic = F.ReskinIcon(_G["VoidStorageStorageButton"..i.."IconTexture"], true)
		F.ReskinTexture(bu, ic, false)

		local border = bu.IconBorder
		F.ReskinTexture(border, bu, false, true)

		local searchOverlay = bu.searchOverlay
		searchOverlay:SetPoint("TOPLEFT", -C.mult, C.mult)
		searchOverlay:SetPoint("BOTTOMRIGHT", C.mult, -C.mult)
	end

	for i = 1, 2 do
		local tab = VoidStorageFrame["Page"..i]
		tab:SetSize(34, 34)
		tab:GetRegions():Hide()
		tab:SetCheckedTexture(C.media.checked)

		local ic = F.ReskinIcon(tab:GetNormalTexture(), true)
		F.ReskinTexture(tab, ic, false)
	end
	VoidStorageFrame.Page1:ClearAllPoints()
	VoidStorageFrame.Page1:SetPoint("TOPLEFT", VoidStorageFrame, "TOPRIGHT", 4, -50)
end