local _, ns = ...
local B, C, L, DB = unpack(ns)
local S = B:GetModule("Skins")

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
		B.ReskinIcon(self.bagIcon)
		self.bagIcon:SetPoint("TOPLEFT", 7, -5)
		self.bagIcon:SetSize(32, 32)
	end

	if index == 1 then
		self.bagIcon:SetTexture(bagTexture) -- backpack
	end
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

tinsert(C.XMLThemes, function()
	if C.db["Bags"]["Enable"] then return end

	B.ReskinInput(BagItemSearchBox)
	S.ReskinSort(BagItemAutoSortButton)

	for i = 1, 12 do
		local container = "ContainerFrame"..i

		local frame = _G[container]
		B.StripTextures(frame, true)
		Create_BagIcon(frame, i)
		frame.PortraitButton.Highlight:SetTexture("")

		local bg = B.CreateBG(frame, 8, -4, -3, 0)
		B.ReskinClose(_G[container.."CloseButton"], bg)

		local name = _G[container.."Name"]
		name:ClearAllPoints()
		name:SetPoint("TOP", bg, 0, -10)

		for j = 1, 36 do
			local item = container.."Item"..j

			local button = _G[item]
			B.CleanTextures(button)

			local questTexture = _G[item.."IconQuestTexture"]
			if questTexture then questTexture:SetAlpha(0) end

			local newTexture = button.NewItemTexture
			if newTexture then newTexture:SetAlpha(0) end

			local icbg = B.ReskinIcon(button.icon)
			B.ReskinHighlight(button, icbg)

			local border = button.IconBorder
			B.ReskinBorder(border, icbg)

			local search = button.searchOverlay
			search:SetAllPoints(icbg)
		end
	end

	B.StripTextures(BackpackTokenFrame)
	for i = 1, 3 do
		local ic = _G["BackpackTokenFrameToken"..i.."Icon"]
		B.ReskinIcon(ic)
	end

	hooksecurefunc("ContainerFrame_Update", Update_ContainerFrame)
end)