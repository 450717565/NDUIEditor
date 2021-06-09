local _, ns = ...
local B, C, L, DB = unpack(ns)

local cr, cg, cb = DB.cr, DB.cg, DB.cb

local function Reskin_CommunityTab(self)
	self:SetSize(32, 32)
	self:GetRegions():Hide()

	local icbg = B.ReskinIcon(self.Icon)
	B.ReskinHLTex(self, icbg)
	B.ReskinCPTex(self, icbg)
end

local function Reskin_GuildCards(self)
	local cards = {
		"FirstCard",
		"SecondCard",
		"ThirdCard",
	}
	for _, name in pairs(cards) do
		local guildCard = self[name]
		B.StripTextures(guildCard)
		B.CreateBDFrame(guildCard)
		B.ReskinButton(guildCard.RequestJoin)
	end

	B.ReskinArrow(self.PreviousPage, "left")
	B.ReskinArrow(self.NextPage, "right")
end

local function Reskin_CommunityCards(self)
	for _, button in pairs(self.ListScrollFrame.buttons) do
		button.CircleMask:Hide()
		button.LogoBorder:Hide()
		button.Background:Hide()

		B.ReskinButton(button)
		B.ReskinIcon(button.CommunityLogo)
	end
	B.ReskinScroll(self.ListScrollFrame.scrollBar)
end

local function Reskin_RequestCheckbox(self)
	for button in self.SpecsPool:EnumerateActive() do
		if button.CheckBox then
			B.ReskinCheck(button.CheckBox)
			button.CheckBox:SetSize(26, 26)
		end
	end
end

local function Reskin_ColumnDisplay(self)
	local children = {self:GetChildren()}
	for _, child in pairs(children) do
		if child and not child.styled then
			B.StripTextures(child)

			local bg = B.CreateBGFrame(child, 4, -2, 0, 2)
			B.ReskinHLTex(child, bg, true)

			child.styled = true
		end
	end
end

local function Reskin_CommunitiesList(self)
	local buttons = self.ListScrollFrame.buttons
	for i = 1, #buttons do
		local button = buttons[i]
		if not button.bubg then
			B.CleanTextures(button)
			button.Background:Hide()
			button.Selection:SetAlpha(0)

			button.bubg = B.CreateBGFrame(button, 5, -5, -10, 5)
		end

		if button.Selection:IsShown() then
			button.bubg:SetBackdropColor(cr, cg, cb, .5)
		else
			button.bubg:SetBackdropColor(0, 0, 0, 0)
		end
	end
end

local function Reskin_RefreshExpandedColumns(self)
	if not self.expanded then return end

	if not self.Class.icbg then
		self.Class.icbg = B.CreateBDFrame(self.Class, 0, -C.mult)
	end

	local memberInfo = self:GetMemberInfo()
	if memberInfo and memberInfo.classID then
		local classInfo = C_CreatureInfo.GetClassInfo(memberInfo.classID)
		if classInfo then
			self.Class:SetTexCoord(B.GetClassTexCoord(classInfo.classFile))
		end
	end
end

local function Reskin_MemberList(self)
	local ColumnDisplay = self.ColumnDisplay
	Reskin_ColumnDisplay(ColumnDisplay)

	for _, button in pairs(self.ListScrollFrame.buttons or {}) do
		if button then
			if not button.styled then
				B.ReskinHLTex(button, nil, true)

				hooksecurefunc(button, "RefreshExpandedColumns", Reskin_RefreshExpandedColumns)

				if button.ProfessionHeader then
					local header = button.ProfessionHeader
					B.StripTextures(header)

					local bg = B.CreateBDFrame(header, 0, 1)
					B.ReskinHLTex(header, bg, true)
					B.ReskinIcon(header.Icon)
				end

				button.styled = true
			end

			if button.Class.icbg then
				button.Class.icbg:SetShown(button.Class:IsShown())
			end
		end
	end
end

local function Reskin_NotificationSettingsDialog(self)
	local children = {self.ScrollFrame.Child:GetChildren()}
	for _, child in pairs(children) do
		if child.StreamName and not child.styled then
			B.ReskinRadio(child.ShowNotificationsButton)
			B.ReskinRadio(child.HideNotificationsButton)
			child.Separator:Hide()

			child.styled = true
		end
	end
end

local function Reskin_AvatarPickerDialog(self)
	for i = 1, 5 do
		for j = 1, 6 do
			local avatarButton = self.avatarButtons[i][j]
			if avatarButton:IsShown() and not avatarButton.icbg then
				avatarButton.Selected:SetTexture("")

				avatarButton.icbg = B.ReskinIcon(avatarButton.Icon)
				B.ReskinHLTex(avatarButton, avatarButton.icbg)
			end

			if avatarButton.Selected:IsShown() then
				avatarButton.icbg:SetBackdropBorderColor(cr, cg, cb)
			else
				avatarButton.icbg:SetBackdropBorderColor(0, 0, 0)
			end
		end
	end
