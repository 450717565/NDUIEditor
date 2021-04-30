local _, ns = ...
local B, C, L, DB = unpack(ns)

-- 好友
local icPatch = "Interface\\Addons\\NDui\\Media\\Other\\"

local function Update_UpdateFriends()
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

local function Reskin_InvitePool(self)
	for invite in self:EnumerateActive() do
		if invite and not invite.styled then
			B.StripTextures(invite)
			B.ReskinDecline(invite.DeclineButton)
			B.ReskinButton(invite.AcceptButton)
			invite.DeclineButton:SetSize(22, 22)

			local Children = FriendsListFrameScrollFrameScrollChild:GetChildren()
			B.StripTextures(Children)
			B.CleanTextures(Children)

			local bg = B.CreateBDFrame(Children, 0, 1)
			B.ReskinHighlight(Children, bg, true)

			invite.styled = true
		end
	end
end

local function Reskin_UpdateFriendButton(button)
	if button.buttonType == FRIENDS_BUTTON_TYPE_INVITE then
		Reskin_InvitePool(FriendsListFrameScrollFrame.invitePool)
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
end

local function Reskin_RecruitAFriendRewardsFrame(self)
	for _, child in pairs {self:GetChildren()} do
		local button = child and child.Button
		if button and not button.styled then
			local icbg = B.ReskinIcon(button.Icon)
			B.ReskinHighlight(button, icbg)
			B.ReskinBorder(button.IconBorder, icbg)

			button.styled = true
		end
	end
end

tinsert(C.XMLThemes, function()
	-- FriendsFrame
	B.ReskinFrame(FriendsFrame)
	B.ReskinFrameTab(FriendsFrame, 4)
	B.ReskinFrame(AddFriendFrame)
	B.ReskinInput(AddFriendNameEditBox)
	B.ReskinDropDown(FriendsFrameStatusDropDown)
	B.ReskinDropDown(FriendsFriendsFrameDropDown)

	local lists = {
		IgnoreListFrame,
		FriendsFriendsFrame,
		FriendsFriendsFrame.ScrollFrameBorder,
		FriendsFrameBattlenetFrame,
	}
	for _, list in pairs(lists) do
		B.StripTextures(list)
	end

	local scrolls = {
		FriendsListFrameScrollFrame.scrollBar,
		IgnoreListFrameScrollFrame.scrollBar,
		FriendsFriendsScrollFrame.scrollBar,
	}
	for _, scroll in pairs(scrolls) do
		B.ReskinScroll(scroll)
	end

	local buttons = {
		AddFriendEntryFrameAcceptButton,
		AddFriendEntryFrameCancelButton,
		AddFriendInfoFrameContinueButton,
		FriendsFrameAddFriendButton,
		FriendsFrameIgnorePlayerButton,
		FriendsFrameSendMessageButton,
		FriendsFrameUnsquelchButton,
		FriendsFriendsFrame.CloseButton,
		FriendsFriendsFrame.SendRequestButton,
		FriendsListFrameContinueButton,
	}
	for _, button in pairs(buttons) do
		B.ReskinButton(button)
	end

	B.CreateBG(FriendsFriendsFrame)
	B.CreateBDFrame(FriendsFriendsFrame.ScrollFrameBorder)

	local bls = {
		FriendsFrameAddFriendButton,
		FriendsFrameIgnorePlayerButton,
	}
	for _, bl in pairs(bls) do
		bl:SetSize(134, 20)
		bl:ClearAllPoints()
		bl:SetPoint("BOTTOMLEFT", 6, 4)
	end

	local brs = {
		FriendsFrameSendMessageButton,
		FriendsFrameUnsquelchButton,
	}
	for _, br in pairs(brs) do
		br:SetSize(134, 20)
		br:ClearAllPoints()
		br:SetPoint("BOTTOMRIGHT", -6, 4)
	end

	for i = 1, 3 do
		local FriendsHeader = _G["FriendsTabHeaderTab"..i]
		B.StripTextures(FriendsHeader)
	end

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
		hl:SetTexture(DB.bgTex)
		hl:SetPoint("BOTTOMRIGHT", tp, "BOTTOMLEFT", -2, 0)
	end

	FriendsFrameTitleText:ClearAllPoints()
	FriendsFrameTitleText:SetPoint("TOP", 0, -8)
	FriendsFrameStatusDropDown:ClearAllPoints()
	FriendsFrameStatusDropDown:SetPoint("TOPLEFT", 15, -25)
	FriendsFrameStatusDropDownStatus:ClearAllPoints()
	FriendsFrameStatusDropDownStatus:SetPoint("RIGHT", FriendsFrameStatusDropDownButton, "LEFT", -4, -.5)

	hooksecurefunc("FriendsFrame_UpdateFriends", Update_UpdateFriends)
	hooksecurefunc("FriendsFrame_UpdateFriendButton", Reskin_UpdateFriendButton)
	hooksecurefunc(FriendsListFrameScrollFrame, "update", Update_UpdateFriends)
	hooksecurefunc(FriendsListFrameScrollFrame.invitePool, "Acquire", Reskin_InvitePool)

	-- RecruitAFriendFrame
	B.ReskinButton(RecruitAFriendFrame.RecruitmentButton)

	local RewardClaiming = RecruitAFriendFrame.RewardClaiming
	B.StripTextures(RewardClaiming)
	B.ReskinButton(RewardClaiming.ClaimOrViewRewardButton)

	local SplashFrame = RecruitAFriendFrame.SplashFrame
	B.ReskinButton(SplashFrame.OKButton)
	B.ReskinText(SplashFrame.Title, 1, .8, 0)
	B.ReskinText(SplashFrame.Description, 1, 1, 1)

	local RecruitList = RecruitAFriendFrame.RecruitList
	B.StripTextures(RecruitList.Header)
	B.CreateBDFrame(RecruitList.Header)
	B.ReskinScroll(RecruitList.ScrollFrame.scrollBar)
	RecruitList.ScrollFrameInset:Hide()

	local RecruitmentFrame = RecruitAFriendRecruitmentFrame
	B.ReskinFrame(RecruitmentFrame)
	B.ReskinButton(RecruitmentFrame.GenerateOrCopyLinkButton)
	B.ReskinInput(RecruitmentFrame.EditBox, 20)

	B.ReskinFrame(RecruitAFriendRewardsFrame)
	RecruitAFriendRewardsFrame:HookScript("OnShow", Reskin_RecruitAFriendRewardsFrame)
end)

