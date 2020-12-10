------------------------------------------------------------
-- Core.lua
--
-- Abin
-- 2015/9/06
------------------------------------------------------------

local pairs = pairs
local ipairs = ipairs
local strfind = string.find
local type = type
local tinsert = table.insert
local strsub = strsub
local date = date
local tonumber = tonumber
local select = select
local PlaySoundFile = PlaySoundFile
local wipe = table.wipe
local tremove = table.remove
local SendWho = SendWho
local min = math.min
local max = math.max
local GetPlayerInfoByGUID = GetPlayerInfoByGUID
local BNGetNumFriends = BNGetNumFriends
local BNGetFriendInfo
local BNGetFriendInfoByID
local GMChatFrame_IsGM = GMChatFrame_IsGM
local ChatFrame_GetMessageEventFilters = ChatFrame_GetMessageEventFilters
local ChatEdit_ChooseBoxForSend = ChatEdit_ChooseBoxForSend
local ChatEdit_ActivateChat = ChatEdit_ActivateChat
local ChatEdit_ParseText = ChatEdit_ParseText
local InviteUnit = InviteUnit
local FriendsFrame_ShowDropdown = FriendsFrame_ShowDropdown
local FriendsFrame_ShowBNDropdown = FriendsFrame_ShowBNDropdown
local DEFAULT_CHAT_FRAME = DEFAULT_CHAT_FRAME
local UNKNOWN = UNKNOWN

local addon = LibAddonManager:CreateAddon(...)
local L = addon.L

addon:RegisterDB("WhisperPopDB")
addon:RegisterSlashCmd("whisperpop", "wp") -- Type /whisperpop or /wp to toggle the frame

addon.ICON_FILE = "Interface\\Icons\\INV_Letter_05"
addon.SOUND_FILE = "Interface\\AddOns\\WhisperPop\\Sounds\\Notify.ogg"
addon.BACKGROUND = "Interface\\DialogFrame\\UI-DialogBox-Background"
addon.BORDER = "Interface\\Tooltips\\UI-Tooltip-Border"

addon.MAX_MESSAGES = 500 -- Maximum messages stored for each conversation

--ADD 9.0
local function getDeprecatedAccountInfo(accountInfo)
	if accountInfo then
		local wowProjectID = accountInfo.gameAccountInfo.wowProjectID or 0
		local clientProgram = accountInfo.gameAccountInfo.clientProgram ~= "" and accountInfo.gameAccountInfo.clientProgram or nil
		return
			accountInfo.bnetAccountID, accountInfo.accountName, accountInfo.battleTag, accountInfo.isBattleTagFriend,
			accountInfo.gameAccountInfo.characterName, accountInfo.gameAccountInfo.gameAccountID, clientProgram,
			accountInfo.gameAccountInfo.isOnline, accountInfo.lastOnlineTime, accountInfo.isAFK, accountInfo.isDND, accountInfo.customMessage, accountInfo.note, accountInfo.isFriend,
			accountInfo.customMessageTime, wowProjectID, accountInfo.rafLinkType == Enum.RafLinkType.Recruit, accountInfo.gameAccountInfo.canSummon, accountInfo.isFavorite, accountInfo.gameAccountInfo.isWowMobile
	end
end
BNGetFriendInfo = function(friendIndex)
	local accountInfo = C_BattleNet.GetFriendAccountInfo(friendIndex)
	return getDeprecatedAccountInfo(accountInfo)
end
BNGetFriendInfoByID = function(id)
	local accountInfo = C_BattleNet.GetAccountInfoByID(id)
	return getDeprecatedAccountInfo(accountInfo)
end

-- Message are saved in format of: [1/0][hh:mm:ss][contents]
-- The first char is 1 if this message is inform, 0 otherwise
function addon:EncodeMessage(text, inform)
	local timeStamp = date("%y/%m/%d %H:%M:%S")
	return (inform and "1" or "0")..timeStamp..(text or ""), timeStamp
end

function addon:DecodeMessage(line)
	if type(line) ~= "string" then
		return
	end

	local inform
	if strsub(line, 1, 1) == "1" then
		inform = 1
	end

	local timeStamp = strsub(line, 2, 18)
	local text = strsub(line, 19)
	return text, inform, timeStamp
end

-- Splits name-realm
function addon:ParseNameRealm(text)
	if type(text) == "string" then
		local _, _, name, realm = strfind(text, "(.+)%-(.+)")
		return name or text, realm
	end
