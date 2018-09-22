local _, ns = ...
local B, C, L, DB = unpack(ns)
local module = B:GetModule("Chat")

-- Account-wide settings
local function accountSettings(event)
	if not NDuiADB["ChatFilter"] then NDuiADB["ChatFilter"] = "" end
	if not NDuiADB["ChatAt"] then NDuiADB["ChatAt"] = "" end
	if not NDuiADB["Timestamp"] then NDuiADB["Timestamp"] = false end

	if event == "PLAYER_LOGIN" then
		NDuiDB["Chat"]["FilterList"] = NDuiADB["ChatFilter"]
		NDuiDB["Chat"]["AtList"] = NDuiADB["ChatAt"]
		NDuiDB["Chat"]["Timestamp"] = NDuiADB["Timestamp"]
	elseif event == "PLAYER_LOGOUT" then
		NDuiADB["ChatFilter"] = NDuiDB["Chat"]["FilterList"]
		NDuiADB["ChatAt"] = NDuiDB["Chat"]["AtList"]
		NDuiADB["Timestamp"] = NDuiDB["Chat"]["Timestamp"]
	end

	-- Timestamp
	local infoStamp = DB.InfoColor.."<%H:%M:%S>|r "
	if NDuiDB["Chat"]["Timestamp"] then
		SetCVar("showTimestamps", infoStamp)
	else
		if GetCVar("showTimestamps") == infoStamp then
			SetCVar("showTimestamps", "none")
		end
	end
end
B:RegisterEvent("PLAYER_LOGIN", accountSettings)
B:RegisterEvent("PLAYER_LOGOUT", accountSettings)

--[[
	修改自NoGoldSeller，强迫症患者只能接受这个低占用的。
]]

-- Filter Chat symbols
local msgSymbols = {"`", "～", "＠", "＃", "^", "＊", "！", "？", "。", "|", " ", "—", "——", "￥", "’", "‘", "“", "”", "【", "】", "『", "』", "《", "》", "〈", "〉", "（", "）", "〔", "〕", "、", "，", "：", ",", "_", "/", "~", "%-", "%."}

local FilterList = {}
local function genFilterList()
	FilterList = {string.split(" ", NDuiDB["Chat"]["FilterList"] or "")}
end
B.genFilterList = genFilterList

B.FriendsList = {}
local function updateFriends()
	wipe(B.FriendsList)

	for i = 1, GetNumFriends() do
		local name = GetFriendInfo(i)
		if name then
			B.FriendsList[Ambiguate(name, "none")] = true
		end
	end

	for i = 1, select(2, BNGetNumFriends()) do
		for j = 1, BNGetNumFriendGameAccounts(i) do
			local _, characterName, client, realmName = BNGetFriendGameAccountInfo(i, j)
			if client == BNET_CLIENT_WOW then
				B.FriendsList[Ambiguate(characterName.."-"..realmName, "none")] = true
			end
		end
	end
end
B:RegisterEvent("FRIENDLIST_UPDATE", updateFriends)
B:RegisterEvent("BN_FRIEND_INFO_CHANGED", updateFriends)

local function genChatFilter(_, event, msg, author, _, _, _, flag)
	if not NDuiDB["Chat"]["EnableFilter"] then return end

	local name = Ambiguate(author, "none")
	if UnitIsUnit(name, "player") or (event == "CHAT_MSG_WHISPER" and flag == "GM") or flag == "DEV" then
		return
	elseif B.UnitInGuild(author) or UnitInRaid(name) or UnitInParty(name) or B.FriendsList[name] then
		return
	end

	for _, symbol in ipairs(msgSymbols) do
		msg = gsub(msg, symbol, "")
	end

	local match = 0
	for _, keyword in pairs(FilterList) do
		if keyword ~= "" then
			local _, count = gsub(msg, keyword, "")
			if count > 0 then
				match = match + 1
			end
		end
	end

	if match >= NDuiDB["Chat"]["Matches"] then
		return true
	end
end

local addonBlockList = {
	"任务进度提示%s?[:：]", "%[接受任务%]", "%(任务完成%)", "<大脚组队提示>", "<大脚团队提示>", "【爱不易】", "EUI:", "EUI_RaidCD", "打断:.+|Hspell", "PS 死亡: .+>", "%*%*.+%*%*",
	"<iLvl>", ("%-"):rep(30), "<小队物品等级:.+>", "<LFG>", "wowcdk", "进度:", "属性通报", "wowcn%.vip"
}

local function genAddonBlock(_, _, msg, author)
	if not NDuiDB["Chat"]["BlockAddonAlert"] then return end

	local name = Ambiguate(author, "none")
	if UnitIsUnit(name, "player") then return end

	for _, word in ipairs(addonBlockList) do
		if msg:find(word) then
			return true
		end
	end
end


