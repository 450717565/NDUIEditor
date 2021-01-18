local _, ns = ...
local B, C, L, DB = unpack(ns)
local Misc = B:GetModule("Misc")

local strmatch, strfind, gsub, format, floor = strmatch, strfind, gsub, format, floor
local wipe, mod, tonumber, pairs, print = wipe, mod, tonumber, pairs, print
local IsPartyLFG, IsInRaid, IsInGroup, PlaySound, SendChatMessage = IsPartyLFG, IsInRaid, IsInGroup, PlaySound, SendChatMessage
local GetQuestLink = GetQuestLink
local C_QuestLog_GetInfo = C_QuestLog.GetInfo
local C_QuestLog_IsComplete = C_QuestLog.IsComplete
local C_QuestLog_IsWorldQuest = C_QuestLog.IsWorldQuest
local C_QuestLog_GetQuestTagInfo = C_QuestLog.GetQuestTagInfo
local C_QuestLog_GetTitleForQuestID = C_QuestLog.GetTitleForQuestID
local C_QuestLog_GetQuestIDForLogIndex = C_QuestLog.GetQuestIDForLogIndex
local C_QuestLog_GetNumQuestLogEntries = C_QuestLog.GetNumQuestLogEntries
local C_QuestLog_GetLogIndexForQuestID = C_QuestLog.GetLogIndexForQuestID
local soundKitID = SOUNDKIT.ALARM_CLOCK_WARNING_3
local DAILY, QUEST_COMPLETE = DAILY, QUEST_COMPLETE
local LE_QUEST_TAG_TYPE_PROFESSION = Enum.QuestTagType.Profession
local LE_QUEST_FREQUENCY_DAILY = Enum.QuestFrequency.Daily

local debugMode = false
local completedQuest, initComplete = {}

local function GetQuestLinkOrName(questID)
	return GetQuestLink(questID) or C_QuestLog_GetTitleForQuestID(questID) or ""
end

local function acceptText(questID, daily)
	local title = GetQuestLinkOrName(questID)
	if daily then
		return format("%s [%s]%s", L["AcceptQuest"], DAILY, title)
	else
		return format("%s %s", L["AcceptQuest"], title)
	end
end

local function completeText(questID)
	PlaySound(soundKitID, "Master")
	return format("%s %s", GetQuestLinkOrName(questID), QUEST_COMPLETE)
end

local function sendQuestMsg(msg)
	if C.db["Misc"]["OnlyCompleteRing"] then return end

	if debugMode and DB.isDeveloper then
		print(msg)
	elseif IsPartyLFG() then
		SendChatMessage(msg, "INSTANCE_CHAT")
	elseif IsInRaid() then
		SendChatMessage(msg, "RAID")
	elseif IsInGroup() then
		SendChatMessage(msg, "PARTY")
	end
end

local function getPattern(pattern)
	pattern = gsub(pattern, "%(", "%%%1")
	pattern = gsub(pattern, "%)", "%%%1")
	pattern = gsub(pattern, "%%%d?$?.", "(.+)")
	return format("^%s$", pattern)
end

local questMatches = {
	["Found"] = getPattern(ERR_QUEST_ADD_FOUND_SII),
	["Item"] = getPattern(ERR_QUEST_ADD_ITEM_SII),
	["Kill"] = getPattern(ERR_QUEST_ADD_KILL_SII),
	["PKill"] = getPattern(ERR_QUEST_ADD_PLAYER_KILL_SII),
	["ObjectiveComplete"] = getPattern(ERR_QUEST_OBJECTIVE_COMPLETE_S),
	["QuestComplete"] = getPattern(ERR_QUEST_COMPLETE_S),
	["QuestFailed"] = getPattern(ERR_QUEST_FAILED_S),
}

function Misc:FindQuestProgress(_, msg)
	if not C.db["Misc"]["QuestProgress"] then return end
	if C.db["Misc"]["OnlyCompleteRing"] then return end

	for _, pattern in pairs(questMatches) do
		if strmatch(msg, pattern) then
			local _, _, _, cur, max = strfind(msg, "(.*)[:：]%s*([-%d]+)%s*/%s*([-%d]+)%s*$")
			cur, max = tonumber(cur), tonumber(max)
			if cur and max and max >= 10 then
				if mod(cur, floor(max/5)) == 0 then
					sendQuestMsg(msg)
				end
			else
				sendQuestMsg(msg)
			end
			break
		end
	end
end

function Misc:FindQuestAccept(questID)
	local tagInfo = C_QuestLog_GetQuestTagInfo(questID)
	if tagInfo and tagInfo.worldQuestType == LE_QUEST_TAG_TYPE_PROFESSION then return end

	local questLogIndex = C_QuestLog_GetLogIndexForQuestID(questID)
	if questLogIndex then
		local info = C_QuestLog_GetInfo(questLogIndex)
		if info then
			sendQuestMsg(acceptText(questID, info.frequency == LE_QUEST_FREQUENCY_DAILY))
		end
	end
end

function Misc:FindQuestComplete()
	for i = 1, C_QuestLog_GetNumQuestLogEntries() do
		local questID = C_QuestLog_GetQuestIDForLogIndex(i)
		local isComplete = questID and C_QuestLog_IsComplete(questID)
		if isComplete and not completedQuest[questID] and not C_QuestLog_IsWorldQuest(questID) then
			if initComplete then
				sendQuestMsg(completeText(questID))
			end
			completedQuest[questID] = true
		end
	end
	initComplete = true
end

function Misc:FindWorldQuestComplete(questID)
	if C_QuestLog_IsWorldQuest(questID) then
		if questID and not completedQuest[questID] then
			sendQuestMsg(completeText(questID))
			completedQuest[questID] = true
		end
	end
end

function Misc:QuestNotification()
	if C.db["Misc"]["QuestNotification"] then
		B:RegisterEvent("QUEST_ACCEPTED", Misc.FindQuestAccept)
		B:RegisterEvent("QUEST_LOG_UPDATE", Misc.FindQuestComplete)
		B:RegisterEvent("QUEST_TURNED_IN", Misc.FindWorldQuestComplete)
		B:RegisterEvent("UI_INFO_MESSAGE", Misc.FindQuestProgress)
	else
		wipe(completedQuest)
		B:UnregisterEvent("QUEST_ACCEPTED", Misc.FindQuestAccept)
		B:UnregisterEvent("QUEST_LOG_UPDATE", Misc.FindQuestComplete)
		B:UnregisterEvent("QUEST_TURNED_IN", Misc.FindWorldQuestComplete)
		B:UnregisterEvent("UI_INFO_MESSAGE", Misc.FindQuestProgress)
	end
end
Misc:RegisterMisc("QuestNotification", Misc.QuestNotification)