local B, C, L, DB = unpack(select(2, ...))

C.themes["Blizzard_GuildUI"] = function()
	local cr, cg, cb = DB.r, DB.g, DB.b

	B.ReskinFrame(GuildFrame)
	B.SetupTabStyle(GuildFrame, 5)

	GuildPointFrame.RightCap:Hide()
	GuildPointFrame.LeftCap:Hide()

	for _, frame in pairs({GuildNewsFiltersFrame, GuildTextEditFrame, GuildLogFrame, GuildMemberDetailFrame}) do
		B.ReskinFrame(frame)

		if frame ~= GuildLogFrame then
			frame:ClearAllPoints()
			frame:SetPoint("TOPLEFT", GuildFrame, "TOPRIGHT", 3, -25)
		end
	end

	local frames = {GuildMemberNoteBackground, GuildMemberOfficerNoteBackground, GuildLogContainer, GuildTextEditContainer, GuildRecruitmentInterestFrame, GuildRecruitmentAvailabilityFrame, GuildRecruitmentRolesFrame, GuildRecruitmentLevelFrame, GuildInfoFrameInfoMOTDScrollFrame, GuildInfoDetailsFrame}
	for _, frame in pairs(frames) do
		B.StripTextures(frame)
		B.CreateBDFrame(frame, 0)
	end

	local lists = {GuildNewsFrame, GuildAllPerksFrame, GuildRewardsFrame, GuildInfoFrameInfo}
	for _, list in pairs(lists) do
		B.StripTextures(list)
	end

	local scrolls = {GuildPerksContainerScrollBar, GuildRosterContainerScrollBar, GuildNewsContainerScrollBar, GuildRewardsContainerScrollBar, GuildInfoFrameInfoMOTDScrollFrameScrollBar, GuildInfoDetailsFrameScrollBar, GuildLogScrollFrameScrollBar, GuildTextEditScrollFrameScrollBar, GuildRecruitmentCommentInputFrameScrollFrameScrollBar, GuildInfoFrameApplicantsContainerScrollBar}
	for _, scroll in pairs(scrolls) do
		B.ReskinScroll(scroll)
	end

	local TextEditFrameCB = select(4, GuildTextEditFrame:GetChildren())
	local LogFrameCB = select(3, GuildLogFrame:GetChildren())
	local buttons = {GuildAddMemberButton, GuildViewLogButton, GuildControlButton, GuildTextEditFrameAcceptButton, GuildMemberGroupInviteButton, GuildMemberRemoveButton, GuildRecruitmentInviteButton, GuildRecruitmentMessageButton, GuildRecruitmentDeclineButton, GuildRecruitmentListGuildButton, TextEditFrameCB, LogFrameCB}
	for _, button in pairs(buttons) do
		B.ReskinButton(button)
	end

	--News
	B.StripTextures(GuildFactionBar)
	B.CreateBDFrame(GuildFactionBarBG, 0)
	GuildFactionBar:SetSize(180, 20)
	GuildFactionBar:ClearAllPoints()
	GuildFactionBar:SetPoint("BOTTOMLEFT", 0, -3)
	GuildFactionBarProgress:SetTexture(DB.normTex)
	GuildFactionBarProgress:SetVertexColor(cr, cg, cb, DB.Alpha)
	GuildFactionBarLabel:ClearAllPoints()
	GuildFactionBarLabel:SetPoint("CENTER", GuildFactionBarBG)

	for i = 1, 7 do
		B.ReskinCheck(GuildNewsFiltersFrame.GuildNewsFilterButtons[i])
	end

	hooksecurefunc("GuildNewsButton_SetNews", function(button)
		if button.header:IsShown() then
			button.header:SetAlpha(0)
		end
	end)

	B.StripTextures(GuildNewsBossModelTextFrame)

	GuildNewsBossModel:ClearAllPoints()
	GuildNewsBossModel:SetPoint("LEFT", GuildFrame, "RIGHT", 5, 0)

	local bg = B.ReskinFrame(GuildNewsBossModel)
	bg:SetOutside(GuildNewsBossModel, C.mult, C.mult, GuildNewsBossModelTextFrame)

	--Roster
	B.ReskinDropDown(GuildRosterViewDropdown)
	B.ReskinDropDown(GuildMemberRankDropdown)
	B.ReskinClose(GuildMemberDetailCloseButton)
	B.ReskinCheck(GuildRosterShowOfflineButton)

	GuildMemberRankDropdownText:Hide()
	GuildRosterShowOfflineButton:SetSize(24, 24)

	for i = 1, 5 do
		local bu = _G["GuildRosterColumnButton"..i]
		B.StripTextures(bu)

		local bubg = B.CreateBDFrame(bu, 0, -C.mult*2)
		B.ReskinHighlight(bu, bubg, true)
	end

	hooksecurefunc("GuildRoster_UpdateTradeSkills", function()
		local buttons = GuildRosterContainer.buttons
		for i = 1, #buttons do
			local index = HybridScrollFrame_GetOffset(GuildRosterContainer) + i
			local String1 = _G["GuildRosterContainerButton"..i.."String1"]
			local String3 = _G["GuildRosterContainerButton"..i.."String3"]
			local HeaderButton = _G["GuildRosterContainerButton"..i.."HeaderButton"]

			if HeaderButton then
				local headerName = select(3, GetGuildTradeSkillInfo(index))
				if headerName then
					String1:Hide()
					String3:Hide()
				else
					String1:Show()
					String3:Show()
				end

				if not HeaderButton.styled then
					B.StripTextures(HeaderButton)
					B.ReskinIcon(HeaderButton.icon)

					local bg = B.CreateBDFrame(HeaderButton, 0, -C.mult*2)
					B.ReskinHighlight(HeaderButton, bg, true)

					HeaderButton.styled = true
				end
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
				button:SetHighlightTexture(DB.bdTex)
				button:GetHighlightTexture():SetVertexColor(cr, cg, cb, .25)

				button.bg = B.ReskinIcon(button.icon)
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
		if view == "playerStatus" or view == "reputation" or view == "achievement" then
			local buttons = GuildRosterContainer.buttons
			for i = 1, #buttons do
				local String1 = _G["GuildRosterContainerButton"..i.."String1"]
				String1:SetWidth(32)
				String1:SetJustifyH("LEFT")
				String1:ClearAllPoints()
				String1:SetPoint("LEFT", 3, 0)

				local Icon = _G["GuildRosterContainerButton"..i.."Icon"]
				Icon:ClearAllPoints()
				Icon:SetPoint("LEFT", 43, 0)

				if view == "achievement" then
					local BarLabel = _G["GuildRosterContainerButton"..i.."BarLabel"]
					BarLabel:SetWidth(60)
					BarLabel:SetJustifyH("LEFT")
				end
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
				B.StripTextures(button)

				local icbg = B.ReskinIcon(button.icon)
				local bubg = B.CreateBG(button, icbg, 2)
				B.ReskinHighlight(button, bubg, true)

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
				B.StripTextures(button)
				B.ReskinIcon(button.icon)

				local bubg = B.CreateBDFrame(button, 0, -C.mult*2)
				B.ReskinHighlight(button, bubg, true)

				button.styled = true
			end
		end
	end)

	--Info
	for i = 1, 3 do
		B.StripTextures(_G["GuildInfoFrameTab"..i])
	end

	-- Recruitment
	GuildRecruitmentCommentEditBox:SetWidth(284)
	local CommentFrame = GuildRecruitmentCommentFrame
	B.StripTextures(CommentFrame)

	local CommentInputFrame = GuildRecruitmentCommentInputFrame
	CommentInputFrame:SetAllPoints(CommentFrame)
	B.StripTextures(CommentInputFrame)
	B.CreateBDFrame(CommentInputFrame, 0)

	B.ReskinRole(GuildRecruitmentTankButton, "TANK")
	B.ReskinRole(GuildRecruitmentHealerButton, "HEALER")
	B.ReskinRole(GuildRecruitmentDamagerButton, "DPS")

	local checks = {GuildRecruitmentQuestButton, GuildRecruitmentDungeonButton, GuildRecruitmentRaidButton, GuildRecruitmentPvPButton, GuildRecruitmentRPButton, GuildRecruitmentWeekdaysButton, GuildRecruitmentWeekendsButton}
	for _, check in pairs(checks) do
		B.ReskinCheck(check)
	end

	B.ReskinRadio(GuildRecruitmentLevelAnyButton)
	B.ReskinRadio(GuildRecruitmentLevelMaxButton)
end