-- 查询
tinsert(C.XMLThemes, function()
	B.StripTextures(WhoFrameListInset)
	B.StripTextures(WhoFrameEditBoxInset)

	B.ReskinDropDown(WhoFrameDropDown)
	B.ReskinScroll(WhoListScrollFrame.scrollBar)

	local FriendButton = WhoFrameAddFriendButton
	B.ReskinButton(FriendButton)
	FriendButton:ClearAllPoints()
	FriendButton:SetPoint("BOTTOM", WhoFrame, "BOTTOM", -17.5, 4)

	local WhoButton = WhoFrameWhoButton
	B.ReskinButton(WhoButton)
	WhoButton:ClearAllPoints()
	WhoButton:SetPoint("RIGHT", FriendButton, "LEFT", -1, 0)

	local InviteButton = WhoFrameGroupInviteButton
	B.ReskinButton(InviteButton)
	InviteButton:ClearAllPoints()
	InviteButton:SetPoint("LEFT", FriendButton, "RIGHT", 1, 0)

	local EditBoxInset = WhoFrameEditBoxInset
	B.ReskinInput(EditBoxInset, 20, 327)
	EditBoxInset:ClearAllPoints()
	EditBoxInset:SetPoint("BOTTOMLEFT", WhoButton, "TOPLEFT", 2+C.mult, 1)

	local EditBox = WhoFrameEditBox
	EditBox:ClearAllPoints()
	EditBox:SetAllPoints(EditBoxInset)

	for i = 1, 4 do
		local ColumnHeader = _G["WhoFrameColumnHeader"..i]
		B.StripTextures(ColumnHeader)

		if i ~= 2 then
			B.ReskinHighlight(ColumnHeader, ColumnHeader, true)
		end
	end
end)

