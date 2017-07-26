local LibStub = LibStub
local AceAddon = LibStub("AceAddon-3.0")
local LookingForGroup = AceAddon:GetAddon("LookingForGroup")
local LookingForGroup_Options = AceAddon:GetAddon("LookingForGroup_Options")
local L = LibStub("AceLocale-3.0"):GetLocale("LookingForGroup_Options")

LookingForGroup_Options:push("options",{
	name = OPTIONS,
	type = "group",
	args =
	{
		icon =
		{
			name = EMBLEM_SYMBOL,
			type = "toggle",
			get = function(info)
				return LookingForGroup.db.profile.enable_icon
			end,
			set = function(info,val)
				LookingForGroup.db.profile.enable_icon = val
				if val then
					LoadAddOn("LookingForGroup_Icon")
				end
				local LookingForGroup_Icon = AceAddon:GetAddon("LookingForGroup_Icon")
				LookingForGroup_Icon:OnEnable()
			end
		},
		hook =
		{
			name = "Hook",
			type = "toggle",
			get = function(info)
				return LookingForGroup.db.profile.enable_hook
			end,
			set = function(info,val)
				LookingForGroup.db.profile.enable_hook = val
				if val then
					LoadAddOn("LookingForGroup_Hook")
				end
				local LookingForGroup_Hook = AceAddon:GetAddon("LookingForGroup_Hook")
				LookingForGroup_Hook:OnEnable()
			end
		},
		event =
		{
			name = "Event",
			type = "toggle",
			get = function(info)
				return LookingForGroup.db.profile.enable_event
			end,
			set = function(info,val)
				LookingForGroup.db.profile.enable_event = val
				if val then
					LoadAddOn("LookingForGroup_Event")
				end
				local LookingForGroup_Event = AceAddon:GetAddon("LookingForGroup_Event")
				LookingForGroup_Event:OnEnable()
			end
		},
		av =
		{
			name = GetMapNameByID(401),
			type = "toggle",
			get = function(info)
				return LookingForGroup.db.profile.enable_av
			end,
			set = function(info,val)
				if val then
					LookingForGroup.db.profile.enable_av = true
				else
					LookingForGroup.db.profile.enable_av = nil
				end
				if val then
					LoadAddOn("LookingForGroup_AV")
				end
				local LookingForGroup_AV = AceAddon:GetAddon("LookingForGroup_AV")
				LookingForGroup_AV:OnEnable()
				LookingForGroup_Options:EnableAV()
			end,
		},
		sf =
		{
			name = SPAM_FILTER,
			type = "toggle",
			get = function(info)
				return LookingForGroup.db.profile.enable_sf
			end,
			set = function(info,val)
				LookingForGroup.db.profile.enable_sf = val
				if val then
					LoadAddOn("LookingForGroup_SF")
				end
				local LookingForGroup_SF = AceAddon:GetAddon("LookingForGroup_SF")
				LookingForGroup_SF:OnEnable()
			end,
		},
		wq =
		{
			name = TRACKER_HEADER_WORLD_QUESTS,
			type = "toggle",
			get = function(info)
				return LookingForGroup.db.profile.enable_wq
			end,
			set = function(info,val)
				LookingForGroup.db.profile.enable_wq = val
				if val then
					LoadAddOn("LookingForGroup_WQ")
				end
				local LookingForGroup_WQ = AceAddon:GetAddon("LookingForGroup_WQ")
				LookingForGroup_WQ:OnEnable()
			end,
		},
		role_check =
		{
			name = LFG_LIST_ROLE_CHECK,
			type = "toggle",
			get = function(info)
				return LookingForGroup.db.profile.role_check
			end,
			set = function(info,val)
				if val then
					LookingForGroup.db.profile.role_check = true
				else
					LookingForGroup.db.profile.role_check = nil
				end
			end,
		},
		hardware =
		{
			name = HARDWARE,
			type = "toggle",
			get = function(info)
				return LookingForGroup.db.profile.hardware
			end,
			set = function(info,val)
				if val then
					LookingForGroup.db.profile.hardware = true
				else
					LookingForGroup.db.profile.hardware = nil
				end
			end,
		},
		music =
		{
			name = ENABLE_MUSIC,
			type = "group",
			args =
			{
				enable_music =
				{
					name = ENABLE_MUSIC,
					type = "toggle",
					order = 1,
					get = function(info)
						return LookingForGroup_Options.db.profile.background_enable_music
					end,
					set = function(info,val)
						if val then
							LookingForGroup_Options.db.profile.background_enable_music = true
						else
							LookingForGroup_Options.db.profile.background_enable_music = nil
						end
					end,
				},
				chat =
				{
					name = SYSTEM_MESSAGES,
					desc = KBASE_SEARCH_RESULTS,
					order = 2,
					type = "toggle",
					get = function(info)
						return LookingForGroup_Options.db.profile.background_message
					end,
					set = function(info,val)
						if val then
							LookingForGroup_Options.db.profile.background_message = true
						else
							LookingForGroup_Options.db.profile.background_message = nil
						end
					end,
				},
				sr =
				{
					name = KBASE_SEARCH_RESULTS,
					order = 3,
					type = "input",
					get = function(info)
						return LookingForGroup_Options.db.profile.background_music
					end,
					set = function(info,val)
						LookingForGroup_Options.db.profile.background_music = val
					end,
					width = "full",
				},
				cancel = 
				{
					name = CANCEL,
					order = 4,
					type = "execute",
					func = function()
						LookingForGroup_Options:RestoreDBVariable("background_music")
						LookingForGroup.db.profile.background_enable_music = nil
						LookingForGroup.db.profile.background_message = nil
					end
				},
			}
		},
		addons =
		{
			name = ADDONS,
			desc = L["Pretend we are using other LFG addons"],
			type = "group",
			args =
			{
				meeting_stone =
				{
					name = "Meeting Stone",
					type = "toggle",
					set = function(_,val)
						if val then 
							LookingForGroup_Options.db.profile.addon_meeting_stone = true
						else
							LookingForGroup_Options.db.profile.addon_meeting_stone = nil
						end
					end,
					get = function() return LookingForGroup_Options.db.profile.addon_meeting_stone end,
				}
			}
		},
		wq_config = 
		{
			name = TRACKER_HEADER_WORLD_QUESTS,
			type = "group",
			args =
			{
				leave_party =
				{
					name = PARTY_LEAVE,
					type = "toggle",
					get = function(info)
						return LookingForGroup.db.profile.wq_leave_party
					end,
					set = function(info,val)
						if val then
							LookingForGroup.db.profile.wq_leave_party = true
						else
							LookingForGroup.db.profile.wq_leave_party = nil
						end
					end,
				}
			}
		},
	}
})
