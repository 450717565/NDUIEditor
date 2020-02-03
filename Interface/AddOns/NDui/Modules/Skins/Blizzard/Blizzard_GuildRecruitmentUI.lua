local B, C, L, DB = unpack(select(2, ...))

C.themes["Blizzard_GuildRecruitmentUI"] = function()
	B.ReskinFrame(CommunitiesGuildRecruitmentFrame)

	B.StripTextures(CommunitiesGuildRecruitmentFrameTab1)
	B.StripTextures(CommunitiesGuildRecruitmentFrameTab2)

	B.ReskinScroll(CommunitiesGuildRecruitmentFrameRecruitmentScrollFrameScrollBar)


	local recruitment = CommunitiesGuildRecruitmentFrameRecruitment
	B.ReskinButton(recruitment.ListGuildButton)

	for _, name in pairs({"InterestFrame", "AvailabilityFrame", "RolesFrame", "LevelFrame"}) do
		local frame = recruitment[name]
		B.StripTextures(frame)
		B.CreateBDFrame(frame, 0)
	end

	for _, name in pairs({"QuestButton", "DungeonButton", "RaidButton", "PvPButton", "RPButton"}) do
		local button = recruitment.InterestFrame[name]
		B.ReskinCheck(button)
	end

	for _, name in pairs({"WeekdaysButton", "WeekendsButton"}) do
		local button = recruitment.AvailabilityFrame[name]
		B.ReskinCheck(button)
	end

	for _, name in pairs({"TankButton", "HealerButton", "DamagerButton"}) do
		local button = recruitment.RolesFrame[name]
		B.ReskinCheck(button.checkButton)
	end

	for _, name in pairs({"LevelAnyButton", "LevelMaxButton"}) do
		local button = recruitment.LevelFrame[name]
		B.ReskinRadio(button)
	end

	local RolesFrame = recruitment.RolesFrame
	B.ReskinRole(RolesFrame.TankButton, "TANK")
	B.ReskinRole(RolesFrame.HealerButton, "HEALER")
	B.ReskinRole(RolesFrame.DamagerButton, "DPS")

	local CommentEditBox = CommunitiesGuildRecruitmentFrameRecruitmentScrollFrame.CommentEditBox
	CommentEditBox:SetWidth(284)

	local CommentFrame = recruitment.CommentFrame
	B.StripTextures(CommentFrame)

	local CommentInputFrame = CommentFrame.CommentInputFrame
	CommentInputFrame:SetAllPoints(CommentFrame)
	B.StripTextures(CommentInputFrame)
	B.CreateBDFrame(CommentInputFrame, 0)

	B.ReskinScroll(CommunitiesGuildRecruitmentFrameApplicantsContainer.scrollBar)
	local Applicants = CommunitiesGuildRecruitmentFrameApplicants
	B.ReskinButton(Applicants.InviteButton)
	B.ReskinButton(Applicants.MessageButton)
	B.ReskinButton(Applicants.DeclineButton)

	hooksecurefunc("CommunitiesGuildRecruitmentFrameApplicants_Update", function(self)
		local buttons = self.Container.buttons
		for i = 1, #buttons do
			local button = buttons[i]
			if not button.styled then
				B.StripTextures(button)

				local bubg = B.CreateBDFrame(button, 0, -3)
				B.ReskinTexture(button, bubg, true)
				B.ReskinTexture(button.selectedTex, bubg, true)

				button.styled = true
			end
		end
	end)
end