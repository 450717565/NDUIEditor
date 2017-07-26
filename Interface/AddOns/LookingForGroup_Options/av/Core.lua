local LibStub = LibStub
local AceAddon = LibStub("AceAddon-3.0")
local LookingForGroup = AceAddon:GetAddon("LookingForGroup")
local LookingForGroup_Options = AceAddon:GetAddon("LookingForGroup_Options")
local C_LFGList_ClearSearchResults = C_LFGList.ClearSearchResults
local AceConfigDialog = LibStub("AceConfigDialog-3.0")
local string_find = string.find
local C_LFGList_GetSearchResultInfo = C_LFGList.GetSearchResultInfo
local string_gsub = string.gsub
local string_lower = string.lower
local table_insert = table.insert

local order = 0
local function get_order()
	local temp = order
	order = order + 1
	return temp
end


local results_table = {}

local function do_start()
	local profile = LookingForGroup_Options.db.profile
	local name = profile.start_a_group_title
	if name ~="" then
		local lfgav = LookingForGroup_Options.GetLFG_AV()
		local funcListing = lfgav.CreateListing
		if C_LFGList.GetActiveEntryInfo() then
			funcListing = lfgav.UpdateListing
		end
		funcListing(name,
					profile.start_a_group_minimum_item_level,
					profile.start_a_group_minimum_honor_level,
					profile.start_a_group_voice_chat,
					profile.start_a_group_details,
					profile.start_a_group_auto_accept,
					profile.start_a_group_private)
		LookingForGroup_Options.set_requests()
		AceConfigDialog:SelectGroup("LookingForGroup","requests")
	end
end

local rc_args,select_sup=LookingForGroup_Options.CreateReceivedArgs(
						"LookingForGroup_Options_AV_Multiselect",results_table,"av")
local function get_search_result()
	local results = LookingForGroup_Options.GetSearchResults()
	wipe(results_table)
	local i
	for i=1,#results do
		table_insert(results_table,results[i])
	end
end

local matches = {"#AV#"}
local searchTerms = {{matches = matches}}

local function do_search()
	LookingForGroup_Options.Search(rc_args,get_search_result,3,searchTerms,0,0)
end
rc_args.search_again.func = do_search

local party_tb = {}
local concat_tb = {}

