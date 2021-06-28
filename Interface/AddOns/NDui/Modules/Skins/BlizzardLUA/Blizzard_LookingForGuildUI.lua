local _, ns = ...
local B, C, L, DB = unpack(ns)

local function Reskin_Button(self, index)
	local button = _G[self..index]
	button:SetBackdrop("")

	local bg = B.CreateBDFrame(button, 0, 1)
	B.ReskinHLTex(button, bg, true)
	B.ReskinHLTex(button.selectedTex, bg, true)

	local remove = _G[self..index.."RemoveButton"]
	if remove then
		remove:ClearAllPoints()
		remove:SetPoint("RIGHT", -10, 0)
	end

	local pending = _G[self..index.."Pending"]
	if pending then
		pending.pendingTex:SetInside(bg)
	end
end

local function Reskin_LookingForGuildFrame()
	if styled then return end

	B.ReskinFrame(LookingForGuildFrame)
	B.ReskinFrame(GuildFinderRequestMembershipFrame)

	B.ReskinScroll(LookingForGuildBrowseFrameContainerScrollBar)

	for i = 1, 3 do
		B.StripTextures(_G["LookingForGuildFrameTab"..i])
	end

	local frames = {
		LookingForGuildInterestFrame,
		LookingForGuildAvailabilityFrame,
		LookingForGuildRolesFrame,
		GuildFinderRequestMembershipFrameInputFrame,
	}
	for _, frame in pairs(frames) do
		B.StripTextures(frame)
		B.CreateBDFrame(frame)
	end

	local checks = {
		LookingForGuildQuestButton,
		LookingForGuildDungeonButton,
		LookingForGuildRaidButton,
		LookingForGuildPvPButton,
		LookingForGuildRPButton,
		LookingForGuildWeekdaysButton,
		LookingForGuildWeekendsButton,
	}
	for _, check in pairs(checks) do
		B.ReskinCheck(check)
	end

	local buttons = {
		LookingForGuildBrowseButton,
		GuildFinderRequestMembershipFrameAcceptButton,
		GuildFinderRequestMembershipFrameCancelButton,
		LookingForGuildRequestButton,
	}
	for _, button in pairs(buttons) do
		B.ReskinButton(button)
	end

	for i = 1, 5 do
		Reskin_Button("LookingForGuildBrowseFrameContainerButton", i)
	end

	for i = 1, 10 do
		Reskin_Button("LookingForGuildAppsFrameContainerButton", i)
	end

	-- CommentFrame
	LookingForGuildCommentFrameText:Hide()
	LookingForGuildCommentEditBox:SetWidth(284)
	local CommentFrame = LookingForGuildCommentFrame
	B.StripTextures(CommentFrame)

	local CommentInputFrame = LookingForGuildCommentInputFrame
	CommentInputFrame:SetAllPoints(CommentFrame)
	B.StripTextures(CommentInputFrame)
	B.CreateBDFrame(CommentInputFrame)

	B.ReskinRole(LookingForGuildTankButton, "TANK")
	B.ReskinRole(LookingForGuildHealerButton, "HEALER")
	B.ReskinRole(LookingForGuildDamagerButton, "DPS")

	styled = true
end

C.OnLoadThemes["Blizzard_LookingForGuildUI"] = function()
	local styled = false
	hooksecurefunc("LookingForGuildFrame_CreateUIElements", Reskin_LookingForGuildFrame)
end