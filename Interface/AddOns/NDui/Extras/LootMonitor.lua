local B, C, L, DB = unpack(select(2, ...))

local Button_Height = 16
local LMFrame_Width = 250

local LMFrame_Report = {}
local LMFrame_CFG = {
	maxloots = 20,
	rarity = 4,
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
local LMFrame_Title = B.CreateFS(LMFrame, Button_Height-2, L["LootMonitor"], true, "TOPLEFT", 10, -10)
local LMFrame_Info = B.CreateFS(LMFrame, Button_Height-2, L["LootMonitor Info"], true, "BOTTOMLEFT", 10, 10)
B.CreateMF(LMFrame)
B.CreateBD(LMFrame)
B.CreateSD(LMFrame)
B.CreateTex(LMFrame)
LMFrame:SetFrameStrata("HIGH")
LMFrame:SetClampedToScreen(true)
LMFrame:SetPoint("LEFT", 4, 0)

local function UnitClassColor(String)
	if not UnitExists(String) then return string.format("|cffff0000%s|r", String) end
	local _, class = UnitClass(String)
	local color = DB.ClassColors[class]
	return string.format("|cff%02x%02x%02x%s|r", color.r*255, color.g*255, color.b*255, String)
end

local function LMFrame_Reset()
	LMFrame_Report = {}
	for index = 1, LMFrame_CFG["maxloots"] do
		LMFrame[index].text:SetText("")
		LMFrame[index]:Hide()
	end
	LMFrame:SetSize(LMFrame_Width, Button_Height*4)
	LMFrame:Hide()
end

local function ButtonOnClick(self, button)
	if button == "RightButton" then
		SendChatMessage(LM_Message_Info[random(4)]:format(LMFrame_Report[self.index]["lootinfo"]), "WHISPER", nil, LMFrame_Report[self.index]["player"])
	else
		local editBox = ChatEdit_ChooseBoxForSend()
		ChatEdit_ActivateChat(editBox)
		editBox:SetText(editBox:GetText()..LMFrame_Report[self.index]["lootinfo"])
	end
end

local function ButtonOnEnter(self)
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT", 10, 0)
	GameTooltip:SetHyperlink(LMFrame_Report[self.index]["lootinfo"])
end

local function ButtonOnLeave(self)
	GameTooltip:Hide()
end

local LMFrame_CloseBtn = B.CreateButton(LMFrame, 20, 20, "X")
LMFrame_CloseBtn:SetPoint("TOPRIGHT", -10, -7)
LMFrame_CloseBtn:SetScript("OnClick", function(self) LMFrame:Hide() end)

local LMFrame_ResetBtn = B.CreateButton(LMFrame, 60, 20, RESET)
LMFrame_ResetBtn:SetPoint("BOTTOMRIGHT", -10, 7)
LMFrame_ResetBtn:SetScript("OnClick", function(self) LMFrame_Reset() end)

local function CreateButton(index)
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

	local text = B.CreateFS(button, Button_Height-2, "")
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
		LMFrame:UnregisterEvent(event)
		for index = 1, LMFrame_CFG["maxloots"] do
			CreateButton(index)
		end
		LMFrame_Reset()
	elseif event == "CHAT_MSG_LOOT" then
		local lootstring, _, _, _, player = ...
		local rollInfo = string.match(lootstring, BONUS_REWARDS)
		local itemLink = string.match(lootstring,"|%x+|Hitem:.-|h.-|h|r")
		local _, _, itemRarity, _, _, _, itemSubType, _, itemEquipLoc, _, _, itemClassID, itemSubClassID, bindType = GetItemInfo(itemLink)

		local Enabled = false
		local totalText
		local textWidth, maxWidth = 0, 0
		local lootTime = GameTime_GetGameTime(true)
		local filterBR = NDuiDB["Extras"]["LootMonitorBonusRewards"] and rollInfo

		local itemLvl = B.GetItemLevel(itemLink)
		local slotText = B.ItemSlotInfo(itemLink)

		if NDuiDB["Extras"]["LootMonitorInGroup"] == true and not IsInGroup() then
			Enabled = false
		elseif LMFrame_CFG["other"] == true and itemClassID == 15 and (itemSubClassID == 2 or itemSubClassID == 5) then
			Enabled = true
		elseif LMFrame_CFG["equip"] == true and (((itemRarity >= LMFrame_CFG["rarity"] and itemRarity < 7) and (itemSubType == EJ_LOOT_SLOT_FILTER_ARTIFACT_RELIC or itemEquipLoc ~= "")) or (itemRarity == 5 and itemClassID == 0)) and not filterBR then
			Enabled = true
		end

		if itemLvl and slotText then
			totalText = "<"..itemLvl.."-"..slotText..">"
		elseif itemLvl then
			totalText = "<"..itemLvl..">"
		elseif slotText then
			totalText = "<"..slotText..">"
		else
			totalText = ""
		end

		if player and Enabled then
			if #LMFrame_Report >= LMFrame_CFG["maxloots"] then table.remove(LMFrame_Report, 1) end

			LMFrame_Report[#LMFrame_Report+1] = {
				loottime = lootTime,
				player = player,
				lootinfo = itemLink,
				soltinfo = totalText,
			}

			local numButtons = #LMFrame_Report
			for index = 1, numButtons do
				LMFrame[index].text:SetText(DB.InfoColor..LMFrame_Report[index]["loottime"].."|r " ..UnitClassColor(LMFrame_Report[index]["player"]).." " ..LMFrame_Report[index]["lootinfo"].." "..LMFrame_Report[index]["soltinfo"])
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