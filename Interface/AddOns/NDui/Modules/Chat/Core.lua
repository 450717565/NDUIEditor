local _, ns = ...
local B, C, L, DB = unpack(ns)
local CHAT = B:RegisterModule("Chat")
local cr, cg, cb = DB.cr, DB.cg, DB.cb

local _G = _G
local tostring, pairs, strsub, strlower = tostring, pairs, string.sub, string.lower
local IsInGroup, IsInRaid, IsPartyLFG, IsInGuild, IsShiftKeyDown, IsControlKeyDown = IsInGroup, IsInRaid, IsPartyLFG, IsInGuild, IsShiftKeyDown, IsControlKeyDown
local ChatEdit_UpdateHeader, GetCVar, SetCVar, Ambiguate, GetTime = ChatEdit_UpdateHeader, GetCVar, SetCVar, Ambiguate, GetTime
local GetNumGuildMembers, GetGuildRosterInfo, IsGuildMember, UnitIsGroupLeader, UnitIsGroupAssistant = GetNumGuildMembers, GetGuildRosterInfo, IsGuildMember, UnitIsGroupLeader, UnitIsGroupAssistant
local CanCooperateWithGameAccount, BNInviteFriend, BNFeaturesEnabledAndConnected, PlaySound = CanCooperateWithGameAccount, BNInviteFriend, BNFeaturesEnabledAndConnected, PlaySound
local C_BattleNet_GetAccountInfoByID = C_BattleNet.GetAccountInfoByID
local InviteToGroup = C_PartyInfo.InviteUnit
local GeneralDockManager = GeneralDockManager
local messageSoundID = SOUNDKIT.TELL_MESSAGE

local maxLines = 1024
local fontOutline

function CHAT:TabSetAlpha(alpha)
	if self.glow:IsShown() and alpha ~= 1 then
		self:SetAlpha(1)
	end
end

local isScaling = false
function CHAT:UpdateChatSize()
	if not C.db["Chat"]["Lock"] then return end
	if isScaling then return end
	isScaling = true

	if ChatFrame1:IsMovable() then
		ChatFrame1:SetUserPlaced(true)
	end
	if ChatFrame1.FontStringContainer then
		ChatFrame1.FontStringContainer:SetOutside(ChatFrame1)
	end

	ChatFrame1:SetWidth(C.db["Chat"]["ChatWidth"])
	ChatFrame1:SetHeight(C.db["Chat"]["ChatHeight"])
	B.UpdatePoint(ChatFrame1, "BOTTOMLEFT", UIParent, "BOTTOMLEFT", 0, 30)

	isScaling = false
end

local function BlackBackground(self)
	local frame = B.CreateBG(self.Background)
	frame:SetShown(C.db["Chat"]["ChatBGType"] == 2)

	return frame
end

local function GradientBackground(self)
	local frame = CreateFrame("Frame", nil, self)
	frame:SetOutside(self.Background)
	frame:SetFrameLevel(0)
	frame:SetShown(C.db["Chat"]["ChatBGType"] == 3)

	local tex = B.CreateGA(frame, "H", 0, 0, 0, C.alpha, 0)
	tex:SetAllPoints()
	local line = B.CreateGA(frame, "H", cr, cg, cb, C.alpha, 0, nil, C.mult*2)
	line:SetPoint("BOTTOMLEFT", frame, "TOPLEFT")
	line:SetPoint("BOTTOMRIGHT", frame, "TOPRIGHT")

	return frame
end

