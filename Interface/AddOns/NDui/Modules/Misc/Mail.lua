local _, ns = ...
local B, C, L, DB = unpack(ns)
local MISC = B:GetModule("Misc")

local wipe, select, pairs, tonumber = wipe, select, pairs, tonumber
local strsplit, strfind, tinsert = strsplit, strfind, tinsert
local InboxItemCanDelete, DeleteInboxItem, TakeInboxMoney, TakeInboxItem = InboxItemCanDelete, DeleteInboxItem, TakeInboxMoney, TakeInboxItem
local GetInboxNumItems, GetInboxHeaderInfo, GetInboxItem, GetItemInfo = GetInboxNumItems, GetInboxHeaderInfo, GetInboxItem, GetItemInfo
local GetSendMailPrice, GetMoney = GetSendMailPrice, GetMoney
local C_Timer_After = C_Timer.After
local C_Mail_HasInboxMoney = C_Mail.HasInboxMoney
local C_Mail_IsCommandPending = C_Mail.IsCommandPending
local ATTACHMENTS_MAX_RECEIVE, ERR_MAIL_DELETE_ITEM_ERROR = ATTACHMENTS_MAX_RECEIVE, ERR_MAIL_DELETE_ITEM_ERROR
local NORMAL_STRING = GUILDCONTROL_OPTION16
local OPENING_STRING = OPEN_ALL_MAIL_BUTTON_OPENING

local mailIndex, timeToWait, totalCash, inboxItems = 0, .15, 0, {}
local isGoldCollecting

function MISC:MailBox_DelectClick()
	local selectedID = self.id + (InboxFrame.pageNum-1)*7
	if InboxItemCanDelete(selectedID) then
		DeleteInboxItem(selectedID)
	else
		UIErrorsFrame:AddMessage(DB.InfoColor..ERR_MAIL_DELETE_ITEM_ERROR)
	end
end

function MISC:MailItem_AddDelete(i)
	local bu = CreateFrame("Button", nil, self)
	bu:SetPoint("BOTTOMRIGHT", self:GetParent(), "BOTTOMRIGHT", -10, 5)
	bu:SetSize(16, 16)
	B.PixelIcon(bu, 136813, true)
	bu.id = i
	bu:SetScript("OnClick", MISC.MailBox_DelectClick)
	B.AddTooltip(bu, "ANCHOR_RIGHT", DELETE, "system")
end

function MISC:InboxItem_OnEnter()
	wipe(inboxItems)

	local itemAttached = select(8, GetInboxHeaderInfo(self.index))
	if itemAttached then
		for attachID = 1, 12 do
			local _, itemID, _, itemCount = GetInboxItem(self.index, attachID)
			if itemCount and itemCount > 0 then
				inboxItems[itemID] = (inboxItems[itemID] or 0) + itemCount
			end
		end

		if itemAttached > 1 then
			GameTooltip:AddLine(L["Attach List"])
			for itemID, count in pairs(inboxItems) do
				local itemName, _, itemQuality, _, _, _, _, _, _, itemTexture = GetItemInfo(itemID)
				if itemName then
					local r, g, b = B.GetQualityColor(itemQuality)
					GameTooltip:AddDoubleLine(" |T"..itemTexture..":12:12:0:0:50:50:4:46:4:46|t "..itemName, count, r, g, b)
				end
			end
			GameTooltip:Show()
		end
	end
end

local contactList = {}
local contactListByRealm = {}

function MISC:ContactButton_OnClick()
	local text = self.name:GetText() or ""
	SendMailNameEditBox:SetText(text)
	SendMailNameEditBox:SetCursorPosition(0)
end

function MISC:ContactButton_Delete()
	NDuiADB["ContactList"][self.__owner.name:GetText()] = nil
	MISC:ContactList_Refresh()
end

function MISC:ContactButton_Create(parent, index)
	local button = CreateFrame("Button", nil, parent)
	button:SetSize(150, 20)
	button:SetPoint("TOPLEFT", 2, -2 - (index-1) *20)

	local HL = button:CreateTexture(nil, "HIGHLIGHT")
	HL:SetAllPoints()
	HL:SetColorTexture(1, 1, 1, .25)
	button.HL = HL

	local name = B.CreateFS(button, 13, "Name", false, "LEFT", 0, 0)
	name:SetPoint("RIGHT", button, "RIGHT", 0, 0)
	button.name = name

	button:RegisterForClicks("AnyUp")
	button:SetScript("OnClick", MISC.ContactButton_OnClick)

	local delete = B.CreateButton(button, 20, 20, true, "Interface\\RAIDFRAME\\ReadyCheck-NotReady")
	delete:SetPoint("LEFT", button, "RIGHT", 2, 0)
	delete.__owner = button
	delete:SetScript("OnClick", MISC.ContactButton_Delete)
	button.delete = delete

	return button
