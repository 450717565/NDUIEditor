local _, ns = ...
local B, C, L, DB = unpack(ns)
local Misc = B:GetModule("Misc")

local wipe, select, pairs, tonumber = wipe, select, pairs, tonumber
local strsplit, strfind = strsplit, strfind
local InboxItemCanDelete, DeleteInboxItem, TakeInboxMoney, TakeInboxItem = InboxItemCanDelete, DeleteInboxItem, TakeInboxMoney, TakeInboxItem
local GetInboxNumItems, GetInboxHeaderInfo, GetInboxItem, GetItemInfo = GetInboxNumItems, GetInboxHeaderInfo, GetInboxItem, GetItemInfo
local C_Timer_After = C_Timer.After
local C_Mail_HasInboxMoney = C_Mail.HasInboxMoney
local C_Mail_IsCommandPending = C_Mail.IsCommandPending
local ATTACHMENTS_MAX_RECEIVE, ERR_MAIL_DELETE_ITEM_ERROR = ATTACHMENTS_MAX_RECEIVE, ERR_MAIL_DELETE_ITEM_ERROR
local NORMAL_STRING = GUILDCONTROL_OPTION16
local OPENING_STRING = OPEN_ALL_MAIL_BUTTON_OPENING

local mailIndex, timeToWait, totalCash, inboxItems = 0, .15, 0, {}
local isGoldCollecting

function Misc:MailBox_DelectClick()
	local selectedID = self.id + (InboxFrame.pageNum-1)*7
	if InboxItemCanDelete(selectedID) then
		DeleteInboxItem(selectedID)
	else
		UIErrorsFrame:AddMessage(DB.InfoColor..ERR_MAIL_DELETE_ITEM_ERROR)
	end
end

function Misc:MailItem_AddDelete(i)
	local bu = CreateFrame("Button", nil, self)
	bu:SetPoint("BOTTOMRIGHT", self:GetParent(), "BOTTOMRIGHT", -10, 5)
	bu:SetSize(16, 16)
	B.PixelIcon(bu, 136813, true)
	bu.id = i
	bu:SetScript("OnClick", Misc.MailBox_DelectClick)
	B.AddTooltip(bu, "ANCHOR_RIGHT", DELETE, "system")
end

function Misc:InboxItem_OnEnter()
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

function Misc:ContactButton_OnClick()
	local text = self.name:GetText() or ""
	SendMailNameEditBox:SetText(text)
end

function Misc:ContactButton_Delete()
	NDuiADB["ContactList"][self.__owner.name:GetText()] = nil
	Misc:ContactList_Refresh()
end

function Misc:ContactButton_Create(parent, index)
	local button = CreateFrame("Button", nil, parent)
	button:SetSize(150, 20)
	button:SetPoint("TOPLEFT", 2, -2 - (index-1) *20)

	local HL = button:CreateTexture(nil, "HIGHLIGHT")
	HL:SetAllPoints()
	HL:SetColorTexture(1, 1, 1, .25)
	button.HL = HL

	local name = B.CreateFS(button, 13, "Name", false, "LEFT", 0, 0)
	name:SetPoint("RIGHT", button, "LEFT", 155, 0)
	button.name = name

	button:RegisterForClicks("AnyUp")
	button:SetScript("OnClick", Misc.ContactButton_OnClick)

	local delete = B.CreateButton(button, 20, 20, true, "Interface\\RAIDFRAME\\ReadyCheck-NotReady")
	delete:SetPoint("LEFT", button, "RIGHT", 2, 0)
	delete.__owner = button
	delete:SetScript("OnClick", Misc.ContactButton_Delete)
	button.delete = delete

	return button
end

function Misc:ContactList_Refresh()
	wipe(contactList)

	local count = 0
	for name, color in pairs(NDuiADB["ContactList"]) do
		count = count + 1
		local r, g, b = strsplit(":", color)
		if not contactList[count] then contactList[count] = {} end
		contactList[count].name = name
		contactList[count].r = r
		contactList[count].g = g
		contactList[count].b = b
	end

	Misc:ContactList_Update()
end

function Misc:ContactButton_Update(button)
	local index = button.index
	local info = contactList[index]

	button.name:SetText(info.name)
	button.name:SetTextColor(info.r, info.g, info.b)
end

function Misc:ContactList_Update()
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
			Misc:ContactButton_Update(button)
			usedHeight = usedHeight + height
			button:Show()
		else
			button.index = nil
			button:Hide()
		end
	end

	HybridScrollFrame_Update(scrollFrame, numFriendButtons*height, usedHeight)
end

function Misc:ContactList_OnMouseWheel(delta)
	local scrollBar = self.scrollBar
	local step = delta*self.buttonHeight
	if IsShiftKeyDown() then
		step = step*18
	end
	scrollBar:SetValue(scrollBar:GetValue() - step)
	Misc:ContactList_Update()
end

function Misc:MailBox_ContactList()
	local bu = B.CreateGear(SendMailFrame)
	bu:SetPoint("LEFT", SendMailNameEditBox, "RIGHT", 3, 0)

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
		Misc:ContactList_Refresh()
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
		buttons[i] = Misc:ContactButton_Create(scrollChild, i)
	end

	scrollFrame.buttons = buttons
	scrollFrame.buttonHeight = buttonHeight
	scrollFrame.update = Misc.ContactList_Update
	scrollFrame:SetScript("OnMouseWheel", Misc.ContactList_OnMouseWheel)
	scrollChild:SetSize(scrollFrame:GetWidth(), numButtons * buttonHeight)
	scrollFrame:SetVerticalScroll(0)
	scrollFrame:UpdateScrollChildRect()
	scrollBar:SetMinMaxValues(0, numButtons * buttonHeight)
	scrollBar:SetValue(0)

	Misc:ContactList_Refresh()
