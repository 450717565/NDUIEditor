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

local results_table = {}

local function get_search_result()
	wipe(results_table)
	local groups, groupsIDs = C_LFGList.GetSearchResults()
	local i
	for i=1,#groupsIDs do
		table_insert(results_table,groupsIDs[i])
	end
end

local function do_start()
	local quest_id = LookingForGroup_Options.db.profile.start_a_group_quest_id
	if quest_id ~= nil then
		local funcListing = C_LFGList.CreateListing
		if C_LFGList.GetActiveEntryInfo() then
			funcListing = C_LFGList.UpdateListing
		end
		local activityID = LFGListUtil_GetQuestCategoryData(quest_id)
		if activityID ~= nil then
			funcListing(activityID,
					"",
					0,
					0,
					"",
					"",
					true,
					false,
					quest_id)
			LookingForGroup_Options.set_requests()
			AceConfigDialog:SelectGroup("LookingForGroup","requests")
		end
	end
end

local rc_args,select_sup=LookingForGroup_Options.CreateReceivedArgs(
						"LookingForGroup_Options_WQ_Multiselect",results_table,"wq")

rc_args.start = 
{
	order = 7,
	name = START,
	type = "execute",
	func = function()
		LookingForGroup_Options.reset_search_result()
		do_start()
	end,
}
local matches = {}
local searchTerms = {{matches = matches}}
function LookingForGroup_Options.do_wq_search()
	local quest_id = LookingForGroup_Options.db.profile.start_a_group_quest_id
	if quest_id ~= nil then
		local activityID, categoryID, filters, questName = LFGListUtil_GetQuestCategoryData(quest_id)
		if activityID ~= nil then
			matches[1] = questName
			LookingForGroup_Options.Search(rc_args,get_search_result,categoryID,searchTerms,0,filters)
		end
	end
end
rc_args.search_again.func = LookingForGroup_Options.do_wq_search

LookingForGroup_Options:push("wq",{
	name = TRACKER_HEADER_WORLD_QUESTS,
	type = "group",
	args =
	{
		quest_id =
		{
			order = get_order(),
			name = BATTLE_PET_SOURCE_2..ID,
			type = "input",
			get = function(info)
				local quest_id = LookingForGroup_Options.db.profile.start_a_group_quest_id
				if quest_id ~= nil then
					return tostring(quest_id)
				end
			end,
			pattern = "^[0-9]*$",
			set = function(info,val)
				local profile = LookingForGroup_Options.db.profile
				if val == "" then
					profile.start_a_group_quest_id = nil
				else
					profile.start_a_group_quest_id = val
				end
			end,
			width = "full"
		},
		quest_name =
		{
			order = get_order(),
			type = "description",
			name = function(info)
				local quest_id = LookingForGroup_Options.db.profile.start_a_group_quest_id
				if quest_id ~= nil then
					local activityID, categoryID, filters, questName = LFGListUtil_GetQuestCategoryData(quest_id)
					return questName
				end
			end,
		},
		search =
		{
			order = get_order(),
			name = SEARCH,
			type = "execute",
			func = LookingForGroup_Options.do_wq_search
		},
		cancel =
		{
			order = get_order(),
			name = CANCEL,
			type = "execute",
			func = function()
				LookingForGroup_Options:RestoreDBVariable("start_a_group_quest_id")
			end
		},
		start = 
		{
			order = get_order(),
			name = START,
			type = "execute",
			func = do_start,
		},
	}
})

local AceGUI = LibStub("AceGUI-3.0")
local GameTooltip = GameTooltip

local function tooltip_feedback()
	local owner = GameTooltip:GetOwner()
	local obj = owner.obj
	local users = obj:GetUserDataTable()
	local val = users.val
	local ok,name,srinfo = LookingForGroup.GetAddon("LookingForGroup_Core").GetQuestSearchResultInfo(val)
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

AceGUI:RegisterWidgetType("LookingForGroup_Options_WQ_Multiselect", function()
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
		local ok, name,desc = LookingForGroup.GetAddon("LookingForGroup_Core").GetQuestSearchResultInfo(val)
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
