local F, C = unpack(select(2, ...))

C.themes["Blizzard_GuildUI"] = function()
	local cr, cg, cb = C.r, C.g, C.b

	F.ReskinFrame(GuildFrame)
	F.SetupTabStyle(GuildFrame, 5)

	for _, frame in pairs({GuildNewsFiltersFrame, GuildTextEditFrame, GuildLogFrame, GuildMemberDetailFrame}) do
		F.ReskinFrame(frame)
	end

	local frames = {GuildMemberNoteBackground, GuildMemberOfficerNoteBackground, GuildLogContainer, GuildTextEditContainer, GuildRecruitmentInterestFrame, GuildRecruitmentAvailabilityFrame, GuildRecruitmentRolesFrame, GuildRecruitmentLevelFrame, GuildInfoFrameInfoMOTDScrollFrame, GuildInfoDetailsFrame}
	for _, frame in pairs(frames) do
		F.StripTextures(frame, true)
		F.CreateBDFrame(frame, 0)
	end

	local lists = {GuildNewsFrame, GuildAllPerksFrame, GuildRewardsFrame, GuildInfoFrameInfo}
	for _, list in pairs(lists) do
		F.StripTextures(list)
	end

	local scrolls = {GuildPerksContainerScrollBar, GuildRosterContainerScrollBar, GuildNewsContainerScrollBar, GuildRewardsContainerScrollBar, GuildInfoFrameInfoMOTDScrollFrameScrollBar, GuildInfoDetailsFrameScrollBar, GuildLogScrollFrameScrollBar, GuildTextEditScrollFrameScrollBar, GuildRecruitmentCommentInputFrameScrollFrameScrollBar, GuildInfoFrameApplicantsContainerScrollBar}
	for _, scroll in pairs(scrolls) do
		F.ReskinScroll(scroll)
	end

	local TextEditFrameCB = select(4, GuildTextEditFrame:GetChildren())
	local LogFrameCB = select(3, GuildLogFrame:GetChildren())
	local buttons = {GuildAddMemberButton, GuildViewLogButton, GuildControlButton, GuildTextEditFrameAcceptButton, GuildMemberGroupInviteButton, GuildMemberRemoveButton, GuildRecruitmentInviteButton, GuildRecruitmentMessageButton, GuildRecruitmentDeclineButton, GuildRecruitmentListGuildButton, TextEditFrameCB, LogFrameCB}
	for _, button in pairs(buttons) do
		F.ReskinButton(button)
	end

	--News
	F.StripTextures(GuildFactionBar)
	F.CreateBDFrame(GuildFactionBarBG, 0)
	GuildFactionBar:ClearAllPoints()
	GuildFactionBar:SetPoint("BOTTOMLEFT", 0, -3)
	GuildFactionBarProgress:SetTexture(C.media.normTex)
	GuildFactionBarProgress:SetVertexColor(cr, cg, cb, .8)
	GuildFactionBarLabel:ClearAllPoints()
	GuildFactionBarLabel:SetPoint("CENTER", GuildFactionBarBG)

	GuildNewsFiltersFrame:ClearAllPoints()
	GuildNewsFiltersFrame:SetPoint("TOPLEFT", GuildFrame, "TOPRIGHT", 3, -25)
	for i = 1, 7 do
		F.ReskinCheck(GuildNewsFiltersFrame.GuildNewsFilterButtons[i])
	end

	hooksecurefunc("GuildNewsButton_SetNews", function(button)
		if button.header:IsShown() then
			button.header:SetAlpha(0)
		end
	end)

	--Roster
	F.ReskinDropDown(GuildRosterViewDropdown)

	GuildRosterShowOfflineButton:SetSize(24, 24)
	F.ReskinCheck(GuildRosterShowOfflineButton)

	for i = 1, 5 do
		local bu = _G["GuildRosterColumnButton"..i]
		F.StripTextures(bu)

		local bubg = F.CreateBDFrame(bu, 0, -C.pixel)
		F.ReskinTexture(bu, bubg, true)
	end

	hooksecurefunc("GuildRoster_UpdateTradeSkills", function()
		local buttons = GuildRosterContainer.buttons
		for i = 1, #buttons do
			local button = buttons[i]
			local string = button.string1
			local header = button.header

			local index = HybridScrollFrame_GetOffset(GuildRosterContainer) + i
			local headerName = select(3, GetGuildTradeSkillInfo(index))
			if headerName then
				string:Hide()
			else
				string:Show()
			end

			if header and not header.styled then
				F.StripTextures(header)
				F.ReskinIcon(header.icon, true)

				local bg = F.CreateBDFrame(header, 0, -C.pixel)
				F.ReskinTexture(header, bg, true)

				header.styled = true
			end
		end
	end)

	local function UpdateIcons()
		local index
		local offset = HybridScrollFrame_GetOffset(GuildRosterContainer)
		local totalMembers, _, onlineAndMobileMembers = GetNumGuildMembers()
		local visibleMembers = onlineAndMobileMembers
		local numbuttons = #GuildRosterContainer.buttons
		if GetGuildRosterShowOffline() then
			visibleMembers = totalMembers
		end

		for i = 1, numbuttons do
			local button = GuildRosterContainer.buttons[i]

			if not button.bg then
				button:SetHighlightTexture(C.media.bdTex)
				button:GetHighlightTexture():SetVertexColor(cr, cg, cb, .25)

				button.bg = F.ReskinIcon(button.icon, true)
			end

			index = offset + i
			local name, _, _, _, _, _, _, _, _, _, classFileName = GetGuildRosterInfo(index)
			if name and index <= visibleMembers and button.icon:IsShown() then
				local tcoords = CLASS_ICON_TCOORDS[classFileName]
				button.icon:SetTexCoord(tcoords[1] + 0.022, tcoords[2] - 0.025, tcoords[3] + 0.022, tcoords[4] - 0.025)
				button.bg:Show()
			else
				button.bg:Hide()
			end
		end
	end

	hooksecurefunc("GuildRoster_Update", UpdateIcons)
	hooksecurefunc(GuildRosterContainer, "update", UpdateIcons)

	-- Font width fix
	local function updateLevelString(view)
		local buttons = GuildRosterContainer.buttons

		for i = 1, #buttons do
			local button = buttons[i]

			if view == "playerStatus" or view == "reputation" or view == "achievement" then
				local string = button.string1
				string:SetWidth(32)
				string:SetJustifyH("LEFT")

				local icon = button.icon
				icon:ClearAllPoints()
				icon:SetPoint("LEFT", 43, 0)
			end

			if view == "achievement" then
				local label = button.barLabel
				label:SetWidth(60)
				label:SetJustifyH("LEFT")
			end
		end
	end

	GuildRosterContainer:HookScript("OnShow", function(self)
		if not self.styled then
			updateLevelString(GetCVar("guildRosterView"))

			self.styled = true
		end
	end)
	hooksecurefunc("GuildRoster_SetView", updateLevelString)

	--Perks
	hooksecurefunc("GuildPerks_Update", function()
		local buttons = GuildPerksContainer.buttons
		for i = 1, #buttons do
			local button = buttons[i]
			if button and not button.styled then
				F.StripTextures(button)

				local icbg = F.ReskinIcon(button.icon)
				local bubg = F.CreateBDFrame(button, 0)
				bubg:SetPoint("TOPLEFT", icbg, "TOPRIGHT", 2, 0)
				bubg:SetPoint("BOTTOMRIGHT", 0, 1)
				F.ReskinTexture(button, bubg, true)

				button.styled = true
			end
		end
	end)

	--Rewards
	hooksecurefunc("GuildRewards_Update", function()
		local buttons = GuildRewardsContainer.buttons
		for i = 1, #buttons do
			local button = buttons[i]
			if button and not button.styled then
				F.StripTextures(button)
				F.ReskinIcon(button.icon)

				local bubg = F.CreateBDFrame(button, 0, -C.pixel)
				F.ReskinTexture(button, bubg, true)

				button.styled = true
			end
		end
	end)

	--Info
	for i = 1, 3 do
		F.StripTextures(_G["GuildInfoFrameTab"..i])
	end

	-- Recruitment
	GuildRecruitmentCommentEditBox:SetWidth(284)
	local CommentFrame = GuildRecruitmentCommentFrame
	F.StripTextures(CommentFrame, true)

	local CommentInputFrame = GuildRecruitmentCommentInputFrame
	CommentInputFrame:SetAllPoints(CommentFrame)
	F.StripTextures(CommentInputFrame)
	F.CreateBDFrame(CommentInputFrame, 0)

	F.ReskinRole(GuildRecruitmentTankButton, "TANK")
	F.ReskinRole(GuildRecruitmentHealerButton, "HEALER")
	F.ReskinRole(GuildRecruitmentDamagerButton, "DPS")

	local checks = {GuildRecruitmentQuestButton, GuildRecruitmentDungeonButton, GuildRecruitmentRaidButton, GuildRecruitmentPvPButton, GuildRecruitmentRPButton, GuildRecruitmentWeekdaysButton, GuildRecruitmentWeekendsButton}
	for _, check in pairs(checks) do
		F.ReskinCheck(check)
	end

	F.ReskinRadio(GuildRecruitmentLevelAnyButton)
	F.ReskinRadio(GuildRecruitmentLevelMaxButton)
end