function CHAT:SkinChat()
	if not self or self.styled then return end

	local fontSize = select(2, self:GetFont())
	self:SetMaxResize(DB.ScreenWidth, DB.ScreenHeight)
	self:SetMinResize(100, 50)
	self:SetFont(DB.Font[1], fontSize, fontOutline)
	self:SetClampRectInsets(0, 0, 0, 0)
	self:SetClampedToScreen(false)
	if self:GetMaxLines() < maxLines then
		self:SetMaxLines(maxLines)
	end

	B.StripTextures(self)
	self.__background = BlackBackground(self)
	self.__gradient = GradientBackground(self)

	local eb = B.GetObject(self, "EditBox")
	eb:SetAltArrowKeyMode(false)
	eb:ClearAllPoints()
	eb:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 4, 26)
	eb:SetPoint("TOPRIGHT", self, "TOPRIGHT", -17, 50)
	B.StripTextures(eb, 2)
	B.CreateBG(eb)

	local lang = B.GetObject(self, "EditBoxLanguage")
	lang:GetRegions():SetAlpha(0)
	lang:SetPoint("TOPLEFT", eb, "TOPRIGHT", C.margin, 0)
	lang:SetPoint("BOTTOMRIGHT", eb, "BOTTOMRIGHT", 24+C.margin, 0)
	B.CreateBG(lang)

	local tab = B.GetObject(self, "Tab")
	tab:SetAlpha(1)
	tab.Text:SetFont(DB.Font[1], DB.Font[2]+2, fontOutline)
	B.StripTextures(tab, 7)
	hooksecurefunc(tab, "SetAlpha", CHAT.TabSetAlpha)

	B.HideObject(self.buttonFrame)
	B.HideObject(self.ScrollBar)
	B.HideObject(self.ScrollToBottomButton)
	CHAT:ToggleChatFrameTextures(self)

	self.oldAlpha = self.oldAlpha or 0 -- fix blizz error

	self.styled = true
end

function CHAT:ToggleChatFrameTextures(frame)
	if C.db["Chat"]["ChatBGType"] == 1 then
		frame:EnableDrawLayer("BORDER")
		frame:EnableDrawLayer("BACKGROUND")
	else
		frame:DisableDrawLayer("BORDER")
		frame:DisableDrawLayer("BACKGROUND")
	end
end

function CHAT:ToggleChatBackground()
	for _, chatFrameName in pairs(CHAT_FRAMES) do
		local frame = _G[chatFrameName]
		if frame.__background then
			frame.__background:SetShown(C.db["Chat"]["ChatBGType"] == 2)
		end
		if frame.__gradient then
			frame.__gradient:SetShown(C.db["Chat"]["ChatBGType"] == 3)
		end
		CHAT:ToggleChatFrameTextures(frame)
	end
end

-- Swith channels by Tab
local cycles = {
	{ chatType = "SAY", use = function() return 1 end },
	{ chatType = "PARTY", use = function() return IsInGroup() end },
	{ chatType = "RAID", use = function() return IsInRaid() end },
	{ chatType = "INSTANCE_CHAT", use = function() return IsPartyLFG() end },
	{ chatType = "GUILD", use = function() return IsInGuild() end },
	{ chatType = "CHANNEL", use = function(_, editbox)
		if CHAT.InWorldChannel and CHAT.WorldChannelID then
			editbox:SetAttribute("channelTarget", CHAT.WorldChannelID)
			return true
		else
			return false
		end
	end },
	{ chatType = "SAY", use = function() return 1 end },
}

function CHAT:UpdateTabChannelSwitch()
	if strsub(tostring(self:GetText()), 1, 1) == "/" then return end
	local currChatType = self:GetAttribute("chatType")
	for i, curr in pairs(cycles) do
		if curr.chatType == currChatType then
			local h, r, step = i+1, #cycles, 1
			if IsShiftKeyDown() then h, r, step = i-1, 1, -1 end
			for j = h, r, step do
				if cycles[j]:use(self, currChatType) then
					self:SetAttribute("chatType", cycles[j].chatType)
					ChatEdit_UpdateHeader(self)
					return
				end
			end
		end
	end
end
hooksecurefunc("ChatEdit_CustomTabPressed", CHAT.UpdateTabChannelSwitch)

-- Quick Scroll
local chatScrollInfo = {
	text = L["ChatScrollHelp"],
	buttonStyle = HelpTip.ButtonStyle.GotIt,
	targetPoint = HelpTip.Point.RightEdgeCenter,
	onAcknowledgeCallback = B.HelpInfoAcknowledge,
	callbackArg = "ChatScroll",
}

