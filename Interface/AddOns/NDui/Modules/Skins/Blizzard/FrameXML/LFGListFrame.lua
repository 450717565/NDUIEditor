local B, C, L, DB = unpack(select(2, ...))

tinsert(C.defaultThemes, function()
	local cr, cg, cb = DB.r, DB.g, DB.b

	--CategorySelection
	local CategorySelection = LFGListFrame.CategorySelection
	B.StripTextures(CategorySelection)
	B.ReskinButton(CategorySelection.FindGroupButton)
	B.ReskinButton(CategorySelection.StartGroupButton)

	hooksecurefunc("LFGListCategorySelection_AddButton", function(self, btnIndex)
		local bu = self.CategoryButtons[btnIndex]

		if bu and not bu.styled then
			bu.Cover:Hide()
			B.CreateBDFrame(bu.Icon, 0)

			bu.styled = true
		end
	end)

	--NothingAvailable
	local NothingAvailable = LFGListFrame.NothingAvailable
	B.StripTextures(NothingAvailable)

	--SearchPanel
	local SearchPanel = LFGListFrame.SearchPanel
	B.StripTextures(SearchPanel.ResultsInset)
	B.StripTextures(SearchPanel.AutoCompleteFrame)
	B.ReskinButton(SearchPanel.RefreshButton)
	B.ReskinButton(SearchPanel.BackButton)
	B.ReskinButton(SearchPanel.SignUpButton)
	B.ReskinButton(SearchPanel.ScrollFrame.StartGroupButton)
	B.ReskinInput(SearchPanel.SearchBox)
	B.ReskinScroll(SearchPanel.ScrollFrame.scrollBar)

	SearchPanel.RefreshButton:SetSize(24, 24)
	SearchPanel.RefreshButton.Icon:SetPoint("CENTER")

	local function resultOnEnter(self)
		self.hl:Show()
	end

	local function resultOnLeave(self)
		self.hl:Hide()
	end

	hooksecurefunc("LFGListSearchPanel_UpdateAutoComplete", function(self)
		local AutoCompleteFrame = self.AutoCompleteFrame

		for i = 1, #AutoCompleteFrame.Results do
			local result = AutoCompleteFrame.Results[i]
			B.StripTextures(result)

			if not result.styled then
				local bg = B.CreateBDFrame(result, 0)
				bg:SetPoint("TOPLEFT", 0, -C.mult)
				bg:SetPoint("BOTTOMRIGHT", 0, C.mult)

				local hl = bg:CreateTexture(nil, "BACKGROUND")
				hl:SetAllPoints()
				hl:SetTexture(DB.bdTex)
				hl:SetVertexColor(cr, cg, cb, .25)
				hl:Hide()
				result.hl = hl

				result:HookScript("OnEnter", resultOnEnter)
				result:HookScript("OnLeave", resultOnLeave)

				result.styled = true
			end
		end
	end)

	hooksecurefunc("LFGListSearchEntry_Update", function(self)
		local CancelButton = self.CancelButton

		if not CancelButton.styled then
			B.ReskinDecline(CancelButton)

			CancelButton.styled = true
		end
	end)

	--ApplicationViewer
	local ApplicationViewer = LFGListFrame.ApplicationViewer
	B.StripTextures(ApplicationViewer, 0)

	B.ReskinButton(ApplicationViewer.RefreshButton)
	B.ReskinButton(ApplicationViewer.RemoveEntryButton)
	B.ReskinButton(ApplicationViewer.EditButton)
	B.ReskinScroll(LFGListApplicationViewerScrollFrameScrollBar)

	ApplicationViewer.RefreshButton:SetSize(24, 24)
	ApplicationViewer.RefreshButton.Icon:SetPoint("CENTER")

	local Background = ApplicationViewer.UnempoweredCover.Background
	Background:SetPoint("TOPLEFT", 2, 0)
	Background:SetPoint("BOTTOMRIGHT", 1, -1)

	for _, headerName in pairs({"NameColumnHeader", "RoleColumnHeader", "ItemLevelColumnHeader"}) do
		local header = ApplicationViewer[headerName]
		B.StripTextures(header)
		B.CreateBDFrame(header, 0, -C.mult*2)
	end

	hooksecurefunc("LFGListApplicationViewer_UpdateApplicant", function(button)
		if not button.styled then
			B.ReskinDecline(button.DeclineButton)
			B.ReskinButton(button.InviteButton)

			button.styled = true
		end
	end)

	--EntryCreation
	local EntryCreation = LFGListFrame.EntryCreation
	B.StripTextures(EntryCreation)
	B.ReskinInput(EntryCreation.Description)

	B.ReskinButton(EntryCreation.ListGroupButton)
	B.ReskinButton(EntryCreation.CancelButton)
	B.ReskinInput(EntryCreation.Name)
	B.ReskinInput(EntryCreation.ItemLevel.EditBox)
	B.ReskinInput(EntryCreation.VoiceChat.EditBox)
	B.ReskinDropDown(EntryCreation.CategoryDropDown)
	B.ReskinDropDown(EntryCreation.GroupDropDown)
	B.ReskinDropDown(EntryCreation.ActivityDropDown)
	B.ReskinCheck(EntryCreation.ItemLevel.CheckButton)
	B.ReskinCheck(EntryCreation.VoiceChat.CheckButton)
	B.ReskinCheck(EntryCreation.PrivateGroup.CheckButton)
	B.ReskinCheck(LFGListFrame.ApplicationViewer.AutoAcceptButton)

	--ActivityFinder
	local ActivityFinder = EntryCreation.ActivityFinder.Dialog
	B.ReskinFrame(ActivityFinder)
	B.ReskinButton(ActivityFinder.SelectButton)
	B.ReskinButton(ActivityFinder.CancelButton)
	B.ReskinInput(ActivityFinder.EntryBox)
	B.ReskinScroll(LFGListEntryCreationSearchScrollFrameScrollBar)

	--LFGListApplicationDialog
	B.ReskinFrame(LFGListApplicationDialog)
	B.ReskinInput(LFGListApplicationDialog.Description)
	B.ReskinButton(LFGListApplicationDialog.SignUpButton)
	B.ReskinButton(LFGListApplicationDialog.CancelButton)

	--LFGListInviteDialog
	B.ReskinFrame(LFGListInviteDialog, "noKill")
	B.ReskinButton(LFGListInviteDialog.AcceptButton)
	B.ReskinButton(LFGListInviteDialog.DeclineButton)
	B.ReskinButton(LFGListInviteDialog.AcknowledgeButton)

	local RoleIcon = LFGListInviteDialog.RoleIcon
	B.ReskinRoleIcon(RoleIcon)

	hooksecurefunc("LFGListInviteDialog_Show", function(self, resultID)
		local role = select(5, C_LFGList.GetApplicationInfo(resultID))
		self.RoleIcon:SetTexCoord(B.GetRoleTexCoord(role))
	end)
end)