local WorldQuestGroupFinderAddon = CreateFrame("Frame", "WorldQuestGroupFinderAddon", UIParent)

local L = LibStub ("AceLocale-3.0"):GetLocale ("WorldQuestGroupFinder", true)

WorldQuestGroupFinder = {}

BINDING_HEADER_WQGF = ... -- text of addonname since no localized name seems to be available
BINDING_NAME_WQGF_HARDWARE_EVENT = "WQGF Button Press"

local RegisteredEvents = {}
WorldQuestGroupFinderAddon:SetScript("OnEvent", function (self, event, ...) if (RegisteredEvents[event]) then return RegisteredEvents[event](self, event, ...) end end)

	
local currentWQ = nil
local tempWQ = nil
local popupWQ = nil
local recentlyTimedOut = false
local recentlyInvited = false
local upToDateGroupMembersCount = 0
local currentlyApplying = false
local INVITE_TIMEOUT_DELAY = 6
local NEW_AREA_TIMER_DELAY = 15
local BROADCAST_PREFIX = "WQGF"
local playerRealmType = "PVE"
local pendingInvites = 0
local recentlyInvitedPlayers = false
local autoInviteRunning = false
local autoInviteQueued = false
local currentApplyID = 0
local pendingApplications = {}
local blacklistedLeaders = {}
local blacklistedRealmHoppers = {}
local seenWorldQuests = {}
local blacklistedQuests = {}
local WorldBosses = {}
local raidQuests = {}
local latestAreaWQID = nil

local manualActionsFrame = CreateFrame("frame", "WQGFManualActionsFrame", UIParent)
local currentWQFrame = CreateFrame("frame", "WorldQuestGroupCurrentWQFrame", UIParent)
	
local function chsize(char)
    if not char then
        return 0
    elseif char > 240 then
        return 4
    elseif char > 225 then
        return 3
    elseif char > 192 then
        return 2
    else
        return 1
    end
end
 
function RegisteredEvents:ADDON_LOADED(event, addon, ...)
	if (addon == "WorldQuestGroupFinder") then
		RegisterAddonMessagePrefix(BROADCAST_PREFIX)
		SLASH_WQGF1 = '/wqgf'
		SlashCmdList["WQGF"] = function (msg, editbox)
			WorldQuestGroupFinder.handleCMD(msg, editbox)	
		end
		setmetatable(WorldQuestGroupFinderConfig, {__index = WorldQuestGroupFinderConf.DefaultConfig})
		WorldQuestGroupFinder.InitBlacklists()
		WorldQuestGroupFinder.InitFrames()
	end
end

function RegisteredEvents:PLAYER_LOGIN(event)
	if (not WorldQuestGroupFinderConf.GetConfigValue("silent")) then
		print("|c00bfffffWorld Quest Group Finder v"..GetAddOnMetadata("WorldQuestGroupFinder", "Version").." BETA. "..L["WQGF_INIT_MSG"])
	end
	WorldQuestGroupFinder.SetHooks()
	WorldQuestGroupFinderConf.CreateConfigMenu()
	WorldQuestGroupFinder.dprint("World Quest Group Finder - "..L["WQGF_DEBUG_MODE_ENABLED"])
	C_Timer.After(4, function()
		local playerRealmInfo = select(4, LibStub("LibRealmInfo"):GetRealmInfoByUnit("player"))
		if (playerRealmInfo == "PVP" or playerRealmInfo == "RPPVP") then
			playerRealmType = "PVP"
		end
		if (WorldQuestGroupFinderConf.GetConfigValue("savedCurrentWQ", "CHAR") ~= nil and currentWQ == nil) then
			if (IsInGroup() and C_LFGList.GetActiveEntryInfo()) then
				WorldQuestGroupFinder.dprint("Retrieved saved current world quest info. Still in group. Restoring...")
				WorldQuestGroupFinder.HandleWorldQuestStart(WorldQuestGroupFinderConf.GetConfigValue("savedCurrentWQ", "CHAR"))
			else
				WorldQuestGroupFinder.dprint("Retrieved saved current world quest info. No longer in group. Deleting...")
				WorldQuestGroupFinderConf.SetConfigValue("savedCurrentWQ", nil, "CHAR")
			end
		end
		-- Load WQs list
		SetMapToCurrentZone()
	end)
end

function RegisteredEvents:LFG_LIST_APPLICANT_LIST_UPDATED(event, hasNewPending, hasNewPendingWithData)
	if (currentWQ ~= nil and not raidQuests[currentWQ] and StaticPopup_Visible("LFG_LIST_AUTO_ACCEPT_CONVERT_TO_RAID")) then
		WorldQuestGroupFinder.dprint("Raid conversion popup has been closed.")
		StaticPopup_Hide("LFG_LIST_AUTO_ACCEPT_CONVERT_TO_RAID")
		QueueStatusMinimapButton_SetGlowLock(QueueStatusMinimapButton, "lfglist-applicant", false)
	end
end

function RegisteredEvents:LFG_LIST_APPLICANT_UPDATED(event, applicantID)
	pendingInvites = C_LFGList.GetNumInvitedApplicantMembers()
	local id, status, pendingStatus, numMembers, isNew, comment = C_LFGList.GetApplicantInfo(applicantID)
	if (currentWQ and status == "inviteaccepted" and comment == "WorldQuestGroupFinderUser-"..currentWQ) then
		if (numMembers > 1) then
			WorldQuestGroupFinder.prefixedPrint(L["WQGF_USERS_JOINED"], true)
		else
			WorldQuestGroupFinder.prefixedPrint(L["WQGF_USER_JOINED"], true)
		end
	end
end

function RegisteredEvents:CHAT_MSG_ADDON(event, prefix, message, channel, sender)
	local cutPlayerName = (string.gsub(sender, "(.*)-(.*)", "%1"))
	if (prefix == BROADCAST_PREFIX and cutPlayerName ~= UnitName("player")) then
		WorldQuestGroupFinder.dprint(string.format("Received addon message. Sender: %s. Message: %s.", sender, message))
		if (string.find(message, "#WQS:")) then
			local tmpMsgWQ = string.gsub(message, "#WQS:(.*)#", "%1")
			tempWQ = tonumber(tmpMsgWQ)
			local isWQ = true
			if not QuestUtils_IsQuestWorldQuest(tempWQ) then
				isWQ = false
			end
			if (tempWQ ~= currentWQ) then
				if(IsQuestFlaggedCompleted(tempWQ)) then
					if isWQ then
						WorldQuestGroupFinder.prefixedPrint(string.format(L["WQGF_GROUP_NOW_DOING_WQ_ALREADY_COMPLETE"], WorldQuestGroupFinder.GetQuestInfo(tempWQ)), true)
					else
						WorldQuestGroupFinder.prefixedPrint(string.format(L["WQGF_GROUP_NOW_DOING_QUEST_ALREADY_COMPLETE"], WorldQuestGroupFinder.GetQuestInfo(tempWQ)), true)
					end
				else
					if (WorldQuestGroupFinder.HandleWorldQuestStart(tempWQ)) then						
						if isWQ then
							WorldQuestGroupFinder.prefixedPrint(string.format(L["WQGF_GROUP_NOW_DOING_WQ"], WorldQuestGroupFinder.GetQuestInfo(tempWQ)), true)
						else
							WorldQuestGroupFinder.prefixedPrint(string.format(L["WQGF_GROUP_NOW_DOING_QUEST"], WorldQuestGroupFinder.GetQuestInfo(tempWQ)), true)
						end
					else 					
						if isWQ then
							WorldQuestGroupFinder.prefixedPrint(string.format(L["WQGF_GROUP_NOW_DOING_WQ_NOT_ELIGIBLE"], WorldQuestGroupFinder.GetQuestInfo(tempWQ)), true)
						else
							WorldQuestGroupFinder.prefixedPrint(string.format(L["WQGF_GROUP_NOW_DOING_QUEST_NOT_ELIGIBLE"], WorldQuestGroupFinder.GetQuestInfo(tempWQ)), true)
						end
						
					end
				end	
			end
		elseif (string.find(message, "#WQE:")) then
			local tmpMsgWQ = string.gsub(message, "#WQE:(.*)#", "%1")
			tempWQ = tonumber(tmpMsgWQ)
			local isWQ = true
			if not QuestUtils_IsQuestWorldQuest(tempWQ) then
				isWQ = false
			end
			if isWQ then
				WorldQuestGroupFinder.prefixedPrint(string.format(L["WQGF_GROUP_NO_LONGER_DOING_WQ"], WorldQuestGroupFinder.GetQuestInfo(tempWQ)), true)
			else
				WorldQuestGroupFinder.prefixedPrint(string.format(L["WQGF_GROUP_NO_LONGER_DOING_QUEST"], WorldQuestGroupFinder.GetQuestInfo(tempWQ)), true)
			end
			if (currentWQ == tempWQ) then
				WorldQuestGroupFinder.HandleWorldQuestEnd(tempWQ)
			end
		end
	end
	CheckDistances()
end

function RegisteredEvents:QUEST_TURNED_IN(event, questID, experience, money)
	-- Hide join WQ prompts
	local isWQ = true
	if not QuestUtils_IsQuestWorldQuest(questID) then
		isWQ = false
	end
	WorldQuestGroupFinder.HideDialog ("WORLD_QUEST_ENTERED_PROMPT")
	WorldQuestGroupFinder.HideDialog ("WORLD_QUEST_ENTERED_SWITCH_PROMPT")
	WorldQuestGroupFinder.dprint(string.format("Quest complete. (ID: %d)", questID))
	if (currentWQ ~= nil and questID == currentWQ) then
		if (WorldQuestGroupFinderConf.GetConfigValue("notifyParty") and IsInGroup()) then
			WorldQuestGroupFinder.SendWQCompletionPartyNotification(questID)
		end
		if (WorldQuestGroupFinderConf.GetConfigValue("askToLeave")) then
			if (WorldQuestGroupFinderConf.GetConfigValue("autoLeaveGroup")) then
				if isWQ then
					WorldQuestGroupFinder.ShowDialog ("WORLD_QUEST_COMPLETED_LEAVE_GROUP_DIALOG")
				else
					WorldQuestGroupFinder.ShowDialog ("QUEST_COMPLETED_LEAVE_GROUP_DIALOG")
				end
			else
				WorldQuestGroupFinder.ShowLeavePrompt(isWQ)
			end
		end
		WorldQuestGroupFinder.HandleWorldQuestEnd(currentWQ)
	end