end

local function Reskin_TicketManagerDialog(self)
	local ColumnDisplay = self.InviteManager.ColumnDisplay
	Reskin_ColumnDisplay(ColumnDisplay)

	local buttons = self.InviteManager.ListScrollFrame.buttons
	for i = 1, #buttons do
		local button = buttons[i]
		if button and not button.styled then
			B.ReskinButton(button.CopyLinkButton)
			B.ReskinButton(button.RevokeButton)
			button.RevokeButton:SetSize(18, 18)

			button.styled = true
		end
	end
end

local function Reskin_UpdateMemberInfo(self, info)
	if not info then return end

	if not self.Class.icbg then
		self.Class.icbg = B.CreateBDFrame(self.Class, 0, -C.mult)
	end

	local classTag = select(2, GetClassInfo(info.classID))
	if classTag then
		self.Class:SetTexCoord(B.GetClassTexCoord(classTag))
	end
end

local function Reskin_ApplicantList(self)
	local ColumnDisplay = self.ColumnDisplay
	Reskin_ColumnDisplay(ColumnDisplay)

	local buttons = self.ListScrollFrame.buttons
	for i = 1, #buttons do
		local button = buttons[i]
		if button and not button.styled then
			button:SetPoint("LEFT", self.bg, C.mult, 0)
			button:SetPoint("RIGHT", self.bg, -C.mult, 0)
			button.InviteButton:SetSize(66, 18)
			button.CancelInvitationButton:SetSize(20, 18)

			B.ReskinHLTex(button, nil, true)
			B.ReskinButton(button.InviteButton)
			B.ReskinDecline(button.CancelInvitationButton)

			hooksecurefunc(button, "UpdateMemberInfo", Reskin_UpdateMemberInfo)

			button.styled = true
		end
	end
end

local function Reskin_GuildPerks(self)
	local buttons = self.Container.buttons
	for i = 1, #buttons do
		local button = buttons[i]
		if button and not button.styled then
			B.StripTextures(button)

			local icbg = B.ReskinIcon(button.Icon)
			local bubg = B.CreateBGFrame(button, 2, 0, 0, 0, icbg)
			B.ReskinHLTex(button, bubg, true)

			button.styled = true
		end
	end
end

local function Reskin_GuildRewards(self)
	local buttons = self.RewardsContainer.buttons
	for i = 1, #buttons do
		local button = buttons[i]
		if button and not button.styled then
			B.StripTextures(button)
			B.ReskinIcon(button.Icon)

			local bubg = B.CreateBDFrame(button, 0, 1)
			B.ReskinHLTex(button, bubg, true)

			button.styled = true
		end
	end
end

local function Reskin_GuildNewsButton(button)
	if button.header:IsShown() then
		button.header:SetAlpha(0)
	end
end

local function Update_FrameAnchor(self)
	self:ClearAllPoints()
	self:SetPoint("TOPLEFT", CommunitiesFrame.ChatTab, "TOPRIGHT", 2, -2)
end

