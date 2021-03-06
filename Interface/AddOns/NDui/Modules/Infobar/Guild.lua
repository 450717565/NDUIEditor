local _, ns = ...
local B, C, L, DB = unpack(ns)
if not C.Infobar.Guild then return end

local IB = B:GetModule("Infobar")
local info = IB:RegisterInfobar("Guild", C.Infobar.GuildPos)

info.guildTable = {}
local cr, cg, cb = DB.cr, DB.cg, DB.cb
local infoFrame, gName, gOnline, gApps, gRank, prevTime

local wipe, sort, format, select = table.wipe, table.sort, format, select
local SELECTED_DOCK_FRAME = SELECTED_DOCK_FRAME
local LEVEL_ABBR, CLASS_ABBR, NAME, ZONE, RANK, GUILDINFOTAB_APPLICANTS, REMOTE_CHAT = LEVEL_ABBR, CLASS_ABBR, NAME, ZONE, RANK, GUILDINFOTAB_APPLICANTS, REMOTE_CHAT
local IsAltKeyDown, IsShiftKeyDown, C_Timer_After, GetTime, Ambiguate, MouseIsOver = IsAltKeyDown, IsShiftKeyDown, C_Timer.After, GetTime, Ambiguate, MouseIsOver
local MailFrame, MailFrameTab_OnClick, SendMailNameEditBox = MailFrame, MailFrameTab_OnClick, SendMailNameEditBox
local ChatEdit_ChooseBoxForSend, ChatEdit_ActivateChat, ChatFrame_OpenChat, ChatFrame_GetMobileEmbeddedTexture = ChatEdit_ChooseBoxForSend, ChatEdit_ActivateChat, ChatFrame_OpenChat, ChatFrame_GetMobileEmbeddedTexture
local GetNumGuildMembers, GetGuildInfo, GetNumGuildApplicants, GetGuildRosterInfo, IsInGuild = GetNumGuildMembers, GetGuildInfo, GetNumGuildApplicants, GetGuildRosterInfo, IsInGuild
local GetQuestDifficultyColor, GetRealZoneText, UnitInRaid, UnitInParty = GetQuestDifficultyColor, GetRealZoneText, UnitInRaid, UnitInParty
local HybridScrollFrame_GetOffset, HybridScrollFrame_Update = HybridScrollFrame_GetOffset, HybridScrollFrame_Update
local C_GuildInfo_GuildRoster = C_GuildInfo.GuildRoster
local InviteToGroup = C_PartyInfo.InviteUnit

local function rosterButtonOnClick(self, btn)
	local name = info.guildTable[self.index][3]
	if btn == "LeftButton" then
		if IsAltKeyDown() then
			InviteToGroup(name)
		elseif IsShiftKeyDown() then
			if MailFrame:IsShown() then
				MailFrameTab_OnClick(nil, 2)
				SendMailNameEditBox:SetText(name)
				SendMailNameEditBox:HighlightText()
			else
				local editBox = ChatEdit_ChooseBoxForSend()
				local hasText = (editBox:GetText() ~= "")
				ChatEdit_ActivateChat(editBox)
				editBox:Insert(name)
				if not hasText then editBox:HighlightText() end
			end
		end
	else
		ChatFrame_SendTell(name, SELECTED_DOCK_FRAME)
	end
end

