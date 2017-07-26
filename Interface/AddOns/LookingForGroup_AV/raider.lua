local LookingForGroup_AV = LibStub("AceAddon-3.0"):GetAddon("LookingForGroup_AV")
local CompleteLFGRoleCheck = CompleteLFGRoleCheck
local wipe = wipe
local string_find = string.find
local C_LFGList_GetSearchResultInfo = C_LFGList.GetSearchResultInfo
local C_LFGList_CancelApplication = C_LFGList.CancelApplication
local UnitIsGroupLeader = UnitIsGroupLeader

local raider = {}

local rl_tb = {}

raider[1] = function(rl) -- raider.accept(rl)
	local id = rl_tb[rl]
	if id~=nil then
		wipe(rl_tb)
		LookingForGroup_AV.db.profile.raid_leader = rl
		C_LFGList_CancelApplication(id)
	end
end

raider[2] = function(rl) -- raider.party_accept(rl)
	local id = rl_tb[rl]
	if id~=nil then
		wipe(rl_tb)
		local profile = LookingForGroup_AV.db.profile
		profile.role = 1
		profile.raid_leader = rl
		C_LFGList_CancelApplication(id)
		LookingForGroup_AV:GROUP_ROSTER_UPDATE()
	end
end


raider[3] = function(pl,nm,msg) -- raider.print_chat_message(pl,nm,msg)
	if UnitIsGroupLeader(pl) then
		print("[V]["..nm.."]:",msg)
	end
end

raider[4] = function(pl) -- raider.roleconfirm(pl)
	if UnitIsGroupLeader(pl) then
		CompleteLFGRoleCheck(true)
	end
end

function LookingForGroup_AV:ChatCommand(msg)
	LookingForGroup_AV:SendCommand(LookingForGroup_AV:Serialize(2,4,msg),"PARTY")
end

function LookingForGroup_AV.ApplyToGroup(resultID, comment, ...)
	LookingForGroup_AV.SetRole(0)
	LookingForGroup_AV.db.profile.raid_leader = nil
	local leadername = select(13,C_LFGList_GetSearchResultInfo(resultID))
	if not string_find(leadername,'-') then
		rl_tb[leadername] = resultID
	end
	C_LFGList.ApplyToGroup(resultID, "#AV#"..comment,...)
end

LookingForGroup_AV.member[1] = raider
