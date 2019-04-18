local F, C = unpack(select(2, ...))

C.themes["Blizzard_Communities"] = function()
	local cr, cg, cb = C.r, C.g, C.b

	CommunitiesFrame.PortraitOverlay:SetAlpha(0)
	F.ReskinFrame(CommunitiesFrame)

	F.ReskinButton(CommunitiesFrame.InviteButton)
	F.ReskinButton(CommunitiesFrame.GuildLogButton)
	F.ReskinButton(CommunitiesFrame.CommunitiesControlFrame.GuildControlButton)
	F.ReskinButton(CommunitiesFrame.CommunitiesControlFrame.GuildRecruitmentButton)
	F.ReskinButton(CommunitiesFrame.CommunitiesControlFrame.CommunitiesSettingsButton)

	F.ReskinMinMax(CommunitiesFrame.MaximizeMinimizeFrame)
	F.ReskinDropDown(CommunitiesFrame.CommunitiesListDropDownMenu)
	F.ReskinScroll(CommunitiesFrameCommunitiesListListScrollFrame.ScrollBar)

	local AddToChatButton = CommunitiesFrame.AddToChatButton
	AddToChatButton:ClearAllPoints()
	AddToChatButton:SetPoint("TOPRIGHT", CommunitiesFrame.ChatEditBox, "BOTTOMRIGHT", 0, -2)
	F.ReskinArrow(AddToChatButton, "down")

	local GuildMemberDetailFrame = CommunitiesFrame.GuildMemberDetailFrame
	F.ReskinFrame(GuildMemberDetailFrame)
	F.ReskinButton(GuildMemberDetailFrame.RemoveButton)
	F.ReskinButton(GuildMemberDetailFrame.GroupInviteButton)
	F.ReskinDropDown(GuildMemberDetailFrame.RankDropdown)
	F.StripTextures(GuildMemberDetailFrame.NoteBackground)
	F.CreateBDFrame(GuildMemberDetailFrame.NoteBackground, 0)
	F.StripTextures(GuildMemberDetailFrame.OfficerNoteBackground)
	F.CreateBDFrame(GuildMemberDetailFrame.OfficerNoteBackground, 0)
	GuildMemberDetailFrame:ClearAllPoints()
	GuildMemberDetailFrame:SetPoint("TOPLEFT", CommunitiesFrame.ChatTab, "TOPRIGHT", 2, 0)

	for _, name in pairs({"GuildFinderFrame", "InvitationFrame", "TicketFrame"}) do
		local frame = CommunitiesFrame[name]
		F.StripTextures(frame.InsetFrame)
		F.CreateBDFrame(frame, 0)

		if frame.FindAGuildButton then F.ReskinButton(frame.FindAGuildButton) end
		if frame.AcceptButton then F.ReskinButton(frame.AcceptButton) end
		if frame.DeclineButton then F.ReskinButton(frame.DeclineButton) end

		if C.isNewPatch then
			local optionsList = frame.OptionsList
			if optionsList then
				F.ReskinDropDown(optionsList.ClubFocusDropdown)
				optionsList.ClubFocusDropdown.GuildFocusDropdownLabel:SetWidth(150)
				F.ReskinDropDown(optionsList.ClubSizeDropdown)
				F.ReskinRole(optionsList.TankRoleFrame, "TANK")
				F.ReskinRole(optionsList.HealerRoleFrame, "HEALER")
				F.ReskinRole(optionsList.DpsRoleFrame, "DPS")
				F.ReskinInput(optionsList.SearchBox)
				optionsList.SearchBox:SetSize(118, 22)
				F.ReskinButton(optionsList.Search)
				optionsList.Search:ClearAllPoints()
				optionsList.Search:SetPoint("TOPRIGHT", optionsList.SearchBox, "BOTTOMRIGHT", 0, -2)
				F.ReskinButton(frame.PendingClubs)
			end
		end
	end

	CommunitiesFrame.ChatTab:ClearAllPoints()
	CommunitiesFrame.ChatTab:SetPoint("TOPLEFT", CommunitiesFrame, "TOPRIGHT", 0, -25)
	for _, name in pairs({"ChatTab", "RosterTab", "GuildBenefitsTab", "GuildInfoTab"}) do
		local tab = CommunitiesFrame[name]
		tab:SetSize(34, 34)
		tab:GetRegions():Hide()

		local bg = F.ReskinIcon(tab.Icon)
		F.ReskinTexture(tab, bg, false)
		F.ReskinTexed(tab, bg)
	end

	F.StripTextures(CommunitiesFrameCommunitiesList)
	hooksecurefunc(CommunitiesFrameCommunitiesList, "Update", function(self)
		local buttons = self.ListScrollFrame.buttons
		for i = 1, #buttons do
			local button = buttons[i]
			if not button.bg then
				F.CleanTextures(button)
				button:GetRegions():Hide()
				button.Selection:SetAlpha(0)

				button.bg = F.CreateBDFrame(button, 0)
				button.bg:SetPoint("TOPLEFT", 5, -5)
				button.bg:SetPoint("BOTTOMRIGHT", -10, 5)
			end

			if button.Selection:IsShown() then
				button.bg:SetBackdropColor(cr, cg, cb, .25)
			else
				button.bg:SetBackdropColor(0, 0, 0, 0)
			end
		end
	end)

	-- ChatTab
	F.ReskinDropDown(CommunitiesFrame.StreamDropDownMenu)
	F.ReskinScroll(CommunitiesFrame.Chat.MessageFrame.ScrollBar)
	F.ReskinScroll(CommunitiesFrame.MemberList.ListScrollFrame.scrollBar)

	F.StripTextures(CommunitiesFrame.Chat)
	F.ReskinInput(CommunitiesFrame.ChatEditBox, 22)
	local chatbg = F.CreateBDFrame(CommunitiesFrame.Chat, 0)
	chatbg:SetPoint("TOPLEFT", -6, 5)
	chatbg:SetPoint("BOTTOMRIGHT", 3, -2)

	F.StripTextures(CommunitiesFrame.MemberList)
	F.CreateBDFrame(CommunitiesFrame.MemberList, 0)

	local EditStream = CommunitiesFrame.EditStreamDialog
	F.ReskinFrame(EditStream)
	F.ReskinCheck(EditStream.TypeCheckBox)
	F.ReskinButton(EditStream.Accept)
	F.ReskinButton(EditStream.Delete)
	F.ReskinButton(EditStream.Cancel)
	F.ReskinInput(EditStream.NameEdit, 22)
	F.StripTextures(EditStream.Description)
	F.CreateBDFrame(EditStream.Description, 0)

	local NotificationSettings = CommunitiesFrame.NotificationSettingsDialog
	NotificationSettings.ScrollFrame.Child.QuickJoinButton:SetSize(25, 25)

	F.ReskinFrame(NotificationSettings)
	F.ReskinDropDown(NotificationSettings.CommunitiesListDropDownMenu)
	F.ReskinButton(NotificationSettings.OkayButton)
	F.ReskinButton(NotificationSettings.CancelButton)
	F.ReskinCheck(NotificationSettings.ScrollFrame.Child.QuickJoinButton)

	F.ReskinButton(NotificationSettings.ScrollFrame.Child.AllButton)
	F.ReskinButton(NotificationSettings.ScrollFrame.Child.NoneButton)
	F.ReskinScroll(NotificationSettings.ScrollFrame.ScrollBar)

	hooksecurefunc(NotificationSettings, "Refresh", function(self)
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

	local TicketManager = CommunitiesTicketManagerDialog
	F.ReskinFrame(TicketManager)
	F.ReskinButton(TicketManager.LinkToChat)
	F.ReskinButton(TicketManager.Copy)
	F.ReskinButton(TicketManager.Close)
	F.ReskinArrow(TicketManager.MaximizeButton, "down")
	F.ReskinDropDown(TicketManager.ExpiresDropDownMenu)
	F.ReskinDropDown(TicketManager.UsesDropDownMenu)
	F.ReskinButton(TicketManager.GenerateLinkButton)

	TicketManager.InviteManager.ArtOverlay:Hide()
	F.StripTextures(TicketManager.InviteManager.ColumnDisplay)
	TicketManager.InviteManager.ListScrollFrame.Background:Hide()
	F.ReskinScroll(TicketManager.InviteManager.ListScrollFrame.scrollBar)
	TicketManager.InviteManager.ListScrollFrame.scrollBar.Background:Hide()

	hooksecurefunc(TicketManager, "Update", function(self)
		local column = self.InviteManager.ColumnDisplay
		for i = 1, column:GetNumChildren() do
			local child = select(i, column:GetChildren())
			if not child.styled then
				F.StripTextures(child)

				local bg = F.CreateBDFrame(child, 0)
				bg:SetPoint("TOPLEFT", 4, -2)
				bg:SetPoint("BOTTOMRIGHT", 0, 2)
				F.ReskinTexture(child, bg, true)

				child.styled = true
			end
		end

		local buttons = self.InviteManager.ListScrollFrame.buttons
		for i = 1, #buttons do
			local button = buttons[i]
			if not button.styled then
				F.ReskinButton(button.CopyLinkButton)
				F.ReskinButton(button.RevokeButton)
				button.RevokeButton:SetSize(18, 18)

				button.styled = true
			end
		end
	end)

	-- RosterTab
	CommunitiesFrame.MemberList.ShowOfflineButton:SetSize(25, 25)
	F.StripTextures(CommunitiesFrame.MemberList.ColumnDisplay)
	F.ReskinCheck(CommunitiesFrame.MemberList.ShowOfflineButton)
	F.ReskinDropDown(CommunitiesFrame.GuildMemberListDropDownMenu)

	local Settings = CommunitiesSettingsDialog
	F.ReskinFrame(Settings)
	F.ReskinButton(Settings.ChangeAvatarButton)
	F.ReskinButton(Settings.Accept)
	F.ReskinButton(Settings.Delete)
	F.ReskinButton(Settings.Cancel)
	F.ReskinInput(Settings.NameEdit)
	F.ReskinInput(Settings.ShortNameEdit)
	F.StripTextures(Settings.Description)
	F.CreateBDFrame(Settings.Description, 0)
	F.StripTextures(Settings.MessageOfTheDay)
	F.CreateBDFrame(Settings.MessageOfTheDay, 0)

	local AvatarPicker = CommunitiesAvatarPickerDialog
	F.ReskinFrame(AvatarPicker)
	F.ReskinScroll(CommunitiesAvatarPickerDialogScrollBar)
	F.ReskinButton(AvatarPicker.OkayButton)
	F.ReskinButton(AvatarPicker.CancelButton)

	hooksecurefunc(CommunitiesAvatarPickerDialog.ScrollFrame, "Refresh", function(self)
		for i = 1, 5 do
			for j = 1, 6 do
				local avatarButton = self.avatarButtons[i][j]
				if avatarButton:IsShown() and not avatarButton.styled then
					local icbg = F.ReskinIcon(avatarButton.Icon)
					F.ReskinTexture(avatarButton, icbg, false)
					F.ReskinTexture(avatarButton.Selected, icbg, false)

					avatarButton.styled = true
				end
			end
		end
	end)

	local function updateNameFrame(self)
		if not self.expanded then return end

		self:SetHighlightTexture(C.media.bdTex)
		self:GetHighlightTexture():SetColorTexture(cr, cg, cb, .25)

		if not self.bg then
			self.bg = F.ReskinIcon(self.Class, true)
		end

		local memberInfo = self:GetMemberInfo()
		if memberInfo and memberInfo.classID then
			local classInfo = C_CreatureInfo.GetClassInfo(memberInfo.classID)
			if classInfo then
				local tcoords = CLASS_ICON_TCOORDS[classInfo.classFile]
				self.Class:SetTexCoord(
					tcoords[1] + .022,
					tcoords[2] - .025,
					tcoords[3] + .022,
					tcoords[4] - .025
				)
			end
		end
	end

	hooksecurefunc(CommunitiesFrame.MemberList, "RefreshListDisplay", function(self)
		for i = 1, self.ColumnDisplay:GetNumChildren() do
			local child = select(i, self.ColumnDisplay:GetChildren())
			if not child.styled then
				F.StripTextures(child)

				local bg = F.CreateBDFrame(child, 0)
				bg:SetPoint("TOPLEFT", 4, -2)
				bg:SetPoint("BOTTOMRIGHT", 0, 2)
				F.ReskinTexture(child, bg, true)

				child.styled = true
			end
		end

		for _, button in pairs(self.ListScrollFrame.buttons or {}) do
			if button and not button.styled then
				hooksecurefunc(button, "RefreshExpandedColumns", updateNameFrame)
				if button.ProfessionHeader then
					local header = button.ProfessionHeader
					F.StripTextures(header)

					local bg = F.CreateBDFrame(header, 0)
					bg:SetPoint("TOPLEFT", -C.mult, -C.mult)
					bg:SetPoint("BOTTOMRIGHT", C.mult, C.mult)

					F.ReskinTexture(header, bg, true)
					F.ReskinIcon(header.Icon, true)
				end

				button.styled = true
			end
			if button and button.bg then button.bg:SetShown(button.Class:IsShown()) end
		end
	end)

	-- GuildBenefitsTab
	local GuildBenefitsFrame = CommunitiesFrame.GuildBenefitsFrame
	GuildBenefitsFrame.Perks:GetRegions():Hide()
	GuildBenefitsFrame.Rewards.Bg:Hide()
	F.StripTextures(GuildBenefitsFrame)
	F.ReskinScroll(CommunitiesFrameRewards.scrollBar)

	local factionFrameBar = GuildBenefitsFrame.FactionFrame.Bar
	F.StripTextures(factionFrameBar)
	F.CreateBDFrame(factionFrameBar.BG, 0)
	factionFrameBar.Progress:SetTexture(C.media.normTex)
	factionFrameBar.Progress:SetVertexColor(cr, cg, cb, .8)
	factionFrameBar.Label:ClearAllPoints()
	factionFrameBar.Label:SetPoint("CENTER", factionFrameBar.BG)

	hooksecurefunc("CommunitiesGuildPerks_Update", function(self)
		local buttons = self.Container.buttons
		for i = 1, #buttons do
			local button = buttons[i]
			if button and not button.styled then
				F.StripTextures(button)

				local icbg = F.ReskinIcon(button.Icon)
				local bubg = F.CreateBDFrame(button, 0)
				bubg:SetPoint("TOPLEFT", icbg, "TOPRIGHT", 2, 0)
				bubg:SetPoint("BOTTOMRIGHT", 0, 1)
				F.ReskinTexture(button, bubg, true)

				button.styled = true
			end
		end
	end)

	hooksecurefunc("CommunitiesGuildRewards_Update", function(self)
		local buttons = self.RewardsContainer.buttons
		for i = 1, #buttons do
			local button = buttons[i]
			if button and not button.styled then
				F.StripTextures(button)

				local bubg = F.CreateBDFrame(button, 0)
				bubg:SetPoint("TOPLEFT", C.mult, -C.mult)
				bubg:SetPoint("BOTTOMRIGHT", -C.mult, C.mult)

				F.ReskinTexture(button, bubg, true)
				F.ReskinIcon(button.Icon)

				button.styled = true
			end
		end
	end)

	-- GuildInfoTab
	F.StripTextures(CommunitiesFrameGuildDetailsFrame)
	F.StripTextures(CommunitiesFrameGuildDetailsFrameInfo)
	F.StripTextures(CommunitiesFrameGuildDetailsFrameNews)
	F.ReskinScroll(CommunitiesFrameGuildDetailsFrameNewsContainer.ScrollBar)

	F.ReskinFrame(CommunitiesGuildTextEditFrame)
	F.ReskinScroll(CommunitiesGuildTextEditFrameScrollBar)
	F.StripTextures(CommunitiesGuildTextEditFrame.Container)
	F.CreateBDFrame(CommunitiesGuildTextEditFrame.Container, 0)
	F.ReskinButton(CommunitiesGuildTextEditFrameAcceptButton)
	local TextEditFrameCB = select(4, CommunitiesGuildTextEditFrame:GetChildren())
	F.ReskinButton(TextEditFrameCB)

	F.CreateBDFrame(CommunitiesFrameGuildDetailsFrameInfo.DetailsFrame, 0)
	local bg = F.CreateBDFrame(CommunitiesFrameGuildDetailsFrameInfoMOTDScrollFrame, 0)
	bg:SetPoint("TOPLEFT", 0, 3)
	bg:SetPoint("BOTTOMRIGHT", -5, -4)

	F.ReskinFrame(CommunitiesGuildNewsFiltersFrame)
	for _, name in pairs({"GuildAchievement", "Achievement", "DungeonEncounter", "EpicItemLooted", "EpicItemPurchased", "EpicItemCrafted", "LegendaryItemLooted"}) do
		local filter = CommunitiesGuildNewsFiltersFrame[name]
		F.ReskinCheck(filter)
	end

	F.ReskinFrame(CommunitiesGuildLogFrame)
	F.ReskinScroll(CommunitiesGuildLogFrameScrollBar)
	F.StripTextures(CommunitiesGuildLogFrame.Container)
	F.CreateBDFrame(CommunitiesGuildLogFrame.Container, 0)
	local LogFrameCB = select(3, CommunitiesGuildLogFrame:GetChildren())
	F.ReskinButton(LogFrameCB)

	hooksecurefunc("CommunitiesGuildNewsButton_SetNews", function(button)
		if button.header:IsShown() then
			button.header:SetAlpha(0)
		end
	end)
end