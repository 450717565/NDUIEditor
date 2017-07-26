local LookingForGroup = LibStub("AceAddon-3.0"):GetAddon("LookingForGroup")
local LookingForGroup_Options = LibStub("AceAddon-3.0"):GetAddon("LookingForGroup_Options")

local C_LFGList_ApplyToGroup = C_LFGList.ApplyToGroup
local GetLFGRoles = GetLFGRoles
local SetLFGRoles = SetLFGRoles
local C_LFGList_GetSearchResults = C_LFGList.GetSearchResults
local C_LFGList_GetSearchResultInfo = C_LFGList.GetSearchResultInfo
local C_LFGList_GetActivityInfo = C_LFGList.GetActivityInfo
local AceConfigDialog = LibStub("AceConfigDialog-3.0")
local C_LFGList_GetSearchResultEncounterInfo = C_LFGList.GetSearchResultEncounterInfo
local C_LFGList_GetSearchResultMemberCounts = C_LFGList.GetSearchResultMemberCounts
local C_LFGList_GetSearchResultMemberInfo = C_LFGList.GetSearchResultMemberInfo
local C_LFGList_UpdateListing = C_LFGList.UpdateListing
local ChatFrame_SendTell = ChatFrame_SendTell
local IsControlKeyDown = IsControlKeyDown
local C_LFGList_GetApplicants = C_LFGList.GetApplicants
local C_LFGList_GetApplicantInfo = C_LFGList.GetApplicantInfo
local C_LFGList_GetApplicantMemberStats = C_LFGList.GetApplicantMemberStats
local C_LFGList_InviteApplicant = C_LFGList.InviteApplicant
local C_LFGList_GetApplicantMemberInfo = C_LFGList.GetApplicantMemberInfo
local C_LFGList_DeclineApplicant = C_LFGList.DeclineApplicant
local C_LFGList_RemoveListing = C_LFGList.RemoveListing
local _G = _G

local LFGListUtil_IsEntryEmpowered = LFGListUtil_IsEntryEmpowered

local string_find = string.find
local string_match = string.match
local table_concat = table.concat
local table_sort = table.sort
local math_floor = math.floor
local table_insert = table.insert

local tostring = tostring
local pairs = pairs
local select = select
local RAID_CLASS_COLORS = RAID_CLASS_COLORS
local LFG_LIST_GROUP_DATA_ATLASES = LFG_LIST_GROUP_DATA_ATLASES
local C_LFGList_GetActiveEntryInfo =C_LFGList.GetActiveEntryInfo
local wipe = wipe

local order = 0
local function get_order()
	local temp = order
	order = order +1
	return temp
end

local requests_vtb = {}
local concat_tb = {}
local max_lvl = GetMaxPlayerLevel()

local LookingForGroup_Options_GetRoleIcon = LookingForGroup_Options.GetRoleIcon
local tank_icon = "|TInterface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES:16:16:0:0:64:64:0:19:22:41|t"
local healer_icon = "|TInterface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES:16:16:0:0:64:64:20:39:1:20|t"
local damager_icon = "|TInterface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES:16:16:0:0:64:64:20:39:22:41|t"

local function member_info(t,name, class, localizedClass, level, itemLevel, honorLevel, tank, healer, damage, assignedRole, relationship)
	if level ~= max_lvl then
		table_insert(t,LEVEL_ABBR)
		table_insert(t,":")
		table_insert(t,level)
		table_insert(t," ")
	end
	table_insert(t,itemLevel)
	table_insert(t," |c")
	table_insert(t,RAID_CLASS_COLORS[class].colorStr)
	table_insert(t,name)
	table_insert(t," ")
	table_insert(t,localizedClass)
	table_insert(t,"|r")
	local roles = 0
	if tank then
		roles = roles + 1
	end
	if healer then
		roles = roles + 1
	end
	if damage then
		roles = roles + 1
	end
	if 1< roles then
		table_insert(t," ")
		if tank then
			table_insert(t,tank_icon)
		end
		if healer then
			table_insert(t,healer_icon)
		end
		if damage then
			table_insert(t,damager_icon)
		end
	end
	if relationship ~= nil then
		table_insert(t," ")
		table_insert(t,relationship)
	end
end