-- 团队
tinsert(C.XMLThemes, function()
	-- RaidInfo
	B.ReskinFrame(RaidInfoFrame)

	B.ReskinButton(RaidFrameRaidInfoButton)
	B.ReskinButton(RaidInfoCancelButton)
	B.ReskinButton(RaidInfoExtendButton)
	B.ReskinCheck(RaidFrameAllAssistCheckButton)
	B.ReskinClose(RaidInfoCloseButton)
	B.ReskinScroll(RaidInfoScrollFrameScrollBar)

	RaidInfoFrame:ClearAllPoints()
	RaidInfoFrame:SetPoint("TOPLEFT", RaidFrame, "TOPRIGHT", 3, -25)
	RaidFrameRaidInfoButton:ClearAllPoints()
	RaidFrameRaidInfoButton:SetPoint("TOPRIGHT", FriendsFrame.CloseButton, "BOTTOMRIGHT", 0, -2)
	RaidFrame.RoleCount:ClearAllPoints()
	RaidFrame.RoleCount:SetPoint("RIGHT", RaidFrameRaidInfoButton, "LEFT", 0, 0)
	RaidFrameAllAssistCheckButton:ClearAllPoints()
	RaidFrameAllAssistCheckButton:SetPoint("RIGHT", RaidFrame.RoleCount, "LEFT", -60, 0)

	local ConvertButton = RaidFrameConvertToRaidButton
	B.ReskinButton(RaidFrameConvertToRaidButton)
	ConvertButton:SetSize(134, 20)
	ConvertButton:ClearAllPoints()
	ConvertButton:SetPoint("BOTTOMRIGHT", -6, 4)

	local labels =  {
		RaidInfoInstanceLabel,
		RaidInfoIDLabel,
	}
	for _, label in pairs(labels) do
		B.StripTextures(label)
		B.CreateBDFrame(label, 0, 1)
	end
end)

C.LUAThemes["Blizzard_RaidUI"] = function()
	for i = 1, NUM_RAID_GROUPS do
		local buttons = "RaidGroup"..i

		local group = _G[buttons]
		B.StripTextures(group)

		for j = 1, MEMBERS_PER_RAID_GROUP do
			local slot = _G[buttons.."Slot"..j]
			slot:GetRegions():Hide()

			B.CreateBDFrame(slot)
			B.ReskinHighlight(slot, slot, true)
		end
	end

	for i = 1, MAX_RAID_MEMBERS do
		local buttons = "RaidGroupButton"..i

		local button = _G[buttons]
		select(4, button:GetRegions()):SetAlpha(0)
		B.ReskinHighlight(button, button, true)

		local class = _G[buttons.."Class"]
		class:Hide()

		local level = _G[buttons.."Level"]
		level:SetWidth(30)
		level:SetJustifyH("RIGHT")
		level:ClearAllPoints()
		level:SetPoint("RIGHT", button, "RIGHT", -2, 0)

		local name = _G[buttons.."Name"]
		name:SetWidth(100)
		name:SetJustifyH("LEFT")
		name:ClearAllPoints()
		name:SetPoint("RIGHT", level, "LEFT", -2, 0)
	end
end

-- 快速加入
local roleAtlas = {
	["tank"] = "Soulbinds_Tree_Conduit_Icon_Protect",
	["heal"] = "ui_adv_health",
	["dps"] = "ui_adv_atk",
}
local function Reskin_SocialQueueUtilTooltip(tooltip)
	for i = 2, tooltip:NumLines() do
		local line = _G[tooltip:GetName().."TextLeft"..i]
		if not line then return end

		local text = line:GetText()
		if text and text ~= "" and strfind(text, QUICK_JOIN_TOOLTIP_AVAILABLE_ROLES) then
			local roleIcons = ""
			for role in gmatch(text, "|A:[%a%-]-(%a+):[%d+:]+|a") do
				roleIcons = roleIcons..CreateAtlasMarkup(roleAtlas[role], 20, 20)
			end
			if roleIcons ~= "" then
				line:SetText(format(QUICK_JOIN_TOOLTIP_AVAILABLE_ROLES.."%s", roleIcons))
			end

			return
		end
	end
end

tinsert(C.XMLThemes, function()
	B.ReskinScroll(QuickJoinScrollFrame.scrollBar)

	local JoinQueueButton = QuickJoinFrame.JoinQueueButton
	B.ReskinButton(JoinQueueButton)
	JoinQueueButton:SetSize(134, 20)
	JoinQueueButton:ClearAllPoints()
	JoinQueueButton:SetPoint("BOTTOMRIGHT", -6, 4)

	local frame = QuickJoinRoleSelectionFrame
	B.ReskinFrame(frame)
	B.ReskinButton(frame.AcceptButton)
	B.ReskinButton(frame.CancelButton)
	B.ReskinRole(frame.RoleButtonTank, "TANK")
	B.ReskinRole(frame.RoleButtonHealer, "HEALER")
	B.ReskinRole(frame.RoleButtonDPS, "DPS")

	hooksecurefunc("SocialQueueUtil_SetTooltip", Reskin_SocialQueueUtilTooltip)
end)