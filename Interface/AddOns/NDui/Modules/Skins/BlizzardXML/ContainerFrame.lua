local _, ns = ...
local B, C, L, DB = unpack(ns)

local tL, tR, tT, tB = unpack(DB.TexCoord)

local MAX_CONTAINER_ITEMS = 36
local bagTexture = "Interface\\Buttons\\Button-Backpack-Up"
local bagIDToInvID = {
	[1] = 20,
	[2] = 21,
	[3] = 22,
	[4] = 23,
	[5] = 80,
	[6] = 81,
	[7] = 82,
	[8] = 83,
	[9] = 84,
	[10] = 85,
	[11] = 86,
}

local function Create_BagIcon(self, index)
	if not self.bagIcon then
		self.bagIcon = self.PortraitButton:CreateTexture(nil, "ARTWORK")
		self.bagIcon:SetSize(32, 32)
		self.bagIcon:ClearAllPoints()
		self.bagIcon:SetPoint("TOPLEFT", self.bg, 3, -3)
		B.ReskinIcon(self.bagIcon)

		self.bagHL = self.PortraitButton:CreateTexture(nil, "HIGHLIGHT")
		self.bagHL:SetColorTexture(1, 1, 1, .25)
		self.bagHL:SetAllPoints(self.bagIcon)
	end

	if index == 1 then
		self.bagIcon:SetTexture(bagTexture) -- backpack
	end
end

local function Reskin_ItemButton(self)
	B.CleanTextures(self)

	local questTexture = self.IconQuestTexture
	if questTexture then questTexture:SetAlpha(0) end

	local icbg = B.ReskinIcon(self.icon)
	B.ReskinHLTex(self, icbg)

	local border = self.IconBorder
	B.ReskinBorder(border, icbg)

	local search = self.searchOverlay
	search:SetAllPoints(icbg)

	local slotTexture = self.SlotHighlightTexture
	if slotTexture then B.ReskinBGBorder(slotTexture, icbg) end
end

local function Reskin_SortButton(self)
	local bg = B.CreateBDFrame(self, 0, -C.mult)
	B.ReskinHLTex(self, bg)

	self:SetSize(26, 26)
	self:SetNormalTexture("Interface\\Icons\\INV_Pet_Broom")
	self:SetPushedTexture("Interface\\Icons\\INV_Pet_Broom")
	self:GetNormalTexture():SetTexCoord(tL, tR, tT, tB)
	self:GetPushedTexture():SetTexCoord(tL, tR, tT, tB)
end

local function Update_ContainerFrame(self)
	local id = self:GetID()
	local name = self:GetDebugName()

	for i = 1, self.size do
		local itemButton = _G[name.."Item"..i]

		if _G[name.."Item"..i.."IconQuestTexture"]:IsShown() then
			itemButton.IconBorder:SetVertexColor(1, 1, 0)
		end
	end

	if self.bagIcon then
		local invID = bagIDToInvID[id]

		if invID then
			local icon = GetInventoryItemTexture("player", invID)
			self.bagIcon:SetTexture(icon or bagTexture)
		end
	end
end

local function Reskin_ReagentBankFrame(self)
	if not self.styled then
		for i = 1, 98 do
			local item = _G["ReagentBankFrameItem"..i]
			Reskin_ItemButton(item)
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

-- Bag
tinsert(C.XMLThemes, function()
	if C.db["Bags"]["Enable"] then return end

	-- Bag
	B.ReskinInput(BagItemSearchBox)
	Reskin_SortButton(BagItemAutoSortButton)

	for i = 1, 12 do
		local container = "ContainerFrame"..i

		local frame = _G[container]
		frame.PortraitButton.Highlight:SetTexture("")

		local bg = B.ReskinFrame(frame)
		bg:ClearAllPoints()
		bg:SetPoint("TOPLEFT", 8, -4)
		bg:SetPoint("BOTTOMRIGHT", -3, 0)

		local name = _G[container.."Name"]
		name:ClearAllPoints()
		name:SetPoint("TOP", bg, 0, -5)

		local close = _G[container.."CloseButton"]
		close:ClearAllPoints()
		close:SetPoint("TOPRIGHT", bg, -3, -3)

		frame.bg = bg
		Create_BagIcon(frame, i)

		for j = 1, MAX_CONTAINER_ITEMS do
			local item = container.."Item"..j
			local button = _G[item]
			if not button.IconQuestTexture then
				button.IconQuestTexture = _G[item.."IconQuestTexture"]
			end

			Reskin_ItemButton(button)
		end
	end

	B.StripTextures(BackpackTokenFrame)
	for i = 1, 3 do
		local token = _G["BackpackTokenFrameToken"..i.."Icon"]
		B.ReskinIcon(token)
	end

	hooksecurefunc("ContainerFrame_Update", Update_ContainerFrame)

	-- Bank
	B.ReskinFrame(BankFrame)
	B.ReskinButton(BankFramePurchaseButton)
	B.ReskinInput(BankItemSearchBox)
	Reskin_SortButton(BankItemAutoSortButton)

	B.StripTextures(BankSlotsFrame)
	B.StripTextures(BankFrameMoneyFrame)

	B.ReskinFrameTab(BankFrame, 3)

	for i = 1, 28 do
		Reskin_ItemButton(_G["BankFrameItem"..i])
	end

	for i = 1, 7 do
		Reskin_ItemButton(BankSlotsFrame["Bag"..i])
	end

	hooksecurefunc("BankFrameItemButton_Update", Update_BankFrameItemButton)

	-- Reagent Bank
	B.StripTextures(ReagentBankFrame)
	B.ReskinButton(ReagentBankFrame.DespositButton)
	B.ReskinButton(ReagentBankFrameUnlockInfoPurchaseButton)

	ReagentBankFrame:DisableDrawLayer("ARTWORK")
	ReagentBankFrame:DisableDrawLayer("BACKGROUND")
	ReagentBankFrame:DisableDrawLayer("BORDER")
	ReagentBankFrame:HookScript("OnShow", Reskin_ReagentBankFrame)
end)