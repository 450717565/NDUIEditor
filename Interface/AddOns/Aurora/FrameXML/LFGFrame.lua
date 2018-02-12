local F, C = unpack(select(2, ...))

tinsert(C.themes["Aurora"], function()
	local function styleRewardButton(button)
		local buttonName = button:GetName()

		local icon = _G[buttonName.."IconTexture"]
		local cta = _G[buttonName.."ShortageBorder"]
		local count = _G[buttonName.."Count"]
		local na = _G[buttonName.."NameFrame"]

		F.CreateBDFrame(icon)
		icon:SetTexCoord(.08, .92, .08, .92)
		icon:SetDrawLayer("OVERLAY")
		count:SetDrawLayer("OVERLAY")
		na:SetColorTexture(0, 0, 0, .25)
		na:SetSize(113, 39)
		if button.IconBorder then
			button.IconBorder:SetAlpha(0)
		end

		if cta then
			cta:SetAlpha(0)
		end

		button.bg2 = CreateFrame("Frame", nil, button)
		button.bg2:SetPoint("TOPLEFT", na, "TOPLEFT", 10, 0)
		button.bg2:SetPoint("BOTTOMRIGHT", na, "BOTTOMRIGHT")
		F.CreateBD(button.bg2, 0)
		F.CreateSD(button.bg2)
	end

	hooksecurefunc("LFDQueueFrameRandom_UpdateFrame", function()
		for i = 1, 4 do
			local button = _G["LFDQueueFrameRandomScrollFrameChildFrameItem"..i]
			if button and not button.styled then
				styleRewardButton(button)
				button.IconBorder:SetAlpha(0)
				button.styled = true
			end
		end
	end)
	hooksecurefunc("ScenarioQueueFrameRandom_UpdateFrame", function()
		for i = 1, 2 do
			local button = _G["ScenarioQueueFrameRandomScrollFrameChildFrameItem"..i]
			if button and not button.styled then
				styleRewardButton(button)
				button.IconBorder:SetAlpha(0)
				button.styled = true
			end
		end
	end)
	hooksecurefunc("RaidFinderQueueFrameRewards_UpdateFrame", function()
		for i = 1, 4 do
			local button = _G["RaidFinderQueueFrameScrollFrameChildFrameItem"..i]

			if button and not button.styled then
				styleRewardButton(button)
				button.IconBorder:SetAlpha(0)
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

	LFGDungeonReadyDialogRoleIconTexture:SetTexture(C.media.roleIcons)
	LFGDungeonReadyDialogRoleIconLeaderIcon:ClearAllPoints()
	LFGDungeonReadyDialogRoleIconLeaderIcon:SetPoint("TOPLEFT", LFGDungeonReadyDialogRoleIcon, "TOPLEFT")

	do
		F.CreateBDFrame(LFGDungeonReadyDialogRoleIcon, .5, 8, -7, -8, 10)
	end

	hooksecurefunc("LFGDungeonReadyDialogReward_SetMisc", function(button)
		if not button.styled then
			local border = _G[button:GetName().."Border"]

			button.texture:SetTexCoord(.08, .92, .08, .92)
			F.CreateBDFrame(button.texture)

			border:SetColorTexture(0, 0, 0)
			border:SetDrawLayer("BACKGROUND")
			border:SetPoint("TOPLEFT", button.texture, -1, 1)
			border:SetPoint("BOTTOMRIGHT", button.texture, 1, -1)

			button.styled = true
		end

		button.texture:SetTexture("Interface\\Icons\\inv_misc_coin_02")
	end)

	hooksecurefunc("LFGDungeonReadyDialogReward_SetReward", function(button, dungeonID, rewardIndex, rewardType, rewardArg)
		if not button.styled then
			local border = _G[button:GetName().."Border"]

			button.texture:SetTexCoord(.08, .92, .08, .92)
			F.CreateBDFrame(button.texture)

			border:SetColorTexture(0, 0, 0)
			border:SetDrawLayer("BACKGROUND")
			border:SetPoint("TOPLEFT", button.texture, -1, 1)
			border:SetPoint("BOTTOMRIGHT", button.texture, 1, -1)

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

	F.CreateBD(LFGDungeonReadyDialog)
	F.CreateSD(LFGDungeonReadyDialog)
	LFGDungeonReadyDialog.SetBackdrop = F.dummy
	F.CreateBD(LFGInvitePopup)
	F.CreateSD(LFGInvitePopup)
	F.CreateBD(LFGDungeonReadyStatus)
	F.CreateSD(LFGDungeonReadyStatus)

	F.Reskin(LFGDungeonReadyDialogEnterDungeonButton)
	F.Reskin(LFGDungeonReadyDialogLeaveQueueButton)
	F.Reskin(LFGInvitePopupAcceptButton)
	F.Reskin(LFGInvitePopupDeclineButton)
	F.ReskinClose(LFGDungeonReadyDialogCloseButton)
	F.ReskinClose(LFGDungeonReadyStatusCloseButton)

	for _, roleButton in pairs({LFDQueueFrameRoleButtonTank, LFDQueueFrameRoleButtonHealer, LFDQueueFrameRoleButtonDPS, LFDQueueFrameRoleButtonLeader, LFRQueueFrameRoleButtonTank, LFRQueueFrameRoleButtonHealer, LFRQueueFrameRoleButtonDPS, RaidFinderQueueFrameRoleButtonTank, RaidFinderQueueFrameRoleButtonHealer, RaidFinderQueueFrameRoleButtonDPS, RaidFinderQueueFrameRoleButtonLeader}) do
		if roleButton.background then
			roleButton.background:SetTexture("")
		end
		roleButton.cover:SetTexture(C.media.roleIcons)
		roleButton:SetNormalTexture(C.media.roleIcons)
		F.CreateBDFrame(roleButton, .5, 6, -5, -6, 7)

		roleButton.checkButton:SetFrameLevel(roleButton:GetFrameLevel() + 2)
		F.ReskinCheck(roleButton.checkButton)

		local shortageBorder = roleButton.shortageBorder
		if shortageBorder then
			shortageBorder:SetTexture("")

			local icon = roleButton.incentiveIcon
			F.CreateBDFrame(icon, .5, -4, 4, -2, 2)

			icon:SetPoint("BOTTOMRIGHT", 3, -3)
			icon:SetSize(14, 14)
			icon.texture:SetSize(14, 14)
			icon.texture:SetTexCoord(.12, .88, .12, .88)
			icon.border:Hide()
		end
	end

	for _, roleButton in pairs({LFDRoleCheckPopupRoleButtonTank, LFDRoleCheckPopupRoleButtonHealer, LFDRoleCheckPopupRoleButtonDPS, LFGInvitePopupRoleButtonTank, LFGInvitePopupRoleButtonHealer, LFGInvitePopupRoleButtonDPS, LFGListApplicationDialog.DamagerButton, LFGListApplicationDialog.TankButton, LFGListApplicationDialog.HealerButton}) do
		local checkButton = roleButton.checkButton or roleButton.CheckButton

		roleButton.cover:SetTexture(C.media.roleIcons)
		roleButton:SetNormalTexture(C.media.roleIcons)
		F.CreateBDFrame(roleButton, .5, 9, -7, -9, 11)

		checkButton:SetFrameLevel(roleButton:GetFrameLevel() + 2)
		F.ReskinCheck(checkButton)
	end

	do
		local roleButtons = {LFGDungeonReadyStatusGroupedTank, LFGDungeonReadyStatusGroupedHealer, LFGDungeonReadyStatusGroupedDamager, LFGDungeonReadyStatusRolelessReady}

		for i = 1, 5 do
			tinsert(roleButtons, _G["LFGDungeonReadyStatusIndividualPlayer"..i])
		end

		for _, roleButton in pairs(roleButtons) do
			roleButton.texture:SetTexture(C.media.roleIcons)
			roleButton.statusIcon:SetDrawLayer("OVERLAY", 2)
			F.CreateBDFrame(roleButton, .5, 7, -6, -7, 8)
		end
	end

	LFGDungeonReadyStatusRolelessReady.texture:SetTexCoord(0.5234375, 0.78750, 0, 0.25875)

	hooksecurefunc("LFG_SetRoleIconIncentive", function(roleButton, incentiveIndex)
		if incentiveIndex then
			local tex
			if incentiveIndex == LFG_ROLE_SHORTAGE_PLENTIFUL then
				tex = "Interface\\Icons\\INV_Misc_Coin_19"
				roleButton:SetBackdropBorderColor(.93, .65, .37)
			elseif incentiveIndex == LFG_ROLE_SHORTAGE_UNCOMMON then
				tex = "Interface\\Icons\\INV_Misc_Coin_18"
				roleButton:SetBackdropBorderColor(.78, .78, .81)
			elseif incentiveIndex == LFG_ROLE_SHORTAGE_RARE then
				tex = "Interface\\Icons\\INV_Misc_Coin_17"
				roleButton:SetBackdropBorderColor(1, .84, 0)
			end
			roleButton.incentiveIcon.texture:SetTexture(tex)
		else
			roleButton:SetBackdropBorderColor(0, 0, 0)
		end
	end)

	hooksecurefunc("LFG_PermanentlyDisableRoleButton", function(button)
		if button.shortageBorder then
			button:SetBackdropBorderColor(1, .84, 0)
		end
	end)

	hooksecurefunc("LFG_DisableRoleButton", function(button)
		if button.shortageBorder then
			button:SetBackdropBorderColor(1, .84, 0)
		end
	end)

	hooksecurefunc("LFG_EnableRoleButton", function(button)
		if button.shortageBorder then
			button:SetBackdropBorderColor(1, .84, 0)
		end
	end)
end)