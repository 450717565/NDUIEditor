local LibStub = LibStub
local AceAddon = LibStub("AceAddon-3.0")
local LookingForGroup = AceAddon:GetAddon("LookingForGroup")
local LookingForGroup_Options = AceAddon:GetAddon("LookingForGroup_Options")
local AceGUI = LibStub("AceGUI-3.0")
local string_lower = string.lower
local string_gsub = string.gsub
local string_find = string.find
local table_insert = table.insert
local SocialQueueUtil_GetQueueName = SocialQueueUtil_GetQueueName
local C_LFGList_GetActivityInfo = C_LFGList.GetActivityInfo

local order = 0
local function get_order()
	local temp = order
	order = order +1
	return temp
end

local select_sup = {}

local social_tb = {}

local function get_social()
	wipe(social_tb)
	if LookingForGroup.db.profile.enable_qj then
		local all_groups = C_SocialQueue.GetAllGroups(false)
		local i
		local fsr = LookingForGroup_Options.FilterSearchResult
		local C_SocialQueue_GetGroupQueues = C_SocialQueue.GetGroupQueues
		for i = 1, #all_groups do
			local ai = all_groups[i]
			local queues = C_SocialQueue_GetGroupQueues(ai)
			if queues~=nil then
				local q1 = queues[1]
				if q1 ~= nil then
					local queue_data = q1.queueData
					if queue_data ~= nil then
						local lfgListID = queue_data.lfgListID
						if lfgListID ~= nil then
							if fsr(lfgListID) then
								table_insert(social_tb,ai)
							end
						else
							table_insert(social_tb,ai)
						end
					end
				end
			end
		end
	end
	return social_tb
end

function LookingForGroup_Options:EnableQuickJoin()
	if LookingForGroup.db.profile.enable_qj then
		self:RegisterEvent("SOCIAL_QUEUE_UPDATE")
	else
		self:UnregisterEvent("SOCIAL_QUEUE_UPDATE")
	end
end

LookingForGroup_Options:push("quick_join",{
	name = QUICK_JOIN,
	desc = SOCIAL_QUICK_JOIN_TAB_HELP_TIP,
	type = "group",
	args =
	{
		sign_up =
		{
			order = get_order(),
			name = SIGN_UP,
			type = "execute",
			func = function()
				local C_SocialQueue_GetGroupQueues = C_SocialQueue.GetGroupQueues
				local C_LFGList_GetSearchResultInfo = C_LFGList.GetSearchResultInfo
				local C_SocialQueue_RequestToJoin = C_SocialQueue.RequestToJoin
				local apply_to_group = LookingForGroup_Options.ApplyToGroup
				local tank,healer,damager =  select(2,GetLFGRoles())
				local k,v
				for k,v in pairs(select_sup) do
					if v then
						local queues = C_SocialQueue_GetGroupQueues(k)
						if queues ~= nil then
							local queueData = queues[1].queueData
							local lfgListID = queueData.lfgListID
							if lfgListID ~= nil then
								apply_to_group(lfgListID,"",tank,healer,damager)
							else
								C_SocialQueue_RequestToJoin(k,tank,healer,damager)
							end
						end
					end
				end
			end
		},
		enable =
		{
			order = get_order(),
			name = ENABLE,
			type = "toggle",
			get = function(info)
				return LookingForGroup.db.profile.enable_qj
			end,
			set = function(info,val)
				if val then
					LookingForGroup.db.profile.enable_qj = true
				else
					LookingForGroup.db.profile.enable_qj = nil
				end
				LookingForGroup_Options:EnableQuickJoin()
			end
		},
		s =
		{
			name = GROUP,
			order = get_order(),
			values = get_social,
			dialogControl = "LookingForGroup_Options_Quick_Join_Multiselect",
			type = "multiselect",
		}
	}
})


function LookingForGroup_Options:Quick_Join_Tooltip_Feedback(...)
	GameTooltip:ClearLines()
	local owner = GameTooltip:GetOwner()
	local obj = owner.obj
	local users = obj:GetUserDataTable()
	local key = users.key
	local val = users.val
	local queueData = users.queueData
	local lfgListID = users.lfgListID
	if lfgListID ~= nil then
		local active, name ,srinfo = LookingForGroup.GetAddon("LookingForGroup_Core").GetSearchResultInfo(lfgListID)
		if active then
			owner.obj:SetLabel(name)
			GameTooltip:ClearLines()
			GameTooltip:AddLine(srinfo, 0.5, 0.5, 0.8, true)
