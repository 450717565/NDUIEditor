local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	local icPatch = "Interface\\FriendsFrame\\"

	F.StripTextures(FriendsFrameFriendsScrollFrame, true)
	F.StripTextures(IgnoreListFrame, true)
	F.StripTextures(WhoListScrollFrame, true)
	F.StripTextures(WhoFrameListInset, true)
	F.StripTextures(WhoFrameEditBoxInset, true)
	F.StripTextures(WhoFrameDropDown, true)

	F.ReskinPortraitFrame(FriendsFrame, true)
	F.ReskinDropDown(FriendsFrameStatusDropDown)
	F.ReskinDropDown(FriendsFriendsFrameDropDown)
	F.ReskinDropDown(WhoFrameDropDown)
	F.ReskinInput(AddFriendNameEditBox)
	F.ReskinInput(FriendsFrameBroadcastInput)
	F.ReskinScroll(FriendsFrameFriendsScrollFrameScrollBar)
	F.ReskinScroll(FriendsFrameIgnoreScrollFrameScrollBar)
	F.ReskinScroll(FriendsFriendsScrollFrameScrollBar)
	F.ReskinScroll(WhoListScrollFrameScrollBar)

	F.CreateBD(AddFriendFrame)
	F.CreateSD(AddFriendFrame)

	local whoBg = F.CreateBDFrame(WhoFrameEditBoxInset, .25)
	whoBg:SetPoint("TOPLEFT")
	whoBg:SetPoint("BOTTOMRIGHT", -1, 1)
	F.CreateGradient(whoBg)

	local header = FriendsFrameFriendsScrollFrame.PendingInvitesHeaderButton
	for i = 1, 11 do
		select(i, header:GetRegions()):Hide()
	end
	local headerBg = F.CreateBDFrame(header, .25)
	headerBg:SetPoint("TOPLEFT", 2, -2)
	headerBg:SetPoint("BOTTOMRIGHT", -2, 2)

	local buttons = {AddFriendEntryFrameAcceptButton, AddFriendEntryFrameCancelButton, AddFriendInfoFrameContinueButton, FriendsFrameAddFriendButton, FriendsFrameIgnorePlayerButton, FriendsFrameSendMessageButton, FriendsFrameUnsquelchButton, FriendsFriendsCloseButton, FriendsFriendsSendRequestButton, FriendsListFrameContinueButton, WhoFrameAddFriendButton, WhoFrameGroupInviteButton, WhoFrameWhoButton}
	for _, button in next, buttons do
		F.Reskin(button)
	end

	for i = 1, 3 do
		F.StripTextures(_G["FriendsTabHeaderTab"..i], true)
	end

	for i = 1, 4 do
		F.StripTextures(_G["WhoFrameColumnHeader"..i], true)
	end

	for i = 1, 3 do
		F.ReskinTab(_G["FriendsFrameTab"..i])
	end

	for i = 1, FRIENDS_TO_DISPLAY do
		local bu = _G["FriendsFrameFriendsScrollFrameButton"..i]
		bu.background:Hide()

		bu:SetHighlightTexture(C.media.backdrop)
		bu:GetHighlightTexture():SetVertexColor(.24, .56, 1, .25)

		local tp = bu.travelPassButton
		tp:EnableMouse(true)
		tp:SetSize(22, 22)
		tp:ClearAllPoints()
		tp:SetPoint("RIGHT", -2, 0)
		F.Reskin(tp)

		bu.inv = tp:CreateTexture(nil, "OVERLAY", nil, 7)
		bu.inv:SetTexture([[Interface\FriendsFrame\PlusManz-PlusManz]])
		bu.inv:SetPoint("CENTER", 0, 1)
		bu.inv:SetSize(20, 20)

		local ic = bu.gameIcon
		ic:SetSize(19, 19)
		ic:SetTexCoord(.19, .81, .19, .81)
		ic:ClearAllPoints()
		ic:SetPoint("RIGHT", tp, "LEFT", -4, 0)
		ic.bg = F.CreateBDFrame(ic)
	end

	for _, button in pairs({FriendsTabHeaderSoRButton, FriendsTabHeaderRecruitAFriendButton}) do
		button:SetPushedTexture("")
		button:GetRegions():SetTexCoord(.08, .92, .08, .92)
		F.CreateBDFrame(button, .25)
	end

	local function UpdateScroll()
		for i = 1, FRIENDS_TO_DISPLAY do
			local bu = _G["FriendsFrameFriendsScrollFrameButton"..i]

			local ic = bu.gameIcon
			if ic:IsShown() then
				ic.bg:Show()
			else
				ic.bg:Hide()
			end

			local toonID = select(6, BNGetFriendInfo(bu.id))
			local faction = select(6, BNGetGameAccountInfo(toonID))
			if faction == "Alliance" or faction == "Horde" or faction == "Neutral" then
				ic:SetTexture(icPatch..faction)
			end

			local isEnabled = bu.travelPassButton:IsEnabled()
			if isEnabled then
				bu.inv:SetAlpha(1)
				bu.travelPassButton:SetAlpha(1)
			else
				bu.inv:SetAlpha(0.25)
				bu.travelPassButton:SetAlpha(0.25)
			end

			for invite in FriendsFrameFriendsScrollFrame.invitePool:EnumerateActive() do
				if not invite.styled then
					F.StripTextures(FriendsFrameFriendsScrollFrameScrollChild, true)

					local child = FriendsFrameFriendsScrollFrameScrollChild:GetChildren()
					F.StripTextures(child, true)
					F.Reskin(child)

					invite.DeclineButton:SetSize(22, 22)
					F.ReskinDecline(invite.DeclineButton)
					F.Reskin(invite.AcceptButton)

					invite.styled = true
				end
			end
		end
	end

	hooksecurefunc("FriendsFrame_UpdateFriends", UpdateScroll)
	hooksecurefunc(FriendsFrameFriendsScrollFrame, "update", UpdateScroll)

	local function reskinInvites(self)
		for invite in self:EnumerateActive() do
			if not invite.styled then
				invite.DeclineButton:SetSize(22, 22)
				F.ReskinDecline(invite.DeclineButton)
				F.Reskin(invite.AcceptButton)

				invite.styled = true
			end
		end
	end

	hooksecurefunc("FriendsFrame_UpdateFriendButton", function(button)
		if button.buttonType == FRIENDS_BUTTON_TYPE_INVITE then
			reskinInvites(FriendsFrameFriendsScrollFrame.invitePool)
		end
	end)
	hooksecurefunc(FriendsFrameFriendsScrollFrame.invitePool, "Acquire", reskinInvites)

	hooksecurefunc("FriendsFrame_CheckBattlenetStatus", function()
		if BNFeaturesEnabled() then
			local frame = FriendsFrameBattlenetFrame

			frame.BroadcastButton:Hide()

			if BNConnected() then
				frame:Hide()
				FriendsFrameBroadcastInput:Show()
				FriendsFrameBroadcastInput_UpdateDisplay()
			end
		end
	end)

	hooksecurefunc("FriendsFrame_Update", function()
		if FriendsFrame.selectedTab == 1 and FriendsTabHeader.selectedTab == 1 and FriendsFrameBattlenetFrame.Tag:IsShown() then
			FriendsFrameTitleText:Hide()
		else
			FriendsFrameTitleText:Show()
		end
	end)

	F.CreateBDFrame(FriendsFrameBattlenetFrame.UnavailableInfoFrame, .25)
	FriendsFrameBattlenetFrame.UnavailableInfoFrame:SetPoint("TOPLEFT", FriendsFrame, "TOPRIGHT", 1, -18)

	FriendsFrameBattlenetFrame:GetRegions():Hide()
	F.CreateBDFrame(FriendsFrameBattlenetFrame, .25)

	FriendsFrameBattlenetFrame.Tag:SetParent(FriendsListFrame)
	FriendsFrameBattlenetFrame.Tag:SetPoint("TOP", FriendsFrame, "TOP", 0, -8)

	FriendsFrameStatusDropDown:ClearAllPoints()
	FriendsFrameStatusDropDown:SetPoint("TOPLEFT", 10, -30)

	WhoFrameWhoButton:SetPoint("RIGHT", WhoFrameAddFriendButton, "LEFT", -1, 0)
	WhoFrameAddFriendButton:SetPoint("RIGHT", WhoFrameGroupInviteButton, "LEFT", -1, 0)
	FriendsFrameTitleText:SetPoint("TOP", 0, -8)
end)