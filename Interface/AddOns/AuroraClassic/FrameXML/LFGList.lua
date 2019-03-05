local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	local r, g, b = C.r, C.g, C.b

	local function HLOnEnter(self)
		self.hl:Show()
	end

	local function HLOnLeave(self)
		self.hl:Hide()
	end

	local function reskinHL(f, bg)
		local hl = bg:CreateTexture(nil, "BACKGROUND")
		hl:SetAllPoints()
		hl:SetTexture(C.media.bdTex)
		hl:SetVertexColor(r, g, b, .25)
		hl:Hide()
		f.hl = hl

		f:HookScript("OnEnter", HLOnEnter)
		f:HookScript("OnLeave", HLOnLeave)
	end

	-- [[ Category selection ]]
	local CategorySelection = LFGListFrame.CategorySelection
	F.StripTextures(CategorySelection, true)
	F.ReskinButton(CategorySelection.FindGroupButton)
	F.ReskinButton(CategorySelection.StartGroupButton)

	hooksecurefunc("LFGListCategorySelection_AddButton", function(self, btnIndex)
		local bu = self.CategoryButtons[btnIndex]

		if bu and not bu.styled then
			bu.Cover:Hide()
			bu.Icon:SetTexCoord(.01, .99, .01, .99)
			F.CreateBDFrame(bu.Icon, 0)

			bu.styled = true
		end
	end)

	-- [[ Nothing available ]]
	local NothingAvailable = LFGListFrame.NothingAvailable
	F.StripTextures(NothingAvailable, true)

	-- [[ Search panel ]]
	local SearchPanel = LFGListFrame.SearchPanel
	F.StripTextures(SearchPanel.ResultsInset, true)
	F.StripTextures(SearchPanel.AutoCompleteFrame, true)
	F.ReskinButton(SearchPanel.RefreshButton)
	F.ReskinButton(SearchPanel.BackButton)
	F.ReskinButton(SearchPanel.SignUpButton)
	F.ReskinButton(SearchPanel.ScrollFrame.StartGroupButton)
	F.ReskinInput(SearchPanel.SearchBox)
	F.ReskinScroll(SearchPanel.ScrollFrame.scrollBar)

	SearchPanel.RefreshButton:SetSize(24, 24)
	SearchPanel.RefreshButton.Icon:SetPoint("CENTER")

	hooksecurefunc("LFGListSearchPanel_UpdateAutoComplete", function(self)
		local AutoCompleteFrame = self.AutoCompleteFrame

		for i = 1, #AutoCompleteFrame.Results do
			local result = AutoCompleteFrame.Results[i]
			F.StripTextures(result, true)

			if not result.styled then
				local bg = F.CreateBDFrame(result, 0)
				bg:SetPoint("TOPLEFT", 0, -1)
				bg:SetPoint("BOTTOMRIGHT", 0, 1)

				reskinHL(result, bg)

				result.styled = true
			end
		end
	end)

	hooksecurefunc("LFGListSearchEntry_Update", function(self)
		local cancelButton = self.CancelButton
		if not cancelButton.styled then
			F.ReskinDecline(cancelButton)

			cancelButton.styled = true
		end
	end)

	-- [[ Application viewer ]]
	local ApplicationViewer = LFGListFrame.ApplicationViewer
	F.StripTextures(ApplicationViewer, true)
	F.StripTextures(ApplicationViewer, true)

	for _, headerName in pairs({"NameColumnHeader", "RoleColumnHeader", "ItemLevelColumnHeader"}) do
		local header = ApplicationViewer[headerName]
		F.StripTextures(header)

		local bg = F.CreateBDFrame(header, 0)
		bg:SetPoint("TOPLEFT", C.mult, -C.mult)
		bg:SetPoint("BOTTOMRIGHT", -C.mult, C.mult)
	end

	hooksecurefunc("LFGListApplicationViewer_UpdateApplicant", function(button)
		if not button.styled then
			F.ReskinDecline(button.DeclineButton)
			F.ReskinButton(button.InviteButton)

			button.styled = true
		end
	end)

	local ucbg = ApplicationViewer.UnempoweredCover.Background
	ucbg:SetPoint("TOPLEFT", 2, 0)
	ucbg:SetPoint("BOTTOMRIGHT", 1, -1)

	ApplicationViewer.RoleColumnHeader:SetPoint("LEFT", ApplicationViewer.NameColumnHeader, "RIGHT", 1, 0)
	ApplicationViewer.ItemLevelColumnHeader:SetPoint("LEFT", ApplicationViewer.RoleColumnHeader, "RIGHT", 1, 0)

	F.ReskinButton(ApplicationViewer.RefreshButton)
	F.ReskinButton(ApplicationViewer.RemoveEntryButton)
	F.ReskinButton(ApplicationViewer.EditButton)
	F.ReskinScroll(LFGListApplicationViewerScrollFrameScrollBar)

	ApplicationViewer.RefreshButton:SetSize(24, 24)
	ApplicationViewer.RefreshButton.Icon:SetPoint("CENTER")

	-- [[ Entry creation ]]
	local EntryCreation = LFGListFrame.EntryCreation
	F.StripTextures(EntryCreation, true)
	F.StripTextures(LFGListCreationDescription, true)
	F.CreateBDFrame(EntryCreation.Description, 0)

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

	-- Activity finder

	local ActivityFinder = EntryCreation.ActivityFinder

	ActivityFinder.Background:SetTexture("")
	ActivityFinder.Dialog.Bg:Hide()
	F.StripTextures(ActivityFinder.Dialog.BorderFrame)
	F.CreateBD(ActivityFinder.Dialog)
	ActivityFinder.Dialog:SetBackdropColor(.2, .2, .2, .9)
	F.ReskinButton(ActivityFinder.Dialog.SelectButton)
	F.ReskinButton(ActivityFinder.Dialog.CancelButton)
	F.ReskinInput(ActivityFinder.Dialog.EntryBox)
	F.ReskinScroll(LFGListEntryCreationSearchScrollFrameScrollBar)

	-- [[ Application dialog ]]

	F.ReskinFrame(LFGListApplicationDialog, true)
	F.StripTextures(LFGListApplicationDialog.Description, true)
	F.CreateBDFrame(LFGListApplicationDialog.Description, 0)
	F.ReskinButton(LFGListApplicationDialog.SignUpButton)
	F.ReskinButton(LFGListApplicationDialog.CancelButton)

	-- [[ Invite dialog ]]
	F.ReskinFrame(LFGListInviteDialog, true)
	F.ReskinButton(LFGListInviteDialog.AcceptButton)
	F.ReskinButton(LFGListInviteDialog.DeclineButton)
	F.ReskinButton(LFGListInviteDialog.AcknowledgeButton)
	local roleIcon = LFGListInviteDialog.RoleIcon
	F.ReskinRoleIcon(roleIcon)

	hooksecurefunc("LFGListInviteDialog_Show", function(self, resultID)
		local role = select(5, C_LFGList.GetApplicationInfo(resultID))
		self.RoleIcon:SetTexCoord(F.GetRoleTexCoord(role))
	end)
end)