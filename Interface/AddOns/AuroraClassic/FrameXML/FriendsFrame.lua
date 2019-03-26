local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	F.ReskinFrame(FriendsFrame)
	F.SetupTabStyle(FriendsFrame, 3)
	F.ReskinFrame(AddFriendFrame)

	local lists = {FriendsFrameFriendsScrollFrame, IgnoreListFrame, WhoListScrollFrame, WhoFrameListInset, WhoFrameEditBoxInset}
	for _, list in pairs(lists) do
		F.StripTextures(list)
	end

	local dropdowns = {FriendsFrameStatusDropDown, FriendsFriendsFrameDropDown, WhoFrameDropDown}
	for _, dropdown in pairs(dropdowns) do
		F.ReskinDropDown(dropdown)
	end

	local scrolls = {FriendsFrameFriendsScrollFrameScrollBar, FriendsFrameIgnoreScrollFrameScrollBar, FriendsFriendsScrollFrameScrollBar, WhoListScrollFrameScrollBar}
	for _, scroll in pairs(scrolls) do
		F.ReskinScroll(scroll)
	end

	local buttons = {AddFriendEntryFrameAcceptButton, AddFriendEntryFrameCancelButton, AddFriendInfoFrameContinueButton, FriendsFrameAddFriendButton, FriendsFrameIgnorePlayerButton, FriendsFrameSendMessageButton, FriendsFrameUnsquelchButton, FriendsFriendsCloseButton, FriendsFriendsSendRequestButton, FriendsListFrameContinueButton, WhoFrameAddFriendButton, WhoFrameGroupInviteButton, WhoFrameWhoButton}
	for _, button in pairs(buttons) do
		F.ReskinButton(button)
	end

	local inputs = {AddFriendNameEditBox, FriendsFrameBroadcastInput}
	for _, input in pairs(inputs) do
		F.ReskinInput(input)
	end

	-- FriendsFrame
	FriendsFrameTitleText:ClearAllPoints()
	FriendsFrameTitleText:SetPoint("TOP", 0, -8)

	FriendsFrameStatusDropDown:ClearAllPoints()
	FriendsFrameStatusDropDown:SetPoint("TOPLEFT", 15, -25)
	FriendsFrameStatusDropDownStatus:ClearAllPoints()
	FriendsFrameStatusDropDownStatus:SetPoint("RIGHT", FriendsFrameStatusDropDownButton, "LEFT", -4, -.5)

	local bls = {FriendsFrameAddFriendButton, FriendsFrameIgnorePlayerButton}
	for _, bl in pairs(bls) do
		bl:SetSize(134, 21)
		bl:ClearAllPoints()
		bl:SetPoint("BOTTOMLEFT", 6, 4)
	end

	local brs = {FriendsFrameSendMessageButton, FriendsFrameUnsquelchButton}
	for _, br in pairs(brs) do
		br:SetSize(134, 21)
		br:ClearAllPoints()
		br:SetPoint("BOTTOMRIGHT", -6, 4)
	end

	for i = 1, 3 do
		local FriendsHeader = _G["FriendsTabHeaderTab"..i]
		F.StripTextures(FriendsHeader)

		local bg = F.CreateBDFrame(FriendsHeader, 0)
		bg:SetPoint("TOPLEFT", C.mult, -8)
		bg:SetPoint("BOTTOMRIGHT", -C.mult, 0)
	end

	local BattlenetFrame = FriendsFrameBattlenetFrame
	local BattlenetTag = BattlenetFrame.Tag
	BattlenetTag:SetParent(FriendsListFrame)
	BattlenetTag:ClearAllPoints()
	BattlenetTag:SetPoint("TOP", 0, -8)

	local UnavailableInfoFrame = BattlenetFrame.UnavailableInfoFrame
	F.ReskinFrame(UnavailableInfoFrame)
	UnavailableInfoFrame:ClearAllPoints()
	UnavailableInfoFrame:SetPoint("TOPLEFT", FriendsFrame, "TOPRIGHT", 2, 0)

	hooksecurefunc("FriendsFrame_CheckBattlenetStatus", function()
		if BNFeaturesEnabled() then
			BattlenetFrame.BroadcastButton:Hide()
			if BNConnected() then
				BattlenetFrame:Hide()
				FriendsFrameBroadcastInput:Show()
				FriendsFrameBroadcastInput_UpdateDisplay()
			end
		end
	end)

	hooksecurefunc("FriendsFrame_Update", function()
		if FriendsFrame.selectedTab == 1 and FriendsTabHeader.selectedTab == 1 and BattlenetTag:IsShown() then
			FriendsFrameTitleText:Hide()
		else
			FriendsFrameTitleText:Show()
		end
	end)

	for i = 1, FRIENDS_TO_DISPLAY do
		local bu = _G["FriendsFrameFriendsScrollFrameButton"..i]
		bu.background:Hide()

		local tp = bu.travelPassButton
		F.ReskinButton(tp)

		local ic = tp:CreateTexture(nil, "OVERLAY")
		ic:SetTexture("Interface\\FriendsFrame\\PlusManz-PlusManz")
		ic:SetPoint("CENTER", 0, 1)
		ic:SetSize(20, 28)

		local gi = bu.gameIcon
		gi:ClearAllPoints()
		gi:SetPoint("RIGHT", tp, "LEFT", -2, 0)

		local hl = bu.highlight
		hl:SetTexture(C.media.bdTex)
		hl:SetAlpha(.25)
		hl:SetPoint("BOTTOMRIGHT", tp, "BOTTOMLEFT", -2, 0)
	end

	local function UpdateScroll()
		for i = 1, FRIENDS_TO_DISPLAY do
			local bu = _G["FriendsFrameFriendsScrollFrameButton"..i]

			local isEnabled = bu.travelPassButton:IsEnabled()
			if isEnabled then
				bu.travelPassButton:SetAlpha(1)
			else
				bu.travelPassButton:SetAlpha(.25)
			end
		end
	end
	hooksecurefunc("FriendsFrame_UpdateFriends", UpdateScroll)
	hooksecurefunc(FriendsFrameFriendsScrollFrame, "update", UpdateScroll)

	local icPatch = "Interface\\FriendsFrame\\"

	local function reskinInvites(self)
		for invite in self:EnumerateActive() do
			if not invite.styled then
				F.StripTextures(invite)
				F.ReskinDecline(invite.DeclineButton)
				F.ReskinButton(invite.AcceptButton)
				invite.DeclineButton:SetSize(22, 22)

				local Children = FriendsFrameFriendsScrollFrameScrollChild:GetChildren()
				F.StripTextures(Children)
				F.CleanTextures(Children)

				local bg = F.CreateBDFrame(Children, 0)
				bg:SetPoint("TOPLEFT", C.mult, -C.mult)
				bg:SetPoint("BOTTOMRIGHT", -C.mult, C.mult)
				F.ReskinTexture(Children, bg, true)

				invite.styled = true
			end
		end
	end

	hooksecurefunc(FriendsFrameFriendsScrollFrame.invitePool, "Acquire", reskinInvites)
	hooksecurefunc("FriendsFrame_UpdateFriendButton", function(button)
		if button.buttonType == FRIENDS_BUTTON_TYPE_INVITE then
			reskinInvites(FriendsFrameFriendsScrollFrame.invitePool)
		elseif button.buttonType == FRIENDS_BUTTON_TYPE_BNET and BNConnected() then
			local toonID = select(6, BNGetFriendInfo(button.id))
			local isOnline = select(8, BNGetFriendInfo(button.id))
			if isOnline then
				local faction = select(6, BNGetGameAccountInfo(toonID))
				if faction == "Alliance" or faction == "Horde" or faction == "Neutral" then
					button.gameIcon:SetTexture(icPatch..faction)
				end
			end
		end
	end)

	-- WhoFrame
	local WhoAdd = WhoFrameAddFriendButton
	WhoAdd:ClearAllPoints()
	WhoAdd:SetPoint("BOTTOM", WhoFrame, "BOTTOM", -17.5, 4)

	local WhoWho = WhoFrameWhoButton
	WhoWho:ClearAllPoints()
	WhoWho:SetPoint("RIGHT", WhoAdd, "LEFT", -1, 0)

	local WhoInvite = WhoFrameGroupInviteButton
	WhoInvite:ClearAllPoints()
	WhoInvite:SetPoint("LEFT", WhoAdd, "RIGHT", 1, 0)

	local WhoEdit = WhoFrameEditBoxInset
	F.ReskinInput(WhoEdit, 20, 325)
	WhoEdit:ClearAllPoints()
	WhoEdit:SetPoint("BOTTOMLEFT", WhoWho, "TOPLEFT", 2, 2)

	local WhoBox = WhoFrameEditBox
	WhoBox:ClearAllPoints()
	WhoBox:SetAllPoints(WhoEdit)

	for i = 1, 4 do
		local WhoHeader = _G["WhoFrameColumnHeader"..i]
		F.StripTextures(WhoHeader)

		if i ~= 2 then
			F.ReskinTexture(WhoHeader, WhoHeader, true)
		end
	end
end)