function info:GuildPanel_CreateButton(parent, index)
	local button = CreateFrame("Button", nil, parent)
	button:SetSize(305, 20)
	button:SetPoint("TOPLEFT", 0, - (index-1) *20)
	button.HL = button:CreateTexture(nil, "HIGHLIGHT")
	button.HL:SetAllPoints()
	button.HL:SetColorTexture(cr, cg, cb, .25)

	button.level = B.CreateFS(button, 13, "Level")
	button.level:ClearAllPoints()
	button.level:SetPoint("LEFT", button, 4, 0)

	button.class = button:CreateTexture(nil, "ARTWORK")
	button.class:SetPoint("LEFT", button, 39, 0)
	button.class:SetSize(16, 16)
	button.class:SetTexture(DB.classTex)
	B.CreateBDFrame(button.class, 0, -C.mult)

	button.name = B.CreateFS(button, 13, "Name")
	button.name:ClearAllPoints()
	button.name:SetPoint("LEFT", button.class, "RIGHT", 12, 0)
	button.name:SetPoint("RIGHT", button, "LEFT", 185, 0)
	button.name:SetJustifyH("LEFT")

	button.zone = B.CreateFS(button, 13, "Zone")
	button.zone:ClearAllPoints()
	button.zone:SetPoint("RIGHT", button, "RIGHT", -5, 0)
	button.zone:SetPoint("LEFT", button, "RIGHT", -120, 0)
	button.zone:SetJustifyH("RIGHT")

	button:RegisterForClicks("AnyUp")
	button:SetScript("OnClick", rosterButtonOnClick)

	return button
end

function info:GuildPanel_UpdateButton(button)
	local index = button.index
	local level, class, name, zone, status = unpack(info.guildTable[index])

	local levelcolor = B.HexRGB(GetQuestDifficultyColor(level))
	button.level:SetText(levelcolor..level)

	local c1, c2, c3, c4 = B.GetClassTexCoord(class)
	button.class:SetTexCoord(c1, c2, c3, c4)

	local namecolor = B.HexRGB(B.GetClassColor(class))
	button.name:SetText(namecolor..name..status)

	local zonecolor = DB.GreyColor
	if UnitInRaid(name) or UnitInParty(name) then
		zonecolor = "|cffFFFF00"
	elseif GetRealZoneText() == zone then
		zonecolor = "|cff00FF00"
	end
	button.zone:SetText(zonecolor..zone)
end

function info:GuildPanel_Update()
	local scrollFrame = NDuiGuildInfobarScrollFrame
	local usedHeight = 0
	local buttons = scrollFrame.buttons
	local height = scrollFrame.buttonHeight
	local numMemberButtons = infoFrame.numMembers
	local offset = HybridScrollFrame_GetOffset(scrollFrame)

	for i = 1, #buttons do
		local button = buttons[i]
		local index = offset + i
		if index <= numMemberButtons then
			button.index = index
			info:GuildPanel_UpdateButton(button)
			usedHeight = usedHeight + height
			button:Show()
		else
			button.index = nil
			button:Hide()
		end
	end

	HybridScrollFrame_Update(scrollFrame, numMemberButtons*height, usedHeight)
end

function info:GuildPanel_OnMouseWheel(delta)
	local scrollBar = self.scrollBar
	local step = delta*self.buttonHeight
	if IsShiftKeyDown() then
		step = step*15
	end
	scrollBar:SetValue(scrollBar:GetValue() - step)
	info:GuildPanel_Update()
end

local function sortRosters(a, b)
	if a and b then
		if NDuiADB["GuildSortOrder"] then
			return a[NDuiADB["GuildSortBy"]] < b[NDuiADB["GuildSortBy"]]
		else
			return a[NDuiADB["GuildSortBy"]] > b[NDuiADB["GuildSortBy"]]
		end
	end
end

function info:GuildPanel_SortUpdate()
	sort(info.guildTable, sortRosters)
	info:GuildPanel_Update()
end

local function sortHeaderOnClick(self)
	NDuiADB["GuildSortBy"] = self.index
	NDuiADB["GuildSortOrder"] = not NDuiADB["GuildSortOrder"]
	info:GuildPanel_SortUpdate()
end

local function isPanelCanHide(self, elapsed)
	self.timer = (self.timer or 0) + elapsed
	if self.timer > .1 then
		if not infoFrame:IsMouseOver() then
			self:Hide()
			self:SetScript("OnUpdate", nil)
		end

		self.timer = 0
	end
end

