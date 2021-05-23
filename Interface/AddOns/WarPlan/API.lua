local W, ADDON, T, EV, C = {}, ...
local Nine = T.Nine or _G
EV, T.WrappedAPI, C = T.Evie, W, Nine.C_Garrison

W.MECHANIC_ISSPEC = { [138]=true, [149]=true, [147]=true }
W.MECHANIC_ICONS = {
	[138]=133869,
	[142]=132226,
	[143]=236201,
	[144]=132269,
	[147]=1398088,
	[149]=615342,
}
W.CURRENCY_FACTION_ID = {
	[1579]=2164, -- Champions of Azeroth
	[1598]=2163, -- Tortollan Seekers
	
	[1592]=2161, -- Order of Embers
	[1593]=2160, -- Proudmoore Admiralty
	[1594]=2162, -- Storm's Wake
	[1599]=2159, -- 7th Legion
	
	[1595]=2156, -- Talanji's Expedition
	[1596]=2158, -- Voldunai
	[1597]=2103, -- Zandalari Empire
	[1600]=2157, -- The Honorbound
}
local MECHANIC_COUNTERS = {
	[143]=1083,
	[144]=1084,
	[142]=1085,
}
local ABILITY_GROUP_BIAS = {
	[1149]= 4, -- Ink Well
	[1152]= 4, -- Herb Tracking
	[1147]= 4, -- Magnetic Mining Pick
	[1155]=-2, -- Whetstone
	[1156]= 0, -- Spurs
	[1153]= 4, -- Azerite
	[1154]= 4, -- Fish
	[1157]=-2, -- Rallying Horn
	[1146]= 4, -- Tempest Hide
	[1150]= 4, -- Kaleidoscopic Lens
	[1151]= 4, -- Linen
	[1148]= 4, -- Disenchanting
}
local MISSION_ACHIEVEMENTS = {
	12896, 12898, 12899, -- Alliance
	12869, 12870, 12867, -- Horde
}
local MAX_CHAMPION_QUALITY = 5

-- 654321  098765  432 109  876 543  210 987  654 32 10
-- CHAMPS  RESERV  DUR LCC  DUR LCC  DUR LCC  DUR TC HC
local GM_DUR_SM = 2^4
local GM_BASE_SM = 2^7
local GM_COUNTER_WM = 2^6
local GM_CHAMP_SM = GM_BASE_SM*GM_COUNTER_WM^4

local LETHAL_MECHANIC = 1080
local GROUP_TIME_IDX = 4
local GROUP_COST_IDX = 5
local GROUP_TAG_IDX = 6
local GROUP_LETHAL_IDX = 7
local GROUP_TRAIT_BIAS = 8
local GROUP_FOLLOWER_BASE = 8
local GROUP_FOLLOWER_1 = GROUP_FOLLOWER_BASE+1
local GROUP_FOLLOWER_2 = GROUP_FOLLOWER_BASE+2
local GROUP_FOLLOWER_3 = GROUP_FOLLOWER_BASE+3
local SAVED_PC_STORE = "WarPlanDataPC"

local missionCreditCriteria = {} -- Achievement credit cache
local followerWaitingTimes = {} -- Suggested group cache
local suggestionResults, suggestionComparators = {[0]={}}, {}
local fsInfo = {missions={}, followerMission={}} -- Fast mission start
local rsInfo = {missions={}, followerMission={}, mcTags={}, curTag=1} -- Tentative Parties
local ipLethalCache, ipTags, ipCurTag = {}, {}, 1 -- Lethal missions
local draftCompletionEntries = {} -- Unsaved completion log entries
local startQueue, startQueueSize = {}, 0

local function isEquivalentGroup(a,b)
	return a == b or (a and b and a[1] == b[1] and a[GROUP_TAG_IDX] == b[GROUP_TAG_IDX])
end
local function dissolveTentativeGroupHelper(mid)
	if rsInfo.missions[mid] then
		local f = rsInfo.followerMission
		for k,v in pairs(f) do
			if v == mid then
				f[k] = nil
			end
		end
		rsInfo.missions[mid] = nil
	end
end
local function cmpAvailMission(a,b)
	local ae, be = a.tooExpensive, b.tooExpensive
	if (not ae) ~= (not be) then
		return not ae
	elseif ae and be and ae ~= be then
		return ae < be
	elseif a.totalRewardScore ~= b.totalRewardScore then
		return a.totalRewardScore > b.totalRewardScore
	elseif a.offerTimeLeft ~= b.offerTimeLeft then
		return a.offerTimeLeft and b.offerTimeLeft and a.offerTimeLeft < b.offerTimeLeft or (b.offerTimeLeft == nil and a.offerTimeLeft ~= nil)
	elseif a.isRare ~= b.isRare then
		return a.isRare
	elseif (a.achievementID and not a.achievementComplete) ~= (b.achievementID and not b.achievementComplete) then
		return a.achievementID and not a.achievementComplete
	elseif a.missionID ~= b.missionID then
		return a.missionID > b.missionID
	end
end
local function cmpInProgressMission(a, b)
	if a.readyAt ~= b.readyAt then
		return a.readyAt == nil or (b.readyAt and a.readyAt < b.readyAt)
	elseif a.missionID ~= b.missionID then
		return a.missionID > b.missionID
	end
end
local function startMissionWithParty(mid, g)
	local f1, f2, f3 = W.GetGroupMembers(g)
	local mi = C.GetBasicMissionInfo(mid)
	if not mi then
		return false
	end
	for j=1,mi.followers and #mi.followers or 0 do
		C.RemoveFollowerFromMission(mid, mi.followers[j])
	end
	local ok = C.AddFollowerToMission(mid, f1)
	           and (f2 == nil or C.AddFollowerToMission(mid, f2))
	           and (f3 == nil or C.AddFollowerToMission(mid, f3))
	if not ok then
		return false
	end
	fsInfo.missions[mid] = {time()+select(2,C.GetPartyMissionInfo(mid)), time(), f1, f2, f3}
	fsInfo.followerMission[f1 or ""], fsInfo.followerMission[f2 or ""], fsInfo.followerMission[f3 or ""] = mid, mid, mid
	fsInfo.followerMission[""] = nil
	C.StartMission(mid)
	return true
