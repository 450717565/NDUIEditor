local B, C, L, DB = unpack(select(2, ...))
------------------------------------
-- Credit: Narcissus, by Peterodox
-- by 雨夜独行客
------------------------------------
local ItemList, gearFrame = {}

local SlotIDtoName = {
	--[SlotID] = {InventorySlotName, Localized Name, SlotID}
	[1] = {"HeadSlot", HEADSLOT, INVTYPE_HEAD},
	[2] = {"NeckSlot", NECKSLOT, INVSLOT_NECK},
	[3] = {"ShoulderSlot", SHOULDERSLOT, INVTYPE_SHOULDER},
	[4] = {"ShirtSlot", SHIRTSLOT, INVTYPE_BODY},
	[5] = {"ChestSlot", CHESTSLOT, INVTYPE_CHEST},
	[6] = {"WaistSlot", WAISTSLOT, INVTYPE_WAIST},
	[7] = {"LegsSlot", LEGSSLOT, INVTYPE_LEGS},
	[8] = {"FeetSlot", L["Feet"], INVTYPE_FEET},
	[9] = {"WristSlot", WRISTSLOT, INVTYPE_WRIST},
	[10]= {"HandsSlot", L["Hands"], INVTYPE_HAND},
	[11]= {"Finger0Slot", FINGER0SLOT_UNIQUE, INVSLOT_FINGER1},
	[12]= {"Finger1Slot", FINGER1SLOT_UNIQUE, INVSLOT_FINGER2},
	[13]= {"Trinket0Slot", TRINKET0SLOT_UNIQUE, INVSLOT_TRINKET1},
	[14]= {"Trinket1Slot", TRINKET1SLOT_UNIQUE, INVSLOT_TRINKET2},
	[15]= {"BackSlot", BACKSLOT, INVTYPE_CLOAK},
	[16]= {"MainHandSlot", MAINHANDSLOT, INVTYPE_WEAPONMAINHAND},
	[17]= {"SecondaryHandSlot", SECONDARYHANDSLOT, INVTYPE_WEAPONOFFHAND},
	[18]= {"AmmoSlot", RANGEDSLOT, INVSLOT_RANGED},
	[19]= {"TabardSlot", TABARDSLOT, INVTYPE_TABARD},
}

local function CreateGearFrame()
	if gearFrame then gearFrame:Show() return end

	gearFrame = CreateFrame("Frame", "InspectGearTexts", UIParent)
	gearFrame:SetPoint("CENTER")
	gearFrame:SetSize(500, 250)
	gearFrame:SetFrameStrata("DIALOG")
	B.CreateMF(gearFrame)
	B.CreateBG(gearFrame)

	gearFrame.Header = B.CreateFS(gearFrame, 14, TRANSMOGRIFY, true, "TOP", 0, -5)
	gearFrame.Close = CreateFrame("Button", nil, gearFrame, "UIPanelCloseButton")
	gearFrame.Close:SetPoint("TOPRIGHT", gearFrame)
	B.ReskinClose(gearFrame.Close)

	local scrollArea = CreateFrame("ScrollFrame", nil, gearFrame, "UIPanelScrollFrameTemplate")
	scrollArea:SetPoint("TOPLEFT", 10, -30)
	scrollArea:SetPoint("BOTTOMRIGHT", -28, 10)
	B.ReskinScroll(scrollArea.ScrollBar)

	local editBox = CreateFrame("EditBox", nil, gearFrame)
	editBox:SetMultiLine(true)
	editBox:SetMaxLetters(99999)
	editBox:EnableMouse(true)
	editBox:SetAutoFocus(true)
	editBox:SetFont(DB.Font[1], 14)
	editBox:SetWidth(scrollArea:GetWidth())
	editBox:SetHeight(scrollArea:GetHeight())
	editBox:SetScript("OnEscapePressed", function() gearFrame:Hide() end)
	scrollArea:SetScrollChild(editBox)
	gearFrame.editBox = editBox
end

local function GenerateSource(sourceID, sourceType, itemModID, itemQuality)
	local sourceTextColorized = ""
	if sourceType == 1 then --TRANSMOG_SOURCE_BOSS_DROP
		local drops = C_TransmogCollection.GetAppearanceSourceDrops(sourceID)
		if drops and drops[1] then
			sourceTextColorized = drops[1].encounter.." ".."|cffFFFF00"..drops[1].instance.."|r|cff00FF00"
			if itemModID == 0 then
				sourceTextColorized = sourceTextColorized.." "..PLAYER_DIFFICULTY1.."|r"
			elseif itemModID == 1 then
				sourceTextColorized = sourceTextColorized.." "..PLAYER_DIFFICULTY2.."|r"
			elseif itemModID == 3 then
				sourceTextColorized = sourceTextColorized.." "..PLAYER_DIFFICULTY6.."|r"
			elseif itemModID == 4 then
				sourceTextColorized = sourceTextColorized.." "..PLAYER_DIFFICULTY3.."|r"
			end
		end
	else
		if sourceType == 2 then --quest
			sourceTextColorized = TRANSMOG_SOURCE_2
		elseif sourceType == 3 then --vendor
			sourceTextColorized = TRANSMOG_SOURCE_3
		elseif sourceType == 4 then --world drop
			sourceTextColorized = TRANSMOG_SOURCE_4
		elseif sourceType == 5 then --achievement
			sourceTextColorized = TRANSMOG_SOURCE_5
		elseif sourceType == 6 then	--profession
			sourceTextColorized = TRANSMOG_SOURCE_6
		else
			if itemQuality == 6 then
				sourceTextColorized = ITEM_QUALITY6_DESC
			elseif itemQuality == 5 then
				sourceTextColorized = ITEM_QUALITY5_DESC
			end
		end
	end

	return sourceTextColorized
