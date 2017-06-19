
local L = OVERACHIEVER_STRINGS

local showUnknownToasts = true

local getCalendarTextureFile


Overachiever.HOLIDAY_REV = { -- lookup table to support localization
--	["Localized holiday/event name"] = "The key we're using for this holiday/event",
	[L.HOLIDAY_DARKMOONFAIRE] = "Darkmoon Faire",
	[L.HOLIDAY_LUNARFESTIVAL] = "Lunar Festival",
	[L.HOLIDAY_LOVEISINTHEAIR] = "Love is in the Air",
	[L.HOLIDAY_NOBLEGARDEN] = "Noblegarden",
	[L.HOLIDAY_CHILDRENSWEEK] = "Children's Week",
	[L.HOLIDAY_MIDSUMMER] = "Midsummer Fire Festival",
	[L.HOLIDAY_PIRATESDAY] = "Pirates' Day",
	[L.HOLIDAY_BREWFEST] = "Brewfest",
	[L.HOLIDAY_HALLOWSEND] = "Hallow's End",
	[L.HOLIDAY_DAYOFTHEDEAD] = "Day of the Dead",
	[L.HOLIDAY_PIGRIMSBOUNTY] = "Pilgrim's Bounty",
	[L.HOLIDAY_WINTERVEIL] = "Feast of Winter Veil",
	-- Aliases: (used by Suggestions tab but not the title the in-game calendar uses)
	[L.HOLIDAY_MIDSUMMER_SHORT] = "Midsummer",
	[L.HOLIDAY_WINTERVEIL_SHORT] = "Winter Veil",
}

local HOLIDAYS_OPTIONS = {
	--"Brewfest" = {}, -- Nothing for this one. "The Brewfest Diet" can be completed when it's not Brewfest (if you already bought the food).
}

local function getHolidayAutoOptions(localizedEventTitle)
	local key = Overachiever.HOLIDAY_REV[localizedEventTitle] or localizedEventTitle
	return HOLIDAYS_OPTIONS[key]
end


local function getEventEnding(title, calendarType, yearStart, monthStart, dayStart)
	local _, _, numDays = TjCalendar.StartReadingAt(yearStart, monthStart, true)
	local m = 0 -- Month offset
	local day = dayStart
	for i = 1, 100 do -- Look up to 100 days away, which should be more than enough; this is a failsafe.
		local numEvents = CalendarGetNumDayEvents(m, day)
		for e = 1, numEvents do
			local title2, hour, minute, calendarType2, sequenceType = CalendarGetDayEvent(m, day, e)
			if (sequenceType == "END" and title == title2 and calendarType == calendarType2) then
				local month, year = CalendarGetMonth(m)
				TjCalendar.StopReading()
				return year, month, day, hour, minute
			end
		end
		day = day + 1
		if (day > numDays) then
			day = 1
			m = m + 1 -- !! This can't effectively go over 1. Thought it worked before, but apparently no longer. Leaving as is for now since there is no event over a month in length anyway.
			_, _, numDays = CalendarGetMonth(m)
		end
	end
	TjCalendar.StopReading()
	return nil, nil, nil, nil, nil
end

local lastEvents = {}
local lastCheckedDay, lastCheckedMonth
local eventsExpireHour, eventsExpireMinute = false, false

function Overachiever.GetTodaysEvents(cachekey, unexpiredOnly, searchEndDate, filterFunc)
	--return Overachiever.GetHolidayEvents(2016, 10, 5, 1, cachekey, unexpiredOnly, searchEndDate, filterFunc)
	return Overachiever.GetHolidayEvents(nil, nil, nil, nil, cachekey, unexpiredOnly, searchEndDate, filterFunc)
end

