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

	local header = B.CreateFS(gearFrame, 14, TRANSMOGRIFY, true)
	gearFrame.Header = header

	local close = CreateFrame("Button", nil, gearFrame, "UIPanelCloseButton")
	close:SetPoint("TOPRIGHT", gearFrame)
	gearFrame.Close = close

	local scrollArea = CreateFrame("ScrollFrame", nil, gearFrame, "UIPanelScrollFrameTemplate")
	scrollArea:SetPoint("TOPLEFT", 10, -30)
	scrollArea:SetPoint("BOTTOMRIGHT", -28, 10)

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

	B.CreateMF(gearFrame)
	B.ReskinFrame(gearFrame)
	B.ReskinScroll(scrollArea.ScrollBar)
	B.UpdatePoint(header, "TOP", gearFrame, "TOP", 0, -5)
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

local function GetIllusionSource(illusionID)
	local name, _, sourceText = C_TransmogCollection.GetIllusionStrings(illusionID)
	name = name and format(TRANSMOGRIFIED_ENCHANT, name)

	return name, sourceText
end

local function GetSourceInfo(sourceID)
	local sourceInfo = C_TransmogCollection.GetSourceInfo(sourceID)
	if not sourceInfo then return end

	return sourceInfo.isHideVisual, sourceInfo.sourceType, sourceInfo.itemModID, sourceInfo.itemID, sourceInfo.name, sourceInfo.quality
end

local function GetTransmogInfo(slotID, sourceID)
	local isHideVisual, sourceType, itemModID, itemID, itemName, itemQuality = GetSourceInfo(sourceID)
	local sourceTextColorized = GenerateSource(sourceID, sourceType, itemModID, itemQuality)

	return {["SlotID"] = slotID, ["Name"] = itemName, ["Source"] = sourceTextColorized}
end

local function GetInspectSources()
	wipe(ItemList)

	local mainHandEnchant, offHandEnchant
	local transmogList = C_TransmogCollection.GetInspectItemTransmogInfoList()

	for slotID, transmogInfo in ipairs(transmogList) do
		local appearanceID, secondaryAppearanceID, illusionID = transmogInfo.appearanceID, transmogInfo.secondaryAppearanceID, transmogInfo.illusionID

		if appearanceID and appearanceID ~= Constants.Transmog.NoTransmogID then
			local info = GetTransmogInfo(slotID, appearanceID)
			if info then
				table.insert(ItemList, info)
			end
		end

		if C_Transmog.CanHaveSecondaryAppearanceForSlotID(slotID) and secondaryAppearanceID > 0 then
			local info = GetTransmogInfo(slotID, secondaryAppearanceID)
			if info then
				table.insert(ItemList, info)
			end
		end

		if slotID == 16 then
			mainHandEnchant = illusionID
		elseif slotID == 17 then
			offHandEnchant = illusionID
		end
	end

	if mainHandEnchant and mainHandEnchant > 0 then
		local illusionName, sourceText = GetIllusionSource(mainHandEnchant)
		table.insert(ItemList, {["SlotID"] = 16, ["Name"] = illusionName, ["Source"] = sourceText})
	end

	if offHandEnchant and offHandEnchant > 0 then
		local illusionName, sourceText = GetIllusionSource(offHandEnchant)
		table.insert(ItemList, {["SlotID"] = 17, ["Name"] = illusionName, ["Source"] = sourceText})
	end
end

local function GetSlotVisualID(slotID, type, modification)
	if slotID == 2 or slotID == 18 or (slotID > 10 and slotID < 15) then
		return -1, -1
	end
	local slotName = TransmogUtil.GetSlotName(slotID)
	local location = TransmogUtil.GetTransmogLocation(slotName, type, modification)
	local baseSourceID, baseVisualID, appliedSourceID, appliedVisualID, _, _, _, _, _, hideVisual = C_Transmog.GetSlotVisualInfo(location)
	if ( hideVisual ) then
		return 0, 0
	elseif ( appliedSourceID == Constants.Transmog.NoTransmogID and modification ~= Enum.TransmogModification.Secondary) then
		return baseSourceID, baseVisualID
	else
		return appliedSourceID, appliedVisualID
	end
end

local function GetPlayerSources()
	wipe(ItemList)

	for slotID = 1, 19 do
		local appliedSourceID, appliedVisualID = GetSlotVisualID(slotID, Enum.TransmogType.Appearance, Enum.TransmogModification.Main)
		if appliedVisualID > 0 and appliedSourceID and appliedSourceID ~= Constants.Transmog.NoTransmogID then
			local info = GetTransmogInfo(slotID, appliedSourceID)
			if info then
				table.insert(ItemList, info)
			end
		end

		if C_Transmog.CanHaveSecondaryAppearanceForSlotID(slotID) then
			local secondarySourceID, secondaryVisualID = GetSlotVisualID(slotID, Enum.TransmogType.Appearance, Enum.TransmogModification.Secondary)
			if secondaryVisualID > 0 and secondarySourceID and secondarySourceID ~= Constants.Transmog.NoTransmogID and secondarySourceID ~= appliedSourceID then
				local info = GetTransmogInfo(slotID, secondarySourceID)
				if info then
					table.insert(ItemList, info)
				end
			end
		end
	end

	local mainHandEnchant = GetSlotVisualID(16, Enum.TransmogType.Illusion, Enum.TransmogModification.Main)
	if mainHandEnchant > 0 then
		local illusionName, sourceText = GetIllusionSource(mainHandEnchant)
		table.insert(ItemList, {["SlotID"] = 16, ["Name"] = illusionName, ["Source"] = sourceText})
	end

	local offHandEnchant = GetSlotVisualID(17, Enum.TransmogType.Illusion, Enum.TransmogModification.Main)
	if offHandEnchant > 0 then
		local illusionName, sourceText = GetIllusionSource(offHandEnchant)
		table.insert(ItemList, {["SlotID"] = 17, ["Name"] = illusionName, ["Source"] = sourceText})
	end
end

local function CopyTexts()
	local texts = ""

	for _, info in pairs(ItemList) do
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

local function SetupInspectButton()
	local button = CreateCopyButton(InspectPaperDollFrame)
	button:SetScript("OnClick", function()
		CreateGearFrame()
		GetInspectSources()
		CopyTexts()
	end)
end
B.LoadWithAddOn("Blizzard_InspectUI", SetupInspectButton)