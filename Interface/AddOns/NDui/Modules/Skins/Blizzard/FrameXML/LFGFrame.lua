local B, C, L, DB = unpack(select(2, ...))

tinsert(C.defaultThemes, function()
	B.ReskinFrame(LFGDungeonReadyStatus)

	B.ReskinFrame(LFGDungeonReadyDialog)
	B.ReskinButton(LFGDungeonReadyDialogEnterDungeonButton)
	B.ReskinButton(LFGDungeonReadyDialogLeaveQueueButton)

	B.ReskinFrame(LFGInvitePopup)
	B.ReskinButton(LFGInvitePopupAcceptButton)
	B.ReskinButton(LFGInvitePopupDeclineButton)

	local function styleRewardButton(button)
		if not button or button.styled then return end

		local buttonName = button:GetName()
		local iconTexture = _G[buttonName.."IconTexture"]
		local shortageBorder = _G[buttonName.."ShortageBorder"]
		local count = _G[buttonName.."Count"]
		local nameFrame = _G[buttonName.."NameFrame"]
		local iconBorder = button.IconBorder

		if shortageBorder then shortageBorder:SetAlpha(0) end
		if count then count:SetDrawLayer("OVERLAY") end
		if iconBorder then iconBorder:SetAlpha(0) end
		if nameFrame then nameFrame:Hide() end

		iconTexture:SetDrawLayer("OVERLAY")
		local icbg = B.ReskinIcon(iconTexture)

		local bubg = B.CreateBDFrame(button, 0)
		bubg:SetPoint("TOPLEFT", icbg, "TOPRIGHT", 2, 0)
		bubg:SetPoint("BOTTOMRIGHT", -5, 1)

		button.styled = true
	end

	hooksecurefunc("LFGRewardsFrame_UpdateFrame", function(parentFrame)
		local parentName = parentFrame:GetName()

		for i = 1, parentFrame.numRewardFrames do
			local itemReward = _G[parentName.."Item"..i]
			styleRewardButton(itemReward)
		end

		local moneyReward = parentFrame.MoneyReward
		styleRewardButton(moneyReward)
	end)

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
	local roleBG = B.ReskinRoleIcon(roleIcon)

	local rewardFrame = LFGDungeonReadyDialogRewardsFrame
	local rewardLabel = LFGDungeonReadyDialogRewardsFrameLabel

	hooksecurefunc("LFGDungeonReadyPopup_Update", function()
		LFGDungeonReadyDialog.SetBackdrop = B.Dummy
		leaderIcon.bg:SetShown(leaderIcon:IsShown())
		rewardLabel:Hide()
		rewardFrame:ClearAllPoints()

		if LFGDungeonReadyDialogRoleIcon:IsShown() then
			local role = select(7, GetLFGProposal())
			if not role or role == "NONE" then role = "DAMAGER" end

			roleIcon:SetTexCoord(B.GetRoleTexCoord(role))
			roleBG:Show()
			rewardFrame:SetPoint("BOTTOMLEFT", LFGDungeonReadyDialogRoleIcon, "BOTTOMRIGHT", 15, 0)
		else
			roleBG:Hide()
			rewardFrame:SetPoint("BOTTOM", LFGDungeonReadyDialogRoleIcon, "BOTTOM", 0, 15)
		end
	end)

	local function reskinDialogReward(button)
		if not button.styled then
			B.ReskinIcon(button.texture)

			local border = _G[button:GetName().."Border"]
			border:Hide()

			button.styled = true
		end
	end

	hooksecurefunc("LFGDungeonReadyDialogReward_SetMisc", function(button)
		reskinDialogReward(button)
		button.texture:SetTexture("Interface\\Icons\\inv_misc_coin_02")
	end)

	hooksecurefunc("LFGDungeonReadyDialogReward_SetReward", function(button, dungeonID, rewardIndex, rewardType, rewardArg)
		reskinDialogReward(button)

		local texturePath
		if rewardType == "reward" then
			texturePath = select(2, GetLFGDungeonRewardInfo(dungeonID, rewardIndex))
		elseif rewardType == "shortage" then
			texturePath = select(2, GetLFGDungeonShortageRewardInfo(dungeonID, rewardArg, rewardIndex))
		end
		if texturePath then
			button.texture:SetTexture(texturePath)
		end
	end)

	local function reskinRoleButton(buttons, role)
		for _, roleButton in pairs(buttons) do
			B.ReskinRole(roleButton, role)
		end
	end

	local tanks = {
		LFDQueueFrameRoleButtonTank,
		LFDRoleCheckPopupRoleButtonTank,
		RaidFinderQueueFrameRoleButtonTank,
		LFGInvitePopupRoleButtonTank,
		LFGListApplicationDialog.TankButton,
		LFGDungeonReadyStatusGroupedTank,
	}
	reskinRoleButton(tanks, "TANK")

	local healers = {
		LFDQueueFrameRoleButtonHealer,
		LFDRoleCheckPopupRoleButtonHealer,
		RaidFinderQueueFrameRoleButtonHealer,
		LFGInvitePopupRoleButtonHealer,
		LFGListApplicationDialog.HealerButton,
		LFGDungeonReadyStatusGroupedHealer,
	}
	reskinRoleButton(healers, "HEALER")

	local dps = {
		LFDQueueFrameRoleButtonDPS,
		LFDRoleCheckPopupRoleButtonDPS,
		RaidFinderQueueFrameRoleButtonDPS,
		LFGInvitePopupRoleButtonDPS,
		LFGListApplicationDialog.DamagerButton,
		LFGDungeonReadyStatusGroupedDamager,
	}
	reskinRoleButton(dps, "DPS")

	B.ReskinRole(LFDQueueFrameRoleButtonLeader, "LEADER")
	B.ReskinRole(RaidFinderQueueFrameRoleButtonLeader, "LEADER")
	B.ReskinRole(LFGDungeonReadyStatusRolelessReady, "READY")

	hooksecurefunc("SetCheckButtonIsRadio", function(button)
		B.CleanTextures(button)

		button:SetCheckedTexture("Interface\\Buttons\\UI-CheckBox-Check")
		button:GetCheckedTexture():SetTexCoord(0, 1, 0, 1)
		button:SetDisabledCheckedTexture("Interface\\Buttons\\UI-CheckBox-Check-Disabled")
		button:GetDisabledCheckedTexture():SetTexCoord(0, 1, 0, 1)
	end)

	local function updateRoleBonus(roleButton)
		if not roleButton.bg then return end
		if roleButton.shortageBorder and roleButton.shortageBorder:IsShown() then
			if roleButton.cover:IsShown() then
				roleButton.bg:SetBackdropBorderColor(.5, .45, .03)
			else
				roleButton.bg:SetBackdropBorderColor(1, .9, .06)
			end
		else
			roleButton.bg:SetBackdropBorderColor(0, 0, 0)
		end
	end

	hooksecurefunc("LFG_SetRoleIconIncentive", function(roleButton, incentiveIndex)
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

		updateRoleBonus(roleButton)
	end)

	hooksecurefunc("LFG_EnableRoleButton", updateRoleBonus)

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

	hooksecurefunc("LFGDungeonReadyStatusIndividual_UpdateIcon", function(button)
		local role = select(2, GetLFGProposalMember(button:GetID()))
		button.texture:SetTexCoord(B.GetRoleTexCoord(role))
	end)

	hooksecurefunc("LFGDungeonReadyStatusGrouped_UpdateIcon", function(button, role)
		button.texture:SetTexCoord(B.GetRoleTexCoord(role))
	end)
end)