end

function addon:GetDisplayName(text, forceRealm)
	if self:IsBattleTag(text) then
		local id, name = self:GetBNInfoFromTag(text)
		return name or UNKNOWN
	end

	if forceRealm then
		return text
	end

	local name, realm = self:ParseNameRealm(text)
	if self.db.showRealm then
		if foreignOnly and realm == self.realm then
			return name
		else
			return text
		end
	else
		return name
	end
end

function addon:GetBNInfoFromTag(tag)
	if type(tag) ~= "string" then
		return
	end

	local count = BNGetNumFriends()
	local i
	for i = 1, count do
		local id, name, battleTag, _, _, _, _, online = BNGetFriendInfo(i)
		if battleTag == tag then
			return id, name, online, i
		end
	end
end

function addon:IsBattleTag(name)
	if type(name) == "string" then
		local _, _, prefix, surfix = strfind(name, "(.+)#(%d+)$")
		return prefix, surfix
	end
end

function addon:GetNewMessage()
	local i
	for i = 1, #self.db.history do
		local data = self.db.history[i]
		if data.new then
			return addon:GetDisplayName(data.name), data.class, addon:DecodeMessage(data.messages[1])
		end
	end
end

function addon:GetNewNames()
	local newNames = {}
	local i
	for i = 1, #self.db.history do
		local data = self.db.history[i]
		if data.new then
			tinsert(newNames, addon:GetDisplayName(data.name))
		end
	end
	return newNames
end

function addon:AddTooltipText(tooltip)
	local newNames = self:GetNewNames()
	if newNames[1] then
		tooltip:AddLine(L["new messages from"], 1, 1, 1, true)
		local i
		for i = 1, #newNames do
			tooltip:AddLine(newNames[i], 0, 1, 0, true)
		end
	else
		tooltip:AddLine(L["no new messages"], 1, 1, 1, true)
	end
end

local menuList = {
	[1] = {text = "邀请或加入", isTitle = true, notCheckable = true}
}

local function inviteFunc(_, bnetIDGameAccount, guid)
	FriendsFrame_InviteOrRequestToJoin(guid, bnetIDGameAccount)
end

local function CanCooperateWithUnit(gameAccountInfo)
	return gameAccountInfo.playerGuid and (gameAccountInfo.factionName == UnitFactionGroup("player")) and (gameAccountInfo.realmID ~= 0)
end

addon.EasyMenu = CreateFrame("Frame", nil, UIParent, "UIDropDownMenuTemplate")

function addon.HexRGB(r, g, b)
	if r then
		if type(r) == "table" then
			if r.r then r, g, b = r.r, r.g, r.b else r, g, b = unpack(r) end
		end
		return format("|cff%02x%02x%02x", r*255, g*255, b*255)
	end
end

addon.ClassList = {}
for k, v in pairs(LOCALIZED_CLASS_NAMES_MALE) do
	addon.ClassList[v] = k
end
addon.ClassColors = {}
local colors = CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS
for class, value in pairs(colors) do
	addon.ClassColors[class] = {}
	addon.ClassColors[class].r = value.r
	addon.ClassColors[class].g = value.g
	addon.ClassColors[class].b = value.b
	addon.ClassColors[class].colorStr = value.colorStr
end

function addon.ClassColor(class)
	local color = addon.ClassColors[class]
	if not color then return 1, 1, 1 end
	return color.r, color.g, color.b
end

function addon:BattlenetInvite(friendIndex, button)
	local index = 2
	if #menuList > 1 then
		for i = 2, #menuList do
			wipe(menuList[i])
		end
	end

	local numGameAccounts = C_BattleNet.GetFriendNumGameAccounts(friendIndex)
	local lastGameAccountID, lastGameAccountGUID
	if numGameAccounts > 0 then
		for i = 1, numGameAccounts do
			local gameAccountInfo = C_BattleNet.GetFriendGameAccountInfo(friendIndex, i)
			local charName = gameAccountInfo.characterName
			local client = gameAccountInfo.clientProgram
			local class = gameAccountInfo.className or UNKNOWN
			local bnetIDGameAccount = gameAccountInfo.gameAccountID
			local guid = gameAccountInfo.playerGuid
			local wowProjectID = gameAccountInfo.wowProjectID
			if client == BNET_CLIENT_WOW and CanCooperateWithUnit(gameAccountInfo) and wowProjectID == WOW_PROJECT_ID then
				if not menuList[index] then menuList[index] = {} end
				menuList[index].text = addon.HexRGB(addon.ClassColor(addon.ClassList[class]))..charName
				menuList[index].notCheckable = true
				menuList[index].arg1 = bnetIDGameAccount
				menuList[index].arg2 = guid
				menuList[index].func = inviteFunc
				lastGameAccountID = bnetIDGameAccount
				lastGameAccountGUID = guid

				index = index + 1
			end
		end
	end

	if index == 2 then return end
	if index == 3 then
		FriendsFrame_InviteOrRequestToJoin(lastGameAccountGUID, lastGameAccountID)
	else
		EasyMenu(menuList, addon.EasyMenu, button, 0, 0, "MENU", 1)
	end