end

local function GenerateDataByRealm(realm)
	if contactListByRealm[realm] then
		for name, color in pairs(contactListByRealm[realm]) do
			local r, g, b = strsplit(":", color)
			tinsert(contactList, {name = name.."-"..realm, r = r, g = g, b = b})
		end
	end
end

function MISC:ContactList_Refresh()
	wipe(contactList)
	wipe(contactListByRealm)

	for fullname, color in pairs(NDuiADB["ContactList"]) do
		local name, realm = strsplit("-", fullname)
		if not contactListByRealm[realm] then contactListByRealm[realm] = {} end
		contactListByRealm[realm][name] = color
	end

	GenerateDataByRealm(DB.MyRealm)

	for realm, value in pairs(contactListByRealm) do
		if realm ~= DB.MyRealm then
			GenerateDataByRealm(realm)
		end
	end

	MISC:ContactList_Update()
end

function MISC:ContactButton_Update(button)
	local index = button.index
	local info = contactList[index]

	button.name:SetText(info.name)
	button.name:SetTextColor(info.r, info.g, info.b)
end

function MISC:ContactList_Update()
	local scrollFrame = _G.NDuiMailBoxScrollFrame
	local usedHeight = 0
	local buttons = scrollFrame.buttons
	local height = scrollFrame.buttonHeight
	local numFriendButtons = #contactList
	local offset = HybridScrollFrame_GetOffset(scrollFrame)

	for i = 1, #buttons do
		local button = buttons[i]
		local index = offset + i
		if index <= numFriendButtons then
			button.index = index
			MISC:ContactButton_Update(button)
			usedHeight = usedHeight + height
			button:Show()
		else
			button.index = nil
			button:Hide()
		end
	end

	HybridScrollFrame_Update(scrollFrame, numFriendButtons*height, usedHeight)
end

function MISC:ContactList_OnMouseWheel(delta)
	local scrollBar = self.scrollBar
	local step = delta*self.buttonHeight
	if IsShiftKeyDown() then
		step = step*18
	end
	scrollBar:SetValue(scrollBar:GetValue() - step)
	MISC:ContactList_Update()
end

function MISC:MailBox_ContactList()
	local bu = B.CreateGear(SendMailFrame)
	bu:SetPoint("LEFT", SendMailNameEditBox, "RIGHT", 25, 0)

	local list = CreateFrame("Frame", nil, bu)
	list:SetSize(200, 424)
	list:SetPoint("TOPLEFT", MailFrame, "TOPRIGHT", 3, 0)
	list:SetFrameStrata("Tooltip")
	B.CreateBG(list)
	B.CreateFS(list, 14, L["ContactList"], "system", "TOP", 0, -5)

	bu:SetScript("OnClick", function()
		B.TogglePanel(list)
	end)

	local editbox = B.CreateEditBox(list, 120, 20)
	editbox:SetJustifyH("LEFT")
	editbox:SetPoint("TOPLEFT", 5, -25)
	editbox.title = L["Tips"]
	B.AddTooltip(editbox, "ANCHOR_BOTTOMRIGHT", DB.InfoColor..L["AddContactTip"])
	local swatch = B.CreateColorSwatch(list, "")
	swatch:SetPoint("LEFT", editbox, "RIGHT", 5, 0)
	local add = B.CreateButton(list, 42, 22, ADD, 14)
	add:SetPoint("LEFT", swatch, "RIGHT", 5, 0)
	add:SetScript("OnClick", function()
		local text = editbox:GetText()
		if text == "" or tonumber(text) then return end -- incorrect input
		if not strfind(text, "-") then text = text.."-"..DB.MyRealm end -- complete player realm name
		if NDuiADB["ContactList"][text] then return end -- unit exists

		local r, g, b = swatch.tex:GetColor()
		NDuiADB["ContactList"][text] = r..":"..g..":"..b
		MISC:ContactList_Refresh()
		editbox:SetText("")
	end)

	local scrollFrame = CreateFrame("ScrollFrame", "NDuiMailBoxScrollFrame", list, "HybridScrollFrameTemplate")
	scrollFrame:SetSize(175, 370)
	scrollFrame:SetPoint("BOTTOMLEFT", 5, 5)
	B.CreateBDFrame(scrollFrame)
	list.scrollFrame = scrollFrame

	local scrollBar = CreateFrame("Slider", "$parentScrollBar", scrollFrame, "HybridScrollBarTemplate")
	scrollBar.doNotHide = true
	B.ReskinScroll(scrollBar)
	scrollFrame.scrollBar = scrollBar

	local scrollChild = scrollFrame.scrollChild
	local numButtons = 19 + 1
	local buttonHeight = 22
	local buttons = {}
	for i = 1, numButtons do
		buttons[i] = MISC:ContactButton_Create(scrollChild, i)
	end

	scrollFrame.buttons = buttons
	scrollFrame.buttonHeight = buttonHeight
	scrollFrame.update = MISC.ContactList_Update
	scrollFrame:SetScript("OnMouseWheel", MISC.ContactList_OnMouseWheel)
	scrollChild:SetSize(scrollFrame:GetWidth(), numButtons * buttonHeight)
	scrollFrame:SetVerticalScroll(0)
	scrollFrame:UpdateScrollChildRect()
	scrollBar:SetMinMaxValues(0, numButtons * buttonHeight)
	scrollBar:SetValue(0)

	MISC:ContactList_Refresh()
