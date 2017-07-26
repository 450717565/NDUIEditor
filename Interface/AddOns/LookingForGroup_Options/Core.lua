local LibStub = LibStub
local AceAddon = LibStub("AceAddon-3.0")
local AceDBOptions = LibStub("AceDBOptions-3.0")
local AceConfig = LibStub("AceConfig-3.0")
local AceConfigRegistry = LibStub("AceConfigRegistry-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")

local LookingForGroup = AceAddon:GetAddon("LookingForGroup")
local LookingForGroup_Options = AceAddon:GetAddon("LookingForGroup_Options")
local C_LFGList_ClearSearchResults = C_LFGList.ClearSearchResults

function LookingForGroup_Options:OnInitialize()
	local options = LookingForGroup_Options : get_table()
--	LookingForGroup_Options.option_table = nil
	self.db = LibStub("AceDB-3.0"):New("LookingForGroup_OptionsCharacterDB",
	{
		profile = 
		{
			cr_category = 1,
			a_group_category = 0,
			a_group_group = 0,
			a_group_activity = 0,
			start_a_group_title = "",
			start_a_group_details = "",
			start_a_group_minimum_item_level = 0,
			start_a_group_minimum_honor_level = 0,
			start_a_group_voice_chat = "",
			start_a_group_auto_accept = false,
			start_a_group_private = false,
			find_a_group_filter = "",
			find_a_group_encounters = {},
			background_music = "sound\\music\\gluescreenmusic\\wow_main_theme.mp3",
		}
	},true)
	options.args.profile = AceDBOptions:GetOptionsTable(LookingForGroup.db)
	AceConfig:RegisterOptionsTable("LookingForGroup", options, nil)
	LookingForGroup.db.RegisterCallback(LookingForGroup, "OnProfileChanged", "OnEnable")
	LookingForGroup.db.RegisterCallback(LookingForGroup, "OnProfileCopied", "OnEnable")
	LookingForGroup.db.RegisterCallback(LookingForGroup, "OnProfileReset", "OnEnable")
	self:RegisterEvent("LFG_LIST_APPLICANT_UPDATED")
	self:RegisterEvent("LFG_LIST_ACTIVE_ENTRY_UPDATE")
	if C_LFGList.GetActiveEntryInfo() then
		LookingForGroup_Options.set_requests()
	end
end

function LookingForGroup_Options:OnEnable()
	self:EnableAV()
	self:EnableQuickJoin()
end

function LookingForGroup_Options.IsSelected(groupname)
	local status_table = AceConfigDialog:GetStatusTable("LookingForGroup")
	if status_table.groups and status_table.groups.selected == groupname then
		return true
	end
end

function LookingForGroup_Options.NotifyChangeIfSelected(groupname)
	if LookingForGroup_Options.IsSelected(groupname) then
		AceConfigRegistry:NotifyChange("LookingForGroup")	
	end
end

function LookingForGroup_Options:SOCIAL_QUEUE_UPDATE()
	self.NotifyChangeIfSelected("quick_join")
end

function LookingForGroup_Options:LFG_LIST_ACTIVE_ENTRY_UPDATE()
	if C_LFGList.GetActiveEntryInfo() then
		if LookingForGroup_Options.option_table.args.requests == nil then
			LookingForGroup_Options.set_requests()
			AceConfigRegistry:NotifyChange("LookingForGroup")
		end
	else
		LookingForGroup_Options.clear_requests()
	end
end

function LookingForGroup_Options:RestoreDBVariable(key)
	self.db.profile[key] = self.db.defaults.profile[key]
end
