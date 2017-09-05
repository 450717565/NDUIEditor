
--[[
----------------------------------------------------------------------------------------------------------------------------------------------

TjAchieve.lua
  by Tuhljin

Dependencies: TjThreads library is required for BuildIDCache(), BuildCritAssetCache(), and related features.

Make it easier for addons to deal with achievements, with a focus on improving performance (handling caches and throttling) and preventing
error messages (which can occur when you're trying achievement/criteria IDs without first verifying that they are valid).

For commonly called functions that "replace" standard WoW API calls, it is suggested that you simplify things by using a line like the
following near the top of your script:
  local GetAchievementCriteriaInfo = TjAchieve.GetAchievementCriteriaInfo


Safe to call before a cache is built
------------------------------------

These functions either don't use a cache or build caches quickly enough that you don't need to worry about processing time before calling them.

TjAchieve.GetAchievementCriteriaInfo( achievementID, criteriaIndex )
  Call this instead of the normal GetAchievementCriteriaInfo function to prevent an error from being thrown when an invalid achievement or
criteria index is used. Returns nil if there would have been an error. You must still use numbers as arguments or an error IS thrown.
  Note that this is only intended for use with two arguments, as indicated (achievementID, criteriaIndex). It won't work with the one-argument
signature (statisticID).

list = TjAchieve.GetAllCategories()
  Returns a list (numerically indexed table) of all category IDs, a combination of WoW's GetCategoryList() and GetGuildCategoryList().

list = TjAchieve.GetAchIDs()
  Returns a list of all achievement IDs.

list = TjAchieve.GetGuildAchIDs()
  Returns a list of all guild achievement IDs.

list = TjAchieve.GetPersonalAchIDs()
  Returns a list of all non-guild achievement IDs.


Calling before a cache is built may build it
--------------------------------------------

These functions may force a rush build of the associated cache (if it isn't fully built yet) to ensure the returns are accurate, resulting
in significant execution time.

id = TjAchieve.GetFirstSeenInSeries( achID )
  Given an achievement ID, returns the same ID if it is visible in the UI. Otherwise, if the achievement is in a series, then the ID of the
"closest" visible achievement is returned (the first visible achievement found when traversing up/down the series). If this fails, false is
returned.

id[, id2, ...] OR list = TjAchieve.GetAchievementByAsset( assetType, assetID[, packed ] )
  Given an asset's type and ID, returns all of the achievement IDs associated with that asset.
  If the packed argument evaluates to true, then the values normally returned may instead be part of a table which is then the only return
value. (If multiple IDs would be returned, or if packed is set to the string "always", they will be in a table. Otherwise, only a single,
non-table value is returned.) Do not alter the table's contents! In some cases, they are used internally.

id, index[, id2, index2, ...] OR list = TjAchieve.GetCriteriaByAsset( assetType, assetID[, packed ] )
  Given an asset's type and ID, returns all of the achievement IDs and criteria indexes associated with that asset.
  If the packed argument evaluates to true, then the values normally returned will instead be part of a table which is then the only return
value. Do not alter the table's contents! They are used internally.


Achievement ID cache management
-------------------------------

status = TjAchieve.BuildIDCache()
  Start populating the achievement ID cache. This may take some time but it is throttled so as to allow gameplay and other scripts to
continue. It is safe to call multiple times since only the first call will start the process.
  Returns:
    status (string)		"started" (if just started due to your call), "ongoing" (if started previously), or "complete".

ready = TjAchieve.IsIDCacheReady()
  Returns true if the achievement ID cache has been fully populated. False otherwise.

TjAchieve.RushBuildIDCache()
  Populates the achievement ID cache without throttling. If the throttled process was already started, this takes over where that left off.

TjAchieve.AddBuildIDCacheListener( func )
  Specify a function to be called once the ID cache has been fully populated. If it is already populated, then the function is called almost
immediately (on the next tick).


Criteria asset ID cache management
----------------------------------

status = TjAchieve.BuildCritAssetCache( assetType[, saveIndex] )
  Start populating a criteria asset ID cache. This may take some time but it is throttled so as to allow gameplay and other scripts to
continue. It is safe to call multiple times since only the first call will start the process.
  Unlike the achievement ID cache, there can be more than one resulting cache and which one is built depends on the arguments passed here.
  Arguments:
    assetType (number)	The asset ID. For instance, 0 for mob IDs or 8 for IDs of achievements that are criteria (used by meta-achievements).
    saveIndex (boolean)	If true, then the resulting cache saves the criteria index in addition to the achievement ID. Defaults to false. If
    					the index isn't needed, this should be false to avoid the excessive use of memory. If this function was already called
    					using the same assetType but saveIndex was false and now it is true, then previous data will be discarded and the
    					cache will be rebuilt.
  Returns:
    status (string)		"started" (if just started due to your call), "ongoing" (if started previously), or "complete".

ready = TjAchieve.IsCritAssetCacheReady( assetType )
  Returns 1 or 2 if the criteria asset ID cache has been fully populated: 1 if without criteria indexes, 2 if with indexes. Returns false
otherwise.

TjAchieve.RushBuildCritAssetCache( assetType[, saveIndex] )
  Populates the criteria asset ID cache without throttling. If the throttled process was already started, this takes over where that left off.

TjAchieve.AddBuildCritAssetCacheListener( assetType, func )
  Specify a function to be called once the criteria asset ID cache has been fully populated. If it is already populated, then the function is
called almost immediately (on the next tick). The function is passed the assetType (to allow you to use a single function to listen for
multiple criteria asset ID caches' completions).

Constants
---------

TjAchieve.CRITTYPE_META		The asset type for meta-achievement criteria.
TjAchieve.CRITTYPE_KILL		The asset type for kill criteria.


----------------------------------------------------------------------------------------------------------------------------------------------
--]]


local THIS_VERSION = "0.04"

if (TjAchieve and TjAchieve.Version >= THIS_VERSION) then  return;  end  -- Lua's pretty good at this. It even knows that "1.0.10" > "1.0.9". However, be aware that it thinks "1.0" < "1.0b" so putting a "b" on the end for Beta, nothing for release, doesn't work.

TjAchieve = TjAchieve or {}
local TjAchieve = TjAchieve
TjAchieve.Version = THIS_VERSION

TjAchieve.CRITTYPE_KILL = 0
TjAchieve.CRITTYPE_META = 8


-- Set this to a higher number to finish building the lookup table faster. If frame rate drops occur, lower the number. Minimum 1.
-- Can also/instead change INTERVAL in libs/TjThreads.lua to try to reduce drops in frame rate (theoretically).
local BUILD_CRIT_STEPS = 50 --15 --50


----------------------------------------------------------------------------------------------------------------------------------------------
-- API WRAPPERS
-- These exist because using WoW's default API functions can result in errors in some cases.
----------------------------------------------------------------------------------------------------------------------------------------------

-- HELPERS

local GetPreviousAchievement = GetPreviousAchievement
local GetNextAchievement = GetNextAchievement

local pcall = pcall

-- A protected call that doesn't append true to the results when successful and returns nil if unsuccessful.
local tryCall
do
	local function tryCall_helper(noerrors, ...)
		if (noerrors) then  return ...;  end
		return nil;
	end
	function tryCall(func, ...)
		-- Supposedly, it's more efficient to do this here than encapsulating the returns in a table and using tremove and unpack:
		return tryCall_helper(pcall(func, ...))
	end
end

--[[
local function tryCall(func, ...)
	return (function(noerrors, ...)
		if (noerrors) then  return ...;  end
		return nil;
	)(pcall(func, ...));
end
--]]


-- Overcome problem where GetAchievementCriteriaInfo throws an error if the achievement ID or criteria number is invalid:
do
	local GACI = GetAchievementCriteriaInfo
	function TjAchieve.GetAchievementCriteriaInfo(achievementID, index)
		assert(type(achievementID) == "number", "Usage: TjAchieve.GetAchievementCrieriaInfo(achievementID, index)")
		assert(type(index) == "number", "Usage: TjAchieve.GetAchievementCrieriaInfo(achievementID, index)")
		return tryCall(GACI, achievementID, index)
	end
end
local GetAchievementCriteriaInfo = TjAchieve.GetAchievementCriteriaInfo

--[[ UNUSED:
-- Overcome problem where GetAchievementInfo throws an error if the achievement ID is invalid:
--    Call this instead of the normal GetAchievementInfo function to prevent an error from being thrown when an
--    invalid achievement or category ID is used. Returns nil if there would have been an error. You must still use
--    integers as arguments or an error is thrown.
--    Note: Since WoW 5.1, GetAchievementInfo seems to behave how it used to months (years?) ago: Returning nil
--    instead of throwing errors due to an invalid achievement ID or category ID argument (provided they are
--    integers, anyway). The code for this function remains here, though, in case things change again.

-- Simple error-preventing version:
do
	local GAI = GetAchievementInfo
	function TjAchieve.GetAchievementInfo(...)
		return tryCall(GAI, ...)
	end
end
local GetAchievementInfo = TjAchieve.GetAchievementInfo

-- Alternate version: Populates the cache.
function TjAchieve.GetAchievementInfo(category, id)
  if (type(id) ~= "number") then  id = category;  category = nil;  end  -- Emulates how standard GetAchievementInfo gets arguments: Checking on the second argument's type, not just seeing if it's nil/false.
  if (ACH[id] == false) then  return nil;  end
  if (ACH[id] == nil) then
    if (type(id) ~= "number") then  error("Invalid achievement ID.", 2);  end
    if (category and type(category) ~= "number") then  error("Invalid achievement category ID.", 2);  end
    local ret
    if (category) then  ret = pcall(GetAchievementInfo, category, id);  else  ret = pcall(GetAchievementInfo, id);  end
    if (not ret) then
      ACH[id] = false
      return nil
    end
    ACH[id] = category or true
  end
  if (category) then  return GetAchievementInfo(category, id);  end
  return GetAchievementInfo(id)
end
--]]



----------------------------------------------------------------------------------------------------------------------------------------------
-- CACHE DEFINITIONS AND BASIC ACCESS
----------------------------------------------------------------------------------------------------------------------------------------------

-- NOTE: It is recommended that you use the functions provided to get data (see above) instead of directly referencing the variables
-- that make up a cache.

-- TjAchieve.status_ACH	values: nil = Not started. false = Building. true = Ready.

-- ALL ACHIEVEMENTS ID cache. When fully populated, it includes every achievement the API tells us exists.
-- Keys are IDs (integers). Possible values:
-- true			The achievement was found in the standard UI.
-- -1			It has not been determined whether this achievement is in the standard UI.
-- 0			The achievement cannot be found in the standard UI and we expect this won't change.
-- number > 0	The achievement wasn't found in the standard UI but another from the same series was. This is that achievement's ID.
--				(Only the last complete and first incomplete achievement in a series are displayed. This ID will be the incomplete
--				achievement if the requested achievement is incomplete or the complete achievement otherwise.)
TjAchieve.ACH = TjAchieve.ACH or {}
local ACH = TjAchieve.ACH


--[[ UNUSED:
-- UI ACHIEVEMENTS ID cache. When fully populated, it includes every achievement that should be visible in the
-- default UI as well as any that are part of a series which, through another achievement, is visible in the
-- default UI. 
-- Keys are IDs (integers). Possible values:
-- true		This achievement is visible in the UI.
-- number	The ID of a previous achievement in this one's series which is visible in the UI.
TjAchieve.ACH_VIS = TjAchieve.ACH_VIS or {}
local ACH_VIS = TjAchieve.ACH_VIS
--]]

--[[ UNUSED:
-- Achievement criteria index cache. Stores highest numbered criteria found for a given achievement.
-- (Doesn't use GetAchievementNumCriteria because there are, or at least used to be, hidden criteria with indexes
-- higher than the number that function would give.)
TjAchieve.CRITCOUNT = TjAchieve.CRITCOUNT or {}
local CRITCOUNT = TjAchieve.CRITCOUNT
--]]

--[[ UNUSED:
-- Achievement criteria/statistic ID cache. Possible values:
-- false: This is an invalid ID.
-- true: This is a valid ID.
TjAchieve.CRIT = TjAchieve.CRIT or {}
local CRIT = TjAchieve.CRIT
--]]


-- TjAchieve.status_CA[assetType]		values: nil = Not started. false = Building. true = Ready.

-- CRITERIA ASSETS ID cache. Divided into parts, a key and data for each. That key indicates the criteria asset type in question (e.g. 0 for
-- mob IDs). The data is a table with its own keys, which are integers giving the asset ID (e.g. the actual mob ID). The value for the data
-- table will either be an integer, indicating the associated achievement ID, or a table, which will either be a simple list of multiple
-- achievement IDs OR it will be a list which alternately gives achievement IDs and criteria indexes, like this:
--   { id, index }
-- Or, if there are multiple IDs and associated indexes, like this:
--   { id1, index1, id2, index2, ... }
-- You can tell whether indexes are included or not by checking against the key "saveIndex" of the associated data table, which will be true
-- if indexes they are.
TjAchieve.ASSETS = TjAchieve.ASSETS or {}
local ASSETS = TjAchieve.ASSETS


function TjAchieve.GetAllCategories()
	if (not TjAchieve.CATEGORIESLIST) then
		local list1 = GetCategoryList()
		local list2 = GetGuildCategoryList()
		local thelist = {}
		TjAchieve.CATEGORIESLIST = thelist
		local i = 0
		for k,v in pairs(list1) do
			i = i + 1
			thelist[i] = v
		end
		for k,v in pairs(list2) do
			i = i + 1
			thelist[i] = v
		end
	end
	return TjAchieve.CATEGORIESLIST
end

local function getAllAchievements(key, catfunc)
	-- Retrieve an array of all achievement IDs, including those not normally listed in the UI for this character.
	local ACHIEVEMENTS_ALL
	if (TjAchieve.ACHIEVEMENTS_ALL) then
		ACHIEVEMENTS_ALL = TjAchieve.ACHIEVEMENTS_ALL
	else
		ACHIEVEMENTS_ALL = {}
		TjAchieve.ACHIEVEMENTS_ALL = ACHIEVEMENTS_ALL
	end
	if (ACHIEVEMENTS_ALL[key]) then  return ACHIEVEMENTS_ALL[key];  end
	local catlist = catfunc and catfunc() or TjAchieve.GetAllCategories()
	local catlookup = {}
	for i,c in ipairs(catlist) do
		catlookup[c] = true
	end
	local buildlist = {}
	local gap, i, size, id = 0, 0, 0
	--local debug_largestgap = 0
	repeat
		i = i + 1
		id = GetAchievementInfo(i)
		if (id) then
			--if (gap > debug_largestgap) then debug_largestgap = gap; print("high gap:",debug_largestgap); end
			gap = 0

			size = size + 1
			buildlist[size] = id
			if (catlookup[GetAchievementCategory(id)]) then  -- If its achievement category is in the UI:
				ACH[id] = -1
			else
				ACH[id] = 0
			end
		else
			gap = gap + 1
		end
	until (gap > 1000) -- 1000 is arbitrary. As of this writing, the largest gap is 79, but this is more future-safe.
	--print("last ach ID:",buildlist[size], "/ size:",size)
	catlookup = nil
	ACHIEVEMENTS_ALL[key] = buildlist
	return buildlist
end

function TjAchieve.GetAchIDs()
	return getAllAchievements(1)
end

function TjAchieve.GetPersonalAchIDs()
	return getAllAchievements(2, GetCategoryList)
end

function TjAchieve.GetGuildAchIDs()
	return getAllAchievements(3, GetGuildCategoryList)
end


local getFirstSeenInSeries_precache
local function getFirstSeenInSeries(id)
	if (not TjAchieve.status_ACH and not getFirstSeenInSeries_precache) then
		TjAchieve.RushBuildIDCache()
	end
	if (ACH[id] == true) then  return id;  end
	local _, _, _, completed = GetAchievementInfo(id)
	local func = completed and GetNextAchievement or GetPreviousAchievement
	repeat
		id = func(id)
		if (id and ACH[id] == true) then  return id;  end
	until (not id)
	return false
end
TjAchieve.GetFirstSeenInSeries = getFirstSeenInSeries

function TjAchieve.GetAchievementByAsset(assetType, assetID, packed)
	assert(type(assetType) == "number", "Usage: TjAchieve.GetAchievementByAsset(assetType[, saveIndex])")
	local ready = TjAchieve.IsCritAssetCacheReady(assetType)
	if (not ready) then
		TjAchieve.RushBuildCritAssetCache(assetType)
	end
	local r = ASSETS[assetType][assetID]
	if (r) then
		if (type(r) == "table") then
			if (ready == 2) then -- Asking only for IDs but we got criteria indexes as well:
				if (#r == 2) then
					return r[1]
				elseif (#r == 4) then
					return r[1], r[3]
				end
				local tab = {}
				local num = 1
				for i = 1, #r, 2 do
					tab[num] = r[i]
					num = num + 1
				end
				if (packed and (packed == "always" or #tab > 1)) then  return tab;  end
				return unpack(tab)
			end
			if (packed and (packed == "always" or #r > 1)) then  return r;  end
			return unpack(r)
		end
		if (packed == "always") then  return { r };  end
		return r
	end
end

function TjAchieve.GetCriteriaByAsset(assetType, assetID, packed)
	assert(type(assetType) == "number", "Usage: TjAchieve.GetCriteriaByAsset(assetType[, saveIndex])")
	if (TjAchieve.IsCritAssetCacheReady(assetType) ~= 2) then
		TjAchieve.RushBuildCritAssetCache(assetType, true)
	end
	local r = ASSETS[assetType][assetID]
	if (r) then
		if (packed) then  return r;  end
		return unpack(r)
	end
end


----------------------------------------------------------------------------------------------------------------------------------------------
-- THROTTLED POPULATION OF CACHES AND EVENT MONITORING TO KEEP IT ACCURATE
----------------------------------------------------------------------------------------------------------------------------------------------

TjAchieve.Frame = TjAchieve.Frame or CreateFrame("Frame")
-- Handle possible changes to UI visibility:
TjAchieve.Frame:RegisterEvent("ACHIEVEMENT_EARNED")
TjAchieve.Frame:SetScript("OnEvent", function(self, event, arg1)
	ACH[arg1] = true -- Most recently completed achievements are shown
	local id = GetPreviousAchievement(arg1)
	if (id) then  ACH[id] = arg1;  end -- Achievements prior to the most recent are not shown
	id = GetNextAchievement(arg1)
	if (id) then  ACH[id] = true;  end -- The next achievement after the most recently completed one is shown
end)

local idCacheBuildStep
do
	local num = 0
	local tab, cats, size, prevcat, lastcat
	local function buildStepUIAch()
		if (num == 0) then
			tab = {}
			cats = TjAchieve.GetAllCategories()
			size = #cats
			prevcat = 0
			lastcat = 5
		else
			lastcat = prevcat + 5
		end
		if (lastcat > size) then  lastcat = size;  end
		for iCat = prevcat + 1, lastcat do
			local catID = cats[iCat]
			for i = 1, GetCategoryNumAchievements(catID) do
				local achID = GetAchievementInfo(catID, i)
				if (achID) then
					num = num + 1
					tab[num] = achID
				--else
					--print("huh",catID,i)
				end
			end
			prevcat = iCat
		end
		if (prevcat == size) then  return true;  end
	end

	function idCacheBuildStep()
		TjAchieve.GetAchIDs()
		TjAchieve.GetPersonalAchIDs()
		TjAchieve.GetGuildAchIDs()
		coroutine.yield()

		while (not buildStepUIAch()) do
			coroutine.yield()
		end

		-- Save our results:
		for i,ach in ipairs(tab) do
			ACH[ach] = true
		end
		tab = nil

		-- Find first visible in series for each:
		for ach,v in pairs(ACH) do
			if (v == -1) then
				getFirstSeenInSeries_precache = true
				local id = getFirstSeenInSeries(ach)  -- This call is fast enough (at least with getFirstSeenInSeries_precache true) that we don't do any yields. If it becomes slower for some reason, consider adding one after every so many calls to it.
				getFirstSeenInSeries_precache = nil
				ACH[ach] = id or 0
			end
		end
		-- Handle possible changes to UI visibility:
		--do this earlier in case something changes while the cache is being built -- TjAchieve.Frame:RegisterEvent("ACHIEVEMENT_EARNED")

		-- We're done!
		TjAchieve.status_ACH = true
		if (TjAchieve.listeners_IDCache) then
			-- Inform the listeners:
			for i,func in ipairs(TjAchieve.listeners_IDCache) do
				local noerrors, ret2 = pcall(func)
				if (not noerrors) then
					C_Timer.After(0, function()  -- Use a timer so as to not interrupt what we're doing.
						error("TjAchieve encountered an error while calling an achievement ID cache listener. Check the listening function for problems. The original error message follows:|n" .. ret2)
					end)
				end
			end
			TjAchieve.listeners_IDCache = nil
		end
		idCacheBuildStep = nil -- Allow this do/end block to go out of scope
	end
end


function TjAchieve.BuildIDCache()
	if (TjAchieve.status_ACH == nil) then
		TjAchieve.status_ACH = false
		TjThreads.AddTask(idCacheBuildStep)
		return "started"
	end
	return TjAchieve.status_ACH and "complete" or "ongoing"
end

function TjAchieve.IsIDCacheReady()
	return not not TjAchieve.status_ACH
end

function TjAchieve.RushBuildIDCache()
	if (idCacheBuildStep) then
		TjThreads.RushTask(idCacheBuildStep)
	end
end

function TjAchieve.AddBuildIDCacheListener(func)
	if (TjAchieve.status_ACH == true) then
		C_Timer.After(0, func)
	else
		if (not TjAchieve.listeners_IDCache) then  TjAchieve.listeners_IDCache = {};  end
		TjAchieve.listeners_IDCache[#TjAchieve.listeners_IDCache + 1] = func
	end
end


local function createAssetLookupFunc(assetType, saveIndex)
	saveIndex = not not saveIndex
	ASSETS[assetType] = { ["saveIndex"] = saveIndex } -- Important that this happens before the function is ever called.
	return function()
		--print("task start",assetType)
		local tab = ASSETS[assetType]
		local list = TjAchieve.GetAchIDs()
		local _, critType
		local numc, i
		local GetAchievementCriteriaInfo = GetAchievementCriteriaInfo
		local GetAchievementNumCriteria = GetAchievementNumCriteria
		local yieldIn = BUILD_CRIT_STEPS
		for x,id in ipairs(list) do
			--for i=1,GetAchievementNumCriteria(id) do
			numc = GetAchievementNumCriteria(id)
			i = 1
			repeat
				_, critType, _, _, _, _, _, assetID = GetAchievementCriteriaInfo(id, i)
				if (critType and critType == assetType and assetID and assetID ~= 0) then
					if (tab[assetID]) then
						local v = tab[assetID]
						if (type(v) == "table") then
							local size = #v
							v[size+1] = id
							if (saveIndex) then  v[size+2] = i;  end
						else
							tab[assetID] = { v, id }  -- Safe to assume saveIndex isn't true since this wasn't already a table
						end
					else
						if (saveIndex) then
							tab[assetID] = { id, i }
						else
							tab[assetID] = id
						end
					end
				end
				i = i + 1
			until (i > numc or not assetID)

			yieldIn = yieldIn - 1
			if (yieldIn < 1) then
				--print("yield after", id,"(",assetType,")")
				coroutine.yield()
				yieldIn = BUILD_CRIT_STEPS
			end
		end

		-- We're done!
		TjAchieve.status_CA[assetType] = true
		if (TjAchieve.listeners_CACache and TjAchieve.listeners_CACache[assetType]) then
			for i,func in ipairs(TjAchieve.listeners_CACache[assetType]) do
				local noerrors, ret2 = pcall(func, assetType)
				if (not noerrors) then
					C_Timer.After(0, function()  -- Use a timer so as to not interrupt what we're doing.
						error("TjAchieve encountered an error while updating a criteria asset cache listener. Check the listening function for problems. The original error message follows:|n" .. ret2)
					end)
				end
			end
			TjAchieve.listeners_CACache[assetType] = nil
			if (next(TjAchieve.listeners_CACache) == nil) then -- Is the table empty?
				TjAchieve.listeners_CACache = nil
			end
		end
		TjAchieve.CritAssetTasks[assetType] = nil
		if (next(TjAchieve.CritAssetTasks) == nil) then -- Is the table empty?
			TjAchieve.CritAssetTasks = nil
		end
		--print("task complete",assetType)
	end
end


function TjAchieve.BuildCritAssetCache(assetType, saveIndex)
	assert(type(assetType) == "number", "Usage: TjAchieve.BuildCritAssetCache(assetType[, saveIndex])")
	if (not TjAchieve.status_CA) then  TjAchieve.status_CA = {};  end
	if (saveIndex and ASSETS[assetType] and not ASSETS[assetType]["saveIndex"]) then
		-- If we want to save the index but the currently cached data doesn't do so:
		TjAchieve.status_CA[assetType] = nil
		if (TjAchieve.CritAssetTasks and TjAchieve.CritAssetTasks[assetType]) then
			TjThreads.RemoveTask(TjAchieve.CritAssetTasks[assetType])
			TjAchieve.CritAssetTasks[assetType] = nil
		end
	end
	if (TjAchieve.status_CA[assetType] == nil) then
		TjAchieve.status_CA[assetType] = false
		local func = createAssetLookupFunc(assetType, saveIndex)
		if (not TjAchieve.CritAssetTasks) then  TjAchieve.CritAssetTasks = {};  end
		TjAchieve.CritAssetTasks[assetType] = func
		TjThreads.AddTask(func)
		return "started"
	end
	return TjAchieve.status_CA[assetType] and "complete" or "ongoing"
end

function TjAchieve.IsCritAssetCacheReady(assetType)
	if (TjAchieve.status_CA and TjAchieve.status_CA[assetType]) then
		return ASSETS[assetType]["saveIndex"] and 2 or 1
	end
	return false
end

function TjAchieve.RushBuildCritAssetCache(assetType, saveIndex)
	assert(type(assetType) == "number", "Usage: TjAchieve.RushBuildCritAssetCache(assetType[, saveIndex])")
	TjAchieve.BuildCritAssetCache(assetType, saveIndex)
	assert(TjAchieve.CritAssetTasks[assetType])
	TjThreads.RushTask(TjAchieve.CritAssetTasks[assetType])
end

function TjAchieve.AddBuildCritAssetCacheListener(assetType, func)
	if (TjAchieve.status_CA and TjAchieve.status_CA[assetType] == true) then
		C_Timer.After(0, func)
	else
		if (not TjAchieve.listeners_CACache) then  TjAchieve.listeners_CACache = {};  end
		if (not TjAchieve.listeners_CACache[assetType]) then  TjAchieve.listeners_CACache[assetType] = {};  end
		TjAchieve.listeners_CACache[assetType][#TjAchieve.listeners_CACache[assetType] + 1] = func
	end
end


--[[
function TjAchieve.TestBuild(assetType, saveIndex)
	TjAchieve.AddBuildCritAssetCacheListener(assetType, function()
		print("Build Complete")
	end)
	print("Start Build")
	--return TjAchieve.BuildCritAssetCache(0, true)
	return TjAchieve.BuildCritAssetCache(assetType, saveIndex)
end
-- /dump TjAchieve.TestBuild(8)
-- /dump TjAchieve.TestBuild(0, true)
-- /dump TjAchieve.IsCritAssetCacheReady(0)
-- /dump TjAchieve.GetAchievementByAsset(8, 10068)
-- /dump TjAchieve.GetCriteriaByAsset(8, 10068)
--]]
