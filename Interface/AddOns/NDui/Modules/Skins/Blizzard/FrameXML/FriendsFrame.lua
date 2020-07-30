local B, C, L, DB = unpack(select(2, ...))

tinsert(C.defaultThemes, function()
	local icPatch = "Interface\\FriendsFrame\\"

	B.ReskinFrame(FriendsFrame)
	B.ReskinFrameTab(FriendsFrame, 4)
	B.ReskinFrame(AddFriendFrame)
	B.ReskinInput(AddFriendNameEditBox)

	B.StripTextures(FriendsFriendsFrame)
	B.CreateBG(FriendsFriendsFrame)
	B.StripTextures(FriendsFriendsFrame.ScrollFrameBorder)
	B.CreateBDFrame(FriendsFriendsFrame.ScrollFrameBorder, 0)

	local lists = {IgnoreListFrame, WhoFrameListInset, WhoFrameEditBoxInset}
	for _, list in pairs(lists) do
		B.StripTextures(list)
	end

	local dropdowns = {FriendsFrameStatusDropDown, FriendsFriendsFrameDropDown, WhoFrameDropDown}
	for _, dropdown in pairs(dropdowns) do
		B.ReskinDropDown(dropdown)
	end

	local scrolls = {FriendsListFrameScrollFrame.scrollBar, IgnoreListFrameScrollFrame.scrollBar, FriendsFriendsScrollFrame.scrollBar, WhoListScrollFrame.scrollBar}
	for _, scroll in pairs(scrolls) do
		B.ReskinScroll(scroll)
	end

	local buttons = {AddFriendEntryFrameAcceptButton, AddFriendEntryFrameCancelButton, AddFriendInfoFrameContinueButton, FriendsFrameAddFriendButton, FriendsFrameIgnorePlayerButton, FriendsFrameSendMessageButton, FriendsFrameUnsquelchButton, FriendsFriendsFrame.CloseButton, FriendsFriendsFrame.SendRequestButton, FriendsListFrameContinueButton, WhoFrameAddFriendButton, WhoFrameGroupInviteButton, WhoFrameWhoButton}
	for _, button in pairs(buttons) do
		B.ReskinButton(button)
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
		B.StripTextures(FriendsHeader)
	end

	-- FriendsFrameBattlenetFrame
	B.StripTextures(FriendsFrameBattlenetFrame)

	local BroadcastButton = FriendsFrameBattlenetFrame.BroadcastButton
	BroadcastButton:SetSize(20, 20)
	BroadcastButton:ClearAllPoints()
	BroadcastButton:SetPoint("LEFT", FriendsFrameStatusDropDownButton, "RIGHT", 1, 0)
	B.StripTextures(BroadcastButton, 0)
	B.ReskinButton(BroadcastButton)
	local newIcon = BroadcastButton:CreateTexture(nil, "ARTWORK")
	newIcon:SetAllPoints()
	newIcon:SetTexture("Interface\\FriendsFrame\\BroadcastIcon")

	local BroadcastFrame = FriendsFrameBattlenetFrame.BroadcastFrame
	B.StripTextures(BroadcastFrame)
	B.CreateBG(BroadcastFrame, 10, -10, -10, 10)
	B.ReskinInput(BroadcastFrame.EditBox, 20)
	B.ReskinButton(BroadcastFrame.UpdateButton)
	B.ReskinButton(BroadcastFrame.CancelButton)
	BroadcastFrame:ClearAllPoints()
	BroadcastFrame:SetPoint("TOPLEFT", FriendsFrame, "TOPRIGHT", 0, 0)

	hooksecurefunc(BroadcastFrame, "ShowFrame", B.CleanTextures)
	hooksecurefunc(BroadcastFrame, "HideFrame", B.CleanTextures)

	local UnavailableInfoFrame = FriendsFrameBattlenetFrame.UnavailableInfoFrame
	B.ReskinFrame(UnavailableInfoFrame)
	UnavailableInfoFrame:ClearAllPoints()
	UnavailableInfoFrame:SetPoint("TOPLEFT", FriendsFrame, "TOPRIGHT", 3, -25)

	for i = 1, FRIENDS_TO_DISPLAY do
		local bu = _G["FriendsListFrameScrollFrameButton"..i]
		bu.background:Hide()

		local tp = bu.travelPassButton
		B.ReskinButton(tp)

		local ic = tp:CreateTexture(nil, "OVERLAY")
		ic:SetTexture("Interface\\FriendsFrame\\PlusManz-PlusManz")
		ic:SetPoint("CENTER", 0, 1)
		ic:SetSize(20, 28)

		local gi = bu.gameIcon
		gi:ClearAllPoints()
		gi:SetPoint("RIGHT", tp, "LEFT", -2, 0)

		local hl = bu.highlight
		hl:SetAlpha(.25)
		hl:SetTexture(DB.bdTex)
		hl:SetPoint("BOTTOMRIGHT", tp, "BOTTOMLEFT", -2, 0)
	end

	local function UpdateScroll()
		for i = 1, FRIENDS_TO_DISPLAY do
			local bu = _G["FriendsListFrameScrollFrameButton"..i]

			local isEnabled = bu.travelPassButton:IsEnabled()
			if isEnabled then
				bu.travelPassButton:SetAlpha(1)
			else
				bu.travelPassButton:SetAlpha(.25)
			end
		end
	end
	hooksecurefunc("FriendsFrame_UpdateFriends", UpdateScroll)
	hooksecurefunc(FriendsListFrameScrollFrame, "update", UpdateScroll)

	local function reskinInvites(self)
		for invite in self:EnumerateActive() do
			if not invite.styled then
				B.StripTextures(invite)
				B.ReskinDecline(invite.DeclineButton)
				B.ReskinButton(invite.AcceptButton)
				invite.DeclineButton:SetSize(22, 22)

				local Children = FriendsListFrameScrollFrameScrollChild:GetChildren()
				B.StripTextures(Children)
				B.CleanTextures(Children)

				local bg = B.CreateBDFrame(Children, 0, -C.mult*2)
				B.ReskinHighlight(Children, bg, true)

				invite.styled = true
			end
		end
	end

	hooksecurefunc(FriendsListFrameScrollFrame.invitePool, "Acquire", reskinInvites)
	hooksecurefunc("FriendsFrame_UpdateFriendButton", function(button)
		if button.buttonType == FRIENDS_BUTTON_TYPE_INVITE then
			reskinInvites(FriendsListFrameScrollFrame.invitePool)
		elseif button.buttonType == FRIENDS_BUTTON_TYPE_BNET and BNConnected() then
			local accountInfo = C_BattleNet.GetFriendAccountInfo(button.id)
			if not accountInfo then return end

			local gameAccountInfo = accountInfo.gameAccountInfo
			if gameAccountInfo.isOnline then
				local faction = gameAccountInfo.factionName
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
	B.ReskinInput(WhoEdit, 20, 325)
	WhoEdit:ClearAllPoints()
	WhoEdit:SetPoint("BOTTOMLEFT", WhoWho, "TOPLEFT", 2, 2)

	local WhoBox = WhoFrameEditBox
	WhoBox:ClearAllPoints()
	WhoBox:SetAllPoints(WhoEdit)

	for i = 1, 4 do
		local WhoHeader = _G["WhoFrameColumnHeader"..i]
		B.StripTextures(WhoHeader)

		if i ~= 2 then
			B.ReskinHighlight(WhoHeader, WhoHeader, true)
		end
	end
end)