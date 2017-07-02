local B, C, L, DB = unpack(select(2, ...))

local fontName, fontHeight, fontFlags = GameFontNormal:GetFont()

local Button_Height = 20
local Button_Spacing = 1

local LMFrame_Point = 10
local LMFrame_Width = 250

local LMFrame_Report = {}
local LMFrame_CFG = {
	maxloots = 20,
	rarity = 4,
	equip = true,
	other = true,
}

local function ClassColor(String)
	if not UnitExists(String) then return string.format("\124cffff0000%s\124r", String) end
	local _, class = UnitClass(String)
	local color = _G["RAID_CLASS_COLORS"][class]
	return string.format("\124cff%02x%02x%02x%s\124r", color.r*255, color.g*255, color.b*255, String)
end

local LMFrame = CreateFrame('Frame', "LootMonitor", UIParent)
local LMFrame_Title = B.CreateFS(LMFrame, 15, "拾取监视", true, "TOPLEFT", 12, -10)
local LMFrame_Rclick = B.CreateFS(LMFrame, 15, "左键：贴出 右键：密语", true, "BOTTOMLEFT", 12, 10)
B.CreateMF(LMFrame)
B.CreateBD(LMFrame)
B.CreateTex(LMFrame)
LMFrame:SetFrameStrata('TOOLTIP')
LMFrame:SetClampedToScreen(true)
LMFrame:SetPoint("LEFT")

local function LMFrame_Reset()
	LMFrame_Report = {}
	for index = 1, LMFrame_CFG["maxloots"] do
		LMFrame[index]:SetText("")
		LMFrame[index]:Hide()
	end
	LMFrame:SetSize(LMFrame_Width, (LMFrame_Point * 2) + (fontHeight* 2) + ((Button_Height + Button_Spacing) - Button_Spacing))
	LMFrame:Hide()
end

local LMFrame_CloseBtn = CreateFrame("Button", nil, LMFrame)
B.CreateBD(LMFrame_CloseBtn, 0.3)
B.CreateBC(LMFrame_CloseBtn)
B.CreateFS(LMFrame_CloseBtn, 12, "X", true)
LMFrame_CloseBtn:SetPoint("TOPRIGHT", -10, -8)
LMFrame_CloseBtn:SetSize(20, 20)
LMFrame_CloseBtn:SetScript("OnClick", function(self) LMFrame:Hide() end)

local LMFrame_ResetBtn = CreateFrame("Button", nil, LMFrame)
B.CreateBD(LMFrame_ResetBtn, 0.3)
B.CreateBC(LMFrame_ResetBtn)
B.CreateFS(LMFrame_ResetBtn, 12, "重置", true)
LMFrame_ResetBtn:SetPoint("BOTTOMRIGHT", -10, 8)
LMFrame_ResetBtn:SetSize(60, 20)
LMFrame_ResetBtn:SetScript("OnClick", function(self) LMFrame_Reset() end)

