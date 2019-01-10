local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	local function styleRewardButton(button)
		local buttonName = button:GetName()

		local icon = _G[buttonName.."IconTexture"]
		icon:SetDrawLayer("OVERLAY")

		local name = _G[buttonName.."NameFrame"]
		name:Hide()

		local count = _G[buttonName.."Count"]
		count:SetDrawLayer("OVERLAY")

		local ic = F.ReskinIcon(icon, true)

		local bg = F.CreateBDFrame(button, .25)
		bg:SetPoint("TOPLEFT", ic, "TOPRIGHT", 2, 0)
		bg:SetPoint("BOTTOMRIGHT", -5, 1)

		local cta = _G[buttonName.."ShortageBorder"]
		if cta then cta:SetAlpha(0) end

		if button.IconBorder then
			button.IconBorder:SetAlpha(0)
		end
	end

	hooksecurefunc("LFDQueueFrameRandom_UpdateFrame", function()
		for i = 1, 4 do
			local button = _G["LFDQueueFrameRandomScrollFrameChildFrameItem"..i]
			if button and not button.styled then
				styleRewardButton(button)
				button.styled = true
			end
		end
	end)
	hooksecurefunc("ScenarioQueueFrameRandom_UpdateFrame", function()
		for i = 1, 2 do
			local button = _G["ScenarioQueueFrameRandomScrollFrameChildFrameItem"..i]
			if button and not button.styled then
				styleRewardButton(button)
				button.styled = true
			end
		end
	end)
	hooksecurefunc("RaidFinderQueueFrameRewards_UpdateFrame", function()
		for i = 1, 4 do
			local button = _G["RaidFinderQueueFrameScrollFrameChildFrameItem"..i]

			if button and not button.styled then
				styleRewardButton(button)
				button.styled = true
			end
		end
	end)

	styleRewardButton(LFDQueueFrameRandomScrollFrameChildFrame.MoneyReward)
	styleRewardButton(ScenarioQueueFrameRandomScrollFrameChildFrame.MoneyReward)
	styleRewardButton(RaidFinderQueueFrameScrollFrameChildFrame.MoneyReward)

	LFGDungeonReadyDialogBackground:Hide()
	LFGDungeonReadyDialogBottomArt:Hide()
	LFGDungeonReadyDialogFiligree:Hide()

	local function styleDungeonReady(button)
		F.ReskinIcon(button.texture, true)

		local border = _G[button:GetName().."Border"]
		border:Hide()
	end

	hooksecurefunc("LFGDungeonReadyDialogReward_SetMisc", function(button)
		if not button.styled then
			styleDungeonReady(button)
			button.styled = true
		end

		button.texture:SetTexture("Interface\\Icons\\inv_misc_coin_02")
	end)

	hooksecurefunc("LFGDungeonReadyDialogReward_SetReward", function(button, dungeonID, rewardIndex, rewardType, rewardArg)
		if not button.styled then
			styleDungeonReady(button)
			button.styled = true
		end

		local name, texturePath, quantity
		if rewardType == "reward" then
			name, texturePath, quantity = GetLFGDungeonRewardInfo(dungeonID, rewardIndex);
		elseif rewardType == "shortage" then
			name, texturePath, quantity = GetLFGDungeonShortageRewardInfo(dungeonID, rewardArg, rewardIndex);
		end
		if texturePath then
			button.texture:SetTexture(texturePath)
		end
	end)

	F.CreateBD(LFGInvitePopup)
	F.CreateSD(LFGInvitePopup)
	F.ReskinPortraitFrame(LFGDungeonReadyStatus, true)
	F.ReskinPortraitFrame(LFGDungeonReadyDialog, true)
	LFGDungeonReadyDialog.SetBackdrop = F.dummy

	F.Reskin(LFGDungeonReadyDialogEnterDungeonButton)
	F.Reskin(LFGDungeonReadyDialogLeaveQueueButton)
	F.Reskin(LFGInvitePopupAcceptButton)
	F.Reskin(LFGInvitePopupDeclineButton)

	for _, roleButton in next, {LFDQueueFrameRoleButtonTank, LFDQueueFrameRoleButtonHealer, LFDQueueFrameRoleButtonDPS, LFDQueueFrameRoleButtonLeader, LFRQueueFrameRoleButtonTank, LFRQueueFrameRoleButtonHealer, LFRQueueFrameRoleButtonDPS, RaidFinderQueueFrameRoleButtonTank, RaidFinderQueueFrameRoleButtonHealer, RaidFinderQueueFrameRoleButtonDPS, RaidFinderQueueFrameRoleButtonLeader} do
		if roleButton.background then
			roleButton.background:SetTexture("")
		end
		F.ReskinCheck(roleButton.checkButton)

		local shortageBorder = roleButton.shortageBorder
		if shortageBorder then
			shortageBorder:SetTexture("")

			local icon = roleButton.incentiveIcon
			icon.texture:ClearAllPoints()
			icon.texture:SetPoint("BOTTOMRIGHT", roleButton)
			icon.texture:SetSize(13, 13)
			icon.border:Hide()

			icon.bg = F.ReskinIcon(icon.texture, .25)
		end
	end

	for _, roleButton in next, {LFDRoleCheckPopupRoleButtonTank, LFDRoleCheckPopupRoleButtonHealer, LFDRoleCheckPopupRoleButtonDPS, LFGInvitePopupRoleButtonTank, LFGInvitePopupRoleButtonHealer, LFGInvitePopupRoleButtonDPS, LFGListApplicationDialog.DamagerButton, LFGListApplicationDialog.TankButton, LFGListApplicationDialog.HealerButton} do
		local checkButton = roleButton.checkButton or roleButton.CheckButton
		F.StripTextures(checkButton, true)
		F.ReskinCheck(checkButton)
	end

	hooksecurefunc("LFG_SetRoleIconIncentive", function(roleButton, incentiveIndex)
		local icon = roleButton.incentiveIcon

		if incentiveIndex then
			local tex

			if incentiveIndex == LFG_ROLE_SHORTAGE_PLENTIFUL then
				tex = "Interface\\Icons\\INV_Misc_Coin_19"
				icon.bg:SetBackdropBorderColor(.93, .65, .37)
			elseif incentiveIndex == LFG_ROLE_SHORTAGE_UNCOMMON then
				tex = "Interface\\Icons\\INV_Misc_Coin_18"
				icon.bg:SetBackdropBorderColor(.78, .78, .81)
			elseif incentiveIndex == LFG_ROLE_SHORTAGE_RARE then
				tex = "Interface\\Icons\\INV_Misc_Coin_17"
				icon.bg:SetBackdropBorderColor(1, .84, 0)
			end

			roleButton.incentiveIcon.texture:SetTexture(tex)
		else
			icon.bg:SetBackdropBorderColor(0, 0, 0)
		end
	end)
end)