end

function Misc:MailBox_CollectGold()
	if mailIndex > 0 then
		if not C_Mail_IsCommandPending() then
			if C_Mail_HasInboxMoney(mailIndex) then
				TakeInboxMoney(mailIndex)
			end
			mailIndex = mailIndex - 1
		end
		C_Timer_After(timeToWait, Misc.MailBox_CollectGold)
	else
		isGoldCollecting = false
		Misc:UpdateOpeningText()
	end
end

function Misc:MailBox_CollectAllGold()
	if isGoldCollecting then return end
	if totalCash == 0 then return end

	isGoldCollecting = true
	mailIndex = GetInboxNumItems()
	Misc:UpdateOpeningText(true)
	Misc:MailBox_CollectGold()
end

function Misc:TotalCash_OnEnter()
	local numItems = GetInboxNumItems()
	if numItems == 0 then return end

	for i = 1, numItems do
		totalCash = totalCash + select(5, GetInboxHeaderInfo(i))
	end

	if totalCash > 0 then
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:AddLine(L["TotalGold"])
		GameTooltip:AddLine(" ")
		GameTooltip:AddLine(Misc:GetMoneyString(totalCash, true), 1,1,1)
		GameTooltip:Show()
	end

	if self and self.bgTex then
		B.Tex_OnEnter(self)
	end
end

function Misc:TotalCash_OnLeave()
	B:HideTooltip()
	totalCash = 0

	if self and self.bgTex then
		B.Tex_OnLeave(self)
	end
end

function Misc:UpdateOpeningText(opening)
	if opening then
		Misc.GoldButton:SetText(OPENING_STRING)
	else
		Misc.GoldButton:SetText(NORMAL_STRING)
	end
end

function Misc:MailBox_CreatButton(parent, width, height, text, anchor)
	local button = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
	button:SetSize(width, height)
	button:SetPoint(unpack(anchor))
	button:SetText(text)
	if C.db["Skins"]["BlizzardSkins"] then B.ReskinButton(button) end

	return button
end

function Misc:CollectGoldButton()
	OpenAllMail:ClearAllPoints()
	OpenAllMail:SetPoint("BOTTOMRIGHT", MailFrameInset, "TOP", -2, 5)

	local button = Misc:MailBox_CreatButton(InboxFrame, 80, 24, "", {"LEFT", OpenAllMail, "RIGHT", 4, 0})
	button:SetScript("OnClick", Misc.MailBox_CollectAllGold)
	button:SetScript("OnEnter", Misc.TotalCash_OnEnter)
	button:SetScript("OnLeave", Misc.TotalCash_OnLeave)

	Misc.GoldButton = button
	Misc:UpdateOpeningText()
end

function Misc:MailBox_CollectAttachment()
	for i = 1, ATTACHMENTS_MAX_RECEIVE do
		local attachmentButton = OpenMailFrame.OpenMailAttachments[i]
		if attachmentButton:IsShown() then
			TakeInboxItem(InboxFrame.openMailID, i)
			C_Timer_After(timeToWait, Misc.MailBox_CollectAttachment)
			return
		end
	end
end

function Misc:MailBox_CollectCurrent()
	if OpenMailFrame.cod then
		UIErrorsFrame:AddMessage(DB.InfoColor..L["MailIsCOD"])
		return
	end

	local currentID = InboxFrame.openMailID
	if C_Mail_HasInboxMoney(currentID) then
		TakeInboxMoney(currentID)
	end
	Misc:MailBox_CollectAttachment()
end

function Misc:CollectCurrentButton()
	local button = Misc:MailBox_CreatButton(OpenMailFrame, 80, 24, L["TakeAll"], {"RIGHT", "OpenMailReplyButton", "LEFT", -1, 0})
	button:SetScript("OnClick", Misc.MailBox_CollectCurrent)
end

function Misc:LastMailSaver()
	local mailSaver = CreateFrame("CheckButton", nil, SendMailFrame, "OptionsCheckButtonTemplate")
	mailSaver:SetHitRectInsets(0, 0, 0, 0)
	mailSaver:SetPoint("RIGHT", MailFrame.CloseButton, "LEFT", -3, 0)
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
			self:SetText(C.db["Misc"]["MailTarget"])
			resetPending = nil
		end
	end)

	SendMailFrame:HookScript("OnShow", function()
		if C.db["Misc"]["MailSaver"] then
			SendMailNameEditBox:SetText(C.db["Misc"]["MailTarget"])
		end
	end)
end

function Misc:MailBox()
	if not C.db["Misc"]["Mail"] then return end
	if IsAddOnLoaded("Postal") then return end

	-- Delete buttons
	for i = 1, 7 do
		local itemButton = _G["MailItem"..i.."Button"]
		Misc.MailItem_AddDelete(itemButton, i)
	end

	-- Tooltips for multi-items
	hooksecurefunc("InboxFrameItem_OnEnter", Misc.InboxItem_OnEnter)

	-- Custom contact list
	Misc:MailBox_ContactList()

	-- Replace the alert frame
	if InboxTooMuchMail then
		InboxTooMuchMail:ClearAllPoints()
		InboxTooMuchMail:SetPoint("BOTTOM", MailFrame, "TOP", 0, 5)
	end

	Misc.GetMoneyString = B:GetModule("Infobar").GetMoneyString
	Misc:CollectGoldButton()
	Misc:CollectCurrentButton()
	Misc:LastMailSaver()
end
Misc:RegisterMisc("MailBox", Misc.MailBox)