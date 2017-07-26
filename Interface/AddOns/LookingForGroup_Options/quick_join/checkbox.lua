local AceGUI = LibStub("AceGUI-3.0")

local C_LFGList_ReportSearchResult = C_LFGList.ReportSearchResult
local EasyMenu = EasyMenu

local ENTRY_MENU

local function GetSearchEntryMenu(aid)
	if ENTRY_MENU == nil then
		ENTRY_MENU =
		{
			{
				text = WHISPER,
				func = function(_, id)
					local players = C_SocialQueue.GetGroupMembers(id)
					if players~=nil and #players ~= 0 then
						local link,text = SplitLink(select(4,SocialQueueUtil_GetNameAndColor(players[1])))
						SetItemRef(link,text,"LeftButton")
					end
				end,
				notCheckable = true
			},
			{
				text = CANCEL,
				notCheckable = true,
			},
		}
	end
	ENTRY_MENU[1].arg1 = aid
	return ENTRY_MENU;
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

AceGUI:RegisterWidgetType("LookingForGroup_quick_join_checkbox", function()
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
			local val = user.val
			EasyMenu(GetSearchEntryMenu(val), LFGListFrameDropDown, self , 20, 0, "MENU")				
		end
	end)
	check.width = "fill"
	return AceGUI:RegisterAsWidget(check)
end, 1)
