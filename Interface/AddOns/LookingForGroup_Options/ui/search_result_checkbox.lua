local AceGUI = LibStub("AceGUI-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")
local LookingForGroup_Options = LibStub("AceAddon-3.0"):GetAddon("LookingForGroup_Options")

local C_LFGList_ReportSearchResult = C_LFGList.ReportSearchResult
local ChatFrame_SendTell = ChatFrame_SendTell
local EasyMenu = EasyMenu

local L = LibStub("AceLocale-3.0"):GetLocale("LookingForGroup_Options")

local LFGListSearchReporter =
{
	func = function(self, ...)C_LFGList_ReportSearchResult(...)end,
	notCheckable = true,
}
LFGListSearchReporter.__index = LFGListSearchReporter

function LFGListSearchReporter:new(o)
	setmetatable(o,self)
	return o
end

local function backfunc()
	if LookingForGroup_Options.option_table.args.search_result then
		AceConfigDialog:SelectGroup("LookingForGroup","search_result")
	end
end

local function paste(text)
	LookingForGroup_Options.Paste(text,backfunc)
end


local LFG_LIST_SEARCH_ENTRY_MENU

local armory_menu = {}

local function update_armory_menu()
	wipe(armory_menu)
	local k,v
	for k,v in pairs(LookingForGroup_Options.armory) do
		armory_menu[#armory_menu + 1] = LFGListSearchReporter:new(
		{
			text = k,
			func = function(_, id)
				local leaderName = select(13,C_LFGList.GetSearchResultInfo(id))
				if leaderName then
					paste(v(leaderName))
				end
			end,
		})
	end
	table.sort(armory_menu,function(a,b)
		return a.text < b.text
	end)
end
LookingForGroup_Options:RegisterMessage("UpdateArmory",update_armory_menu)