end

function RegisteredEvents:LFG_LIST_APPLICATION_STATUS_UPDATED(event, applicationID, status)
	if (currentlyApplying) then
		local _,_,name,description,_,ilvl,_,_,_,_,_,_,author,members,autoinv = C_LFGList.GetSearchResultInfo(applicationID)
		WorldQuestGroupFinder.dprint(string.format("Application has changed status. ID: %d. New status: %s.", applicationID, status))
		if (status == "applied") then
			pendingApplications[applicationID] = tempWQ
		end
		if (status == "invited") then
			recentlyInvited = true
			WorldQuestGroupFinder.StopTimeoutTimer()
			manualActionsFrame.NextButton:Show()
			manualActionsFrame.NextButton:Enable()
			manualActionsFrame.NextButton:SetText(L["WQGF_FRAME_ACCEPT_INVITE"])
			manualActionsFrame.NextButton:SetScript("OnClick", function(self, button, down)
				C_LFGList.AcceptInvite(applicationID)
			end)
		end
		if (status == "declined") then
			if (author) then
				blacklistedLeaders[author] = true
			end
			table.remove(pendingApplications, applicationID)
		end
		if (status == "failed" or status == "timedout") then
			if (pendingApplications[applicationID]) then
				table.remove(pendingApplications, applicationID)
			end
		end
		if (status == "invitedeclined") then
			if (author) then
				blacklistedLeaders[author] = true
			end
			table.remove(pendingApplications, applicationID)
			if (C_LFGList.GetNumApplications() == 0) then
				WorldQuestGroupFinder.StopTimeoutTimer()
				manualActionsFrame:Hide()
			end
		end
		if (status == "cancelled") then
			-- If cancelled status was caused by the addon
			if (recentlyTimedOut or recentlyInvited or currentWQ) then
				C_Timer.After(1, function()
					recentlyTimedOut = false
				end)
			else
				table.remove(pendingApplications, applicationID)
				if (C_LFGList.GetNumApplications() == 0) then
					WorldQuestGroupFinder.StopTimeoutTimer()
				end
			end
			C_Timer.After(1, function()
				recentlyInvited = false
			end)
		end
		if (status == "inviteaccepted") then
			recentlyInvited = false
			manualActionsFrame:Hide()
			local savedWQID = pendingApplications[applicationID]
			if (author) then
				WorldQuestGroupFinder.prefixedPrint(string.format(L["WQGF_JOINED_WQ_GROUP"], author, WorldQuestGroupFinder.GetQuestInfo(savedWQID)), true)
			end
			WorldQuestGroupFinder.HandleWorldQuestStart(savedWQID)
			C_Timer.After(1, function()
				if (IsInRaid()) then
					if (not raidQuests[savedWQID]) then
						WorldQuestGroupFinder.prefixedPrint(L["WQGF_RAID_MODE_WARNING"])
					end
				end
			end)
		end
		
		if (C_LFGList.GetNumApplications() <= 0) then
			currentlyApplying = false
		end
	end
end

function RegisteredEvents:GROUP_ROSTER_UPDATE(event)
	-- Remember that this event is often triggered multiple times
	if (currentWQ ~= nil) then
		-- Leaving the group.
		if (not IsInGroup()) then
			WorldQuestGroupFinder.HideDialog ("WORLD_QUEST_COMPLETED_LEAVE_GROUP_DIALOG")
			WorldQuestGroupFinder.HandleWorldQuestEnd(currentWQ)
			pendingInvites = 0
		end
		if (UnitIsGroupLeader("player")) then
			CheckDistances()
			C_Timer.After(1, function()
				-- If doing a world quest, group is not full and applicants are waiting, we will try to invite them
				if (((GetNumGroupMembers(LE_PARTY_CATEGORY_HOME) + C_LFGList.GetNumInvitedApplicantMembers() < (MAX_PARTY_MEMBERS+1)) or raidQuests[currentWQ]) and C_LFGList.GetNumApplicants() > 0) then
					--WorldQuestGroupFinder.HandleCustomAutoInvite()
				end
				-- Ask to relist
				if (GetNumGroupMembers() <= MAX_PARTY_MEMBERS and not C_LFGList.GetActiveEntryInfo()) then
					manualActionsFrame:Show()
					manualActionsFrame.NextButton:Show()
					manualActionsFrame.NextButton:SetText(L["WQGF_FRAME_RELIST_GROUP"])
					manualActionsFrame.NextButton:SetScript("OnClick", function(self, button, down)
						WorldQuestGroupFinder.CreateGroup(currentWQ)
					end)
				end
			end)
			-- You don't want to  be in raid mode, unless it is an elite quest
			if (IsInRaid() and GetNumGroupMembers() <= MAX_PARTY_MEMBERS+1 and not raidQuests[currentWQ]) then
				ConvertToParty()
			end
			if raidQuests[currentWQ] then
				ConvertToRaid()
			end
		end
	end
	-- GetPlayerMapPosition("party1")
end

function RegisteredEvents:LFG_LIST_ENTRY_EXPIRED_TOO_MANY_PLAYERS(event)
	if currentWQ then
		StaticPopup_Hide("LFG_LIST_ENTRY_EXPIRED_TOO_MANY_PLAYERS")
	end
end
		
function GetUnitID(RosterIndex)
	if IsInRaid() then
		return "raid"..RosterIndex
	end
	if RosterIndex == 1 then
		return "player"
	end
	return "party" .. (RosterIndex - 1)
end

function KickHoppers()
	if (currentWQ ~= nil) then
		if (UnitIsGroupLeader("player")) then
			for i=1, GetNumGroupMembers() do 
				local unitName, unitRank = GetRaidRosterInfo(i)
				if (unitRank ~= 2 and blacklistedRealmHoppers[unitName] == true) then
					WorldQuestGroupFinder.dprint(string.format("Kicking %s for being too far away...", unitName))
					UninviteUnit(unitName)
				end
			end
		end
	end
	currentWQFrame.KickButton:Hide()
end

function CheckDistances()
	if (currentWQ ~= nil) then
		if (UnitIsGroupLeader("player")) then
			-- Auto-kick all realm hoppers (players that are more than 650 yards away)
			for i=1, GetNumGroupMembers() do
				local unitName, unitRank = GetRaidRosterInfo(i)
				if unitName == GetUnitName(GetUnitID(i), true) then		-- make sure we don't kick the wrong players
					if (unitRank ~= 2 and blacklistedRealmHoppers[unitName] == nil) then
						distanceSquared, checkedDistance = UnitDistanceSquared(GetUnitID(i))
						if checkedDistance then
							if distanceSquared ^ 0.5 >= 650 then
								WorldQuestGroupFinder.prefixedPrint(string.format(L["WQGF_MEMBER_TOO_FAR_AWAY"], unitName, floor(distanceSquared ^ 0.5 + 0.5)))
								blacklistedRealmHoppers[unitName] = true
								currentWQFrame.KickButton:Show()
							end
						else
							-- distance could not be determined, check again after 1 second
							C_Timer.After(1, CheckDistances)
						end
					end
				end						
			end
		end
	end
end

for k, v in pairs(RegisteredEvents) do
	WorldQuestGroupFinderAddon:RegisterEvent(k)
end

function WorldQuestGroupFinder.GetQuestInfo (questID)
	local activityID, categoryID, filters, questName = LFGListUtil_GetQuestCategoryData(questID);
	if QuestUtils_IsQuestWorldQuest(questID) then
		local tagID, tagName, worldQuestType, rarity, elite, tradeskillLineIndex = GetQuestTagInfo (questID)
		if (not questName or questName == "") then
			questName, _ = C_TaskQuest.GetQuestInfoByQuestID (questID)
			if  (not questName or questName == "") then
				questName = select(4, GetTaskInfo(questID));
			end
		end
		
		return questName, tagID, tagName, worldQuestType, rarity, elite, tradeskillLineIndex, activityID, categoryID, filters
	else 
		if (not questName or questName == "") then
			questName, _ = C_TaskQuest.GetQuestInfoByQuestID (questID)
			if (not questName or questName == "") then
				questName = select(4, GetTaskInfo(questID));
			end
		end
		return questName, activityID, categoryID, filters
	end
end

function WorldQuestGroupFinder.resetTmpWQ ()
	tempWQ = nil
	WorldQuestGroupFinder.dprint("Resetting tempWQ")
end


