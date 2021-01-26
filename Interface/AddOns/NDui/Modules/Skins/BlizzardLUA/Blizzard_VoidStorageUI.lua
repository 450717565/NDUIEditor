local _, ns = ...
local B, C, L, DB = unpack(ns)

local function Reskin_Button(self)
	B.CleanTextures(self)

	local icbg = B.ReskinIcon(self.icon)
	B.ReskinHighlight(self, icbg)

	local border = self.IconBorder
	B.ReskinBorder(border, icbg)

	local search = self.searchOverlay
	search:SetAllPoints(icbg)
end

C.LUAThemes["Blizzard_VoidStorageUI"] = function()
	local bg = B.ReskinFrame(VoidStorageBorderFrame)
	--bg:SetFrameLevel(0)

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

	local buttons = {
		"VoidStorageDepositButton",
		"VoidStorageWithdrawButton",
	}
	for _, buttons in pairs(buttons) do
		for i = 1, 9 do
			local button = _G[buttons..i]
			Reskin_Button(button)
		end
	end

	for i = 1, 80 do
		local button = _G["VoidStorageStorageButton"..i]
		Reskin_Button(button)
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