end
local function startQueuePing()
	if next(startQueue) then
		C_Timer.After(0.5, startQueuePing)
	end
	local ne = startQueueSize
	W.SuppressFollowerEvents(22)
	for mid, g in pairs(startQueue) do
		if not startMissionWithParty(mid, g) then
			startQueueSize, startQueue[mid] = startQueueSize - 1, nil
		end
	end
	W.ReleaseFollowerEvents(22)
	if ne ~= startQueueSize then
		EV("I_MISSION_START_QUEUE", startQueueSize)
	end
end
local function cmpFollowerBaseID(a,b)
	if a.isTroop ~= b.isTroop then
		return b.isTroop
	end
	return (a.garrFollowerID or a.followerID) < (b.garrFollowerID or b.followerID)
end
local function cmpFollower(a,b)
	if a.isCollected ~= b.isCollected then
		return a.isCollected
	elseif a.troopAbility ~= b.troopAbility then
		return a.troopAbility == nil or (b.troopAbility and a.troopAbility < b.troopAbility)
	elseif a.missionTimeLeft ~= b.missionTimeLeft then
		return b.missionTimeLeft == nil or (a.missionTimeLeft and a.missionTimeLeft > b.missionTimeLeft)
	elseif a.isEffectivelyDead ~= b.isEffectivelyDead then
		return b.isEffectivelyDead
	elseif a.isTroop and a.durability ~= b.durability then
		return a.durability > b.durability
	else
		local fm = rsInfo.followerMission
		local am, bm = fm[a.followerID], fm[a.followerID]
		if (not am) ~= (not bm) then
			return not am
		elseif am ~= bm then
			am, bm = fsInfo.missions[am][GROUP_TIME_IDX], fsInfo.missions[bm][GROUP_TIME_IDX]
			if am ~= bm then
				return am < bm
			end
		end
	end
	return (a.garrFollowerID or a.followerID) < (b.garrFollowerID or b.followerID)
end
local function PackRewards(mi)
	local r1, r2
	for j=1,mi and 2 or 0 do
		local rewards, p = mi[j == 1 and "rewards" or "overmaxRewards"], nil
		if rewards then
			for _, v in pairs(rewards) do
				local q = v.quantity or 0
				if v.currencyID == 0 then
					p = 2 + q*2^3
				elseif v.currencyID then
					p = 1 + v.currencyID*2^3 + q*2^24
				elseif v.itemID then
					p = 3 + v.itemID*2^3 + q*2^24
				else
					p = 0 + q*2^24
				end
			end
		end
		r1, r2 = r2, p
	end
	return r1, r2
end
local function GetMissionHistory(create)
	local pcData = _G[SAVED_PC_STORE]
	if create then
		if type(pcData) ~= "table" then
			pcData = {}
			_G[SAVED_PC_STORE] = pcData
		end
		if type(pcData.History) ~= "table" then
			pcData.History = {}
		end
		return pcData.History
	else
		return type(pcData) == "table" and type(pcData.History) == "table" and pcData.History
	end
