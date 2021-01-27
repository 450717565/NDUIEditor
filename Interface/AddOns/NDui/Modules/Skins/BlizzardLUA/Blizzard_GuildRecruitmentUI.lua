local _, ns = ...
local B, C, L, DB = unpack(ns)

local function Reskin_Applicants(self)
	local buttons = self.Container.buttons
	for i = 1, #buttons do
		local button = buttons[i]
		if button and not button.styled then
			B.StripTextures(button)

			local bubg = B.CreateBDFrame(button, 0, -3)
			B.ReskinHighlight(button, bubg, true)
			B.ReskinHighlight(button.selectedTex, bubg, true)

			button.styled = true
		end
	end
end

C.LUAThemes["Blizzard_GuildRecruitmentUI"] = function()
	B.ReskinFrame(CommunitiesGuildRecruitmentFrame)

	B.StripTextures(CommunitiesGuildRecruitmentFrameTab1)
	B.StripTextures(CommunitiesGuildRecruitmentFrameTab2)

	B.ReskinScroll(CommunitiesGuildRecruitmentFrameRecruitmentScrollFrameScrollBar)

	local recruitment = CommunitiesGuildRecruitmentFrameRecruitment
	B.ReskinButton(recruitment.ListGuildButton)

	local frames = {
		"InterestFrame",
		"AvailabilityFrame",
		"RolesFrame",
		"LevelFrame",
	}
	for _, name in pairs(frames) do
		local frame = recruitment[name]
		B.StripTextures(frame)
		B.CreateBDFrame(frame)
	end

	local buttons_1 = {
		"QuestButton",
		"DungeonButton",
		"RaidButton",
		"PvPButton",
		"RPButton",
	}
	for _, name in pairs(buttons_1) do
		local button = recruitment.InterestFrame[name]
		B.ReskinCheck(button)
	end

	local buttons_2 = {
		"WeekdaysButton",
		"WeekendsButton",
	}
	for _, name in pairs(buttons_2) do
		local button = recruitment.AvailabilityFrame[name]
		B.ReskinCheck(button)
	end

	local buttons_3 = {
		"TankButton",
		"HealerButton",
		"DamagerButton",
	}
	for _, name in pairs(buttons_3) do
		local button = recruitment.RolesFrame[name]
		B.ReskinCheck(button.checkButton)
	end

	local buttons_4 = {
		"LevelAnyButton",
		"LevelMaxButton",
	}
	for _, name in pairs(buttons_4) do
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
	B.CreateBDFrame(CommentInputFrame)

	B.ReskinScroll(CommunitiesGuildRecruitmentFrameApplicantsContainer.scrollBar)
	local Applicants = CommunitiesGuildRecruitmentFrameApplicants
	B.ReskinButton(Applicants.InviteButton)
	B.ReskinButton(Applicants.MessageButton)
	B.ReskinButton(Applicants.DeclineButton)

	hooksecurefunc("CommunitiesGuildRecruitmentFrameApplicants_Update", Reskin_Applicants)
end