local LookingForGroup_AV = LibStub("AceAddon-3.0"):GetAddon("LookingForGroup_AV")
local InviteUnit = InviteUnit
local LeaveParty = LeaveParty
local LookingForGroup_AV_SendCommand = LookingForGroup_AV.SendCommand
local GetNumGroupMembers = GetNumGroupMembers
local UnitName = UnitName
local table_insert = table.insert

local party_leader = {}

local function isp()
	return 0 < LookingForGroup_AV.db.profile.role
end

local function isrl(rl)
	return LookingForGroup_AV.db.profile.raid_leader == rl
end

party_leader[1] = function(rl,name)-- party_leader.invite(rl,name)
	if isp() and isrl(rl) then
		InviteUnit(name)
	end
end

local invite_temp

local function cinvite()
	LookingForGroup_AV.SetRole(1)
	local i
	for i = 1,#invite_temp do
		InviteUnit(nms[i])
	end
end

party_leader[2] = function(rl,...)-- party_leader.create_invite(rl,...)
	if isrl(rl) then
		invite_temp = {...}
		if UnitInParty("player") then
			LeaveParty()
			LookingForGroup_AV:ScheduleTimer(cinvite,3)
		else
			cinvite()
		end
	end
end

--[[function LookingForGroup_AV.party_leave_raid()
	if isp() then
		LookingForGroup_AV.SetRole(0)
		local profile = LookingForGroup_AV.db.profile
		local raid_leader = profile.raid_leader
		LookingForGroup_AV:SendCommand(serialize,"WHISPER",raid_leader)
		profile.raid_leader = nil
	end
end]]

local confirm_instruction = LookingForGroup_AV:Serialize(1,4)

party_leader[3] = function(rl)-- party_leader.roleconfirm(rl)
	if isrl(rl) then
		LookingForGroup_AV_SendCommand(LookingForGroup_AV,confirm_instruction,"PARTY")
	end
end

party_leader[4] = function(pm,...) -- party_leader.send_chat_message(pm,...)
	if isp() and UnitInParty(pm) then
		LookingForGroup_AV:SendCommand(LookingForGroup_AV:Serialize(3,2,pm,...),"WHISPER",LookingForGroup_AV.db.profile.raid_leader)
	end
end

party_leader[5] = function(rl,...) -- party_leader.broadcast_chat_message(rl,...)
	if isrl(rl) then
		LookingForGroup_AV:SendCommand(LookingForGroup_AV:Serialize(1,3,...),"PARTY")
	end
end

local members = {}

function LookingForGroup_AV:GROUP_ROSTER_UPDATE()
	if isp() then
		local profile = LookingForGroup_AV.db.profile
		local raid_leader = profile.raid_leader
		local numgm = GetNumGroupMembers()
		wipe(members)
		local i
		for i = 1,numgm do
			local name = UnitName("party"..i)
			table_insert(members,name)
		end
		LookingForGroup_AV:SendCommand(LookingForGroup_AV:Serialize(3,1,members),"WHISPER",raid_leader)
	end
end

LookingForGroup_AV.member[2] = party_leader