local function fake_achievement_link(id,b)
	local concat_tb = {"\124cffffff00\124Hachievement:",id,":",string.gsub(UnitGUID("player"), '0x', ''),":1:"}
	local d,m,y = date(nil,time()-691200):match('^(%d+)/(%d+)/(%d+)')
	if b then
		concat_tb[#concat_tb+1] = math.random(1,28)
		concat_tb[#concat_tb+1] = ":"
		concat_tb[#concat_tb+1] = math.random(1,12)
		concat_tb[#concat_tb+1] = ":"
		concat_tb[#concat_tb+1] = math.random(y-7,y-1)
	else
		concat_tb[#concat_tb+1] = d
		concat_tb[#concat_tb+1] = ":"
		concat_tb[#concat_tb+1] = m
		concat_tb[#concat_tb+1] = ":"
		concat_tb[#concat_tb+1] = y
	end
	concat_tb[#concat_tb+1] = ":4294967295:4294967295:4294967295:4294967295\124h["
	concat_tb[#concat_tb+1] = select(2,GetAchievementInfo(id))
	concat_tb[#concat_tb+1] = "]\124h\124r"
	return table.concat(concat_tb)
end

local function raid_achievement(ce,aotc)
	if select(14,GetAchievementInfo(ce)) then	-- Cutting Edge
		return GetAchievementLink(ce)
	end
	if select(14,GetAchievementInfo(aotc)) then	-- AotC
		return GetAchievementLink(aotc)
	end
	return fake_achievement_link(aotc)
end

local function botting_achievement(id,v)
	if select(14,GetAchievementInfo(id)) then
		return GetAchievementLink(id)
	end
	return fake_achievement_link(id,v)
end

local function GetSearchEntryMenu(resultID)
	LFGListSearchReporter.arg1 = resultID;
	if LFG_LIST_SEARCH_ENTRY_MENU == nil then
		update_armory_menu()
		LFG_LIST_SEARCH_ENTRY_MENU =
		{
			LFGListSearchReporter:new(
			{
				text = WHISPER_LEADER,
				func = function(_, id)
					local leaderName = select(13,C_LFGList.GetSearchResultInfo(id))
					if leaderName then
						ChatFrame_SendTell(leaderName)
					end
				end,
			}),
			{
				text = CALENDAR_COPY_EVENT,
				hasArrow = true,
				notCheckable = true,
				menuList =
				{
					LFGListSearchReporter:new(
					{
						text = LFG_LIST_TITLE,
						func = function(_, id)
							local title,comment = select(3,C_LFGList.GetSearchResultInfo(id))
							if comment then
								local summary,data = comment:match('^(.*)%((^1^.+^^)%)$')
								if title:find("集合石") or (data and not data:find("LookingForGroup")) then
									paste(summary)
								else
									paste(title)
								end
							else
								paste(title)
							end
						end,
					}),
					LFGListSearchReporter:new(
					{
						text = LFG_LIST_DETAILS,
						func = function(_, id)
							local comment = select(4,C_LFGList.GetSearchResultInfo(id))
							if comment then
								local summary = comment:match('^(.*)%(^1^.+^^%)$')
								if summary then
									paste(summary)
								else
									paste(comment)
								end
							end
						end,
					}),
				}
			},
			{
				text = L.Armory,
				hasArrow = true,
				notCheckable = true,
				menuList = armory_menu
			},
			LFGListSearchReporter:new({
				text = BATTLE_PET_SOURCE_6,
				func = function(_,groupid)
					local _, activityID, _, _, _, _, _,
						_, _, _, _,
						_, leaderName = C_LFGList.GetSearchResultInfo(groupid)
					if leaderName then
						if activityID == 478 or activityID == 479 then -- ToS N/H
							SendChatMessage(raid_achievement(11875,11874),"WHISPER",nil,leaderName)
						end
						
						if activityID == 415 or activityID == 416 then -- NH N/H
							SendChatMessage(raid_achievement(11192,11195),"WHISPER",nil,leaderName)
						end
						if activityID == 481 then	-- NH M
							SendChatMessage(botting_achievement(11192),"WHISPER",nil,leaderName)						
						end
						
						if activityID == 456 or activityID == 457 then -- ToV N/H
							SendChatMessage(raid_achievement(11580,11426),"WHISPER",nil,leaderName)
						end
						if activityID == 480 then	-- ToV M
							SendChatMessage(botting_achievement(11580),"WHISPER",nil,leaderName)						
						end

						if activityID == 413 or activityID == 414 then -- EN N/H
							SendChatMessage(raid_achievement(11191,11194),"WHISPER",nil,leaderName)
						end
						if activityID == 468 then	-- EN M
							SendChatMessage(botting_achievement(11191),"WHISPER",nil,leaderName)						
						end

						if activityID == 6 then -- 2 Bots vs 2 Bots
							SendChatMessage(botting_achievement(1159,true),"WHISPER",nil,leaderName)
						end
						if activityID == 7 then -- 3 Bots vs 3 Bots
							SendChatMessage(botting_achievement(5267,true),"WHISPER",nil,leaderName)
						end
						if activityID == 19 then -- Rated Bots
							SendChatMessage(botting_achievement(5356,true)..botting_achievement(5267,true),"WHISPER",nil,leaderName)	-- Rated Bots + 3 Bots vs 3 Bots
						end
					end
				end
			}),
			LFGListSearchReporter:new({
				text = REMOVE,
				func = function(_,groupid)
					local id, activityID, name, comment, voiceChat, iLvl, honorLevel,
						age, numBNetFriends, numCharFriends, numGuildMates,
						isDelisted, leaderName, numMembers, autoaccept = C_LFGList.GetSearchResultInfo(groupid)
					local summary,data = comment:match('^(.*)%((^1^.+^^)%)$')
					if summary then
						comment = summary
					end
					if data and not data:find("LookingForGroup") then
						name = ""
						comment = summary
					end
					name = name:gsub(" ",""):lower()
					comment = comment:gsub(" ",""):lower()
					local string_find = string.find
					local table_insert = table.insert
					local LookingForGroup = LibStub("AceAddon-3.0"):GetAddon("LookingForGroup")
					local profile = LookingForGroup.db.profile
					local filters = profile.spam_filter_keywords
					local tb = {}
					for i=1,#filters do
						local ele = filters[i]
						if not string_find(name,ele) and not string_find(comment,ele) and not string_find(voiceChat,ele) then
							table_insert(tb,ele)
						end
					end
					profile.spam_filter_keywords = tb
				end
			}),
			{
				text = LFG_LIST_REPORT_GROUP_FOR,
				hasArrow = true,
				notCheckable = true,
				menuList =
				{
					LFGListSearchReporter:new({text = LFG_LIST_BAD_NAME,arg2 = "lfglistname"}),
					LFGListSearchReporter:new({text = LFG_LIST_BAD_DESCRIPTION,arg2 = "lfglistcomment"}),
					LFGListSearchReporter:new({text = LFG_LIST_BAD_VOICE_CHAT_COMMENT,arg2 = "lfglistvoicechat"}),
					LFGListSearchReporter:new({text = LFG_LIST_BAD_LEADER_NAME,arg2 = "badplayername"}),
				},
			},
			{
				text = CANCEL,
				notCheckable = true,
			},
		}
	end
	return LFG_LIST_SEARCH_ENTRY_MENU;
end

local function AlignImage(self)
	local img = self.image:GetTexture()
	self.text:ClearAllPoints()
	if not img then
		self.text:SetPoint("LEFT", self.checkbg, "RIGHT")
		self.text:SetPoint("RIGHT")
	else
		self.text:SetPoint("LEFT", self.image,"RIGHT", 1, 0)
		self.text:SetPoint("RIGHT")
	end
end

AceGUI:RegisterWidgetType("LookingForGroup_search_result_checkbox", function()
	local check = AceGUI:Create("CheckBox")
	local frame = check.frame
	frame:RegisterForClicks("LeftButtonDown","RightButtonDown")
	frame:SetScript("OnMouseUp",function(self,button)
		local obj = self.obj
		local user = obj:GetUserDataTable()
		if button == "LeftButton" then
			if not obj.disabled then
--				obj:ToggleChecked()
				if obj.checked then
					PlaySound("igMainMenuOptionCheckBoxOn")
				else -- for both nil and false (tristate)
					PlaySound("igMainMenuOptionCheckBoxOff")
				end
				
				obj:Fire("OnValueChanged", obj.checked)
				AlignImage(obj)
			end
		else
--			LFGListFrameDropDown:SetPoint("CENTER"frame)
			EasyMenu(GetSearchEntryMenu(user.val), LFGListFrameDropDown, "cursor" , 0, 0, "MENU")				
		end
	end)
	check.width = "fill"
	return AceGUI:RegisterAsWidget(check)
end, 1)
