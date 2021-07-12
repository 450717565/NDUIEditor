local _, ns = ...
local B, C, L, DB = unpack(ns)

local cr, cg, cb = DB.cr, DB.cg, DB.cb

local function Reskin_GuildNewsButton(button)
	if button.header:IsShown() then
		button.header:SetAlpha(0)
	end
end

local function Reskin_UpdateTradeSkills()
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
				B.StripTextures(HeaderButton, 6)
				B.ReskinIcon(HeaderButton.icon)

				local bg = B.CreateBDFrame(HeaderButton, 0, 1)
				B.ReskinHLTex(HeaderButton, bg, true)

				HeaderButton.styled = true
			end
		end
	end
end

local function Reskin_GuildRosterContainer()
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

		if not button.icbg then
			B.ReskinHLTex(button, nil, true)

			button.icbg = B.ReskinIcon(button.icon)
		end

		index = offset + i
		local name, _, _, _, _, _, _, _, _, _, classFileName = GetGuildRosterInfo(index)
		if name and index <= visibleMembers and button.icon:IsShown() then
			button.icon:SetTexCoord(B.GetClassTexCoord(classFileName))
			button.icbg:Show()
		else
			button.icbg:Hide()
		end
	end
end

local function Reskin_GuildPerks()
	local buttons = GuildPerksContainer.buttons
	for i = 1, #buttons do
		local button = buttons[i]
		if button and not button.styled then
			B.StripTextures(button)

			local icbg = B.ReskinIcon(button.icon)
			local bubg = B.CreateBGFrame(button, C.margin, 0, 0, 0, icbg)
			B.ReskinHLTex(button, bubg, true)

			button.styled = true
		end
	end
end

local function Reskin_GuildRewards()
	local buttons = GuildRewardsContainer.buttons
	for i = 1, #buttons do
		local button = buttons[i]
		if button and not button.styled then
			B.StripTextures(button)
			B.ReskinIcon(button.icon)

			local bubg = B.CreateBDFrame(button, 0, 1)
			B.ReskinHLTex(button, bubg, true)

			button.styled = true
		end
	end
end

local function Update_LevelString(view)
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

local function Fixed_LevelString(self)
	if not self.styled then
		Update_LevelString(GetCVar("guildRosterView"))

		self.styled = true
	end
end