--[[
	公会频道有人@时提示你
]]
local chatAtList, at = {}, {}
local function genChatAtList()
	chatAtList = {string.split(" ", NDuiDB["Chat"]["AtList"] or "")}
	local name = UnitName("player")
	tinsert(chatAtList, name)
end
B.genChatAtList = genChatAtList

local function chatAtMe(_, _, ...)
	local msg, author, _, _, _, _, _, _, _, _, _, guid = ...
	for _, word in pairs(chatAtList) do
		if word ~= "" then
			if msg:lower():match("@"..word:lower()) then
				at.checker = true
				at.author = author
				at.class = select(2, GetPlayerInfoByGUID(guid))
				BNToastFrame:AddToast(BN_TOAST_TYPE_NEW_INVITE)
			end
		end
	end
end

hooksecurefunc(BNToastFrame, "ShowToast", function(self)
	if at.checker == true then
		self:SetHeight(50)
		self.IconTexture:SetTexCoord(.75, 1, 0, .5)
		self.TopLine:Hide()
		self.MiddleLine:Hide()
		self.BottomLine:Hide()
		self.DoubleLine:Show()

		local hexColor = B.HexRGB(B.ClassColor(at.class))
		self.DoubleLine:SetText(format("%s "..DB.InfoColor.."@"..YOU.."! ("..GUILD..")", hexColor..Ambiguate(at.author, "short")))
		at.checker = false
	end
end)

--[[
	过滤WQT的邀请
	Credit: WorldQuestTrackerBlocker, Jordy141
]]
local WQTUsers = {}
local inviteString = _G.ERR_INVITED_TO_GROUP_SS:gsub(".+|h", "")

local function blockInviteString(_, _, msg)
	if msg:find(inviteString) then
		local name = msg:match("%[(.+)%]")
		if WQTUsers[name] then
			return true
		end
	end
end

local function blockWhisperString(_, _, msg, author)
	local name = Ambiguate(author, "none")
	if msg:find("%[World Quest Tracker%]") or msg:find("一起做世界任务吧：") or msg:find("一起来做世界任务<") then
		if not WQTUsers[name] then
			WQTUsers[name] = true
		end
		return true
	end
end

local function hideInvitePopup(_, name)
	if WQTUsers[name] then
		StaticPopup_Hide("PARTY_INVITE")
	end
end

-- 过滤海岛探险中艾泽里特的获取信息
local azerite = ISLANDS_QUEUE_WEEKLY_QUEST_PROGRESS:gsub("%%d/%%d ", "")
local function filterAzeriteGain(_, _, msg)
	if msg:find(azerite) then
		return true
	end
end

local function isPlayerOnIslands()
	local _, instanceType, _, _, maxPlayers = GetInstanceInfo()
	if instanceType == "scenario" and maxPlayers == 3 then
		ChatFrame_AddMessageEventFilter("CHAT_MSG_SYSTEM", filterAzeriteGain)
	else
		ChatFrame_RemoveMessageEventFilter("CHAT_MSG_SYSTEM", filterAzeriteGain)
	end
end

local chatEvents = {
	"CHAT_MSG_BATTLEGROUND",
	"CHAT_MSG_BATTLEGROUND_LEADER",
	"CHAT_MSG_BN_CONVERSATION",
	"CHAT_MSG_BN_WHISPER",
	"CHAT_MSG_BN_WHISPER_INFORM",
	"CHAT_MSG_CHANNEL",
	"CHAT_MSG_EMOTE",
	"CHAT_MSG_INSTANCE_CHAT",
	"CHAT_MSG_INSTANCE_CHAT_LEADER",
	"CHAT_MSG_LOOT",
	"CHAT_MSG_OFFICER",
	"CHAT_MSG_PARTY",
	"CHAT_MSG_PARTY_LEADER",
	"CHAT_MSG_RAID",
	"CHAT_MSG_RAID_LEADER",
	"CHAT_MSG_RAID_WARNING",
	"CHAT_MSG_SAY",
	"CHAT_MSG_SYSTEM",
	"CHAT_MSG_WHISPER",
	"CHAT_MSG_WHISPER_INFORM",
	"CHAT_MSG_YELL",
}

function module:ChatFilter()
	genFilterList()
	genChatAtList()

	for _, v in pairs(chatEvents) do
		ChatFrame_AddMessageEventFilter(v, genChatFilter)
		ChatFrame_AddMessageEventFilter(v, genAddonBlock)
	end

	ChatFrame_AddMessageEventFilter("CHAT_MSG_GUILD", chatAtMe)

	ChatFrame_AddMessageEventFilter("CHAT_MSG_SYSTEM", blockInviteString)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", blockWhisperString)
	B:RegisterEvent("PARTY_INVITE_REQUEST", hideInvitePopup)

	B:RegisterEvent("PLAYER_ENTERING_WORLD", isPlayerOnIslands)
end