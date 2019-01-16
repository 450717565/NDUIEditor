local F, C = unpack(select(2, ...))

C.themes["Blizzard_GuildRecruitmentUI"] = function()
	local r, g, b = C.r, C.g, C.b

	F.ReskinPortraitFrame(CommunitiesGuildRecruitmentFrame, true)
	F.StripTextures(CommunitiesGuildRecruitmentFrameTab1, true)
	F.StripTextures(CommunitiesGuildRecruitmentFrameTab2, true)
	F.Reskin(CommunitiesGuildRecruitmentFrameRecruitment.ListGuildButton)

	for _, name in next, {"InterestFrame", "AvailabilityFrame", "RolesFrame", "LevelFrame"} do
		local frame = CommunitiesGuildRecruitmentFrameRecruitment[name]
		F.StripTextures(frame, true)
		F.CreateBDFrame(frame, .25)
	end

	for _, name in next, {"QuestButton", "DungeonButton", "RaidButton", "PvPButton", "RPButton"} do
		local button = CommunitiesGuildRecruitmentFrameRecruitment.InterestFrame[name]
		F.ReskinCheck(button)
	end

	local rolesFrame = CommunitiesGuildRecruitmentFrameRecruitment.RolesFrame
	for _, button in next, {rolesFrame.TankButton, rolesFrame.HealerButton, rolesFrame.DamagerButton} do
		F.ReskinCheck(button.checkButton)
	end

	CommunitiesGuildRecruitmentFrameRecruitmentScrollFrame.CommentEditBox:SetWidth(284)

	local recruitment = CommunitiesGuildRecruitmentFrameRecruitment
	F.StripTextures(recruitment.CommentFrame, true)
	recruitment.CommentFrame:ClearAllPoints()
	recruitment.CommentFrame:SetPoint("TOPLEFT", recruitment.LevelFrame, "BOTTOMLEFT", 0, 1)

	local input = recruitment.CommentFrame.CommentInputFrame
	input:SetWidth(312)
	F.StripTextures(input, true)
	F.CreateBDFrame(input, .25)

	F.ReskinCheck(CommunitiesGuildRecruitmentFrameRecruitment.AvailabilityFrame.WeekdaysButton)
	F.ReskinCheck(CommunitiesGuildRecruitmentFrameRecruitment.AvailabilityFrame.WeekendsButton)
	F.ReskinRadio(CommunitiesGuildRecruitmentFrameRecruitment.LevelFrame.LevelAnyButton)
	F.ReskinRadio(CommunitiesGuildRecruitmentFrameRecruitment.LevelFrame.LevelMaxButton)
	F.ReskinScroll(CommunitiesGuildRecruitmentFrameRecruitmentScrollFrameScrollBar)
	F.ReskinScroll(CommunitiesGuildRecruitmentFrameApplicantsContainer.scrollBar)
	F.Reskin(CommunitiesGuildRecruitmentFrameApplicants.InviteButton)
	F.Reskin(CommunitiesGuildRecruitmentFrameApplicants.MessageButton)
	F.Reskin(CommunitiesGuildRecruitmentFrameApplicants.DeclineButton)

	hooksecurefunc("CommunitiesGuildRecruitmentFrameApplicants_Update", function(self)
		local buttons = self.Container.buttons
		for i = 1, #buttons do
			local button = buttons[i]
			if not button.bg then
				for i = 1, 9 do
					select(i, button:GetRegions()):Hide()
				end
				button.bg = F.CreateBDFrame(button, .25)
				button.bg:SetPoint("TOPLEFT", 3, -3)
				button.bg:SetPoint("BOTTOMRIGHT", -3, 3)

				F.ReskinTexture(button, button.bg, true)
				F.ReskinTexture(button.selectedTex, button.bg, true)
			end
		end
	end)
end