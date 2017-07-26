local LookingForGroup_Options = LibStub("AceAddon-3.0"):GetAddon("LookingForGroup_Options")

local function normal_pattern(s)
	if s == " " then
		return "-"
	else
		return ""
	end
end

local function player_armory_name(playername,pattern)
	local name,realm = strsplit("-",playername)
	if realm == nil then
		realm = GetRealmName()
	end
	realm = realm:gsub("[ ']",pattern)
	return name,realm
end

local function region_name()
	local region = GetCurrentRegion()
	if region == 1 then
		return "us"
	elseif region == 2 then
		return "kr"
	elseif region == 3 then
		return "eu"
	elseif region == 4 then
		return "tw"
	elseif region == 5 then
		return "cn"
	end
end

LookingForGroup_Options.armory =
{
	["Battle.net"] = function(playername)
		local name,realm = player_armory_name(playername,normal_pattern)
		local region = GetCurrentRegion()
		if region == 1 then
			return "https://worldofwarcraft.com/en-us/character/"..realm.."/"..name
		elseif region == 2 then
			return "https://worldofwarcraft.com/ko-kr/character/"..realm.."/"..name
		elseif region == 3 then
			return "https://worldofwarcraft.com/en-gb/character/"..realm.."/"..name
		elseif region == 4 then
			return "https://worldofwarcraft.com/zh-tw/character/"..realm.."/"..name
		elseif region == 5 then
			return "http://www.battlenet.com.cn/wow/zh/character/"..realm.."/"..name.."/simple"
		end
	end,
	WarcraftLogs = function(playername)
		local name,realm = player_armory_name(playername,normal_pattern)
		local reg = region_name()
		if reg then
			return "https://www.warcraftlogs.com/character/"..reg.."/"..realm.."/"..name
		end
	end,	
	["Ask Mr. Robot"] = function(playername)
		local name,realm = player_armory_name(playername,normal_pattern)
		local reg = region_name()
		if reg then
			return "https://www.askmrrobot.com/wow/player/"..reg.."/"..realm.."/"..name
		end
	end,
	Guildox = function(playername)
		local name,realm = player_armory_name(playername,normal_pattern)
		local reg = region_name()
		if reg then
			return "http://guildox.com/toon/"..reg.."/"..realm.."/"..name
		end
	end,
	WoWProgress = function(playername)
		local name,realm = player_armory_name(playername,normal_pattern)
		local reg = region_name()
		if reg then
			return "https://www.wowprogress.com/character/"..reg.."/"..realm.."/"..name
		end
	end,
}
