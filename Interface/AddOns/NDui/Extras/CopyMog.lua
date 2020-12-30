local _, ns = ...
local B, C, L, DB = unpack(ns)
------------------------------------
-- Credit: Narcissus, by Peterodox
-- by 雨夜独行客
------------------------------------
local ItemList, gearFrame = {}

local SlotIDtoName = {
	[1] = HEADSLOT,
	[2] = NECKSLOT,
	[3] = SHOULDERSLOT,
	[4] = SHIRTSLOT,
	[5] = CHESTSLOT,
	[6] = WAISTSLOT,
	[7] = LEGSSLOT,
	[8] = L["Feet"],
	[9] = WRISTSLOT,
	[10]= L["Hands"],
	[11]= FINGER0SLOT_UNIQUE,
	[12]= FINGER1SLOT_UNIQUE,
	[13]= TRINKET0SLOT_UNIQUE,
	[14]= TRINKET1SLOT_UNIQUE,
	[15]= BACKSLOT,
	[16]= MAINHANDSLOT,
	[17]= SECONDARYHANDSLOT,
	[18]= RANGEDSLOT,
	[19]= TABARDSLOT,
}

local function CreateGearFrame()
	if gearFrame then gearFrame:Show() return end

	gearFrame = CreateFrame("Frame", "CopyMogGearTexts", UIParent)
	gearFrame:SetPoint("CENTER")
	gearFrame:SetSize(500, 250)
	gearFrame:SetFrameStrata("DIALOG")
	B.CreateMF(gearFrame)
	B.CreateBG(gearFrame)

	local header = B.CreateFS(gearFrame, 14, TRANSMOGRIFY, true, "TOP", 0, -5)
	gearFrame.Header = header

	local close = CreateFrame("Button", nil, gearFrame, "UIPanelCloseButton")
	close:SetPoint("TOPRIGHT", gearFrame)
	B.ReskinClose(close)
	gearFrame.Close = close

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
	gearFrame.EditBox = editBox
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

local function GetIllusionSource(sourceID)
	local _, name = C_TransmogCollection.GetIllusionSourceInfo(sourceID)
	local sourceText = ""
	name = name and format(TRANSMOGRIFIED_ENCHANT, name)

	local illusionList = C_TransmogCollection.GetIllusions()
	for i = 1, #illusionList do
		local info = illusionList[i]
		if info.sourceID == sourceID and info.sourceText then
			sourceText = info.sourceText
			break
		end
	end

	return name, sourceText
end

local function GetSourceInfo(sourceID)
	local sourceInfo = C_TransmogCollection.GetSourceInfo(sourceID)
	if not sourceInfo then return end

	return sourceInfo.isHideVisual, sourceInfo.sourceType, sourceInfo.itemModID, sourceInfo.itemID, sourceInfo.name, sourceInfo.quality
end

local function GetInspectSources()
	wipe(ItemList)

	local appearanceSources, mainHandEnchant, offHandEnchant = C_TransmogCollection.GetInspectSources()
	if not appearanceSources then return end

	for i = 1, #appearanceSources do
		local sourceID = appearanceSources[i]
		if sourceID and sourceID ~= NO_TRANSMOG_SOURCE_ID then
			local isHideVisual, sourceType, itemModID, itemID, itemName, itemQuality = GetSourceInfo(sourceID)
			local sourceTextColorized = GenerateSource(sourceID, sourceType, itemModID, itemQuality)
			table.insert(ItemList, {["SlotID"] = i, ["Name"] = itemName, ["Source"] = sourceTextColorized})
		end
	end

	if mainHandEnchant > 0 then
		local illusionName, sourceText = GetIllusionSource(mainHandEnchant)
		table.insert(ItemList, {["SlotID"] = 16, ["Name"] = illusionName, ["Source"] = sourceText})
	end

	if offHandEnchant > 0 then
		local illusionName, sourceText = GetIllusionSource(offHandEnchant)
		table.insert(ItemList, {["SlotID"] = 17, ["Name"] = illusionName, ["Source"] = sourceText})
	end
end

local function GetSlotVisualID(slotId, type)
	if slotId == 2 or slotId == 18 or (slotId > 10 and slotId < 15) then
		return -1, -1
	end
	local slotName = TransmogUtil.GetSlotName(slotId)
	local location = TransmogUtil.GetTransmogLocation(slotName, type, Enum.TransmogModification.None)
	local baseSourceID, baseVisualID, appliedSourceID, appliedVisualID, _, _, _, _, _, hideVisual = C_Transmog.GetSlotVisualInfo(location)
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
		local appliedSourceID, appliedVisualID = GetSlotVisualID(slotId, Enum.TransmogType.Appearance)
		if appliedVisualID > 0 and appliedSourceID and appliedSourceID ~= NO_TRANSMOG_SOURCE_ID then
			local isHideVisual, sourceType, itemModID, itemID, itemName, itemQuality = GetSourceInfo(appliedSourceID)
			local sourceTextColorized = GenerateSource(appliedSourceID, sourceType, itemModID, itemQuality)
			table.insert(ItemList, {["SlotID"] = slotId, ["Name"] = itemName, ["Source"] = sourceTextColorized})
		end
	end

	local mainHandEnchant = GetSlotVisualID(16, Enum.TransmogType.Illusion)
	if mainHandEnchant > 0 then
		local illusionName, sourceText = GetIllusionSource(mainHandEnchant)
		table.insert(ItemList, {["SlotID"] = 16, ["Name"] = illusionName, ["Source"] = sourceText})
	end

	local offHandEnchant = GetSlotVisualID(17, Enum.TransmogType.Illusion)
	if offHandEnchant > 0 then
		local illusionName, sourceText = GetIllusionSource(offHandEnchant)
		table.insert(ItemList, {["SlotID"] = 17, ["Name"] = illusionName, ["Source"] = sourceText})
	end
end

local function CopyTexts()
	local texts = ""

	for _, info in ipairs(ItemList) do
		if info.Name and info.Name ~= "" then
			texts = texts.."|cffFFFF00"..SlotIDtoName[info.SlotID]..":|r "..info.Name
			if info.Source and info.Source ~= "" then
				texts = texts.." |cffFF0000(|r|cff00FFFF"..info.Source.."|r|cffFF0000)|r"
			end
			texts = texts.."\n"
		end
	end

	gearFrame.EditBox:SetText(strtrim(texts))
end

local function CreateCopyButton(parent)
	local button = B.CreateButton(parent, 50, 20, TRANSMOGRIFY)
	button:SetPoint("TOPLEFT", 5, -5)
	parent.CopyButton = button

	return button
end

local function SetupPlayerButton(event)
	local button = CreateCopyButton(PaperDollFrame)
	button:SetScript("OnClick", function()
		CreateGearFrame()
		GetPlayerSources()
		CopyTexts()
	end)

	B:UnregisterEvent(event, SetupPlayerButton)
end
B:RegisterEvent("PLAYER_LOGIN", SetupPlayerButton)

local function SetupInspectButton(event, addon)
	if addon ~= "Blizzard_InspectUI" then return end

	local button = CreateCopyButton(InspectPaperDollFrame)
	button:SetScript("OnClick", function()
		CreateGearFrame()
		GetInspectSources()
		CopyTexts()
	end)

	B:UnregisterEvent(event, SetupInspectButton)
end
B:RegisterEvent("ADDON_LOADED", SetupInspectButton)