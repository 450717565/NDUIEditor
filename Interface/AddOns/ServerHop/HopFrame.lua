-- MODULE FOR HOPPING FRAME --


--=====================--
-- Standard mode frame --
--=====================--
ServerHop.hopFrame = CreateFrame("Frame",nil,ServerHop)
local hopFrame = ServerHop.hopFrame

hopFrame.lastUpdate = 0
hopFrame.SearchRequest = false
hopFrame.Searching = false
hopFrame.EnteringApplication = false
hopFrame.LastEnter = 0
hopFrame.LeavingGroup = false
local BlackList = {} -- list of pairs {realm name = time last visited
local HopList = {} -- sorted list of groups available for server hopping

local lastServer = nil -- last server you've hopped to
local backSearch = false -- start searching for a last server you've hopped on

local searchCategoryCount = 0 -- change category if addon can't find something new

ServerHop.hopFrame:SetSize(SERVERHOP_WIDTH,SERVERHOP_HEIGHT)
ServerHop.hopFrame:SetPoint("BOTTOM",0,0)
ServerHop.hopFrame:SetBackdrop({bgFile = "Interface\\FrameGeneral\\UI-Background-Rock", 
					edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border", 
					tile = true, tileSize = 200, edgeSize = 24, 
					insets = { left = 4, right = 4, top = 4, bottom = 4 }});
ServerHop.hopFrame:SetBackdropColor(1,1,1,1);

ServerHop.hopFrame.background = ServerHop.hopFrame:CreateTexture(nil,"BORDER")
ServerHop.hopFrame.background:SetSize(SERVERHOP_WIDTH+106,SERVERHOP_HEIGHT-10)
ServerHop.hopFrame.background:SetPoint("BOTTOM",1,5)
ServerHop.hopFrame.background:SetTexture("Interface\\Challenges\\challenges-besttime-bg")

ServerHop.hopFrame.stringRealm = ServerHop.hopFrame:CreateFontString("realmname", "OVERLAY", "QuestFont_Shadow_Huge")
ServerHop.hopFrame.stringRealm:SetPoint("BOTTOM",0,92)
ServerHop.hopFrame.stringRealm:SetTextColor(1, 0.914, 0.682, 1)
ServerHop.hopFrame.stringRealm:SetText(GetRealmName())

-- list of options 
ServerHop.hopFrame.pvpDrop = CreateFrame("Frame", "hopFramepvpDrop", ServerHop.hopFrame, "UIDropDownMenuTemplate")
local pvpD = ServerHop.hopFrame.pvpDrop
pvpD:SetPoint("BOTTOMRIGHT",0,55)
function ServerHop.hopFrame.pvpDrop_OnClick(self)
	UIDropDownMenu_SetSelectedID(pvpD, self:GetID())
end
-- list of options in droplist
ServerHop_serverTypeDropTable = {
	COMPACT_UNIT_FRAME_PROFILE_AUTOACTIVATEPVP,
	COMPACT_UNIT_FRAME_PROFILE_AUTOACTIVATEPVE,
	ALL
}
pvpD.initialize = function(self,level)
	if not level then return end
	local info = UIDropDownMenu_CreateInfo()
	for k,v in pairs(ServerHop_serverTypeDropTable) do
		info = UIDropDownMenu_CreateInfo()
		info.text = v
		info.value = v
		info.func = ServerHop.hopFrame.pvpDrop_OnClick
		UIDropDownMenu_AddButton(info,level)
	end
end
UIDropDownMenu_Initialize(pvpD, pvpD.initialize)
UIDropDownMenu_SetSelectedID(pvpD, 3)
UIDropDownMenu_SetText(pvpD,ALL)
UIDropDownMenu_SetWidth(pvpD,70)

-- Dropdown to select party size to hop in
ServerHop.hopFrame.dropDown = CreateFrame("Frame", "CountDrop", ServerHop.hopFrame, "UIDropDownMenuTemplate")
ServerHop.hopFrame.dropDown:SetPoint("BOTTOMLEFT",0,55)
function ServerHop.hopFrame.dropDown_OnClick(self)
	UIDropDownMenu_SetSelectedID(ServerHop.hopFrame.dropDown, self:GetID())
end
-- list of options in droplist
local groupSizeList = {
	PARTY.." 1-4",
	RAID.." 6-40",
	SERVERHOP_ANYSIZE
}
ServerHop.hopFrame.dropDown.initialize = function(self,level)
	if not level then return end
	local info = UIDropDownMenu_CreateInfo()
	for k,v in pairs(groupSizeList) do
		info = UIDropDownMenu_CreateInfo()
		info.text = v
		info.value = v
		info.func = ServerHop.hopFrame.dropDown_OnClick
		UIDropDownMenu_AddButton(info,level)
	end
end
UIDropDownMenu_Initialize(ServerHop.hopFrame.dropDown, ServerHop.hopFrame.dropDown.initialize)
UIDropDownMenu_SetSelectedID(ServerHop.hopFrame.dropDown, 3)
UIDropDownMenu_SetText(ServerHop.hopFrame.dropDown,SERVERHOP_ANYSIZE)
UIDropDownMenu_SetWidth(ServerHop.hopFrame.dropDown,100)
UIDropDownMenu_SetAnchor(ServerHop.hopFrame.dropDown,0,10,"TOPRIGHT",ServerHop.hopFrame.dropDown,"BOTTOMRIGHT")

-- Button to do the hopping 
ServerHop.hopFrame.buttonHop = CreateFrame("Button",nil,ServerHop.hopFrame,"UIGoldBorderButtonTemplate")
ServerHop.hopFrame.buttonHop:SetSize(94,24)
ServerHop.hopFrame.buttonHop:SetPoint("BOTTOM",-54,36)
ServerHop.hopFrame.buttonHop:SetText(SEARCH)

ServerHop.hopFrame.buttonHop.spinner = CreateFrame("Frame",nil,ServerHop.hopFrame.buttonHop,"LoadingSpinnerTemplate")
ServerHop.hopFrame.buttonHop.spinner:SetSize(30,30)
ServerHop.hopFrame.buttonHop.spinner:SetPoint("RIGHT",24,0)
hopFrame.buttonHop.spinner:Hide()

-- counter for visited realms
hopFrame.blacklistString = hopFrame:CreateFontString("rolestring", "OVERLAY", "GameFontNormal")
hopFrame.blacklistString:SetPoint("BOTTOM",50,36)
hopFrame.blacklistString:SetHeight(24)
hopFrame.blacklistString:SetJustifyH("LEFT")
hopFrame.blacklistString:SetText(SERVERHOP_INBLACKLIST.."|cFFFFFFFF0|r")

-- Button to reset blacklist
ServerHop.hopFrame.buttonResetBL = CreateFrame("Button","sh_clearblbut",ServerHop.hopFrame,"BrowserButtonTemplate")
ServerHop.hopFrame.buttonResetBL:SetSize(25,25)
ServerHop.hopFrame.buttonResetBL:SetPoint("BOTTOMRIGHT",-15,35)
ServerHop.hopFrame.buttonResetBL.Icon = ServerHop.hopFrame.buttonResetBL:CreateTexture("changemodebuttex","OVERLAY")
ServerHop.hopFrame.buttonResetBL.Icon:SetSize(14,12)
ServerHop.hopFrame.buttonResetBL.Icon:SetPoint("CENTER",0,0)
ServerHop.hopFrame.buttonResetBL.Icon:SetTexture("Interface\\Buttons\\UI-RefreshButton")

hopFrame.description = CreateFrame("EditBox", nil, hopFrame, "LFGListEditBoxTemplate")
hopFrame.description:SetPoint("BOTTOM",3,12)
hopFrame.description:SetSize(SERVERHOP_WIDTH-40,24)
hopFrame.description:SetMaxLetters(255)
hopFrame.description.Instructions:SetText(LFG_LIST_DETAILS)


-- Button to hop to the last blacklisted realm
--[[ServerHop.hopFrame.buttonHopBack = CreateFrame("Button",nil,ServerHop.hopFrame,"UIGoldBorderButtonTemplate")
ServerHop.hopFrame.buttonHopBack:SetSize(100,24)
ServerHop.hopFrame.buttonHopBack:SetPoint("BOTTOM",-55,15)
ServerHop.hopFrame.buttonHopBack:SetText(ServerHop_LASTBUTTON)
ServerHop.hopFrame.buttonHopBack:Disable()
]]



-- MAIN FUNCTIONS --
local function ClearBlackList()
	BlackList = {}
	ServerHop.tables.LeadersBL = {}
	hopFrame.blacklistString:SetText(SERVERHOP_INBLACKLIST.."|cFFFFFFFF0|r")
end

local origLeaveParty = LeaveParty

LeaveParty = function (...)
	-- turn this off first so it won't enable a button
	hopFrame.EnteringApplication = false

	hopFrame.buttonHop:Disable()
	if #HopList == 0 then
		hopFrame.buttonHop:SetText(SEARCH)
	else
		hopFrame.buttonHop:SetText(SERVERHOP_HOPPING)
	end
	GameTooltip:Hide()
	hopFrame.buttonHop.spinner:Show()
	hopFrame.buttonHop.spinner.Anim:Play()
	hopFrame.LeavingGroup = true

	return origLeaveParty(...)
end

function LeaveAndBlackList()
	local index = GetNumGroupMembers()
	local name, server
	local fullname
	
	if IsInRaid() then
		for i=1,index do
			if UnitIsGroupLeader("raid"..i) then
				fullname = GetUnitName("raid"..i,true)
				name,server = UnitName("raid"..i)
				-- why the hell does it return server as "" on other people, but on you returns nil???
				if server == "" or server == nil then
					server = GetRealmName()
				end
				BlackList[server]=GetTime()
				break
			end
		end
	else
		for i=1,4 do
			if UnitIsGroupLeader("party"..i) then
				fullname = GetUnitName("party"..i,true)
				name,server = UnitName("party"..i)
				if server == "" then
					server = GetRealmName()
				end
				BlackList[server]=GetTime()
				break
			end
		end
	end
	
	if server ~= GetRealmName() then
		lastServer = server
	end

	local blackCount = 0
	for k,v in pairs(BlackList) do
		if GetTime()-v < ServerHop.optionsFrame.hopSearchOptionsFrame.sliderBLTime:GetValue() then
			blackCount = blackCount + 1
		end
	end
	
	if IsShiftKeyDown() then
		table.insert(ServerHop.tables.LeadersBL,fullname)
	end

	hopFrame.blacklistString:SetText(SERVERHOP_INBLACKLIST.." |cFFFFFFFF"..blackCount.."|r")	
	LeaveParty()
end

local function FoundInDelisted(appID)
	local id, activityID, name, comment, voiceChat, iLvl, honorLevel, age, numBNetFriends, numCharFriends, numGuildMates, isDelisted, leaderName, numMembers, autoinv = C_LFGList.GetSearchResultInfo(appID)
	local id, appStatus, pendingStatus, appDuration = C_LFGList.GetApplicationInfo(appID)
	
	-- if your selected group has the same leader as you - it's your group
	if C_LFGList.GetActiveEntryInfo() then
		local index = GetNumGroupMembers()
		local name = GetUnitName("player")
		
		if IsInRaid() then
			for i=1,index do
				if UnitIsGroupLeader("raid"..i) then
					name = GetUnitName("raid"..i,true)
					break
				end
			end
		else
			for i=1,4 do
				if UnitIsGroupLeader("party"..i) then
					name = GetUnitName("party"..i,true)
					break
				end
			end
		end

		if name == leaderName then return true end
	end
	
	if isDelisted or appStatus == "invitedeclined" or appStatus == "declined" or appStatus == "timedout"
	or appStatus == "cancelled" or pendingStatus == "cancelled" or appStatus == "failed" 
	then
		return true
	end
	
	return false
end

local function FilterHopSearchGroups()
	HopList = {}
	local count, slist = C_LFGList.GetSearchResults()
	
	-- SORT BY ZONE
	list = {}
	for i=1,#slist do
		local id, activityID, name, comment, voiceChat, iLvl, honorLevel, age, numBNetFriends, numCharFriends, numGuildMates, isDelisted, leaderName, numMembers, autoinv = C_LFGList.GetSearchResultInfo(slist[i])
		
		if activityID == ServerHop:GetMyZoneID() or string.find(name,GetZoneText()) or string.find(comment,GetZoneText()) or string.find(comment,ServerHop:GetMyZoneID()) then
			table.insert(list,id)
		end
	end
--	print(#list.." groups found.")

	local unsorted = {}
	if (backSearch) then
		for i = 1,#list do
			local id, _, _, _, _, _, _, _, _, _, _, _, leaderName, numMembers, autoinv = C_LFGList.GetSearchResultInfo(list[i])
			local realm = PlayerRealm(leaderName)

			if leaderName ~= nil and lastServer == realm then
				if UIDropDownMenu_GetSelectedID(ServerHop.hopFrame.dropDown) == 1 then
					if numMembers < 5 then
						table.insert(HopList, id)
					end
				elseif UIDropDownMenu_GetSelectedID(ServerHop.hopFrame.dropDown) == 2 then
					if numMembers >= 6 and numMembers < 40 then
						table.insert(HopList, id)
					end
				else
					table.insert(HopList, id)
				end				
			end
		end			
	else
	-- forward search
		
		-- Adding all available groups that don't match blacklist
		for i = 1,#list do
			local id, _, _, comment, _, _, _, _, _, _, _, _, leaderName, numMembers, autoinv = C_LFGList.GetSearchResultInfo(list[i])

			if leaderName ~= nil then
				-- checking if leader is blacklisted
				local leaderClear = true
				for i=1,#ServerHop.tables.LeadersBL do
					if leaderName == ServerHop.tables.LeadersBL[i] then
						leaderClear = false
						break
					end
				end

				local realm = PlayerRealm(leaderName)
				
				if realm ~= GetRealmName() and leaderClear and not FoundInDelisted(id)
				and (BlackList[realm] == nil or (GetTime()-BlackList[realm] > ServerHop.optionsFrame.hopSearchOptionsFrame.sliderBLTime:GetValue())) 
				and numMembers ~= 5 and numMembers ~= 40 then
					-- passed general filters, now let's check for settings
					if (UIDropDownMenu_GetSelectedID(pvpD) == 1 and ServerHop.var.pvpList[realm] == true) or
					(UIDropDownMenu_GetSelectedID(pvpD) == 2 and ServerHop.var.pvpList[realm] == nil) or
					(UIDropDownMenu_GetSelectedID(pvpD) == 3) then

						if UIDropDownMenu_GetSelectedID(ServerHop.hopFrame.dropDown) == 1 then
							if numMembers < 5 then
								unsorted[id] = autoinv
							end
						elseif UIDropDownMenu_GetSelectedID(ServerHop.hopFrame.dropDown) == 2 then
							if numMembers >= 6 and numMembers < 40 then
								unsorted[id] = autoinv
							end
						else
							unsorted[id] = autoinv
						end

					end
				end
			end
		end

		-- push all autoinvite first
		for id,auto in pairs(unsorted) do
			if auto then table.insert(HopList,id) end
		end
		-- sort by people count, low count first
		table.sort(HopList,function(id1,id2)
			local pcount1 = select(14,C_LFGList.GetSearchResultInfo(id1))
			local pcount2 = select(14,C_LFGList.GetSearchResultInfo(id2))
			return pcount1 < pcount2
		end)		

		-- add non auto invites if needeed
		if ServerHop.optionsFrame.hopSearchOptionsFrame.autoInviteCheck:GetChecked() then
			-- push them to another group
			local normalGroups = {}
			for id,auto in pairs(unsorted) do
				if not auto then table.insert(normalGroups,id) end
			end
			-- sort them
			table.sort(normalGroups,function(id1,id2)
				local pcount1 = select(14,C_LFGList.GetSearchResultInfo(id1))
				local pcount2 = select(14,C_LFGList.GetSearchResultInfo(id2))
				return pcount1 < pcount2
			end)
			-- push them good ordered
			for k,v in pairs(normalGroups) do
				table.insert(HopList,v)
			end	
		end
	end

--[[ TEST FILLING
	for k,v in pairs(HopList) do
		local id, activityID, name, comment, voiceChat, iLvl, honorLevel, age, numBNetFriends, numCharFriends, numGuildMates, isDelisted, leaderName, numMembers, autoinv = C_LFGList.GetSearchResultInfo(v)
		local a = 0
		if autoinv then a = 1 end 
		print(numMembers.." "..a)
	end
]]

	if #HopList == 0 then-- search more if couldn't find any
		ServerHop.hopFrame.buttonHop:SetText(SEARCH)
	end
end

local function buttonHop_OnEnter(self)
	if not self:IsEnabled() then return end

	GameTooltip:SetOwner(self, "ANCHOR_RIGHT", 10, -40);

	if #HopList > 0 then
		local resultID = HopList[1]
		local id, activityID, name, comment, voiceChat, iLvl, honorLevel, age, numBNetFriends, numCharFriends, numGuildMates, isDelisted, leaderName, numMembers, autoinv = C_LFGList.GetSearchResultInfo(resultID)
		local fullName, shortName, categoryID, groupID, iLevel, filters, minLevel, maxPlayers, displayType, orderIndex, useHonorLevel = C_LFGList.GetActivityInfo(activityID);
		local memberCounts = C_LFGList.GetSearchResultMemberCounts(resultID);
		GameTooltip:SetText(name);	
		GameTooltip:AddLine(fullName,1,1,1);
		if autoinv then
			GameTooltip:AddLine(ServerHop_AUTOINVITE, 0.25, 0.75, 0.25, true)
		end	
		if ( comment ~= "" ) then
			GameTooltip:AddLine(string.format(LFG_LIST_COMMENT_FORMAT, comment), LFG_LIST_COMMENT_FONT_COLOR.r, LFG_LIST_COMMENT_FONT_COLOR.g, LFG_LIST_COMMENT_FONT_COLOR.b, true);
		end
		if ( leaderName ) then
			GameTooltip:AddLine(string.format(LFG_LIST_TOOLTIP_LEADER, leaderName));
		end
		if ( age > 0 ) then
			GameTooltip:AddLine(string.format(LFG_LIST_TOOLTIP_AGE, SecondsToTime(age, false, false, 1, false)));
		end

		if ( leaderName or age > 0 ) then
			GameTooltip:AddLine(" ");
		end

		GameTooltip:AddLine(string.format(LFG_LIST_TOOLTIP_MEMBERS, numMembers, memberCounts.TANK, memberCounts.HEALER, memberCounts.DAMAGER));
	else
		GameTooltip:SetText(SEARCH)
	end

	GameTooltip:Show();
end

ServerHop.hopFrame.buttonHop:SetScript("OnEnter", buttonHop_OnEnter)
ServerHop.hopFrame.buttonHop:SetScript("OnLeave", function(self) GameTooltip:Hide() end)

local function FullScaleSearch(selection, str, filter1, filter2)
	--print("Called search")
	local lang={}
	for k,v in pairs(C_LFGList.GetAvailableLanguageSearchFilter()) do lang[v]=true end
	C_LFGList.Search(selection, LFGListSearchPanel_ParseSearchTerms(str), filter1, filter2, lang)
end

function SH_ManageSearch()
	local category = 1
	if searchCategoryCount == 2 then
		category = 6
		searchCategoryCount = 0
	else
		searchCategoryCount = searchCategoryCount + 1
	end
	HopList = {}
	hopFrame.SearchRequest = true
	hopFrame.buttonHop.spinner:Show()
	hopFrame.buttonHop.spinner.Anim:Play()
	hopFrame.Searching = true
	FullScaleSearch(category,"",0,0)
end

local function SH_ManageApplications()
	local summ = 0

	local apps = C_LFGList.GetApplications()
	for i=1,#apps do
		local id, appStatus, pendingStatus,appDuration = C_LFGList.GetApplicationInfo(apps[i]);
		local duration = 0;
		if appDuration and appDuration > 0 then
			duration = appDuration;
		end
		if appStatus == "applied" or pendingStatus == "applied" then
			if duration < 300 - ceil(ServerHop.optionsFrame.hopSearchOptionsFrame.sliderQueueWait.value) then
				C_LFGList.CancelApplication(apps[i])
				return
			end
			summ = summ + 1
		elseif pendingStatus == "invited" or appStatus == "invited" then
			C_LFGList.AcceptInvite(apps[i])
			hopFrame.buttonHop:Disable()
			hopFrame.buttonHop.spinner:Show()
			hopFrame.buttonHop.spinner.Anim:Play()

			hopFrame.buttonHop:SetText(PARTY_LEAVE)
			GameTooltip:Hide()
			hopFrame.EnteringApplication = true
			hopFrame.LastEnter = GetTime()
			return
		end
	end
	
	if summ == 5 then return end

	local tank, heal, dd = C_LFGList.GetAvailableRoles()
	C_LFGList.ApplyToGroup(HopList[1], "", tank, heal, dd)	
	table.remove(HopList,1)

	if ServerHop.optionsFrame.hopSearchOptionsFrame.chatNotifButton:GetChecked() then
		ServerHop:Log(SERVERHOP_NEXTREALM,SIGN_UP.."... ")
	end

	if #HopList == 0 then
		hopFrame.buttonHop:SetText(SEARCH)
	end
end

-- hop forward button
function ServerHop_HopForward()
	if not hopFrame.buttonHop:IsEnabled() then return end

	if #HopList == 0 then
		SH_ManageSearch()
	elseif IsInGroup() or IsInRaid() then
		LeaveAndBlackList()
	else
		SH_ManageApplications()
	end
end

ServerHop.hopFrame.buttonHop:SetScript("OnClick", function(btn)
	ServerHop_HopForward()
	buttonHop_OnEnter(btn)
end)

--[[function ServerHop_HopBack()
	if lastServer ~= nil then
		hopFrame.buttonHop:Disable()
		hopFrame.buttonHopBack:Disable()
		hopFrame.buttonHop:SetText(ServerHop_HOPPING)

		LeaveParty()
		
		hopFrame.hopRequest = true
		backSearch = true
		
		-- make sure to get a search from category 6
		if hopFrame.firstTime then
			hopFrame.lastUpdate = SEARCH_INTERVAL
			ServerHop.hopFrame.buttonHop:SetText(ServerHop_SEARCHING)
			hopSearch = true
		else
			FilterHopSearchGroups()
		end
	end
end

ServerHop.hopFrame.buttonHopBack:SetScript("OnClick", function(btn)
	ServerHop_HopBack()
end)
]]

ServerHop.hopFrame.buttonResetBL:SetScript("OnEnter", function(self)
	GameTooltip:SetOwner(self, "ANCHOR_BOTTOM", 0, 0)
	GameTooltip:SetText(SERVERHOP_CLEARBL, 1, 1, 1, true)
	
	local i = 0
	for k,v in pairs(BlackList) do
		if GetTime()-v < ServerHop.optionsFrame.hopSearchOptionsFrame.sliderBLTime:GetValue() then
			if i < 5 then
				GameTooltip:AddLine(k)
			end
			i = i+1
		end
	end
	
	if i>5 then
		GameTooltip:AddLine(" ");
		GameTooltip:AddLine(string.format(SERVERHOP_MORE_IN_BL,(i-5)));	
	end
	
	if #ServerHop.tables.LeadersBL > 0 then
		GameTooltip:AddLine(" ")
		GameTooltip:AddLine(LEADER..": "..#ServerHop.tables.LeadersBL)
	end

	GameTooltip:Show()

end)

ServerHop.hopFrame.buttonResetBL:SetScript("OnLeave", function(self)
	GameTooltip:Hide()
end)

StaticPopupDialogs["SERVERHOP_CLEARBL_DIAG"] = {
  text = SERVERHOP_CLEARBL_QUESTION,
  button1 = YES,
  button2 = NO,
  OnAccept = function()
      ClearBlackList()
  end,
  whileDead = true,
  hideOnEscape = true,
}

ServerHop.hopFrame.buttonResetBL:SetScript("OnClick", function(self,btn)
	StaticPopup_Show("SERVERHOP_CLEARBL_DIAG")
end)




local function RemoveDelisted()
	local removed = false

	local i=#HopList
	while i > 0 do		
		if FoundInDelisted(HopList[i]) then
			table.remove(HopList,i)
			removed = true
		end
		i = i - 1
	end

	if removed then FilterHopSearchGroups() end
end


--===============--
-- LINKS IN CHAT --
--===============--

function SH_ShowServerChatInfo(text)
	local _,name,comment,realm = strsplit("*",text)

	local realmName = string.match(realm,'%[(.+)%]')
	
	ShowUIPanel(ItemRefTooltip)
	if (not ItemRefTooltip:IsVisible()) then
		ItemRefTooltip:SetOwner(UIParent, "ANCHOR_PRESERVE")
	end
	ItemRefTooltip:ClearLines()
	ItemRefTooltip:AddLine("\124cff71d5ff"..realmName.."\124r",1,1,1,1)
	ItemRefTooltip:AddLine(" ",1,1,1,1)
	ItemRefTooltip:AddLine("\124cff"..name.."\124r",1,1,1,1)
	if grdesc ~= "" then
		ItemRefTooltip:AddLine(comment,1,1,1,1)
	end
	ItemRefTooltip:Show()
end

local function SendChatNotification(appID)
	local id, _, name, comment, _, _, _, _, _, _, _, _, leaderName, _, autoinv = C_LFGList.GetSearchResultInfo(appID)
	local realm = PlayerRealm(leaderName)
	local ncolor = "ffd517"
	if autoinv then ncolor = "3caa3c" end
	ServerHop:Log(TRANSFER,"\124cff71d5ff\124HsehopS:*"..ncolor..name.."*"..comment.."*\124h["..realm.."]\124h\124r.")
end

-- rewriting hyperlink function to react on serverhop links
local origChatFrame_OnHyperlinkShow = ChatFrame_OnHyperlinkShow

ChatFrame_OnHyperlinkShow = function(...)
	local chatFrame, link, text, button = ...
	if type(text) == "string" and text:match("sehopS") and not IsModifiedClick() then
		SH_ShowServerChatInfo(text)
	else
		return origChatFrame_OnHyperlinkShow(...)
	end
end


--==============--
-- EVENT SYSTEM --
--==============--

local function HopFrame_EventSystem(self, event, ...)
	local arg1 = ...

	if event == "LFG_LIST_SEARCH_RESULTS_RECEIVED" then
		if hopFrame.SearchRequest then
			-- thus we're populating HopList
			FilterHopSearchGroups()
			hopFrame.SearchRequest = false
			hopFrame.buttonHop:SetText(SERVERHOP_HOPPING)
		else
			-- let's forget about search results
			HopList = {}
		end
	end
	
	if event == "LFG_LIST_SEARCH_RESULT_UPDATED" then
		if #HopList > 0 then
			--FilterHopSearchGroups() -- unfortunately causes too much lag
			RemoveDelisted()
		end
	end

	if event == "GROUP_ROSTER_UPDATE" then -- non checked yet
	-- Checking Server Name
		local index = GetNumGroupMembers()
		local name = nil
		local server = nil
		
		if IsInRaid() then
			for i=1,index do
				if UnitIsGroupLeader("raid"..i) then
					name,server = UnitName("raid"..i)
					break
				end
			end
		elseif IsInGroup() then
			for i=1,4 do
				if UnitIsGroupLeader("party"..i) then
					name,server = UnitName("party"..i)
					break
				end
			end
		end
		
		if server == nil or server == "" then
			server = GetRealmName()
		end
		ServerHop.hopFrame.stringRealm:SetText(server)
	
	end
	if event == "LFG_LIST_JOINED_GROUP" then
		-- send chat notification about hopping
		if (ServerHop.optionsFrame.hopSearchOptionsFrame.chatNotifButton:GetChecked()) then
			SendChatNotification(arg1)
		end
	end

end

local BackgroundScanner = CreateFrame("Frame")
BackgroundScanner:SetScript("OnEvent", HopFrame_EventSystem)
BackgroundScanner:RegisterEvent("LFG_LIST_SEARCH_FAILED")
BackgroundScanner:RegisterEvent("LFG_LIST_SEARCH_RESULT_UPDATED")
BackgroundScanner:RegisterEvent("LFG_LIST_SEARCH_RESULTS_RECEIVED")
BackgroundScanner:RegisterEvent("LFG_LIST_JOINED_GROUP")
BackgroundScanner:RegisterEvent("GROUP_ROSTER_UPDATE")


local function OnUpdate(self,elapsed)
	-- search updating should be counting all the time, resetting it on search results
	--hopFrame.lastUpdate = hopFrame.lastUpdate + elapsed

	if hopFrame.Searching and not hopFrame.SearchRequest then
		hopFrame.Searching = false
		hopFrame.buttonHop.spinner.Anim:Stop()
		hopFrame.buttonHop.spinner:Hide()
	end

	if hopFrame.EnteringApplication then
		if LFGListInviteDialog:IsShown() then
			StaticPopupSpecial_Hide(LFGListInviteDialog)
		end
		-- button spam remove protection
		if (GetTime() - hopFrame.LastEnter) > 5 then
			hopFrame.buttonHop:Enable()
			hopFrame.buttonHop.spinner.Anim:Stop()
			hopFrame.buttonHop.spinner:Hide()
		end

	end

	if hopFrame.LeavingGroup and not IsInGroup() and not IsInRaid() then
		hopFrame.LeavingGroup = false
		hopFrame.buttonHop.spinner.Anim:Stop()
		hopFrame.buttonHop.spinner:Hide()
		hopFrame.buttonHop:Enable()
	end

--[[
	local apps = C_LFGList.GetApplications();
	for i=1, #apps-1 do
		LFGListInviteDialog.AcknowledgeButton:Click()
	end
]]		
end

BackgroundScanner:SetScript("OnUpdate",OnUpdate)

