local F, C = unpack(select(2, ...))

C.themes["Blizzard_VoidStorageUI"] = function()
	F.ReskinFrame(VoidStorageBorderFrame)
	F.ReskinFrame(VoidStoragePurchaseFrame)

	F.ReskinButton(VoidStoragePurchaseButton)
	F.ReskinButton(VoidStorageHelpBoxButton)
	F.ReskinButton(VoidStorageTransferButton)
	F.ReskinInput(VoidItemSearchBox)

	local lists = {VoidStorageFrame, VoidStorageCostFrame, VoidStorageDepositFrame, VoidStoragePurchaseFrame, VoidStorageWithdrawFrame, VoidStorageStorageFrame}
	for _, list in pairs(lists) do
		F.StripTextures(list, true)
	end

	for _, voidButton in pairs({"VoidStorageDepositButton", "VoidStorageWithdrawButton"}) do
		for i = 1, 9 do
			local bu = _G[voidButton..i]
			F.StripTextures(bu)

			local icbg = F.ReskinIcon(bu.icon)
			F.ReskinTexture(bu, icbg, false)

			local border = bu.IconBorder
			F.ReskinBorder(border, bu)
		end
	end

	for i = 1, 80 do
		local bu = _G["VoidStorageStorageButton"..i]
		F.StripTextures(bu)

		local icbg = F.ReskinIcon(_G["VoidStorageStorageButton"..i.."IconTexture"])
		F.ReskinTexture(bu, icbg, false)

		local border = bu.IconBorder
		F.ReskinBorder(border, bu)

		local searchOverlay = bu.searchOverlay
		searchOverlay:SetAllPoints(icbg)
	end

	for i = 1, 2 do
		local tab = VoidStorageFrame["Page"..i]
		tab:SetSize(34, 34)
		tab:GetRegions():Hide()

		local icbg = F.ReskinIcon(tab:GetNormalTexture())
		F.ReskinTexed(tab, icbg)
		F.ReskinTexture(tab, icbg, false)

		if i == 1 then
			tab:ClearAllPoints()
			tab:SetPoint("TOPLEFT", VoidStorageFrame, "TOPRIGHT", 4, -25)
		end
	end
end