local function GetApplicantInfo(app_i)
	local id, status, pendingStatus, numMembers, isNew, comment = C_LFGList_GetApplicantInfo(app_i)
	local c1 = string_match(comment,"^#AV#(.*)$")
	if c1 ~= nil then
		if 1 == numMembers then
			return id, status, pendingStatus, numMembers, isNew, c1
		end
		local name = C_LFGList_GetApplicantMemberInfo(id,1)
		if string_find(name,'-') == nil then
			return id, status, pendingStatus, numMembers, isNew, c1
		end		
	end
	if status == "applied" then
--		C_LFGList_DeclineApplicant(app_i)
		pendingStatus = "declined"
	end
	return id, status, pendingStatus, numMembers, isNew, comment
end

local concat_tb_tooltip = {}

local function applicant_info(appid)
	wipe(concat_tb)
	wipe(concat_tb_tooltip)
	local id, status, pendingStatus, numMembers, isNew, comment = C_LFGList_GetApplicantInfo(appid)
	if comment == nil then
		comment = ""
	end
	local summary = string_match(comment,'^(.*)%(^1^.+^^%)$')
	if summary then
		comment = summary
	end
	if numMembers == 1 then
		local name, class, localizedClass, level, itemLevel, honorLevel, tank, healer, damage, assignedRole, relationship = C_LFGList_GetApplicantMemberInfo(id,1)
		itemLevel = math_floor(itemLevel)
		local icon = LookingForGroup_Options_GetRoleIcon(assignedRole)
		table_insert(concat_tb,icon)
		member_info(concat_tb, name, class, localizedClass, level, itemLevel, honorLevel, tank, healer, damage, assignedRole, relationship)
		if comment ~= nil and comment ~= "" then
			table_insert(concat_tb_tooltip,comment)
		end
	elseif numMembers ~= nil then
		concat_tb[#concat_tb + 1] = numMembers
		local k = #concat_tb + 1
		concat_tb[k] = " "
		local j
		for j = 1,numMembers do
			local name, class, localizedClass, level, itemLevel, honorLevel, tank, healer, damage, assignedRole, relationship = C_LFGList_GetApplicantMemberInfo(id,j)
			itemLevel = math_floor(itemLevel)
			table_insert(concat_tb," |c")
			table_insert(concat_tb,RAID_CLASS_COLORS[class].colorStr)
			local icon = LookingForGroup_Options_GetRoleIcon(assignedRole)
			table_insert(concat_tb,icon)
			table_insert(concat_tb,itemLevel)
			table_insert(concat_tb,"|r")
			if j ~= 1 then
				table_insert(concat_tb_tooltip,"\n")
			end
			table_insert(concat_tb_tooltip,icon)
			member_info(concat_tb_tooltip, name, class, localizedClass, level, itemLevel, honorLevel, tank, healer, damage, assignedRole, relationship)
		end
		if comment ~= "" then
			table_insert(concat_tb_tooltip,"\n")
			table_insert(concat_tb_tooltip,comment)
		end
	end
	return table_concat(concat_tb),table_concat(concat_tb_tooltip),status
end

local function requests_values()
	local app = C_LFGList_GetApplicants()
	if app == nil then
		return
	end
	local i
	wipe(requests_vtb)
	for i=1,#app do
		local app_i = app[i]
		local id, status = C_LFGList_GetApplicantInfo(app_i)
		if status == "applied" then
			table_insert(requests_vtb,app_i)
		elseif status == "invited" then
			table_insert(requests_vtb,app_i)
		end
	end
	return requests_vtb
end

local AceConfigRegistry = LibStub("AceConfigRegistry-3.0")

function LookingForGroup_Options:LFG_LIST_APPLICANT_UPDATED()
	if LookingForGroup_Options.Tooltip_Feedback_timer ~= nil then
		LookingForGroup_Options:CancelTimer(LookingForGroup_Options.Tooltip_Feedback_timer)
		LookingForGroup_Options.Tooltip_Feedback_timer = nil
	end
	LookingForGroup_Options.set_requests()
	self.NotifyChangeIfSelected("requests")
end

local app_tb = {}

function LookingForGroup_Options.clear_requests()
	if LookingForGroup_Options.option_table.args.requests then
		LookingForGroup_Options.option_table.args.requests = nil
		wipe(app_tb)
		AceConfigRegistry:NotifyChange("LookingForGroup")
	end
end

local requests =
{
	name = LFGUILD_TAB_REQUESTS_NONE,
	type = "group",
	args =
	{
		apply =
		{
			name = APPLY,
			type = "execute",
			order = get_order(),
			func = function()
				local active, activityID, iLevel, honorLevel, name, comment = C_LFGList_GetActiveEntryInfo()
				if active then
					local InviteApplicant = C_LFGList.InviteApplicant
					if activityID == 44 and string_find(name,"#AV#") then
						InviteApplicant = LookingForGroup.GetAddon("LookingForGroup_AV").InviteApplicant
					end
					local k,v
					for k,v in pairs(app_tb) do
						if v then
							InviteApplicant(k)
						elseif v == false then
							C_LFGList_DeclineApplicant(k)
						end
					end
				end
				wipe(app_tb)
				AceConfigRegistry:NotifyChange("LookingForGroup")
			end
		},
		delist = 
		{
			order = get_order(),
			name = UNLIST_MY_GROUP,
			type = "execute",
			func = function()
				local active, activityID, iLevel, honorLevel, name, comment = C_LFGList_GetActiveEntryInfo()
				if active and LFGListUtil_IsEntryEmpowered() then
					LookingForGroup_Options.option_table.args.requests = nil
					local quest_id = LookingForGroup_Options.db.profile.start_a_group_quest_id
					if quest_id == nil then
						if activityID == 44 and string_find(name,"#AV#") then
							AceConfigDialog:SelectGroup("LookingForGroup","av")
						else
							AceConfigDialog:SelectGroup("LookingForGroup","find")
						end
					else
						AceConfigDialog:SelectGroup("LookingForGroup","wq")
					end
					C_LFGList_RemoveListing()
				end
			end
		},
		applicants =
		{
			order = get_order(),
			name = " ",
			type = "multiselect",
			order = get_order(),
			values = requests_values,
			width = "full",
			dialogControl = "LookingForGroup_Options_Applicant_Multiselect"
		}
	}
}

function LookingForGroup_Options.set_requests()
	LookingForGroup_Options.option_table.args.requests = requests
end

local function tooltip_feedback()
	GameTooltip:ClearLines()
	local owner = GameTooltip:GetOwner()
	local obj = owner.obj
	local users = obj:GetUserDataTable()
	local val = users.val
	if LookingForGroup_Options.Tooltip_Feedback_timer ~= nil then
		LookingForGroup_Options:CancelTimer(LookingForGroup_Options.Tooltip_Feedback_timer)
		LookingForGroup_Options.Tooltip_Feedback_timer = nil
	end
	local label,info = applicant_info(val)
	GameTooltip:AddLine(label)
	GameTooltip:AddLine(info)
	GameTooltip:Show()
end
local AceGUI = LibStub("AceGUI-3.0")
AceGUI:RegisterWidgetType("LookingForGroup_Options_Applicant_Multiselect", function()
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
		local check = AceGUI:Create("LookingForGroup_applicant_checkbox")
		check:SetUserData("val", val)
		local label,_,status = applicant_info(val)
		check:SetLabel(label)
		if status == "applied" then
			check:SetTriState(true)
			local v = app_tb[val]
			if v then
				check:SetValue(true)
			elseif v == nil then
				check:SetValue(false)
			end
			check:SetCallback("OnValueChanged",function(self,event,val)
				if LFGListUtil_IsEntryEmpowered() then
					if val == nil then
						val = false
					elseif val == false then
						val = true
					else
						val = nil
					end
					local user = self:GetUserDataTable()
					local key = user.val
					if val then
						app_tb[key] = true
					elseif val == nil then
						app_tb[key] = false
					else
						app_tb[key] = nil
					end
					check:SetValue(val)
				end
			end)
		elseif status == "invited" then
			check:SetValue(true)
			check:SetCallback("OnValueChanged",function()end)
		end
		check:SetCallback("OnLeave", function(self,...)
			if LookingForGroup_Options.Tooltip_Feedback_timer ~= nil then
				LookingForGroup_Options:CancelTimer(LookingForGroup_Options.Tooltip_Feedback_timer)
				LookingForGroup_Options.Tooltip_Feedback_timer = nil
			end
			GameTooltip:Hide()
		end)
		check:SetCallback("OnEnter", function(self,...)
			if LookingForGroup_Options.Tooltip_Feedback_timer ~= nil then
				LookingForGroup_Options:CancelTimer(LookingForGroup_Options.Tooltip_Feedback_timer)
			end
			GameTooltip:SetOwner(self.frame,"ANCHOR_TOPRIGHT")
			LookingForGroup_Options.Tooltip_Feedback_timer = LookingForGroup_Options:ScheduleRepeatingTimer(tooltip_feedback,1)
			tooltip_feedback()
		end)
		check.width = "fill"
		self:AddChild(check)
	end
	return AceGUI:RegisterAsContainer(control)
end , 1)
