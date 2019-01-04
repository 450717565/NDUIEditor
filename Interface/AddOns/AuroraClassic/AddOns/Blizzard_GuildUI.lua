local F, C = unpack(select(2, ...))

C.themes["Blizzard_GuildUI"] = function()
	local r, g, b = C.r, C.g, C.b

	local bdsds = {GuildFrame, GuildNewsFiltersFrame, GuildTextEditFrame, GuildLogFrame}
	for _, bdsd in next, bdsds do
		F.StripTextures(bdsd, true)
		F.CreateBD(bdsd)
		F.CreateSD(bdsd)
	end

	local closes = {GuildFrameCloseButton, GuildNewsFiltersFrameCloseButton, GuildLogFrameCloseButton, GuildMemberDetailCloseButton, GuildTextEditFrameCloseButton}
	for _, close in next, closes do
		F.StripTextures(close, true)
		F.ReskinClose(close)
	end

	local frames = {GuildMemberDetailFrame, GuildMemberNoteBackground, GuildMemberOfficerNoteBackground, GuildLogContainer, GuildTextEditContainer, GuildRecruitmentInterestFrame, GuildRecruitmentAvailabilityFrame, GuildRecruitmentRolesFrame, GuildRecruitmentLevelFrame, GuildInfoFrameInfoMOTDScrollFrame, GuildInfoDetailsFrame, GuildRecruitmentCommentInputFrame}
	for _, frame in next, frames do
		F.StripTextures(frame, true)
		F.CreateBDFrame(frame, .25)
	end

	for i = 1, 5 do
		F.ReskinTab(_G["GuildFrameTab"..i])
	end
	if GetLocale() == "zhTW" then
		GuildFrameTab1:ClearAllPoints()
		GuildFrameTab1:SetPoint("TOPLEFT", GuildFrame, "BOTTOMLEFT", -7, 2)
	end
	GuildFrameTabardBackground:Hide()
	GuildFrameTabardEmblem:Hide()
	GuildFrameTabardBorder:Hide()

	F.StripTextures(GuildFrameInset, true)
	F.StripTextures(GuildNewsFrame, true)
	F.StripTextures(GuildAllPerksFrame, true)
	F.StripTextures(GuildRewardsFrame, true)
	F.StripTextures(GuildInfoFrameInfo, true)

	GuildMemberRankDropdown:HookScript("OnShow", function()
		GuildMemberDetailRankText:Hide()
	end)
	GuildMemberRankDropdown:HookScript("OnHide", function()
		GuildMemberDetailRankText:Show()
	end)

	hooksecurefunc("GuildNews_Update", function()
		local buttons = GuildNewsContainer.buttons
		for i = 1, #buttons do
			buttons[i].header:SetAlpha(0)
		end
	end)

	local scrolls = {GuildPerksContainerScrollBar, GuildRosterContainerScrollBar, GuildNewsContainerScrollBar, GuildRewardsContainerScrollBar, GuildInfoFrameInfoMOTDScrollFrameScrollBar, GuildInfoDetailsFrameScrollBar, GuildLogScrollFrameScrollBar, GuildTextEditScrollFrameScrollBar, GuildRecruitmentCommentInputFrameScrollFrameScrollBar, GuildInfoFrameApplicantsContainerScrollBar}
	for _, scroll in next, scrolls do
		F.ReskinScroll(scroll)
	end

	F.ReskinDropDown(GuildRosterViewDropdown)
	F.ReskinDropDown(GuildMemberRankDropdown)

	GuildInfoFrameInfoMOTDScrollFrameScrollBar:SetAlpha(0)
	GuildRecruitmentCommentFrameBg:Hide()
	GuildRecruitmentCommentInputFrame:SetWidth(312)
	GuildRecruitmentCommentEditBox:SetWidth(284)
	GuildRecruitmentCommentFrame:ClearAllPoints()
	GuildRecruitmentCommentFrame:SetPoint("TOPLEFT", GuildRecruitmentLevelFrame, "BOTTOMLEFT", 0, 1)

	GuildRosterShowOfflineButton:SetSize(24, 24)
	F.ReskinCheck(GuildRosterShowOfflineButton)
	for i = 1, 7 do
		F.ReskinCheck(GuildNewsFiltersFrame.GuildNewsFilterButtons[i])
	end

	local a1, p, a2, x, y = GuildNewsBossModel:GetPoint()
	GuildNewsBossModel:ClearAllPoints()
	GuildNewsBossModel:SetPoint(a1, p, a2, x+5, y)

	local bg = F.CreateBDFrame(GuildNewsBossModel)
	bg:SetPoint("TOPLEFT", 0, 1)
	bg:SetPoint("BOTTOMRIGHT", 1, -52)

	local line = F.CreateBDFrame(GuildNewsBossModel, 0)
	line:ClearAllPoints()
	line:SetPoint("BOTTOMLEFT", 0, -1)
	line:SetPoint("BOTTOMRIGHT", 0, -1)
	line:SetHeight(C.mult)

	GuildNewsFiltersFrame:SetWidth(224)
	GuildNewsFiltersFrame:SetPoint("TOPLEFT", GuildFrame, "TOPRIGHT", 1, -20)
	GuildMemberDetailFrame:SetPoint("TOPLEFT", GuildFrame, "TOPRIGHT", 1, -28)
	GuildLogFrame:SetPoint("TOPLEFT", GuildFrame, "TOPRIGHT", 1, 0)
	GuildTextEditFrame:SetPoint("TOPLEFT", GuildFrame, "TOPRIGHT", 1, 0)

	for i = 1, 5 do
		local bu = _G["GuildInfoFrameApplicantsContainerButton"..i]

		bu:SetBackdrop(nil)
		bu:SetHighlightTexture("")

		local bg = F.CreateBDFrame(bu, .25)
		bg:SetPoint("TOPLEFT")
		bg:SetPoint("BOTTOMRIGHT")

		bu:GetRegions():SetTexture(C.media.bdTex)
		bu:GetRegions():SetVertexColor(r, g, b, .25)
	end

	F.StripTextures(GuildFactionBar)
	F.CreateBDFrame(GuildFactionBar, .25)
	GuildFactionBar:ClearAllPoints()
	GuildFactionBar:SetPoint("BOTTOMLEFT", 0, -3)
	GuildFactionBarProgress:SetTexture(C.media.normTex)
	GuildFactionBarProgress:SetVertexColor(r*.8, g*.8, b*.8)
	GuildFactionBarProgress:SetPoint("TOPLEFT")
	GuildFactionBarProgress:SetPoint("BOTTOMLEFT")

	for _, bu in pairs(GuildPerksContainer.buttons) do
		for i = 1, 4 do
			select(i, bu:GetRegions()):SetAlpha(0)
		end

		local ic = F.ReskinIcon(bu.icon, true)

		local bg = F.CreateBDFrame(bu, .25)
		bg:SetPoint("TOPLEFT", ic, "TOPRIGHT", 2, 0)
		bg:SetPoint("BOTTOMRIGHT", 0, 1)
		F.ReskinTexture(bu, true, bg)
	end
	GuildPerksContainerButton1:SetPoint("LEFT", -1, 0)

	hooksecurefunc("GuildRewards_Update", function()
		local buttons = GuildRewardsContainer.buttons
		for i = 1, #buttons do
			local bu = buttons[i]
			if not bu.bg then
				bu:SetNormalTexture("")
				bu.disabledBG:Hide()
				--bu.disabledBG.Show = F.dummy

				bu.bg = F.CreateBDFrame(bu, .25)
				bu.bg:SetPoint("TOPLEFT", C.mult, -C.mult)
				bu.bg:SetPoint("BOTTOMRIGHT", -C.mult, C.mult)

				F.ReskinTexture(bu, true, bu.bg)
				F.ReskinIcon(bu.icon, true)
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
			local bu = GuildRosterContainer.buttons[i]

			if not bu.bg then
				bu:SetHighlightTexture(C.media.bdTex)
				bu:GetHighlightTexture():SetVertexColor(r, g, b, .25)

				bu.bg = F.CreateBDFrame(bu.icon, .25)
			end

			index = offset + i
			local name, _, _, _, _, _, _, _, _, _, classFileName = GetGuildRosterInfo(index)
			if name and index <= visibleMembers and bu.icon:IsShown() then
				local tcoords = CLASS_ICON_TCOORDS[classFileName]
				bu.icon:SetTexCoord(tcoords[1] + 0.022, tcoords[2] - 0.025, tcoords[3] + 0.022, tcoords[4] - 0.025)
				bu.bg:Show()
			else
				bu.bg:Hide()
			end
		end
	end

	hooksecurefunc("GuildRoster_Update", UpdateIcons)
	hooksecurefunc(GuildRosterContainer, "update", UpdateIcons)

	local gbuttons = {GuildAddMemberButton, GuildViewLogButton, GuildControlButton, GuildTextEditFrameAcceptButton, GuildMemberGroupInviteButton, GuildMemberRemoveButton, GuildRecruitmentInviteButton, GuildRecruitmentMessageButton, GuildRecruitmentDeclineButton, GuildRecruitmentListGuildButton, select(4, GuildTextEditFrame:GetChildren()), select(3, GuildLogFrame:GetChildren())}
	for _, button in next, gbuttons do
		F.Reskin(button)
	end

	local checkboxes = {GuildRecruitmentQuestButton, GuildRecruitmentDungeonButton, GuildRecruitmentRaidButton, GuildRecruitmentPvPButton, GuildRecruitmentRPButton, GuildRecruitmentWeekdaysButton, GuildRecruitmentWeekendsButton, GuildRecruitmentTankButton:GetChildren(), GuildRecruitmentHealerButton:GetChildren(), GuildRecruitmentDamagerButton:GetChildren()}
	for _, check in next, checkboxes do
		F.ReskinCheck(check)
	end

	F.ReskinRadio(GuildRecruitmentLevelAnyButton)
	F.ReskinRadio(GuildRecruitmentLevelMaxButton)

	for i = 1, 3 do
		F.StripTextures(_G["GuildInfoFrameTab"..i], true)
	end

	for i = 1, 5 do
		local bu = _G["GuildRosterColumnButton"..i]

		local md = _G["GuildRosterColumnButton"..i.."Middle"]
		md:Hide()

		local hl = _G["GuildRosterColumnButton"..i.."HighlightTexture"]
		F.ReskinTexture(hl, true, bu)
	end

	-- Tradeskill View
	hooksecurefunc("GuildRoster_UpdateTradeSkills", function()
		local buttons = GuildRosterContainer.buttons
		for i = 1, #buttons do
			local index = HybridScrollFrame_GetOffset(GuildRosterContainer) + i
			local str = _G["GuildRosterContainerButton"..i.."String1"]
			local header = _G["GuildRosterContainerButton"..i.."HeaderButton"]
			if header then
				local _, _, _, headerName = GetGuildTradeSkillInfo(index)
				if headerName then
					str:Hide()
				else
					str:Show()
				end

				if not header.styled then
					F.ReskinIcon(header.icon)
					header.styled = true
				end

				if not header.bg then
					for j = 1, 3 do
						select(j, header:GetRegions()):Hide()
					end

					header.bg = F.CreateBDFrame(header, .25)
					header.bg:SetAllPoints()

					F.ReskinTexture(header, true, header.bg)
				end
			end
		end
	end)

	-- Font width fix
	local function updateLevelString(view)
		if view == "playerStatus" or view == "reputation" or view == "achievement" then
			local buttons = GuildRosterContainer.buttons
			for i = 1, #buttons do
				local str = _G["GuildRosterContainerButton"..i.."String1"]
				str:SetWidth(32)
				str:SetJustifyH("LEFT")

				local ic = _G["GuildRosterContainerButton"..i.."Icon"]
				ic:ClearAllPoints()
				ic:SetPoint("LEFT", 43, 0)
			end

			if view == "achievement" then
				for i = 1, #buttons do
					local str = _G["GuildRosterContainerButton"..i.."BarLabel"]
					str:SetWidth(60)
					str:SetJustifyH("LEFT")
				end
			end
		end
	end

	local done
	GuildRosterContainer:HookScript("OnShow", function()
		if not done then
			updateLevelString(GetCVar("guildRosterView"))
			done = true
		end
	end)
	hooksecurefunc("GuildRoster_SetView", updateLevelString)
end