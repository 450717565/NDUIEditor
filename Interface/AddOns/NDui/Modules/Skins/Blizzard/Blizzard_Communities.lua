local B, C, L, DB = unpack(select(2, ...))

C.themes["Blizzard_Communities"] = function()
	local cr, cg, cb = DB.r, DB.g, DB.b

	local function reskinCommunityTab(self)
		self:SetSize(32, 32)
		self:GetRegions():Hide()

		local icbg = B.ReskinIcon(self.Icon)
		B.ReskinHighlight(self, icbg)
		B.ReskinChecked(self, icbg)
	end

	local function reskinGuildCards(self)
		for _, name in pairs({"FirstCard", "SecondCard", "ThirdCard"}) do
			local guildCard = self[name]
			B.StripTextures(guildCard)
			B.CreateBDFrame(guildCard, 0)
			B.ReskinButton(guildCard.RequestJoin)
		end
		B.ReskinArrow(self.PreviousPage, "left")
		B.ReskinArrow(self.NextPage, "right")
	end

	local function reskinCommunityCards(self)
		for _, button in next, self.ListScrollFrame.buttons do
			button.CircleMask:Hide()
			button.LogoBorder:Hide()
			button.Background:Hide()
			B.ReskinButton(button)
			B.ReskinIcon(button.CommunityLogo)
		end
		B.ReskinScroll(self.ListScrollFrame.scrollBar)
	end

	local function reskinRequestCheckbox(self)
		for button in self.SpecsPool:EnumerateActive() do
			if button.CheckBox then
				B.ReskinCheck(button.CheckBox)
				button.CheckBox:SetSize(26, 26)
			end
		end
	end

	CommunitiesFrame.PortraitOverlay:SetAlpha(0)
	B.ReskinFrame(CommunitiesFrame)
	B.ReskinMinMax(CommunitiesFrame.MaximizeMinimizeFrame)
	B.ReskinDropDown(CommunitiesFrame.CommunitiesListDropDownMenu)

	CommunitiesFrame.ChatTab:ClearAllPoints()
	CommunitiesFrame.ChatTab:SetPoint("TOPLEFT", CommunitiesFrame, "TOPRIGHT", 1, -25)
	local tabs = {"ChatTab", "RosterTab", "GuildBenefitsTab", "GuildInfoTab"}
	for _, name in pairs(tabs) do
		local tab = CommunitiesFrame[name]
		reskinCommunityTab(tab)
	end

	B.StripTextures(CommunitiesFrameCommunitiesList)
	B.ReskinScroll(CommunitiesFrameCommunitiesListListScrollFrame.ScrollBar)
	hooksecurefunc(CommunitiesFrameCommunitiesList, "Update", function(self)
		local buttons = self.ListScrollFrame.buttons
		for i = 1, #buttons do
			local button = buttons[i]
			if not button.bg then
				B.CleanTextures(button)
				button:GetRegions():Hide()
				button.Selection:SetAlpha(0)

				button.bg = B.CreateBDFrame(button, 0)
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
			B.StripTextures(frame)

			if frame.FindAGuildButton then B.ReskinButton(frame.FindAGuildButton) end
			if frame.ApplyButton then B.ReskinButton(frame.ApplyButton) end
			if frame.AcceptButton then B.ReskinButton(frame.AcceptButton) end
			if frame.DeclineButton then B.ReskinDecline(frame.DeclineButton) end

			local OptionsList = frame.OptionsList
			if OptionsList then
				B.ReskinDropDown(OptionsList.ClubFocusDropdown)
				B.ReskinDropDown(OptionsList.ClubSizeDropdown)
				B.ReskinDropDown(OptionsList.SortByDropdown)
				B.ReskinRole(OptionsList.TankRoleFrame, "TANK")
				B.ReskinRole(OptionsList.HealerRoleFrame, "HEALER")
				B.ReskinRole(OptionsList.DpsRoleFrame, "DPS")
				B.ReskinInput(OptionsList.SearchBox, 20)
				B.ReskinButton(OptionsList.Search)

				OptionsList.Search:ClearAllPoints()
				OptionsList.Search:SetPoint("TOPRIGHT", OptionsList.SearchBox, "BOTTOMRIGHT", 0, -2)
			end

			local RequestToJoinFrame = frame.RequestToJoinFrame
			if RequestToJoinFrame then
				B.ReskinFrame(RequestToJoinFrame)
				B.ReskinButton(RequestToJoinFrame.Apply)
				B.ReskinButton(RequestToJoinFrame.Cancel)
				B.StripTextures(RequestToJoinFrame.MessageFrame)
				B.ReskinInput(RequestToJoinFrame.MessageFrame.MessageScroll)
				hooksecurefunc(RequestToJoinFrame, "Initialize", reskinRequestCheckbox)
			end

			if frame.ClubFinderSearchTab then
				reskinCommunityTab(frame.ClubFinderSearchTab)
				frame.ClubFinderSearchTab:ClearAllPoints()
				frame.ClubFinderSearchTab:SetPoint("TOPLEFT", CommunitiesFrame, "TOPRIGHT", 1, -25)
			end
			if frame.ClubFinderPendingTab then reskinCommunityTab(frame.ClubFinderPendingTab) end
			if frame.GuildCards then reskinGuildCards(frame.GuildCards) end
			if frame.PendingGuildCards then reskinGuildCards(frame.PendingGuildCards) end
			if frame.CommunityCards then reskinCommunityCards(frame.CommunityCards) end
			if frame.PendingCommunityCards then reskinCommunityCards(frame.PendingCommunityCards) end
		end
	end

	local GuildMemberDetailFrame = CommunitiesFrame.GuildMemberDetailFrame
	B.ReskinFrame(GuildMemberDetailFrame)
	B.ReskinButton(GuildMemberDetailFrame.RemoveButton)
	B.ReskinButton(GuildMemberDetailFrame.GroupInviteButton)
	B.ReskinDropDown(GuildMemberDetailFrame.RankDropdown)
	B.ReskinInput(GuildMemberDetailFrame.NoteBackground)
	B.ReskinInput(GuildMemberDetailFrame.OfficerNoteBackground)
	GuildMemberDetailFrame:ClearAllPoints()
	GuildMemberDetailFrame:SetPoint("TOPLEFT", CommunitiesFrame.ChatTab, "TOPRIGHT", 2, -2)

	local MemberList = CommunitiesFrame.MemberList
	B.StripTextures(MemberList)
	B.CreateBDFrame(MemberList, 0)
	B.ReskinScroll(MemberList.ListScrollFrame.scrollBar)

	-- ChatTab
	B.ReskinDropDown(CommunitiesFrame.StreamDropDownMenu)
	B.ReskinArrow(CommunitiesFrame.AddToChatButton, "down")
	B.ReskinButton(CommunitiesFrame.InviteButton)
	B.ReskinButton(CommunitiesFrame.CommunitiesControlFrame.GuildRecruitmentButton)
	B.ReskinButton(CommunitiesFrame.CommunitiesControlFrame.CommunitiesSettingsButton)
	B.ReskinInput(CommunitiesFrame.ChatEditBox, 22)

	local Chat = CommunitiesFrame.Chat
	B.StripTextures(Chat)
	B.ReskinScroll(Chat.MessageFrame.ScrollBar)
	local chatBG = B.CreateBDFrame(Chat, 0)
	chatBG:SetPoint("TOPLEFT", -6, 5)
	chatBG:SetPoint("BOTTOMRIGHT", 3, -2)

	local EditStreamDialog = CommunitiesFrame.EditStreamDialog
	B.ReskinFrame(EditStreamDialog)
	B.ReskinCheck(EditStreamDialog.TypeCheckBox)
	B.ReskinButton(EditStreamDialog.Accept)
	B.ReskinButton(EditStreamDialog.Delete)
	B.ReskinButton(EditStreamDialog.Cancel)
	B.ReskinInput(EditStreamDialog.NameEdit, 22)
	B.ReskinInput(EditStreamDialog.Description)

	local NotificationSettingsDialog = CommunitiesFrame.NotificationSettingsDialog
	NotificationSettingsDialog.ScrollFrame.Child.QuickJoinButton:SetSize(25, 25)

	B.ReskinFrame(NotificationSettingsDialog)
	B.ReskinDropDown(NotificationSettingsDialog.CommunitiesListDropDownMenu)
	B.ReskinButton(NotificationSettingsDialog.OkayButton)
	B.ReskinButton(NotificationSettingsDialog.CancelButton)
	B.ReskinCheck(NotificationSettingsDialog.ScrollFrame.Child.QuickJoinButton)
	B.ReskinButton(NotificationSettingsDialog.ScrollFrame.Child.AllButton)
	B.ReskinButton(NotificationSettingsDialog.ScrollFrame.Child.NoneButton)
	B.ReskinScroll(NotificationSettingsDialog.ScrollFrame.ScrollBar)

	hooksecurefunc(NotificationSettingsDialog, "Refresh", function(self)
		local frame = self.ScrollFrame.Child
		for i = 1, frame:GetNumChildren() do
			local child = select(i, frame:GetChildren())
			if child.StreamName and not child.styled then
				B.ReskinRadio(child.ShowNotificationsButton)
				B.ReskinRadio(child.HideNotificationsButton)
				child.Separator:Hide()

				child.styled = true
			end
		end
	end)

	local RecruitmentDialog = CommunitiesFrame.RecruitmentDialog
	B.ReskinFrame(RecruitmentDialog)
	B.ReskinCheck(RecruitmentDialog.ShouldListClub.Button)
	B.ReskinCheck(RecruitmentDialog.MaxLevelOnly.Button)
	B.ReskinCheck(RecruitmentDialog.MinIlvlOnly.Button)
	B.ReskinDropDown(RecruitmentDialog.ClubFocusDropdown)
	B.ReskinDropDown(RecruitmentDialog.LookingForDropdown)
	B.StripTextures(RecruitmentDialog.RecruitmentMessageFrame.RecruitmentMessageInput)
	B.ReskinScroll(RecruitmentDialog.RecruitmentMessageFrame.RecruitmentMessageInput.ScrollBar)
	B.ReskinInput(RecruitmentDialog.RecruitmentMessageFrame)
	B.ReskinInput(RecruitmentDialog.MinIlvlOnly.EditBox)
	B.ReskinButton(RecruitmentDialog.Accept)
	B.ReskinButton(RecruitmentDialog.Cancel)

	local SettingsDialog = CommunitiesSettingsDialog
	B.ReskinFrame(SettingsDialog)
	B.ReskinButton(SettingsDialog.ChangeAvatarButton)
	B.ReskinButton(SettingsDialog.Accept)
	B.ReskinButton(SettingsDialog.Delete)
	B.ReskinButton(SettingsDialog.Cancel)
	B.ReskinInput(SettingsDialog.NameEdit)
	B.ReskinInput(SettingsDialog.ShortNameEdit)
	B.ReskinInput(SettingsDialog.Description)
	B.ReskinInput(SettingsDialog.MessageOfTheDay)
	B.ReskinCheck(SettingsDialog.ShouldListClub.Button)
	B.ReskinCheck(SettingsDialog.AutoAcceptApplications.Button)
	B.ReskinCheck(SettingsDialog.MaxLevelOnly.Button)
	B.ReskinCheck(SettingsDialog.MinIlvlOnly.Button)
	B.ReskinInput(SettingsDialog.MinIlvlOnly.EditBox)
	B.ReskinDropDown(ClubFinderFocusDropdown)
	B.ReskinDropDown(ClubFinderLookingForDropdown)

	local AvatarPickerDialog = CommunitiesAvatarPickerDialog
	B.ReskinFrame(AvatarPickerDialog)
	B.ReskinScroll(CommunitiesAvatarPickerDialogScrollBar)
	B.ReskinButton(AvatarPickerDialog.OkayButton)
	B.ReskinButton(AvatarPickerDialog.CancelButton)

	hooksecurefunc(AvatarPickerDialog.ScrollFrame, "Refresh", function(self)
		for i = 1, 5 do
			for j = 1, 6 do
				local avatarButton = self.avatarButtons[i][j]
				if avatarButton:IsShown() and not avatarButton.styled then
					avatarButton.Selected:SetTexture("")

					avatarButton.bg = B.ReskinIcon(avatarButton.Icon)
					B.ReskinHighlight(avatarButton, avatarButton.bg)

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
	B.ReskinFrame(TicketManagerDialog)
	B.ReskinButton(TicketManagerDialog.LinkToChat)
	B.ReskinButton(TicketManagerDialog.Copy)
	B.ReskinButton(TicketManagerDialog.Close)
	B.ReskinArrow(TicketManagerDialog.MaximizeButton, "down")
	B.ReskinDropDown(TicketManagerDialog.ExpiresDropDownMenu)
	B.ReskinDropDown(TicketManagerDialog.UsesDropDownMenu)
	B.ReskinButton(TicketManagerDialog.GenerateLinkButton)

	TicketManagerDialog.InviteManager.ArtOverlay:Hide()
	B.StripTextures(TicketManagerDialog.InviteManager.ColumnDisplay)
	B.ReskinScroll(TicketManagerDialog.InviteManager.ListScrollFrame.scrollBar)

	hooksecurefunc(TicketManagerDialog, "Update", function(self)
		local ColumnDisplay = self.InviteManager.ColumnDisplay
		for i = 1, ColumnDisplay:GetNumChildren() do
			local child = select(i, ColumnDisplay:GetChildren())
			if not child.styled then
				B.StripTextures(child)

				local bg = B.CreateBDFrame(child, 0)
				bg:SetPoint("TOPLEFT", 4, -2)
				bg:SetPoint("BOTTOMRIGHT", 0, 2)
				B.ReskinHighlight(child, bg, true)

				child.styled = true
			end
		end

		local buttons = self.InviteManager.ListScrollFrame.buttons
		for i = 1, #buttons do
			local button = buttons[i]
			if not button.styled then
				B.ReskinButton(button.CopyLinkButton)
				B.ReskinButton(button.RevokeButton)
				button.RevokeButton:SetSize(18, 18)

				button.styled = true
			end
		end
	end)

	-- RosterTab
	B.StripTextures(CommunitiesFrame.MemberList.ColumnDisplay)
	B.StripTextures(CommunitiesFrame.ApplicantList.ColumnDisplay)
	B.ReskinCheck(CommunitiesFrame.MemberList.ShowOfflineButton)
	B.ReskinDropDown(CommunitiesFrame.GuildMemberListDropDownMenu)
	B.ReskinButton(CommunitiesFrame.CommunitiesControlFrame.GuildControlButton)
	B.ReskinDropDown(CommunitiesFrame.CommunityMemberListDropDownMenu)

	local ApplicantList = CommunitiesFrame.ApplicantList
	B.StripTextures(ApplicantList)
	B.ReskinScroll(ApplicantList.ListScrollFrame.scrollBar)
	local listBG = B.CreateBDFrame(ApplicantList, 0)
	listBG:SetPoint("TOPLEFT", 0, 0)
	listBG:SetPoint("BOTTOMRIGHT", -15, 0)

	hooksecurefunc(ApplicantList, "BuildList", function(self)
		local ColumnDisplay = self.ColumnDisplay
		for i = 1, ColumnDisplay:GetNumChildren() do
			local child = select(i, ColumnDisplay:GetChildren())
			if not child.styled then
				B.StripTextures(child)

				local bg = B.CreateBDFrame(child, 0)
				bg:SetPoint("TOPLEFT", 4, -2)
				bg:SetPoint("BOTTOMRIGHT", 0, 2)
				B.ReskinHighlight(child, bg, true)

				child.styled = true
			end
		end

		local buttons = self.ListScrollFrame.buttons
		for i = 1, #buttons do
			local button = buttons[i]
			if not button.styled then
				button:SetPoint("LEFT", listBG, C.mult, 0)
				button:SetPoint("RIGHT", listBG, -C.mult, 0)
				button.InviteButton:SetSize(66, 18)
				button.CancelInvitationButton:SetSize(20, 18)

				B.ReskinHighlight(button, nil, true)
				B.ReskinButton(button.InviteButton)
				B.ReskinDecline(button.CancelInvitationButton)

				hooksecurefunc(button, "UpdateMemberInfo", function(self, info)
					self.Info = info
					if not info then return end

					if not self.Class.bg then
						self.Class.bg = B.CreateBDFrame(self.Class, 0)
					end

					local classTag = select(2, GetClassInfo(info.classID))
					if classTag then
						local tcoords = CLASS_ICON_TCOORDS[classTag]
						self.Class:SetTexCoord(
							tcoords[1] + .022,
							tcoords[2] - .025,
							tcoords[3] + .022,
							tcoords[4] - .025
						)
					end
				end)

				button.styled = true
			end
		end
	end)

	hooksecurefunc(CommunitiesFrame.MemberList, "RefreshListDisplay", function(self)
		local ColumnDisplay = self.ColumnDisplay
		for i = 1, ColumnDisplay:GetNumChildren() do
			local child = select(i, ColumnDisplay:GetChildren())
			if not child.styled then
				B.StripTextures(child)

				local bg = B.CreateBDFrame(child, 0)
				bg:SetPoint("TOPLEFT", 4, -2)
				bg:SetPoint("BOTTOMRIGHT", 0, 2)
				B.ReskinHighlight(child, bg, true)

				child.styled = true
			end
		end

		for _, button in pairs(self.ListScrollFrame.buttons or {}) do
			if button and not button.styled then
				B.ReskinHighlight(button, nil, true)
				hooksecurefunc(button, "RefreshExpandedColumns", function(self)
					if not self.expanded then return end

					if not self.Class.bg then
						self.Class.bg = B.CreateBDFrame(self.Class, 0)
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
				end)

				if button.ProfessionHeader then
					local header = button.ProfessionHeader
					B.StripTextures(header)

					local bg = B.CreateBDFrame(header, 0)
					bg:SetPoint("TOPLEFT", -C.mult, -C.mult)
					bg:SetPoint("BOTTOMRIGHT", C.mult, C.mult)

					B.ReskinHighlight(header, bg, true)
					B.ReskinIcon(header.Icon)
				end

				button.styled = true
			end

			if button and button.Class.bg then
				button.Class.bg:SetShown(button.Class:IsShown())
			end
		end
	end)

	-- GuildBenefitsTab
	local GuildBenefitsFrame = CommunitiesFrame.GuildBenefitsFrame
	B.StripTextures(GuildBenefitsFrame)
	B.StripTextures(GuildBenefitsFrame.Perks)
	B.StripTextures(GuildBenefitsFrame.Rewards)
	B.ReskinScroll(CommunitiesFrameRewards.scrollBar)

	local factionFrameBar = GuildBenefitsFrame.FactionFrame.Bar
	B.StripTextures(factionFrameBar)
	B.CreateBDFrame(factionFrameBar.BG, 0)
	factionFrameBar.Progress:SetTexture(DB.normTex)
	factionFrameBar.Progress:SetVertexColor(cr, cg, cb, .8)
	factionFrameBar.Label:ClearAllPoints()
	factionFrameBar.Label:SetPoint("CENTER", factionFrameBar.BG)

	hooksecurefunc("CommunitiesGuildPerks_Update", function(self)
		local buttons = self.Container.buttons
		for i = 1, #buttons do
			local button = buttons[i]
			if button and not button.styled then
				B.StripTextures(button)

				local icbg = B.ReskinIcon(button.Icon)
				local bubg = B.CreateBDFrame(button, 0)
				bubg:SetPoint("TOPLEFT", icbg, "TOPRIGHT", 2, 0)
				bubg:SetPoint("BOTTOMRIGHT", 0, 1)
				B.ReskinHighlight(button, bubg, true)

				button.styled = true
			end
		end
	end)

	hooksecurefunc("CommunitiesGuildRewards_Update", function(self)
		local buttons = self.RewardsContainer.buttons
		for i = 1, #buttons do
			local button = buttons[i]
			if button and not button.styled then
				B.StripTextures(button)
				B.ReskinIcon(button.Icon)

				local bubg = B.CreateBDFrame(button, 0, -C.mult*2)
				B.ReskinHighlight(button, bubg, true)

				button.styled = true
			end
		end
	end)

	-- GuildInfoTab
	B.ReskinButton(CommunitiesFrame.GuildLogButton)
	B.StripTextures(CommunitiesFrameGuildDetailsFrame)
	B.StripTextures(CommunitiesFrameGuildDetailsFrameInfo)
	B.StripTextures(CommunitiesFrameGuildDetailsFrameNews)
	B.ReskinScroll(CommunitiesFrameGuildDetailsFrameInfoScrollBar)
	B.ReskinScroll(CommunitiesFrameGuildDetailsFrameNewsContainer.ScrollBar)
	B.ReskinScroll(CommunitiesFrameGuildDetailsFrameInfoMOTDScrollFrameScrollBar)

	B.ReskinFrame(CommunitiesGuildTextEditFrame)
	B.ReskinScroll(CommunitiesGuildTextEditFrameScrollBar)
	B.ReskinInput(CommunitiesGuildTextEditFrame.Container)
	B.ReskinButton(CommunitiesGuildTextEditFrameAcceptButton)
	local TextEditFrameCB = select(4, CommunitiesGuildTextEditFrame:GetChildren())
	B.ReskinButton(TextEditFrameCB)

	B.ReskinFrame(CommunitiesGuildLogFrame)
	B.ReskinScroll(CommunitiesGuildLogFrameScrollBar)
	B.ReskinInput(CommunitiesGuildLogFrame.Container)
	local LogFrameCB = select(3, CommunitiesGuildLogFrame:GetChildren())
	B.ReskinButton(LogFrameCB)

	B.CreateBDFrame(CommunitiesFrameGuildDetailsFrameInfo.DetailsFrame, 0)
	local bg = B.CreateBDFrame(CommunitiesFrameGuildDetailsFrameInfoMOTDScrollFrame, 0)
	bg:SetPoint("TOPLEFT", 0, 3)
	bg:SetPoint("BOTTOMRIGHT", 0, -4)

	local BossModel = CommunitiesFrameGuildDetailsFrameNews.BossModel
	BossModel:ClearAllPoints()
	BossModel:SetPoint("LEFT", CommunitiesFrame, "RIGHT", 40, 0)

	local TextFrame = BossModel.TextFrame
	B.StripTextures(TextFrame)

	local bossBG = B.ReskinFrame(BossModel)
	bossBG:SetOutside(BossModel, C.mult, C.mult, TextFrame)

	local FiltersFrame = CommunitiesGuildNewsFiltersFrame
	B.ReskinFrame(FiltersFrame)

	FiltersFrame:HookScript("OnShow", function()
		FiltersFrame:ClearAllPoints()
		FiltersFrame:SetPoint("TOPLEFT", CommunitiesFrame.ChatTab, "TOPRIGHT", 2, -2)
	end)

	local filters = {"GuildAchievement", "Achievement", "DungeonEncounter", "EpicItemLooted", "EpicItemPurchased", "EpicItemCrafted", "LegendaryItemLooted"}
	for _, name in pairs(filters) do
		local filter = FiltersFrame[name]
		B.ReskinCheck(filter)
	end

	hooksecurefunc("GuildNewsButton_SetNews", function(button)
		if button.header:IsShown() then
			button.header:SetAlpha(0)
		end
	end)
end