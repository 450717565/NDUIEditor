local _, ns = ...
local B, C, L, DB = unpack(ns)

local cr, cg, cb = DB.cr, DB.cg, DB.cb

local function Reskin_LFGDungeonListButton(button)
	if not button.styled then
		B.ReskinCheck(button.enableButton)
		B.ReskinCollapse(button.expandOrCollapseButton)

		button.styled = true
	end

	button.enableButton:GetCheckedTexture():SetDesaturated(true)
end

local function Reskin_Reward(self)
	if self and not self.styled then
		local nameFrame = B.GetObject(self, "NameFrame")
		local iconBorder = B.GetObject(self, "IconBorder")
		local iconTexture = B.GetObject(self, "IconTexture")
		local shortageBorder = B.GetObject(self, "ShortageBorder")

		local icbg = B.ReskinIcon(iconTexture)
		local bubg = B.CreateBGFrame(self, C.margin, 0, -5, 0, icbg)
		B.ReskinBorder(self.IconBorder, icbg, bubg)

		if nameFrame then nameFrame:Hide() end
		if shortageBorder then shortageBorder:SetTexture("") end

		self.styled = true
	end
end

local function Reskin_DialogReward(self)
	if not self.styled then
		B.ReskinIcon(self.texture)

		B.GetObject(self, "Border"):Hide()

		self.styled = true
	end
end

local function Update_LFGRewardsFrame(parentFrame, _, index)
	local parentName = parentFrame:GetDebugName()
	local button = _G[parentName.."Item"..index]
	Reskin_Reward(button)

	local moneyReward = parentFrame.MoneyReward
	Reskin_Reward(moneyReward)
end

local function Reskin_SetMisc(button)
	Reskin_DialogReward(button)
	button.texture:SetTexture("Interface\\Icons\\inv_misc_coin_02")
end

local function Reskin_SetReward(button, dungeonID, rewardIndex, rewardType, rewardArg)
	Reskin_DialogReward(button)

	local texturePath
	if rewardType == "reward" then
		texturePath = select(2, GetLFGDungeonRewardInfo(dungeonID, rewardIndex))
	elseif rewardType == "shortage" then
		texturePath = select(2, GetLFGDungeonShortageRewardInfo(dungeonID, rewardArg, rewardIndex))
	end
	if texturePath then
		button.texture:SetTexture(texturePath)
	end
end

local function Reskin_LFGDungeonReadyPopup()
	LFGDungeonReadyDialog.SetBackdrop = B.Dummy
	LFGDungeonReadyDialogRoleIconLeaderIcon.icbg:SetShown(LFGDungeonReadyDialogRoleIconLeaderIcon:IsShown())
	LFGDungeonReadyDialogRewardsFrameLabel:Hide()
	LFGDungeonReadyDialogRewardsFrame:ClearAllPoints()

	if LFGDungeonReadyDialogRoleIcon:IsShown() then
		local role = select(7, GetLFGProposal())
		if not role or role == "NONE" then role = "DAMAGER" end

		LFGDungeonReadyDialogRoleIconTexture:SetTexCoord(B.GetRoleTexCoord(role))
		LFGDungeonReadyDialogRoleIconTexture.icbg:Show()
		LFGDungeonReadyDialogRewardsFrame:SetPoint("BOTTOMLEFT", LFGDungeonReadyDialogRoleIcon, "BOTTOMRIGHT", 15, 0)
	else
		LFGDungeonReadyDialogRoleIconTexture.icbg:Hide()
		LFGDungeonReadyDialogRewardsFrame:SetPoint("BOTTOM", LFGDungeonReadyDialogRoleIcon, "BOTTOM", 0, 15)
	end
end

local function Reskin_SetCheckButtonIsRadio(button)
	B.CleanTextures(button)

	button:SetCheckedTexture("Interface\\Buttons\\UI-CheckBox-Check")
	button:GetCheckedTexture():SetTexCoord(0, 1, 0, 1)
	button:SetDisabledCheckedTexture("Interface\\Buttons\\UI-CheckBox-Check-Disabled")
	button:GetDisabledCheckedTexture():SetTexCoord(0, 1, 0, 1)