--/dump Overachiever.GetHolidayEvents(2017, 2, 1, 1, -1, true, true)
function Overachiever.GetHolidayEvents(year, month, day, hourOverride, cachekey, unexpiredOnly, searchEndDate, filterFunc)
	-- Make sure to use a unique cachekey for each combination of your other arguments. Otherwise, you may get back cached data for some other arguments.
	cachekey = cachekey or 0
	local weekdayNow, monthNow, dayNow, yearNow = CalendarGetDate()
	local hourNow, minuteNow = GetGameTime()
	if (lastCheckedDay == dayNow and lastCheckedMonth == monthNow and lastEvents[cachekey]) then
		if (eventsExpireHour == false or hourNow < eventsExpireHour or (hourNow == eventsExpireHour and minuteNow < eventsExpireMinute)) then
			return lastEvents[cachekey]
		end
	end
	lastCheckedDay = dayNow
	lastCheckedMonth = monthNow
	eventsExpireHour = false
	eventsExpireMinute = false

	year = year or yearNow
	month = month or monthNow
	day = day or dayNow
	hourNow = hourOverride or hourNow

	TjCalendar.StartReadingAt(year, month)
	--TjCalendar.StartReading()

	local result = nil
	local numEvents = CalendarGetNumDayEvents(0, day)
	local expired = {}
	for e = 1, numEvents do
		local title, hour, minute, calendarType, sequenceType, eventType, texture = CalendarGetDayEvent(0, day, e)
		--print(title, ",", calendarType, ",", sequenceType, ",", eventType, ",", texture)
		if (not expired[title] and calendarType == "HOLIDAY") then
			if (unexpiredOnly and sequenceType == "END" and (hour < hourNow or (hour == hourNow and minute <= minuteNow))) then
				expired[title] = true
				if (result) then  result[title] = nil;  end
			elseif (not filterFunc or filterFunc(title, texture)) then
				if (not result) then  result = {};  end
				--texture = getCalendarTextureFile(texture, calendarType, sequenceType, eventType)
				if (not result[title]) then  result[title] = {};  end
				if (not result[title]["texture"] or result[title]["texture"] == "") then
					local st = sequenceType
					--if (st ~= "") then  st = "START";  end
					if (st == "ONGOING" or st == "END") then  st = "START";  end

					--[[ CALENDAR_USE_SEQUENCE_FOR_EVENT_TEXTURE is hardcoded to true right now. It's safe to just treat it as true until that changes.
					if (not CalendarFrame) then  Calendar_LoadUI();  end  -- Need to load the calendar so CALENDAR_USE_SEQUENCE_FOR_EVENT_TEXTURE is defined by Blizzard_Calendar.lua.
					if (CALENDAR_USE_SEQUENCE_FOR_EVENT_TEXTURE) then
					--]]
						local event = C_Calendar.GetDayEvent(0, day, e)
						if (event.numSequenceDays == 2) then  st = "";  end
					--[[
					end
					--]]

					result[title]["texture"] = getCalendarTextureFile(texture, calendarType, st, eventType)
					result[title]["texture_unpathed"] = texture
				end
				if (not result[title]["desc"]) then
					local _, description = CalendarGetHolidayInfo(0, day, e)
					result[title]["desc"] = description
				end
				if (sequenceType == "START")  then
					result[title]["hourStart"] = hour
					result[title]["minuteStart"] = minute
				elseif (sequenceType == "END")  then
					result[title]["hourEnd"] = hour
					result[title]["minuteEnd"] = minute
					if (eventsExpireHour == false or (eventsExpireHour > hour or (eventsExpireHour == hour and eventsExpireMinute > minute))) then
						eventsExpireHour = hour
						eventsExpireMinute = minute
					end
				end
			end
		end
	end

	TjCalendar.StopReading()

	if (searchEndDate and result) then
		for title,arr in pairs(result) do
			if (not arr["hourEnd"]) then
				arr["yearEnd"], arr["monthEnd"], arr["dayEnd"], arr["hourEnd"], arr["minuteEnd"] = getEventEnding(title, "HOLIDAY", year, month, day)
				--print("getEventEnding(",title,", \"HOLIDAY\", ",month,", ",day,")")
				--print(arr["yearEnd"], arr["monthEnd"], arr["dayEnd"], arr["hourEnd"], arr["minuteEnd"])
			end
		end
	end
	if (cachekey ~= -1) then  lastEvents[cachekey] = result;  end
	return result
end

