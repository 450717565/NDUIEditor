local _, ns = ...
local B, C, L, DB = unpack(ns)

local cr, cg, cb = DB.cr, DB.cg, DB.cb

local function Update_RoleAnchor(self, role)
	local Count = self[role.."Count"]
	Count:SetWidth(24)
	Count:SetJustifyH("CENTER")
	Count:SetFontObject(Game13Font)
	Count:SetPoint("RIGHT", self[role.."Icon"], "LEFT", 1, 0)
end

local function Reskin_GroupDataDisplay(self)
	if not self.styled then
		B.ReskinRole(self.TankIcon, "TANK")
		B.ReskinRole(self.HealerIcon, "HEALER")
		B.ReskinRole(self.DamagerIcon, "DPS")

		self.DamagerIcon:ClearAllPoints()
		self.DamagerIcon:SetPoint("RIGHT", self, "RIGHT", -10, 0)
		self.HealerIcon:ClearAllPoints()
		self.HealerIcon:SetPoint("RIGHT", self.DamagerIcon, "LEFT", -24, 0)
		self.TankIcon:ClearAllPoints()
		self.TankIcon:SetPoint("RIGHT", self.HealerIcon, "LEFT", -24, 0)

		Update_RoleAnchor(self, "Tank")
		Update_RoleAnchor(self, "Healer")
		Update_RoleAnchor(self, "Damager")

		if self.Count then self.Count:SetWidth(25) end

		self.styled = true
	end
end

local function Reskin_CategorySelection(self, btnIndex)
	local button = self.CategoryButtons[btnIndex]
	if not button then return end

	if not button.styled then
		button.Cover:Hide()
		button.Icon:SetTexCoord(.01, .99, .01, .99)
		B.CreateBDFrame(button.Icon, 0, -C.mult)

		button.styled = true
	end
end

local function Reskin_ApplicationViewer(button)
	if not button.styled then
		B.ReskinDecline(button.DeclineButton)
		B.ReskinButton(button.InviteButton)

		button.styled = true
	end
end

local function Reskin_SearchPanel(self)
	local AutoCompleteFrame = self.AutoCompleteFrame

	for i = 1, #AutoCompleteFrame.Results do
		local result = AutoCompleteFrame.Results[i]
		if not result.styled then
			B.StripTextures(result)

			local bubg = B.CreateBDFrame(result, 0, 1)
			B.ReskinHighlight(result, bubg, true)

			result.styled = true
		end
	end
end

local function Reskin_SearchEntry(self)
	if not self.styled then
		self.ExpirationTime:SetWidth(40)
		B.ReskinDecline(self.CancelButton)

		self.styled = true
	end
end

local function Reskin_LFGListInviteDialog(self, resultID)
	local role = select(5, C_LFGList.GetApplicationInfo(resultID))
	self.RoleIcon:SetTexCoord(B.GetRoleTexCoord(role))
end