end

local function Update_EnableRoleButton(roleButton)
	if not roleButton.icbg then return end
	if roleButton.shortageBorder and roleButton.shortageBorder:IsShown() then
		if roleButton.cover:IsShown() then
			roleButton.icbg:SetBackdropBorderColor(.5, .45, .03)
		else
			roleButton.icbg:SetBackdropBorderColor(1, .9, .06)
		end
	else
		roleButton.icbg:SetBackdropBorderColor(0, 0, 0)
	end
end

local function Reskin_SetRoleIconIncentive(roleButton, incentiveIndex)
	if incentiveIndex then
		local tex
		if incentiveIndex == LFG_ROLE_SHORTAGE_PLENTIFUL then
			tex = "Interface\\Icons\\INV_Misc_Coin_19"
		elseif incentiveIndex == LFG_ROLE_SHORTAGE_UNCOMMON then
			tex = "Interface\\Icons\\INV_Misc_Coin_18"
		elseif incentiveIndex == LFG_ROLE_SHORTAGE_RARE then
			tex = "Interface\\Icons\\INV_Misc_Coin_17"
		end
		roleButton.incentiveIcon.texture:SetTexture(tex)
	end

	Update_EnableRoleButton(roleButton)
end

local function Reskin_LFGDungeonReadyStatusIndividual(button)
	local role = select(2, GetLFGProposalMember(button:GetID()))
	button.texture:SetTexCoord(B.GetRoleTexCoord(role))
end

local function Reskin_LFGDungeonReadyStatusGrouped(button, role)
	button.texture:SetTexCoord(B.GetRoleTexCoord(role))
end

