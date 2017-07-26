local LibStub = LibStub
local AceAddon = LibStub("AceAddon-3.0")
local LookingForGroup = AceAddon:GetAddon("LookingForGroup")
local LookingForGroup_Options = AceAddon:GetAddon("LookingForGroup_Options")
local AceGUI = LibStub("AceGUI-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("LookingForGroup_Options")
local wipe = wipe
local table_insert = table.insert
local C_LFGList_GetSearchResultInfo = C_LFGList.GetSearchResultInfo
local C_LFGList_ApplyToGroup = C_LFGList.ApplyToGroup
local AceConfigRegistry = LibStub("AceConfigRegistry-3.0")
local pairs = pairs

local order = 0
local function get_order()
	local temp = order
	order = order +1
	return temp
end

local party_tb = {}

local cr_sr =
{
	name = KBASE_SEARCH_RESULTS,
	desc = LFG_LIST_SELECT_A_SEARCH_RESULT,
	type = "group",
}

local function cancel_signups()
	local applications =  C_LFGList.GetApplications()
	local C_LFGList_CancelApplication = C_LFGList.CancelApplication
	local i
	for i = 1,#applications do
		C_LFGList_CancelApplication(applications[i])
	end
end

local sign_up

local rc_args,select_sup=LookingForGroup_Options.CreateReceivedArgs(
						"LookingForGroup_Options_Cross_Realm_Multiselect",party_tb,"cr",function()
	cancel_signups()
	sign_up()
end)

local function callback()
	wipe(party_tb)
	local counts,results = C_LFGList.GetSearchResults()
	local player_realm = GetRealmName()
	local string_find = string.find
	local string_match = string.match
	local C_LFGList_GetActivityInfo = C_LFGList.GetActivityInfo
	local i
	for i=1,#results do
		local ri = results[i]
		local id, activityID, name, comment, voiceChat, iLvl, honorLevel,
				age, numBNetFriends, numCharFriends, numGuildMates,
				isDelisted, leaderName, numMembers, isAutoAccept = C_LFGList_GetSearchResultInfo(ri)
		local activity = C_LFGList_GetActivityInfo(activityID)
		if (isAutoAccept or string_find(comment,"#([%w]+)#")) and leaderName ~= nil then
			local realm = string_match(leaderName,"-(.*)$")
			if realm == nil then
				realm = player_realm
			end
			if party_tb[realm] == nil then
				party_tb[realm] = {}
			end
			table_insert(party_tb[realm],ri)
		end
	end
	AceConfigRegistry:NotifyChange("LookingForGroup")
	return #party_tb
end

sign_up=function()
	local k,v
	local tank,healer,dps = select(2,GetLFGRoles())
	local ApplyToGroup = LookingForGroup_Options.SearchResults_ApplyToGroup
	for k,v in pairs(select_sup) do
		if v then
			local party = party_tb[k]
			local i
			local n = #party
			for i=1,n do
				ApplyToGroup(party[i],tank,healer,dps)
			end
		end
	end
end

local matches = {}
local realm_matches = {}
local terms = {{matches = matches},{matches = realm_matches}}

function LookingForGroup_Options.DoCRSearch()
	if LookingForGroup_Options.db.profile.cr_map then
		matches[1] = GetMapNameByID(GetCurrentMapAreaID())
	else
		matches[1] = nil
	end
	if LookingForGroup_Options.db.profile.cr_realm then
		realm_matches[1] = LookingForGroup_Options.db.profile.cr_realm
	else
		realm_matches[1] = nil
	end
	LookingForGroup_Options.Search(rc_args,callback,LookingForGroup_Options.db.profile.cr_category,
									terms,0,0,0.3)
end

rc_args.search_again.func = LookingForGroup_Options.DoCRSearch

LookingForGroup_Options:push("cr",{
	name = L["Cross Realm"],
	type = "group",
	args =
	{
		scan =
		{
			order = get_order(),
			name = ENABLE,
			type = "execute",
			func = function()
				LookingForGroup.GetAddon("LookingForGroup_CR").do_scan()
			end,
			width = "full"
		},
		search =
		{
			order = get_order(),
			name = SEARCH,
			type = "execute",
			func = LookingForGroup_Options.DoCRSearch,
		},
		cancel =
		{
			order = get_order(),
			name = CANCEL,
			type = "execute",
			func = function()
				LookingForGroup_Options:RestoreDBVariable("cr_category")
				LookingForGroup_Options.db.profile.cr_map = nil
				LookingForGroup_Options.db.profile.cr_realm = nil
			end
		},
		map =
		{
			order = get_order(),
			name = function() return GetMapNameByID(GetCurrentMapAreaID()) end,
			type = "toggle",
			get = function(info)
				return LookingForGroup_Options.db.profile.cr_map
			end,
			set = function(info,val)
				LookingForGroup_Options.db.profile.cr_map = val
			end
		},
		realm =
		{
			order = get_order(),
			name = FRIENDS_LIST_REALM:match("^(.*)%:") or FRIENDS_LIST_REALM:match("^(.*)%：") or FRIENDS_LIST_REALM,
			type = "input",
			get = function(info)
				return LookingForGroup_Options.db.profile.cr_realm
			end,
			set = function(info,val)
				if val == "" then
					LookingForGroup_Options.db.profile.cr_realm = nil
				else
					LookingForGroup_Options.db.profile.cr_realm = val
				end
			end
		},
		category =
		{
			order = get_order(),
			name = CATEGORY,
			type = "select",
			values = LookingForGroup_Options.categorys_values,
			get = function(info) return LookingForGroup_Options.db.profile.cr_category end,
			set = function(info,key) LookingForGroup_Options.db.profile.cr_category = key end,
		},
	}
})

local function tooltip_feedback()
	GameTooltip:ClearLines()
	local owner = GameTooltip:GetOwner()
	local obj = owner.obj
	local users = obj:GetUserDataTable()
	local key = users.key
	local val = users.val
	local i
	local q = {}
	for i=1,#val do
		local ri = val[i]
		local isDelisted = select(12,C_LFGList_GetSearchResultInfo(ri))
		if isDelisted == false then
			table_insert(q,ri)
		end
	end
	
	if next(q) == nil then
		obj:SetDisabled(true)
		if LookingForGroup_Options.CR_Tooltip_Feedback_timer ~= nil then
			LookingForGroup_Options:CancelTimer(LookingForGroup_Options.CR_Tooltip_Feedback_timer)
			LookingForGroup_Options.CR_Tooltip_Feedback_timer = nil
		end
		party_tb[key] = nil
	else
		party_tb[key] = q
	end
	
	local tm = "|cff8080cc("..#q..")|r"
	obj:SetLabel(key.." "..tm)
	GameTooltip:AddDoubleLine(key,#q)
	for i=1,#q do
		local id, activityID, name, comment, voiceChat, iLvl, honorLevel,
		age, numBNetFriends, numCharFriends, numGuildMates,
		isDelisted, leaderName, numMembers = C_LFGList.GetSearchResultInfo(q[i])
		local activity = C_LFGList.GetActivityInfo(activityID)
		if leaderName then
			GameTooltip:AddDoubleLine("|cff8080cc"..activity.."|r",leaderName)
		else
			GameTooltip:AddLine("|cff8080cc"..activity.."|r")
		end
	end
	GameTooltip:Show()
end

AceGUI:RegisterWidgetType("LookingForGroup_Options_Cross_Realm_Multiselect", function()
	local control = AceGUI:Create("InlineGroup")
	control:SetLayout("Flow")
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
		local check = AceGUI:Create("CheckBox")
		check:SetUserData("key", key)
		check:SetUserData("val", val)
		check:SetValue(select_sup[key])
		check:SetLabel(key.." |cff8080cc("..#val..")|r")
		check:SetCallback("OnValueChanged",function(self,event,val)
			local user = self:GetUserDataTable()
			local key = user.key
			select_sup[key] = val
			check:SetValue(select_sup[key])
		end)
		check:SetCallback("OnLeave", function(self,...)
			if LookingForGroup_Options.CR_Tooltip_Feedback_timer ~= nil then
				LookingForGroup_Options:CancelTimer(LookingForGroup_Options.CR_Tooltip_Feedback_timer)
				LookingForGroup_Options.CR_Tooltip_Feedback_timer = nil
			end
			GameTooltip:Hide()
		end)
		check:SetCallback("OnEnter", function(self,...)
			if LookingForGroup_Options.CR_Tooltip_Feedback_timer ~= nil then
				LookingForGroup_Options:CancelTimer(LookingForGroup_Options.CR_Tooltip_Feedback_timer)
			end
			GameTooltip:SetOwner(self.frame,"ANCHOR_TOPRIGHT")
			LookingForGroup_Options.CR_Tooltip_Feedback_timer = LookingForGroup_Options:ScheduleRepeatingTimer(tooltip_feedback,1)
			tooltip_feedback()
		end)
		self:AddChild(check)
	end
	return AceGUI:RegisterAsContainer(control)
end , 1)