end
local function AddToMissionLog(info)
	local log = GetMissionHistory(true)
	log[#log+1] = info
	EV("I_MISSION_LOG_UPDATED")
end
local function LogMissionCompletion(mid, baseOK, brOK, chance, r1, r2)
	local e = {GetServerTime(), mid, chance, baseOK, brOK, r1 or (r2 and 0 or nil), r2}
	if baseOK then
		-- Succeeded missions aren't "done" until GMBRC comes back, so don't log it yet
		draftCompletionEntries[mid] = e
	else
		-- Failures are final
		AddToMissionLog(e)
	end
end

function W.GetGroupMembers(g)
	if g then
		return g[GROUP_FOLLOWER_1], g[GROUP_FOLLOWER_2], g[GROUP_FOLLOWER_3]
	end
end
function W.GetGroupInfo(g) -- success, baseXP, chestXP, time, cost, tag, isLethal, groupBias
	if g then
		return unpack(g, 1, GROUP_FOLLOWER_BASE)
	end
end
function W.GetTimeStringFromSeconds(sec, shorter, roundUp, disallowSeconds)
	local h = roundUp and math.ceil or math.floor
	if sec < 90 and not disallowSeconds then
		return (shorter and COOLDOWN_DURATION_SEC or GARRISON_DURATION_SECONDS):format(sec < 0 and 0 or h(sec))
	elseif sec < 3600*3 and (sec % 3600 >= 1) then
		return (shorter and COOLDOWN_DURATION_MIN or GARRISON_DURATION_MINUTES):format(h(sec/60))
	elseif sec < 3600*72 then
		return (shorter and COOLDOWN_DURATION_HOURS or GARRISON_DURATION_HOURS):format(h(sec/3600))
	else
		return (shorter and COOLDOWN_DURATION_DAYS or GARRISON_DURATION_DAYS):format(h(sec/84600))
	end
end
function W.GetLazyTimeStringFromSeconds(sec, roundUp)
	local h = roundUp and math.ceil or math.floor
	if sec < 3600 and (sec % 3600 ~= 0) then
		return GARRISON_DURATION_MINUTES:format(h(sec/60))
	elseif sec < 84600 then
		return GARRISON_DURATION_HOURS:format(h(sec/3600))
	elseif sec < 3e6 then
		return GARRISON_DURATION_DAYS:format(h(sec/84600))
	else
		return ""
	end
end
function W.GetMissionLethalMask(mid, enemies)
	if mid and enemies == nil then
		enemies = select(8, C.GetMissionInfo(mid))
	end
	local le1, le2
	for i=1,type(enemies) == "table" and #enemies or 0 do
		local mech = enemies[i].mechanics
		for i=1,type(mech) == "table" and #mech or 0 do
			local v = mech[i]
			local k = v.mechanicTypeID
			local c = MECHANIC_COUNTERS[k]
			if c and type(v.ability) == "table" and v.ability.id == LETHAL_MECHANIC then
				le1, le2 = c, le1
			end
		end
	end
	return (le1 and GM_BASE_SM*GM_COUNTER_WM^(le1-1083) or 0) + (le2 and GM_BASE_SM*GM_COUNTER_WM^((le2 or 0)-1083) or 0)
end

function W.AddMissionAchievementInfo(missions)
	if not missions or #missions == 0 then
		return missions
	end
	if not next(missionCreditCriteria) then
		local isHorde = UnitFactionGroup("player") == "Horde"
		for i=isHorde and 4 or 1,isHorde and 6 or 3 do
			local aid = MISSION_ACHIEVEMENTS[i]
			for i=1,GetAchievementNumCriteria(aid) do
				local _, ct, com, _, _, _, _, asid, _, cid = GetAchievementCriteriaInfo(aid, i)
				if ct == 174 and asid then
					missionCreditCriteria[asid] = aid*2 + cid*1e6 + (com and 1 or 0)
				end
			end
		end
	end
	if next(missionCreditCriteria) and missions then
		for i=1,#missions do
			local mi = missions[i]
			local mid = mi.missionID
			local ai = missionCreditCriteria[mid]
			if ai then
				mi.achievementID = math.floor(ai % 1e6 / 2)
				if ai % 2 == 1 then
					mi.achievementComplete = true
				else
					local cid = math.floor(ai / 1e6)
					local _, _, isComplete = GetAchievementCriteriaInfoByID(mi.achievementID, cid)
					mi.achievementComplete, missionCreditCriteria[mid] = isComplete, isComplete and ai + 1 or ai
				end
			end
		end
	end
	return missions
end
function W.GetAvailableMissions(mtype, inProgressMissions, followerMissionInfo)
	local r = C.GetAvailableMissions(mtype) or {}
	W.ObserveAvailableMissions(r)
	if inProgressMissions and next(fsInfo.missions) then
		local ni, fsMissions = 1, fsInfo.missions
		for i=1,#r do
			local m = r[i]
			local mid = m.missionID
			local fsEntry = fsMissions[mid]
			if fsEntry then
				inProgressMissions[#inProgressMissions+1] = m
				m.timeLeftSeconds = fsEntry[1]-time()
				m.inProgress, m.isFakeStart = true, true
				for i=2,#fsEntry do
					followerMissionInfo[fsEntry[i]] = m
				end
			else
				r[ni], ni = r[i], ni + 1
			end
		end
		for i=ni,#r do
			r[i] = nil
		end
	end
	local _, cres = Nine.GetCurrencyInfo(1560)
	for i=1,#r do
		local e = r[i]
		for j=1,2 do
			local er = e[j == 1 and "rewards" or "overmaxRewards"]
			local er1 = er and er[1]
			local ecid = er1 and er1.currencyID
			local rq = er1 and 4 or 0
			if ecid == 0 then
				rq = 2
			elseif ecid then
				local fid = W.CURRENCY_FACTION_ID[ecid]
				if fid and not C_Reputation.IsFactionParagon(fid) then
					local _, _, stID = GetFactionInfoByID(fid)
					if stID == 8 then
						rq = 0
					end
				end
			elseif not er then
				rq = 0
			end
			rq = rq > 0 and er1 and er1.quantity and (rq + (1 - 1/(1+er1.quantity))/4) or rq
			e[j == 1 and "rewardScore" or "overmaxRewardScore"] = rq
		end
		local cost = e.basecost or e.cost
		e.tooExpensive = cres and cost and (cres < cost) and cost
		e.totalRewardScore = e.rewardScore + e.overmaxRewardScore
	end
	W.AddMissionAchievementInfo(r)
	table.sort(r, cmpAvailMission)
	if inProgressMissions then
		local now = GetTime()
		for i=1,#inProgressMissions do
			local m = inProgressMissions[i]
			m.readyAt = m.timeLeftSeconds and (now + m.timeLeftSeconds) or nil
		end
		W.AddMissionAchievementInfo(inProgressMissions)
		table.sort(inProgressMissions, cmpInProgressMission)
	end
	return r
end
function W.GetMissionTableInfo(mtype)
	local followerMissionInfo, inProgressMissions, completeMissions = W.GetFollowersMissionInfo(mtype)
	for i=1,#completeMissions do
		local mid = completeMissions[i].missionID
		for j=1,#inProgressMissions do
			if inProgressMissions[j].missionID == mid then
				mid = nil
				break
			end
		end
		if mid then
			inProgressMissions[#inProgressMissions+1] = completeMissions[i]
		end
	end
	local availableMissions = W.GetAvailableMissions(mtype, inProgressMissions, followerMissionInfo)
	local followers = W.GetFollowers(mtype, followerMissionInfo) or {}
	return availableMissions, inProgressMissions, completeMissions, followers, followerMissionInfo
end
function W.GetFollowersMissionInfo(mtype, inProgressMissions, completeMissions)
	inProgressMissions = inProgressMissions or C.GetInProgressMissions(mtype) or {}
	completeMissions = completeMissions or C.GetCompleteMissions(mtype) or {}
	local followerMissionInfo, a = {}, inProgressMissions
	for _=1,2 do
		for i=1,#a do
			local m = a[i]
			local a = m.followers
			for i=1,a and #a or 0 do
				followerMissionInfo[a[i]] = m
			end
		end
		a = completeMissions
	end
	return followerMissionInfo, inProgressMissions, completeMissions
end

function W.IsStartingMissions()
	return next(startQueue) ~= nil and startQueueSize or 0
end
function W.StopStartingMissions()
	for k in pairs(startQueue) do
		startQueue[k] = nil
	end
	startQueueSize = 0
	wipe(fsInfo.missions)
	wipe(fsInfo.followerMission)
	EV("I_MISSION_START_QUEUE", startQueueSize)
end
function W.StartTentativeGroups()
	if next(startQueue) ~= nil then
		return
	end
	startQueueSize = 0
	for mid,g in pairs(rsInfo.missions) do
		startQueue[mid], startQueueSize = g, startQueueSize + 1
	end
	startQueuePing()
end
function W.EnqueueMissionStart(mid, g)
	if startQueue[mid] then
		error("Already starting a group for this mission")
	end
	startQueue[mid], startQueueSize = g, startQueueSize + 1
	if startQueueSize == 1 then
		startQueuePing()
	else
		startMissionWithParty(mid, g)
	end
	EV("I_MISSION_START_QUEUE", startQueueSize)
	EV("I_MANUAL_MISSION_START", mid, g[GROUP_FOLLOWER_1], g[GROUP_FOLLOWER_2], g[GROUP_FOLLOWER_3])
end
function W.HasTentantiveGroups()
	return next(rsInfo.missions) ~= nil
end
function W.SetTentativeGroup(mid, g)
	local m, f = rsInfo.missions, rsInfo.followerMission
	if m[mid] and g and (m[mid] == g or m[mid][GROUP_TAG_IDX] == g[GROUP_TAG_IDX]) then
		g = nil
	end
	dissolveTentativeGroupHelper(mid)
	if g then
		m[mid] = g
		for i=1,3 do
			local fid = g[GROUP_FOLLOWER_BASE+i]
			if fid and f[fid] then
				dissolveTentativeGroupHelper(f[fid])
			end
			if fid then
				f[fid] = mid
			end
		end
	else
		m[mid] = nil
	end
	EV("I_UPDATE_TENTATIVE_GROUP", mid, g and g[GROUP_FOLLOWER_1], g and g[GROUP_FOLLOWER_2], g and g[GROUP_FOLLOWER_3])
end
function W.GetTentativeGroup(mid)
	return rsInfo.missions[mid]
end
function W.GetFollowerTentativeGroup(fid)
	return rsInfo.followerMission[fid]
end
function W.TentativeGroups(_, k)
	local gid, g = next(rsInfo.missions, k)
	if gid then
		return gid, g[1]
	end
end
function W.ClearTentativeGroups()
	rsInfo = {missions={}, followerMission={}, mcTags={}, curTag=1}
	EV("I_UPDATE_TENTATIVE_GROUP")
end
function W.ObserveAvailableMissions(arr)
	local changed, nT = false, rsInfo.curTag % 2 + 1
	local h, m, f = rsInfo.mcTags, rsInfo.missions, rsInfo.followerMission
	for i=1,#arr do
		local mid = arr[i].missionID
		if h[mid] then
			h[mid] = nT
		end
	end
	for k,v in pairs(h) do
		if v ~= nT then
			changed, h[k], m[k] = true, nil
		end
	end
	rsInfo.curTag = nT
	if changed then
		for k,v in pairs(f) do
			if not h[v] then
				f[k] = nil
			end
		end
	end
end

function W.GetFollowers(mtype, followerMissionInfo)
	local followers = C.GetFollowers(mtype)
	table.sort(followers, cmpFollowerBaseID)
	for i=1,#followers do
		local fi = followers[i]
		local fid = fi.followerID
		local mGroup = followerMissionInfo and followerMissionInfo[fid]
		if fi.status == GARRISON_FOLLOWER_ON_MISSION then
			local fmid = mGroup and followerMissionInfo[fid].missionID
			fi.missionTimeLeft = C.GetFollowerMissionTimeLeftSeconds(fid)
			fi.missionID = fmid
		end
		if fi.isTroop then
			local m, d, ab = 0, fi.durability, C.GetFollowerAbilityAtIndex(fid, 1)
			if ab >= 1083 and ab <= 1085 then
				m, fi.troopAbility = GM_COUNTER_WM^(ab-1083), ab
			else
				m = GM_COUNTER_WM^3
			end
			fi.tag = GM_BASE_SM*m*(d*8-8 + 3) + GM_DUR_SM*(d - 1) + 5
			fi.groupBias = d == 1 and (C.GetFollowerAbilityAtIndex(fid, 2) ~= 0 and -0.125 or 0.125) or 0
		else
			fi.tag = GM_CHAMP_SM * 2^(i-1) + 1
			fi.groupBias = fi.isCollected and (0
			             + (ABILITY_GROUP_BIAS[C.GetFollowerTraitAtIndex(fid, 1)] or 0)
			             + (ABILITY_GROUP_BIAS[C.GetFollowerTraitAtIndex(fid, 2)] or 0)
			             + (fi.quality < MAX_CHAMPION_QUALITY and 2 or 0)
			             ) or 0
		end
		if mGroup then
			mGroup.groupTag = (mGroup.groupTag or 0) + fi.tag
		end
	end
	if followerMissionInfo then
		local band, iNT = bit.band, ipCurTag % 2 + 1
		for i=1,#followers do
			local fi = followers[i]
			local fmid = fi.isTroop and fi.missionID
			local mGroup = followerMissionInfo[fi.followerID]
			if fmid then
				local lethalThreat = ipLethalCache[fmid]
				if lethalThreat == nil or ipTags[fmid] ~= ipCurTag then
					lethalThreat = W.GetMissionLethalMask(fmid)
				end
				ipLethalCache[fmid], ipTags[fmid] = lethalThreat, iNT
				fi.isEffectivelyDead = lethalThreat > 0 and band(lethalThreat, mGroup.groupTag or 0) ~= lethalThreat or (fi.durability == 1)
			end
		end
		ipCurTag = iNT
		for k,v in pairs(ipTags) do
			if v ~= iNT then
				ipTags[k], ipLethalCache[k] = nil
			end
		end
	end
	table.sort(followers, cmpFollower)
	return followers
end

do -- CompleteMissions/StopCompletingMissions/IsCompletingMissions
	local curStack, curRewards, curFollowers, curCallback, curOverflow
	local curState, curIndex, completionStep, lastAction, delayIndex, delayMID
	local delayOpen, delayRoll do
		local function delay(state, f, d)
			local function delay(minDelay)
				if curState == state and curIndex == delayIndex and curStack[delayIndex].missionID == delayMID then
					local time = GetTime()
					if not minDelay and (not lastAction or (time-lastAction >= d)) then
						lastAction = GetTime()
						f(curStack[curIndex].missionID)
						C_Timer.After(d, delay)
					else
						C_Timer.After(math.max(0.1, d + lastAction - time, minDelay or 0), delay)
					end
				end
			end
			return delay
		end
		delayOpen = delay("COMPLETE", C.MarkMissionComplete, 0.4)
		delayRoll = delay("BONUS", C.MissionBonusRoll, 0.4)
	end
	local function delayStep()
		completionStep("GARRISON_MISSION_NPC_OPENED")
	end
	local function delayDone()
		if curState == "ABORT" or curState == "DONE" then
			local a,b,c,d,e,f = curCallback, curState, curStack, curRewards, curFollowers, curOverflow
			curState, curStack, curRewards, curFollowers, curIndex, curCallback, delayMID, delayIndex = nil
			securecall(a,b,c,d,e,f)
		end
	end

	local function whineAboutUnexpectedState(msg, mid, suf)
		local et = msg .. ": " .. tostring(mid) .. tostring(suf or "") .. " does not fit (" .. curIndex .. ";"
		for i=1,#curStack do
			local e = curStack[i]
			et = et .. " " .. tostring(e and e.missionID or "?") .. (e and e.skipped and "S" or "") .. (e and e.failed and "F" or "")
		end
		return et .. ")"
	end
	function completionStep(ev, ...)
		if not curState then return end
		local mi = curStack[curIndex]
		while mi and (mi.succeeded or mi.failed) do
			mi, curIndex = curStack[curIndex+1], curIndex + 1
		end
		if (ev == "GARRISON_MISSION_NPC_CLOSED" and mi) or not mi then
			curState = mi and "ABORT" or "DONE"
			C_Timer.After(... == "IMMEDIATE" and 0 or 0.1, delayDone)
		elseif curState == "NEXT" and ev == "GARRISON_MISSION_NPC_OPENED" then
			mi.successChance = mi.successChance or C.GetMissionSuccessChance(mi.missionID)
			if mi.completed then
				curState, delayIndex, delayMID = "BONUS", curIndex, mi.missionID
				delayRoll(... ~= "IMMEDIATE" and 0.2)
			else
				LogMissionCompletion(mi.missionID, true, mi.overmaxSucceeded, mi.successChance, PackRewards(mi))
				curState, delayIndex, delayMID = "COMPLETE", curIndex, mi.missionID
				delayOpen(... ~= "IMMEDIATE" and 0.2)
			end
		elseif curState == "COMPLETE" and ev == "GARRISON_MISSION_COMPLETE_RESPONSE" then
			local mid, cc, ok, brOK = ...
			if mid ~= mi.missionID and not cc then return end
			if mid == mi.missionID or securecall(error, whineAboutUnexpectedState("Unexpected mission completion", mid, (cc and "C" or "c") .. (ok and "K" or "k")), 2) then
				if ok then
					mi.successChance = mi.successChance or C.GetMissionSuccessChance(mi.missionID)
					mi.state, curState = 0, "BONUS"
				else
					mi.failed, curState, curIndex = cc and true or nil, "NEXT", curIndex + 1
				end
				if cc then
					securecall(curCallback, "STEP", curStack, curRewards, curFollowers, ok and "COMPLETE" or "FAIL", brOK, mi.missionID)
				end
				if ok then
					delayIndex, delayMID = curIndex, mi.missionID
					delayRoll(0.2)
				else
					C_Timer.After(0.45, delayStep)
				end
			end
		elseif curState == "BONUS" and ev == "GARRISON_MISSION_BONUS_ROLL_COMPLETE" then
			local mid, ok = ...
			if mid ~= mi.missionID then
				securecall(error, whineAboutUnexpectedState("Unexpected bonus roll completion", mid, ok and "K" or "k"), 2)
			elseif ok then
				mi.succeeded, curState, curIndex = true, "NEXT", curIndex + 1
				if mi.rewards then
					for _,r in pairs(mi.rewards) do
						if r.currencyID and r.quantity then
							local ik, q = "cur:" .. r.currencyID, r.quantity
							curRewards[ik] = curRewards[ik] or {quantity=0, currencyID=r.currencyID}
							curRewards[ik].quantity = curRewards[ik].quantity + q
						elseif r.itemID and r.quantity then
							local ik = "item:" .. r.itemID
							curRewards[ik] = curRewards[ik] or {itemID=r.itemID, quantity=0}
							curRewards[ik].quantity = curRewards[ik].quantity + r.quantity
						end
					end
				end
				securecall(curCallback, "STEP", curStack, curRewards, curFollowers, "LOOT", mi.missionID)
			end
		end
	end
	function EV:GARRISON_FOLLOWER_XP_CHANGED(_, fid, xpAward, oldXP, olvl, oqual)
		if curState then
			curFollowers[fid] = curFollowers[fid] or {olvl=olvl, oqual=oqual, xpAward=0, oxp=oldXP}
			curFollowers[fid].xpAward = curFollowers[fid].xpAward + xpAward
		end
	end
	function EV:UI_ERROR_MESSAGE(msg)
		if curState and msg == ERR_ITEM_INVENTORY_FULL_SATCHEL then
			curOverflow = true
		end
	end
	EV.GARRISON_MISSION_NPC_OPENED, EV.GARRISON_MISSION_NPC_CLOSED = completionStep, completionStep
	EV.GARRISON_MISSION_BONUS_ROLL_COMPLETE, EV.GARRISON_MISSION_COMPLETE_RESPONSE = completionStep, completionStep
	function W.CompleteMissions(stack, callback)
		curStack, curCallback, curRewards, curFollowers, curOverflow = stack, callback, {}, {}
		curState, curIndex = "NEXT", 1
		completionStep("GARRISON_MISSION_NPC_OPENED", "IMMEDIATE")
	end
	function W.CompleteMission(mid, callback)
		if not curState then
			W.CompleteMissions({C.GetBasicMissionInfo(mid)}, callback)
		else
			for i=1,#curStack do
				if curStack[i].missionID == mid then
					return
				end
			end
			table.insert(curStack, curIndex+1, C.GetBasicMissionInfo(mid))
		end
	end
	function W.StopCompletingMissions()
		if curState then
			completionStep("GARRISON_MISSION_NPC_CLOSED", "IMMEDIATE")
		end
	end
	function W.IsCompletingMissions()
		return curState ~= nil and (#curStack-curIndex+1) or nil
	end
end

do -- PrepareAllMissionGroups/GetMissionGroups
	local mmFollowerKeys, mmFollowerIDs, mmFollowerTags, mmFollowerBias, mmGroups = {}, {}, {}, {}, {}
	local suppressFollowerEvents, releaseFollowerEvents do
		local level, frames, followers = 0
		local function failsafe()
			if level > 0 then
				level = 1
				releaseFollowerEvents()
			end
		end
		function suppressFollowerEvents(mt)
			if level == 0 then
				frames, followers = {GetFramesRegisteredForEvent("GARRISON_FOLLOWER_LIST_UPDATE")}, {}
				for i=1,#frames do
					frames[i]:UnregisterEvent("GARRISON_FOLLOWER_LIST_UPDATE")
				end
				local mmi = C.GetAvailableMissions(mt) or {}
				for i=1,#mmi do
					for _,v in pairs(mmi[i].followers) do
						C.RemoveFollowerFromMission(mmi[i].missionID, v)
						followers[v] = mmi[i].missionID
					end
				end
				C_Timer.After(0, failsafe)
			end
			level = level + 1
		end
		function releaseFollowerEvents(mt)
			assert(level > 0, "release not matched to suppress")
			level = level - 1
			if level == 0 then
				for i=1,(not mt) and 2 or 1 do
					local mt = not mt and i or mt
					local mmi = C.GetAvailableMissions(mt) or {}
					for i=1,#mmi do
						for _,v in pairs(mmi[i].followers) do
							C.RemoveFollowerFromMission(mmi[i].missionID, v)
						end
					end
					for f, m in pairs(followers) do
						C.AddFollowerToMission(m, f)
					end
				end
				for i=1,#frames do
					frames[i]:RegisterEvent("GARRISON_FOLLOWER_LIST_UPDATE")
				end
				frames, followers = nil, nil
			end
		end
		W.SuppressFollowerEvents = suppressFollowerEvents
		W.ReleaseFollowerEvents = releaseFollowerEvents
	end
	local function doPrepareMissionGroups(mmi)
		for i=1,#mmi do
			W.GetMissionGroups(mmi[i].missionID, i > 1, mmi[i])
		end
	end
	function W.PrepareAllMissionGroups(mtype)
		suppressFollowerEvents(mtype)
		local mmi = C.GetAvailableMissions(mtype) or {}
		securecall(doPrepareMissionGroups, mmi)
		releaseFollowerEvents(mtype)
		return mmi
	end
	function W.GetMissionGroups(mid, trustValid, omi)
		local mt = C.GetFollowerTypeByMissionID(mid)
		if not trustValid or not mmFollowerIDs[1] or not securecall(assert, mmFollowerIDs.typeID == mt, "trust/type mismatch") then
			local ipfInfo = W.GetFollowersMissionInfo(mt)
			local finfo = W.GetFollowers(mt, ipfInfo)
			local valid, fn, lastChampion = true, 1, 0
			for i=1,#finfo do
				local v = finfo[i]
				local fid = v.followerID
				if not v.isCollected or v.followerTypeID ~= mt then
					-- Don't suggest impossible followers
				elseif v.status == GARRISON_FOLLOWER_ON_MISSION and v.isEffectivelyDead and v.isTroop then
					-- Don't suggest troops dying upon return
				elseif  v.status ~= GARRISON_FOLLOWER_INACTIVE then
					local key = v.level .. "#" .. v.iLevel .. "#" .. v.quality
					for i=1,2 do
						key = key .. "#" .. (C.GetFollowerTraitAtIndex(fid, i) or 0)
					end
					if not v.isTroop then
						assert(lastChampion == (fn-1), "order violation")
						lastChampion = fn
					end
					mmFollowerTags[fid], mmFollowerBias[fid] = v.tag, v.groupBias or 0
					mmFollowerIDs[fn], fn, mmFollowerKeys[fid], valid = fid, fn+1, key, valid and mmFollowerKeys[fid] == key
				end
			end
			for i=fn,#mmFollowerIDs do
				valid, mmFollowerIDs[i] = false
			end
			for k in pairs(mmFollowerKeys) do
				for i=1,#mmFollowerIDs do
					if mmFollowerIDs[i] == k then
						k = nil
						break
					end
				end
				if k then
					valid, mmFollowerKeys[k] = false, nil
				end
			end
			if not valid then wipe(mmGroups) end
			mmFollowerIDs.typeID, mmFollowerIDs.numChampions, finfo = mt, lastChampion, nil
		end
		local ret = mmGroups[mid]
		if ret and omi and ret.hasBonusEffect ~= omi.hasBonusEffect then
			ret = nil
		end
		if ret then
			return ret
		end
		local mi = C.GetBasicMissionInfo(mid)
		if not mi then
			return false
		elseif mi.numFollowers > #mmFollowerIDs then
			mmGroups[mid] = {hasBonusEffect=mi.hasBonusEffect}
			return mmGroups[mid]
		end
		
		local chestXP, _, baseXP, _, _, _, _, _, enemies = 0, C.GetMissionInfo(mid)
		for _,r in pairs(mi.rewards) do
			if r.followerXP then
				chestXP = chestXP + r.followerXP
			end
		end
		local band, leMask = bit.band, W.GetMissionLethalMask(mid, enemies)
		
		suppressFollowerEvents(mt)
		
		local fn, t, fm, m, mn = #mmFollowerIDs, {}, {}, {hasBonusEffect=mi.hasBonusEffect}, 1
		local nf = mi.numFollowers
		local af, rf = C.AddFollowerToMission, C.RemoveFollowerFromMission
		local GetPartyMissionInfo, GetMissionCost = C.GetPartyMissionInfo, C.GetMissionCost
		repeat
			fm[1] = fn
			for i=2,nf do
				fm[1], fm[2], fm[3] = fm[1] - 1, fm[1], fm[2]
			end
			fm[1] = math.min(fm[1], mmFollowerIDs.numChampions)
			t[1], t[2], t[3] = fm[1], fm[2], fm[3]
			local i1, i2, i3 = 1, nf > 1 and 2 or -1, nf > 2 and 3 or -1
			repeat
				for i=nf,1,-1 do
					rf(mid, mmFollowerIDs[t[i]])
					t[i] = t[i] % fm[i] + 1
					if t[i] > 1 or i == 1 then
						if not af(mid, mmFollowerIDs[t[i]]) then error("Failed to add follower " .. i .. ":" .. tostring(t[i]) .. ":" .. tostring(mmFollowerIDs[t[i]]) .. " to " .. tostring(mid)) end
						for j=i+1, nf do
							t[j]=t[j-1]+1
							if not af(mid, mmFollowerIDs[t[j]]) then error("Failed to add follower " .. j .. ":" .. tostring(t[j]) .. ":" .. tostring(mmFollowerIDs[t[j]]) .. " to " .. tostring(mid)) end
						end
						break
					end
				end
				local _st, rtime, _it, chance, _buffs, _envCountered, _overcapChance, _materialMultiplier, _goldMultiplier = GetPartyMissionInfo(mid)
				local _, cost = GetMissionCost(mid)
				local f1, f2, f3 = mmFollowerIDs[t[i1]], mmFollowerIDs[t[i2]], mmFollowerIDs[t[i3]]
				local gtag = (mmFollowerTags[f1] or f1 and 1 or 0) + (mmFollowerTags[f2] or f2 and 1 or 0) + (mmFollowerTags[f3] or f3 and 1 or 0)
				local gbias = (mmFollowerBias[f1] or 0) + (mmFollowerBias[f2] or 0) + (mmFollowerBias[f3] or 0)
				m[mn], mn = {chance, baseXP, chestXP, rtime, cost, gtag, leMask ~= 0 and band(leMask, gtag) ~= leMask, gbias, f1, f2, f3}, mn + 1
			until t[1] == fm[1] and t[2] == fm[2] and t[3] == fm[3]
		
			for i=1,nf do
				C.RemoveFollowerFromMission(mid, mmFollowerIDs[t[i]])
			end
			nf = nf - 1
		until nf == 0
		
		mmGroups[mid], ret = m, m
		releaseFollowerEvents(mt)
			
		return ret
	end
	function EV:I_RELEASE_CACHES()
		mmGroups, mmFollowerKeys, mmFollowerIDs = {}, {}, {}
	end
end
local function cmpSecondary(a,b)
	if a[4] ~= b[4] then
		return a[4] < b[4]
	elseif a[GROUP_TRAIT_BIAS] ~= b[GROUP_TRAIT_BIAS] then
		return a[GROUP_TRAIT_BIAS] > b[GROUP_TRAIT_BIAS]
	elseif a.nL ~= b.nL then
		return a.nL < b.nL
	elseif (not a[GROUP_FOLLOWER_3]) ~= (not b[GROUP_FOLLOWER_3]) then
		return not a[GROUP_FOLLOWER_3]
	elseif (not a[GROUP_FOLLOWER_2]) ~= (not b[GROUP_FOLLOWER_2]) then
		return not a[GROUP_FOLLOWER_2]
	end
end
local function cmpChancePatient(a,b)
	if a[1] ~= b[1] then
		return a[1] >= b[1]
	end
	return cmpSecondary(a,b)
end
local function cmpChancePatientNoOvermax(a,b)
	local ac, bc = a[1], b[1]
	if (ac < 100 or bc < 100) and (ac ~= bc) then
		return ac > bc
	end
	return cmpSecondary(a,b)
end
local function cmpChanceNoOvermax(a,b)
	local ac, bc = a[1], b[1]
	if a.wt ~= b.wt then
		return a.wt < b.wt
	elseif (ac < 100 or bc < 100) and (ac ~= bc) then
		return ac > bc
	end
	return cmpSecondary(a,b)
end
local function cmpChanceReady(a,b)
	if a.wt ~= b.wt then
		return a.wt < b.wt
	elseif a[1] ~= b[1] then
		return a[1] > b[1]
	end
	return cmpSecondary(a,b)
end
local function cmpMinimal(a,b)
	if a.wt ~= b.wt then
		return a.wt < b.wt
	elseif (not a[GROUP_FOLLOWER_3]) ~= (not b[GROUP_FOLLOWER_3]) then
		return not a[GROUP_FOLLOWER_3]
	elseif (not a[GROUP_FOLLOWER_2]) ~= (not b[GROUP_FOLLOWER_2]) then
		return not a[GROUP_FOLLOWER_2]
	elseif a[1] ~= b[1] then
		return a[1] > b[1]
	end
	return  cmpSecondary(a,b)
end
local function maybeKeepGroup(out, cmp, g)
	if #out == 4 and not cmp(g, out[4]) then
		return
	end
	for i=1,#out do
		if isEquivalentGroup(out[i], g) then
			return
		end
	end
	if #out < 4 then
		out[#out+1] = g
		if #out == 4 then
			table.sort(out, cmp)
		end
	else
		for i=4,1,-1 do
			if i == 1 or cmp(out[i-1], g) then
				table.insert(out, i, g)
				out[5] = nil
				break
			end
		end
	end
end
function W.PrepareSuggestedGroups(mid, followers)
	wipe(followerWaitingTimes)
	for _,v in pairs(followers) do
		local fid = v.followerID
		if v.status == GARRISON_FOLLOWER_ON_MISSION then
			followerWaitingTimes[fid] = v.missionTimeLeft
		end
	end
	for fid, fmid in pairs(rsInfo.followerMission) do
		if fmid ~= mid then
			followerWaitingTimes[fid] = followerWaitingTimes[fid] or rsInfo.missions[fmid][GROUP_TIME_IDX]
		end
	end
	for fid,mid in pairs(fsInfo.followerMission) do
		followerWaitingTimes[fid] = fsInfo.missions[mid][GROUP_TIME_IDX]
	end
end
function W.SuggestMissionGroups(mid, arr, filter, missionExpiresIn, maxCost, hasOvermaxRewards)
	local sr, cmp = suggestionResults, suggestionComparators
	if hasOvermaxRewards then
		cmp[1], cmp[2], cmp[3], cmp[4] = cmpChanceReady, cmpChanceNoOvermax, cmpMinimal, cmpChancePatient
	else
		cmp[1], cmp[2], cmp[3], cmp[4] = cmpChanceNoOvermax, cmpChanceReady, cmpMinimal, cmpChancePatientNoOvermax
	end
	for i=0,#sr do
		wipe(sr[i])
	end
	for i=#sr+1,#cmp do
		sr[i] = {}
	end
	
	local max = math.max
	arr.baseTime = GetTime()
	for i=1,#arr do
		local g = arr[i]
		local wt = max(followerWaitingTimes[g[GROUP_FOLLOWER_1]] or -1, followerWaitingTimes[g[GROUP_FOLLOWER_2]] or -1, followerWaitingTimes[g[GROUP_FOLLOWER_3]] or -1)
		local gTag = g[GROUP_TAG_IDX]
		g.wt, g.nL = wt, g[GROUP_LETHAL_IDX] and (gTag % 64 - gTag % 16)/16 or 0
		if (missionExpiresIn == nil or wt < missionExpiresIn)
		   and (filter == nil or filter(g))
		   and (maxCost == nil or g[GROUP_COST_IDX] <= maxCost) then
			for j=(wt < 0 and 1 or 4),#cmp do
				maybeKeepGroup(sr[j], cmp[j], g)
			end
		end
	end
	for i=1,#sr do
		if #sr[i] < 4 then
			table.sort(sr[i], cmp[i])
		end
	end

	local o, tg, addGroup = sr[0], W.GetTentativeGroup(mid), nil
	o[1] = tg
	for i=1,4 do
		for a=0,i-1 do
			local ga = sr[a == 0 and i or a]
			for j=1,#ga do
				local g = ga[j]
				if not (isEquivalentGroup(g,o[1]) or isEquivalentGroup(g,o[2]) or isEquivalentGroup(g,o[3])) then
					addGroup = g
					break
				end
			end
			if addGroup then
				break
			end
		end
		o[#o+1], addGroup = addGroup, nil
	end
	if tg then
		table.remove(o, 1)
	end
	table.sort(o, cmp[1])
	if tg then
		if #o == 4 then
			table.remove(o, 2)
		end
		table.insert(o, 1, tg)
	end
	return unpack(o)
end

function W.UnpackHistoryReward(r)
	if type(r) ~= "number" then
		return "invalid"
	end
	local kind, floor = r % 8, math.floor
	local typeID = floor(r % 2^24 / 8)
	if kind == 2 then
		return "gold", 0, floor(r/8), 133784
	elseif kind == 1 then
		local quant, ico = floor(r / 2^24)
		if C_CurrencyInfo.IsCurrencyContainer(typeID, quant) then
			local ci = C_CurrencyInfo.GetBasicCurrencyInfo(typeID, quant)
			ico = ci and ci.icon
		end
		return "currency", typeID, quant, ico or select(3,Nine.GetCurrencyInfo(typeID)) or 134400
	elseif kind == 3 then
		return "item", typeID, floor(r / 2^24), GetItemIcon(typeID) or 134400
	elseif r > 0 then
		return "unknown", 0, 0, 877477
	else
		return "invalid"
	end
end
function W.GetNumCompletionHistoryEntries()
	local log = GetMissionHistory()
	return log and #log or 0
end
function W.GetCompletionHistoryEntry(index)
	local log = GetMissionHistory()
	local e = log and log[(#log-index)+1]
	if e then
		local ec = #e
		return unpack(e, 1, ec > 10 and ec or 10)
	end
end

function W.SuspendAndReload()
	local pcData = _G[SAVED_PC_STORE]
	pcData = type(pcData) == "table" and pcData or {}
	_G[SAVED_PC_STORE], pcData.SkipLoad = pcData, GetServerTime()
	ReloadUI()
end
function EV:ADDON_LOADED(addon)
	if addon == ADDON then
		local pcData = _G[SAVED_PC_STORE]
		if type(pcData) == "table" and type(pcData.SkipLoad) == "number" then
			local now, skipTime = GetServerTime(), pcData.SkipLoad
			pcData.SkipLoad = nil
			if now >= skipTime and now-skipTime <= 180 then
				EV.UnregisterAll()
				return "remove"
			end
		end
		EV("I_LOAD_HOOKS")
		if IsAddOnLoaded("Blizzard_GarrisonUI") then
			EV("I_LOAD_MAINUI")
			return "remove"
		end
	elseif addon == "Blizzard_GarrisonUI" and select(2, IsAddOnLoaded(ADDON)) then
		EV("I_LOAD_MAINUI")
		return "remove"
	end
end
function EV:I_LOAD_HOOKS()
	function EV:GARRISON_MISSION_NPC_CLOSED()
		wipe(startQueue)
		wipe(fsInfo.missions)
		wipe(fsInfo.followerMission)
		if startQueueSize > 0 then
			startQueueSize = 0
			EV("I_MISSION_START_QUEUE", startQueueSize)
		end
	end
	function EV:GARRISON_MISSION_COMPLETE_RESPONSE(mid, cc, baseOK, brOK, _deaths)
		if C.GetFollowerTypeByMissionID(mid) ~= 22 or not cc then return end
		if cc then
			LogMissionCompletion(mid, baseOK, brOK, C.GetMissionSuccessChance(mid), PackRewards(C.GetBasicMissionInfo(mid)))
		end
	end
	function EV:GARRISON_MISSION_BONUS_ROLL_COMPLETE(mid, _rollOK)
		local cc = draftCompletionEntries[mid]
		if cc then
			AddToMissionLog(cc)
			draftCompletionEntries[mid] = nil
		end
	end
	function EV:GARRISON_MISSION_BONUS_ROLL_LOOT(itemID)
		if not (itemID and itemID > 0) then
			return
		end
		local q = 0 -- Not provided by the event
		local packedReward = 3 + itemID*2^3 + q*2^24
		local log = GetMissionHistory()
		local logEntry = log and log[#log]
		local td = logEntry and (GetServerTime()-logEntry[1])
		if td and td >= 0 and td <= 3 then
			local t, oc = 0, GetItemCount(itemID)
			local function saveCount()
				local nc = GetItemCount(itemID)
				if oc == nc and t < 20 then
					t = t + 1
					C_Timer.After(0.05, saveCount)
					return
				elseif nc > oc then
					packedReward = packedReward + (nc-oc)*2^24
				end
				for i=8,10 do
					if logEntry[i] == nil then
						logEntry[i] = packedReward
						break
					end
				end
				EV("I_ABILITY_BONUS_LOOT", logEntry[2], packedReward)
			end
			saveCount()
		end
	end
	function EV:GARRISON_MISSION_STARTED(_mtype, mid)
		if fsInfo.missions[mid] then
			fsInfo.missions[mid] = nil
			local fm = fsInfo.followerMission
			for k,v in pairs(fm) do
				if v == mid then
					fm[k] = nil
				end
			end
		end
		dissolveTentativeGroupHelper(mid)
		if startQueue[mid] then
			startQueueSize, startQueue[mid] = startQueueSize - 1, nil
			EV("I_MISSION_START_QUEUE", startQueueSize)
		end
	end
	return "remove"
end

function EV:I_RELEASE_CACHES()
	missionCreditCriteria, followerWaitingTimes = {}, {}
	suggestionResults = {[0]={}}
	ipLethalCache = {}
end