local AceAddon = LibStub("AceAddon-3.0")
local LookingForGroup = AceAddon:GetAddon("LookingForGroup")
local LookingForGroup_WQ = AceAddon:NewAddon("LookingForGroup_WQ","AceEvent-3.0")

function LookingForGroup_WQ:OnInitialize()
	self.db = LibStub("AceDB-3.0"):New("LookingForGroup_WQCharacterDB",
	{
		profile =
		{
		}
	},true)
end

function LookingForGroup_WQ:OnEnable()
	if LookingForGroup.db.profile.enable_wq then
		self:RegisterEvent("QUEST_ACCEPTED")
		self:RegisterEvent("QUEST_REMOVED")
		self:RegisterEvent("QUEST_TURNED_IN")
		local t = {button1=ACCEPT,button2=CANCEL}
		t.timeOut = 45
		StaticPopupDialogs.LookingForGroup_WQ_HardwareAPIDialog = t
		
	else
		StaticPopupDialogs.LookingForGroup_WQ_HardwareAPIDialog = nil
		self:UnregisterAllEvents()
		LookingForGroup_WQ.db.profile.doing_wq = nil
	end
end

local function is_group_wq(id)
	if id == 43943 or id == 45379 then
		return false
	end
	local wq_type = select(3,GetQuestTagInfo(id))
	if wq_type == nil or wq_type == LE_QUEST_TAG_TYPE_PET_BATTLE or wq_type == LE_QUEST_TAG_TYPE_PROFESSION or wq_type == LE_QUEST_TAG_TYPE_DUNGEON or wq_type == LE_QUEST_TAG_TYPE_RAID then
		return false
	end
	if select(2,C_TaskQuest.GetQuestInfoByQuestID(id)) == 1090 then
		return false
	end
	return true
end

local function hardware_api(desc,func)
	if LookingForGroup.db.profile.hardware then
		local dialog = StaticPopupDialogs.LookingForGroup_WQ_HardwareAPIDialog
		dialog.text = desc
		dialog.OnAccept = func
		StaticPopup_Show("LookingForGroup_WQ_HardwareAPIDialog")
	else
		func()
	end
end

local matches = {}
local searchTerms = {{matches = matches}}

local function lfg_active()
	local i
	local GetLFGMode = GetLFGMode
	for i = 1,6 do
		if GetLFGMode(i) then
			return true
		end
	end
	local GetBattlefieldStatus = GetBattlefieldStatus
	for i=1,GetMaxBattlefieldID() do
		if GetBattlefieldStatus(i) ~= "none" then
			return true
		end
	end
end