function info:GuildPanel_Init()
	if infoFrame then infoFrame:Show() return end

	infoFrame = CreateFrame("Frame", "NDuiGuildInfobar", info)
	infoFrame:SetSize(340, 495)
	infoFrame:SetPoint("TOPLEFT", UIParent, 15, -35)
	infoFrame:SetClampedToScreen(true)
	infoFrame:SetFrameStrata("TOOLTIP")
	B.CreateBG(infoFrame)

	infoFrame:SetScript("OnLeave", function(self)
		self:SetScript("OnUpdate", isPanelCanHide)
	end)

	gName = B.CreateFS(infoFrame, 16, "Guild", true, "TOPLEFT", 15, -10)
	gOnline = B.CreateFS(infoFrame, 13, "Online", false, "TOPLEFT", 15, -35)
	gApps = B.CreateFS(infoFrame, 13, "Applications", false, "TOPRIGHT", -15, -35)
	gRank = B.CreateFS(infoFrame, 13, "Rank", false, "TOPLEFT", 15, -51)

	local bu = {}
	local width = {30, 35, 126, 126}
	for i = 1, 4 do
		bu[i] = CreateFrame("Button", nil, infoFrame)
		bu[i]:SetSize(width[i], 22)
		bu[i]:SetFrameLevel(infoFrame:GetFrameLevel() + 3)
		if i == 1 then
			bu[i]:SetPoint("TOPLEFT", 12, -75)
		else
			bu[i]:SetPoint("LEFT", bu[i-1], "RIGHT", -2, 0)
		end
		bu[i].HL = bu[i]:CreateTexture(nil, "HIGHLIGHT")
		bu[i].HL:SetAllPoints(bu[i])
		bu[i].HL:SetColorTexture(cr, cg, cb, .2)
		bu[i].index = i
		bu[i]:SetScript("OnClick", sortHeaderOnClick)
	end
	B.CreateFS(bu[1], 13, LEVEL_ABBR, false, "LEFT", 3, 0)
	B.CreateFS(bu[2], 13, CLASS_ABBR)
	B.CreateFS(bu[3], 13, NAME, false, "LEFT", 5, 0)
	B.CreateFS(bu[4], 13, ZONE, false, "RIGHT", -10, 0)

	B.CreateFS(infoFrame, 13, DB.LineString, false, "BOTTOMRIGHT", -12, 58)
	local whspInfo = DB.InfoColor..DB.RightButton..WHISPER
	B.CreateFS(infoFrame, 13, whspInfo, false, "BOTTOMRIGHT", -15, 42)
	local invtInfo = DB.InfoColor.."ALT +"..DB.LeftButton..INVITE
	B.CreateFS(infoFrame, 13, invtInfo, false, "BOTTOMRIGHT", -15, 26)
	local copyInfo = DB.InfoColor.."SHIFT +"..DB.LeftButton..COPY_NAME
	B.CreateFS(infoFrame, 13, copyInfo, false, "BOTTOMRIGHT", -15, 10)

	local scrollFrame = CreateFrame("ScrollFrame", "NDuiGuildInfobarScrollFrame", infoFrame, "HybridScrollFrameTemplate")
	scrollFrame:SetSize(305, 320)
	scrollFrame:SetPoint("TOPLEFT", 10, -100)
	infoFrame.scrollFrame = scrollFrame

	local scrollBar = CreateFrame("Slider", "$parentScrollBar", scrollFrame, "HybridScrollBarTemplate")
	scrollBar.doNotHide = true
	B.ReskinScroll(scrollBar)
	scrollFrame.scrollBar = scrollBar

	local scrollChild = scrollFrame.scrollChild
	local numButtons = 16 + 1
	local buttonHeight = 22
	local buttons = {}
	for i = 1, numButtons do
		buttons[i] = info:GuildPanel_CreateButton(scrollChild, i)
	end

	scrollFrame.buttons = buttons
	scrollFrame.buttonHeight = buttonHeight
	scrollFrame.update = info.GuildPanel_Update
	scrollFrame:SetScript("OnMouseWheel", info.GuildPanel_OnMouseWheel)
	scrollChild:SetSize(scrollFrame:GetWidth(), numButtons * buttonHeight)
	scrollFrame:SetVerticalScroll(0)
	scrollFrame:UpdateScrollChildRect()
	scrollBar:SetMinMaxValues(0, numButtons * buttonHeight)
	scrollBar:SetValue(0)
