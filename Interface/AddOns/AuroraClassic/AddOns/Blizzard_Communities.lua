local F, C = unpack(select(2, ...))

C.themes["Blizzard_Communities"] = function()
	local r, g, b = C.r, C.g, C.b

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
	F.StripTextures(GuildMemberDetailFrame.NoteBackground, true)
	F.CreateBDFrame(GuildMemberDetailFrame.NoteBackground, 0)
	F.StripTextures(GuildMemberDetailFrame.OfficerNoteBackground, true)
	F.CreateBDFrame(GuildMemberDetailFrame.OfficerNoteBackground, 0)
	GuildMemberDetailFrame:ClearAllPoints()
	GuildMemberDetailFrame:SetPoint("TOPLEFT", CommunitiesFrame.ChatTab, "TOPRIGHT", 2, 0)

	for _, name in next, {"GuildFinderFrame", "InvitationFrame", "TicketFrame"} do
		local frame = CommunitiesFrame[name]
		F.StripTextures(frame.InsetFrame)
		F.CreateBDFrame(frame, 0)

		if frame.FindAGuildButton then F.ReskinButton(frame.FindAGuildButton) end
		if frame.AcceptButton then F.ReskinButton(frame.AcceptButton) end
		if frame.DeclineButton then F.ReskinButton(frame.DeclineButton) end
	end

	CommunitiesFrame.ChatTab:ClearAllPoints()
	CommunitiesFrame.ChatTab:SetPoint("TOPLEFT", CommunitiesFrame, "TOPRIGHT", 2, -25)
	for _, name in next, {"ChatTab", "RosterTab", "GuildBenefitsTab", "GuildInfoTab"} do
		local tab = CommunitiesFrame[name]
		tab:SetSize(34, 34)
		tab:GetRegions():Hide()
		tab:SetCheckedTexture(C.media.checked)

		local bg = F.ReskinIcon(tab.Icon)
		F.ReskinTexture(tab, bg, false)
	end

	F.StripTextures(CommunitiesFrameCommunitiesList, true)
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
			end

			if button.Selection:IsShown() then
				button.bg:SetBackdropColor(r, g, b, .25)
			else
				button.bg:SetBackdropColor(0, 0, 0, 0)
			end
		end
	end)

	-- ChatTab
	F.ReskinDropDown(CommunitiesFrame.StreamDropDownMenu)
	F.ReskinScroll(CommunitiesFrame.Chat.MessageFrame.ScrollBar)
	F.ReskinScroll(CommunitiesFrame.MemberList.ListScrollFrame.scrollBar)

	F.StripTextures(CommunitiesFrame.Chat, true)
	F.ReskinInput(CommunitiesFrame.ChatEditBox, 22)
	local chatbg = F.CreateBDFrame(CommunitiesFrame.Chat, 0)
	chatbg:SetPoint("TOPLEFT", -6, 5)
	chatbg:SetPoint("BOTTOMRIGHT", 3, -2)

	F.StripTextures(CommunitiesFrame.MemberList, true)
	F.CreateBDFrame(CommunitiesFrame.MemberList, 0)

	local EditStream = CommunitiesFrame.EditStreamDialog
	F.ReskinFrame(EditStream)
	F.ReskinCheck(EditStream.TypeCheckBox)
	F.ReskinButton(EditStream.Accept)
	F.ReskinButton(EditStream.Delete)
	F.ReskinButton(EditStream.Cancel)
	F.ReskinInput(EditStream.NameEdit, 22)
	F.StripTextures(EditStream.Description, true)
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
	F.StripTextures(CommunitiesFrame.MemberList.ColumnDisplay, true)
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
				if avatarButton:IsShown() and not avatarButton.bg then
					avatarButton.bg = F.ReskinIcon(avatarButton.Icon)
					F.ReskinTexture(avatarButton, avatarButton.bg, false)
					F.ReskinTexture(avatarButton.Selected, avatarButton.bg, false)
				end
			end
		end
	end)

	local function updateNameFrame(self)
		if not self.expanded then return end

		self:SetHighlightTexture(C.media.bdTex)
		self:GetHighlightTexture():SetColorTexture(r, g, b, .25)

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
				local bg = F.CreateBDFrame(child, 0)
				bg:SetPoint("TOPLEFT", 4, -2)
				bg:SetPoint("BOTTOMRIGHT", 0, 2)
				F.ReskinTexture(child, bg, true)

				child.styled = true
			end
		end

		for _, button in ipairs(self.ListScrollFrame.buttons or {}) do
			if button and not button.hooked then
				hooksecurefunc(button, "RefreshExpandedColumns", updateNameFrame)
				if button.ProfessionHeader then
					local header = button.ProfessionHeader
					for i = 1, 3 do select(i, header:GetRegions()):Hide() end
					local bg = F.CreateBDFrame(header, 0)
					F.ReskinTexture(header, bg, true)
					F.ReskinIcon(header.Icon, true)
				end

				button.hooked = true
			end
			if button and button.bg then button.bg:SetShown(button.Class:IsShown()) end
		end
	end)

	-- GuildBenefitsTab
	local GuildBenefitsFrame = CommunitiesFrame.GuildBenefitsFrame
	GuildBenefitsFrame.Perks:GetRegions():Hide()
	GuildBenefitsFrame.Rewards.Bg:Hide()
	F.StripTextures(GuildBenefitsFrame, true)
	F.ReskinScroll(CommunitiesFrameRewards.scrollBar)

	local factionFrameBar = GuildBenefitsFrame.FactionFrame.Bar
	F.StripTextures(factionFrameBar)
	F.CreateBDFrame(factionFrameBar.BG, 0)
	factionFrameBar.Progress:SetTexture(C.media.normTex)
	factionFrameBar.Progress:SetVertexColor(r*.8, g*.8, b*.8)
	factionFrameBar.Label:ClearAllPoints()
	factionFrameBar.Label:SetPoint("CENTER", factionFrameBar.BG, "CENTER", 0, 0)

	hooksecurefunc("CommunitiesGuildPerks_Update", function(self)
		local buttons = self.Container.buttons
		for i = 1, #buttons do
			local button = buttons[i]
			if button and button:IsShown() and not button.bg then
				F.StripTextures(button)

				local ic = F.ReskinIcon(button.Icon)
				button.bg = F.CreateBDFrame(button, 0)
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
					button.bg = F.CreateBDFrame(button, 0)
					button.bg:SetPoint("TOPLEFT", C.mult, -C.mult)
					button.bg:SetPoint("BOTTOMRIGHT", -C.mult, C.mult)

					F.ReskinTexture(button, button.bg, true)
					F.ReskinIcon(button.Icon)
				end
				button:SetNormalTexture("")
				button.DisabledBG:Hide()
			end
		end
	end)

	-- GuildInfoTab
	CommunitiesFrameGuildDetailsFrameInfoMOTDScrollFrameScrollBar:SetAlpha(0)
	F.StripTextures(CommunitiesFrameGuildDetailsFrame, true)
	F.StripTextures(CommunitiesFrameGuildDetailsFrameInfo, true)
	F.StripTextures(CommunitiesFrameGuildDetailsFrameNews, true)
	F.ReskinScroll(CommunitiesFrameGuildDetailsFrameNewsContainer.ScrollBar)

	F.ReskinFrame(CommunitiesGuildTextEditFrame)
	F.ReskinScroll(CommunitiesGuildTextEditFrameScrollBar)
	F.StripTextures(CommunitiesGuildTextEditFrame.Container, true)
	F.CreateBDFrame(CommunitiesGuildTextEditFrame.Container, 0)
	F.ReskinButton(CommunitiesGuildTextEditFrameAcceptButton)
	local TextEditFrameCB = select(4, CommunitiesGuildTextEditFrame:GetChildren())
	F.ReskinButton(TextEditFrameCB)

	F.CreateBDFrame(CommunitiesFrameGuildDetailsFrameInfo.DetailsFrame, 0)
	local bg = F.CreateBDFrame(CommunitiesFrameGuildDetailsFrameInfoMOTDScrollFrame, 0)
	bg:SetPoint("TOPLEFT", 0, 3)
	bg:SetPoint("BOTTOMRIGHT", -5, -4)

	F.ReskinFrame(CommunitiesGuildNewsFiltersFrame)
	for _, name in next, {"GuildAchievement", "Achievement", "DungeonEncounter", "EpicItemLooted", "EpicItemPurchased", "EpicItemCrafted", "LegendaryItemLooted"} do
		local filter = CommunitiesGuildNewsFiltersFrame[name]
		F.ReskinCheck(filter)
	end

	F.ReskinFrame(CommunitiesGuildLogFrame)
	F.ReskinScroll(CommunitiesGuildLogFrameScrollBar)
	F.StripTextures(CommunitiesGuildLogFrame.Container, true)
	F.CreateBDFrame(CommunitiesGuildLogFrame.Container, 0)
	local LogFrameCB = select(3, CommunitiesGuildLogFrame:GetChildren())
	F.ReskinButton(LogFrameCB)

	hooksecurefunc("CommunitiesGuildNewsButton_SetNews", function(button)
		if button.header:IsShown() then
			button.header:SetAlpha(0)
		end
	end)
end