end

local function GetSourceInfo(sourceID)
	local sourceInfo = C_TransmogCollection.GetSourceInfo(sourceID)
	local isHideVisual = sourceInfo.isHideVisual
	local sourceType = sourceInfo.sourceType
	local itemModID = sourceInfo.itemModID
	local itemID = sourceInfo.itemID
	local itemName = sourceInfo.name
	local itemQuality = sourceInfo.quality

	return isHideVisual, sourceType, itemModID, itemID, itemName, itemQuality
end

local function GetInspectSources()
	wipe(ItemList)

	local appearanceSources, mainHandEnchant, offHandEnchant = C_TransmogCollection.GetInspectSources()
	if not appearanceSources then return end

	for i = 1, #appearanceSources do
		local sourceID = appearanceSources[i]
		if sourceID and sourceID ~= NO_TRANSMOG_SOURCE_ID then
			local isHideVisual, sourceType, itemModID, itemID, itemName, itemQuality = GetSourceInfo(sourceID)
			if not isHideVisual then
				local sourceTextColorized = GenerateSource(sourceID, sourceType, itemModID, itemQuality)
				ItemList[i] = {itemName, sourceTextColorized}
			end
		end
	end
end

local function GetSlotVisualID(slotId)
	if slotId == 2 or slotId == 18 or (slotId > 10 and slotId < 15) then
		return -1, -1
	end
	local baseSourceID, baseVisualID, appliedSourceID, appliedVisualID, _, _, _, hideVisual = C_Transmog.GetSlotVisualInfo(slotId, 0)
	if ( hideVisual ) then
		return 0, 0
	elseif ( appliedSourceID == NO_TRANSMOG_SOURCE_ID ) then
		return baseSourceID, baseVisualID
	else
		return appliedSourceID, appliedVisualID
	end
end

local function GetPlayerSources()
	wipe(ItemList)

	for slotId = 1, 19 do
		local appliedSourceID, appliedVisualID = GetSlotVisualID(slotId)
		if appliedVisualID > 0 and appliedSourceID and appliedSourceID ~= NO_TRANSMOG_SOURCE_ID then
			local isHideVisual, sourceType, itemModID, itemID, itemName, itemQuality = GetSourceInfo(appliedSourceID)
			if not isHideVisual then
				local sourceTextColorized = GenerateSource(appliedSourceID, sourceType, itemModID, itemQuality)
				ItemList[slotId] = {itemName, sourceTextColorized}
			end
		end
	end
end

local function CopyTexts()
	local texts = ""

	for slotId = 1, 19 do
		local info = ItemList[slotId]
		if info then
			if info[1] and info[1] ~= "" then
				texts = texts.."|cffFFFF00"..SlotIDtoName[slotId][2]..":|r "..info[1]
				if info[2] and info[2] ~= "" then
					texts = texts.." |cffFF0000(|r|cff00FFFF"..info[2].."|r|cffFF0000)|r"
				end
				texts = texts.."\n"
			end
		end
	end

	gearFrame.editBox:SetText(strtrim(texts))
	gearFrame.editBox:HighlightText()
end

local function SetupPlayerButton(event)
	local button = B.CreateButton(CharacterFrame, 50, 20, TRANSMOGRIFY)
	button:SetPoint("BOTTOMRIGHT", -5, 5)
	button:SetScript("OnClick", function()
		CreateGearFrame()
		GetPlayerSources()
		CopyTexts()
	end)
	CharacterFrame.CopyButton = button

	B:UnregisterEvent(event, SetupPlayerButton)
end
B:RegisterEvent("PLAYER_LOGIN", SetupPlayerButton)

local function SetupInspectButton(event, addon)
	if addon ~= "Blizzard_InspectUI" then return end

	local button = B.CreateButton(InspectPaperDollFrame, 50, 20, TRANSMOGRIFY)
	button:SetPoint("BOTTOMRIGHT", -5, 5)
	button:SetScript("OnClick", function()
		CreateGearFrame()
		GetInspectSources()
		CopyTexts()
	end)
	InspectPaperDollFrame.CopyButton = button

	B:UnregisterEvent(event, SetupInspectButton)
end
B:RegisterEvent("ADDON_LOADED", SetupInspectButton)