local av_tb =
{
	name = GetMapNameByID(401),
	type = "group",
	args =
	{
		search =
		{
			order = get_order(),
			name = LFG_LIST_FIND_A_GROUP,
			type = "execute",
			func = do_search,
		},
		start =
		{
			order = get_order(),
			name = START_A_GROUP,
			type = "execute",
			func = function() 	AceConfigDialog:SelectGroup("LookingForGroup","av","s") end,
		},
		disban =
		{
			order = get_order(),
			name = TEAM_DISBAND,
			type = "execute",
			confirm = true,
			func = function() LookingForGroup.GetAddon("LookingForGroup_AV").rl_disban() end,
		},
		s =
		{
			name = START_A_GROUP,
			order = get_order(),
			type = "group",
			args =
			{
				title =
				{
					order = get_order(),
					name = LFG_LIST_TITLE,
					desc = LFG_LIST_ENTER_NAME,
					type = "input",
					get = function(info) return LookingForGroup_Options.db.profile.start_a_group_title end,
					set = function(info,val) LookingForGroup_Options.db.profile.start_a_group_title = val end,
					width = "full"
				},
				details =
				{
					order = get_order(),
					name = LFG_LIST_DETAILS,
					desc = DESCRIPTION_OF_YOUR_GROUP,
					type = "input",
					multiline = true,
					get = function(info) return LookingForGroup_Options.db.profile.start_a_group_details end,
					set = function(info,val) LookingForGroup_Options.db.profile.start_a_group_details = val end,
					width = "full"
				},
				minitemlvl =
				{
					order = get_order(),
					name = LFG_LIST_ITEM_LEVEL_INSTR_SHORT,
					desc = LFG_LIST_ITEM_LEVEL_REQ,
					type = "input",
					get = function(info)
						local sminilv = LookingForGroup_Options.db.profile.start_a_group_minimum_item_level
						if sminilv == 0 then
							return ""
						else
							return tostring(sminilv)
						end
					end,
					pattern = "^[0-9]*$",
					set = function(info,val)
						if val == nil or val == "" then
							LookingForGroup_Options.db.profile.start_a_group_minimum_item_level = 0
						else
							local player_ilv = math_floor(GetAverageItemLevel())
							val = tonumber(val)
							if player_ilv < val then
								LookingForGroup_Options.db.profile.start_a_group_minimum_item_level = player_ilv
							else
								LookingForGroup_Options.db.profile.start_a_group_minimum_item_level = val
							end
						end
					end
				},
				minhonorlvl =
				{
					order = get_order(),
					name = LFG_LIST_HONOR_LEVEL_INSTR_SHORT,
					desc = LFG_LIST_HONOR_LEVEL_REQ,
					type = "input",
					get = function(info)
						local sminilv = LookingForGroup_Options.db.profile.start_a_group_minimum_honor_level
						if sminilv == 0 then
							return ""
						else
							return tostring(sminilv)
						end
					end,
					pattern = "^[0-9]*$",
					set = function(info,val)
						if val == nil or val == "" then
							LookingForGroup_Options.db.profile.start_a_group_minimum_honor_level = 0
						else
							local player_ilv = math_floor(UnitHonorLevel("player"))
							val = tonumber(val)
							if player_ilv < val then
								LookingForGroup_Options.db.profile.start_a_group_minimum_honor_level = player_ilv
							else
								LookingForGroup_Options.db.profile.start_a_group_minimum_honor_level = val
							end
						end
					end,
				},
				vc =
				{
					order = get_order(),
					name = VOICE_CHAT,
					desc = LFG_LIST_VOICE_CHAT_INSTR,
					type = "input",
					get = function(info)
						return LookingForGroup_Options.db.profile.start_a_group_voice_chat
					end,
					set = function(info,val)
						LookingForGroup_Options.db.profile.start_a_group_voice_chat = val
					end,
					width = "full",
				},
				auto_acc =
				{
					order = get_order(),
					name = LFG_LIST_AUTO_ACCEPT,
					type = "toggle",
					get = function(info)
						return LookingForGroup_Options.db.profile.start_a_group_auto_accept
					end,
					set = function(info,val)
						LookingForGroup_Options.db.profile.start_a_group_auto_accept = val
					end
				},
				prv =
				{
					order = get_order(),
					name = LFG_LIST_PRIVATE,
					desc = LFG_LIST_PRIVATE_TOOLTIP,
					type = "toggle",
					get = function(info)
						return LookingForGroup_Options.db.profile.start_a_group_private
					end,
					set = function(info,val)
						LookingForGroup_Options.db.profile.start_a_group_private = val
					end
				},
				start =
				{
					order = get_order(),
					name = START,
					type = "execute",
					func = do_start
				},
				cancel = 
				{
					order = get_order(),
					name = CANCEL,
					type = "execute",
					func = LookingForGroup_Options.UpdateEditing
				},
				back = 
				{
					order = get_order(),
					name = BACK,
					type = "execute",
					func = function() AceConfigDialog:SelectGroup("LookingForGroup","av") end
				},
			}
		},
		
		parties =
		{
			name = PARTY_MEMBERS,
			order = get_order(),
			type = "group",
			args =
			{
				roleconfirm =
				{
					order = get_order(),
					name = ROLE_POLL,
					type = "execute",
					func = function() LookingForGroup.GetAddon("LookingForGroup_AV").rl_roleconfirm() end,
					width = "full"
				},
				parties =
				{
					name = PARTY,
					type = "multiselect",
					order = get_order(),
					values = function()
						wipe(party_tb)
						local parties = LookingForGroup.GetAddon("LookingForGroup_AV").db.profile.parties
						local table_insert = table.insert
						local k,v
						for k,v in pairs(parties) do
							wipe(concat_tb)
							table_insert(concat_tb,k)
							table_insert(concat_tb,' (')
							table_insert(concat_tb,#v+1)
							table_insert(concat_tb,')')
							local i
							for i = 1,#v do
								table_insert(concat_tb,'\n')
								table_insert(concat_tb,v[i])
							end
							party_tb[k] = table.concat(concat_tb)
						end
						return party_tb
					end,
					width = "full",
					set = function()end,
					get = function()end,
				}
			}
		}
	}
}
LookingForGroup_Options:push("av",av_tb)

function LookingForGroup_Options:EnableAV()
	if LookingForGroup.db.profile.enable_av then
		LookingForGroup_Options.option_table.args.av = av_tb
	else
		LookingForGroup_Options.option_table.args.av = nil
	end
end

local AceGUI = LibStub("AceGUI-3.0")
local GameTooltip = GameTooltip

local function tooltip_feedback()
	local owner = GameTooltip:GetOwner()
	local obj = owner.obj
	local users = obj:GetUserDataTable()
	local val = users.val
	local ok,name,srinfo = LookingForGroup.GetAddon("LookingForGroup_Core").GetSearchResultInfo(val)
	if ok then
		GameTooltip:GetOwner().obj:SetLabel(name)
		GameTooltip:ClearLines()
		GameTooltip:AddLine(srinfo, 0.5, 0.5, 0.8, true)
		GameTooltip:Show()
	else
		select_sup[val] = nil
		obj:SetValue(false)
		obj:SetDisabled(true)
		if LookingForGroup_Options.SearchResult_Tooltip_Feedback_timer ~= nil then
			LookingForGroup_Options:CancelTimer(LookingForGroup_Options.SearchResult_Tooltip_Feedback_timer)
			LookingForGroup_Options.SearchResult_Tooltip_Feedback_timer = nil
		end
	end
end

AceGUI:RegisterWidgetType("LookingForGroup_Options_AV_Multiselect", function()
	local control = AceGUI:Create("InlineGroup")
	control:SetLayout("Flow")
	control:SetTitle(name)
	control.width = "fill"
	control.SetList = function(self,values)
		self.values = values
	end
	control.SetLabel = function(self,value)
		self:SetTitle(value)
	end
	control.SetDisabled = function(self,disabled)
		self.disabled = disabled
	end
	control.SetMultiselect = function()end
	control.SetItemValue = function(self,key)
		local val = self.values[key]
		local ok, name, desc = LookingForGroup.GetAddon("LookingForGroup_Core").GetSearchResultInfo(val)
		if not ok then
			return
		end
		local check = AceGUI:Create("LookingForGroup_search_result_checkbox")
		check:SetUserData("key", key)
		check:SetLabel(name)
		check:SetUserData("val", val)
		check:SetValue(select_sup[val])
		check:SetCallback("OnValueChanged",function(self,...)
			local user = self:GetUserDataTable()
			local v = user.val
			if select_sup[v] then
				select_sup[v] = nil
			else
				select_sup[v] = true
			end
			check:SetValue(select_sup[v])
		end)
		check:SetCallback("OnLeave", function(self,...)
			if LookingForGroup_Options.SearchResult_Tooltip_Feedback_timer ~= nil then
				LookingForGroup_Options:CancelTimer(LookingForGroup_Options.SearchResult_Tooltip_Feedback_timer)
			end
			GameTooltip:Hide()
		end)
		check:SetCallback("OnEnter", function(self,...)
			GameTooltip:SetOwner(self.frame,"ANCHOR_TOPRIGHT")
			if LookingForGroup_Options.SearchResult_Tooltip_Feedback_timer ~= nil then
				LookingForGroup_Options:CancelTimer(LookingForGroup_Options.SearchResult_Tooltip_Feedback_timer)
			end
			LookingForGroup_Options.SearchResult_Tooltip_Feedback_timer = LookingForGroup_Options:ScheduleRepeatingTimer(tooltip_feedback, 1)
			tooltip_feedback()
		end)
		self:AddChild(check)
	end
	return AceGUI:RegisterAsContainer(control)
end , 1)