function CHAT:QuickMouseScroll(dir)
	if not NDuiADB["Help"]["ChatScroll"] then
		HelpTip:Show(ChatFrame1, chatScrollInfo)
	end

	if dir > 0 then
		if IsShiftKeyDown() then
			self:ScrollToTop()
		elseif IsControlKeyDown() then
			self:ScrollUp()
			self:ScrollUp()
		end
	else
		if IsShiftKeyDown() then
			self:ScrollToBottom()
		elseif IsControlKeyDown() then
			self:ScrollDown()
			self:ScrollDown()
		end
	end
end
hooksecurefunc("FloatingChatFrame_OnMouseScroll", CHAT.QuickMouseScroll)

-- Autoinvite by whisper
local whisperList = {}
function CHAT:UpdateWhisperList()
	B.SplitList(whisperList, C.db["Chat"]["Keyword"], true)
end

function CHAT:IsUnitInGuild(unitName)
	if not unitName then return end
	for i = 1, GetNumGuildMembers() do
		local name = GetGuildRosterInfo(i)
		if name and Ambiguate(name, "none") == Ambiguate(unitName, "none") then
			return true
		end
	end

	return false
end

function CHAT.OnChatWhisper(event, ...)
	local msg, author, _, _, _, _, _, _, _, _, _, guid, presenceID = ...
	for word in pairs(whisperList) do
		if (not IsInGroup() or UnitIsGroupLeader("player") or UnitIsGroupAssistant("player")) and strlower(msg) == strlower(word) then
			if event == "CHAT_MSG_BN_WHISPER" then
				local accountInfo = C_BattleNet_GetAccountInfoByID(presenceID)
				if accountInfo then
					local gameAccountInfo = accountInfo.gameAccountInfo
					local gameID = gameAccountInfo.gameAccountID
					if gameID then
						local charName = gameAccountInfo.characterName
						local realmName = gameAccountInfo.realmName
						if CanCooperateWithGameAccount(accountInfo) and (not C.db["Chat"]["GuildInvite"] or CHAT:IsUnitInGuild(charName.."-"..realmName)) then
							BNInviteFriend(gameID)
						end
					end
				end
			else
				if not C.db["Chat"]["GuildInvite"] or IsGuildMember(guid) then
					InviteToGroup(author)
				end
			end
		end
	end
end

function CHAT:WhisperInvite()
	if not C.db["Chat"]["Invite"] then return end
	CHAT:UpdateWhisperList()
	B:RegisterEvent("CHAT_MSG_WHISPER", CHAT.OnChatWhisper)
	B:RegisterEvent("CHAT_MSG_BN_WHISPER", CHAT.OnChatWhisper)
end

-- Sticky whisper
function CHAT:ChatWhisperSticky()
	if C.db["Chat"]["Sticky"] then
		ChatTypeInfo["WHISPER"].sticky = 1
		ChatTypeInfo["BN_WHISPER"].sticky = 1
	else
		ChatTypeInfo["WHISPER"].sticky = 0
		ChatTypeInfo["BN_WHISPER"].sticky = 0
	end
end

-- Tab colors
function CHAT:UpdateTabColors(selected)
	if selected then
		B.ReskinText(self.Text, 1, .8, 0)
		self.whisperIndex = 0
	else
		B.ReskinText(self.Text, .5, .5, .5)
	end

	if self.whisperIndex == 1 then
		self.glow:SetVertexColor(1, .5, 1)
	elseif self.whisperIndex == 2 then
		self.glow:SetVertexColor(0, 1, .96)
	else
		self.glow:SetVertexColor(1, .8, 0)
	end
end

function CHAT:UpdateTabEventColors(event)
	local tab = B.GetObject(self, "Tab")
	local selected = GeneralDockManager.selected:GetID() == tab:GetID()
	if event == "CHAT_MSG_WHISPER" then
		tab.whisperIndex = 1
		CHAT.UpdateTabColors(tab, selected)
	elseif event == "CHAT_MSG_BN_WHISPER" then
		tab.whisperIndex = 2
		CHAT.UpdateTabColors(tab, selected)
	end
end

