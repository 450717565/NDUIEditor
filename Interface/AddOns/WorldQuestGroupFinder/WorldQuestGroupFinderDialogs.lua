WorldQuestGroupFinderDialogs = {}

local L = LibStub ("AceLocale-3.0"):GetLocale ("WorldQuestGroupFinder", true)

StaticPopupDialogs["WORLD_QUEST_FINISHED_LEADER_PROMPT"] = {
	text = L["WQGF_WQ_COMPLETE_LEAVE_OR_DELIST_DIALOG"],
	button1 = L["WQGF_LEAVE"],
	button2 = L["WQGF_STAY"],
	button3 = L["WQGF_DELIST"],
	OnAccept = function()
		LeaveParty()
	end,
	OnAlt = function()
		C_LFGList.RemoveListing()
	end,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
	preferredIndex = 3,  
}

StaticPopupDialogs["QUEST_FINISHED_LEADER_PROMPT"] = {
	text = L["WQGF_QUEST_COMPLETE_LEAVE_OR_DELIST_DIALOG"],
	button1 = L["WQGF_LEAVE"],
	button2 = L["WQGF_STAY"],
	button3 = L["WQGF_DELIST"],
	OnAccept = function()
		LeaveParty()
	end,
	OnAlt = function()
		C_LFGList.RemoveListing()
	end,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
	preferredIndex = 3,  
}

StaticPopupDialogs["WORLD_QUEST_FINISHED_PROMPT"] = {
	text = L["WQGF_WQ_COMPLETE_LEAVE_DIALOG"],
	button1 = L["WQGF_LEAVE"],
	button2 = L["WQGF_STAY"],
	OnAccept = function()
		LeaveParty()
	end,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
	preferredIndex = 3,  
}

StaticPopupDialogs["QUEST_FINISHED_PROMPT"] = {
	text = L["WQGF_QUEST_COMPLETE_LEAVE_DIALOG"],
	button1 = L["WQGF_LEAVE"],
	button2 = L["WQGF_STAY"],
	OnAccept = function()
		LeaveParty()
	end,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
	preferredIndex = 3,  
}

StaticPopupDialogs["NEW_WORLD_QUEST_PROMPT"] = {
	text = L["WQGF_START_ANOTHER_WQ_DIALOG"],
	button1 = L["WQGF_YES"],
	button2 = L["WQGF_CANCEL"],  
	OnAccept = function(self, data)
		LeaveParty()
		C_Timer.After(1, function()
			WorldQuestGroupFinder.HandleBlockClick(data, true)
		end)
	end,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
	enterClicksFirstButton = true,
	preferredIndex = 3,  
}

StaticPopupDialogs["NEW_QUEST_PROMPT"] = {
	text = L["WQGF_START_ANOTHER_QUEST_DIALOG"],
	button1 = L["WQGF_YES"],
	button2 = L["WQGF_CANCEL"],  
	OnAccept = function(self, data)
		LeaveParty()
		C_Timer.After(1, function()
			WorldQuestGroupFinder.HandleBlockClick(data, true)
		end)
	end,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
	enterClicksFirstButton = true,
	preferredIndex = 3,  
}

StaticPopupDialogs["WORLD_QUEST_ENTERED_PROMPT"] = {
	text = L["WQGF_WQ_AREA_ENTERED_DIALOG"],
	button1 = L["WQGF_YES"],
	button2 = L["WQGF_NO"],  
	OnAccept = function(self, data)
		WorldQuestGroupFinder.HandleBlockClick(data, true)
	end,
	OnCancel = function()
		WorldQuestGroupFinder.resetTmpWQ()
	end,
	timeout = 15,
	whileDead = true,
	hideOnEscape = true,
	preferredIndex = 3,  
}

StaticPopupDialogs["WORLD_QUEST_ENTERED_SWITCH_PROMPT"] = {
	text = L["WQGF_WQ_AREA_ENTERED_ALREADY_GROUPED_DIALOG"],
	button1 = L["WQGF_YES"],
	button2 = L["WQGF_NO"],  
	OnAccept = function()
		LeaveParty()
		C_Timer.After(1, function(self, data)
			WorldQuestGroupFinder.HandleBlockClick(data, true)
		end)
	end,
	OnCancel = function()
		WorldQuestGroupFinder.resetTmpWQ()
	end,
	timeout = 15,
	whileDead = false,
	hideOnEscape = true,
	preferredIndex = 3,  
}

StaticPopupDialogs["WORLD_QUEST_COMPLETED_LEAVE_GROUP_DIALOG"] = {
	text = string.format(L["WQGF_AUTO_LEAVING_DIALOG"], 10),
	button1 = L["WQGF_STAY"],
	button2 = L["WQGF_LEAVE"],
	OnShow = function(self)
		self.timeleft = 10
	end,
	OnAccept = function(self)
	end,
	OnCancel = function()
		LeaveParty()
	end,
	OnUpdate = function(self, elapsed)
		self.text:SetText(string.format(L["WQGF_AUTO_LEAVING_DIALOG"], self.timeleft+1))
	end,
	timeout = 10,
	hideOnEscape = 0,
	whileDead = true
}

StaticPopupDialogs["QUEST_COMPLETED_LEAVE_GROUP_DIALOG"] = {
	text = string.format(L["WQGF_AUTO_LEAVING_DIALOG_QUEST"], 10),
	button1 = L["WQGF_STAY"],
	button2 = L["WQGF_LEAVE"],
	OnShow = function(self)
		self.timeleft = 10
	end,
	OnAccept = function(self)
	end,
	OnCancel = function()
		LeaveParty()
	end,
	OnUpdate = function(self, elapsed)
		self.text:SetText(string.format(L["WQGF_AUTO_LEAVING_DIALOG_QUEST"], self.timeleft+1))
	end,
	timeout = 10,
	hideOnEscape = 0,
	whileDead = true
};