function WorldQuestGroupFinder.SetHooks()	
	hooksecurefunc("BonusObjectiveTracker_OnBlockClick", function(self, button)
		if (button == "MiddleButton") then
			WorldQuestGroupFinder.HandleBlockClick(self.TrackedQuest.questID)
		end
	end)
	
	hooksecurefunc("QuestObjectiveSetupBlockButton_FindGroup", function(block, questID)
		if block.hasGroupFinderButton then
			local groupFinderButton = block.groupFinderButton;
			groupFinderButton:Hide()
		end
		local canFindGroup = false
		if QuestUtils_IsQuestWorldQuest(questID) then
			local _, _, _, worldQuestType, _, _, _, _, _, _ = WorldQuestGroupFinder.GetQuestInfo(questID)
			canFindGroup = true
			if (blacklistedQuests[questID] or worldQuestType == LE_QUEST_TAG_TYPE_PET_BATTLE or worldQuestType == LE_QUEST_TAG_TYPE_DUNGEON or worldQuestType == LE_QUEST_TAG_TYPE_PROFESSION) then
				canFindGroup = false
			end
		else 
			canFindGroup = (QuestUtils_CanUseAutoGroupFinder(questID, true) and WorldQuestGroupFinderConf.GetConfigValue("regularQuests")) or block.hasGroupFinderButton
		end
		if (canFindGroup and not block.WQGFButton) then
			block.WQGFButton = WorldQuestGroupFinder.CreateWQGFButton(block, questID, block.itemButton)
		end
		if (block.itemButton and block.WQGFButton) then
			block.WQGFButton:SetPoint("TOPRIGHT", block, 5, -26)
		end
	end)
	
	hooksecurefunc("TaskPOI_OnClick", function(self, button)
		if (self.worldQuest and (button == "MiddleButton"  or (button == "LeftButton" and IsControlKeyDown()))) then
			WorldQuestGroupFinder.HandleBlockClick(self.questID)
		end
	end)
	
	hooksecurefunc("WorldMap_GetOrCreateTaskPOI", function(index)
		-- Bind mouse button on POIs
		local existingButton = _G["WorldMapFrameTaskPOI"..index];
		existingButton:RegisterForClicks("LeftButtonUp", "RightButtonUp", "MiddleButtonUp");
		WorldMap_ResetPOI(existingButton, true, false);
		return existingButton
	end)
	
	hooksecurefunc("ObjectiveTracker_Update", function(reason, questID)
		if (reason == OBJECTIVE_TRACKER_UPDATE_WORLD_QUEST_ADDED) then
			latestAreaWQID = questID
		end
		if (reason == OBJECTIVE_TRACKER_UPDATE_WORLD_QUEST_ADDED and WorldQuestGroupFinderConf.GetConfigValue("askZoning") and GetCurrentMapAreaID() ~= 978) then
			local title, tagID, tagName, worldQuestType, rarity, elite, tradeskillLineIndex, activityID, categoryID, filters = WorldQuestGroupFinder.GetQuestInfo(questID)
			popupWQ = questID
			-- If already queued for something or if the quest is in blacklist, do not prompt
			if (not WorldQuestGroupFinder.IsAlreadyQueued(false) and not blacklistedQuests[popupWQ]) then
				-- Ignore pet battle and dungeon quests
				if (worldQuestType ~= LE_QUEST_TAG_TYPE_PET_BATTLE and worldQuestType ~= LE_QUEST_TAG_TYPE_DUNGEON and worldQuestType ~= LE_QUEST_TAG_TYPE_PROFESSION) then
					if not currentlyApplying then
						-- Check if the world quest zone has already been entered during this session
						if not seenWorldQuests[questID] then
							-- No current WQ. 
							if (currentWQ == nil) then
								seenWorldQuests[questID] = true
								WorldQuestGroupFinder.InitSearchProcess(questID, false, false, true)
								NEW_AREA_TIMER = C_Timer.NewTicker(NEW_AREA_TIMER_DELAY, function() 
									manualActionsFrame:Hide()
								end, 1)
							end
						else 
							WorldQuestGroupFinder.dprint(string.format("World quest #%d zone has already been visited. Dialog will not be shown.", questID))
						end
					else
						WorldQuestGroupFinder.dprint(string.format("Already applying for WQ #%d. Not showing dialog", questID))
					end
				else 
					WorldQuestGroupFinder.dprint(string.format("World quest #%d zone entered. WQ type is not supported. Dialog will not be shown.", questID))
				end
			else 
				WorldQuestGroupFinder.dprint(string.format("World quest #%d zone entered. WQ is blacklisted. Dialog will not be shown.", questID))
			end
		end
	end)
	
	hooksecurefunc("BonusObjectiveTracker_OnBlockAnimOutFinished", function(self) 
		WorldQuestGroupFinder.HideDialog ("WORLD_QUEST_ENTERED_PROMPT")
		WorldQuestGroupFinder.HideDialog ("WORLD_QUEST_ENTERED_SWITCH_PROMPT")
	end)
			
	hooksecurefunc("ObjectiveTracker_Update", function(reason, id)
		if (reason and reason == OBJECTIVE_TRACKER_UPDATE_QUEST and currentWQ) then
			WorldQuestGroupFinder.AttachBorderToWQ(currentWQ, true)
		end
	end)
	
	hooksecurefunc("LFGListUtil_SetAutoAccept", function(autoAccept)
		if (autoAccept and currentWQ) then
			LFGListUtil_SetAutoAccept(false)
			LFGListFrame.ApplicationViewer.AutoAcceptButton:SetChecked(false)
		end
	end)
	
	hooksecurefunc(C_LFGList, "RemoveListing", function(self)
		if (currentWQ ~= nil) then
			WorldQuestGroupFinder.HandleWorldQuestEnd(currentWQ, true)
		end
	end)
end

function WorldQuestGroupFinder.AddWorldQuestToTracker(questID)
	AddWorldQuestWatch(questID, true) 
end

function WorldQuestGroupFinder.IsAlreadyQueued(verbose)
	mode, subMode = GetLFGMode(LE_LFG_CATEGORY_LFD);
	if ( mode == "queued" or mode == "listed" or mode == "rolecheck" or mode == "proposal" or mode == "suspended" ) then
		if verbose then	WorldQuestGroupFinder.prefixedPrint(L["WQGF_ALREADY_QUEUED_DF"]) end
		return true
	end
	mode, subMode = GetLFGMode(LE_LFG_CATEGORY_LFR);
	if ( mode == "queued" or mode == "listed" or mode == "rolecheck" or mode == "proposal" or mode == "suspended" ) then
		if verbose then	WorldQuestGroupFinder.prefixedPrint(L["WQGF_ALREADY_QUEUED_RF"]) end
		return true
	end	
	mode, subMode = GetLFGMode(LE_LFG_CATEGORY_RF, RaidFinderQueueFrame.raid);
	if ( mode == "queued" or mode == "listed" or mode == "rolecheck" or mode == "proposal" or mode == "suspended" ) then
		if verbose then	WorldQuestGroupFinder.prefixedPrint(L["WQGF_ALREADY_QUEUED_RF"]) end
		return true
	end
	for i=1, GetMaxBattlefieldID() do
		local status, mapName, teamSize, registeredMatch, suspend = GetBattlefieldStatus(i);
		if ( status and status ~= "none" ) then
			if verbose then	WorldQuestGroupFinder.prefixedPrint(L["WQGF_ALREADY_QUEUED_BG"]) end
			return true
		end
	end
	return false
end

function WorldQuestGroupCurrentWQFrameNextButton__OnClick()
	if (manualActionsFrame:IsShown() and manualActionsFrame.NextButton:IsEnabled()) then
		local pf_NextButton_OnClick = manualActionsFrame.NextButton:GetScript("OnClick")
		pf_NextButton_OnClick()
	elseif (LFGListInviteDialog:IsVisible()) then
		LFGListInviteDialog_Accept(LFGListInviteDialog)
	elseif (not manualActionsFrame:IsShown() and not currentWQ and (latestAreaWQID and not IsQuestFlaggedCompleted(latestAreaWQID))) then
		WorldQuestGroupFinder.HandleBlockClick(latestAreaWQID)
	end
end