C.OnLoginThemes["LFGFinderFrame"] = function()
	B.StripTextures(LFDParentFrame)
	B.StripTextures(LFDQueueFrame, 0)
	B.StripTextures(RaidFinderFrame)
	B.StripTextures(RaidFinderQueueFrame, 0)

	B.ReskinFrame(LFDRoleCheckPopup)
	B.ReskinFrame(LFGDungeonReadyDialog)
	B.ReskinFrame(LFGDungeonReadyStatus)
	B.ReskinFrame(LFGInvitePopup)

	B.ReskinDropDown(LFDQueueFrameTypeDropDown)
	B.ReskinDropDown(RaidFinderQueueFrameSelectionDropDown)
	B.ReskinScroll(LFDQueueFrameRandomScrollFrameScrollBar)
	B.ReskinScroll(LFDQueueFrameSpecificListScrollFrameScrollBar)
	B.ReskinScroll(RaidFinderQueueFrameScrollFrameScrollBar)

	Reskin_Reward(LFDQueueFrameRandomScrollFrameChildFrameMoneyReward)
	Reskin_Reward(RaidFinderQueueFrameScrollFrameChildFrameMoneyReward)

	local buttons = {
		LFDQueueFrameFindGroupButton,
		LFDQueueFrameNoLFDWhileLFRLeaveQueueButton,
		LFDQueueFramePartyBackfillBackfillButton,
		LFDQueueFramePartyBackfillNoBackfillButton,
		LFDRoleCheckPopupAcceptButton,
		LFDRoleCheckPopupDeclineButton,
		LFGDungeonReadyDialogEnterDungeonButton,
		LFGDungeonReadyDialogLeaveQueueButton,
		LFGInvitePopupAcceptButton,
		LFGInvitePopupDeclineButton,
		RaidFinderFrameFindRaidButton,
		RaidFinderQueueFrameIneligibleFrameLeaveQueueButton,
		RaidFinderQueueFramePartyBackfillBackfillButton,
		RaidFinderQueueFramePartyBackfillNoBackfillButton,
	}
	for _, button in pairs(buttons) do
		B.ReskinButton(button)
	end

	local tank = {
		LFDQueueFrameRoleButtonTank,
		LFDRoleCheckPopupRoleButtonTank,
		LFGDungeonReadyStatusGroupedTank,
		LFGInvitePopupRoleButtonTank,
		LFGListApplicationDialog.TankButton,
		RaidFinderQueueFrameRoleButtonTank,
	}
	for _, button in pairs(tank) do
		B.ReskinRole(button, "TANK")
	end

	local healer = {
		LFDQueueFrameRoleButtonHealer,
		LFDRoleCheckPopupRoleButtonHealer,
		LFGDungeonReadyStatusGroupedHealer,
		LFGInvitePopupRoleButtonHealer,
		LFGListApplicationDialog.HealerButton,
		RaidFinderQueueFrameRoleButtonHealer,
	}
	for _, button in pairs(healer) do
		B.ReskinRole(button, "HEALER")
	end

	local dps = {
		LFDQueueFrameRoleButtonDPS,
		LFDRoleCheckPopupRoleButtonDPS,
		LFGDungeonReadyStatusGroupedDamager,
		LFGInvitePopupRoleButtonDPS,
		LFGListApplicationDialog.DamagerButton,
		RaidFinderQueueFrameRoleButtonDPS,
	}
	for _, button in pairs(dps) do
		B.ReskinRole(button, "DPS")
	end

	B.ReskinRole(LFDQueueFrameRoleButtonLeader, "LEADER")
	B.ReskinRole(RaidFinderQueueFrameRoleButtonLeader, "LEADER")
	B.ReskinRole(LFGDungeonReadyStatusRolelessReady, "READY")

	local roleDescription = LFGDungeonReadyDialogYourRoleDescription
	roleDescription:ClearAllPoints()
	roleDescription:SetPoint("BOTTOMRIGHT", LFGDungeonReadyDialogRoleIcon, "LEFT", -10, 0)

	local roleLabel = LFGDungeonReadyDialogRoleLabel
	roleLabel:ClearAllPoints()
	roleLabel:SetPoint("TOP", roleDescription, "BOTTOM", 0, -3)

	local leaderIcon = LFGDungeonReadyDialogRoleIconLeaderIcon
	B.ReskinRole(leaderIcon, "LEADER")
	leaderIcon:ClearAllPoints()
	leaderIcon:SetPoint("BOTTOM", roleDescription, "TOP", 0, 5)

	local roleIcon = LFGDungeonReadyDialogRoleIconTexture
	local icbg = B.ReskinRoleIcon(roleIcon)
	roleIcon.icbg = icbg

	for i = 1, 5 do
		local roleButton = _G["LFGDungeonReadyStatusIndividualPlayer"..i]
		B.ReskinRoleIcon(roleButton.texture)
		roleButton:ClearAllPoints()
		if i == 1 then
			roleButton:SetPoint("LEFT", 7, 0)
		else
			roleButton:SetPoint("LEFT", _G["LFGDungeonReadyStatusIndividualPlayer"..(i-1)], "RIGHT", 4, 0)
		end
	end

	hooksecurefunc("LFG_EnableRoleButton", Update_EnableRoleButton)
	hooksecurefunc("LFG_SetRoleIconIncentive", Reskin_SetRoleIconIncentive)
	hooksecurefunc("LFGDungeonListButton_SetDungeon", Reskin_LFGDungeonListButton)
	hooksecurefunc("LFGDungeonReadyDialogReward_SetMisc", Reskin_SetMisc)
	hooksecurefunc("LFGDungeonReadyDialogReward_SetReward", Reskin_SetReward)
	hooksecurefunc("LFGDungeonReadyPopup_Update", Reskin_LFGDungeonReadyPopup)
	hooksecurefunc("LFGDungeonReadyStatusGrouped_UpdateIcon", Reskin_LFGDungeonReadyStatusGrouped)
	hooksecurefunc("LFGDungeonReadyStatusIndividual_UpdateIcon", Reskin_LFGDungeonReadyStatusIndividual)
	hooksecurefunc("LFGRewardsFrame_SetItemButton", Update_LFGRewardsFrame)
	hooksecurefunc("SetCheckButtonIsRadio", Reskin_SetCheckButtonIsRadio)
end