local whisperEvents = {
	["CHAT_MSG_WHISPER"] = true,
	["CHAT_MSG_BN_WHISPER"] = true,
}
function CHAT:PlayWhisperSound(event)
	if whisperEvents[event] then
		if CHAT.MuteThisTime then
			CHAT.MuteThisTime = nil
			return
		end

		local currentTime = GetTime()
		if not self.soundTimer or currentTime > self.soundTimer then
			PlaySound(messageSoundID, "master")
		end
		self.soundTimer = currentTime + 5
	end
end

local function FixLanguageFilterSideEffects()
	HelpFrame:HookScript("OnShow", function()
		UIErrorsFrame:AddMessage(DB.InfoColor..L["LanguageFilterTip"])
	end)

	local OLD_GetFriendGameAccountInfo = C_BattleNet.GetFriendGameAccountInfo
	function C_BattleNet.GetFriendGameAccountInfo(...)
		local gameAccountInfo = OLD_GetFriendGameAccountInfo(...)
		if gameAccountInfo then
			gameAccountInfo.isInCurrentRegion = true
		end
		return gameAccountInfo
	end

	local OLD_GetFriendAccountInfo = C_BattleNet.GetFriendAccountInfo
	function C_BattleNet.GetFriendAccountInfo(...)
		local accountInfo = OLD_GetFriendAccountInfo(...)
		if accountInfo and accountInfo.gameAccountInfo then
			accountInfo.gameAccountInfo.isInCurrentRegion = true
		end
		return accountInfo
	end
end

function CHAT:OnLogin()
	fontOutline = C.db["Skins"]["FontOutline"] and "OUTLINE" or ""

	for i = 1, NUM_CHAT_WINDOWS do
		local chatframe = _G["ChatFrame"..i]
		CHAT.SkinChat(chatframe)
		ChatFrame_RemoveMessageGroup(chatframe, "CHANNEL")
	end

	hooksecurefunc("FCF_OpenTemporaryWindow", function()
		for _, chatFrameName in pairs(CHAT_FRAMES) do
			local frame = _G[chatFrameName]
			if frame.isTemporary then
				CHAT.SkinChat(frame)
			end
		end
	end)

	hooksecurefunc("FCFTab_UpdateColors", CHAT.UpdateTabColors)
	hooksecurefunc("FloatingChatFrame_OnEvent", CHAT.UpdateTabEventColors)
	hooksecurefunc("ChatFrame_MessageEventHandler", CHAT.PlayWhisperSound)

	-- Font size
	for i = 1, 15 do
		CHAT_FONT_HEIGHTS[i] = i + 9
	end

	-- Default
	if CHAT_OPTIONS then CHAT_OPTIONS.HIDE_FRAME_ALERTS = true end -- only flash whisper
	SetCVar("chatStyle", "classic")
	SetCVar("whisperMode", "inline") -- blizz reset this on NPE
	B.HideOption(InterfaceOptionsSocialPanelChatStyle)
	CombatLogQuickButtonFrame_CustomTexture:SetTexture("")

	-- Add Elements
	CHAT:ChatWhisperSticky()
	CHAT:ChatFilter()
	CHAT:ChannelRename()
	CHAT:Chatbar()
	CHAT:ChatCopy()
	CHAT:UrlCopy()
	CHAT:WhisperInvite()

	-- Lock chatframe
	if C.db["Chat"]["Lock"] then
		CHAT:UpdateChatSize()
		B:RegisterEvent("UI_SCALE_CHANGED", CHAT.UpdateChatSize)
		hooksecurefunc("FCF_SavePositionAndDimensions", CHAT.UpdateChatSize)
		FCF_SavePositionAndDimensions(ChatFrame1)
	end

	-- ProfanityFilter
	if not BNFeaturesEnabledAndConnected() then return end
	if C.db["Chat"]["Freedom"] then
		if GetCVar("portal") == "CN" then
			ConsoleExec("portal TW")
			FixLanguageFilterSideEffects()
		end
		SetCVar("profanityFilter", 0)
	else
		SetCVar("profanityFilter", 1)
	end
end