end

function MISC:MailBox_CollectGold()
	if mailIndex > 0 then
		if not C_Mail_IsCommandPending() then
			if C_Mail_HasInboxMoney(mailIndex) then
				TakeInboxMoney(mailIndex)
			end
			mailIndex = mailIndex - 1
		end
		C_Timer_After(timeToWait, MISC.MailBox_CollectGold)
	else
		isGoldCollecting = false
		MISC:UpdateOpeningText()
	end
end

function MISC:MailBox_CollectAllGold()
	if isGoldCollecting then return end
	if totalCash == 0 then return end

	isGoldCollecting = true
	mailIndex = GetInboxNumItems()
	MISC:UpdateOpeningText(true)
	MISC:MailBox_CollectGold()
end

function MISC:TotalCash_OnEnter()
	local numItems = GetInboxNumItems()
	if numItems == 0 then return end

	for i = 1, numItems do
		totalCash = totalCash + select(5, GetInboxHeaderInfo(i))
	end

	if totalCash > 0 then
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:AddLine(L["TotalGold"])
		GameTooltip:AddLine(" ")
		GameTooltip:AddLine(MISC:GetMoneyString(totalCash, true), 1,1,1)
		GameTooltip:Show()
	end

	if self and self.bgTex then
		B.Tex_OnEnter(self)
	end
end

function MISC:TotalCash_OnLeave()
	B:HideTooltip()
	totalCash = 0

	if self and self.bgTex then
		B.Tex_OnLeave(self)
	end
end

function MISC:UpdateOpeningText(opening)
	if opening then
		MISC.GoldButton:SetText(OPENING_STRING)
	else
		MISC.GoldButton:SetText(NORMAL_STRING)
	end
end

function MISC:MailBox_CreatButton(parent, width, height, text, anchor)
	local button = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
	button:SetSize(width, height)
	button:SetPoint(unpack(anchor))
	button:SetText(text)
	if C.db["Skins"]["BlizzardSkins"] then B.ReskinButton(button) end

	return button
end

function MISC:CollectGoldButton()
	B.UpdatePoint(OpenAllMail, "BOTTOMRIGHT", MailFrameInset, "TOP", -2, 5)

	local button = MISC:MailBox_CreatButton(InboxFrame, 80, 24, "", {"LEFT", OpenAllMail, "RIGHT", 4, 0})
	button:SetScript("OnClick", MISC.MailBox_CollectAllGold)
	button:SetScript("OnEnter", MISC.TotalCash_OnEnter)
	button:SetScript("OnLeave", MISC.TotalCash_OnLeave)

	MISC.GoldButton = button
	MISC:UpdateOpeningText()
end

function MISC:MailBox_CollectAttachment()
	for i = 1, ATTACHMENTS_MAX_RECEIVE do
		local attachmentButton = OpenMailFrame.OpenMailAttachments[i]
		if attachmentButton:IsShown() then
			TakeInboxItem(InboxFrame.openMailID, i)
			C_Timer_After(timeToWait, MISC.MailBox_CollectAttachment)
			return
		end
	end
end