function WorldQuestGroupFinder.InitSearchProcess(questID, retry, forceCreate, wait) 
	WorldQuestGroupFinder.dprint(string.format("Looking for a group for a world quest. ID: %d", questID))
	local title, tagID, tagName, worldQuestType, rarity, elite, tradeskillLineIndex, activityID, categoryID, filters
	if (QuestUtils_IsQuestWorldQuest(questID)) then
		title, tagID, tagName, worldQuestType, rarity, elite, tradeskillLineIndex, activityID, categoryID, filters = WorldQuestGroupFinder.GetQuestInfo(questID)
		-- Ignore pet battle and dungeon quests
		if (worldQuestType == LE_QUEST_TAG_TYPE_PET_BATTLE or worldQuestType == LE_QUEST_TAG_TYPE_DUNGEON or worldQuestType == LE_QUEST_TAG_TYPE_PROFESSION) then
			WorldQuestGroupFinder.prefixedPrint(L["WQGF_CANNOT_DO_WQ_TYPE_IN_GROUP"])
			return false
		end
	else 
		title, activityID, categoryID, filters = WorldQuestGroupFinder.GetQuestInfo(questID)
		--if not LFGListUtil_CanSearchForGroup(questID) then
		--	WorldQuestGroupFinder.prefixedPrint(L["WQGF_CANNOT_DO_WQ_IN_GROUP"])
		--	return false
		--end
	end

	manualActionsFrame:Show()
	manualActionsFrame.NextButton:Show()
	
	manualActionsFrame.NextButton:SetText(L["WQGF_FRAME_SEARCH_GROUPS"])
	manualActionsFrame.secondLine:SetText("")
	manualActionsFrame.NextButton:Enable()
	manualActionsFrame.questTitle:SetText(title)
	
	local foundZone = false
	local foundGroup = false
	local retry = retry or false
	local forceCreate = forceCreate or false
	if (IsInGroup() and not UnitIsGroupLeader("player")) then
		WorldQuestGroupFinder.prefixedPrint(L["WQGF_PLAYER_IS_NOT_LEADER"])
		return false
	end
	-- Ignore blacklisted quests
	if (blacklistedQuests[questID]) then
		WorldQuestGroupFinder.prefixedPrint(L["WQGF_CANNOT_DO_WQ_IN_GROUP"])
		return false
	end
	-- Check if already queued
	if (WorldQuestGroupFinder.IsAlreadyQueued(true)) then
		return false
	end
	if (forceCreate) then
		WorldQuestGroupFinder.CreateGroup(questID)
		return true
	else
		tempWQ = questID
		if (raidQuests[questID]) then
			WorldQuestGroupFinder.dprint("This WQ can be completed in a raid")
		end
		local selectedLanguages = {}
		if (WorldQuestGroupFinderConf.GetConfigValue("allLanguages")) then
			for k,v in pairs( C_LFGList.GetAvailableLanguageSearchFilter() ) do
				selectedLanguages[v] = true
			end
		else
			selectedLanguages = C_LFGList.GetLanguageSearchFilter()
		end		
		if (wait) then
			manualActionsFrame.NextButton:SetText(L["WQGF_FRAME_INIT_SEARCH"])
			manualActionsFrame.NextButton:SetScript("OnClick", function(self, button, down)
				if (NEW_AREA_TIMER) then NEW_AREA_TIMER:Cancel() end
				C_LFGList.Search(1, LFGListSearchPanel_ParseSearchTerms(title), 0, 4, selectedLanguages)
				manualActionsFrame.NextButton:Disable()
				C_Timer.After(1.5, function()
					WorldQuestGroupFinder.InitSearchProcess(questID, true)
				end)
			end)
			return true
		end
		
		if (not retry) then
			C_LFGList.Search(1, LFGListSearchPanel_ParseSearchTerms(title), 0, 4, selectedLanguages)
			manualActionsFrame.NextButton:Disable()
			C_Timer.After(1, function()
				manualActionsFrame.NextButton:Enable()
			end)
		end
		
		manualActionsFrame.NextButton:SetScript("OnClick", function(self, button, down)
			local applicationsCount = 0
			local blacklistedApplicationsCount = 0
			local searchCount, searchResults = C_LFGList.GetSearchResults()
			local currentPlayers = 1;
							
			if (IsInGroup()) then
				currentPlayers = GetNumGroupMembers()
			end
			local groupIDs = {}
			if (not forceCreate) then
				currentApplyID = 0
				local arrayID = 0
				for k, v in pairs( searchResults ) do
					local id,_,name,description,_,ilvl,_,_,_,_,_,_,author,members,autoinv = C_LFGList.GetSearchResultInfo(v)
					-- Check group is correct
					if (name == title and GetAverageItemLevel() > ilvl and (members + currentPlayers <= MAX_PARTY_MEMBERS+1 or raidQuests[questID]) and author ~= UnitName("player")) then
						if (blacklistedLeaders[author] == true or (retry and not author)) then
							if (author) then
								WorldQuestGroupFinder.dprint(string.format("Ignoring group because leader is blacklisted. ID: %d, Name: %s, Leader: %s", id, name, author))
							end
							blacklistedApplicationsCount = blacklistedApplicationsCount + 1
						else 
							local avoidPVPGroup = false
							if (playerRealmType == "PVE" and WorldQuestGroupFinderConf.GetConfigValue("avoidPVP") and worldQuestType ~= LE_QUEST_TAG_TYPE_PVP) then
								if (string.find(description, "#WQ:"..questID.."#PV")) then
									-- Created by WQGF 0.13+, server type in description
									if (string.find(description, "#WQ:"..questID.."#PVP#")) then
										avoidPVPGroup = true
									end
								else
									-- Created by an outdated version, lookup for leader's realm type 
									local authorRealmType = nil
									if (author) then
										local _, authorRealm = strsplit("-", author)
										_, _, _, authorRealmType = LibStub("LibRealmInfo"):GetRealmInfo(authorRealm)
										if (authorRealmType == "PVP" or authorRealmType == "RPPVP") then
											avoidPVPGroup = true
										end
										WorldQuestGroupFinder.dprint(string.format("Current leader's realm type: %s", authorRealmType))
									end
								end
							end
							if (avoidPVPGroup) then
								WorldQuestGroupFinder.dprint("Not applying to a PVP realm.")
							else 
								foundGroup = true
								currentlyApplying = true
								if (applicationsCount < 5) then
									if (author) then
										WorldQuestGroupFinder.dprint(string.format("Applying to group. ID: %d, Name: %s, Leader: %s", id, name, author))
									else
										WorldQuestGroupFinder.dprint(string.format("Applying to group. ID: %d, Name: %s", id, name))
									end
									groupIDs[arrayID] = v
									arrayID = arrayID + 1
									applicationsCount = applicationsCount + 1
								else
									WorldQuestGroupFinder.dprint(string.format("Too many applications, ignoring. ID: %d, Name: %s", id, name))
								end
							end
						end
					end
				end
				if (arrayID == 0) then
					manualActionsFrame.NextButton:SetText(L["WQGF_FRAME_NO_GROUPS"])
				else
					manualActionsFrame.NextButton:SetText(string.format(L["WQGF_FRAME_FOUND_GROUPS"], applicationsCount))
				end
				manualActionsFrame.NextButton:SetScript("OnClick", function(self, button, down)
					if (arrayID == 0) then			
						WorldQuestGroupFinder.CreateGroup(questID)
					else
						local canBeTank = LFDQueueFrameRoleButtonTank.checkButton:GetChecked()
						local canBeHealer = LFDQueueFrameRoleButtonHealer.checkButton:GetChecked()
						local canBeDamager = LFDQueueFrameRoleButtonDPS.checkButton:GetChecked()
						if ((canBeTank or canBeHealer or canBeDamager) == false) then
							canBeTank, canBeHealer, canBeDamager = UnitGetAvailableRoles("player")
						end
						if (currentApplyID < tablelength(groupIDs)) then
							C_LFGList.ApplyToGroup(groupIDs[currentApplyID], "WorldQuestGroupFinderUser-"..questID, canBeTank, canBeHealer, canBeDamager)
							currentApplyID = currentApplyID + 1
							if (currentApplyID < applicationsCount) then
								manualActionsFrame.NextButton:SetText(string.format(L["WQGF_FRAME_GROUPS_LEFT"], applicationsCount - currentApplyID))
							else
								manualActionsFrame.currentText:SetText(L["WQGF_FRAME_APPLY_DONE"])
								manualActionsFrame.secondLine:SetText(L["WQGF_FRAME_CREATE_WAIT"])
								manualActionsFrame.NextButton:Hide()
								manualActionsFrame.NextButton:Disable()
								manualActionsFrame.NextButton:SetScript("OnClick", function(self, button, down)
									manualActionsFrame.NextButton:SetText(string.format(L["WQGF_FRAME_CLICK_TWICE"], C_LFGList.GetNumApplications()))		
									if (C_LFGList.GetNumApplications() > 0) then 							
										WorldQuestGroupFinder.ClearOneApplication()
									else 
										WorldQuestGroupFinder.CreateGroup(questID)
									end
								end)
								TIMEOUT_TIMER = C_Timer.NewTicker(INVITE_TIMEOUT_DELAY, function() 
									manualActionsFrame.NextButton:SetText(string.format(L["WQGF_FRAME_CLICK_TWICE"], C_LFGList.GetNumApplications()+1))									
									manualActionsFrame.secondLine:SetText("")
									manualActionsFrame.NextButton:Show()
									manualActionsFrame.NextButton:Enable()
									WorldQuestGroupFinder.dprint(string.format("The timeout timer has ended (%d seconds)", INVITE_TIMEOUT_DELAY))
								end, 1)
							end
						end
					end
				end)
			end
		end)
	end
end

function WorldQuestGroupFinder.CreateGroup(questID)
	local currentRealmType = WorldQuestGroupFinder.getCurrentRealmType()
	local descriptionFormat = AUTO_GROUP_CREATION_NORMAL_QUEST;
	local title = QuestUtils_GetQuestName(questID)
	local activityID = C_LFGList.GetActivityIDForQuestID(questID)
	-- If the function doesn't return an activity ID, create in Azsuna
	if (not activityID) then
		activityID = 419
	end
	if QuestUtils_IsQuestWorldQuest(questID) then
		descriptionFormat = AUTO_GROUP_CREATION_WORLD_QUEST;
	end					
	local completeDescription = string.format(descriptionFormat .. " " .. L["WQGF_WQ_GROUP_DESCRIPTION"], title, GetAddOnMetadata("WorldQuestGroupFinder", "Version")).." #WQ:"..questID.."#"..currentRealmType.."#"
	if (C_LFGList.CreateListing(activityID, "", 0, 0, "", completeDescription, true, false, questID)) then
		WorldQuestGroupFinder.prefixedPrint(string.format(L["WQGF_NEW_ENTRY_CREATED"], title), true)
		WorldQuestGroupFinder.HandleWorldQuestStart(questID)
	else
		WorldQuestGroupFinder.prefixedPrint(string.format(L["WQGF_GROUP_CREATION_ERROR"]))
		WorldQuestGroupFinder.dprint(string.format("Failed group data: activityID: %d", activityID))
	end
	manualActionsFrame:Hide()
end

function WorldQuestGroupFinder.ClearOneApplication()
	local applications = C_LFGList.GetApplications()
	if (C_LFGList.GetNumApplications() > 0) then
		-- Have to do this because GetApplications sometimes returns already cancelled applications
		local applicationToClear = C_LFGList.GetNumApplications()
		local _, applicationStatus = C_LFGList.GetApplicationInfo(applications[applicationToClear])
		if (applicationStatus == "invited") then
			C_LFGList.DeclineInvite(applications[applicationToClear])
			WorldQuestGroupFinder.dprint(string.format("Canceling invite: %d", applications[applicationToClear]))
		else
			WorldQuestGroupFinder.dprint(string.format("Clearing application: %d", applications[applicationToClear]))
			C_LFGList.CancelApplication(applications[applicationToClear])
		end
		return true
	end
end

function WorldQuestGroupFinder.HandleWorldQuestStart(questID)
	WorldQuestGroupFinder.dprint(string.format("World quest starting process. ID: %d", questID))
	currentlyApplying = false
	if (TIMEOUT_TIMER) then	WorldQuestGroupFinder.StopTimeoutTimer() end
	WorldQuestGroupFinder.AddWorldQuestToTracker(questID)	
	if (WorldQuestGroupFinder.AttachBorderToWQ(questID)) then
		currentWQFrame:Show()
		pendingApplications = {}
		currentWQ = questID
		WorldQuestGroupFinderConf.SetConfigValue("savedCurrentWQ", currentWQ, "CHAR")
		if (IsInGroup() and UnitIsGroupLeader("player")) then
			WorldQuestGroupFinder.BroadcastMessage("#WQS:"..questID.."#")
		end
		LFGListFrame.ApplicationViewer.AutoAcceptButton:Hide()
		WorldQuestGroupFinder.resetTmpWQ()
		return true
	else
		WorldQuestGroupFinder.dprint(string.format("World quest start process failed. ID: %d", questID))
		return false
	end
end
	
function WorldQuestGroupFinder.HandleWorldQuestEnd(wqID, broadcast)
	local broadcast = broadcast or false
	currentWQ = nil
	local targetBlock = WorldQuestGroupFinder.FindWQBlock(wqID)
	if (targetBlock) then
		targetBlock.WQGFButton:Show()
	end
	WorldQuestGroupFinder.resetTmpWQ()
	WorldQuestGroupFinder.dprint(string.format("World quest ending process. ID: %d", wqID))
	WorldQuestGroupFinderConf.SetConfigValue("savedCurrentWQ", nil, "CHAR")
	--BonusObjectiveTracker_UntrackWorldQuest(wqID)
	LFGListFrame.ApplicationViewer.AutoAcceptButton:Show()
	if (IsInGroup() and UnitIsGroupLeader("player") and broadcast) then
		WorldQuestGroupFinder.BroadcastMessage("#WQE:"..wqID.."#")
	end
	blacklistedLeaders = {}
	currentWQFrame:Hide()
end

function WorldQuestGroupFinder.FlagWQAsSeen(wqID)
	seenWorldQuests[wqID] = true
	WorldQuestGroupFinder.dprint(string.format("Setting quest #%d as visited", wqID))