end

function addon:HandleAction(name, action, button)
	if type(name) ~= "string" then
		return
	end

	local bnId, bnName, bnOnline
	if addon:IsBattleTag(name) then
		bnId, bnName, bnOnline, bnIndex = self:GetBNInfoFromTag(name)
		if not bnId then
			return
		end
	end

	if action == "MENU" then
		if bnId then
			FriendsFrame_ShowBNDropdown(bnName, bnOnline, nil, nil, nil, 1, bnId)
		else
			FriendsFrame_ShowDropdown(name, 1)
		end

	elseif action == "WHO" then
		SendWho("n-"..(bnName or name))

	elseif action == "INVITE" then
		if bnIndex then
			self:BattlenetInvite(bnIndex, button)
		else
			C_PartyInfo.InviteUnit(name)
		end

	elseif action == "WHISPER" then
		if bnName then
			ChatFrame_SendBNetTell(bnName)
		else
			ChatFrame_SendTell(name, SELECTED_DOCK_FRAME)
		end
	end
end

function addon:PlaySound()
	PlaySoundFile(self.SOUND_FILE, "Master") -- Sound alert
end

addon.DB_DEFAULTS = {
	time = 1,
	sound = 1,
	save = 1,
	notifyButton = 1,
	ignoreTags = 1,
	applyFilters = 1,
	receiveOnly = 0,
	showRealm = 1,
	foreignOnly = 1,
	buttonScale = { min = 50, max = 200, step = 5, default = 100 },
	listScale = { min = 50, max = 200, step = 5, default = 100 },
	listWidth = { min = 100, max = 400, step = 5, default = 200 },
	listHeight = { min = 100, max = 640, step = 20, default = 320 }
}

function addon:OnInitialize(db, firstTime)
	if firstTime or not addon:VerifyDBVersion(4.12, db) then
		db.version = 4.12
		local k, v
		for k, v in pairs(self.DB_DEFAULTS) do
			if v == 1 then
				db[k] = 1
			elseif type(v) == "table" then
				print(k, db[k])
				if type(db[k]) ~= "number"  or db[k] < v.min or db[k] > v.max then
					db[k] = v.default
				end
			end
		end
	end

	if type(db.history) ~= "table" then
		db.history = {}
	end

	self:BroadcastEvent("OnInitialize", db)

	local k
	for k in pairs(self.DB_DEFAULTS) do
		self:BroadcastOptionEvent(k, db[k])
	end

	self:RegisterEvent("PLAYER_LOGOUT")
	self:RegisterEvent("CHAT_MSG_WHISPER")
	self:RegisterEvent("CHAT_MSG_WHISPER_INFORM")
	self:RegisterEvent("CHAT_MSG_BN_WHISPER")
	self:RegisterEvent("CHAT_MSG_BN_WHISPER_INFORM")

	self:BroadcastEvent("OnListUpdate")
end

function addon:PLAYER_LOGOUT()
	if not self.db.save then
		wipe(self.db.history)
	end
end

function addon:Clear()
	local history = self.db.history
	local i
	for i = #history, 1, -1 do
		if not history[i].protected then
			tremove(history, i)
		end
	end

	self:BroadcastEvent("OnListUpdate")
	self:BroadcastEvent("OnClearMessages")
end

function addon:FindPlayerData(name)
	local index, data
	for index, data in ipairs(self.db.history) do
		if data.name == name then
			return index, data
		end
	end
end

function addon:Delete(name)
	local index, data = self:FindPlayerData(name)
	if index and not data.protected then
		tremove(self.db.history, index)
		self:BroadcastEvent("OnListUpdate")
	end
end