function LookingForGroup_WQ:QUEST_ACCEPTED(info,index,wq_id)
	if wq_id and (info == LookingForGroup or is_group_wq(wq_id)) then
		if lfg_active() then
			if C_LFGList.GetActiveEntryInfo() and LookingForGroup_WQ.db.profile.doing_wq == wq_id and UnitInParty("player") then
				StaticPopup_Hide("LookingForGroup_WQ_HardwareAPIDialog")
			end
			return
		else
			if UnitInParty("player") then
				if info == LookingForGroup and UnitIsGroupLeader("player") then
					local activityID = LFGListUtil_GetQuestCategoryData(wq_id)
					C_LFGList.CreateListing(activityID,"",0,0,"","",true,false,wq_id)
				end
				return
			end
		end
		
		local activityID, categoryID, filters, questName = LFGListUtil_GetQuestCategoryData(wq_id)
		if activityID then
			LookingForGroup_WQ.db.profile.doing_wq = wq_id
			local function create()
				if LookingForGroup_WQ.db.profile.doing_wq == wq_id then
					C_LFGList.CreateListing(activityID,"",0,0,"","",true,false,wq_id)
				end
			end
			local function callback()
				if LookingForGroup_WQ.db.profile.doing_wq ~= wq_id then
					return
				end
				local count,results = C_LFGList.GetSearchResults()
				if results == nil or count == 0 then
					hardware_api(START_A_GROUP,create)
				else
					local function apply()
						local i
						if 5 < #results then
							local random = math.random
							for i = #results,2,-1 do
								local r = random(1,i)
								local t = results[r]
								results[r] = results[i]
								results[i] = t
							end
						end
						local i = 1
						local b = 0
						local _,tank,healer,dps = GetLFGRoles()
						while i<=#results and b<5 do
							local v = results[i]
							local _, _, _, comment, _, _, _,
								_, _, _, _,
								_, leaderName, _, autoaccept = C_LFGList.GetSearchResultInfo(v)
							if LookingForGroup.FilterRealm(leaderName) then
								if autoaccept then
									C_LFGList.ApplyToGroup(v, "", tank,healer,true)
									b = b + 1
								else
									if comment:find("#WQ:"..wq_id.."#") then
										C_LFGList.ApplyToGroup(v, "WorldQuestGroupFinderUser-"..wq_id, tank,healer,true)
										b = b + 1
									end
								end
							end
							i = i+1
						end
						if 0 < b then
							C_Timer.After(5,function()
								if not UnitInParty("player") then
									local applications =  C_LFGList.GetApplications()
									if applications == nil or #applications == 0 then
										hardware_api(START_A_GROUP,create)
									else
										local C_LFGList_GetApplicationInfo = C_LFGList.GetApplicationInfo
										local C_LFGList_CancelApplication = C_LFGList.CancelApplication
										local ok = false
										local i
										for i = 1,#applications do
											local id = applications[i]
											local groupID, status, unknown, timeRemaining, role = C_LFGList_GetApplicationInfo(id)
											if status == "invited" then
												ok = true
											else
												C_LFGList_CancelApplication(id)
											end
										end
										if not ok then
											if LookingForGroup.db.profile.hardware then
												hardware_api(START_A_GROUP,create)
											else
												C_Timer.After(1,create)
											end
										end
									end
								end
							end)
						else
							create()
						end
					end
					hardware_api(SIGN_UP,apply)
				end
			end
			local function search_func()
				matches[1] = questName
				LookingForGroup.Search(callback,categoryID,searchTerms,0,filters)
			end
			local status,LookingForGroup_Options = pcall(AceAddon.GetAddon,AceAddon,"LookingForGroup_Options")
			if status then
				LookingForGroup_Options.Background_Timer_Stop()
				LookingForGroup_Options.Background_NoSearchResult_StartMusic()
			end
			if info == LookingForGroup then
				search_func()
			else
				hardware_api(SEARCH,search_func)
			end
		end
	end
end

function LookingForGroup_WQ:QUEST_REMOVED(info,id)
	if LookingForGroup_WQ.db.profile.doing_wq == id then
		if lfg_active() then
			LookingForGroup_WQ.db.profile.doing_wq = nil
			StaticPopup_Hide("LookingForGroup_WQ_HardwareAPIDialog")
			return
		end
		if IsMounted() then
			LeaveParty()
			LookingForGroup_WQ.db.profile.doing_wq = nil
			StaticPopup_Hide("LookingForGroup_WQ_HardwareAPIDialog")
			return
		end
		if GetNumGroupMembers() == 0 then
			LookingForGroup_WQ.db.profile.doing_wq = nil
			StaticPopup_Hide("LookingForGroup_WQ_HardwareAPIDialog")
		else
			StaticPopupDialogs.LookingForGroup_WQ_HardwareAPIDialog.text = PARTY_LEAVE
			StaticPopupDialogs.LookingForGroup_WQ_HardwareAPIDialog.OnAccept = function()
				LeaveParty()
				if LookingForGroup_WQ.db.profile.doing_wq == id then
					LookingForGroup_WQ.db.profile.doing_wq = nil
				end
			end
			StaticPopup_Show("LookingForGroup_WQ_HardwareAPIDialog")
		end
	end
end

function LookingForGroup_WQ:QUEST_TURNED_IN(info,id)
	if LookingForGroup_WQ.db.profile.doing_wq == id then
		LookingForGroup_WQ.db.profile.doing_wq = nil
		if lfg_active() then
			StaticPopup_Hide("LookingForGroup_WQ_HardwareAPIDialog")
			return
		end
		if LookingForGroup.db.profile.wq_leave_party then
			LeaveParty()
			return
		end
		if GetNumGroupMembers() < 2 then
			LeaveParty()
			StaticPopup_Hide("LookingForGroup_WQ_HardwareAPIDialog")
		else
			StaticPopupDialogs.LookingForGroup_WQ_HardwareAPIDialog.text = PARTY_LEAVE
			StaticPopupDialogs.LookingForGroup_WQ_HardwareAPIDialog.OnAccept = LeaveParty
			StaticPopup_Show("LookingForGroup_WQ_HardwareAPIDialog")
		end
	end
end