end

function WorldQuestGroupFinder.BroadcastMessage(msg) 
	SendAddonMessage(BROADCAST_PREFIX, msg, "PARTY")
	WorldQuestGroupFinder.dprint(string.format("Sending broadcast. Message: %s", msg))
end

function WorldQuestGroupFinder.ShowDialog(...)
	local dialog = ...
	local dialogObject = StaticPopup_Show(...)
	if (dialogObject) then
		WorldQuestGroupFinder.dprint(string.format("Showing dialog %s", dialog))
		dialogObject.data = popupWQ
	else
		WorldQuestGroupFinder.dprint(string.format("Failed to show dialog %s", dialog))
	end
end

function WorldQuestGroupFinder.HideDialog(dialog) 
	if (StaticPopup_Visible(dialog)) then
		StaticPopup_Hide(dialog)
		WorldQuestGroupFinder.dprint(string.format("Hiding dialog %s", dialog))
	end
end

function WorldQuestGroupFinder.StopTimeoutTimer()
	if (TIMEOUT_TIMER) then TIMEOUT_TIMER:Cancel() end
	WorldQuestGroupFinder.dprint("The timeout timer has been stopped.")
end	
		
function WorldQuestGroupFinder.HandleBlockClick(wqID, forceCreate, wait)	
	if (tempWQ ~= wqID or (C_LFGList.GetNumApplications() == 0 and not C_LFGList.GetActiveEntryInfo())) then
		WorldQuestGroupFinder.dprint(string.format("World quest has been clicked. ID: %d", wqID))
		-- Ignore pet battle and dungeon quests
		local _, _, _, worldQuestType, _, _, _, _, _, _ = WorldQuestGroupFinder.GetQuestInfo(wqID)
		if (blacklistedQuests[wqID] or worldQuestType == LE_QUEST_TAG_TYPE_PET_BATTLE or worldQuestType == LE_QUEST_TAG_TYPE_DUNGEON or worldQuestType == LE_QUEST_TAG_TYPE_PROFESSION) then
			WorldQuestGroupFinder.prefixedPrint(L["WQGF_CANNOT_DO_WQ_IN_GROUP"])
			return false
		end
		if (IsInGroup() and not UnitIsGroupLeader("player")) then
			WorldQuestGroupFinder.prefixedPrint(L["WQGF_PLAYER_IS_NOT_LEADER"])
			return false
		end
		if (currentWQ ~= nil and wqID ~= currentWQ) then
			WorldQuestGroupFinder.dprint(string.format("Clicked world quest is not the same is current (%d). Showing NEW_WORLD_QUEST_PROMPT.", currentWQ))
			if QuestUtils_IsQuestWorldQuest(currentWQ) then
				WorldQuestGroupFinder.ShowDialog ("NEW_WORLD_QUEST_PROMPT")
			else
				WorldQuestGroupFinder.ShowDialog ("NEW_QUEST_PROMPT")
			end
		else 
			-- No current WQ. 
			if (currentWQ == nil or (C_LFGList.GetNumApplications() == 0 and not C_LFGList.GetActiveEntryInfo())) then
				-- Hide join WQ prompts
				WorldQuestGroupFinder.HideDialog ("WORLD_QUEST_ENTERED_PROMPT")
				WorldQuestGroupFinder.HideDialog ("WORLD_QUEST_ENTERED_SWITCH_PROMPT")
				if (NEW_AREA_TIMER) then NEW_AREA_TIMER:Cancel() end
				WorldQuestGroupFinder.InitSearchProcess(wqID, false, forceCreate, wait)
			else
				WorldQuestGroupFinder.prefixedPrint(L["WQGF_ALREADY_IS_GROUP_FOR_WQ"])
			end
		end
	else
		WorldQuestGroupFinder.dprint("Already applying for this WQ")
	end
end

function WorldQuestGroupFinder.AttachBorderToWQ(wqID, update)
	update = update or false
	local targetBlock = WorldQuestGroupFinder.FindWQBlock(wqID)
	if (targetBlock) then
		-- Move item button
		if (targetBlock.itemButton) then
			targetBlock.itemButton:SetPoint("TOPRIGHT", targetBlock, -2, -18)
		end
	
		local xOffset = -12
		local yOffset = 10
		
		local trackerWidth, trackerHeight = ObjectiveTrackerFrame:GetSize()
		local blockWidth, blockHeight = targetBlock:GetSize()
			
		currentWQFrame:SetClampedToScreen(true)
		currentWQFrame:SetFrameStrata("MEDIUM")
		currentWQFrame:SetToplevel(false) 
		
		currentWQFrame:SetSize(blockWidth+18,blockHeight+18)
		currentWQFrame:SetMovable(false)
		currentWQFrame:EnableMouse(false)
		
		currentWQFrame:SetPoint("TOPLEFT", targetBlock,"TOPLEFT", xOffset, yOffset)
		currentWQFrame:SetParent(targetBlock)
			
		currentWQFrame:SetFrameStrata("LOW")
		currentWQFrame:SetFrameLevel(0)

		currentWQFrame:SetBackdrop({
		  bgFile="Interface\\MINIMAP\\TooltipBackdrop-Background", 
		  edgeFile="Interface\\DialogFrame\\UI-DialogBox-Gold-Border", 
		  tile=false, edgeSize=16, --tileSize=16,
		  insets={left=5, right=5, top=5, bottom=5}
		})		
				
		if (not update) then
			currentWQFrame.KickButton:SetFlattensRenderLayers(true)
			currentWQFrame.KickButton:SetPoint("TOPRIGHT", -46, -6)
			currentWQFrame.KickButton:SetFrameLevel(10)
			currentWQFrame.KickButton:RegisterForClicks("LeftButtonUp")
			currentWQFrame.KickButton:SetScript("OnClick", WorldQuestGroupFinder.KickButton_OnClick)
			currentWQFrame.KickButton:SetScript("OnEnter", KickButton_OnEnter)
			currentWQFrame.KickButton:SetSize(20, 20);

			currentWQFrame.KickButton.Icon = currentWQFrame.KickButton:CreateTexture(currentWQFrame.KickButton:GetName().."Texture", "OVERLAY")
			currentWQFrame.KickButton.Icon:SetSize(12, 12)
			currentWQFrame.KickButton.Icon:SetPoint("CENTER", 0, 0)
			currentWQFrame.KickButton.Icon:SetTexture([[Interface\AddOns\WorldQuestGroupFinder\img\autokick.blp]])
			
			currentWQFrame.KickButton:Hide()

			currentWQFrame.RefreshButton:SetFlattensRenderLayers(true)
			currentWQFrame.RefreshButton:SetPoint("TOPRIGHT", -26, -6)
			currentWQFrame.RefreshButton:SetFrameLevel(10)
			currentWQFrame.RefreshButton:RegisterForClicks("LeftButtonUp")
			currentWQFrame.RefreshButton:SetScript("OnClick", WorldQuestGroupFinder.RefreshButton_OnClick)
			currentWQFrame.RefreshButton:SetScript("OnEnter", RefreshButton_OnEnter)
			currentWQFrame.RefreshButton:SetSize(20, 20);

			currentWQFrame.RefreshButton.Icon = currentWQFrame.RefreshButton:CreateTexture(currentWQFrame.RefreshButton:GetName().."Texture", "OVERLAY")
			currentWQFrame.RefreshButton.Icon:SetSize(12, 12)
			currentWQFrame.RefreshButton.Icon:SetPoint("CENTER", 0, 0)
			currentWQFrame.RefreshButton.Icon:SetTexture([[Interface\AddOns\WorldQuestGroupFinder\img\refresh.blp]])

			currentWQFrame.StopButton:SetFlattensRenderLayers(true)
			currentWQFrame.StopButton:SetPoint("TOPRIGHT", -6, -6)
			currentWQFrame.StopButton:SetFrameLevel(10)
			currentWQFrame.StopButton:RegisterForClicks("LeftButtonUp")
			currentWQFrame.StopButton:SetScript("OnClick", WorldQuestGroupFinder.StopButton_OnClick)
			currentWQFrame.StopButton:SetScript("OnEnter", StopButton_OnEnter)
			currentWQFrame.StopButton:SetSize(20, 20);

			currentWQFrame.StopButton.Icon = currentWQFrame.StopButton:CreateTexture(currentWQFrame.StopButton:GetName().."Texture", "OVERLAY")
			currentWQFrame.StopButton.Icon:SetSize(12, 12)
			currentWQFrame.StopButton.Icon:SetPoint("CENTER", 0, 0)
			currentWQFrame.StopButton.Icon:SetTexture([[Interface\AddOns\WorldQuestGroupFinder\img\stop.blp]])

			WorldQuestGroupFinder.AssignButtonTextures(currentWQFrame.KickButton)
			WorldQuestGroupFinder.AssignButtonTextures(currentWQFrame.RefreshButton)
			WorldQuestGroupFinder.AssignButtonTextures(currentWQFrame.StopButton)
		end
		
		if (targetBlock.WQGFButton) then
			targetBlock.WQGFButton:Hide()
		end
		
		return currentWQFrame
	else 
		return false
	end
end

function WorldQuestGroupFinder.CreateWQGFButton(block, questID) 
	local groupFinderButton = CreateFrame("button", questID.."GroupFinderButton", block)
	groupFinderButton:SetFlattensRenderLayers(true)
	groupFinderButton:SetPoint("TOPRIGHT", 5, 0)
	groupFinderButton:SetFrameLevel(10)
	groupFinderButton:RegisterForClicks("LeftButtonUp", "MiddleButtonUp", "RightButtonUp")
	groupFinderButton:SetScript("OnClick", function(self, button, down)
		if (button == "RightButton") then
			WorldQuestGroupFinder.prefixedPrint("Please right-click on the world quest and select \"Find Group\".")
		elseif (button == "MiddleButton") then
			WorldQuestGroupFinder.HandleBlockClick(self:GetParent().id, true)
		else
			WorldQuestGroupFinder.HandleBlockClick(self:GetParent().id)
		end
	end)
	groupFinderButton:SetScript("OnEnter", WQGFButton_OnEnter)
	groupFinderButton:SetSize(20, 20)
	groupFinderButton:SetFrameLevel(500)
	
	groupFinderButton.Icon = groupFinderButton:CreateTexture(groupFinderButton:GetName().."Texture", "OVERLAY")
	groupFinderButton.Icon:SetSize(12, 12)
	groupFinderButton.Icon:SetPoint("CENTER", 0, 0)
	groupFinderButton.Icon:SetAtlas("socialqueuing-icon-eye")
	WorldQuestGroupFinder.AssignButtonTextures(groupFinderButton)
	return groupFinderButton