C.OnLoadThemes["Blizzard_GuildUI"] = function()
	B.ReskinFrame(GuildFrame)
	B.ReskinFrameTab(GuildFrame, 5)

	GuildPointFrame.RightCap:Hide()
	GuildPointFrame.LeftCap:Hide()

	local frames_1 = {
		GuildLogFrame,
		GuildMemberDetailFrame,
		GuildNewsFiltersFrame,
		GuildTextEditFrame,
	}
	for _, frame in pairs(frames_1) do
		B.ReskinFrame(frame)

		if frame ~= GuildLogFrame then
			frame:ClearAllPoints()
			frame:SetPoint("TOPLEFT", GuildFrame, "TOPRIGHT", 3, -25)
		end
	end

	local frames_2 = {
		GuildInfoDetailsFrame,
		GuildInfoFrameInfoMOTDScrollFrame,
		GuildLogContainer,
		GuildMemberNoteBackground,
		GuildMemberOfficerNoteBackground,
		GuildRecruitmentAvailabilityFrame,
		GuildRecruitmentInterestFrame,
		GuildRecruitmentLevelFrame,
		GuildRecruitmentRolesFrame,
		GuildTextEditContainer,
	}
	for _, frame in pairs(frames_2) do
		B.StripTextures(frame)
		B.CreateBDFrame(frame)
	end

	local lists = {
		GuildAllPerksFrame,
		GuildInfoFrameInfo,
		GuildNewsFrame,
		GuildRewardsFrame,
	}
	for _, list in pairs(lists) do
		B.StripTextures(list)
	end

	local scrolls = {
		GuildInfoDetailsFrameScrollBar,
		GuildInfoFrameApplicantsContainerScrollBar,
		GuildInfoFrameInfoMOTDScrollFrameScrollBar,
		GuildLogScrollFrameScrollBar,
		GuildNewsContainerScrollBar,
		GuildPerksContainerScrollBar,
		GuildRecruitmentCommentInputFrameScrollFrameScrollBar,
		GuildRewardsContainerScrollBar,
		GuildRosterContainerScrollBar,
		GuildTextEditScrollFrameScrollBar,
	}
	for _, scroll in pairs(scrolls) do
		B.ReskinScroll(scroll)
	end

	local TextEditFrameCB = select(4, GuildTextEditFrame:GetChildren())
	local LogFrameCB = select(3, GuildLogFrame:GetChildren())
	local buttons = {
		GuildAddMemberButton,
		GuildControlButton,
		GuildMemberGroupInviteButton,
		GuildMemberRemoveButton,
		GuildRecruitmentDeclineButton,
		GuildRecruitmentInviteButton,
		GuildRecruitmentListGuildButton,
		GuildRecruitmentMessageButton,
		GuildTextEditFrameAcceptButton,
		GuildViewLogButton,
		LogFrameCB,
		TextEditFrameCB,
	}
	for _, button in pairs(buttons) do
		B.ReskinButton(button)
	end

	--News
	B.StripTextures(GuildFactionBar)
	B.CreateBDFrame(GuildFactionBarBG)
	GuildFactionBar:SetSize(180, 20)
	GuildFactionBar:ClearAllPoints()
	GuildFactionBar:SetPoint("BOTTOMLEFT", 0, -3)
	GuildFactionBarProgress:SetTexture(DB.normTex)
	GuildFactionBarProgress:SetVertexColor(cr, cg, cb, C.alpha)
	GuildFactionBarLabel:ClearAllPoints()
	GuildFactionBarLabel:SetPoint("CENTER", GuildFactionBarBG)

	for i = 1, 7 do
		B.ReskinCheck(GuildNewsFiltersFrame.GuildNewsFilterButtons[i])
	end

	hooksecurefunc("GuildNewsButton_SetNews", Reskin_GuildNewsButton)

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
		local button = _G["GuildRosterColumnButton"..i]
		B.StripTextures(button)

		local bubg = B.CreateBDFrame(button, 0, 2)
		B.ReskinHLTex(button, bubg, true)
	end

	hooksecurefunc(GuildRosterContainer, "update", Reskin_GuildRosterContainer)
	hooksecurefunc("GuildRoster_UpdateTradeSkills", Reskin_UpdateTradeSkills)
	hooksecurefunc("GuildRoster_Update", Reskin_GuildRosterContainer)
	hooksecurefunc("GuildRoster_SetView", Update_LevelString)
	GuildRosterContainer:HookScript("OnShow", Fixed_LevelString)

	--Perks
	hooksecurefunc("GuildPerks_Update", Reskin_GuildPerks)

	--Rewards
	hooksecurefunc("GuildRewards_Update", Reskin_GuildRewards)

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
	B.CreateBDFrame(CommentInputFrame)

	B.ReskinRole(GuildRecruitmentTankButton, "TANK")
	B.ReskinRole(GuildRecruitmentHealerButton, "HEALER")
	B.ReskinRole(GuildRecruitmentDamagerButton, "DPS")

	local checks = {
		GuildRecruitmentQuestButton,
		GuildRecruitmentDungeonButton,
		GuildRecruitmentRaidButton,
		GuildRecruitmentPvPButton,
		GuildRecruitmentRPButton,
		GuildRecruitmentWeekdaysButton,
		GuildRecruitmentWeekendsButton,
	}
	for _, check in pairs(checks) do
		B.ReskinCheck(check)
	end

	B.ReskinRadio(GuildRecruitmentLevelAnyButton)
	B.ReskinRadio(GuildRecruitmentLevelMaxButton)
end