C.LUAThemes["Blizzard_Communities"] = function()
	CommunitiesFrame.PortraitOverlay:SetAlpha(0)
	B.ReskinFrame(CommunitiesFrame)
	B.ReskinMinMax(CommunitiesFrame.MaximizeMinimizeFrame)
	B.ReskinDropDown(CommunitiesFrame.CommunitiesListDropDownMenu)

	CommunitiesFrame.ChatTab:ClearAllPoints()
	CommunitiesFrame.ChatTab:SetPoint("TOPLEFT", CommunitiesFrame, "TOPRIGHT", 1, -25)
	local tabs = {
		"ChatTab",
		"GuildBenefitsTab",
		"GuildInfoTab",
		"RosterTab",
	}
	for _, name in pairs(tabs) do
		local tab = CommunitiesFrame[name]
		Reskin_CommunityTab(tab)
	end

	B.StripTextures(CommunitiesFrameCommunitiesList)
	B.ReskinScroll(CommunitiesFrameCommunitiesListListScrollFrame.ScrollBar)
	hooksecurefunc(CommunitiesFrameCommunitiesList, "Update", Reskin_CommunitiesList)

	local frames = {
		"ClubFinderInvitationFrame",
		"CommunityFinderFrame",
		"GuildFinderFrame",
		"InvitationFrame",
		"TicketFrame",
	}
	for _, name in pairs(frames) do
		local frame = CommunitiesFrame[name]
		if frame then
			B.StripTextures(frame)

			if frame.ApplyButton then B.ReskinButton(frame.ApplyButton) end
			if frame.AcceptButton then B.ReskinButton(frame.AcceptButton) end
			if frame.DeclineButton then B.ReskinButton(frame.DeclineButton) end
			if frame.FindAGuildButton then B.ReskinButton(frame.FindAGuildButton) end

			local OptionsList = frame.OptionsList
			if OptionsList then
				B.ReskinDropDown(OptionsList.ClubFilterDropdown)
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
				hooksecurefunc(RequestToJoinFrame, "Initialize", Reskin_RequestCheckbox)
			end

			if frame.ClubFinderSearchTab then
				Reskin_CommunityTab(frame.ClubFinderSearchTab)
				frame.ClubFinderSearchTab:ClearAllPoints()
				frame.ClubFinderSearchTab:SetPoint("TOPLEFT", CommunitiesFrame, "TOPRIGHT", 1, -25)
			end

			if frame.GuildCards then Reskin_GuildCards(frame.GuildCards) end
			if frame.CommunityCards then Reskin_CommunityCards(frame.CommunityCards) end
			if frame.PendingGuildCards then Reskin_GuildCards(frame.PendingGuildCards) end
			if frame.ClubFinderPendingTab then Reskin_CommunityTab(frame.ClubFinderPendingTab) end
			if frame.PendingCommunityCards then Reskin_CommunityCards(frame.PendingCommunityCards) end
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
	B.StripTextures(MemberList.ColumnDisplay)
	B.CreateBDFrame(MemberList)
	B.ReskinCheck(MemberList.ShowOfflineButton)
	B.ReskinScroll(MemberList.ListScrollFrame.scrollBar)

	hooksecurefunc(MemberList, "RefreshListDisplay", Reskin_MemberList)

	-- ChatTab
	B.ReskinDropDown(CommunitiesFrame.StreamDropDownMenu)
	B.ReskinArrow(CommunitiesFrame.AddToChatButton, "down")
	B.ReskinButton(CommunitiesFrame.InviteButton)
	B.ReskinButton(CommunitiesFrame.CommunitiesControlFrame.GuildRecruitmentButton)
	B.ReskinButton(CommunitiesFrame.CommunitiesControlFrame.CommunitiesSettingsButton)

	CommunitiesFrame.ChatEditBox:DisableDrawLayer("BACKGROUND")

	local Chat = CommunitiesFrame.Chat
	B.StripTextures(Chat)
	B.ReskinScroll(Chat.MessageFrame.ScrollBar)
	B.CreateBGFrame(Chat, -8, 6, 6+C.mult, -6)
	B.CreateBGFrame(CommunitiesFrame.ChatEditBox, -5, -5, 4, 6)

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

	hooksecurefunc(NotificationSettingsDialog, "Refresh", Reskin_NotificationSettingsDialog)

	local RecruitmentDialog = CommunitiesFrame.RecruitmentDialog
	B.ReskinFrame(RecruitmentDialog)
	B.ReskinCheck(RecruitmentDialog.ShouldListClub.Button)
	B.ReskinCheck(RecruitmentDialog.MaxLevelOnly.Button)
	B.ReskinCheck(RecruitmentDialog.MinIlvlOnly.Button)
	B.ReskinDropDown(RecruitmentDialog.ClubFocusDropdown)
	B.ReskinDropDown(RecruitmentDialog.LookingForDropdown)
	B.ReskinDropDown(RecruitmentDialog.LanguageDropdown)
	B.ReskinInput(RecruitmentDialog.MinIlvlOnly.EditBox)
	B.ReskinButton(RecruitmentDialog.Accept)
	B.ReskinButton(RecruitmentDialog.Cancel)

	local RecruitmentMessageFrame = RecruitmentDialog.RecruitmentMessageFrame
	B.StripTextures(RecruitmentMessageFrame.RecruitmentMessageInput)
	B.ReskinScroll(RecruitmentMessageFrame.RecruitmentMessageInput.ScrollBar)
	B.ReskinInput(RecruitmentMessageFrame)

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
	B.ReskinDropDown(ClubFinderLanguageDropdown)
	B.ReskinDropDown(ClubFinderLookingForDropdown)

	local AvatarPickerDialog = CommunitiesAvatarPickerDialog
	B.ReskinFrame(AvatarPickerDialog)
	B.ReskinScroll(CommunitiesAvatarPickerDialogScrollBar)
	B.ReskinButton(AvatarPickerDialog.OkayButton)
	B.ReskinButton(AvatarPickerDialog.CancelButton)

	hooksecurefunc(AvatarPickerDialog.ScrollFrame, "Refresh", Reskin_AvatarPickerDialog)

	local TicketManagerDialog = CommunitiesTicketManagerDialog
	B.ReskinFrame(TicketManagerDialog)
	B.ReskinButton(TicketManagerDialog.LinkToChat)
	B.ReskinButton(TicketManagerDialog.Copy)
	B.ReskinArrow(TicketManagerDialog.MaximizeButton, "down")
	B.ReskinDropDown(TicketManagerDialog.ExpiresDropDownMenu)
	B.ReskinDropDown(TicketManagerDialog.UsesDropDownMenu)
	B.ReskinButton(TicketManagerDialog.GenerateLinkButton)

	TicketManagerDialog.InviteManager.ArtOverlay:Hide()
	B.StripTextures(TicketManagerDialog.InviteManager.ColumnDisplay)
	B.ReskinScroll(TicketManagerDialog.InviteManager.ListScrollFrame.scrollBar)

	hooksecurefunc(TicketManagerDialog, "Update", Reskin_TicketManagerDialog)

	-- RosterTab
	B.ReskinDropDown(CommunitiesFrame.GuildMemberListDropDownMenu)
	B.ReskinButton(CommunitiesFrame.CommunitiesControlFrame.GuildControlButton)
	B.ReskinDropDown(CommunitiesFrame.CommunityMemberListDropDownMenu)

	local ApplicantList = CommunitiesFrame.ApplicantList
	B.StripTextures(ApplicantList)
	B.StripTextures(ApplicantList.ColumnDisplay)
	B.ReskinScroll(ApplicantList.ListScrollFrame.scrollBar)
	ApplicantList.bg = B.CreateBGFrame(ApplicantList, 0, 0, -15, 0)
	hooksecurefunc(ApplicantList, "BuildList", Reskin_ApplicantList)

	-- GuildBenefitsTab
	local GuildBenefitsFrame = CommunitiesFrame.GuildBenefitsFrame
	B.StripTextures(GuildBenefitsFrame)
	B.StripTextures(GuildBenefitsFrame.Perks)
	B.StripTextures(GuildBenefitsFrame.Rewards)
	B.ReskinScroll(CommunitiesFrameRewards.scrollBar)

	local factionFrameBar = GuildBenefitsFrame.FactionFrame.Bar
	B.StripTextures(factionFrameBar)
	factionFrameBar.Progress:SetTexture(DB.normTex)
	factionFrameBar.Progress:SetVertexColor(cr, cg, cb, C.alpha)
	factionFrameBar.Label:ClearAllPoints()
	factionFrameBar.Label:SetPoint("CENTER", factionFrameBar.BG)
	local bg = B.CreateBDFrame(factionFrameBar)
	bg:SetPoint("TOPLEFT", factionFrameBar.Left, 0, -(C.mult*2))
	bg:SetPoint("BOTTOMRIGHT", factionFrameBar.Right, -(C.mult*2), C.mult*2)

	hooksecurefunc("CommunitiesGuildPerks_Update", Reskin_GuildPerks)
	hooksecurefunc("CommunitiesGuildRewards_Update", Reskin_GuildRewards)

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

	B.CreateBDFrame(CommunitiesFrameGuildDetailsFrameInfo.DetailsFrame)
	B.CreateBGFrame(CommunitiesFrameGuildDetailsFrameInfoMOTDScrollFrame, 0, 3, 0, -4)

	local BossModel = CommunitiesFrameGuildDetailsFrameNews.BossModel
	BossModel:ClearAllPoints()
	BossModel:SetPoint("LEFT", CommunitiesFrame, "RIGHT", 40, 0)

	local TextFrame = BossModel.TextFrame
	B.StripTextures(TextFrame)

	local bossBG = B.ReskinFrame(BossModel)
	bossBG:SetOutside(BossModel, C.mult, C.mult, TextFrame)

	local FiltersFrame = CommunitiesGuildNewsFiltersFrame
	B.ReskinFrame(FiltersFrame)

	local filters = {
		"Achievement",
		"DungeonEncounter",
		"EpicItemCrafted",
		"EpicItemLooted",
		"EpicItemPurchased",
		"GuildAchievement",
		"LegendaryItemLooted",
	}
	for _, name in pairs(filters) do
		local filter = FiltersFrame[name]
		B.ReskinCheck(filter)
	end

	FiltersFrame:HookScript("OnShow", Update_FrameAnchor)
	hooksecurefunc("GuildNewsButton_SetNews", Reskin_GuildNewsButton)
end