local F, C = unpack(select(2, ...))

C.themes["Blizzard_Communities"] = function()
	local cr, cg, cb = C.r, C.g, C.b

	local function reskinCommunityTab(self)
		self:SetSize(34, 34)
		self:GetRegions():Hide()

		local bg = F.ReskinIcon(self.Icon)
		F.ReskinTexture(self, bg)
		F.ReskinTexed(self, bg)
	end

	local function reskinGuildCards(self)
		for _, name in pairs({"FirstCard", "SecondCard", "ThirdCard"}) do
			local guildCard = self[name]
			F.StripTextures(guildCard)
			F.CreateBDFrame(guildCard, 0)
			F.ReskinButton(guildCard.RequestJoin)
		end
		F.ReskinArrow(self.PreviousPage, "left")
		F.ReskinArrow(self.NextPage, "right")
	end

	local function reskinCommunityCards(self)
		for _, button in next, self.ListScrollFrame.buttons do
			button.CircleMask:Hide()
			button.LogoBorder:Hide()
			button.Background:Hide()
			F.ReskinButton(button)
			F.ReskinIcon(button.CommunityLogo)
		end
		F.ReskinScroll(self.ListScrollFrame.scrollBar)
	end

	local function reskinRequestCheckbox(self)
		for button in self.SpecsPool:EnumerateActive() do
			if button.CheckBox then
				F.ReskinCheck(button.CheckBox)
				button.CheckBox:SetSize(26, 26)
			end
		end
	end

	CommunitiesFrame.PortraitOverlay:SetAlpha(0)
	F.ReskinFrame(CommunitiesFrame)
	F.ReskinMinMax(CommunitiesFrame.MaximizeMinimizeFrame)
	F.ReskinDropDown(CommunitiesFrame.CommunitiesListDropDownMenu)

	CommunitiesFrame.ChatTab:ClearAllPoints()
	CommunitiesFrame.ChatTab:SetPoint("TOPLEFT", CommunitiesFrame, "TOPRIGHT", 2, -25)
	local tabs = {"ChatTab", "RosterTab", "GuildBenefitsTab", "GuildInfoTab"}
	for _, name in pairs(tabs) do
		local tab = CommunitiesFrame[name]
		reskinCommunityTab(tab)
	end

	F.StripTextures(CommunitiesFrameCommunitiesList)
	F.ReskinScroll(CommunitiesFrameCommunitiesListListScrollFrame.ScrollBar)
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

	local frames = {"ClubFinderInvitationFrame", "CommunityFinderFrame", "GuildFinderFrame", "InvitationFrame", "TicketFrame"}
	for _, name in pairs(frames) do
		local frame = CommunitiesFrame[name]
		if frame then
			F.StripTextures(frame)

			if frame.FindAGuildButton then F.ReskinButton(frame.FindAGuildButton) end
			if frame.AcceptButton then F.ReskinButton(frame.AcceptButton) end
			if frame.DeclineButton then F.ReskinButton(frame.DeclineButton) end

			local OptionsList = frame.OptionsList
			if OptionsList then
				F.ReskinDropDown(OptionsList.ClubFocusDropdown)
				F.ReskinDropDown(OptionsList.ClubSizeDropdown)
				F.ReskinDropDown(OptionsList.SortByDropdown)
				F.ReskinRole(OptionsList.TankRoleFrame, "TANK")
				F.ReskinRole(OptionsList.HealerRoleFrame, "HEALER")
				F.ReskinRole(OptionsList.DpsRoleFrame, "DPS")
				F.ReskinInput(OptionsList.SearchBox, 20)
				F.ReskinButton(OptionsList.Search)

				OptionsList.Search:ClearAllPoints()
				OptionsList.Search:SetPoint("TOPRIGHT", OptionsList.SearchBox, "BOTTOMRIGHT", 0, -2)
			end

			local RequestToJoinFrame = frame.RequestToJoinFrame
			if RequestToJoinFrame then
				F.ReskinFrame(RequestToJoinFrame)
				F.ReskinButton(RequestToJoinFrame.Apply)
				F.ReskinButton(RequestToJoinFrame.Cancel)
				F.StripTextures(RequestToJoinFrame.MessageFrame)
				F.ReskinInput(RequestToJoinFrame.MessageFrame.MessageScroll)
				hooksecurefunc(RequestToJoinFrame, "Initialize", reskinRequestCheckbox)
			end

			if frame.ClubFinderSearchTab then
				reskinCommunityTab(frame.ClubFinderSearchTab)
				frame.ClubFinderSearchTab:ClearAllPoints()
				frame.ClubFinderSearchTab:SetPoint("TOPLEFT", CommunitiesFrame, "TOPRIGHT", 2, -25)
			end
			if frame.ClubFinderPendingTab then reskinCommunityTab(frame.ClubFinderPendingTab) end
			if frame.GuildCards then reskinGuildCards(frame.GuildCards) end
			if frame.PendingGuildCards then reskinGuildCards(frame.PendingGuildCards) end
			if frame.CommunityCards then reskinCommunityCards(frame.CommunityCards) end
			if frame.PendingCommunityCards then reskinCommunityCards(frame.PendingCommunityCards) end
		end
	end

	local GuildMemberDetailFrame = CommunitiesFrame.GuildMemberDetailFrame
	F.ReskinFrame(GuildMemberDetailFrame)
	F.ReskinButton(GuildMemberDetailFrame.RemoveButton)
	F.ReskinButton(GuildMemberDetailFrame.GroupInviteButton)
	F.ReskinDropDown(GuildMemberDetailFrame.RankDropdown)
	F.ReskinInput(GuildMemberDetailFrame.NoteBackground)
	F.ReskinInput(GuildMemberDetailFrame.OfficerNoteBackground)
	GuildMemberDetailFrame:ClearAllPoints()
	GuildMemberDetailFrame:SetPoint("TOPLEFT", CommunitiesFrame.ChatTab, "TOPRIGHT", 2, -2)

	local MemberList = CommunitiesFrame.MemberList
	F.StripTextures(MemberList)
	F.CreateBDFrame(MemberList, 0)
	F.ReskinScroll(MemberList.ListScrollFrame.scrollBar)

	-- ChatTab
	F.ReskinDropDown(CommunitiesFrame.StreamDropDownMenu)
	F.ReskinArrow(CommunitiesFrame.AddToChatButton, "down")
	F.ReskinButton(CommunitiesFrame.InviteButton)
	F.ReskinButton(CommunitiesFrame.CommunitiesControlFrame.GuildRecruitmentButton)
	F.ReskinButton(CommunitiesFrame.CommunitiesControlFrame.CommunitiesSettingsButton)
	F.ReskinInput(CommunitiesFrame.ChatEditBox, 22)

	local Chat = CommunitiesFrame.Chat
	F.StripTextures(Chat)
	F.ReskinScroll(Chat.MessageFrame.ScrollBar)
	local chatbg = F.CreateBDFrame(Chat, 0)
	chatbg:SetPoint("TOPLEFT", -6, 5)
	chatbg:SetPoint("BOTTOMRIGHT", 3, -2)

	local EditStreamDialog = CommunitiesFrame.EditStreamDialog
	F.ReskinFrame(EditStreamDialog)
	F.ReskinCheck(EditStreamDialog.TypeCheckBox)
	F.ReskinButton(EditStreamDialog.Accept)
	F.ReskinButton(EditStreamDialog.Delete)
	F.ReskinButton(EditStreamDialog.Cancel)
	F.ReskinInput(EditStreamDialog.NameEdit, 22)
	F.ReskinInput(EditStreamDialog.Description)

	local NotificationSettingsDialog = CommunitiesFrame.NotificationSettingsDialog
	NotificationSettingsDialog.ScrollFrame.Child.QuickJoinButton:SetSize(25, 25)

	F.ReskinFrame(NotificationSettingsDialog)
	F.ReskinDropDown(NotificationSettingsDialog.CommunitiesListDropDownMenu)
	F.ReskinButton(NotificationSettingsDialog.OkayButton)
	F.ReskinButton(NotificationSettingsDialog.CancelButton)
	F.ReskinCheck(NotificationSettingsDialog.ScrollFrame.Child.QuickJoinButton)
	F.ReskinButton(NotificationSettingsDialog.ScrollFrame.Child.AllButton)
	F.ReskinButton(NotificationSettingsDialog.ScrollFrame.Child.NoneButton)
	F.ReskinScroll(NotificationSettingsDialog.ScrollFrame.ScrollBar)

	hooksecurefunc(NotificationSettingsDialog, "Refresh", function(self)
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

	local RecruitmentDialog = CommunitiesFrame.RecruitmentDialog
	F.ReskinFrame(RecruitmentDialog)
	F.ReskinCheck(RecruitmentDialog.ShouldListClub.Button)
	F.ReskinCheck(RecruitmentDialog.MaxLevelOnly.Button)
	F.ReskinCheck(RecruitmentDialog.MinIlvlOnly.Button)
	F.ReskinDropDown(RecruitmentDialog.ClubFocusDropdown)
	F.ReskinDropDown(RecruitmentDialog.LookingForDropdown)
	F.StripTextures(RecruitmentDialog.RecruitmentMessageFrame.RecruitmentMessageInput)
	F.ReskinInput(RecruitmentDialog.RecruitmentMessageFrame)
	F.ReskinInput(RecruitmentDialog.MinIlvlOnly.EditBox)
	F.ReskinButton(RecruitmentDialog.Accept)
	F.ReskinButton(RecruitmentDialog.Cancel)

	local SettingsDialog = CommunitiesSettingsDialog
	F.ReskinFrame(SettingsDialog, true)
	F.ReskinButton(SettingsDialog.ChangeAvatarButton)
	F.ReskinButton(SettingsDialog.Accept)
	F.ReskinButton(SettingsDialog.Delete)
	F.ReskinButton(SettingsDialog.Cancel)
	F.ReskinInput(SettingsDialog.NameEdit)
	F.ReskinInput(SettingsDialog.ShortNameEdit)
	F.ReskinInput(SettingsDialog.Description)
	F.ReskinInput(SettingsDialog.MessageOfTheDay)
	F.ReskinCheck(SettingsDialog.ShouldListClub.Button)
	F.ReskinCheck(SettingsDialog.AutoAcceptApplications.Button)
	F.ReskinCheck(SettingsDialog.MaxLevelOnly.Button)
	F.ReskinCheck(SettingsDialog.MinIlvlOnly.Button)
	F.ReskinInput(SettingsDialog.MinIlvlOnly.EditBox)
	F.ReskinDropDown(ClubFinderFocusDropdown)
	F.ReskinDropDown(ClubFinderLookingForDropdown)

	local AvatarPickerDialog = CommunitiesAvatarPickerDialog
	F.ReskinFrame(AvatarPickerDialog)
	F.ReskinScroll(CommunitiesAvatarPickerDialogScrollBar)
	F.ReskinButton(AvatarPickerDialog.OkayButton)
	F.ReskinButton(AvatarPickerDialog.CancelButton)

	hooksecurefunc(AvatarPickerDialog.ScrollFrame, "Refresh", function(self)
		for i = 1, 5 do
			for j = 1, 6 do
				local avatarButton = self.avatarButtons[i][j]
				if avatarButton:IsShown() and not avatarButton.styled then
					avatarButton.Selected:SetTexture("")

					avatarButton.bg = F.ReskinIcon(avatarButton.Icon)
					F.ReskinTexture(avatarButton, avatarButton.bg)

					avatarButton.styled = true
				end

				if avatarButton.Selected:IsShown() then
					avatarButton.bg:SetBackdropBorderColor(cr, cg, cb)
				else
					avatarButton.bg:SetBackdropBorderColor(0, 0, 0)
				end
			end
		end
	end)

	local TicketManagerDialog = CommunitiesTicketManagerDialog
	F.ReskinFrame(TicketManagerDialog, true)
	F.ReskinButton(TicketManagerDialog.LinkToChat)
	F.ReskinButton(TicketManagerDialog.Copy)
	F.ReskinButton(TicketManagerDialog.Close)
	F.ReskinArrow(TicketManagerDialog.MaximizeButton, "down")
	F.ReskinDropDown(TicketManagerDialog.ExpiresDropDownMenu)
	F.ReskinDropDown(TicketManagerDialog.UsesDropDownMenu)
	F.ReskinButton(TicketManagerDialog.GenerateLinkButton)

	TicketManagerDialog.InviteManager.ArtOverlay:Hide()
	F.StripTextures(TicketManagerDialog.InviteManager.ColumnDisplay)
	F.ReskinScroll(TicketManagerDialog.InviteManager.ListScrollFrame.scrollBar)

	hooksecurefunc(TicketManagerDialog, "Update", function(self)
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
	F.StripTextures(CommunitiesFrame.MemberList.ColumnDisplay)
	F.ReskinCheck(CommunitiesFrame.MemberList.ShowOfflineButton)
	F.ReskinDropDown(CommunitiesFrame.GuildMemberListDropDownMenu)
	F.ReskinButton(CommunitiesFrame.CommunitiesControlFrame.GuildControlButton)
	F.ReskinDropDown(CommunitiesFrame.CommunityMemberListDropDownMenu)

	local function updateNameFrame(self)
		if not self.expanded then return end

		self:SetHighlightTexture(C.media.bdTex)
		self:GetHighlightTexture():SetColorTexture(cr, cg, cb, .25)

		if not self.bg then
			self.bg = F.ReskinIcon(self.Class)
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
					F.ReskinIcon(header.Icon)
				end

				button.styled = true
			end

			if button and button.bg then
				button.bg:SetShown(button.Class:IsShown())
			end
		end
	end)

	-- GuildBenefitsTab
	local GuildBenefitsFrame = CommunitiesFrame.GuildBenefitsFrame
	F.StripTextures(GuildBenefitsFrame)
	F.StripTextures(GuildBenefitsFrame.Perks)
	F.StripTextures(GuildBenefitsFrame.Rewards)
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
				F.ReskinIcon(button.Icon)

				local bubg = F.CreateBDFrame(button, 0, -C.pixel)
				F.ReskinTexture(button, bubg, true)

				button.styled = true
			end
		end
	end)

	-- GuildInfoTab
	F.ReskinButton(CommunitiesFrame.GuildLogButton)
	F.StripTextures(CommunitiesFrameGuildDetailsFrame)
	F.StripTextures(CommunitiesFrameGuildDetailsFrameInfo)
	F.StripTextures(CommunitiesFrameGuildDetailsFrameNews)
	F.ReskinScroll(CommunitiesFrameGuildDetailsFrameInfoScrollBar)
	F.ReskinScroll(CommunitiesFrameGuildDetailsFrameNewsContainer.ScrollBar)
	F.ReskinScroll(CommunitiesFrameGuildDetailsFrameInfoMOTDScrollFrameScrollBar)

	F.ReskinFrame(CommunitiesGuildTextEditFrame)
	F.ReskinScroll(CommunitiesGuildTextEditFrameScrollBar)
	F.ReskinInput(CommunitiesGuildTextEditFrame.Container)
	F.ReskinButton(CommunitiesGuildTextEditFrameAcceptButton)
	local TextEditFrameCB = select(4, CommunitiesGuildTextEditFrame:GetChildren())
	F.ReskinButton(TextEditFrameCB)

	F.ReskinFrame(CommunitiesGuildLogFrame)
	F.ReskinScroll(CommunitiesGuildLogFrameScrollBar)
	F.ReskinInput(CommunitiesGuildLogFrame.Container)
	local LogFrameCB = select(3, CommunitiesGuildLogFrame:GetChildren())
	F.ReskinButton(LogFrameCB)

	F.CreateBDFrame(CommunitiesFrameGuildDetailsFrameInfo.DetailsFrame, 0)
	local bg = F.CreateBDFrame(CommunitiesFrameGuildDetailsFrameInfoMOTDScrollFrame, 0)
	bg:SetPoint("TOPLEFT", 0, 3)
	bg:SetPoint("BOTTOMRIGHT", 0, -4)

	local FiltersFrame = CommunitiesGuildNewsFiltersFrame
	F.ReskinFrame(FiltersFrame)

	FiltersFrame:HookScript("OnShow", function()
		FiltersFrame:ClearAllPoints()
		FiltersFrame:SetPoint("TOPLEFT", CommunitiesFrame.ChatTab, "TOPRIGHT", 2, -2)
	end)

	local filters = {"GuildAchievement", "Achievement", "DungeonEncounter", "EpicItemLooted", "EpicItemPurchased", "EpicItemCrafted", "LegendaryItemLooted"}
	for _, name in pairs(filters) do
		local filter = FiltersFrame[name]
		F.ReskinCheck(filter)
	end

	hooksecurefunc("GuildNewsButton_SetNews", function(button)
		if button.header:IsShown() then
			button.header:SetAlpha(0)
		end
	end)
end