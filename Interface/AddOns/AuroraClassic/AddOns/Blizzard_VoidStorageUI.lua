local F, C = unpack(select(2, ...))

C.themes["Blizzard_VoidStorageUI"] = function()
	F.ReskinFrame(VoidStorageBorderFrame)
	F.ReskinFrame(VoidStoragePurchaseFrame)

	F.ReskinButton(VoidStoragePurchaseButton)
	F.ReskinButton(VoidStorageHelpBoxButton)
	F.ReskinButton(VoidStorageTransferButton)
	F.ReskinInput(VoidItemSearchBox)

	local frames = {VoidStorageFrame, VoidStorageCostFrame, VoidStorageDepositFrame, VoidStoragePurchaseFrame, VoidStorageWithdrawFrame, VoidStorageStorageFrame}
	for _, frame in pairs(frames) do
		F.StripTextures(frame, true)
	end

	for _, voidButton in pairs({"VoidStorageDepositButton", "VoidStorageWithdrawButton"}) do
		for i = 1, 9 do
			local bu = _G[voidButton..i]
			F.StripTextures(bu)

			local ic = F.ReskinIcon(bu.icon)
			F.ReskinTexture(bu, ic, false)

			local border = bu.IconBorder
			F.ReskinBorder(border, bu)
		end
	end

	for i = 1, 80 do
		local bu = _G["VoidStorageStorageButton"..i]
		F.StripTextures(bu)

		local ic = F.ReskinIcon(_G["VoidStorageStorageButton"..i.."IconTexture"])
		F.ReskinTexture(bu, ic, false)

		local border = bu.IconBorder
		F.ReskinBorder(border, bu)

		local searchOverlay = bu.searchOverlay
		searchOverlay:SetAllPoints(ic)
	end

	for i = 1, 2 do
		local tab = VoidStorageFrame["Page"..i]
		tab:SetSize(34, 34)
		tab:GetRegions():Hide()

		local ic = F.ReskinIcon(tab:GetNormalTexture())
		F.ReskinTexture(tab, ic, false)
		F.ReskinTexed(tab, ic)
	end
	VoidStorageFrame.Page1:ClearAllPoints()
	VoidStorageFrame.Page1:SetPoint("TOPLEFT", VoidStorageFrame, "TOPRIGHT", 4, -25)
end