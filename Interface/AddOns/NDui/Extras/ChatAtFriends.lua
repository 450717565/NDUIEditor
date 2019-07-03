-------------------------------------
-- 輸入框首字@可快捷密好友
-- Author:M
-------------------------------------
local B, C, L, DB = unpack(select(2, ...))
local Extras = B:GetModule("Extras")
local cr, cg, cb = DB.r, DB.g, DB.b

local tbinsert = table.insert

--職業顔色值
local LOCAL_CLASS_INFO = {}

do
	local localClass, class
	for i = 1, GetNumClasses() do
		localClass, class = GetClassInfo(i)
		LOCAL_CLASS_INFO[localClass] = DB.ClassColors[class] or NORMAL_FONT_COLOR
		LOCAL_CLASS_INFO[localClass].class = class
	end
end

--按鈕數量
local numButton = 12

--創建信息框
do
	local function onclick(self)
		local parent = self:GetParent()
		local editBox = ChatEdit_GetLastActiveWindow()
		if (self.dataIsBNet) then
			editBox:SetAttribute("chatType", "BN_WHISPER")
			editBox:SetAttribute("tellTarget", self.dataBName)
		else
			editBox:SetAttribute("chatType", "WHISPER")
			editBox:SetAttribute("tellTarget", self.dataName)
		end
		ChatEdit_UpdateHeader(editBox)
		editBox:SetText(strsub(editBox:GetText(),parent.editPos+1))
		parent:Hide()
	end
	local function createButton(parent, index)
		local button = CreateFrame("Button", "ChatAtFriendsFrameButton"..index, parent)
		button:SetHighlightTexture(DB.bdTex, "ADD")
		button:SetID(index)
		button:SetHeight(26)
		button:SetWidth(128)
		button:SetPoint("LEFT", 1, 0)
		button:SetPoint("RIGHT", -1, 0)
		button:SetScript("OnClick", onclick)
		if (index == 1) then
			button:SetPoint("TOP", parent, "TOP", 2, -12)
		else
			button:SetPoint("TOP", _G["ChatAtFriendsFrameButton"..(index-1)], "BOTTOM", 0, -6)
		end
		button.icon = button:CreateTexture(nil, "BORDER")
		button.icon:SetSize(20, 20)
		button.icon:SetPoint("LEFT", 8, 0)
		button.icon:SetTexture("Interface\\TargetingFrame\\UI-Classes-Circles")
		button.name = B.CreateFS(button, 13, "", false, "TOPLEFT", 30, 0)
		button.name:SetJustifyH("LEFT")
		button.name:SetSize(90, 18)
		button.area = B.CreateFS(button, 9, "", false, "BOTTOMLEFT", 30, 0)
		button.area:SetJustifyH("LEFT")
		button.area:SetSize(90, 12)
		button.area:SetTextColor(1, 0.82, 0, 0.8)
		button.level = B.CreateFS(button, 9, "", false, "LEFT", -2, -6)
		button.level:SetSize(40, 40)
		button.level:SetTextColor(1, 0.82, 0)

		local hl = button:GetHighlightTexture()
		hl:SetVertexColor(cr, cg, cb, .25)
	end
	local frame = CreateFrame("Frame", "ChatAtFriendsFrame", UIParent)
	frame:Hide()
	frame:SetClampedToScreen(true)
	frame:SetFrameStrata("DIALOG")
	frame:SetSize(136, 500)

	for i = 1, numButton do createButton(frame, i) end

	function Extras:ChatAtFriends()
		B.SetBackground(frame)
	end
end