--			local name,color,_,plink = SocialQueueUtil_GetNameAndColor(select(7,C_SocialQueue.GetGroupInfo(val)))
--			GameTooltip:AddLine(color..name..FONT_COLOR_CODE_CLOSE)
			GameTooltip:Show()
		else
			select_sup[val] = nil
			obj:SetValue(false)
			obj:SetDisabled(true)
			if self.Quick_Join_Tooltip_Feedback_timer ~= nil then
				self:CancelTimer(self.Quick_Join_Tooltip_Feedback_timer)
				self.Quick_Join_Tooltip_Feedback_timer = nil
			end
			GameTooltip:Hide()
		end
	else
		local s = SocialQueueUtil_GetQueueName(queueData)
		if s == UNKNOWNOBJECT then
			select_sup[val] = nil
			obj:SetValue(false)
			obj:SetDisabled(true)
			if self.Quick_Join_Tooltip_Feedback_timer ~= nil then
				self:CancelTimer(self.Quick_Join_Tooltip_Feedback_timer)
				self.Quick_Join_Tooltip_Feedback_timer = nil
			end
			GameTooltip:Hide()
		else
			owner.obj:SetLabel("|cff8080cc"..s.."|r")
			GameTooltip:ClearLines()
			GameTooltip:AddLine(s, 0.5, 0.5, 0.8, true)
			local name,color,_,plink = SocialQueueUtil_GetNameAndColor(select(7,C_SocialQueue.GetGroupInfo(val)))
			GameTooltip:AddLine('\n'..color..name..FONT_COLOR_CODE_CLOSE)
			GameTooltip:Show()
		end
	end
end

AceGUI:RegisterWidgetType("LookingForGroup_Options_Quick_Join_Multiselect", function()
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
		local check = AceGUI:Create("LookingForGroup_quick_join_checkbox")
		check:SetUserData("key", key)
		check:SetUserData("val", val)
		local queues = C_SocialQueue.GetGroupQueues(val)
		local queueData = queues[1].queueData
		check:SetUserData("queueData", queueData)
		local lfgListID = queueData.lfgListID
		if lfgListID ~= nil then
			local id,activityID = C_LFGList.GetSearchResultInfo(lfgListID)
			if id == nil then
				return
			end
			local activityName, shortName, categoryID, groupID, itemLevel, filters, minLevel, maxPlayers, displayType = C_LFGList_GetActivityInfo(activityID)
			if categoryID == 1 then
				return
			end
			local active, name,desc = LookingForGroup.GetAddon("LookingForGroup_Core").GetSearchResultInfo(lfgListID)
			if not active then
				return
			end
			check:SetLabel(name)
			check:SetUserData("lfgListID", lfgListID)
		else
			check:SetLabel("|cff8080cc"..SocialQueueUtil_GetQueueName(queueData).."|r")
		end
		check:SetCallback("OnValueChanged",function(self,event,val)
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
			if LookingForGroup_Options.Quick_Join_Tooltip_Feedback_timer ~= nil then
				LookingForGroup_Options:CancelTimer(LookingForGroup_Options.Quick_Join_Tooltip_Feedback_timer)
				LookingForGroup_Options.Quick_Join_Tooltip_Feedback_timer = nil
			end
			GameTooltip:Hide()
		end)
		check:SetCallback("OnEnter", function(self,...)
			if LookingForGroup_Options.Quick_Join_Tooltip_Feedback_timer ~= nil then
				LookingForGroup_Options:CancelTimer(LookingForGroup_Options.Quick_Join_Tooltip_Feedback_timer)
			end
			GameTooltip:SetOwner(self.frame,"ANCHOR_TOPRIGHT")
			LookingForGroup_Options.Quick_Join_Tooltip_Feedback_timer = LookingForGroup_Options:ScheduleRepeatingTimer("Quick_Join_Tooltip_Feedback",1)
			LookingForGroup_Options:Quick_Join_Tooltip_Feedback()
		end)
		check.width = "fill"
		self:AddChild(check)
	end
	return AceGUI:RegisterAsContainer(control)
end , 1)
