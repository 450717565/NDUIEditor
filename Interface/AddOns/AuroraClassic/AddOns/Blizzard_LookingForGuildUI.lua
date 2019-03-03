local F, C = unpack(select(2, ...))

C.themes["Blizzard_LookingForGuildUI"] = function()
	local styled = false
	hooksecurefunc("LookingForGuildFrame_CreateUIElements", function()
		F.ReskinFrame(LookingForGuildFrame)
		F.ReskinFrame(GuildFinderRequestMembershipFrame)

		F.ReskinScroll(LookingForGuildBrowseFrameContainerScrollBar)

		for i = 1, 3 do
			F.StripTextures(_G["LookingForGuildFrameTab"..i])
		end

		local frames = {LookingForGuildInterestFrame, LookingForGuildAvailabilityFrame, LookingForGuildRolesFrame, GuildFinderRequestMembershipFrameInputFrame}
		for _, frame in next, frames do
			F.StripTextures(frame, true)
			F.CreateBDFrame(frame, 0)
		end

		local checks = {LookingForGuildQuestButton, LookingForGuildDungeonButton, LookingForGuildRaidButton, LookingForGuildPvPButton, LookingForGuildRPButton, LookingForGuildWeekdaysButton, LookingForGuildWeekendsButton}
		for _, check in next, checks do
			F.ReskinCheck(check)
		end

		local buttons = {LookingForGuildBrowseButton, GuildFinderRequestMembershipFrameAcceptButton, GuildFinderRequestMembershipFrameCancelButton, LookingForGuildRequestButton}
		for _, button in next, buttons do
			F.ReskinButton(button)
		end

		local function reskinButtons(button, i)
			local bu = _G[button..i]
			bu:SetBackdrop(nil)

			local bg = F.CreateBDFrame(bu, 0)
			bg:SetPoint("TOPLEFT", C.mult, -C.mult)
			bg:SetPoint("BOTTOMRIGHT", -C.mult, C.mult)

			F.ReskinTexture(bu, bg, true)
			F.ReskinTexture(bu.selectedTex, bg, true)

			local rm = _G[button..i.."RemoveButton"]
			if rm then
				rm:ClearAllPoints()
				rm:SetPoint("RIGHT", -10, 0)
			end

			local pd = _G[button..i.."Pending"]
			if pd then
				pd.pendingTex:SetPoint("TOPLEFT", bg, C.mult, -C.mult)
				pd.pendingTex:SetPoint("BOTTOMRIGHT", bg, -C.mult, C.mult)
			end
		end

		for i = 1, 5 do
			reskinButtons("LookingForGuildBrowseFrameContainerButton", i)
		end

		for i = 1, 10 do
			reskinButtons("LookingForGuildAppsFrameContainerButton", i)
		end

		-- CommentFrame
		LookingForGuildCommentFrameText:Hide()
		LookingForGuildCommentEditBox:SetWidth(284)
		local CommentFrame = LookingForGuildCommentFrame
		F.StripTextures(CommentFrame, true)

		local CommentInputFrame = LookingForGuildCommentInputFrame
		CommentInputFrame:SetAllPoints(CommentFrame)
		F.StripTextures(CommentInputFrame)
		F.CreateBDFrame(CommentInputFrame, 0)

		F.ReskinRole(LookingForGuildTankButton, "TANK")
		F.ReskinRole(LookingForGuildHealerButton, "HEALER")
		F.ReskinRole(LookingForGuildDamagerButton, "DPS")

		styled = true
	end)
end