tinsert(C.XMLThemes, function()
	--NothingAvailable
	local NothingAvailable = LFGListFrame.NothingAvailable
	B.StripTextures(NothingAvailable)

	--CategorySelection
	local CategorySelection = LFGListFrame.CategorySelection
	B.StripTextures(CategorySelection)

	hooksecurefunc("LFGListCategorySelection_AddButton", Reskin_CategorySelection)

	--EntryCreation
	local EntryCreation = LFGListFrame.EntryCreation
	B.StripTextures(EntryCreation)

	local ActivityFinder = EntryCreation.ActivityFinder.Dialog
	B.ReskinFrame(ActivityFinder)
	EntryCreation.ActivityFinder.Background:Hide()

	local ApplicationViewer = LFGListFrame.ApplicationViewer
	B.StripTextures(ApplicationViewer, 0)

	ApplicationViewer.RefreshButton:SetSize(24, 24)
	ApplicationViewer.RefreshButton.Icon:SetPoint("CENTER")

	local headers = {
		"NameColumnHeader",
		"RoleColumnHeader",
		"ItemLevelColumnHeader",
	}
	for _, headerName in pairs(headers) do
		local header = ApplicationViewer[headerName]
		header.Label:SetFont(DB.Font[1], 14, DB.Font[3])
		header.Label:SetShadowColor(0, 0, 0, 0)

		B.StripTextures(header)
		B.CreateBGFrame(header, 3, -1, 1, 1)
	end

	hooksecurefunc("LFGListApplicationViewer_UpdateApplicant", Reskin_ApplicationViewer)

	-- SearchPanel
	local SearchPanel = LFGListFrame.SearchPanel
	B.StripTextures(SearchPanel.ResultsInset)
	B.StripTextures(SearchPanel.AutoCompleteFrame)

	SearchPanel.RefreshButton:SetSize(24, 24)
	SearchPanel.RefreshButton.Icon:SetPoint("CENTER")

	hooksecurefunc("LFGListGroupDataDisplayRoleCount_Update", Reskin_GroupDataDisplay)
	hooksecurefunc("LFGListSearchPanel_UpdateAutoComplete", Reskin_SearchPanel)
	hooksecurefunc("LFGListSearchEntry_Update", Reskin_SearchEntry)

	--LFGListApplicationDialog
	B.ReskinFrame(LFGListApplicationDialog)

	--LFGListInviteDialog
	B.ReskinFrame(LFGListInviteDialog, "none")

	local RoleIcon = LFGListInviteDialog.RoleIcon
	B.ReskinRoleIcon(RoleIcon)

	hooksecurefunc("LFGListInviteDialog_Show", Reskin_LFGListInviteDialog)

	-- General Reskin
	local buttons = {
		ActivityFinder.CancelButton,
		ActivityFinder.SelectButton,
		ApplicationViewer.EditButton,
		ApplicationViewer.RefreshButton,
		ApplicationViewer.RemoveEntryButton,
		CategorySelection.FindGroupButton,
		CategorySelection.StartGroupButton,
		EntryCreation.CancelButton,
		EntryCreation.ListGroupButton,
		LFGListApplicationDialog.CancelButton,
		LFGListApplicationDialog.SignUpButton,
		LFGListInviteDialog.AcceptButton,
		LFGListInviteDialog.AcknowledgeButton,
		LFGListInviteDialog.DeclineButton,
		SearchPanel.BackButton,
		SearchPanel.RefreshButton,
		SearchPanel.ScrollFrame.ScrollChild.StartGroupButton,
		SearchPanel.SignUpButton,
	}
	for _, button in pairs(buttons) do
		B.ReskinButton(button)
	end

	local inputs = {
		ActivityFinder.EntryBox,
		EntryCreation.Description,
		EntryCreation.ItemLevel.EditBox,
		EntryCreation.Name,
		EntryCreation.VoiceChat.EditBox,
		LFGListApplicationDialog.Description,
		SearchPanel.SearchBox,
	}
	for _, input in pairs(inputs) do
		B.ReskinInput(input)
	end

	local dropdowns = {
		EntryCreation.ActivityDropDown,
		EntryCreation.CategoryDropDown,
		EntryCreation.GroupDropDown,
	}
	for _, dropdown in pairs(dropdowns) do
		B.ReskinDropDown(dropdown)
	end

	local checks = {
		EntryCreation.ItemLevel.CheckButton,
		EntryCreation.PrivateGroup.CheckButton,
		EntryCreation.VoiceChat.CheckButton,
		LFGListFrame.ApplicationViewer.AutoAcceptButton,
	}
	for _, check in pairs(checks) do
		B.ReskinCheck(check)
	end

	local scrolls = {
		LFGListApplicationDialogDescriptionScrollBar,
		LFGListApplicationViewerScrollFrameScrollBar,
		LFGListEntryCreationSearchScrollFrameScrollBar,
		SearchPanel.ScrollFrame.scrollBar,
	}
	for _, scroll in pairs(scrolls) do
		B.ReskinScroll(scroll)
	end
end)