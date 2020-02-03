local B, C, L, DB = unpack(select(2, ...))

C.themes["Blizzard_LookingForGuildUI"] = function()
	local styled = false
	hooksecurefunc("LookingForGuildFrame_CreateUIElements", function()
		if styled then return end

		B.ReskinFrame(LookingForGuildFrame)
		B.ReskinFrame(GuildFinderRequestMembershipFrame)

		B.ReskinScroll(LookingForGuildBrowseFrameContainerScrollBar)

		for i = 1, 3 do
			B.StripTextures(_G["LookingForGuildFrameTab"..i])
		end

		local frames = {LookingForGuildInterestFrame, LookingForGuildAvailabilityFrame, LookingForGuildRolesFrame, GuildFinderRequestMembershipFrameInputFrame}
		for _, frame in pairs(frames) do
			B.StripTextures(frame)
			B.CreateBDFrame(frame, 0)
		end

		local checks = {LookingForGuildQuestButton, LookingForGuildDungeonButton, LookingForGuildRaidButton, LookingForGuildPvPButton, LookingForGuildRPButton, LookingForGuildWeekdaysButton, LookingForGuildWeekendsButton}
		for _, check in pairs(checks) do
			B.ReskinCheck(check)
		end

		local buttons = {LookingForGuildBrowseButton, GuildFinderRequestMembershipFrameAcceptButton, GuildFinderRequestMembershipFrameCancelButton, LookingForGuildRequestButton}
		for _, button in pairs(buttons) do
			B.ReskinButton(button)
		end

		local function reskinButtons(button, i)
			local bu = _G[button..i]
			bu:SetBackdrop(nil)

			local bg = B.CreateBDFrame(bu, 0, -C.mult*2)
			B.ReskinTexture(bu, bg, true)
			B.ReskinTexture(bu.selectedTex, bg, true)

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
		B.StripTextures(CommentFrame)

		local CommentInputFrame = LookingForGuildCommentInputFrame
		CommentInputFrame:SetAllPoints(CommentFrame)
		B.StripTextures(CommentInputFrame)
		B.CreateBDFrame(CommentInputFrame, 0)

		B.ReskinRole(LookingForGuildTankButton, "TANK")
		B.ReskinRole(LookingForGuildHealerButton, "HEALER")
		B.ReskinRole(LookingForGuildDamagerButton, "DPS")

		styled = true
	end)
end