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
	F.StripTextures(CategorySelection.Inset, true)
	F.Reskin(CategorySelection.FindGroupButton)
	F.Reskin(CategorySelection.StartGroupButton)

	hooksecurefunc("LFGListCategorySelection_AddButton", function(self, btnIndex)
		local bu = self.CategoryButtons[btnIndex]

		if bu and not bu.styled then
			bu.Cover:Hide()
			bu.Icon:SetTexCoord(.01, .99, .01, .99)
			F.CreateBDFrame(bu.Icon, .25)

			bu.styled = true
		end
	end)

	-- [[ Nothing available ]]
	local NothingAvailable = LFGListFrame.NothingAvailable
	F.StripTextures(NothingAvailable.Inset, true)

	-- [[ Search panel ]]
	local SearchPanel = LFGListFrame.SearchPanel
	F.StripTextures(SearchPanel.ResultsInset, true)
	F.StripTextures(SearchPanel.AutoCompleteFrame, true)
	F.Reskin(SearchPanel.RefreshButton)
	F.Reskin(SearchPanel.BackButton)
	F.Reskin(SearchPanel.SignUpButton)
	F.Reskin(SearchPanel.ScrollFrame.StartGroupButton)
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
				local bg = F.CreateBDFrame(result, .25)
				bg:SetPoint("TOPLEFT", C.mult, -C.mult)
				bg:SetPoint("BOTTOMRIGHT", -C.mult, C.mult)

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
	F.StripTextures(ApplicationViewer.Inset, true)

	for _, headerName in next, {"NameColumnHeader", "RoleColumnHeader", "ItemLevelColumnHeader"} do
		local header = ApplicationViewer[headerName]
		F.StripTextures(header)

		local bg = F.CreateBDFrame(header, .25)
		bg:SetPoint("TOPLEFT", C.mult, -C.mult)
		bg:SetPoint("BOTTOMRIGHT", -C.mult, C.mult)

		reskinHL(header, bg)
	end

	hooksecurefunc("LFGListApplicationViewer_UpdateApplicant", function(button)
		if not button.styled then
			F.ReskinDecline(button.DeclineButton)
			F.Reskin(button.InviteButton)

			button.styled = true
		end
	end)

	local ucbg = ApplicationViewer.UnempoweredCover.Background
	ucbg:SetPoint("TOPLEFT", 2, 0)
	ucbg:SetPoint("BOTTOMRIGHT", 1, -1)

	ApplicationViewer.RoleColumnHeader:SetPoint("LEFT", ApplicationViewer.NameColumnHeader, "RIGHT", 1, 0)
	ApplicationViewer.ItemLevelColumnHeader:SetPoint("LEFT", ApplicationViewer.RoleColumnHeader, "RIGHT", 1, 0)

	F.Reskin(ApplicationViewer.RefreshButton)
	F.Reskin(ApplicationViewer.RemoveEntryButton)
	F.Reskin(ApplicationViewer.EditButton)
	F.ReskinScroll(LFGListApplicationViewerScrollFrameScrollBar)

	ApplicationViewer.RefreshButton:SetSize(24, 24)
	ApplicationViewer.RefreshButton.Icon:SetPoint("CENTER")

	-- [[ Entry creation ]]
	local EntryCreation = LFGListFrame.EntryCreation
	F.StripTextures(EntryCreation.Inset, true)
	F.StripTextures(LFGListCreationDescription, true)

	local bg = F.CreateBDFrame(EntryCreation.Description, .25)
	F.CreateGradient(bg)

	F.Reskin(EntryCreation.ListGroupButton)
	F.Reskin(EntryCreation.CancelButton)
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

	-- [[ Application dialog ]]
	F.StripTextures(LFGListApplicationDialog.Description, true)
	F.CreateBD(LFGListApplicationDialog)
	F.CreateSD(LFGListApplicationDialog)
	F.CreateBDFrame(LFGListApplicationDialog.Description, .25)
	F.Reskin(LFGListApplicationDialog.SignUpButton)
	F.Reskin(LFGListApplicationDialog.CancelButton)

	-- [[ Invite dialog ]]
	F.CreateBD(LFGListInviteDialog)
	F.CreateSD(LFGListInviteDialog)
	F.Reskin(LFGListInviteDialog.AcceptButton)
	F.Reskin(LFGListInviteDialog.DeclineButton)
	F.Reskin(LFGListInviteDialog.AcknowledgeButton)
end)