--獲取好友信息
local function ListFriends(text)
	local friends = {}
	local accountName, bnetIDGameAccount, client
	local name, level, class, area, faction, _
	--本服好友
	local numWoWTotal, numWoWOnline = GetNumFriends()
	if (numWoWOnline > 0) then
		faction = UnitFactionGroup("player")
		for id = 1, numWoWOnline do
			name, level, class, area = GetFriendInfo(id)
			tbinsert(friends, { name = name, level = level, class = class, area = area, faction = faction, isBNet = false, })
		end
	end
	--戰網好友
	local numBNetTotal, numBNetOnline = BNGetNumFriends()
	if (numBNetOnline > 0) then
		for id = 1, numBNetOnline do
			_, accountName, _, _, _, bnetIDGameAccount, client = BNGetFriendInfo(id)
			if (client == "WoW" and bnetIDGameAccount) then
				_, name, _, _, _, faction, _, class, _, area, level = BNGetGameAccountInfo(bnetIDGameAccount)
				tbinsert(friends, { bname = accountName, name = name, level = level, class = class, area = area, faction = faction, isBNet = true, })
			end
		end
	end
	--好友太多的話自動啓用關鍵字匹配
	if (#friends > numButton) then
		text = text:gsub("@", "")
		if (text ~= "") then
			local t = {}
			for _, v in ipairs(friends) do
				if (strfind(v.name, text)) then
					tbinsert(t, v)
				end
			end
			if (#t > 0) then friends = t end
		end
	end

	return friends
end

--顯示好友信息框
local function ChatAtFriendsFrame_Show(self, text)
	local friends = ListFriends(text)
	local faction = UnitFactionGroup("player")
	local position = self.GetCursorPosition and self:GetCursorPosition() or 0
	local button, info
	local index = 1
	if (#friends == 0) then return ChatAtFriendsFrame:Hide() end
	while (friends[index] and index <= numButton) do
		info = LOCAL_CLASS_INFO[friends[index].class]
		button = _G["ChatAtFriendsFrameButton"..index]
		button.name:SetText(friends[index].name)
		button.area:SetText(friends[index].area)
		button.level:SetText(friends[index].level)
		button.name:SetTextColor(info.r, info.g, info.b)
		if (faction == friends[index].faction) then
			button.icon:SetTexture("Interface\\TargetingFrame\\UI-Classes-Circles")
			button.icon:SetTexCoord(unpack(CLASS_ICON_TCOORDS[info.class]))
		else
			button.icon:SetTexture("Interface\\TargetingFrame\\UI-PVP-"..friends[index].faction)
			button.icon:SetTexCoord(0, 44/64, 0, 44/64)
		end
		button.dataName = friends[index].name
		button.dataIsBNet = friends[index].isBNet
		button.dataBName = friends[index].bname
		button:Show()
		index = index + 1
	end
	ChatAtFriendsFrame:SetHeight((index-1)*32+20)
	while (_G["ChatAtFriendsFrameButton"..index]) do
		_G["ChatAtFriendsFrameButton"..index]:Hide()
		index = index + 1
	end
	ChatAtFriendsFrame.editPos = position
	ChatAtFriendsFrame:SetPoint("BOTTOMLEFT", self, "TOPLEFT", position*8+40, 5)
	ChatAtFriendsFrame:Show()
end

--隱藏好友信息框
local function ChatAtFriendsFrame_Hide()
	ChatAtFriendsFrame:Hide()
end

--功能附到聊天框 多于3字不顯示
hooksecurefunc("ChatEdit_OnTextChanged", function(self, userInput)
	local text = self:GetText()
	if (userInput) then
		if (strfind(text, "^%s*@%w-") and self:GetUTF8CursorPosition() <= 4) then
			ChatAtFriendsFrame_Show(self, text)
		else
			ChatAtFriendsFrame_Hide()
		end
	end
end)
hooksecurefunc("ChatEdit_OnEditFocusLost", function(self) ChatAtFriendsFrame_Hide() end)
hooksecurefunc("ChatEdit_OnEscapePressed", function(self) ChatAtFriendsFrame_Hide() end)


-------------------------------------
--战网好友显示角色信息
-------------------------------------

hooksecurefunc("ChatEdit_UpdateHeader", function(editBox)
	if (not editBox.nametip) then
		editBox.nametip = CreateFrame("Frame", nil, editBox)
		editBox.nametip:SetPoint("TOPLEFT", editBox, "TOPLEFT", 40, 12)
		editBox.nametip:SetSize(136, 16)
		editBox.nametip.icon = editBox.nametip:CreateTexture(nil, "BORDER")
		editBox.nametip.icon:SetSize(15, 15)
		editBox.nametip.icon:SetPoint("LEFT", 8, 5)
		editBox.nametip.icon:SetTexture("Interface\\TargetingFrame\\UI-Classes-Circles")
		editBox.nametip.name = B.CreateFS(editBox.nametip, 14, "", false, "LEFT", 25, 5)
		editBox.nametip.name:SetJustifyH("LEFT")
		editBox.nametip.name:SetSize(128, 16)
		editBox.nametip.level = B.CreateFS(editBox.nametip, 9, "", false, "LEFT", -2, 1)
		editBox.nametip.level:SetSize(40, 14)
		editBox.nametip.level:SetTextColor(1, 0.82, 0)
		editBox.nametip.faction = UnitFactionGroup("player")
	end
	if (editBox:GetAttribute("chatType") == "BN_WHISPER") then
		local name, faction, class, area, level, info
		local accountName, bnetIDGameAccount, client
		local bname = editBox:GetAttribute("tellTarget")
		local _, numBNetOnline = BNGetNumFriends()
		for i = 1, numBNetOnline do
			_, accountName, _, _, _, bnetIDGameAccount, client = BNGetFriendInfo(i)
			if (bname == accountName and client == "WoW" and bnetIDGameAccount) then
				_, name, _, _, _, faction, _, class, _, area, level = BNGetGameAccountInfo(bnetIDGameAccount)
				info = LOCAL_CLASS_INFO[class]
				editBox.nametip.name:SetText(name)
				editBox.nametip.level:SetText(level)
				editBox.nametip.name:SetTextColor(info.r, info.g, info.b)
				if (editBox.nametip.faction == faction) then
					editBox.nametip.icon:SetTexture("Interface\\TargetingFrame\\UI-Classes-Circles")
					editBox.nametip.icon:SetTexCoord(unpack(CLASS_ICON_TCOORDS[info.class]))
				else
					editBox.nametip.icon:SetTexture("Interface\\TargetingFrame\\UI-PVP-"..faction)
					editBox.nametip.icon:SetTexCoord(0, 44/64, 0, 44/64)
				end
				return editBox.nametip:Show()
			end
		end
		editBox.nametip:Hide()
	else
		editBox.nametip:Hide()
	end
end)