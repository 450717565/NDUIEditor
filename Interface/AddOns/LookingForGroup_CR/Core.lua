local LookingForGroup = LibStub("AceAddon-3.0"):GetAddon("LookingForGroup")
local LookingForGroup_CR = LibStub("AceAddon-3.0"):NewAddon("LookingForGroup_CR","AceEvent-3.0","AceTimer-3.0")

local function print_result(tb)
	local tb2 = {}
	local k,v
	local num = 0
	local table_insert = table.insert
	for k,v in pairs(tb) do
		table_insert(tb2,{k,v})
		num = num + v
	end
	table.sort(tb2,function(a,b) return b[2] < a[2]; end)
	if num == 0 then
		LookingForGroup:Print(UNKNOWN)
	else
		local n = #tb2
		local string_format = string.format
		LookingForGroup:Print(KBASE_SEARCH_RESULTS)
		for i = 1, n do
			local ti = tb2[i]
			LookingForGroup:Print(i,ti[1],string_format("%.0f%%",100 * ti[2]/num))
			if i < n and tb2[i+1][2]*2 < ti[2] then
				break
			end
		end
	end
end

local log_tb = {}
local player_realm = GetRealmName()
local event_counter = 0

local function add_to_log_tb(uid,name)
	if not string.find(uid,"Player") or UnitGUID("player") == uid then
		return
	end
	local realm = string.match(name,"-(.*)$")
	if realm == nil then
		realm = player_realm
	end
	if log_tb[realm] == nil then
		log_tb[realm] = 1
	else
		log_tb[realm] = log_tb[realm] + 1
	end
	event_counter = event_counter + 1
end

function LookingForGroup_CR:COMBAT_LOG_EVENT_UNFILTERED(...)
	add_to_log_tb(select(5, ...))
	add_to_log_tb(select(9, ...))
	if 50 < event_counter then
		self:TimerFeedback()
	end
end

function LookingForGroup_CR:TimerFeedback()
	self:UnregisterEvent("WHO_LIST_UPDATE")
	self:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	print_result(log_tb)
	wipe(log_tb)
	event_counter = 0
	if LookingForGroup_CR.timer ~= nil then
		self:CancelTimer(LookingForGroup_CR.timer)
		LookingForGroup_CR.timer = nil
	end
end

function LookingForGroup_CR:WHO_LIST_UPDATE()
	self:UnregisterEvent("WHO_LIST_UPDATE")
	local i
	local numwho = GetNumWhoResults()
	local tb = {}
	local GetWhoInfo = GetWhoInfo
	local string_match = string.match
	local table_insert = table.insert
	local all_player_realm = true
	for i = 1,numwho do
		local name = GetWhoInfo(i)
		local realm = string_match(name,"-(.*)$")
		if realm == nil then
			realm = player_realm
		else
			all_player_realm = false
		end
		local tbs = tb[realm]
		if tbs == nil then
			tb[realm] = 1
		else
			tb[realm] = tbs + 1
		end
	end
	if not all_player_realm then
		LookingForGroup_CR:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		if LookingForGroup_CR.timer ~= nil then
			self:CancelTimer(LookingForGroup_CR.timer)
			LookingForGroup_CR.timer = nil
		end
		print_result(tb)
	end
end

function LookingForGroup_CR.do_scan()
	local name, t = GetInstanceInfo()
	if t == "none" then
		if LookingForGroup_CR.timer ~= nil then
			LookingForGroup_CR:CancelTimer(LookingForGroup_CR.timer)
			LookingForGroup_CR.timer = LookingForGroup_CR:ScheduleTimer("TimerFeedback", 20)
			LookingForGroup_CR:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		end
		LookingForGroup:Print(SEARCHING)
		wipe(log_tb)
		event_counter = 0
		LookingForGroup_CR.timer = LookingForGroup_CR:ScheduleTimer("TimerFeedback", 20)
		LookingForGroup_CR:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		LookingForGroup_CR:RegisterEvent("WHO_LIST_UPDATE")
		SendWho("z-\""..GetZoneText().."\"")
	else
		LookingForGroup:Print(INSTANCE)
	end
end

function LookingForGroup_CR:OnInitialize()
end

function LookingForGroup_CR:OnEnable()
	FriendsFrame:UnregisterEvent("WHO_LIST_UPDATE")
	SetWhoToUI(0)
end
