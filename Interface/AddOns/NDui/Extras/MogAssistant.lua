local _G = _G
local select = select

local C_TransmogCollection_GetAppearanceSourceInfo = C_TransmogCollection.GetAppearanceSourceInfo
local C_TransmogCollection_GetIllusionSourceInfo = C_TransmogCollection.GetIllusionSourceInfo
local CreateFrame = CreateFrame
local DressUpVisual = DressUpVisual
local IsModifiedClick = IsModifiedClick
local PlaySound = PlaySound

local LE_TRANSMOG_TYPE_APPEARANCE = LE_TRANSMOG_TYPE_APPEARANCE
local LE_TRANSMOG_TYPE_ILLUSION = LE_TRANSMOG_TYPE_ILLUSION
local SOUNDKIT_UI_TRANSMOG_ITEM_CLICK = SOUNDKIT.UI_TRANSMOG_ITEM_CLICK
local WARDROBE_DOWN_VISUAL_KEY = WARDROBE_DOWN_VISUAL_KEY
local WARDROBE_NEXT_VISUAL_KEY = WARDROBE_NEXT_VISUAL_KEY
local WARDROBE_PREV_VISUAL_KEY = WARDROBE_PREV_VISUAL_KEY
local WARDROBE_UP_VISUAL_KEY = WARDROBE_UP_VISUAL_KEY

local function UpdateItems(self)
	local pendingTransmogModelFrame
	local indexOffset = (self.PagingFrame:GetCurrentPage() - 1) * self.PAGE_SIZE
	for i = 1, self.PAGE_SIZE do
		local model = self.Models[i]
		local index = i + indexOffset
		local visualInfo = self.filteredVisualsList[index]
		if visualInfo then
			local transmogStateAtlas
			if visualInfo.visualID == self.selectedVisualID then
				transmogStateAtlas = "transmog-wardrobe-border-selected"
				pendingTransmogModelFrame = model
			end
			if transmogStateAtlas then
				model.TransmogStateTexture:SetAtlas(transmogStateAtlas, true)
				model.TransmogStateTexture:Show()
			else
				model.TransmogStateTexture:Hide()
			end
		end
	end
	if pendingTransmogModelFrame then
		self.PendingTransmogFrame:SetParent(pendingTransmogModelFrame)
		self.PendingTransmogFrame:SetPoint("CENTER")
		self.PendingTransmogFrame:Show()
		if self.PendingTransmogFrame.visualID ~= self.selectedVisualID then
			self.PendingTransmogFrame.TransmogSelectedAnim:Stop()
			self.PendingTransmogFrame.TransmogSelectedAnim:Play()
			self.PendingTransmogFrame.TransmogSelectedAnim2:Stop()
			self.PendingTransmogFrame.TransmogSelectedAnim2:Play()
			self.PendingTransmogFrame.TransmogSelectedAnim3:Stop()
			self.PendingTransmogFrame.TransmogSelectedAnim3:Play()
			self.PendingTransmogFrame.TransmogSelectedAnim4:Stop()
			self.PendingTransmogFrame.TransmogSelectedAnim4:Play()
			self.PendingTransmogFrame.TransmogSelectedAnim5:Stop()
			self.PendingTransmogFrame.TransmogSelectedAnim5:Play()
		end
		self.PendingTransmogFrame.visualID = self.selectedVisualID
	end
end

local function DressUp(self, visualInfo)
	local transmogType = self.transmogType
	local slot = self:GetActiveSlot()
	if transmogType == LE_TRANSMOG_TYPE_APPEARANCE then
		local sourceID = self:GetAnAppearanceSourceFromVisual(visualInfo.visualID, nil)
		if WardrobeUtils_IsCategoryRanged(self:GetActiveCategory()) or WardrobeUtils_IsCategoryLegionArtifact(self:GetActiveCategory()) then
			slot = nil
		end
		DressUpVisual(sourceID, slot)
		self.selectedVisualID = select(2, C_TransmogCollection_GetAppearanceSourceInfo(sourceID))
	elseif transmogType == LE_TRANSMOG_TYPE_ILLUSION then
		local weaponSourceID = WardrobeCollectionFrame_GetWeaponInfoForEnchant(slot)
		DressUpVisual(weaponSourceID, slot, visualInfo.sourceID)
		self.selectedVisualID = C_TransmogCollection_GetIllusionSourceInfo(visualInfo.sourceID)
	end
end

local function OnKeyDown(self, key)
	if WardrobeFrame_IsAtTransmogrifier() or self.selectedCollectionTab ~= 1 then return end
	if not (key == WARDROBE_PREV_VISUAL_KEY or key == WARDROBE_NEXT_VISUAL_KEY or key == WARDROBE_UP_VISUAL_KEY or key == WARDROBE_DOWN_VISUAL_KEY) then return end
	self:SetPropagateKeyboardInput(false)
	local visualIndex = 0
	local visualsList = self.ItemsCollectionFrame.filteredVisualsList
	for i = 1, #visualsList do
		if visualsList[i].visualID == self.ItemsCollectionFrame.selectedVisualID then
			visualIndex = i
			break
		end
	end
	visualIndex = WardrobeUtils_GetAdjustedDisplayIndexFromKeyPress(self.ItemsCollectionFrame, visualIndex, #visualsList, key)
	PlaySound(SOUNDKIT_UI_TRANSMOG_ITEM_CLICK)
	self.ItemsCollectionFrame.jumpToVisualID = visualsList[visualIndex].visualID
	self.ItemsCollectionFrame.selectedVisualID = visualsList[visualIndex].visualID
	self.ItemsCollectionFrame:ResetPage()
	DressUp(self.ItemsCollectionFrame, visualsList[visualIndex])
	UpdateItems(self.ItemsCollectionFrame)
end

local function OnMouseDown(self, button)
	if WardrobeFrame_IsAtTransmogrifier() then return end
	if button == "LeftButton" and not IsModifiedClick("CHATLINK") then
		PlaySound(SOUNDKIT_UI_TRANSMOG_ITEM_CLICK)
		DressUp(self:GetParent(), self.visualInfo)
		UpdateItems(self:GetParent())
	end
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:SetScript("OnEvent", function(_, event, arg1)
	if event == "ADDON_LOADED" and arg1 == "Blizzard_Collections" then
		_G.WardrobeCollectionFrame:HookScript("OnKeyDown", OnKeyDown)
		for i = 1, #_G.WardrobeCollectionFrame.ItemsCollectionFrame.Models do
			local model = _G.WardrobeCollectionFrame.ItemsCollectionFrame.Models[i]
			model:HookScript("OnMouseDown", OnMouseDown)
		end
	end
end)
