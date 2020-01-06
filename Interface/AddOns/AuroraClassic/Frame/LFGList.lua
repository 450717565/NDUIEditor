local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	local cr, cg, cb = C.r, C.g, C.b

	--CategorySelection
	local CategorySelection = LFGListFrame.CategorySelection
	F.StripTextures(CategorySelection)
	F.ReskinButton(CategorySelection.FindGroupButton)
	F.ReskinButton(CategorySelection.StartGroupButton)

	hooksecurefunc("LFGListCategorySelection_AddButton", function(self, btnIndex)
		local bu = self.CategoryButtons[btnIndex]

		if bu and not bu.styled then
			bu.Cover:Hide()
			F.CreateBDFrame(bu.Icon, 1, nil, true)

			bu.styled = true
		end
	end)

	--NothingAvailable
	local NothingAvailable = LFGListFrame.NothingAvailable
	F.StripTextures(NothingAvailable)

	--SearchPanel
	local SearchPanel = LFGListFrame.SearchPanel
	F.StripTextures(SearchPanel.ResultsInset)
	F.StripTextures(SearchPanel.AutoCompleteFrame)
	F.ReskinButton(SearchPanel.RefreshButton)
	F.ReskinButton(SearchPanel.BackButton)
	F.ReskinButton(SearchPanel.SignUpButton)
	F.ReskinButton(SearchPanel.ScrollFrame.StartGroupButton)
	F.ReskinInput(SearchPanel.SearchBox)
	F.ReskinScroll(SearchPanel.ScrollFrame.scrollBar)

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
			F.StripTextures(result)

			if not result.styled then
				local bg = F.CreateBDFrame(result, 0)
				bg:SetPoint("TOPLEFT", 0, -C.mult)
				bg:SetPoint("BOTTOMRIGHT", 0, C.mult)

				local hl = bg:CreateTexture(nil, "BACKGROUND")
				hl:SetAllPoints()
				hl:SetTexture(C.media.bdTex)
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
			F.ReskinDecline(CancelButton)

			CancelButton.styled = true
		end
	end)

	--ApplicationViewer
	local ApplicationViewer = LFGListFrame.ApplicationViewer
	F.StripTextures(ApplicationViewer, true)

	F.ReskinButton(ApplicationViewer.RefreshButton)
	F.ReskinButton(ApplicationViewer.RemoveEntryButton)
	F.ReskinButton(ApplicationViewer.EditButton)
	F.ReskinScroll(LFGListApplicationViewerScrollFrameScrollBar)

	ApplicationViewer.RefreshButton:SetSize(24, 24)
	ApplicationViewer.RefreshButton.Icon:SetPoint("CENTER")

	local Background = ApplicationViewer.UnempoweredCover.Background
	Background:SetPoint("TOPLEFT", 2, 0)
	Background:SetPoint("BOTTOMRIGHT", 1, -1)

	for _, headerName in pairs({"NameColumnHeader", "RoleColumnHeader", "ItemLevelColumnHeader"}) do
		local header = ApplicationViewer[headerName]
		F.StripTextures(header)
		F.CreateBDFrame(header, 0, -C.pixel)
	end

	hooksecurefunc("LFGListApplicationViewer_UpdateApplicant", function(button)
		if not button.styled then
			F.ReskinDecline(button.DeclineButton)
			F.ReskinButton(button.InviteButton)

			button.styled = true
		end
	end)

	--EntryCreation
	local EntryCreation = LFGListFrame.EntryCreation
	F.StripTextures(EntryCreation)
	F.ReskinInput(EntryCreation.Description)

	F.ReskinButton(EntryCreation.ListGroupButton)
	F.ReskinButton(EntryCreation.CancelButton)
	F.ReskinInput(EntryCreation.Name)
	F.ReskinInput(EntryCreation.ItemLevel.EditBox)
	F.ReskinInput(EntryCreation.VoiceChat.EditBox)
	F.ReskinDropDown(EntryCreation.CategoryDropDown)
	F.ReskinDropDown(EntryCreation.GroupDropDown)
	F.ReskinDropDown(EntryCreation.ActivityDropDown)
	F.ReskinCheck(EntryCreation.ItemLevel.CheckButton)
	F.ReskinCheck(EntryCreation.VoiceChat.CheckButton)
	F.ReskinCheck(EntryCreation.PrivateGroup.CheckButton)
	F.ReskinCheck(LFGListFrame.ApplicationViewer.AutoAcceptButton)

	--ActivityFinder
	local ActivityFinder = EntryCreation.ActivityFinder.Dialog
	F.ReskinFrame(ActivityFinder)
	F.ReskinButton(ActivityFinder.SelectButton)
	F.ReskinButton(ActivityFinder.CancelButton)
	F.ReskinInput(ActivityFinder.EntryBox)
	F.ReskinScroll(LFGListEntryCreationSearchScrollFrameScrollBar)

	--LFGListApplicationDialog
	F.ReskinFrame(LFGListApplicationDialog)
	F.ReskinInput(LFGListApplicationDialog.Description)
	F.ReskinButton(LFGListApplicationDialog.SignUpButton)
	F.ReskinButton(LFGListApplicationDialog.CancelButton)

	--LFGListInviteDialog
	F.ReskinFrame(LFGListInviteDialog, true)
	F.ReskinButton(LFGListInviteDialog.AcceptButton)
	F.ReskinButton(LFGListInviteDialog.DeclineButton)
	F.ReskinButton(LFGListInviteDialog.AcknowledgeButton)

	local RoleIcon = LFGListInviteDialog.RoleIcon
	F.ReskinRoleIcon(RoleIcon)

	hooksecurefunc("LFGListInviteDialog_Show", function(self, resultID)
		local role = select(5, C_LFGList.GetApplicationInfo(resultID))
		self.RoleIcon:SetTexCoord(F.GetRoleTexCoord(role))
	end)
end)