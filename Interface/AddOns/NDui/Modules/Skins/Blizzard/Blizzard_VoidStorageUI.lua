local B, C, L, DB = unpack(select(2, ...))

C.themes["Blizzard_VoidStorageUI"] = function()
	B.ReskinFrame(VoidStorageBorderFrame)
	B.ReskinFrame(VoidStoragePurchaseFrame)

	B.ReskinButton(VoidStoragePurchaseButton)
	B.ReskinButton(VoidStorageHelpBoxButton)
	B.ReskinButton(VoidStorageTransferButton)
	B.ReskinInput(VoidItemSearchBox)

	local lists = {VoidStorageFrame, VoidStorageCostFrame, VoidStorageDepositFrame, VoidStoragePurchaseFrame, VoidStorageWithdrawFrame, VoidStorageStorageFrame}
	for _, list in pairs(lists) do
		B.StripTextures(list)
	end

	for _, voidButton in pairs({"VoidStorageDepositButton", "VoidStorageWithdrawButton"}) do
		for i = 1, 9 do
			local bu = _G[voidButton..i]
			B.StripTextures(bu)

			local icbg = B.ReskinIcon(bu.icon)
			B.ReskinTexture(bu, icbg)

			local border = bu.IconBorder
			B.ReskinBorder(border, icbg)
		end
	end

	for i = 1, 80 do
		local button = "VoidStorageStorageButton"..i

		local bu = _G[button]
		B.StripTextures(bu)

		local icbg = B.ReskinIcon(_G[button.."IconTexture"])
		B.ReskinTexture(bu, icbg)

		local border = bu.IconBorder
		B.ReskinBorder(border, icbg)

		local searchOverlay = bu.searchOverlay
		searchOverlay:SetAllPoints(icbg)
	end

	for i = 1, 2 do
		local tab = VoidStorageFrame["Page"..i]
		tab:SetSize(34, 34)
		tab:GetRegions():Hide()

		local icbg = B.ReskinIcon(tab:GetNormalTexture())
		B.ReskinTexed(tab, icbg)
		B.ReskinTexture(tab, icbg)

		if i == 1 then
			tab:ClearAllPoints()
			tab:SetPoint("TOPLEFT", VoidStorageFrame, "TOPRIGHT", 4, -25)
		end
	end
end