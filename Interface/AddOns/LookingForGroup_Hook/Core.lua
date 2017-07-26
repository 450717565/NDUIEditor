local LibStub = LibStub
local AceAddon = LibStub("AceAddon-3.0")
local LookingForGroup = AceAddon:GetAddon("LookingForGroup")
local LookingForGroup_Hook = AceAddon:NewAddon("LookingForGroup_Hook","AceHook-3.0")

--------------------------------------------------------------------------------------
local AceConfigDialog = LibStub("AceConfigDialog-3.0")

function LookingForGroup_Hook:OnInitialize()
end

function LookingForGroup_Hook:OnEnable()
	if LookingForGroup.db.profile.enable_hook then
		local function nullfun()end
		self:RawHook("LFGListCategorySelection_StartFindGroup",true)
		self:RawHook("LFGListFrame_BeginFindQuestGroup",true)
		self:RawHook("LFGListEntryCreation_Show",true)
		self:RawHook("QueueStatusDropDown_AddLFGListButtons",true)
		self:RawHook("LFGListUtil_OpenBestWindow",true)
		self:RawHook("QueueStatusDropDown_AddLFGListApplicationButtons",true)
		self:RawHook("QueueStatusEntry_SetUpLFGListApplication",true)
		self:RawHook("QueueStatusEntry_SetUpLFGListActiveEntry",true)
		self:RawHook("ChatFrame_DisplayGMOTD",nullfun,true)
		self:RawHook("LFGListSearchEntry_Update",nullfun,true)
		self:RawHook("LFGListInviteDialog_Show",true)
--		self:RawHook("LFGListFrame_OnEvent",function(...) print(...); end,true)
--		LFGListFrame:UnregisterEvent("LFG_LIST_APPLICANT_LIST_UPDATED")
--		LFGListFrame:UnregisterEvent("LFG_LIST_APPLICANT_LIST_UPDATED")
--		LFGListFrame:UnregisterEvent("LFG_LIST_APPLICANT_UPDATED")
		self:RawHook(QuickJoinFrame,"Show",nullfun,true)
		self:RawHookScript(LFGListFrame,"OnEvent",nullfun)
--		self:RawHookScript(QuickJoinMixin,"OnEvent",function() print("here") ;end,true)
	else
		self:UnhookAll()
	end
end

function LookingForGroup_Hook:LFGListFrame_BeginFindQuestGroup(panel,questID)
	if LookingForGroup.db.profile.enable_wq then
		LookingForGroup.GetAddon("LookingForGroup_WQ"):QUEST_ACCEPTED(LookingForGroup,0,questID)
		return
	end
	local LookingForGroup_Options = LookingForGroup.GetAddon("LookingForGroup_Options")
	LookingForGroup_Options.db.profile.start_a_group_quest_id = questID
	LookingForGroup_Options.do_wq_search()
	AceConfigDialog:Open("LookingForGroup")
end

function LookingForGroup_Hook:LFGListCategorySelection_StartFindGroup(panel)
	LoadAddOn("LookingForGroup_Options")
	AceConfigDialog:SelectGroup("LookingForGroup","find","f")
	AceConfigDialog:Open("LookingForGroup")
end

function LookingForGroup_Hook:LFGListEntryCreation_Show(_,_,category)
	local option = LookingForGroup.GetAddon("LookingForGroup_Options")
	PVEFrame:Hide()
	option.SetCategory(_,category)
	AceConfigDialog:SelectGroup("LookingForGroup","find","s")
	AceConfigDialog:Open("LookingForGroup")
end

function LookingForGroup_Hook:LFGListUtil_OpenBestWindow()
	local option = LookingForGroup.GetAddon("LookingForGroup_Options")
	if option.option_table.args.requests == nil then
		option.set_requests()
	end
	AceConfigDialog:SelectGroup("LookingForGroup","requests")
	AceConfigDialog:Open("LookingForGroup")
end

function LookingForGroup_Hook:QueueStatusDropDown_AddLFGListApplicationButtons(info, resultID)
	wipe(info)
	info.text = LookingForGroup.GetAddon("LookingForGroup_Core").GetSearchResultName(resultID)
	info.isTitle = 1
	info.notCheckable = 1
	UIDropDownMenu_AddButton(info)
	wipe(info)
	info.text = CANCEL_SIGN_UP
	info.func = function(_,id) C_LFGList.CancelApplication(id)  end
	info.arg1 = resultID
	info.leftPadding = 10
	info.disabled = IsInGroup() and not UnitIsGroupLeader("player")
	UIDropDownMenu_AddButton(info)
end

function LookingForGroup_Hook:QueueStatusDropDown_AddLFGListButtons(info)
	wipe(info)
	if UnitIsGroupLeader("player") then
		info.text = EDIT
	else
		info.text = VIEW
	end
	info.func = function()
		LookingForGroup.GetAddon("LookingForGroup_Options").UpdateEditing()
		PVEFrame:Hide()
		AceConfigDialog:SelectGroup("LookingForGroup","find","s")
		AceConfigDialog:Open("LookingForGroup")
	end
	UIDropDownMenu_AddButton(info)
	info.text = LFG_LIST_VIEW_GROUP
	info.func = LFGListUtil_OpenBestWindow
	UIDropDownMenu_AddButton(info)
	if UnitIsGroupLeader("player") then
		info.text = UNLIST_MY_GROUP
		info.func = C_LFGList.RemoveListing
		UIDropDownMenu_AddButton(info)
	end
end

function LookingForGroup_Hook:QueueStatusEntry_SetUpLFGListApplication(entry,resultID)
	local name , comment = LookingForGroup.GetAddon("LookingForGroup_Core").GetSearchResultName(resultID)
	QueueStatusEntry_SetMinimalDisplay(entry,name,QUEUE_STATUS_SIGNED_UP,comment)
end

function LookingForGroup_Hook:QueueStatusEntry_SetUpLFGListActiveEntry(entry)
	local name, info = LookingForGroup.GetAddon("LookingForGroup_Core").GetActiveEntryInfo()
	QueueStatusEntry_SetMinimalDisplay(entry,name,QUEUE_STATUS_LISTED,info)
end

function LookingForGroup_Hook:LFGListInviteDialog_Show(entry,resultID)
	local _, status, _, _, role = C_LFGList.GetApplicationInfo(resultID);

	local informational = (status ~= "invited");
	assert(not informational or status == "inviteaccepted");

	entry.resultID = resultID;
	
	local gpn,actn = LookingForGroup.GetAddon("LookingForGroup_Core").GetSearchResultInviteDialog(resultID)
	entry.GroupName:SetText(gpn);
	entry.ActivityName:SetText(actn);
	entry.Role:SetText(_G[role]);
	entry.RoleIcon:SetTexCoord(GetTexCoordsForRole(role));
	entry.Label:SetText(informational and LFG_LIST_JOINED_GROUP_NOTICE or LFG_LIST_INVITED_TO_GROUP);

	entry.informational = informational;
	entry.AcceptButton:SetShown(not informational);
	entry.DeclineButton:SetShown(not informational);
	entry.AcknowledgeButton:SetShown(informational);

	if ( not informational and GroupHasOfflineMember(LE_PARTY_CATEGORY_HOME) ) then
		entry:SetHeight(250);
		entry.OfflineNotice:Show();
		LFGListInviteDialog_UpdateOfflineNotice(entry);
	else
		entry:SetHeight(210);
		entry.OfflineNotice:Hide();
	end

	StaticPopupSpecial_Show(entry);

	PlaySound("ReadyCheck");
	FlashClientIcon();
end
