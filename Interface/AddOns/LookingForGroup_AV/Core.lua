local LookingForGroup = LibStub("AceAddon-3.0"):GetAddon("LookingForGroup")
local LookingForGroup_AV = LibStub("AceAddon-3.0"):NewAddon("LookingForGroup_AV","AceEvent-3.0","AceTimer-3.0","AceComm-3.0","AceSerializer-3.0","AceConsole-3.0")

local C_LFGList = C_LFGList
local string_match = string.match
local string_find = string.find
local C_LFGList_GetApplicantInfo = C_LFGList.GetApplicantInfo
local C_LFGList_ApplyToGroup = C_LFGList.ApplyToGroup
local C_LFGList_DeclineApplicant = C_LFGList.DeclineApplicant

function LookingForGroup_AV:OnInitialize()
	self.db = LibStub("AceDB-3.0"):New("LookingForGroup_AVCharacterDB",
	{
		profile =
		{
			role = 0,
			parties =
			{
			},
			potentials =
			{},
--			raid_leader = nil
		}
	},true)
	self:RegisterComm("LFG_AV")
end

function LookingForGroup_AV:OnEnable()
	if LookingForGroup.db.profile.enable_av then
		self:RegisterEvent("GROUP_ROSTER_UPDATE")
		self:RegisterChatCommand("v","ChatCommand")
	else
		self:UnregisterEvent("GROUP_ROSTER_UPDATE")
		self:UnregisterChatCommand("v","ChatCommand")
	end
end

function LookingForGroup_AV.SetRole(role)
	LookingForGroup_AV.db.profile.role = role
end

function LookingForGroup_AV.GetRole()
	return LookingForGroup_AV.db.profile.role
end
LookingForGroup_AV.member = {}
local member = LookingForGroup_AV.member

local function transfer_info(unit,...)
	local suc, obj,method = ...
	if suc then
		member[obj][method](unit,select(4,...))
	end
end

function LookingForGroup_AV:OnCommReceived(prefix, text, distribution, unit)
	transfer_info(unit,self:Deserialize(text))
end

function LookingForGroup_AV:SendCommand(...)
	LookingForGroup_AV:SendCommMessage("LFG_AV",...)
end
