local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	for i = 1, 3 do
		select(i, FriendsFrameFriendsScrollFrame:GetRegions()):Hide()
	end
	IgnoreListFrameTop:Hide()
	IgnoreListFrameMiddle:Hide()
	IgnoreListFrameBottom:Hide()

	for i = 1, 3 do
		F.ReskinTab(_G["FriendsFrameTab"..i])
	end

	FriendsFrameIcon:Hide()

	for i = 1, FRIENDS_TO_DISPLAY do
		local bu = _G["FriendsFrameFriendsScrollFrameButton"..i]
		local ic = bu.gameIcon

		bu.background:Hide()
		F.Reskin(bu.travelPassButton)
		bu.travelPassButton:EnableMouse(true)
		bu.travelPassButton:SetSize(22, 22)
		bu.travelPassButton:ClearAllPoints()
		bu.travelPassButton:SetPoint("RIGHT", bu, "RIGHT", -2, 0)

		bu:SetHighlightTexture(C.media.backdrop)
		bu:GetHighlightTexture():SetVertexColor(.24, .56, 1, .2)

		ic:SetSize(22, 22)
		ic:SetTexCoord(.15, .85, .15, .85)

		bu.bg = CreateFrame("Frame", nil, bu)
		bu.bg:SetAllPoints(ic)
		F.CreateBD(bu.bg, 0)
		F.CreateSD(bu.bg)
		bu.inv = bu.travelPassButton:CreateTexture(nil, "OVERLAY", nil, 7)
		bu.inv:SetTexture([[Interface\FriendsFrame\PlusManz-PlusManz]])
		bu.inv:SetPoint("CENTER", 0, 1)
		bu.inv:SetSize(20, 20)
	end

	local function UpdateScroll()
		for i = 1, FRIENDS_TO_DISPLAY do
			local bu = _G["FriendsFrameFriendsScrollFrameButton"..i]
			local isEnabled = bu.travelPassButton:IsEnabled()

			if bu.gameIcon:IsShown() then
				bu.bg:Show()
				bu.gameIcon:ClearAllPoints()
				bu.gameIcon:SetPoint("RIGHT", bu.travelPassButton, "LEFT", -2, 0)
			else
				bu.bg:Hide()
			end
			if isEnabled then
				bu.inv:SetAlpha(1)
				bu.travelPassButton:SetAlpha(1)
			else
				bu.inv:SetAlpha(0.25)
				bu.travelPassButton:SetAlpha(0.25)
			end
			for invite in FriendsFrameFriendsScrollFrame.invitePool:EnumerateActive() do
				if not invite.styled then
					local childbtn = FriendsFrameFriendsScrollFrameScrollChild:GetChildren()
					childbtn.BG:Hide()
					invite.DeclineButton:SetSize(22, 22)
					F.Reskin(childbtn)
					F.ReskinDecline(invite.DeclineButton)
					F.Reskin(invite.AcceptButton)
					invite.styled = true
				end
			end
		end
	end

	local bu1 = FriendsFrameFriendsScrollFrameButton1
	bu1.bg:SetPoint("BOTTOMRIGHT", bu1.gameIcon, 0, -1)

	hooksecurefunc("FriendsFrame_UpdateFriends", UpdateScroll)
	hooksecurefunc(FriendsFrameFriendsScrollFrame, "update", UpdateScroll)

	FriendsFrameStatusDropDown:ClearAllPoints()
	FriendsFrameStatusDropDown:SetPoint("TOPLEFT", FriendsFrame, "TOPLEFT", 10, -28)

	for _, button in pairs({FriendsTabHeaderSoRButton, FriendsTabHeaderRecruitAFriendButton}) do
		button:SetPushedTexture("")
		button:GetRegions():SetTexCoord(.08, .92, .08, .92)
		F.CreateBDFrame(button)
	end

	F.CreateBD(FriendsFrameBattlenetFrame.UnavailableInfoFrame)
	F.CreateSD(FriendsFrameBattlenetFrame.UnavailableInfoFrame)
	FriendsFrameBattlenetFrame.UnavailableInfoFrame:SetPoint("TOPLEFT", FriendsFrame, "TOPRIGHT", 1, -18)

	FriendsFrameBattlenetFrame:GetRegions():Hide()
	F.CreateBD(FriendsFrameBattlenetFrame, .25)
	F.CreateSD(FriendsFrameBattlenetFrame)

	FriendsFrameBattlenetFrame.Tag:SetParent(FriendsListFrame)
	FriendsFrameBattlenetFrame.Tag:SetPoint("TOP", FriendsFrame, "TOP", 0, -8)

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

	local whoBg = CreateFrame("Frame", nil, WhoFrameEditBoxInset)
	whoBg:SetPoint("TOPLEFT")
	whoBg:SetPoint("BOTTOMRIGHT", -1, 1)
	whoBg:SetFrameLevel(WhoFrameEditBoxInset:GetFrameLevel()-1)
	F.CreateBD(whoBg, .25)
	F.CreateSD(whoBg)
	F.CreateGradient(whoBg)

	F.ReskinPortraitFrame(FriendsFrame, true)
	F.Reskin(FriendsFrameAddFriendButton)
	F.Reskin(FriendsFrameSendMessageButton)
	F.Reskin(FriendsFrameIgnorePlayerButton)
	F.Reskin(FriendsFrameUnsquelchButton)
	F.ReskinScroll(FriendsFrameFriendsScrollFrameScrollBar)
	F.ReskinScroll(FriendsFrameIgnoreScrollFrameScrollBar)
	F.ReskinScroll(FriendsFriendsScrollFrameScrollBar)
	F.ReskinScroll(WhoListScrollFrameScrollBar)
	F.ReskinDropDown(FriendsFrameStatusDropDown)
	F.ReskinDropDown(WhoFrameDropDown)
	F.ReskinDropDown(FriendsFriendsFrameDropDown)
	F.Reskin(FriendsListFrameContinueButton)
	F.CreateBD(FriendsFriendsList, .25)
	F.CreateSD(FriendsFriendsList)
	F.CreateBD(AddFriendNoteFrame, .25)
	F.CreateSD(AddFriendNoteFrame)
	F.ReskinInput(AddFriendNameEditBox)
	F.ReskinInput(FriendsFrameBroadcastInput)
	F.CreateBD(AddFriendFrame)
	F.CreateSD(AddFriendFrame)
	F.CreateBD(FriendsFriendsFrame)
	F.CreateSD(FriendsFriendsFrame)
	F.Reskin(WhoFrameWhoButton)
	F.Reskin(WhoFrameAddFriendButton)
	F.Reskin(WhoFrameGroupInviteButton)
	F.Reskin(AddFriendEntryFrameAcceptButton)
	F.Reskin(AddFriendEntryFrameCancelButton)
	F.Reskin(FriendsFriendsSendRequestButton)
	F.Reskin(FriendsFriendsCloseButton)
	F.Reskin(AddFriendInfoFrameContinueButton)

	for i = 1, 9 do
		select(i, AddFriendNoteFrame:GetRegions()):Hide()
	end
	WhoListScrollFrame:GetRegions():Hide()
	select(2, WhoListScrollFrame:GetRegions()):Hide()
	WhoFrameListInsetBg:Hide()
	WhoFrameEditBoxInsetBg:Hide()

	local bglayers = {"WhoFrameColumnHeader1", "WhoFrameColumnHeader2", "WhoFrameColumnHeader3", "WhoFrameColumnHeader4"}
	for i = 1, #bglayers do
		_G[bglayers[i]]:DisableDrawLayer("BACKGROUND")
	end

	local borderlayers = {"WhoFrameListInset", "WhoFrameEditBoxInset"}
	for i = 1, #borderlayers do
		local bl = _G[borderlayers[i]]
		if not bl then
			print(borderlayers[i], "not found")
		else
			bl:DisableDrawLayer("BORDER")
		end
	end

	for i = 1, 6 do
		for j = 1, 3 do
			select(i, _G["FriendsTabHeaderTab"..j]:GetRegions()):Hide()
			select(i, _G["FriendsTabHeaderTab"..j]:GetRegions()).Show = F.dummy
		end
	end

	WhoFrameWhoButton:SetPoint("RIGHT", WhoFrameAddFriendButton, "LEFT", -1, 0)
	WhoFrameAddFriendButton:SetPoint("RIGHT", WhoFrameGroupInviteButton, "LEFT", -1, 0)
	FriendsFrameTitleText:SetPoint("TOP", FriendsFrame, "TOP", 0, -8)
end)