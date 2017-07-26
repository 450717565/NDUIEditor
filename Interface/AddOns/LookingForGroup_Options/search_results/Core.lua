local LibStub = LibStub
local AceAddon = LibStub("AceAddon-3.0")
local LookingForGroup = AceAddon:GetAddon("LookingForGroup")
local LookingForGroup_Options = AceAddon:GetAddon("LookingForGroup_Options")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")
local table_insert = table.insert

local order = 0
local function get_order()
	local temp = order
	order = order +1
	return temp
end

local search_config_tb =
{
	name = KBASE_SEARCH_RESULTS,
	type = "group",
	childGroups = "tab",
}

local comment_text = ""

local failed_args =
{
	back = 
	{
		order = 1,
		name = BACK,
		type = "execute",
	},
	search_again = 
	{
		order = 2,
		name = LFG_LIST_SEARCH_AGAIN,
		type = "execute",
	},
	error_msg =
	{
		order = 3,
		name = LFG_LIST_SEARCH_FAILED,
		type = "description",
		width = "full"
	}
}

local select_sup = {}

--local signup_tb = 

local ApplyToGroup = LookingForGroup_Options.ApplyToGroup

function LookingForGroup_Options.SearchResults_ApplyToGroup(k,...)
	ApplyToGroup(k,comment_text,...)
end

local function default_signup()
	local k,v
	local tank,healer,dps = select(2,GetLFGRoles())
	for k,v in pairs(select_sup) do
		if v then
			ApplyToGroup(k,comment_text,tank,healer,dps)
		end
	end
end

local tank_icon = "|TInterface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES:16:16:0:0:64:64:0:19:22:41|t"
local healer_icon = "|TInterface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES:16:16:0:0:64:64:20:39:1:20|t"
local damager_icon = "|TInterface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES:16:16:0:0:64:64:20:39:22:41|t"
local role =
{
	name = ROLE,
	type = "group",
	order = 5,
	args =
	{
		tank = 
		{
			order = get_order(),
			name = tank_icon,
			desc = TANK,
			type = "toggle",
			get = function(info)
				return select(2,GetLFGRoles())
			end,
			set = function(info,val)
				local leader,tank,healer,damage = GetLFGRoles()
				SetLFGRoles(leader,val,healer,damage)
			end,
			width = "full",
		},
		healer = 
		{
			order = get_order(),
			name = healer_icon,
			desc = HEALER,
			type = "toggle",
			get = function(info)
				return select(3,GetLFGRoles())
			end,
			set = function(info,val)
				local leader,tank,healer,damage = GetLFGRoles()
				SetLFGRoles(leader,tank,val,damage)
			end,
			width = "full",
		},
		damage = 
		{
			order = get_order(),
			name = damager_icon,
			desc = DAMAGER,
			type = "toggle",
			get = function(info)
				return select(4,GetLFGRoles())
			end,
			set = function(info,val)
				local leader,tank,healer,damage = GetLFGRoles()
				SetLFGRoles(leader,tank,healer,val)
			end,
			width = "full",
		},
		comment =
		{
			order = get_order(),
			name = COMMENT,
			type = "input",
			multiline = true,
			width = "full",
			set = function(info,val)
				comment_text = val
			end,
			get = function(info) return comment_text end,
		}
	}
}

function LookingForGroup_Options.CreateReceivedArgs(dialogControl,values,group,custom_signup)
	local args =
	{
		back = 
		{
			order = 1,
			name = BACK,
			type = "execute",
			func = function()
				LookingForGroup_Options.Background_Timer_Stop()
				LookingForGroup_Options.Background_NoSearchResult_StartMusic()
				C_LFGList.ClearSearchResults()
				wipe(select_sup)
				LookingForGroup_Options.reset_search_result()
				AceConfigDialog:SelectGroup("LookingForGroup",group)
			end
		},
		search_again = 
		{
			order = 2,
			name = LFG_LIST_SEARCH_AGAIN,
			type = "execute",
		},
		sign_up =
		{
			order = 3,
			name = SIGN_UP,
			type = "execute",
			func = custom_signup or default_signup
		},
		results =
		{
			name = KBASE_SEARCH_RESULTS,
			desc = LFG_LIST_SELECT_A_SEARCH_RESULT,
			type = "group",
			order = 4,
			args =
			{
				result =
				{
					name = " ",
					type = "multiselect",
					dialogControl = dialogControl,
					values = values,
					get = function(info,val)	return select_sup[val] end,
					width = "full",
				}
			}
		},
		role = role
	}
	return args,select_sup
end

local function lfeedback(callback,category,terms,filters,preferredfilters,delay)
	local results = callback()
	if results then
		if 0 < results then
			LookingForGroup_Options.Background_Notifing_Music()
		else
			LookingForGroup_Options.Background_NoSearchResult_StartMusic()
		end
		local elaspe = math.ceil((results+1)/10)*10
		local function feedback()
			lfeedback(callback,category,terms,filters,preferredfilters,delay)
			LookingForGroup_Options.NotifyChangeIfSelected("search_result")
		end
		if LookingForGroup.db.profile.hardware then
			LookingForGroup_Options.Background_Sceduled_Timer_Start(
			function()
				if next(select_sup) == nil then
					feedback()
				end
			end,elaspe)
		else
			LookingForGroup_Options.Background_Sceduled_Timer_Start(function()
				if next(select_sup) == nil then
					LookingForGroup.Search(feedback,category,terms,filters,preferredfilters,delay)
				end
			end,elaspe)
		end
	end
end

function LookingForGroup_Options.Search(rargs,callback,category,terms,filters,preferredfilters,delay)
	LookingForGroup.Search(function()
		wipe(select_sup)
		lfeedback(callback,category,terms,filters,preferredfilters,delay)
		search_config_tb.args = rargs
		LookingForGroup_Options.option_table.args.search_result = search_config_tb
		AceConfigDialog:SelectGroup("LookingForGroup","search_result")
	end,category,terms,filters,preferredfilters,delay)
	LookingForGroup_Options:RegisterEvent("LFG_LIST_SEARCH_FAILED",function()
		LookingForGroup_Options:UnregisterEvent("LFG_LIST_SEARCH_FAILED")
		failed_args.back.func = rargs.back.func
		failed_args.search_again.func = rargs.search_again.func
		search_config_tb.args = failed_args
		LookingForGroup_Options.option_table.args.search_result = search_config_tb
		LookingForGroup_Options.Background_Timer_Start(failed_args.search_again.func,5)
		AceConfigDialog:SelectGroup("LookingForGroup","search_result")
	end)
end