end

function WorldQuestGroupFinder.SendWQCompletionPartyNotification (wqID)
	if QuestUtils_IsQuestWorldQuest(wqID) then
		SendChatMessage(string.format("[WQGF] %s: %s :)", WorldQuestGroupFinder.GetQuestInfo(wqID), WORLD_QUEST_COMPLETE), "PARTY", "", "");
	else
		SendChatMessage(string.format("[WQGF] %s: %s :)", WorldQuestGroupFinder.GetQuestInfo(wqID), QUEST_COMPLETE), "PARTY", "", "");
	end
end

function WorldQuestGroupFinder.AssignButtonTextures(button)
	button:SetNormalTexture("Interface/WorldMap/UI-QuestPoi-NumberIcons")
	button:GetNormalTexture():ClearAllPoints()
	button:GetNormalTexture():SetPoint("CENTER", button:GetNormalTexture():GetParent())
	button:GetNormalTexture():SetSize(32, 32)
	button:GetNormalTexture():SetTexCoord(0.500, 0.625, 0.375, 0.5)
	button:SetHighlightTexture("Interface/WorldMap/UI-QuestPoi-NumberIcons")
	button:GetHighlightTexture():ClearAllPoints()
	button:GetHighlightTexture():SetPoint("CENTER", button:GetHighlightTexture():GetParent())
	button:GetHighlightTexture():SetSize(32, 32)
	button:GetHighlightTexture():SetTexCoord(0.625, 0.750, 0.875, 1)
	button:SetPushedTexture("Interface/WorldMap/UI-QuestPoi-NumberIcons")
	button:GetPushedTexture():ClearAllPoints()
	button:GetPushedTexture():SetPoint("CENTER", button:GetPushedTexture():GetParent())
	button:GetPushedTexture():SetSize(32, 32)
	button:GetPushedTexture():SetTexCoord(0.375, 0.500, 0.375, 0.5)
end
	
function KickButton_OnEnter(self)
	GameTooltip:SetOwner(self);
	GameTooltip:AddLine(L["WQGF_KICK_TOOLTIP"], HIGHLIGHT_FONT_COLOR:GetRGB());
	if not self:IsEnabled() and C_LFGList.GetActiveEntryInfo() then
		local r, g, b = RED_FONT_COLOR:GetRGB();
		GameTooltip:AddLine(CANNOT_DO_THIS_WHILE_LFGLIST_LISTED, r, g, b, true);
	end
	GameTooltip:Show();
end

function RefreshButton_OnEnter(self)
	GameTooltip:SetOwner(self);
	GameTooltip:AddLine(L["WQGF_REFRESH_TOOLTIP"], HIGHLIGHT_FONT_COLOR:GetRGB());
	if not self:IsEnabled() and C_LFGList.GetActiveEntryInfo() then
		local r, g, b = RED_FONT_COLOR:GetRGB();
		GameTooltip:AddLine(CANNOT_DO_THIS_WHILE_LFGLIST_LISTED, r, g, b, true);
	end
	GameTooltip:Show();
end

function StopButton_OnEnter(self)
	GameTooltip:SetOwner(self);
	GameTooltip:AddLine(L["WQGF_STOP_TOOLTIP"], HIGHLIGHT_FONT_COLOR:GetRGB());
	if not self:IsEnabled() and C_LFGList.GetActiveEntryInfo() then
		local r, g, b = RED_FONT_COLOR:GetRGB();
		GameTooltip:AddLine(CANNOT_DO_THIS_WHILE_LFGLIST_LISTED, r, g, b, true);
	end
	GameTooltip:Show();
end

function WQGFButton_OnEnter(self)
	GameTooltip:SetOwner(self);
	GameTooltip:AddLine(L["WQGF_FIND_GROUP_TOOLTIP"], YELLOW_FONT_COLOR:GetRGB());
	GameTooltip:AddLine(L["WQGF_FIND_GROUP_TOOLTIP_2"], HIGHLIGHT_FONT_COLOR:GetRGB());
	if not self:IsEnabled() and C_LFGList.GetActiveEntryInfo() then
		local r, g, b = RED_FONT_COLOR:GetRGB();
		GameTooltip:AddLine(CANNOT_DO_THIS_WHILE_LFGLIST_LISTED, r, g, b, true);
	end
	GameTooltip:Show();
end

function WorldQuestGroupFinder.KickButton_OnClick()
	CheckDistances()
	KickHoppers()
end

function WorldQuestGroupFinder.RefreshButton_OnClick()
	if (IsInGroup() and not UnitIsGroupLeader("player")) then
		for i=1, GetNumGroupMembers() do 
			if (UnitIsGroupLeader(IsInRaid() and ("raid"..i) or ("party"..i))) then
				local leaderName = GetRaidRosterInfo(i)
				WorldQuestGroupFinder.dprint(string.format("Adding %s to blacklisted leaders...", leaderName))
				blacklistedLeaders[leaderName] = true
			end						
		end
	end
	local currentWQtmp = currentWQ
	LeaveParty()
	C_Timer.After(2, function()
		tempWQ = currentWQ
		WorldQuestGroupFinder.InitSearchProcess(currentWQtmp, false, false, true)
	end)
end

function WorldQuestGroupFinder.StopButton_OnClick()
	if (IsInGroup() and not UnitIsGroupLeader("player")) then
		WorldQuestGroupFinder.prefixedPrint(L["WQGF_PLAYER_IS_NOT_LEADER"])
	else
		C_LFGList.RemoveListing()
	end
end

function WorldQuestGroupFinder.ShowLeavePrompt(isWQ)
	if (UnitIsGroupLeader("player")) then
		if isWQ then
			WorldQuestGroupFinder.ShowDialog ("WORLD_QUEST_FINISHED_LEADER_PROMPT")
		else
			WorldQuestGroupFinder.ShowDialog ("QUEST_FINISHED_LEADER_PROMPT")
		end
	else 
		if isWQ then
			WorldQuestGroupFinder.ShowDialog ("WORLD_QUEST_FINISHED_PROMPT")
		else
			WorldQuestGroupFinder.ShowDialog ("QUEST_FINISHED_PROMPT")
		end
	end
end

function WorldQuestGroupFinder.handleCMD(msg, editbox)
	if (string.lower(msg) == "config") then
		InterfaceOptionsFrame_OpenToCategory("WorldQuestGroupFinder")
	elseif (string.lower(msg) == "data") then
		if (currentWQ ~= nil) then
			WorldQuestGroupFinder.prefixedPrint(string.format(L["WQGF_DEBUG_CURRENT_WQ_ID"], currentWQ))
		else 
			WorldQuestGroupFinder.prefixedPrint(L["WQGF_DEBUG_NO_CURRENT_WQ_ID"])
		end
		print(L["WQGF_DEBUG_WQ_ZONES_ENTERED"])
		WorldQuestGroupFinder.dumpTable(seenWorldQuests)
	elseif (string.lower(msg) == "debug") then
		if (WorldQuestGroupFinderConf.GetConfigValue("printDebug")) then
			WorldQuestGroupFinderConf.SetConfigValue("printDebug", false)
			WorldQuestGroupFinder.prefixedPrint(L["WQGF_DEBUG_MODE_DISABLED"])
		else
			WorldQuestGroupFinderConf.SetConfigValue("printDebug", true)
			WorldQuestGroupFinder.prefixedPrint(L["WQGF_DEBUG_MODE_ENABLED"])
		end
	elseif (string.lower(msg) == "showconfig") then
		print(L["WQGF_GLOBAL_CONFIGURATION"])
		WorldQuestGroupFinder.dumpTable(WorldQuestGroupFinderConfig)
		print(L["WQGF_DEBUG_CONFIGURATION_DUMP"])
		WorldQuestGroupFinder.dumpTable(WorldQuestGroupFinderCharacterConfig)
	elseif (string.lower(msg) == "unbl") then
		blacklistedLeaders = {}
		blacklistedRealmHoppers = {}
		WorldQuestGroupFinder.prefixedPrint(L["WQGF_LEADERS_BL_CLEARED"])
	elseif (string.lower(msg) == "toggle") then
		local currentValue = WorldQuestGroupFinderConf.GetConfigValue("askZoning")
		if (currentValue) then
			WorldQuestGroupFinderConf.SetConfigValue("askZoning", false)
			WorldQuestGroupFinder.prefixedPrint(L["WQGF_ZONE_DETECTION_DISABLED"])
		else
			WorldQuestGroupFinderConf.SetConfigValue("askZoning", true)
			WorldQuestGroupFinder.prefixedPrint(L["WQGF_ZONE_DETECTION_ENABLED"])
		end
	elseif (string.lower(msg) == "autokick") then
		CheckDistances()
		KickHoppers()
	else
		WorldQuestGroupFinder.help()
	end
end

function WorldQuestGroupFinder.help()
	print(L["WQGF_SLASH_COMMANDS_1"])
	print(L["WQGF_SLASH_COMMANDS_2"])
	print(L["WQGF_SLASH_COMMANDS_3"])
	print(L["WQGF_SLASH_COMMANDS_4"])
end

function WorldQuestGroupFinder.prefixedPrint(text, verbose)
	if (not (verbose and WorldQuestGroupFinderConf.GetConfigValue("silent"))) then	
		print("|c00bfffff[WQGF]|c00ffffff "..text)
	end
end 

function WorldQuestGroupFinder.dprint(text)
	if (WorldQuestGroupFinderConf.GetConfigValue("printDebug")) then
		print("|c00ffbfff[DEBUG]|c00ffffff "..text)
	end
end 

function WorldQuestGroupFinder.dumpTable(t)
	if type(t) == "table" then
		for k, v in pairs( t ) do
			print(k, v)
		end
	else 
		print(t)
	end
end

function WorldQuestGroupFinder.IsWQInZone(wqID, mapAreaID)
	local correctZone = false
	local taskInfo = C_TaskQuest.GetQuestsForPlayerByMapID(mapAreaID);
	local numTaskPOIs = 0;
	if(taskInfo ~= nil) then
		numTaskPOIs = #taskInfo;
	end
	if ( numTaskPOIs > 0 ) then
		for i, info  in ipairs(taskInfo) do
			if (info.questId == wqID) then
				correctZone = true
			end
		end
	end
	return correctZone