function MISC:MailBox_CollectCurrent()
	if OpenMailFrame.cod then
		UIErrorsFrame:AddMessage(DB.InfoColor..L["MailIsCOD"])
		return
	end

	local currentID = InboxFrame.openMailID
	if C_Mail_HasInboxMoney(currentID) then
		TakeInboxMoney(currentID)
	end
	MISC:MailBox_CollectAttachment()
end

function MISC:CollectCurrentButton()
	local button = MISC:MailBox_CreatButton(OpenMailFrame, 80, 24, L["TakeAll"], {"RIGHT", "OpenMailReplyButton", "LEFT", -1, 0})
	button:SetScript("OnClick", MISC.MailBox_CollectCurrent)
end

function MISC:LastMailSaver()
	local mailSaver = CreateFrame("CheckButton", nil, SendMailFrame, "OptionsCheckButtonTemplate")
	mailSaver:SetHitRectInsets(0, 0, 0, 0)
	mailSaver:SetPoint("LEFT", SendMailNameEditBox, "RIGHT", 0, 0)
	mailSaver:SetSize(26, 26)
	B.ReskinCheck(mailSaver)

	mailSaver:SetChecked(C.db["Misc"]["MailSaver"])
	mailSaver:SetScript("OnClick", function(self)
		C.db["Misc"]["MailSaver"] = self:GetChecked()
	end)
	B.AddTooltip(mailSaver, "ANCHOR_TOP", L["SaveMailTarget"])

	local resetPending
	hooksecurefunc("SendMailFrame_SendMail", function()
		if C.db["Misc"]["MailSaver"] then
			C.db["Misc"]["MailTarget"] = SendMailNameEditBox:GetText()
			resetPending = true
		else
			resetPending = nil
		end
	end)

	hooksecurefunc(SendMailNameEditBox, "SetText", function(self, text)
		if resetPending and text == "" then
			resetPending = nil
			self:SetText(C.db["Misc"]["MailTarget"])
		end
	end)

	SendMailFrame:HookScript("OnShow", function()
		if C.db["Misc"]["MailSaver"] then
			SendMailNameEditBox:SetText(C.db["Misc"]["MailTarget"])
		end
	end)
end

function MISC:ArrangeDefaultElements()
	SendMailNameEditBox:SetWidth(160)
	SendMailNameEditBoxMiddle:SetWidth(144)
	SendMailSubjectEditBox:SetWidth(160)
	SendMailSubjectEditBoxMiddle:SetWidth(144)
	SendMailCostMoneyFrame:DisableDrawLayer("BACKGROUND")

	B.UpdatePoint(SendMailNameEditBox, "TOPLEFT", SendMailFrame, "TOPLEFT", 80, -30)
	B.UpdatePoint(SendMailSubjectEditBox, "TOPLEFT", SendMailNameEditBox, "BOTTOMLEFT", 0, -1)
	B.UpdatePoint(SendMailCostMoneyFrame, "LEFT", SendMailSubjectEditBox, "RIGHT", 4, 0)
	B.UpdatePoint(InboxTooMuchMail, "BOTTOM", MailFrame, "TOP", 0, 5)

	SendMailMailButton:HookScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_TOP")
		GameTooltip:ClearLines()
		local sendPrice = GetSendMailPrice()
		local colorStr = "|cffFFFFFF"
		if sendPrice > GetMoney() then colorStr = "|cffFF0000" end
		GameTooltip:AddLine(SEND_MAIL_COST..colorStr..MISC:GetMoneyString(sendPrice))
		GameTooltip:Show()
	end)
	SendMailMailButton:HookScript("OnLeave", B.HideTooltip)
end

function MISC:MailBox()
	if not C.db["Misc"]["Mail"] then return end
	if IsAddOnLoaded("Postal") then return end

	-- Delete buttons
	for i = 1, 7 do
		local itemButton = _G["MailItem"..i.."Button"]
		MISC.MailItem_AddDelete(itemButton, i)
	end

	-- Tooltips for multi-items
	hooksecurefunc("InboxFrameItem_OnEnter", MISC.InboxItem_OnEnter)

	-- Custom contact list
	MISC:MailBox_ContactList()

	-- Elements
	MISC:ArrangeDefaultElements()

	MISC.GetMoneyString = B:GetModule("Infobar").GetMoneyString
	MISC:CollectGoldButton()
	MISC:CollectCurrentButton()
	MISC:LastMailSaver()
end
MISC:RegisterMisc("MailBox", MISC.MailBox)