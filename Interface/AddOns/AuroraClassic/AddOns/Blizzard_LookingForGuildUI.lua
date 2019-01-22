local F, C = unpack(select(2, ...))

C.themes["Blizzard_LookingForGuildUI"] = function()
	local styled = false
	hooksecurefunc("LookingForGuildFrame_CreateUIElements", function()
		if styled then return end

		F.ReskinFrame(LookingForGuildFrame)
		F.ReskinFrame(GuildFinderRequestMembershipFrame)

		F.ReskinButton(LookingForGuildBrowseButton)
		F.ReskinButton(GuildFinderRequestMembershipFrameAcceptButton)
		F.ReskinButton(GuildFinderRequestMembershipFrameCancelButton)

		for i = 1, 3 do
			F.StripTextures(_G["LookingForGuildFrameTab"..i], true)
		end

		local frames = {LookingForGuildInterestFrame, LookingForGuildAvailabilityFrame, LookingForGuildRolesFrame, LookingForGuildCommentFrame, LookingForGuildCommentInputFrame, GuildFinderRequestMembershipFrameInputFrame}
		for _, frame in next, frames do
			F.StripTextures(frame, true)
			F.CreateBDFrame(frame, .25)
		end

		local buttons = {LookingForGuildQuestButton, LookingForGuildDungeonButton, LookingForGuildRaidButton, LookingForGuildPvPButton, LookingForGuildRPButton, LookingForGuildWeekdaysButton, LookingForGuildWeekendsButton}
		for _, button in next, buttons do
			F.ReskinCheck(button)
		end

		local function reskinButtons(button, i)
			local bu = _G[button..i]
			bu:SetBackdrop(nil)

			local bg = F.CreateBDFrame(bu, .25)
			bg:SetPoint("TOPLEFT", C.mult, -C.mult)
			bg:SetPoint("BOTTOMRIGHT", -C.mult, C.mult)

			F.ReskinTexture(bu.selectedTex, bg, true)
			F.ReskinTexture(_G[button..i.."Highlight"], bg, true)

			local rm = _G[button..i.."RemoveButton"]
			if rm then rm:SetPoint("RIGHT", -10, 1) end

			local pd = _G[button..i.."Pending"]
			if pd then
				pd.pendingTex:SetPoint("TOPLEFT", bg, C.mult, -C.mult)
				pd.pendingTex:SetPoint("BOTTOMRIGHT", bg, -C.mult, C.mult)
			end
		end

		-- [[ Browse frame ]]
		F.ReskinButton(LookingForGuildRequestButton)
		F.ReskinScroll(LookingForGuildBrowseFrameContainerScrollBar)

		for i = 1, 5 do
			reskinButtons("LookingForGuildBrowseFrameContainerButton", i)
		end

		-- [[ App frame ]]
		for i = 1, 10 do
			reskinButtons("LookingForGuildAppsFrameContainerButton", i)
		end

		-- [[ Role buttons ]]
		for _, roleButton in next, {LookingForGuildTankButton, LookingForGuildHealerButton, LookingForGuildDamagerButton} do
			F.ReskinCheck(roleButton.checkButton)
		end

		styled = true
	end)
end