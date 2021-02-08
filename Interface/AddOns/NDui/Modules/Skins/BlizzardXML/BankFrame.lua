local _, ns = ...
local B, C, L, DB = unpack(ns)
local S = B:GetModule("Skins")

local function Reskin_Button(self)
	B.CleanTextures(self)

	local questTexture = self.IconQuestTexture
	if questTexture then questTexture:SetAlpha(0) end

	local icbg = B.ReskinIcon(self.icon)
	B.ReskinHighlight(self, icbg)

	local border = self.IconBorder
	B.ReskinBorder(border, icbg)

	local search = self.searchOverlay
	search:SetAllPoints(icbg)

	local slotTexture = self.SlotHighlightTexture
	if slotTexture then B.ReskinSpecialBorder(slotTexture, icbg) end
end

local function Reskin_ReagentBankFrame(self)
	if not self.styled then
		for i = 1, 98 do
			local item = _G["ReagentBankFrameItem"..i]
			Reskin_Button(item)
			BankFrameItemButton_Update(item)
		end

		self.styled = true
	end
end

local function Update_BankFrameItemButton(button)
	if not button.isBag and button.IconQuestTexture:IsShown() then
		button.IconBorder:SetVertexColor(1, 1, 0)
	end
end

tinsert(C.XMLThemes, function()
	if C.db["Bags"]["Enable"] then return end

	-- [[ Bank ]]
	B.ReskinFrame(BankFrame)
	B.ReskinButton(BankFramePurchaseButton)
	B.ReskinInput(BankItemSearchBox)
	S.ReskinSort(BankItemAutoSortButton)

	B.StripTextures(BankSlotsFrame)
	B.StripTextures(BankFrameMoneyFrame)

	B.ReskinFrameTab(BankFrame, 3)

	for i = 1, 28 do
		Reskin_Button(_G["BankFrameItem"..i])
	end

	for i = 1, 7 do
		Reskin_Button(BankSlotsFrame["Bag"..i])
	end

	hooksecurefunc("BankFrameItemButton_Update", Update_BankFrameItemButton)

	-- [[ Reagent bank ]]
	B.StripTextures(ReagentBankFrame)
	B.ReskinButton(ReagentBankFrame.DespositButton)
	B.ReskinButton(ReagentBankFrameUnlockInfoPurchaseButton)

	ReagentBankFrame:DisableDrawLayer("ARTWORK")
	ReagentBankFrame:DisableDrawLayer("BACKGROUND")
	ReagentBankFrame:DisableDrawLayer("BORDER")
	ReagentBankFrame:HookScript("OnShow", Reskin_ReagentBankFrame)
end)