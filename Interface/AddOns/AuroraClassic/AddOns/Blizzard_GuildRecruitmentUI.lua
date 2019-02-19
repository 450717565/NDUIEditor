local F, C = unpack(select(2, ...))

C.themes["Blizzard_GuildRecruitmentUI"] = function()
	F.ReskinFrame(CommunitiesGuildRecruitmentFrame)

	F.StripTextures(CommunitiesGuildRecruitmentFrameTab1)
	F.StripTextures(CommunitiesGuildRecruitmentFrameTab2)

	F.ReskinScroll(CommunitiesGuildRecruitmentFrameRecruitmentScrollFrameScrollBar)
	CommunitiesGuildRecruitmentFrameRecruitmentScrollFrame.CommentEditBox:SetWidth(284)

	local recruitment = CommunitiesGuildRecruitmentFrameRecruitment
	F.ReskinButton(recruitment.ListGuildButton)

	for _, name in next, {"InterestFrame", "AvailabilityFrame", "RolesFrame", "LevelFrame"} do
		local frame = recruitment[name]
		F.StripTextures(frame, true)
		F.CreateBDFrame(frame, 0)
	end

	for _, name in next, {"QuestButton", "DungeonButton", "RaidButton", "PvPButton", "RPButton"} do
		local button = recruitment.InterestFrame[name]
		F.ReskinCheck(button)
	end

	for _, name in next, {"WeekdaysButton", "WeekendsButton"} do
		local button = recruitment.AvailabilityFrame[name]
		F.ReskinCheck(button)
	end

	for _, name in next, {"TankButton", "HealerButton", "DamagerButton"} do
		local button = recruitment.RolesFrame[name]
		F.ReskinCheck(button.checkButton)
	end

	for _, name in next, {"LevelAnyButton", "LevelMaxButton"} do
		local button = recruitment.LevelFrame[name]
		F.ReskinRadio(button)
	end

	local RolesFrame = recruitment.RolesFrame
	F.ReskinRole(RolesFrame.TankButton, "TANK")
	F.ReskinRole(RolesFrame.HealerButton, "HEALER")
	F.ReskinRole(RolesFrame.DamagerButton, "DPS")

	local CommentFrame = recruitment.CommentFrame
	F.StripTextures(CommentFrame, true)

	local CommentInputFrame = CommentFrame.CommentInputFrame
	CommentInputFrame:SetAllPoints(CommentFrame)
	F.StripTextures(CommentInputFrame)
	F.CreateBDFrame(CommentInputFrame, 0)

	F.ReskinScroll(CommunitiesGuildRecruitmentFrameApplicantsContainer.scrollBar)
	local Applicants = CommunitiesGuildRecruitmentFrameApplicants
	F.ReskinButton(Applicants.InviteButton)
	F.ReskinButton(Applicants.MessageButton)
	F.ReskinButton(Applicants.DeclineButton)

	hooksecurefunc("CommunitiesGuildRecruitmentFrameApplicants_Update", function(self)
		local buttons = self.Container.buttons
		for i = 1, #buttons do
			local button = buttons[i]
			if not button.styled then
				F.StripTextures(button)

				local bubg = F.CreateBDFrame(button, 0)
				bubg:SetPoint("TOPLEFT", 3, -3)
				bubg:SetPoint("BOTTOMRIGHT", -3, 3)

				F.ReskinTexture(button, bubg, true)
				F.ReskinTexture(button.selectedTex, bubg, true)

				button.styled = true
			end
		end
	end)
end