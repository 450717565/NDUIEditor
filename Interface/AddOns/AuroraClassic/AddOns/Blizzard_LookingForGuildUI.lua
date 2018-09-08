local F, C = unpack(select(2, ...))

C.themes["Blizzard_LookingForGuildUI"] = function()
	local r, g, b = C.r, C.g, C.b

	local styled
	hooksecurefunc("LookingForGuildFrame_CreateUIElements", function()
		if styled then return end

		F.ReskinPortraitFrame(LookingForGuildFrame, true)
		F.CreateBD(LookingForGuildFrame)
		F.CreateSD(LookingForGuildFrame)

		F.StripTextures(GuildFinderRequestMembershipFrame, true)
		F.CreateBD(GuildFinderRequestMembershipFrame)
		F.CreateSD(GuildFinderRequestMembershipFrame)

		F.Reskin(LookingForGuildBrowseButton)
		F.Reskin(GuildFinderRequestMembershipFrameAcceptButton)
		F.Reskin(GuildFinderRequestMembershipFrameCancelButton)
		F.ReskinClose(LookingForGuildFrameCloseButton)

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

		-- [[ Browse frame ]]
		F.Reskin(LookingForGuildRequestButton)
		F.ReskinScroll(LookingForGuildBrowseFrameContainerScrollBar)

		for i = 1, 5 do
			local bu = _G["LookingForGuildBrowseFrameContainerButton"..i]
			bu:SetBackdrop(nil)

			local selected = bu.selectedTex
			selected:SetTexture(C.media.backdrop)
			selected:SetVertexColor(r, g, b, .25)
			selected:SetPoint("TOPLEFT", 2, -2)
			selected:SetPoint("BOTTOMRIGHT", -2, 4)

			local hl = _G["LookingForGuildBrowseFrameContainerButton"..i.."Highlight"]
			hl:SetTexture(C.media.backdrop)
			hl:SetVertexColor(r, g, b, .25)
			hl:SetPoint("TOPLEFT", 2, -2)
			hl:SetPoint("BOTTOMRIGHT", -2, 4)

			local bg = F.CreateBDFrame(bu, .25)
			bg:SetPoint("TOPLEFT", 1, -1)
			bg:SetPoint("BOTTOMRIGHT", -1, 3)
		end

		-- [[ Role buttons ]]
		for _, roleButton in next, {LookingForGuildTankButton, LookingForGuildHealerButton, LookingForGuildDamagerButton} do
			F.ReskinCheck(roleButton.checkButton)
		end

		styled = true
	end)
end