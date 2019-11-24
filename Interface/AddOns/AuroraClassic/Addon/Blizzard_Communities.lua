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

	CommunitiesFrame.PortraitOverlay:SetAlpha(0)
	F.ReskinFrame(CommunitiesFrame)

	F.ReskinButton(CommunitiesFrame.InviteButton)
	F.ReskinButton(CommunitiesFrame.GuildLogButton)
	F.ReskinButton(CommunitiesFrame.CommunitiesControlFrame.GuildControlButton)
	F.ReskinButton(CommunitiesFrame.CommunitiesControlFrame.GuildRecruitmentButton)
	F.ReskinButton(CommunitiesFrame.CommunitiesControlFrame.CommunitiesSettingsButton)

	if C.isNewPatch then
		F.ReskinDropDown(CommunitiesFrame.CommunityMemberListDropDownMenu)
	end

	F.ReskinMinMax(CommunitiesFrame.MaximizeMinimizeFrame)
	F.ReskinDropDown(CommunitiesFrame.CommunitiesListDropDownMenu)
	F.ReskinScroll(CommunitiesFrameCommunitiesListListScrollFrame.ScrollBar)

	local AddToChatButton = CommunitiesFrame.AddToChatButton
	AddToChatButton:ClearAllPoints()
	AddToChatButton:SetPoint("RIGHT", CommunitiesFrame.CommunitiesControlFrame.CommunitiesSettingsButton, "LEFT", -2, 0)
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
	GuildMemberDetailFrame:SetPoint("TOPLEFT", CommunitiesFrame.ChatTab, "TOPRIGHT", 2, -2)

	for _, name in pairs({"GuildFinderFrame", "InvitationFrame", "TicketFrame", "CommunityFinderFrame"}) do
		local frame = CommunitiesFrame[name]
		if frame then
			F.StripTextures(frame.InsetFrame)
			F.CreateBDFrame(frame, 0)

			if frame.FindAGuildButton then F.ReskinButton(frame.FindAGuildButton) end
			if frame.AcceptButton then F.ReskinButton(frame.AcceptButton) end
			if frame.DeclineButton then F.ReskinButton(frame.DeclineButton) end
			if frame.ClubFinderPendingTab then reskinCommunityTab(frame.ClubFinderPendingTab) end
			if frame.ClubFinderSearchTab then
				reskinCommunityTab(frame.ClubFinderSearchTab)
				frame.ClubFinderSearchTab:ClearAllPoints()
				frame.ClubFinderSearchTab:SetPoint("TOPLEFT", CommunitiesFrame, "TOPRIGHT", 2, -25)
			end

			local OptionsList = frame.OptionsList
			if OptionsList then
				OptionsList.SearchBox:SetSize(118, 22)
				OptionsList.Search:ClearAllPoints()
				OptionsList.Search:SetPoint("TOPRIGHT", OptionsList.SearchBox, "BOTTOMRIGHT", 0, -2)

				--F.ReskinDropDown(OptionsList.ClubFocusDropdown)
				--F.ReskinDropDown(OptionsList.ClubSizeDropdown)
				--F.ReskinDropDown(OptionsList.SortByDropdown)
				F.ReskinRole(OptionsList.TankRoleFrame, "TANK")
				F.ReskinRole(OptionsList.HealerRoleFrame, "HEALER")
				F.ReskinRole(OptionsList.DpsRoleFrame, "DPS")
				F.ReskinInput(OptionsList.SearchBox)
				F.ReskinButton(OptionsList.Search)
			end
		end
	end

	for _, frame in ipairs({ClubFinderGuildFinderFrame.RequestToJoinFrame, ClubFinderCommunityAndGuildFinderFrame.RequestToJoinFrame}) do
		F.ReskinFrame(frame)
		F.ReskinButton(frame.Apply)
		F.ReskinButton(frame.Cancel)
		F.StripTextures(frame.MessageFrame)
		F.ReskinInput(frame.MessageFrame.MessageScroll)

		local parentFrame = frame:GetParent()
		local frameName = parentFrame.GetName and parentFrame:GetName()
		local ScrollBar = _G[frameName.."ScrollBar"]
		F.ReskinScroll(ScrollBar)
		local parent = ScrollBar:GetParent()
		ScrollBar:ClearAllPoints()
		ScrollBar:SetPoint("TOPRIGHT", parent, "TOPRIGHT", -4, -15)
		ScrollBar:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", -4, 15)

		hooksecurefunc(frame, "Initialize", function(self)
			for button in self.SpecsPool:EnumerateActive() do
				if button.CheckBox then
					F.ReskinCheck(button.CheckBox)
					button.CheckBox:SetSize(26, 26)
				end
			end
		end)
	end

	CommunitiesFrame.ChatTab:ClearAllPoints()
	CommunitiesFrame.ChatTab:SetPoint("TOPLEFT", CommunitiesFrame, "TOPRIGHT", 2, -25)
	for _, name in pairs({"ChatTab", "RosterTab", "GuildBenefitsTab", "GuildInfoTab"}) do
		local tab = CommunitiesFrame[name]
		reskinCommunityTab(tab)
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

	local CommunityCards = ClubFinderCommunityAndGuildFinderFrame.CommunityCards
	local scrollBar = CommunityCards.ListScrollFrame.scrollBar
	F.ReskinScroll(scrollBar)
	local parent = scrollBar:GetParent()
	scrollBar:ClearAllPoints()
	scrollBar:SetPoint("TOPRIGHT", parent, "TOPRIGHT", 0, -16)
	scrollBar:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", 0, 16)

	local GuildCards = ClubFinderGuildFinderFrame.GuildCards
	F.ReskinButton(GuildCards.FirstCard.RequestJoin)
	F.ReskinButton(GuildCards.SecondCard.RequestJoin)
	F.ReskinButton(GuildCards.ThirdCard.RequestJoin)
	F.ReskinArrow(GuildCards.PreviousPage, "left")
	F.ReskinArrow(GuildCards.NextPage, "right")

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
	F.ReskinScroll(TicketManager.InviteManager.ListScrollFrame.scrollBar)

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
					F.ReskinTexture(avatarButton, icbg)
					F.ReskinTexture(avatarButton.Selected, icbg)

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
				F.ReskinIcon(button.Icon)

				local bubg = F.CreateBDFrame(button, 0, -C.mult)
				F.ReskinTexture(button, bubg, true)

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
	bg:SetPoint("BOTTOMRIGHT", 0, -4)

	local FiltersFrame = CommunitiesGuildNewsFiltersFrame
	F.ReskinFrame(FiltersFrame)

	FiltersFrame:HookScript("OnShow", function()
		FiltersFrame:ClearAllPoints()
		FiltersFrame:SetPoint("TOPLEFT", CommunitiesFrame.ChatTab, "TOPRIGHT", 2, -2)
	end)

	for _, name in pairs({"GuildAchievement", "Achievement", "DungeonEncounter", "EpicItemLooted", "EpicItemPurchased", "EpicItemCrafted", "LegendaryItemLooted"}) do
		local filter = FiltersFrame[name]
		F.ReskinCheck(filter)
	end

	F.ReskinFrame(CommunitiesGuildLogFrame)
	F.ReskinScroll(CommunitiesGuildLogFrameScrollBar)
	F.StripTextures(CommunitiesGuildLogFrame.Container)
	F.CreateBDFrame(CommunitiesGuildLogFrame.Container, 0)
	local LogFrameCB = select(3, CommunitiesGuildLogFrame:GetChildren())
	F.ReskinButton(LogFrameCB)

	hooksecurefunc("GuildNewsButton_SetNews", function(button)
		if button.header:IsShown() then
			button.header:SetAlpha(0)
		end
	end)

	-- Recruitment dialog
	do
		local RecruitmentDialog = CommunitiesFrame.RecruitmentDialog
		F.ReskinFrame(RecruitmentDialog)
		F.ReskinCheck(RecruitmentDialog.ShouldListClub.Button)
		F.ReskinCheck(RecruitmentDialog.MaxLevelOnly.Button)
		F.ReskinCheck(RecruitmentDialog.MinIlvlOnly.Button)
		F.ReskinDropDown(RecruitmentDialog.ClubFocusDropdown)
		F.ReskinDropDown(RecruitmentDialog.LookingForDropdown)
		F.StripTextures(RecruitmentDialog.RecruitmentMessageFrame)
		F.StripTextures(RecruitmentDialog.RecruitmentMessageFrame.RecruitmentMessageInput)
		F.ReskinInput(RecruitmentDialog.RecruitmentMessageFrame)
		F.ReskinInput(RecruitmentDialog.MinIlvlOnly.EditBox)
		F.ReskinButton(RecruitmentDialog.Accept)
		F.ReskinButton(RecruitmentDialog.Cancel)
	end
end