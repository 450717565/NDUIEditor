local F, C = unpack(select(2, ...))

C.themes["Blizzard_Communities"] = function()
	local r, g, b = C.r, C.g, C.b
	local CommunitiesFrame = CommunitiesFrame

	F.ReskinFrame(CommunitiesFrame)
	CommunitiesFrame.PortraitOverlay:SetAlpha(0)
	F.ReskinDropDown(CommunitiesFrame.StreamDropDownMenu)
	F.ReskinMinMax(CommunitiesFrame.MaximizeMinimizeFrame)
	F.ReskinArrow(CommunitiesFrame.AddToChatButton, "down")
	F.ReskinDropDown(CommunitiesFrame.CommunitiesListDropDownMenu)

	for _, name in next, {"GuildFinderFrame", "InvitationFrame", "TicketFrame"} do
		local frame = CommunitiesFrame[name]
		F.StripTextures(frame, true)
		F.CreateBDFrame(frame, .25)
		if frame.CircleMask then
			frame.CircleMask:Hide()
			F.ReskinIcon(frame.Icon, true)
		end
		if frame.FindAGuildButton then F.ReskinButton(frame.FindAGuildButton) end
		if frame.AcceptButton then F.ReskinButton(frame.AcceptButton) end
		if frame.DeclineButton then F.ReskinButton(frame.DeclineButton) end
	end

	F.StripTextures(CommunitiesFrameCommunitiesList, true)
	F.ReskinScroll(CommunitiesFrameCommunitiesListListScrollFrame.ScrollBar)
	CommunitiesFrameCommunitiesListListScrollFrame.ScrollBar.Background:Hide()

	hooksecurefunc(CommunitiesFrameCommunitiesList, "Update", function(self)
		local buttons = self.ListScrollFrame.buttons
		for i = 1, #buttons do
			local button = buttons[i]
			if not button.bg then
				button:GetRegions():Hide()
				button.Selection:SetAlpha(0)
				button:SetHighlightTexture("")
				button.bg = F.CreateBDFrame(button, 0)
				button.bg:SetPoint("TOPLEFT", 5, -5)
				button.bg:SetPoint("BOTTOMRIGHT", -10, 5)
				F.CreateGradient(button.bg)
			end

			if button.Selection:IsShown() then
				button.bg:SetBackdropColor(r, g, b, .25)
			else
				button.bg:SetBackdropColor(0, 0, 0, 0)
			end
		end
	end)

	for _, name in next, {"ChatTab", "RosterTab", "GuildBenefitsTab", "GuildInfoTab"} do
		local tab = CommunitiesFrame[name]
		tab:SetSize(34, 34)
		tab:GetRegions():Hide()
		tab:SetCheckedTexture(C.media.checked)

		local bg = F.ReskinIcon(tab.Icon, true)
		F.ReskinTexture(tab, bg, false)
	end
	local p1, p2, p3, x, y = CommunitiesFrame.ChatTab:GetPoint()
	CommunitiesFrame.ChatTab:ClearAllPoints()
	CommunitiesFrame.ChatTab:SetPoint(p1, p2, p3, x+2, y)

	-- ChatTab
	F.ReskinButton(CommunitiesFrame.InviteButton)
	F.StripTextures(CommunitiesFrame.Chat, true)
	F.ReskinScroll(CommunitiesFrame.Chat.MessageFrame.ScrollBar)
	F.StripTextures(CommunitiesFrame.ChatEditBox, true)
	local bg1 = F.CreateBDFrame(CommunitiesFrame.Chat.InsetFrame, .25)
	bg1:SetPoint("BOTTOMRIGHT", -1, 22)
	local bg2 = F.CreateBDFrame(CommunitiesFrame.ChatEditBox, 0)
	F.CreateGradient(bg2)
	bg2:SetPoint("TOPLEFT", -2, -5)
	bg2:SetPoint("BOTTOMRIGHT", 2, 5)

	do
		local dialog = CommunitiesFrame.NotificationSettingsDialog
		dialog.BG:Hide()
		F.ReskinFrame(dialog)
		F.ReskinDropDown(dialog.CommunitiesListDropDownMenu)
		F.ReskinButton(dialog.OkayButton)
		F.ReskinButton(dialog.CancelButton)
		F.ReskinCheck(dialog.ScrollFrame.Child.QuickJoinButton)
		dialog.ScrollFrame.Child.QuickJoinButton:SetSize(25, 25)
		F.ReskinButton(dialog.ScrollFrame.Child.AllButton)
		F.ReskinButton(dialog.ScrollFrame.Child.NoneButton)
		F.ReskinScroll(dialog.ScrollFrame.ScrollBar)

		hooksecurefunc(dialog, "Refresh", function(self)
			local frame = self.ScrollFrame.Child
			for i = 1, frame:GetNumChildren() do
				local child = select(i, frame:GetChildren())
				if child.StreamName and not child.styled then
					F.ReskinRadio(child.ShowNotificationsButton)
					F.ReskinRadio(child.HideNotificationsButton)
					child.Separator:Hide()

					child.styled = true
				end
			end
		end)
	end

	do
		local dialog = CommunitiesFrame.EditStreamDialog
		F.ReskinFrame(dialog)
		F.StripTextures(dialog.NameEdit, true)
		local bg = F.CreateBDFrame(dialog.NameEdit, .25)
		bg:SetPoint("TOPLEFT", -3, -3)
		bg:SetPoint("BOTTOMRIGHT", -4, 3)
		F.StripTextures(dialog.Description, true)
		F.CreateBDFrame(dialog.Description, .25)
		F.ReskinCheck(dialog.TypeCheckBox)
		F.ReskinButton(dialog.Accept)
		F.ReskinButton(dialog.Delete)
		F.ReskinButton(dialog.Cancel)
	end

	do
		local dialog = CommunitiesTicketManagerDialog
		F.ReskinFrame(dialog)
		dialog.Background:Hide()
		F.ReskinButton(dialog.LinkToChat)
		F.ReskinButton(dialog.Copy)
		F.ReskinButton(dialog.Close)
		F.ReskinArrow(dialog.MaximizeButton, "down")
		F.ReskinDropDown(dialog.ExpiresDropDownMenu)
		F.ReskinDropDown(dialog.UsesDropDownMenu)
		F.ReskinButton(dialog.GenerateLinkButton)

		dialog.InviteManager.ArtOverlay:Hide()
		F.StripTextures(dialog.InviteManager.ColumnDisplay, true)
		dialog.InviteManager.ListScrollFrame.Background:Hide()
		F.ReskinScroll(dialog.InviteManager.ListScrollFrame.scrollBar)
		dialog.InviteManager.ListScrollFrame.scrollBar.Background:Hide()

		hooksecurefunc(dialog, "Update", function(self)
			local column = self.InviteManager.ColumnDisplay
			for i = 1, column:GetNumChildren() do
				local child = select(i, column:GetChildren())
				if not child.styled then
					F.StripTextures(child, true)
					F.CreateBDFrame(child, .25)

					child.styled = true
				end
			end

			local buttons = self.InviteManager.ListScrollFrame.buttons
			for i = 1, #buttons do
				local button = buttons[i]
				if not button.styled then
					F.ReskinButton(button.CopyLinkButton)
					button.CopyLinkButton.Background:Hide()
					F.ReskinButton(button.RevokeButton)
					button.RevokeButton:SetSize(18, 18)

					button.styled = true
				end
			end
		end)
	end

	-- Roster
	F.StripTextures(CommunitiesFrame.MemberList, true)
	F.CreateBDFrame(CommunitiesFrame.MemberList.ListScrollFrame, .25)
	F.StripTextures(CommunitiesFrame.MemberList.ColumnDisplay, true)
	F.ReskinDropDown(CommunitiesFrame.GuildMemberListDropDownMenu)
	F.ReskinScroll(CommunitiesFrame.MemberList.ListScrollFrame.scrollBar)
	CommunitiesFrame.MemberList.ListScrollFrame.scrollBar.Background:Hide()
	F.ReskinCheck(CommunitiesFrame.MemberList.ShowOfflineButton)
	CommunitiesFrame.MemberList.ShowOfflineButton:SetSize(25, 25)
	F.ReskinButton(CommunitiesFrame.CommunitiesControlFrame.GuildControlButton)
	F.ReskinButton(CommunitiesFrame.CommunitiesControlFrame.GuildRecruitmentButton)
	F.ReskinButton(CommunitiesFrame.CommunitiesControlFrame.CommunitiesSettingsButton)

	local detailFrame = CommunitiesFrame.GuildMemberDetailFrame
	F.ReskinFrame(detailFrame)
	detailFrame.BackBackground:Hide()
	F.ReskinButton(detailFrame.RemoveButton)
	F.ReskinButton(detailFrame.GroupInviteButton)
	F.ReskinDropDown(detailFrame.RankDropdown)
	F.StripTextures(detailFrame.NoteBackground, true)
	F.CreateBDFrame(detailFrame.NoteBackground, .25)
	F.StripTextures(detailFrame.OfficerNoteBackground, true)
	F.CreateBDFrame(detailFrame.OfficerNoteBackground, .25)
	detailFrame:ClearAllPoints()
	detailFrame:SetPoint("TOPLEFT", CommunitiesFrame, "TOPRIGHT", 34, 0)

	do
		local dialog = CommunitiesSettingsDialog
		F.ReskinFrame(dialog)
		F.ReskinButton(dialog.ChangeAvatarButton)
		F.ReskinButton(dialog.Accept)
		F.ReskinButton(dialog.Delete)
		F.ReskinButton(dialog.Cancel)
		F.ReskinInput(dialog.NameEdit)
		F.ReskinInput(dialog.ShortNameEdit)
		F.StripTextures(dialog.Description, true)
		F.CreateBDFrame(dialog.Description, .25)
		F.StripTextures(dialog.MessageOfTheDay, true)
		F.CreateBDFrame(dialog.MessageOfTheDay, .25)
	end

	do
		local dialog = CommunitiesAvatarPickerDialog
		F.ReskinFrame(dialog)
		CommunitiesAvatarPickerDialogTop:Hide()
		CommunitiesAvatarPickerDialogMiddle:Hide()
		CommunitiesAvatarPickerDialogBottom:Hide()
		F.ReskinScroll(CommunitiesAvatarPickerDialogScrollBar)
		F.ReskinButton(dialog.OkayButton)
		F.ReskinButton(dialog.CancelButton)

		hooksecurefunc(CommunitiesAvatarPickerDialog.ScrollFrame, "Refresh", function(self)
			for i = 1, 5 do
				for j = 1, 6 do
					local avatarButton = self.avatarButtons[i][j]
					if avatarButton:IsShown() and not avatarButton.bg then
						avatarButton.bg = F.ReskinIcon(avatarButton.Icon)
						avatarButton.Selected:SetTexture("")
						avatarButton:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)
					end

					if avatarButton.Selected:IsShown() then
						avatarButton.bg:SetVertexColor(r, g, b)
					else
						avatarButton.bg:SetVertexColor(0, 0, 0)
					end
				end
			end
		end)
	end

	local function updateNameFrame(self)
		if not self.expanded then return end
		if not self.bg then
			self.bg = F.CreateBDFrame(self.Class, .25)
		end
		local memberInfo = self:GetMemberInfo()
		if memberInfo and memberInfo.classID then
			local classInfo = C_CreatureInfo.GetClassInfo(memberInfo.classID)
			if classInfo then
				local tcoords = CLASS_ICON_TCOORDS[classInfo.classFile]
				self.Class:SetTexCoord(tcoords[1] + .022, tcoords[2] - .025, tcoords[3] + .022, tcoords[4] - .025)
			end
		end
	end

	hooksecurefunc(CommunitiesFrame.MemberList, "RefreshListDisplay", function(self)
		for i = 1, self.ColumnDisplay:GetNumChildren() do
			local child = select(i, self.ColumnDisplay:GetChildren())
			if not child.styled then
				F.StripTextures(child, true)
				local bg = F.CreateBDFrame(child, .25)
				bg:SetPoint("TOPLEFT", 4, -2)
				bg:SetPoint("BOTTOMRIGHT", 0, 2)

				child.styled = true
			end
		end

		for _, button in ipairs(self.ListScrollFrame.buttons or {}) do
			if button and not button.hooked then
				hooksecurefunc(button, "RefreshExpandedColumns", updateNameFrame)
				if button.ProfessionHeader then
					local header = button.ProfessionHeader
					for i = 1, 3 do
						select(i, header:GetRegions()):Hide()
					end
					local bg = F.CreateBDFrame(header, .45)
					F.ReskinTexture(header, bg, true)
					F.CreateBDFrame(header.Icon, .25)
				end

				button.hooked = true
			end
			if button and button.bg then
				button.bg:SetShown(button.Class:IsShown())
			end
		end
	end)

	-- Benefits
	CommunitiesFrame.GuildBenefitsFrame.Perks:GetRegions():SetAlpha(0)
	CommunitiesFrame.GuildBenefitsFrame.Rewards.Bg:SetAlpha(0)
	F.StripTextures(CommunitiesFrame.GuildBenefitsFrame, true)
	F.ReskinScroll(CommunitiesFrameRewards.scrollBar)

	local factionFrameBar = CommunitiesFrame.GuildBenefitsFrame.FactionFrame.Bar
	F.StripTextures(factionFrameBar, true)
	F.CreateBDFrame(factionFrameBar.Progress, .25)
	factionFrameBar.Progress:SetTexture(C.media.normTex)
	factionFrameBar.Progress:SetVertexColor(r*.8, g*.8, b*.8)

	hooksecurefunc("CommunitiesGuildPerks_Update", function(self)
		local buttons = self.Container.buttons
		for i = 1, #buttons do
			local button = buttons[i]
			if button and button:IsShown() and not button.bg then
				for i = 1, 4 do
					select(i, button:GetRegions()):SetAlpha(0)
				end

				local ic = F.ReskinIcon(button.Icon, true)
				button.bg = F.CreateBDFrame(button, .25)
				button.bg:SetPoint("TOPLEFT", ic, "TOPRIGHT", 2, 0)
				button.bg:SetPoint("BOTTOMRIGHT", 0, 1)
				F.ReskinTexture(button, button.bg, true)
			end
		end
	end)

	hooksecurefunc("CommunitiesGuildRewards_Update", function(self)
		local buttons = self.RewardsContainer.buttons
		for i = 1, #buttons do
			local button = buttons[i]
			if button then
				if not button.bg then
					button.bg = F.CreateBDFrame(button, .25)
					button.bg:SetPoint("TOPLEFT", C.mult, -C.mult)
					button.bg:SetPoint("BOTTOMRIGHT", -C.mult, C.mult)

					F.ReskinTexture(button, button.bg, true)
					F.ReskinIcon(button.Icon, true)
				end
				button:SetNormalTexture("")
				button.DisabledBG:Hide()
			end
		end
	end)

	-- Guild Info
	F.ReskinButton(CommunitiesFrame.GuildLogButton)
	F.StripTextures(CommunitiesFrameGuildDetailsFrameInfo, true)
	F.StripTextures(CommunitiesFrameGuildDetailsFrameNews, true)
	CommunitiesFrameGuildDetailsFrameInfoMOTDScrollFrameScrollBar:SetAlpha(0)
	local bg3 = F.CreateBDFrame(CommunitiesFrameGuildDetailsFrameInfoMOTDScrollFrame, .25)
	bg3:SetPoint("TOPLEFT", 0, 3)
	bg3:SetPoint("BOTTOMRIGHT", -5, -4)

	F.ReskinFrame(CommunitiesGuildTextEditFrame)
	CommunitiesGuildTextEditFrameBg:Hide()
	F.StripTextures(CommunitiesGuildTextEditFrame.Container, true)
	F.CreateBDFrame(CommunitiesGuildTextEditFrame.Container, .25)
	F.ReskinScroll(CommunitiesGuildTextEditFrameScrollBar)
	F.ReskinButton(CommunitiesGuildTextEditFrameAcceptButton)
	local closeButton = select(4, CommunitiesGuildTextEditFrame:GetChildren())
	F.ReskinButton(closeButton)

	F.ReskinScroll(CommunitiesFrameGuildDetailsFrameInfoScrollBar)
	F.CreateBDFrame(CommunitiesFrameGuildDetailsFrameInfo.DetailsFrame, .25)
	F.ReskinScroll(CommunitiesFrameGuildDetailsFrameNewsContainer.ScrollBar)
	F.StripTextures(CommunitiesFrameGuildDetailsFrame, true)

	hooksecurefunc("CommunitiesGuildNewsButton_SetNews", function(button)
		if button.header:IsShown() then
			button.header:SetAlpha(0)
		end
	end)

	CommunitiesGuildNewsFiltersFrameBg:Hide()
	F.ReskinFrame(CommunitiesGuildNewsFiltersFrame)
	for _, name in next, {"GuildAchievement", "Achievement", "DungeonEncounter", "EpicItemLooted", "EpicItemPurchased", "EpicItemCrafted", "LegendaryItemLooted"} do
		local filter = CommunitiesGuildNewsFiltersFrame[name]
		F.ReskinCheck(filter)
	end

	F.ReskinFrame(CommunitiesGuildLogFrame)
	F.ReskinScroll(CommunitiesGuildLogFrameScrollBar)
	F.StripTextures(CommunitiesGuildLogFrame.Container, true)
	F.CreateBDFrame(CommunitiesGuildLogFrame.Container, .25)
	local closeButton = select(3, CommunitiesGuildLogFrame:GetChildren())
	F.ReskinButton(closeButton)
end