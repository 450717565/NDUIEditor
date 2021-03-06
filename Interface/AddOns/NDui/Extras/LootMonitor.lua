local _, ns = ...
local B, C, L, DB = unpack(ns)

local Button_Height = 16
local LMFrame_Width = 200

local LMFrame_Report = {}
local LMFrame_CFG = {
	nums = 20,
	equip = true,
	other = true,
}

local LM_Message_Info = {
	L["LM Message 1"],
	L["LM Message 2"],
	L["LM Message 3"],
	L["LM Message 4"],
}

local LMFrame = CreateFrame("Frame", "LootMonitor", UIParent)
LMFrame:SetFrameStrata("HIGH")
LMFrame:SetClampedToScreen(true)
LMFrame:SetPoint("LEFT", 4, 0)

local LMFrame_Title = B.CreateFS(LMFrame, Button_Height-2, L["LootMonitor Title"], true, "TOPLEFT", 10, -10)
local LMFrame_Info = B.CreateFS(LMFrame, Button_Height-2, L["LootMonitor Info"], true, "BOTTOMRIGHT", -10, 10)

local function UnitClassColor(unit)
	local r, g, b = B.GetUnitColor(unit)
	return B.HexRGB(r, g, b, unit)
end

local function LMFrame_Close()
	table.wipe(LMFrame_Report)
	for index = 1, LMFrame_CFG["nums"] do
		LMFrame[index]:Hide()
	end
	LMFrame:SetSize(LMFrame_Width, Button_Height*4)
	LMFrame:Hide()
end

local function ButtonOnClick(self, button)
	if button == "RightButton" then
		SendChatMessage(string.format(LM_Message_Info[random(4)], LMFrame_Report[self.index]["link"]), "WHISPER", nil, LMFrame_Report[self.index]["list"])
	else
		local editBox = ChatEdit_ChooseBoxForSend()
		ChatEdit_ActivateChat(editBox)
		editBox:SetText(editBox:GetText()..LMFrame_Report[self.index]["link"])
	end
end

local function ButtonOnEnter(self)
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT", 10, 0)
	GameTooltip:SetHyperlink(LMFrame_Report[self.index]["link"])
end

local function ButtonOnLeave(self)
	GameTooltip:Hide()
end

local function CreateLMFrame()
	B.CreateBG(LMFrame)
	B.CreateMF(LMFrame)

	local LMFrame_CloseBtn = B.CreateButton(LMFrame, 18, 18, "X")
	LMFrame_CloseBtn:SetPoint("TOPRIGHT", -10, -7)
	LMFrame_CloseBtn:SetScript("OnClick", function(self) LMFrame_Close() end)
end

local function CreateLMButton(index)
	local button = CreateFrame("Button", "LMFrame_Report"..index, LMFrame)
	button:SetHighlightTexture(DB.bgTex)
	button:SetHeight(Button_Height)
	button:SetPoint("RIGHT", -10, 0)

	local hl = button:GetHighlightTexture()
	hl:SetVertexColor(1, 1, 1, .25)

	button:RegisterForClicks("AnyDown")
	button:SetScript("OnClick", ButtonOnClick)
	button:SetScript("OnEnter", ButtonOnEnter)
	button:SetScript("OnLeave", ButtonOnLeave)
	button.index = index

	local text = B.CreateFS(button, Button_Height-2)
	text:SetJustifyH("LEFT")
	text:SetNonSpaceWrap(true)
	B.UpdatePoint(text, "LEFT", button, "LEFT", 0, 0)
	button.text = text

	if index == 1 then
		button:SetPoint("TOPLEFT", LMFrame_Title, "BOTTOMLEFT", 0, -5)
	else
		button:SetPoint("TOPLEFT", LMFrame[index - 1], "BOTTOMLEFT", 0, -1)
	end

	LMFrame[index] = button
	return button
end

LMFrame:RegisterEvent("CHAT_MSG_LOOT")
LMFrame:RegisterEvent("PLAYER_LOGIN")
LMFrame:SetScript("OnEvent", function(self, event, ...)
	if not C.db["Extras"]["LootMonitor"] then return end

	if event == "PLAYER_LOGIN" then
		CreateLMFrame()
		for index = 1, LMFrame_CFG["nums"] do
			CreateLMButton(index)
		end
		LMFrame_Close()
		LMFrame:UnregisterEvent(event)
	elseif event == "CHAT_MSG_LOOT" then
		local lootStr, playerStr = ...
		local rollInfo = string.match(lootStr, BONUS_REWARDS)
		local itemLink = string.match(lootStr, "|%x+|Hitem:.-|h.-|h|r")

		if not itemLink then return end

		local Enabled = false
		local totalText = ""
		local textWidth, maxWidth = 0, 0
		local lootTime = DB.InfoColor..GameTime_GetGameTime(true).."|r"
		local playerInfo = UnitClassColor(string.split("-", playerStr))
		local filterBR = C.db["Extras"]["LootMonitorBonusRewards"] and rollInfo
		local minQuality = C.db["Extras"]["LootMonitorQuality"]

		local itemLvl = B.GetItemLevel(itemLink)
		local itemSolt = B.GetItemSlot(itemLink)
		local isGems = B.GetItemGems(itemLink)
		local itemGems = isGems or ""
		local itemID = GetItemInfoInstant(itemLink)
		local _, _, itemQuality, _, _, _, _, _, itemEquipLoc, _, _, itemClassID, itemSubClassID = GetItemInfo(itemLink)

		if C.db["Extras"]["LootMonitorInGroup"] == true and not IsInGroup() then
			Enabled = false
		elseif LMFrame_CFG["other"] == true and ((itemClassID == 15 and (itemSubClassID == 2 or itemSubClassID == 5)) or C_ToyBox.GetToyInfo(itemID)) then
			Enabled = true
		elseif LMFrame_CFG["equip"] == true and (itemQuality >= minQuality and itemQuality < 7) and (itemEquipLoc ~= "" or IsArtifactRelicItem(itemID)) and not filterBR then
			Enabled = true
		end

		if itemLvl and itemSolt then
			totalText = "<"..itemLvl.."-"..itemSolt..itemGems..">"
		elseif itemLvl then
			totalText = "<"..itemLvl..itemGems..">"
		elseif itemSolt then
			totalText = "<"..itemSolt..itemGems..">"
		end

		if isGems then
			totalText = "|cff00FF00"..totalText.."|r"
		end

		if playerInfo and Enabled then
			if #LMFrame_Report >= LMFrame_CFG["nums"] then table.remove(LMFrame_Report, 1) end

			table.insert(LMFrame_Report, {timer = lootTime, player = playerInfo, link = itemLink, solt = totalText, list = playerStr})

			local numButtons = #LMFrame_Report
			for index = 1, numButtons do
				LMFrame[index].text:SetFormattedText("%s %s %s %s", LMFrame_Report[index]["timer"], LMFrame_Report[index]["player"], LMFrame_Report[index]["link"], LMFrame_Report[index]["solt"])
				LMFrame[index]:Show()
				textWidth = math.floor(LMFrame[index].text:GetStringWidth() + 20.5)
				maxWidth = math.max(textWidth, maxWidth)
			end

			LMFrame:SetWidth(maxWidth)
			LMFrame:SetHeight((Button_Height+1)*(numButtons+3)+6)

			if not LMFrame:IsShown() then
				LMFrame:Show()
			end
		end
	end
end)

SLASH_NDLM1 = "/ndlm"
SlashCmdList["NDLM"] = function()
	if not LMFrame:IsShown() then
		LMFrame:Show()
	else
		LMFrame:Hide()
	end
end