LMFrame:RegisterEvent('PLAYER_LOGIN')
LMFrame:RegisterEvent('CHAT_MSG_LOOT')
LMFrame:SetScript("OnEvent", function(self, event, ...)
	if event == "PLAYER_LOGIN" then
		LMFrame:UnregisterEvent(event)
		for index = 1, LMFrame_CFG["maxloots"] do
			local button = CreateFrame("Button", nil, LMFrame)
			if index ~= 1 then
				button:SetPoint("TOPLEFT", LMFrame[index - 1], "BOTTOMLEFT", 0, -Button_Spacing)
			else
				button:SetPoint("TOPLEFT", LMFrame_Title, "BOTTOMLEFT", 0, -LMFrame_Point)
			end
			button:SetPoint("RIGHT")
			button:SetHeight(Button_Height)
			button:SetNormalFontObject("GameFontNormal")
			button:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight")
			button:RegisterForClicks("AnyDown")
			button:SetScript("OnClick", function(self, button)
				if button == "RightButton" then
					SendChatMessage("你好！请问"..LMFrame_Report[self.index]["loot"].."有需求吗？没有的话能让我吗？谢谢！", "WHISPER", nil, LMFrame_Report[self.index]["player"])
				else
					local editBox = ChatEdit_ChooseBoxForSend()
					ChatEdit_ActivateChat(editBox)
					editBox:SetText(editBox:GetText()..LMFrame_Report[self.index]["loot"])
				end
			end)
			button:SetScript("OnEnter", function(self)
				GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
				GameTooltip:SetHyperlink(LMFrame_Report[self.index]["loot"])
			end)
			button:SetScript("OnLeave", function(self)
				GameTooltip_Hide()
			end)
			button.index = index

			local text = button:CreateFontString(nil, "MEDIUM", "GameFontHighlightLarge")
			text:SetAllPoints()
			text:SetJustifyH("LEFT")
			text:SetJustifyV("MIDDLE")
			text:SetTextColor(1, 1, 1, 1)
			button:SetFontString(text)
			LMFrame[index] = button
		end
		LMFrame_Reset()
	elseif event == "CHAT_MSG_LOOT" then
		local lootstring, _, _, _, player = ...
		local itemLink 		= string.match(lootstring,"|%x+|Hitem:.-|h.-|h|r")
		local itemString 	= string.match(itemLink, "item[%-?%d:]+")
		local itemName, _, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice, itemClassID, itemSubClassID = GetItemInfo(itemString)
		local Enabled = 0
		local slotText, totalInfo
		local itemLvl = GetDetailedItemLevelInfo(itemLink)
		local lootTime = GameTime_GetGameTime(true)

		if itemEquipLoc and string.find(itemEquipLoc, "INVTYPE_") then
			slotText = _G[itemEquipLoc] or ""
		end
		if itemEquipLoc and string.find(itemEquipLoc, "INVTYPE_FEET") then
			slotText = L["Feet"] or ""
		elseif itemEquipLoc and string.find(itemEquipLoc, "INVTYPE_HAND") then
			slotText = L["Hands"] or ""
		elseif itemEquipLoc and string.find(itemEquipLoc, "INVTYPE_HOLDABLE") then
			slotText = INVTYPE_WEAPONOFFHAND or ""
		elseif itemEquipLoc and string.find(itemEquipLoc, "INVTYPE_SHIELD") then
			slotText = itemSubType or ""
		elseif itemSubType and string.find(itemSubType, RELICSLOT) then
			slotText = RELICSLOT or ""
		elseif (itemClassID and itemClassID == 15) and (itemSubClassID and itemSubClassID == 2) then
			slotText = PET or ""
		elseif (itemClassID and itemClassID == 15) and (itemSubClassID and itemSubClassID == 5) then
			slotText = itemSubType or ""
		end

		if LMFrame_CFG["other"] == true and (itemClassID == 15) and ((itemSubClassID == 2) or (itemSubClassID == 5))then
			Enabled = 1
		elseif LMFrame_CFG["equip"] == true and (itemRarity >= LMFrame_CFG["rarity"]) and (itemClassID > 0 and itemClassID < 5 ) then
			Enabled = 1
		end

		if itemLvl and slotText then
			totalInfo = itemLvl.."-"..slotText
		elseif itemLvl then
			totalInfo = itemLvl
		elseif slotText then
			totalInfo = slotText
		end

		if player and Enabled == 1 then
			if #LMFrame_Report >= LMFrame_CFG["maxloots"] then table.remove(LMFrame_Report, 1) end
			LMFrame_Report[#LMFrame_Report+1] = {
				loottime        = lootTime,
				info			= totalInfo,
				player			= player,
				loot			= itemLink,
			}
			local numButtons = #LMFrame_Report
			for index = 1, numButtons do
				LMFrame[index]:SetText(DB.InfoColor..LMFrame_Report[index]["loottime"].." " ..ClassColor(LMFrame_Report[index]["player"]).." " ..LMFrame_Report[index]["loot"].." <"..LMFrame_Report[index]["info"]..">")
				LMFrame[index]:Show()
			end
			LMFrame:SetSize((LMFrame_Width * 2), (LMFrame_Point * 2) + (fontHeight * 3) + ((Button_Height + Button_Spacing) * numButtons - Button_Spacing))
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