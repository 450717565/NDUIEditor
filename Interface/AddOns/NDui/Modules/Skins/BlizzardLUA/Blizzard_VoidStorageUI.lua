local _, ns = ...
local B, C, L, DB = unpack(ns)

local function Reskin_ItemButton(self)
	B.CleanTextures(self)

	local icbg = B.ReskinIcon(self.icon)
	B.ReskinHLTex(self, icbg)

	local border = self.IconBorder
	B.ReskinBorder(border, icbg)

	local search = self.searchOverlay
	search:SetAllPoints(icbg)
end

C.OnLoadThemes["Blizzard_VoidStorageUI"] = function()
	local bg = B.ReskinFrame(VoidStorageBorderFrame)
	bg:SetFrameLevel(0)

	B.ReskinFrame(VoidStoragePurchaseFrame)

	B.ReskinButton(VoidStoragePurchaseButton)
	B.ReskinButton(VoidStorageTransferButton)
	B.ReskinInput(VoidItemSearchBox)

	local lists = {
		VoidStorageCostFrame,
		VoidStorageDepositFrame,
		VoidStorageFrame,
		VoidStoragePurchaseFrame,
		VoidStorageStorageFrame,
		VoidStorageWithdrawFrame,
	}
	for _, list in pairs(lists) do
		B.StripTextures(list)
	end

	for i = 1, 9 do
		local deposit = _G["VoidStorageDepositButton"..i]
		Reskin_ItemButton(deposit)

		local withdraw = _G["VoidStorageWithdrawButton"..i]
		Reskin_ItemButton(withdraw)
	end

	for i = 1, 80 do
		local storage = _G["VoidStorageStorageButton"..i]
		Reskin_ItemButton(storage)
	end

	for i = 1, 2 do
		local tab = VoidStorageFrame["Page"..i]
		B.ReskinSideTab(tab)

		if i == 1 then
			tab:ClearAllPoints()
			tab:SetPoint("TOPLEFT", VoidStorageFrame, "TOPRIGHT", 2, -25)
		end
	end
end