end

C_Timer_After(5, function()
	if IsInGuild() then C_GuildInfo_GuildRoster() end
end)

function info:GuildPanel_Refresh()
	local thisTime = GetTime()
	if not prevTime or (thisTime-prevTime > 5) then
		C_GuildInfo_GuildRoster()
		prevTime = thisTime
	end

	wipe(info.guildTable)
	local count = 0
	local total, _, online = GetNumGuildMembers()
	local guildName, guildRank = GetGuildInfo("player")

	gName:SetFormattedText("|cff0099FF<%s>", guildName or "")
	gOnline:SetFormattedText(DB.InfoColor.."%s：%s / %s", GUILD_ONLINE_LABEL, online, total)
	gApps:SetFormattedText(DB.InfoColor..GUILDINFOTAB_APPLICANTS, GetNumGuildApplicants())
	gRank:SetFormattedText(DB.InfoColor.."%s%s", RANK_COLON, guildRank or "")

	for i = 1, total do
		local name, _, _, level, _, zone, _, _, connected, status, class, _, _, mobile = GetGuildRosterInfo(i)
		if connected or mobile then
			if mobile and not connected then
				zone = REMOTE_CHAT
				if status == 1 then
					status = "|TInterface\\ChatFrame\\UI-ChatIcon-ArmoryChat-AwayMobile:14:14:0:0:16:16:0:16:0:16|t"
				elseif status == 2 then
					status = "|TInterface\\ChatFrame\\UI-ChatIcon-ArmoryChat-BusyMobile:14:14:0:0:16:16:0:16:0:16|t"
				else
					status = ChatFrame_GetMobileEmbeddedTexture(73/255, 177/255, 73/255)
				end
			else
				if status == 1 then
					status = DB.AFKTex
				elseif status == 2 then
					status = DB.DNDTex
				else
					status = " "
				end
			end
			if not zone then zone = UNKNOWN end

			count = count + 1

			if not info.guildTable[count] then info.guildTable[count] = {} end
			info.guildTable[count][1] = level
			info.guildTable[count][2] = class
			info.guildTable[count][3] = Ambiguate(name, "none")
			info.guildTable[count][4] = zone
			info.guildTable[count][5] = status
		end
	end

	infoFrame.numMembers = count
end

info.eventList = {
	"PLAYER_ENTERING_WORLD",
	"GUILD_ROSTER_UPDATE",
	"PLAYER_GUILD_UPDATE",
}

info.onEvent = function(self, event, arg1)
	if not IsInGuild() then
		self.text:SetFormattedText("%s：%s", GUILD, DB.MyColor..NONE)
		return
	end

	if event == "GUILD_ROSTER_UPDATE" then
		if arg1 then
			C_GuildInfo_GuildRoster()
		end
	end

	local online = select(3, GetNumGuildMembers())
	self.text:SetFormattedText("%s：%s", GUILD, DB.MyColor..online)

	if infoFrame and infoFrame:IsShown() then
		info:GuildPanel_Refresh()
		info:GuildPanel_SortUpdate()
	end
end

info.onEnter = function()
	if not IsInGuild() then return end
	if NDuiFriendsFrame and NDuiFriendsFrame:IsShown() then
		NDuiFriendsFrame:Hide()
	end

	info:GuildPanel_Init()
	info:GuildPanel_Refresh()
	info:GuildPanel_SortUpdate()
end

local function delayLeave()
	if MouseIsOver(infoFrame) then return end
	infoFrame:Hide()
end

info.onLeave = function()
	if not infoFrame then return end
	C_Timer_After(.1, delayLeave)
end

info.onMouseUp = function()
	--if InCombatLockdown() then UIErrorsFrame:AddMessage(DB.InfoColor..ERR_NOT_IN_COMBAT) return end -- fix by LibShowUIPanel

	if not IsInGuild() then return end
	infoFrame:Hide()
	if not GuildFrame then LoadAddOn("Blizzard_GuildUI") end
	ToggleFrame(GuildFrame)
end