function addon:ProcessChatMsg(name, class, text, inform, bnid)
	if type(text) ~= "string" or type(name) ~= "string" then
		return
	end

	if self.db.ignoreTags then
		local tag = strsub(text, 1, 1)
		if tag == "<" or tag == "[" then
			return
		end
	end

	if self:IsIgnoredMessage(arg1) then
		return -- Ignored message
	end

	-- Names must be in the "name-realm" format except for BN friends
	if class == "BN" then
		name = select(3, BNGetFriendInfoByID(bnid or 0)) -- Seemingly better than my original solution, credits to Warbaby
		if not name then
			return
		end
	elseif class ~= "GM" then
		local _, realm = self:ParseNameRealm(name)
		if not realm then
			name = name.."-"..self.realm
		end
	end

	-- Add data into message history
	local index, data = self:FindPlayerData(name)
	if index then
		if index > 1 then
			tremove(self.db.history, index)
			tinsert(self.db.history, 1, data)
		end
	else
		data = { name = name, class = class }
		tinsert(self.db.history, 1, data)
	end

	if type(data.messages) ~= "table" then
		data.messages = {}
	end

	if inform then
		data.new = nil
	else
		data.new = 1
		data.received = 1
	end

	local msg, timeStamp = self:EncodeMessage(text, inform)
	tinsert(data.messages, msg)

	while #data.messages > self.MAX_MESSAGES do
		tremove(data.messages, 1)
	end

	self:BroadcastEvent("OnListUpdate")

	-- It's a new message
	if not inform and self.db.sound then
		self:PlaySound()
	end

	self:BroadcastEvent("OnNewMessage", name, class, text, inform, timeStamp)
end

function addon:CHAT_MSG_WHISPER(...)
	local text, name, _, _, _, flag, _, _, _, _, _, guid, _, _, _, hide = ...
	if hide then
		return
	end

	if flag == "GM" or flag == "DEV" then
		flag = "GM"
	else
		-- Spam filters only applied on incoming non-GM whispers, other cases make no sense
		if self.db.applyFilters then
			local filtersList = ChatFrame_GetMessageEventFilters("CHAT_MSG_WHISPER")
			if filtersList then
				local _, func
				for _, func in ipairs(filtersList) do
					if type(func) == "function" and func(DEFAULT_CHAT_FRAME, "CHAT_MSG_WHISPER", ...) then
						return
					end
				end
			end
		end

		flag = select(2, GetPlayerInfoByGUID(guid or ""))
	end

	self:ProcessChatMsg(name, flag, text)
end

function addon:CHAT_MSG_WHISPER_INFORM(...)
	local text, name, _, _, _, flag, _, _, _, _, _, guid = ...
	if flag == "GM" or flag == "DEV" or (GMChatFrame_IsGM and GMChatFrame_IsGM(name)) then
		flag = "GM"
	else
		flag = select(2, GetPlayerInfoByGUID(guid or ""))
	end

	self:ProcessChatMsg(name, flag, text, 1)
end

function addon:CHAT_MSG_BN_WHISPER(...)
	local text, name, _, _, _, _, _, _, _, _, _, _, bnid = ...
	self:ProcessChatMsg(name, "BN", text, nil, bnid)
end

function addon:CHAT_MSG_BN_WHISPER_INFORM(...)
	local text, name, _, _, _, _, _, _, _, _, _, _, bnid = ...
	self:ProcessChatMsg(name, "BN", text, 1, bnid)
end

------------------------------------------------------
-- Depreciated functions
------------------------------------------------------
-- It is not recommended to use WhisperPop's IGNORED_MESSAGES array to filter messages anymore,
-- I've added codes in v4 to support third-party filters so it's better let other professional addons do
-- the message-filtering job and we simply take their filter results.
------------------------------------------------------

addon.IGNORED_MESSAGES = {} -- Do not use anymore

-- Add additional ignoring patterns into addon.IGNORED_MESSAGES to filter messages in particular, not recommended since v4.0
function addon:AddIgnore(pattern)
	if type(pattern) ~= "string" then
		return
	end

	local index, str
	for index, str in ipairs(self.IGNORED_MESSAGES) do
		if str == pattern then
			return
		end
	end

	tinsert(self.IGNORED_MESSAGES, pattern)
end

function addon:IsIgnoredMessage(text)
	if type(text) ~= "string" then
		return
	end

	local pattern
	for _, pattern in ipairs(self.IGNORED_MESSAGES) do
		if strfind(text, pattern) then
			return pattern
		end
	end
end