local B, C, L, DB = unpack(select(2, ...))

C.themes["Blizzard_VoidStorageUI"] = function()
	local bg = B.ReskinFrame(VoidStorageBorderFrame)
	bg:SetFrameLevel(0)

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
			B.ReskinHighlight(bu, icbg)

			local border = bu.IconBorder
			B.ReskinBorder(border, icbg)
		end
	end

	for i = 1, 80 do
		local button = "VoidStorageStorageButton"..i

		local bu = _G[button]
		B.StripTextures(bu)

		local icbg = B.ReskinIcon(_G[button.."IconTexture"])
		B.ReskinHighlight(bu, icbg)

		local border = bu.IconBorder
		B.ReskinBorder(border, icbg)

		local searchOverlay = bu.searchOverlay
		searchOverlay:SetAllPoints(icbg)
	end

	for i = 1, 2 do
		local tab = VoidStorageFrame["Page"..i]
		tab:SetSize(32, 32)
		tab:GetRegions():Hide()

		local icbg = B.ReskinIcon(tab:GetNormalTexture())
		B.ReskinChecked(tab, icbg)
		B.ReskinHighlight(tab, icbg)

		if i == 1 then
			tab:ClearAllPoints()
			tab:SetPoint("TOPLEFT", VoidStorageFrame, "TOPRIGHT", 3, -25)
		end
	end
end