end

function WorldQuestGroupFinder.FindWQBlock(wqID)
	local tracker = ObjectiveTrackerFrame
	wqID = tonumber(wqID)
	
	if (not tracker.initialized) then
		return
	end
	for i = 1, #tracker.MODULES do
		local module = tracker.MODULES [i]
		for blockName, usedBlock in pairs (module.usedBlocks) do
			if (usedBlock.id) then
				if (wqID == usedBlock.id) then
					return usedBlock
				end
			end
		end
	end
	return false
end

function WorldQuestGroupFinder.getCurrentRealmType()
	local realmType = ""
	if (UnitIsPVP("player")) then
		if (GetPVPTimer() == 301000) then
			realmType = "PVP"
		else 
			realmType = "PVE"
		end
	else
		realmType = "PVE"
	end
	return realmType
end

function WorldQuestGroupFinder.getRealmTypeFromDescription()
	local description = select(6, C_LFGList.GetActiveEntryInfo())
	if (description) then
		return string.match(description, "#WQ:[%d]+#([%w]+)#")
	else
		return nil
	end
end

function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

function WorldQuestGroupFinder.ToggleFrameLock()
	if (manualActionsFrame:IsMouseEnabled()) then
		manualActionsFrame.LockButton:SetNormalTexture("Interface\\Buttons\\LockButton-Locked-Up")
		manualActionsFrame:EnableMouse(false)
		WorldQuestGroupFinderConf.SetConfigValue("frameUnlocked", false)
	else
		manualActionsFrame:EnableMouse(true)
		manualActionsFrame.LockButton:SetNormalTexture("Interface\\Buttons\\LockButton-Unlocked-Up")
		WorldQuestGroupFinderConf.SetConfigValue("frameUnlocked", true)
	end
end

function WorldQuestGroupFinder.InitFrames()
	currentWQFrame.KickButton = CreateFrame("button", currentWQFrame:GetName().."KickButton", currentWQFrame)
	currentWQFrame.RefreshButton = CreateFrame("button", currentWQFrame:GetName().."RefreshButton", currentWQFrame)
	currentWQFrame.StopButton = CreateFrame("button", currentWQFrame:GetName().."StopButton", currentWQFrame)
				
	manualActionsFrame.NextButton = CreateFrame("button", manualActionsFrame:GetName().."NextButton", manualActionsFrame, "UIPanelButtonTemplate")
	manualActionsFrame.CloseButton = CreateFrame("button", manualActionsFrame:GetName().."CloseButton", manualActionsFrame)
	manualActionsFrame.LockButton = CreateFrame("button", manualActionsFrame:GetName().."LockButton", manualActionsFrame)
	manualActionsFrame.TitleFrame = CreateFrame("frame",  manualActionsFrame:GetName().."TitleFrame", manualActionsFrame)

	tinsert(UISpecialFrames, manualActionsFrame:GetName())
	
	manualActionsFrame:SetFrameStrata("DIALOG")
	manualActionsFrame:SetToplevel(false) 
	manualActionsFrame:SetClampedToScreen(true)
	manualActionsFrame:RegisterForDrag("LeftButton")
	manualActionsFrame:SetMovable(true)
	manualActionsFrame:SetUserPlaced(true)
	manualActionsFrame:EnableMouse(WorldQuestGroupFinderConf.GetConfigValue("frameUnlocked"))
	manualActionsFrame:SetScript("OnDragStart", manualActionsFrame.StartMoving)
	manualActionsFrame:SetScript("OnDragStop", manualActionsFrame.StopMovingOrSizing)
	manualActionsFrame:SetPoint("CENTER", 0, 60); 
	manualActionsFrame:SetWidth(370); 
	manualActionsFrame:SetHeight(110);
	manualActionsFrame:SetFrameLevel(0)
	manualActionsFrame:SetBackdrop({
	  bgFile="Interface\\MINIMAP\\TooltipBackdrop-Background", 
	  edgeFile="Interface\\DialogFrame\\UI-DialogBox-Gold-Border", 
	  tile=false, edgeSize=16, --tileSize=16,
	  insets={left=5, right=5, top=5, bottom=5}
	})		

	manualActionsFrame.TitleFrame:SetPoint("TOP", 0, 0); 
	manualActionsFrame.TitleFrame:SetWidth(370); 
	manualActionsFrame.TitleFrame:SetHeight(30);
	manualActionsFrame.TitleFrame:SetBackdrop({
	  bgFile="Interface\\MINIMAP\\TooltipBackdrop-Background", 
	  edgeFile="Interface\\DialogFrame\\UI-DialogBox-Gold-Border", 
	  tile=false, edgeSize=16, --tileSize=16,
	  insets={left=5, right=5, top=5, bottom=5}
	})		

	local font = "Fonts\\FRIZQT__.TTF"
	local locale = GetLocale();
	if locale == "ruRU" then
		font = "Fonts\\FRIZQT___CYR.TTF"
	elseif locale == "koKR" then
		font = "Fonts\\2002.TTF"
	elseif locale == "zhTW" then
		font = "Fonts\\bHEI01B.TTF"
	elseif locale == "zhCN" then
		font = "Fonts\\ARKai_C.ttf"
	end

	manualActionsFrame.TitleFrame.TitleText = manualActionsFrame.TitleFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	manualActionsFrame.TitleFrame.TitleText:SetPoint("CENTER", 0, 0)
	manualActionsFrame.TitleFrame.TitleText:SetText("World Quest Group Finder v"..GetAddOnMetadata("WorldQuestGroupFinder", "Version"))

	manualActionsFrame.questTitle = manualActionsFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	manualActionsFrame.questTitle:SetPoint("TOP", 0, -35)
	manualActionsFrame.questTitle:SetFont(font, 16)
	manualActionsFrame.questTitle:SetText("")

	manualActionsFrame.currentText = manualActionsFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	manualActionsFrame.currentText:SetPoint("TOP", 0, -63)
			
	manualActionsFrame.currentText:SetTextColor(0.85, 0.85, 0.85, 1)

	manualActionsFrame.secondLine = manualActionsFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	manualActionsFrame.secondLine:SetPoint("BOTTOM", 0, 15)
	manualActionsFrame.secondLine:SetText("")
	manualActionsFrame.secondLine:SetTextColor(0.85, 0.85, 0.85, 1)

	manualActionsFrame.NextButton:SetFlattensRenderLayers(true)
	manualActionsFrame.NextButton:SetPoint("BOTTOM", 0, 10)
	manualActionsFrame.NextButton:SetFrameLevel(10)
	manualActionsFrame.NextButton:RegisterForClicks("LeftButtonUp")

	manualActionsFrame.NextButton:SetSize(
		manualActionsFrame.NextButton:GetParent():GetWidth() - 20,
		(manualActionsFrame.NextButton:GetParent():GetHeight() / 3) + 7
	)

	manualActionsFrame.CloseButton:ClearAllPoints()
	manualActionsFrame.CloseButton:SetPoint("TOPRIGHT", 0, 0)
	manualActionsFrame.CloseButton:SetSize(24, 24)
	manualActionsFrame.CloseButton:SetScale(1.25)
	manualActionsFrame.CloseButton:SetNormalTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Up")
	manualActionsFrame.CloseButton:SetPushedTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Down")
	manualActionsFrame.CloseButton:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight", "ADD")
	manualActionsFrame.CloseButton:SetScript("OnClick", function(self, button, down)
		C_LFGList.ClearSearchResults()
		self:GetParent():Hide()
	end)
		
	manualActionsFrame.LockButton:ClearAllPoints()
	manualActionsFrame.LockButton:SetPoint("TOPLEFT", 0, 0)
	manualActionsFrame.LockButton:SetSize(24, 24)
	manualActionsFrame.LockButton:SetScale(1.25)
	manualActionsFrame.LockButton:SetPushedTexture("Interface\\Buttons\\LockButton-Unlocked-Down")
	manualActionsFrame.LockButton:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight", "ADD")			
	manualActionsFrame.LockButton:SetScript("OnClick", function(self, button, down)
		WorldQuestGroupFinder.ToggleFrameLock()
	end)
	if (manualActionsFrame:IsMouseEnabled()) then
		manualActionsFrame.LockButton:SetNormalTexture("Interface\\Buttons\\LockButton-Unlocked-Up")
	else
		manualActionsFrame.LockButton:SetNormalTexture("Interface\\Buttons\\LockButton-Locked-Up")
	end
		
	manualActionsFrame:Hide()	
end

