local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	F.ReskinFrame(LFGInvitePopup, true)
	F.ReskinFrame(LFGDungeonReadyDialog)
	F.ReskinFrame(LFGDungeonReadyStatus, true)

	F.ReskinButton(LFGDungeonReadyDialogEnterDungeonButton)
	F.ReskinButton(LFGDungeonReadyDialogLeaveQueueButton)
	F.ReskinButton(LFGInvitePopupAcceptButton)
	F.ReskinButton(LFGInvitePopupDeclineButton)

	local function styleRewardButton(button)
		if not button or button.styled then return end

		local buttonName = button:GetName()
		local icon = _G[buttonName.."IconTexture"]
		local shortageBorder = _G[buttonName.."ShortageBorder"]
		local count = _G[buttonName.."Count"]
		local nameFrame = _G[buttonName.."NameFrame"]
		local border = button.IconBorder

		if shortageBorder then shortageBorder:SetAlpha(0) end
		if count then count:SetDrawLayer("OVERLAY") end
		if nameFrame then nameFrame:SetAlpha(0) end
		if border then border:SetAlpha(0) end

		local icbg = F.ReskinIcon(icon)
		icon:SetDrawLayer("OVERLAY")

		local bubg = F.CreateBDFrame(button, 0)
		bubg:SetPoint("TOPLEFT", icbg, "TOPRIGHT", 2, 0)
		bubg:SetPoint("BOTTOMRIGHT", -5, 1)

		button.styled = true
	end

	hooksecurefunc("LFGRewardsFrame_SetItemButton", function(parentFrame, _, index)
		local parentName = parentFrame:GetName()
		local button = _G[parentName.."Item"..index]
		styleRewardButton(button)

		local moneyReward = parentFrame.MoneyReward
		styleRewardButton(moneyReward)
	end)

	local roleDes = LFGDungeonReadyDialogYourRoleDescription
	roleDes:ClearAllPoints()
	roleDes:SetPoint("BOTTOMRIGHT", LFGDungeonReadyDialogRoleIcon, "LEFT", -10, 0)

	local rolelabel = LFGDungeonReadyDialogRoleLabel
	rolelabel:ClearAllPoints()
	rolelabel:SetPoint("TOP", roleDes, "BOTTOM", 0, -3)

	local leaderIcon = LFGDungeonReadyDialogRoleIconLeaderIcon
	F.ReskinRole(leaderIcon, "LEADER")
	leaderIcon:ClearAllPoints()
	leaderIcon:SetPoint("BOTTOM", roleDes, "TOP", 0, 5)

	local iconTexture = LFGDungeonReadyDialogRoleIconTexture
	local icbg = F.ReskinRoleIcon(LFGDungeonReadyDialogRoleIconTexture)

	local rewardFrame = LFGDungeonReadyDialogRewardsFrame
	local rewardLabel = LFGDungeonReadyDialogRewardsFrameLabel

	hooksecurefunc("LFGDungeonReadyPopup_Update", function()
		LFGDungeonReadyDialog.SetBackdrop = F.Dummy
		leaderIcon.bg:SetShown(leaderIcon:IsShown())

		if LFGDungeonReadyDialogRoleIcon:IsShown() then
			local role = select(7, GetLFGProposal())
			if not role or role == "NONE" then role = "DAMAGER" end
			iconTexture:SetTexCoord(F.GetRoleTexCoord(role))
			icbg:Show()
		else
			icbg:Hide()
		end

		rewardLabel:Hide()
		rewardFrame:ClearAllPoints()
		rewardFrame:SetPoint("BOTTOMLEFT", LFGDungeonReadyDialogRoleIcon, "BOTTOMRIGHT", 15, 0)
	end)

	local function reskinDialogReward(button)
		if not button.styled then
			F.ReskinIcon(button.texture)

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
			F.ReskinRole(roleButton, role)
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

	F.ReskinRole(LFDQueueFrameRoleButtonLeader, "LEADER")
	F.ReskinRole(RaidFinderQueueFrameRoleButtonLeader, "LEADER")
	F.ReskinRole(LFGDungeonReadyStatusRolelessReady, "READY")

	hooksecurefunc("SetCheckButtonIsRadio", function(button)
		F.CleanTextures(button)

		button:SetHighlightTexture(C.media.backdrop)
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
		F.ReskinRoleIcon(roleButton.texture)
		if i == 1 then
			roleButton:SetPoint("LEFT", 7, 0)
		else
			roleButton:SetPoint("LEFT", _G["LFGDungeonReadyStatusIndividualPlayer"..(i-1)], "RIGHT", 4, 0)
		end
	end

	hooksecurefunc("LFGDungeonReadyStatusIndividual_UpdateIcon", function(button)
		local role = select(2, GetLFGProposalMember(button:GetID()))
		button.texture:SetTexCoord(F.GetRoleTexCoord(role))
	end)

	hooksecurefunc("LFGDungeonReadyStatusGrouped_UpdateIcon", function(button, role)
		button.texture:SetTexCoord(F.GetRoleTexCoord(role))
	end)
end)