--[[
--/run DEBUG_GETALLEVENTS()
function DEBUG_GETALLEVENTS()
	local m = 1 -- Start month
	local events = {}
	--local _, _, numDays = TjCalendar.StartReadingAt(nil, 1, true) -- Start at first month of this year
	local _, _, numDays = TjCalendar.StartReadingAt(nil, m, true)
	local day = 1
	for i = 1, 366 do -- Look up to 366 days away (365 + 1 in case it's a leap year)
		local numEvents = CalendarGetNumDayEvents(0, day)
		for e = 1, numEvents do
			local title, _, _, calendarType, sequenceType, _, texture = CalendarGetDayEvent(0, day, e)
			if (calendarType == "HOLIDAY") then --and sequenceType == "START") then
				if (not texture) then  texture = 0;  end
				if (events[title]) then
					events[title][#(events[title])] = texture
				else
					events[title] = { texture }
				end
			end
		end
		day = day + 1
		if (day > numDays) then
			day = 1
			m = m + 1
			if (m > 12) then  break;  end
			--_, _, numDays = CalendarGetMonth(m)
			TjCalendar.StopReading()
			_, _, numDays = TjCalendar.StartReadingAt(nil, m, true)
		end
	end
	TjCalendar.StopReading()

	C_Timer.After(0, function()
		local s = ""
		for k,v in pairs(events) do
			v = table.concat(v, ",")
			s = s .. '["' .. v .. '"] = "edit_this",				-- ' .. k .. "\r\n"
		end
		error(s)
	end)

	return events
end
--]]

local EVENT_TEXTURE_LOOKUP = {
	["calendar_volunteerguardday"] = "micro",				-- Volunteer Guard Day
	["calendar_weekendpetbattles"] = "bonus",				-- Pet Battle Bonus Event
	["calendar_glowcapfestival"] = "micro",					-- Glowcap Festival
	["Calendar_HallowsEnd"] = "holiday",					-- Hallow's End
	["calendar_weekendlegion"] = "dungeon",					-- Legion Dungeon Event
	["calendar_weekendpvpskirmish"] = "bonus",				-- Arena Skirmish Bonus Event
	["calendar_hatchingofthehippogryphs"] = "micro",		-- Hatching of the Hippogryphs
	["calendar_ungoromadness"] = "micro",					-- Un'Goro Madness
	["calendar_fireworks"] = "holiday",						-- Fireworks Celebration
	["Calendar_LoveInTheAir"] = "holiday",					-- Love is in the Air
	["calendar_thousandboatbash"] = "micro",				-- Thousand Boat Bash
	["calendar_weekendworldquest"] = "bonus",				-- World Quest Bonus Event
	["Calendar_Brewfest"] = "holiday",						-- Brewfest
	["Calendar_HarvestFestival"] = "holiday",				-- Harvest Festival
	["calendar_springballoonfestival"] = "micro",			-- Spring Balloon Festival
	["calendar_taverncrawl"] = "micro",						-- Kirin Tor Tavern Crawl
	["calendar_fireworks"] = "holiday",						-- Fireworks Spectacular
	["Calendar_LunarFestival"] = "holiday",					-- Lunar Festival
	["Calendar_PiratesDay"] = "holiday",					-- Pirates' Day
	["Calendar_Midsummer"] = "holiday",						-- Midsummer Fire Festival
	["Calendar_WinterVeil"] = "holiday",					-- Feast of Winter Veil
	["calendar_marchofthetadpoles"] = "micro",				-- March of the Tadpoles
	["Calendar_DayOfTheDead"] = "holiday",					-- Day of the Dead
	["Calendar_ChildrensWeek"] = "holiday",					-- Children's Week
	["Calendar_Noblegarden"] = "holiday",					-- Noblegarden
	["calendar_weekendbattlegrounds"] = "bonus",			-- Battleground Bonus Event
	["calendar_darkmoonfaireterokkar"] = "holiday",			-- Darkmoon Faire
	["calendar_callofthescarab"] = "micro",					-- Call of the Scarab
	["calendar_brawl"] = "pvpbrawl",						-- PvP Brawl (any)
	-- Timewalking Dungeon Events:
	["calendar_weekendburningcrusade"] = "dungeon",
	["calendar_weekendwrathofthelichking"] = "dungeon",
	["calendar_weekendcataclysm"] = "dungeon",
	["calendar_weekendmistsofpandaria"] = "dungeon",
}

-- /run Overachiever.ToastForEvents(true, true, true, true)
function Overachiever.ToastForEvents(holiday, microholiday, bonusevent, dungeonevent, pvpbrawl)
	if (not holiday and not microholiday and not bonusevent and not dungeonevent) then  return;  end
	--print("ToastForEvents",holiday, microholiday, bonusevent, dungeonevent)

	local function filterEvents(localizedTitle, texture)
		--print(texture)
		local arr = EVENT_TEXTURE_LOOKUP[texture]
		if (not arr) then  return showUnknownToasts;  end
		local holidayType = type(arr) == "table" and arr[1] or arr
		--print("holidayType",holidayType)
		if     (holidayType == "holiday") then	return holiday
		elseif (holidayType == "micro") then	return microholiday
		elseif (holidayType == "bonus") then	return bonusevent
		elseif (holidayType == "dungeon") then	return dungeonevent
		elseif (holidayType == "pvpbrawl") then	return pvpbrawl
		end
	end

	local events = Overachiever.GetTodaysEvents(-1, true, nil, filterEvents)
	if (events) then
		--print("events:")
		for localizedEventTitle,tab in pairs(events) do
			local arr = EVENT_TEXTURE_LOOKUP[tab.texture_unpathed]
			local onClick
			local holidayType = type(arr) == "table" and arr[1] or arr
			if (holidayType == "holiday") then
				onClick = function()
					if (not AchievementFrame or not AchievementFrame:IsShown()) then
						ToggleAchievementFrame()
					end
					Overachiever.OpenSuggestionsTab(localizedEventTitle)
				end
			else
				onClick = function()
					Calendar_LoadUI()
					if (Calendar_Show) then  Calendar_Show();  end
				end
			end
			local achID = type(arr) == "table" and arr[2] or nil
			local delay
			if (Overachiever_Settings.ToastCalendar_noautofade) then
				delay = Overachiever_Settings.ToastCalendar_onlyclickfade and -1 or 0
			end
			--print("-",localizedEventTitle)
			Overachiever.ToastFakeAchievement(localizedEventTitle, achID, false, nil, delay, L.STARTTOAST_EVENT, onClick, tab.texture)
		end
	end
end


-- THIS SECTION IS FROM Blizzard_Calendar.lua (since it is entirely local there)
-----------------------------------------------------------------------------------

local CALENDAR_CALENDARTYPE_TEXTURE_PATHS = {
--	["PLAYER"]				= "",
--	["GUILD_ANNOUNCEMENT"]	= "",
--	["GUILD_EVENT"]			= "",
--	["SYSTEM"]				= "",
	["HOLIDAY"]				= "Interface\\Calendar\\Holidays\\",
--	["RAID_LOCKOUT"]		= "",
--	["RAID_RESET"]			= "",
};

local CALENDAR_CALENDARTYPE_TEXTURE_APPEND = {
--	["PLAYER"] = {
--	},
--	["GUILD_ANNOUNCEMENT"] = {
--	},
--	["GUILD_EVENT"] = {
--	},
--	["SYSTEM"] = {
--	},
	["HOLIDAY"] = {
		["START"]			= "Start",
		["ONGOING"]			= "Ongoing",
		["END"]				= "End",
		["INFO"]			= "Info",
		[""]				= "",
	},
--	["RAID_LOCKOUT"] = {
--	},
--	["RAID_RESET"] = {
--	},
};

local CALENDAR_CALENDARTYPE_TCOORDS = {
	["PLAYER"] = {
		left	= 0.0,
		right	= 1.0,
		top		= 0.0,
		bottom	= 1.0,
	},
	["GUILD_ANNOUNCEMENT"] = {
		left	= 0.0,
		right	= 1.0,
		top		= 0.0,
		bottom	= 1.0,
	},
	["GUILD_EVENT"] = {
		left	= 0.0,
		right	= 1.0,
		top		= 0.0,
		bottom	= 1.0,
	},
	["SYSTEM"] = {
		left	= 0.0,
		right	= 1.0,
		top		= 0.0,
		bottom	= 1.0,
	},
	["HOLIDAY"] = {
		left	= 0.0,
		right	= 0.7109375,
		top		= 0.0,
		bottom	= 0.7109375,
	},
	["RAID_LOCKOUT"] = {
		left	= 0.0,
		right	= 1.0,
		top		= 0.0,
		bottom	= 1.0,
	},
	["RAID_RESET"] = {
		left	= 0.0,
		right	= 1.0,
		top		= 0.0,
		bottom	= 1.0,
	},
};

local CALENDAR_EVENTTYPE_TEXTURE_PATHS = {
	[CALENDAR_EVENTTYPE_RAID]		= "Interface\\LFGFrame\\LFGIcon-",
	[CALENDAR_EVENTTYPE_DUNGEON]	= "Interface\\LFGFrame\\LFGIcon-",
};

local CALENDAR_EVENTTYPE_TCOORDS = {
	[CALENDAR_EVENTTYPE_RAID] = {
		left	= 0.0,
		right	= 1.0,
		top		= 0.0,
		bottom	= 1.0,
	},
	[CALENDAR_EVENTTYPE_DUNGEON] = {
		left	= 0.0,
		right	= 1.0,
		top		= 0.0,
		bottom	= 1.0,
	},
	[CALENDAR_EVENTTYPE_PVP] = {
		left	= 0.0,
		right	= 1.0,
		top		= 0.0,
		bottom	= 1.0,
	},
	[CALENDAR_EVENTTYPE_MEETING] = {
		left	= 0.0,
		right	= 1.0,
		top		= 0.0,
		bottom	= 1.0,
	},
	[CALENDAR_EVENTTYPE_OTHER] = {
		left	= 0.0,
		right	= 1.0,
		top		= 0.0,
		bottom	= 1.0,
	},
};

local CALENDAR_CALENDARTYPE_TEXTURES = {
	["PLAYER"] = {
--		[""]				= "",
	},
	["GUILD_ANNOUNCEMENT"] = {
--		[""]				= "",
	},
	["GUILD_EVENT"] = {
--		[""]				= "",
	},
	["SYSTEM"] = {
--		[""]				= "",
	},
	["HOLIDAY"] = {
		["START"]			= "Interface\\Calendar\\Holidays\\Calendar_DefaultHoliday",
--		["ONGOING"]			= "",
		["END"]				= "Interface\\Calendar\\Holidays\\Calendar_DefaultHoliday",
		["INFO"]			= "Interface\\Calendar\\Holidays\\Calendar_DefaultHoliday",
--		[""]				= "",
	},
	["RAID_LOCKOUT"] = {
--		[""]				= "",
	},
	["RAID_RESET"] = {
--		[""]				= "",
	},
};

local CALENDAR_EVENTTYPE_TEXTURES = {
	[CALENDAR_EVENTTYPE_RAID]		= "Interface\\LFGFrame\\LFGIcon-Raid",
	[CALENDAR_EVENTTYPE_DUNGEON]	= "Interface\\LFGFrame\\LFGIcon-Dungeon",
	[CALENDAR_EVENTTYPE_PVP]		= "Interface\\Calendar\\UI-Calendar-Event-PVP",
	[CALENDAR_EVENTTYPE_MEETING]	= "Interface\\Calendar\\MeetingIcon",
	[CALENDAR_EVENTTYPE_OTHER]		= "Interface\\Calendar\\UI-Calendar-Event-Other",
};


function getCalendarTextureFile(textureName, calendarType, sequenceType, eventType) -- from _CalendarFrame_GetTextureFile
	local texture, tcoords;
	if ( textureName and textureName ~= "" ) then
		if ( CALENDAR_CALENDARTYPE_TEXTURE_PATHS[calendarType] ) then
			texture = CALENDAR_CALENDARTYPE_TEXTURE_PATHS[calendarType]..textureName;
			if ( CALENDAR_CALENDARTYPE_TEXTURE_APPEND[calendarType] ) then
				texture = texture..CALENDAR_CALENDARTYPE_TEXTURE_APPEND[calendarType][sequenceType];
			end
			tcoords = CALENDAR_CALENDARTYPE_TCOORDS[calendarType];
		elseif ( CALENDAR_EVENTTYPE_TEXTURE_PATHS[eventType] ) then
			texture = CALENDAR_EVENTTYPE_TEXTURE_PATHS[eventType]..textureName;
			tcoords = CALENDAR_EVENTTYPE_TCOORDS[eventType];
		elseif ( CALENDAR_CALENDARTYPE_TEXTURES[calendarType][sequenceType] ) then
			texture = CALENDAR_CALENDARTYPE_TEXTURES[calendarType][sequenceType];
			tcoords = CALENDAR_CALENDARTYPE_TCOORDS[calendarType];
		elseif ( CALENDAR_EVENTTYPE_TEXTURES[eventType] ) then
			texture = CALENDAR_EVENTTYPE_TEXTURES[eventType];
			tcoords = CALENDAR_EVENTTYPE_TCOORDS[eventType];
		end
	elseif ( CALENDAR_CALENDARTYPE_TEXTURES[calendarType][sequenceType] ) then
		texture = CALENDAR_CALENDARTYPE_TEXTURES[calendarType][sequenceType];
		tcoords = CALENDAR_CALENDARTYPE_TCOORDS[calendarType];
	elseif ( CALENDAR_EVENTTYPE_TEXTURES[eventType] ) then
		texture = CALENDAR_EVENTTYPE_TEXTURES[eventType];
		tcoords = CALENDAR_EVENTTYPE_TCOORDS[eventType];
	end
	--print(textureName, calendarType, sequenceType, eventType)
	--print("-", texture, tcoords)
	return texture, tcoords;
end

-----------------------------------------------------------------------------------



--/dump CalendarGetDayEvent(0, 4, 1)