function WorldQuestGroupFinder.InitBlacklists()
	blacklistedQuests = { 
		[45379] = true, -- Treasure Master Iks'reeged  
		[45988] = true, -- Ancient Bones  
		[43943] = true, -- Withered Army Training
		[42725] = true, -- Sharing the Wealth
		[42880] = true, -- Meeting their Quota
		[42178] = true, -- Shock Absorber
		[42173] = true, -- Electrosnack  
		[44011] = true, -- Lost Wisp
		[43774] = true, -- Ley Race
		[43764] = true, -- Ley Race
		[43753] = true, -- Ley Race
		[43325] = true, -- Ley Race
		[43769] = true, -- Ley Race
		[43772] = true, -- Enigmatic
		[43767] = true, -- Enigmatic
		[43756] = true, -- Enigmatic
		[43778] = true, -- Enigmatic
		[45032] = true, -- Like the Wind
		[45046] = true, -- Like the Wind
		[45047] = true, -- Like the Wind
		[45048] = true, -- Like the Wind
		[45049] = true, -- Like the Wind
		[45068] = true, -- Barrels o' fun
		[45069] = true, -- Barrels o' fun
		[45070] = true, -- Barrels o' fun
		[45071] = true, -- Barrels o' fun
		[45072] = true, -- Barrels o' fun
		[44786] = true, -- Midterm: Rune Aptitude
		[41327] = true, -- Supplies Needed: Stormscales
		[41345] = true, -- Supplies Needed: Stormscales
		[41318] = true, -- Supplies Needed: Felslate
		[41237] = true, -- Supplies Needed: Stonehide Leather
		[41339] = true, -- Supplies Needed: Stonehide Leather
		[41351] = true, -- Supplies Needed: Stonehide Leather
		[41207] = true, -- Supplies Needed: Leystone
		[41298] = true, -- Supplies Needed: Fjarnskaggl
		[41315] = true, -- Supplies Needed: Leystone
		[41316] = true, -- Supplies Needed: Leystone
		[41317] = true, -- Supplies Needed: Leystone
		[41303] = true, -- Supplies Needed: Starlight Roses
		[41288] = true, -- Supplies Needed: Aethril
		[44932] = true, -- The Nighthold: Ettin Your Foot In The Door
		[44937] = true, -- The Nighthold: Focused Power
		[44934] = true, -- The Nighthold: Creepy Crawlers
		[44935] = true, -- The Nighthold: Gilded Guardian
		[44938] = true, -- The Nighthold: Love Tap
		[44939] = true, -- The Nighthold: Seeds of Destruction
		[44936] = true, -- The Nighthold: Supply Routes
		[44933] = true, -- The Nighthold: Wailing In The Night
	}

	-- Quests you can complete while in a raid
	raidQuests = { 
		[42820] = true, -- DANGER: Aegir Wavecrusher
		[41685] = true, -- DANGER: Ala'washte
		[44113] = true, -- DANGER: Anachronos
		[43091] = true, -- DANGER: Arcanor Prime
		[44118] = true, -- DANGER: Auditor Esiel
		[44121] = true, -- DANGER: Az'jatar
		[44189] = true, -- DANGER: Bestrix
		[42861] = true, -- DANGER: Boulderfall, the Eroded
		[42864] = true, -- DANGER: Captain Dargun
		[43121] = true, -- DANGER: Chief Treasurer Jabrill
		[41697] = true, -- DANGER: Colerian, Alteria, and Selenyi
		[43175] = true, -- DANGER: Deepclaw
		[41695] = true, -- DANGER: Defilia
		[42785] = true, -- DANGER: Den Mother Ylva
		[41093] = true, -- DANGER: Durguth
		[43346] = true, -- DANGER: Ealdis
		[43059] = true, -- DANGER: Fjordun
		[42806] = true, -- DANGER: Fjorlag, the Grave's Chill
		[43345] = true, -- DANGER: Harbinger of Screams
		[43079] = true, -- DANGER: Immolian
		[44190] = true, -- DANGER: Jade Darkhaven
		[44191] = true, -- DANGER: Karthax
		[43798] = true, -- DANGER: Kosumoth the Hungering
		[42964] = true, -- DANGER: Lagertha
		[44192] = true, -- DANGER: Lysanis Shadesoul
		[43152] = true, -- DANGER: Lytheron
		[44114] = true, -- DANGER: Magistrix Vilessa
		[42927] = true, -- DANGER: Malisandra
		[43098] = true, -- DANGER: Marblub the Massive
		[41696] = true, -- DANGER: Mawat'aki
		[43027] = true, -- DANGER: Mortiferous
		[43333] = true, -- DANGER: Nylaathria the Forgotten
		[41703] = true, -- DANGER: Ormagrogg
		[41816] = true, -- DANGER: Oubdob da Smasher
		[43347] = true, -- DANGER: Rabxach
		[42963] = true, -- DANGER: Rulf Bonesnapper
		[42991] = true, -- DANGER: Runeseer Sigvid
		[42797] = true, -- DANGER: Scythemaster Cil'raman
		[44193] = true, -- DANGER: Sea King Tidross
		[41700] = true, -- DANGER: Shalas'aman
		[44122] = true, -- DANGER: Sorallus
		[42953] = true, -- DANGER: Soulbinder Halldora
		[43072] = true, -- DANGER: The Whisperer
		[44194] = true, -- DANGER: Torrentius
		[43040] = true, -- DANGER: Valakar the Thirsty
		[44119] = true, -- DANGER: Volshax, Breaker of Will
		[43101] = true, -- DANGER: Withdoctor Grgl-Brgl
		[41779] = true, -- DANGER: Xavrix
		[44017] = true, -- WANTED: Apothecary Faldren
		[44032] = true, -- WANTED: Apothecary Faldren
		[42636] = true, -- WANTED: Arcanist Shal'iman
		[43605] = true, -- WANTED: Arcanist Shal'iman
		[42620] = true, -- WANTED: Arcavellus
		[43606] = true, -- WANTED: Arcavellus
		[41824] = true, -- WANTED: Arru
		[44289] = true, -- WANTED: Arru
		[44301] = true, -- WANTED: Bahagar
		[44305] = true, -- WANTED: Bahagar
		[41836] = true, -- WANTED: Bodash the Hoarder
		[43616] = true, -- WANTED: Bodash the Hoarder
		[41828] = true, -- WANTED: Bristlemaul
		[44290] = true, -- WANTED: Bristlemaul
		[43426] = true, -- WANTED: Brogozog
		[43607] = true, -- WANTED: Brogozog
		[42796] = true, -- WANTED: Broodmother Shu'malis
		[44016] = true, -- WANTED: Cadraeus
		[44031] = true, -- WANTED: Cadraeus
		[43430] = true, -- WANTED: Captain Volo'ren
		[43608] = true, -- WANTED: Captain Volo'ren
		[41826] = true, -- WANTED: Crawshuk the Hungry
		[44291] = true, -- WANTED: Crawshuk the Hungry
		[44299] = true, -- WANTED: Darkshade
		[44304] = true, -- WANTED: Darkshade
		[43455] = true, -- WANTED: Devouring Darkness
		[43617] = true, -- WANTED: Devouring Darkness
		[43428] = true, -- WANTED: Doomlord Kazrok
		[43609] = true, -- WANTED: Doomlord Kazrok
		[44298] = true, -- WANTED: Dreadbog
		[44303] = true, -- WANTED: Dreadbog
		[43454] = true, -- WANTED: Egyl the Enduring
		[43620] = true, -- WANTED: Egyl the Enduring
		[43434] = true, -- WANTED: Fathnyr
		[43621] = true, -- WANTED: Fathnyr
		[43436] = true, -- WANTED: Glimar Ironfist
		[43622] = true, -- WANTED: Glimar Ironfist
		[44030] = true, -- WANTED: Guardian Thor'el
		[44013] = true, -- WANTED: Guardian Thor'el
		[41819] = true, -- WANTED: Gurbog da Basher
		[43618] = true, -- WANTED: Gurbog da Basher
		[43453] = true, -- WANTED: Hannval the Butcher
		[43623] = true, -- WANTED: Hannval the Butcher
		[44021] = true, -- WANTED: Hertha Grimdottir
		[44029] = true, -- WANTED: Hertha Grimdottir
		[43427] = true, -- WANTED: Infernal Lord
		[43610] = true, -- WANTED: Infernal Lord
		[43611] = true, -- WANTED: Inquisitor Tivos
		[42631] = true, -- WANTED: Inquisitor Tivos
		[43452] = true, -- WANTED: Isel the Hammer
		[43624] = true, -- WANTED: Isel the Hammer
		[43460] = true, -- WANTED: Kiranys Duskwhisper
		[43629] = true, -- WANTED: Kiranys Duskwhisper
		[44028] = true, -- WANTED: Lieutenant Strathmar
		[44019] = true, -- WANTED: Lieutenant Strathmar
		[44018] = true, -- WANTED: Magister Phaedris
		[44027] = true, -- WANTED: Magister Phaedris
		[41818] = true, -- WANTED: Majestic Elderhorn
		[44292] = true, -- WANTED: Majestic Elderhorn
		[44015] = true, -- WANTED: Mal'Dreth the Corruptor
		[44026] = true, -- WANTED: Mal'Dreth the Corruptor
		[43438] = true, -- WANTED: Nameless King
		[43625] = true, -- WANTED: Nameless King
		[43432] = true, -- WANTED: Normantis the Deposed
		[43612] = true, -- WANTED: Normantis the Deposed
		[41686] = true, -- WANTED: Olokk the Shipbreaker
		[44010] = true, -- WANTED: Oreth the Vile
		[43458] = true, -- WANTED: Perrexx
		[43630] = true, -- WANTED: Perrexx
		[42795] = true, -- WANTED: Sanaar
		[44300] = true, -- WANTED: Seersei
		[44302] = true, -- WANTED: Seersei
		[41844] = true, -- WANTED: Sekhan
		[44294] = true, -- WANTED: Sekhan
		[44022] = true, -- WANTED: Shal'an
		[41821] = true, -- WANTED: Shara Felbreath
		[43619] = true, -- WANTED: Shara Felbreath
		[44012] = true, -- WANTED: Siegemaster Aedrin
		[44023] = true, -- WANTED: Siegemaster Aedrin
		[43456] = true, -- WANTED: Skul'vrax
		[43631] = true, -- WANTED: Skul'vrax
		[41838] = true, -- WANTED: Slumber
		[44293] = true, -- WANTED: Slumber
		[43429] = true, -- WANTED: Syphonus
		[43613] = true, -- WANTED: Syphonus
		[43437] = true, -- WANTED: Thane Irglov
		[43626] = true, -- WANTED: Thane Irglov
		[43457] = true, -- WANTED: Theryssia
		[43632] = true, -- WANTED: Theryssia
		[43459] = true, -- WANTED: Thondrax
		[43633] = true, -- WANTED: Thondrax
		[43450] = true, -- WANTED: Tiptog the Lost
		[43627] = true, -- WANTED: Tiptog the Lost
		[43451] = true, -- WANTED: Urgev the Flayer
		[43628] = true, -- WANTED: Urgev the Flayer
		[42633] = true, -- WANTED: Vorthax
		[43614] = true, -- WANTED: Vorthax
		[43431] = true, -- WANTED: Warbringer Mox'na
		[46945] = true, -- Si'vash
		[47061] = true, -- Apocron
		[46948] = true, -- Malificus
		[42270] = true, -- Scourge of the Skies
		[44287] = true, -- DEADLY: Withered J'im
		[43192] = true, -- Terror of the Deep
		[43448] = true, -- The Frozen King
		[43193] = true, -- Calamitous Intent
		[42779] = true, -- The Sleeping Corruption
		[42269] = true, -- The Soultakers
		[42819] = true, -- Pocket Wizard
		[42270] = true, -- Scourge of the Skies
		[43512] = true, -- Ana-Mouz
		[43985] = true -- A Dark Tide
	}

end