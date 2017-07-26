local LookingForGroup_AV = LibStub("AceAddon-3.0"):GetAddon("LookingForGroup_AV")
local LookingForGroup_AV_SendCommand = LookingForGroup_AV.SendCommand

local string_find = string.find
local table_insert = table.insert
local table_remove = table.remove
local next = next
local pairs = pairs
local UnitName = UnitName
local C_LFGList_GetApplicantInfo = C_LFGList.GetApplicantInfo
local C_LFGList_GetApplicantMemberInfo = C_LFGList.GetApplicantMemberInfo

local function name_is_same_realm(name)
	if string_find(name,'-') == nil then
		return false
	end
	return true
end

local function isr()
	return LookingForGroup_AV.GetRole() == 2
end

local function potential(potentials,name)
	if name_is_same_realm(name) then
		table_insert(potentials,name)
	end
	return name
end

local function party_assign(parties,potentials,name)
	local d = name_is_same_realm(name)
	local i
	local k,v
	for k,v in pairs(parties) do
		if #v < 4 then
			if d then
				table_insert(potentials,name)
			end
			LookingForGroup_AV:SendCommand(LookingForGroup_AV:Serialize(2,1,name),"WHISPER",k)
			return
		end
	end
	if d then
		table_insert(potentials,name)
		LookingForGroup_AV:SendCommand(LookingForGroup_AV:Serialize(1,1),"WHISPER",name)
	else
		local top = potentials[#potentials]
		if top ~= nil then
			LookingForGroup_AV:SendCommand(LookingForGroup_AV:Serialize(2,2,name),"WHISPER",top)
			parties[name] = {}
			table_remove(potentials,#potentials)
		end
	end
end

function LookingForGroup_AV.InviteApplicant(app_i)
	if isr() then
		local profile = LookingForGroup_AV.db.profile
		local parties = profile.parties
		local potentials = profile.potentials
		local id, status, pendingStatus, numMembers, isNew, comment = C_LFGList_GetApplicantInfo(app_i)
		local name = C_LFGList_GetApplicantMemberInfo(id,1)
		if numMembers == 1 then
			party_assign(parties,potentials,name)
		else
			if name_is_same_realm(name) then
				self:SendCommand(self:Serialize(1,2),"WHISPER",name)
				parties[name] = tb
			end
		end
	end
end

function LookingForGroup_AV.CreateListing(name,...)
	local profile = LookingForGroup_AV.db.profile
	if profile.raid_leader == nil then
		local parties = profile.parties
		LookingForGroup_AV.SetRole(2)
		local name = UnitName("player")
		parties[name]={}
		profile.raid_leader = name
	end
	if isr() then
		C_LFGList.CreateListing(44,"#AV#"..name,...)
	end
end

function LookingForGroup_AV.UpdateListing(name,...)
	if isr() then
		C_LFGList.UpdateListing(44,name,...)
	end
end

function LookingForGroup_AV.RemoveListing(...)
	if isr() then
		C_LFGList.RemoveListing(...)
	end
end

function LookingForGroup_AV.rl_disban()
	if isr() then
		local profile = LookingForGroup_AV.db.profile
		profile.raid_leader = nil
		profile.role = 0
		wipe(profile.parties)
	end
end

function LookingForGroup_AV.rl_roleconfirm()
	if isr() then
		local serialize = LookingForGroup_AV:Serialize(2,3)
		local parties = LookingForGroup_AV.db.profile.parties
		local k,v
		for k,v in pairs(parties) do
			LookingForGroup_AV_SendCommand(LookingForGroup_AV,serialize,"WHISPER",k)
		end
	end
end

local raid_leader = {}

raid_leader[1] = function(leader,members) --raid_leader.group_roster_update(leader,members)
	if isr() then
		local parties = LookingForGroup_AV.db.profile.parties
		if parties[leader] ~= nil then
			parties[leader] = members
		end
	end
end

raid_leader[2] = function(source,...) -- raid_leader.broadcast_chat_message(source,...)
	if isr() then
		local parties = LookingForGroup_AV.db.profile.parties
		if parties[source] ~= nil then
			local serialize = LookingForGroup_AV:Serialize(2,5,...)
			local k,v
			for k,v in pairs(parties) do
				LookingForGroup_AV_SendCommand(LookingForGroup_AV,serialize,"WHISPER",k)
			end
		end
	end
end

LookingForGroup_AV.member[3] = raid_leader
