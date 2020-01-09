local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	F.ReskinFrame(FriendsFrame)
	F.SetupTabStyle(FriendsFrame, 4)
	F.ReskinFrame(AddFriendFrame)
	F.ReskinInput(AddFriendNameEditBox)

	F.StripTextures(FriendsFriendsFrame, true)
	F.CreateBD(FriendsFriendsFrame)
	F.StripTextures(FriendsFriendsFrame.ScrollFrameBorder, true)
	F.CreateBDFrame(FriendsFriendsFrame.ScrollFrameBorder, 0)

	local lists = {IgnoreListFrame, WhoFrameListInset, WhoFrameEditBoxInset}
	for _, list in pairs(lists) do
		F.StripTextures(list)
	end

	local dropdowns = {FriendsFrameStatusDropDown, FriendsFriendsFrameDropDown, WhoFrameDropDown}
	for _, dropdown in pairs(dropdowns) do
		F.ReskinDropDown(dropdown)
	end

	local scrolls = {FriendsListFrameScrollFrame.scrollBar, IgnoreListFrameScrollFrame.scrollBar, FriendsFriendsScrollFrame.scrollBar, WhoListScrollFrame.scrollBar}
	for _, scroll in pairs(scrolls) do
		F.ReskinScroll(scroll)
	end

	local buttons = {AddFriendEntryFrameAcceptButton, AddFriendEntryFrameCancelButton, AddFriendInfoFrameContinueButton, FriendsFrameAddFriendButton, FriendsFrameIgnorePlayerButton, FriendsFrameSendMessageButton, FriendsFrameUnsquelchButton, FriendsFriendsFrame.CloseButton, FriendsFriendsFrame.SendRequestButton, FriendsListFrameContinueButton, WhoFrameAddFriendButton, WhoFrameGroupInviteButton, WhoFrameWhoButton}
	for _, button in pairs(buttons) do
		F.ReskinButton(button)
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

	-- FriendsFrameBattlenetFrame
	F.StripTextures(FriendsFrameBattlenetFrame)

	local BroadcastButton = FriendsFrameBattlenetFrame.BroadcastButton
	BroadcastButton:SetSize(20, 20)
	BroadcastButton:ClearAllPoints()
	BroadcastButton:SetPoint("LEFT", FriendsFrameStatusDropDownButton, "RIGHT", 1, 0)
	F.ReskinButton(BroadcastButton)
	local newIcon = BroadcastButton:CreateTexture(nil, "ARTWORK")
	newIcon:SetAllPoints()
	newIcon:SetTexture("Interface\\FriendsFrame\\BroadcastIcon")

	local BroadcastFrame = FriendsFrameBattlenetFrame.BroadcastFrame
	F.StripTextures(BroadcastFrame)
	F.SetBDFrame(BroadcastFrame, 10, -10, -10, 10)
	F.ReskinInput(BroadcastFrame.EditBox, 20)
	F.ReskinButton(BroadcastFrame.UpdateButton)
	F.ReskinButton(BroadcastFrame.CancelButton)
	BroadcastFrame:ClearAllPoints()
	BroadcastFrame:SetPoint("TOPLEFT", FriendsFrame, "TOPRIGHT", 0, 0)

	local function BroadcastButton_SetTexture(self)
		self.BroadcastButton:SetNormalTexture("")
		self.BroadcastButton:SetPushedTexture("")
	end
	hooksecurefunc(BroadcastFrame, "ShowFrame", BroadcastButton_SetTexture)
	hooksecurefunc(BroadcastFrame, "HideFrame", BroadcastButton_SetTexture)

	local UnavailableInfoFrame = FriendsFrameBattlenetFrame.UnavailableInfoFrame
	F.ReskinFrame(UnavailableInfoFrame)
	UnavailableInfoFrame:ClearAllPoints()
	UnavailableInfoFrame:SetPoint("TOPLEFT", FriendsFrame, "TOPRIGHT", 3, -25)

	for i = 1, FRIENDS_TO_DISPLAY do
		local bu = _G["FriendsListFrameScrollFrameButton"..i]
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
		hl:SetAlpha(.25)
		hl:SetTexture(C.media.bdTex)
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

	local icPatch = "Interface\\FriendsFrame\\"

	local function reskinInvites(self)
		for invite in self:EnumerateActive() do
			if not invite.styled then
				F.StripTextures(invite)
				F.ReskinDecline(invite.DeclineButton)
				F.ReskinButton(invite.AcceptButton)
				invite.DeclineButton:SetSize(22, 22)

				local Children = FriendsListFrameScrollFrameScrollChild:GetChildren()
				F.StripTextures(Children)
				F.CleanTextures(Children)

				local bg = F.CreateBDFrame(Children, 0, -C.pixel)
				F.ReskinTexture(Children, bg, true)

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