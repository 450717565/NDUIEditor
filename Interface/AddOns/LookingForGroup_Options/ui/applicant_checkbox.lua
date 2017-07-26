local AceGUI = LibStub("AceGUI-3.0")
local LookingForGroup_Options = LibStub("AceAddon-3.0"):GetAddon("LookingForGroup_Options")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")

local C_LFGList_ReportSearchResult = C_LFGList.ReportSearchResult
local ChatFrame_SendTell = ChatFrame_SendTell
local EasyMenu = EasyMenu

local L = LibStub("AceLocale-3.0"):GetLocale("LookingForGroup_Options")

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

local LFGListApplicanter =
{
	notCheckable = true,
}
LFGListApplicanter.__index = LFGListApplicanter

function LFGListApplicanter:new(o)
	setmetatable(o,self)
	return o
end

local function backfunc()
	if LookingForGroup_Options.option_table.args.requests then
		AceConfigDialog:SelectGroup("LookingForGroup","requests")
	end
end

local function paste(text)
	LookingForGroup_Options.Paste(text,backfunc)
end

local armory_menu = {}
local concat_tb = {}

local function update_armory_menu()
	wipe(armory_menu)
	local k,v
	for k,v in pairs(LookingForGroup_Options.armory) do
		armory_menu[#armory_menu + 1] = LFGListApplicanter:new(
		{
			text = k,
			func = function(_, id)
				local numMembers = select(4,C_LFGList.GetApplicantInfo(id))
				if numMembers == nil then
					return
				end
				local i
				wipe(concat_tb)
				for i = 1, numMembers do
					local applicantName = C_LFGList.GetApplicantMemberInfo(id,i)
					if applicantName then					
						if i ~= 1 then
							concat_tb[#concat_tb + 1] = '\n\n'
						end
						concat_tb[#concat_tb + 1] = v(applicantName)
					end
				end
				paste(table.concat(concat_tb))
			end,
		})
	end
	table.sort(armory_menu,function(a,b)
		return a.text < b.text
	end)
end
LookingForGroup_Options:RegisterMessage("UpdateArmory",update_armory_menu)

local LFG_LIST_APPLICANT_MEMBER_MENU

local function GetApplicantMemberMenu(applicantID, memberIdx)
	LFGListApplicanter.arg1 = applicantID
	LFGListApplicanter.arg2 = memberIdx
	if LFG_LIST_APPLICANT_MEMBER_MENU == nil then
		update_armory_menu()
		LFG_LIST_APPLICANT_MEMBER_MENU =
		{
			LFGListApplicanter:new({text = WHISPER,
			func = function(_, id,memberIdx)
				local applicantName = C_LFGList.GetApplicantMemberInfo(id,memberIdx)
				if applicantName then
					ChatFrame_SendTell(applicantName)
				end
			end}),
			{
				text = L.Armory,
				hasArrow = true,
				notCheckable = true,
				menuList = armory_menu
			},
			{
				text = LFG_LIST_REPORT_FOR,
				hasArrow = true,
				notCheckable = true,
				menuList =
				{
					LFGListApplicanter:new({text = LFG_LIST_BAD_PLAYER_NAME,func = function(_,id,memberIdx) C_LFGList.ReportApplicant(arg1,"badplayername",memberIdx); end}),
					LFGListApplicanter:new({text = LFG_LIST_BAD_DESCRIPTION,func = function(_,id) C_LFGList.ReportApplicant(arg1,"lfglistappcomment"); end}),
				}
			},
			LFGListApplicanter:new({text = IGNORE_PLAYER,function(_,id,memberIdx)
				local applicantName = C_LFGList.GetApplicantMemberInfo(id,memberIdx)
				if applicantName then
					AddIgnore(applicantName)
				end
				C_LFGList.DeclineApplicant(id)
			end}),
			{
				text = CANCEL,
				notCheckable = true,
			},
		}
	end
	return LFG_LIST_APPLICANT_MEMBER_MENU
end

AceGUI:RegisterWidgetType("LookingForGroup_applicant_checkbox", function()
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
			EasyMenu(GetApplicantMemberMenu(user.val,1), LFGListFrameDropDown, "cursor" , 0, 0, "MENU")
		end
	end)
	check.width = "fill"
	return AceGUI:RegisterAsWidget(check)
end, 1)
