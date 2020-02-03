local B, C, L, DB = unpack(select(2, ...))

local strmatch, strformat, strsplit = string.match, string.format, string.split
local tbwipe, tbinsert, tbremove = table.wipe, table.insert, table.remove
local mmax, mfloor = math.max, math.floor

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
	local r, g, b = B.UnitColor(unit)
	return B.HexRGB(r, g, b, unit)
end

local function LMFrame_Close()
	tbwipe(LMFrame_Report)
	for index = 1, LMFrame_CFG["nums"] do
		LMFrame[index]:Hide()
	end
	LMFrame:SetSize(LMFrame_Width, Button_Height*4)
	LMFrame:Hide()
end

local function ButtonOnClick(self, button)
	if button == "RightButton" then
		SendChatMessage(strformat(LM_Message_Info[random(4)], LMFrame_Report[self.index]["link"]), "WHISPER", nil, LMFrame_Report[self.index]["list"])
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
	B.CreateMF(LMFrame)
	B.CreateBD(LMFrame)

	local LMFrame_CloseBtn = B.CreateButton(LMFrame, 18, 18, "X")
	LMFrame_CloseBtn:SetPoint("TOPRIGHT", -10, -7)
	LMFrame_CloseBtn:SetScript("OnClick", function(self) LMFrame_Close() end)
end

local function CreateLMButton(index)
	local button = CreateFrame("Button", "LMFrame_Report"..index, LMFrame)
	button:SetHighlightTexture(DB.bdTex)
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
	text:SetPoint("LEFT", 0, 0)
	text:SetNonSpaceWrap(true)
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
	if not NDuiDB["Extras"]["LootMonitor"] then return end

	if event == "PLAYER_LOGIN" then
		CreateLMFrame()
		for index = 1, LMFrame_CFG["nums"] do
			CreateLMButton(index)
		end
		LMFrame_Close()
		LMFrame:UnregisterEvent(event)
	elseif event == "CHAT_MSG_LOOT" then
		local lootStr, playerStr = ...
		local rollInfo = strmatch(lootStr, BONUS_REWARDS)
		local itemLink = strmatch(lootStr, "|%x+|Hitem:.-|h.-|h|r")
		local playerInfo = strsplit("-", playerStr)

		if not itemLink then return end

		local Enabled = false
		local totalText = ""
		local textWidth, maxWidth = 0, 0
		local lootTime = GameTime_GetGameTime(true)
		local filterBR = NDuiDB["Extras"]["LootMonitorBonusRewards"] and rollInfo
		local minQuality = NDuiDB["Extras"]["LootMonitorQuality"]

		local itemLvl = B.GetItemLevel(itemLink)
		local itemSolt = B.GetItemSlot(itemLink)
		local itemGems = B.GetItemGems(itemLink) or ""
		local _, _, itemRarity, _, _, _, itemSubType, _, itemEquipLoc, _, _, itemClassID, itemSubClassID, bindType = GetItemInfo(itemLink)

		if NDuiDB["Extras"]["LootMonitorInGroup"] == true and not IsInGroup() then
			Enabled = false
		elseif LMFrame_CFG["other"] == true and itemClassID == 15 and (itemSubClassID == 2 or itemSubClassID == 5) then
			Enabled = true
		elseif LMFrame_CFG["equip"] == true and (((itemRarity >= minQuality and itemRarity < 7) and (itemSubType == EJ_LOOT_SLOT_FILTER_ARTIFACT_RELIC or itemEquipLoc ~= "")) or (itemRarity == 5 and itemClassID == 0)) and not filterBR then
			Enabled = true
		end

		if itemLvl and itemSolt then
			totalText = "<"..itemLvl.."-"..itemSolt..itemGems..">"
		elseif itemLvl then
			totalText = "<"..itemLvl..itemGems..">"
		elseif itemSolt then
			totalText = "<"..itemSolt..itemGems..">"
		end

		if playerInfo and Enabled then
			if #LMFrame_Report >= LMFrame_CFG["nums"] then tbremove(LMFrame_Report, 1) end

			tbinsert(LMFrame_Report, {timer = lootTime, player = playerInfo, link = itemLink, solt = totalText, list = playerStr})

			local numButtons = #LMFrame_Report
			for index = 1, numButtons do
				LMFrame[index].text:SetFormattedText("%s %s %s %s", DB.InfoColor..LMFrame_Report[index]["timer"], UnitClassColor(LMFrame_Report[index]["player"]), LMFrame_Report[index]["link"], LMFrame_Report[index]["solt"])
				LMFrame[index]:Show()
				textWidth = mfloor(LMFrame[index].text:GetStringWidth() + 20.5)
				maxWidth = mmax(textWidth, maxWidth)
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