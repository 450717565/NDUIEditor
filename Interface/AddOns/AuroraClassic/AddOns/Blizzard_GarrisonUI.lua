local F, C = unpack(select(2, ...))

C.themes["Blizzard_GarrisonUI"] = function()
	local cr, cg, cb = C.r, C.g, C.b

	-- tooltips
	if AuroraConfig.tooltips then
		F.ReskinTooltip(GarrisonFollowerAbilityWithoutCountersTooltip)
		F.ReskinTooltip(GarrisonFollowerMissionAbilityWithoutCountersTooltip)
		F.ReskinTooltip(GarrisonMissionMechanicTooltip)
		F.ReskinTooltip(GarrisonMissionMechanicFollowerCounterTooltip)
		F.ReskinTooltip(GarrisonShipyardMapMissionTooltip)
		F.ReskinTooltip(GarrisonBonusAreaTooltip)
		F.ReskinTooltip(GarrisonBuildingFrame.BuildingLevelTooltip)
	end

	-- [[ Shared codes ]]

	GARRISON_FOLLOWER_ITEM_LEVEL = "iLvl %d"

	function F:ReskinMissionPage()
		F.StripTextures(self)
		self.StartMissionButton.Flash:SetTexture("")
		F.ReskinButton(self.StartMissionButton)
		F.ReskinClose(self.CloseButton)

		self.CloseButton:ClearAllPoints()
		self.CloseButton:SetPoint("TOPRIGHT", -10, -5)
		select(4, self.Stage:GetRegions()):Hide()
		select(5, self.Stage:GetRegions()):Hide()

		local bg = F.CreateBDFrame(self.Stage, 0)
		bg:SetPoint("TOPLEFT", 4, 1)
		bg:SetPoint("BOTTOMRIGHT", -4, -1)
		local overlay = self.Stage:CreateTexture()
		overlay:SetDrawLayer("ARTWORK", 3)
		overlay:SetAllPoints(bg)
		overlay:SetColorTexture(0, 0, 0, .5)
		local iconbg = select(16, self:GetRegions())
		iconbg:ClearAllPoints()
		iconbg:SetPoint("TOPLEFT", 3, -1)

		for i = 1, 3 do
			local follower = self.Followers[i]
			follower:GetRegions():Hide()
			F.CreateBDFrame(follower, 0)
			F.ReskinGarrisonPortrait(follower.PortraitFrame)
			follower.PortraitFrame:ClearAllPoints()
			follower.PortraitFrame:SetPoint("TOPLEFT", 0, -3)

			follower.Durability:ClearAllPoints()
			follower.Durability:SetPoint("BOTTOM", follower.PortraitFrame, "BOTTOM", 1, 12)
			follower.DurabilityBackground:SetAlpha(0)

			if follower.Class then
				F.ReskinClassIcon(follower, 40, "RIGHT", -17, -1)
			end
		end

		for i = 1, 10 do
			select(i, self.RewardsFrame:GetRegions()):Hide()
		end
		F.CreateBDFrame(self.RewardsFrame, 0)

		local env = self.Stage.MissionEnvIcon
		env.bg = F.ReskinIcon(env.Texture)

		local cost = self.CostFrame
		F.ReskinIcon(cost.CostIcon)
	end

	function F:ReskinMissionTabs()
		for i = 1, 2 do
			local tab = _G[self:GetName().."Tab"..i]
			F.StripTextures(tab)
			F.CreateBDFrame(tab, 0)
			if i == 1 then
				tab:SetBackdropColor(cr, cg, cb, .25)
			end
		end
	end

	function F:ReskinXPBar()
		local xpBar = self.XPBar
		F.ReskinStatusBar(xpBar, true)
	end

	function F:ReskinGarrMaterial()
		self.MaterialFrame:GetRegions():Hide()
		local bg = F.CreateBDFrame(self.MaterialFrame, 0)
		bg:SetPoint("TOPLEFT", 5, -5)
		bg:SetPoint("BOTTOMRIGHT", -5, 6)
		F.ReskinIcon(self.MaterialFrame.Icon)
	end

	function F:ReskinMissionList()
		local buttons = self.listScroll.buttons
		for i = 1, #buttons do
			local button = buttons[i]
			if not button.styled then
				F.StripTextures(button)

				local bg = F.CreateBDFrame(button, 0)
				bg:SetPoint("TOPLEFT", 2, -2)
				bg:SetPoint("BOTTOMRIGHT", -2, 2)

				local locBG = button.LocBG
				locBG:ClearAllPoints()
				locBG:SetPoint("TOPLEFT", bg, 1, 0)
				locBG:SetPoint("BOTTOMRIGHT", bg, -1, -2)

				local lists = {button.RareOverlay, button.Overlay.Overlay}
				for _, list in pairs(lists) do
					list:SetDrawLayer("BACKGROUND")
					list:SetTexture(C.media.bdTex)
					list:ClearAllPoints()
					list:SetPoint("TOPLEFT", locBG, 0, -1)
					list:SetPoint("BOTTOMRIGHT", locBG, 0, 3)
				end

				local rareOverlay = button.RareOverlay
				rareOverlay:SetVertexColor(.1, .5, .9, .25)

				local overlay = button.Overlay.Overlay
				overlay:SetVertexColor(.1, .1, .1, .5)

				local levelText = button.Level
				levelText:ClearAllPoints()
				levelText:SetPoint("TOPLEFT", button, 10, -4)

				local itemText = button.ItemLevel
				itemText:ClearAllPoints()
				itemText:SetPoint("TOP", levelText, "BOTTOM", 2, 3)

				local rareText = button.RareText
				rareText:ClearAllPoints()
				rareText:SetPoint("BOTTOMLEFT", button, 14, 8)

				button.styled = true
			end
		end
	end

	function F:ReskinMissionComplete()
		local missionComplete = self.MissionComplete
		local bonusRewards = missionComplete.BonusRewards
		select(11, bonusRewards:GetRegions()):SetTextColor(1, .8, 0)
		F.StripTextures(bonusRewards.Saturated)
		for i = 1, 9 do
			select(i, bonusRewards:GetRegions()):SetAlpha(0)
		end
		F.ReskinButton(missionComplete.NextMissionButton)
	end

	function F:ReskinFollowerTab()
		for i = 1, 2 do
			local trait = self.Traits[i]
			trait.Border:Hide()
			F.ReskinIcon(trait.Portrait)

			local equipment = self.EquipmentFrame.Equipment[i]
			equipment.BG:Hide()
			equipment.Border:Hide()
			F.ReskinIcon(equipment.Icon)
		end
	end

	function F:ReskinClassIcon(size, point, x, y)
		local class = self.Class
		class:SetSize(size, size)
		class:ClearAllPoints()
		class:SetPoint(point, x, y)
		class:SetTexCoord(.18, .92, .08, .92)
		F.CreateBDFrame(class, 0)
	end

	local function onUpdateData(self)
		local followerFrame = self:GetParent()
		local scrollFrame = followerFrame.FollowerList.listScroll
		local buttons = scrollFrame.buttons

		for i = 1, #buttons do
			local button = buttons[i].Follower
			local portrait = button.PortraitFrame

			if not button.restyled then
				button.BG:Hide()
				button.Selection:SetTexture("")
				button.AbilitiesBG:SetTexture("")
				button.BusyFrame:SetAllPoints()

				local bg = F.CreateBDFrame(button, 0)
				F.ReskinTexture(button, bg, true)

				if portrait then
					F.ReskinGarrisonPortrait(portrait)
					portrait:ClearAllPoints()
					portrait:SetPoint("TOPLEFT", 4, -1)
				end

				if button.Class then
					F.ReskinClassIcon(button, 40, "RIGHT", -9, 0)
				end

				button.bg = bg

				button.restyled = true
			end

			if button.Selection:IsShown() then
				button.bg:SetBackdropColor(cr, cg, cb, .25)
			else
				button.bg:SetBackdropColor(0, 0, 0, 0)
			end

			if portrait and portrait.quality then
				local color = BAG_ITEM_QUALITY_COLORS[portrait.quality or 1]
				portrait.squareBG:SetBackdropBorderColor(color.r, color.g, color.b)
			end
		end
	end

	local function onShowFollower(followerList)
		local self = followerList.followerTab
		local abilities = self.AbilitiesFrame.Abilities
		if not abilities then return end
		if not self.numAbilitiesStyled then self.numAbilitiesStyled = 1 end

		local numAbilitiesStyled = self.numAbilitiesStyled
		local ability = abilities[numAbilitiesStyled]
		while ability do
			local icon = ability.IconButton.Icon
			F.ReskinIcon(icon)

			numAbilitiesStyled = numAbilitiesStyled + 1
			ability = abilities[numAbilitiesStyled]
		end
		self.numAbilitiesStyled = numAbilitiesStyled

		if self.AbilitiesFrame.Equipment then
			for i = 1, 3 do
				local equip = self.AbilitiesFrame.Equipment[i]
				if equip and not equip.bg then
					equip.Border:SetAlpha(0)
					equip.BG:SetAlpha(0)
					equip.bg = F.ReskinIcon(equip.Icon)
					equip.bg:SetBackdropColor(1, 1, 1, .25)
				end
			end
		end

		local allySpell = self.AbilitiesFrame.CombatAllySpell
		for i = 1, #allySpell do
			if not allySpell.styled then
				local iconTexture = allySpell[i].iconTexture
				F.ReskinIcon(iconTexture)
				allySpell.styled = true
			end
		end
	end

	function F:ReskinMissionFrame()
		F.ReskinFrame(self)
		F.SetupTabStyle(self, 3)

		self.GarrCorners:Hide()
		if self.ClassHallIcon then self.ClassHallIcon:Hide() end
		if self.TitleScroll then
			F.StripTextures(self.TitleScroll)
			select(4, self.TitleScroll:GetRegions()):SetTextColor(1, .8, 0)
		end
		if self.MapTab then self.MapTab.ScrollContainer.Child.TiledBackground:Hide() end

		F.ReskinMissionComplete(self)
		F.ReskinMissionPage(self.MissionTab.MissionPage)
		F.StripTextures(self.FollowerTab)
		F.ReskinXPBar(self.FollowerTab)

		for _, item in pairs({self.FollowerTab.ItemWeapon, self.FollowerTab.ItemArmor}) do
			if item then
				local icon = item.Icon
				item.Border:Hide()
				F.ReskinIcon(icon)

				local bg = F.CreateBDFrame(item, 0)
				bg:SetPoint("TOPLEFT", 41, -1)
				bg:SetPoint("BOTTOMRIGHT", 0, 1)
			end
		end

		local missionList = self.MissionTab.MissionList
		F.StripTextures(missionList)
		F.ReskinScroll(missionList.listScroll.scrollBar)
		F.ReskinGarrMaterial(missionList)
		F.ReskinMissionTabs(missionList)
		F.ReskinButton(missionList.CompleteDialog.BorderFrame.ViewButton)
		hooksecurefunc(missionList, "Update", F.ReskinMissionList)

		local FollowerList = self.FollowerList
		F.StripTextures(FollowerList)
		F.ReskinInput(FollowerList.SearchBox)
		F.ReskinScroll(FollowerList.listScroll.scrollBar)
		F.ReskinGarrMaterial(FollowerList)
		hooksecurefunc(FollowerList, "UpdateData", onUpdateData)
		hooksecurefunc(FollowerList, "ShowFollower", onShowFollower)
	end

	-- [[ Garrison system ]]

	-- Building frame
	local GarrisonBuildingFrame = GarrisonBuildingFrame
	F.ReskinFrame(GarrisonBuildingFrame)
	GarrisonBuildingFrame.GarrCorners:Hide()

	-- Tutorial button

	local MainHelpButton = GarrisonBuildingFrame.MainHelpButton
	MainHelpButton.Ring:Hide()
	MainHelpButton:SetPoint("TOPLEFT", GarrisonBuildingFrame, "TOPLEFT", -12, 12)

	-- Building list

	local BuildingList = GarrisonBuildingFrame.BuildingList

	BuildingList:DisableDrawLayer("BORDER")
	F.ReskinGarrMaterial(BuildingList)

	for i = 1, GARRISON_NUM_BUILDING_SIZES do
		local tab = BuildingList["Tab"..i]

		tab:GetNormalTexture():SetAlpha(0)

		local bg = F.CreateBDFrame(tab, 0)
		bg:SetPoint("TOPLEFT", 6, -7)
		bg:SetPoint("BOTTOMRIGHT", -6, 7)
		F.ReskinTexture(tab, bg, true)

		tab.bg = bg
	end

	hooksecurefunc("GarrisonBuildingList_SelectTab", function(tab)
		local list = GarrisonBuildingFrame.BuildingList

		for i = 1, GARRISON_NUM_BUILDING_SIZES do
			local otherTab = list["Tab"..i]
			if i ~= tab:GetID() then
				otherTab.bg:SetBackdropColor(0, 0, 0, 0)
			end
		end
		tab.bg:SetBackdropColor(cr, cg, cb, .25)

		for _, button in pairs(list.Buttons) do
			if not button.styled then
				button.BG:Hide()

				F.ReskinIcon(button.Icon)

				local bg = F.CreateBDFrame(button, 0)
				bg:SetPoint("TOPLEFT", 44, -5)
				bg:SetPoint("BOTTOMRIGHT", 0, 6)

				F.ReskinTexture(button, bg, true)
				F.ReskinTexture(button.SelectedBG, bg, true)

				button.styled = true
			end
		end
	end)

	-- Follower list

	local FollowerList = GarrisonBuildingFrame.FollowerList

	FollowerList:DisableDrawLayer("BACKGROUND")
	FollowerList:DisableDrawLayer("BORDER")
	F.ReskinScroll(FollowerList.listScroll.scrollBar)

	FollowerList:ClearAllPoints()
	FollowerList:SetPoint("BOTTOMLEFT", 24, 34)

	hooksecurefunc(FollowerList, "UpdateData", onUpdateData)
	hooksecurefunc(FollowerList, "ShowFollower", onShowFollower)

	-- Info box

	local InfoBox = GarrisonBuildingFrame.InfoBox
	local TownHallBox = GarrisonBuildingFrame.TownHallBox

	for i = 1, 25 do
		select(i, InfoBox:GetRegions()):Hide()
		select(i, TownHallBox:GetRegions()):Hide()
	end

	F.CreateBDFrame(InfoBox, 0)
	F.CreateBDFrame(TownHallBox, 0)
	F.ReskinButton(InfoBox.UpgradeButton)
	F.ReskinButton(TownHallBox.UpgradeButton)
	GarrisonBuildingFrame.MapFrame.TownHall.TownHallName:SetTextColor(1, .8, 0)

	do
		local FollowerPortrait = InfoBox.FollowerPortrait

		F.ReskinGarrisonPortrait(FollowerPortrait)

		FollowerPortrait:SetPoint("BOTTOMLEFT", 230, 10)
		FollowerPortrait.RemoveFollowerButton:ClearAllPoints()
		FollowerPortrait.RemoveFollowerButton:SetPoint("TOPRIGHT", 4, 4)
	end

	hooksecurefunc("GarrisonBuildingInfoBox_ShowFollowerPortrait", function(_, _, infoBox)
		local portrait = infoBox.FollowerPortrait

		if portrait:IsShown() then
			portrait.squareBG:SetBackdropBorderColor(portrait.PortraitRing:GetVertexColor())
		end
	end)

	-- Confirmation popup

	local Confirmation = GarrisonBuildingFrame.Confirmation
	F.ReskinFrame(Confirmation)
	F.ReskinButton(Confirmation.CancelButton)
	F.ReskinButton(Confirmation.BuildButton)
	F.ReskinButton(Confirmation.UpgradeButton)
	F.ReskinButton(Confirmation.UpgradeGarrisonButton)
	F.ReskinButton(Confirmation.ReplaceButton)
	F.ReskinButton(Confirmation.SwitchButton)

	-- [[ Capacitive display frame ]]

	local GarrisonCapacitiveDisplayFrame = GarrisonCapacitiveDisplayFrame
	GarrisonCapacitiveDisplayFrameLeft:Hide()
	GarrisonCapacitiveDisplayFrameMiddle:Hide()
	GarrisonCapacitiveDisplayFrameRight:Hide()
	GarrisonCapacitiveDisplayFrame.Count:SetWidth(38)
	GarrisonCapacitiveDisplayFrame.Count:SetTextInsets(3, 0, 0, 0)

	F.ReskinFrame(GarrisonCapacitiveDisplayFrame)
	F.ReskinButton(GarrisonCapacitiveDisplayFrame.StartWorkOrderButton)
	F.ReskinButton(GarrisonCapacitiveDisplayFrame.CreateAllWorkOrdersButton)
	F.ReskinArrow(GarrisonCapacitiveDisplayFrame.DecrementButton, "left")
	F.ReskinArrow(GarrisonCapacitiveDisplayFrame.IncrementButton, "right")
	F.CreateBDFrame(GarrisonCapacitiveDisplayFrame.Count, 0)

	-- Capacitive display

	local CapacitiveDisplay = GarrisonCapacitiveDisplayFrame.CapacitiveDisplay
	CapacitiveDisplay.IconBG:Hide()
	F.ReskinGarrisonPortrait(CapacitiveDisplay.ShipmentIconFrame.Follower)

	local reagentIndex = 1
	hooksecurefunc("GarrisonCapacitiveDisplayFrame_Update", function()
		local reagents = CapacitiveDisplay.Reagents

		local reagent = reagents[reagentIndex]
		while reagent do
			reagent.NameFrame:SetAlpha(0)

			local ic = F.ReskinIcon(reagent.Icon)

			local bg = F.CreateBDFrame(reagent, 0)
			bg:SetPoint("TOPLEFT", ic, "TOPRIGHT", 2, 0)
			bg:SetPoint("BOTTOMRIGHT", -5, 0)

			reagentIndex = reagentIndex + 1
			reagent = reagents[reagentIndex]
		end
	end)

	-- [[ Landing page ]]

	local GarrisonLandingPage = GarrisonLandingPage
	F.ReskinFrame(GarrisonLandingPage)

	for i = 1, 3 do
		F.ReskinTab(_G["GarrisonLandingPageTab"..i])
	end

	GarrisonLandingPageTab1:ClearAllPoints()
	GarrisonLandingPageTab1:SetPoint("TOPLEFT", GarrisonLandingPage, "BOTTOMLEFT", 70, 2)

	-- Report

	local Report = GarrisonLandingPage.Report

	select(2, Report:GetRegions()):Hide()
	Report.List:GetRegions():Hide()

	local scrollFrame = Report.List.listScroll
	F.ReskinScroll(scrollFrame.scrollBar)

	local buttons = scrollFrame.buttons
	for i = 1, #buttons do
		local button = buttons[i]
		button.BG:Hide()
		local bg = F.CreateBDFrame(button, 0)
		bg:SetPoint("TOPLEFT", C.mult, -C.mult)
		bg:SetPoint("BOTTOMRIGHT", -C.mult, C.mult)

		for _, reward in pairs(button.Rewards) do
			reward:GetRegions():Hide()
			reward.IconBorder:SetAlpha(0)
			reward:ClearAllPoints()
			reward:SetPoint("TOPRIGHT", -4, -4)
			F.ReskinIcon(reward.Icon)
		end
	end

	for _, tab in pairs({Report.InProgress, Report.Available}) do
		F.CleanTextures(tab)
		tab.Text:ClearAllPoints()
		tab.Text:SetPoint("CENTER")
		local bg = F.CreateBDFrame(tab, 0)

		local selectedTex = bg:CreateTexture(nil, "BACKGROUND")
		selectedTex:SetAllPoints()
		selectedTex:SetColorTexture(cr, cg, cb, .25)
		selectedTex:Hide()
		tab.selectedTex = selectedTex

		if tab == Report.InProgress then
			bg:SetPoint("TOPLEFT", 5, 0)
			bg:SetPoint("BOTTOMRIGHT")
		else
			bg:SetPoint("TOPLEFT")
			bg:SetPoint("BOTTOMRIGHT", -7, 0)
		end
	end

	hooksecurefunc("GarrisonLandingPageReport_SetTab", function(self)
		local unselectedTab = Report.unselectedTab
		F.CleanTextures(unselectedTab)
		unselectedTab:SetHeight(36)
		unselectedTab.selectedTex:Hide()

		F.CleanTextures(self)
		self.selectedTex:Show()
	end)

	-- Follower list

	local FollowerList = GarrisonLandingPage.FollowerList
	FollowerList:GetRegions():Hide()
	select(2, FollowerList:GetRegions()):Hide()
	F.ReskinInput(FollowerList.SearchBox)

	local scrollFrame = FollowerList.listScroll
	F.ReskinScroll(scrollFrame.scrollBar)

	hooksecurefunc(GarrisonLandingPageFollowerList, "UpdateData", onUpdateData)
	hooksecurefunc(GarrisonLandingPageFollowerList, "ShowFollower", onShowFollower)

	-- Ship follower list

	local FollowerList = GarrisonLandingPage.ShipFollowerList
	FollowerList:GetRegions():Hide()
	select(2, FollowerList:GetRegions()):Hide()
	F.ReskinInput(FollowerList.SearchBox)

	local scrollFrame = FollowerList.listScroll
	F.ReskinScroll(scrollFrame.scrollBar)

	-- Follower tab

	local FollowerTab = GarrisonLandingPage.FollowerTab
	F.ReskinXPBar(FollowerTab)
	F.ReskinClassIcon(FollowerTab, 50, "TOPRIGHT", 0, -3)

	-- Ship follower tab

	local FollowerTab = GarrisonLandingPage.ShipFollowerTab
	F.ReskinXPBar(FollowerTab)
	F.ReskinFollowerTab(FollowerTab)

	-- [[ Mission UI ]]

	local GarrisonMissionFrame = GarrisonMissionFrame
	F.ReskinMissionFrame(GarrisonMissionFrame)

	hooksecurefunc("GarrisonMissonListTab_SetSelected", function(tab, isSelected)
		if isSelected then
			tab:SetBackdropColor(cr, cg, cb, .25)
		else
			tab:SetBackdropColor(0, 0, 0, 0)
		end
	end)

	hooksecurefunc("GarrisonFollowerButton_AddAbility", function(self, index)
		local ability = self.Abilities[index]

		if not ability.styled then
			local icon = ability.Icon
			icon:SetSize(19, 19)
			F.ReskinIcon(icon)

			ability.styled = true
		end
	end)

	hooksecurefunc("GarrisonFollowerButton_SetCounterButton", function(button, _, index)
		local counter = button.Counters[index]
		if counter and not counter.styled then
			F.ReskinIcon(counter.Icon)

			counter.styled = true
		end
	end)

	hooksecurefunc("GarrisonMissionButton_SetRewards", function(self, rewards)
		if not self.numRewardsStyled then self.numRewardsStyled = 0 end

		while self.numRewardsStyled < #rewards do
			self.numRewardsStyled = self.numRewardsStyled + 1
			local reward = self.Rewards[self.numRewardsStyled]
			reward:GetRegions():Hide()
			reward.IconBorder:SetAlpha(0)
			F.ReskinIcon(reward.Icon)
		end
	end)

	hooksecurefunc("GarrisonMissionPortrait_SetFollowerPortrait", function(portraitFrame, followerInfo)
		if not portraitFrame.styled then
			F.ReskinGarrisonPortrait(portraitFrame)
			portraitFrame.styled = true
		end

		local color = BAG_ITEM_QUALITY_COLORS[followerInfo.quality or 1]
		portraitFrame.squareBG:SetBackdropBorderColor(color.r, color.g, color.b)
		portraitFrame.squareBG:Show()
	end)

	hooksecurefunc("GarrisonMissionPage_SetReward", function(frame)
		if not frame.styled then
			frame.BG:Hide()
			frame.IconBorder:SetAlpha(0)
			F.ReskinIcon(frame.Icon)

			frame.styled = true
		end
	end)

	hooksecurefunc(GarrisonMission, "UpdateMissionParty", function(_, followers)
		for followerIndex = 1, #followers do
			local followerFrame = followers[followerIndex]
			if followerFrame.info then
				for i = 1, #followerFrame.Counters do
					local counter = followerFrame.Counters[i]
					if not counter.styled then
						F.ReskinIcon(counter.Icon)

						counter.styled = true
					end
				end
			end
		end
	end)

	hooksecurefunc(GarrisonMission, "RemoveFollowerFromMission", function(_, frame)
		if frame.PortraitFrame and frame.PortraitFrame.squareBG then
			frame.PortraitFrame.squareBG:Hide()
		end
	end)

	hooksecurefunc(GarrisonMission, "SetEnemies", function(_, missionPage, enemies)
		for i = 1, #enemies do
			local frame = missionPage.Enemies[i]
			if frame:IsShown() and not frame.styled then
				for j = 1, #frame.Mechanics do
					local mechanic = frame.Mechanics[j]
					F.ReskinIcon(mechanic.Icon)
				end
				frame.styled = true
			end
		end
	end)

	hooksecurefunc(GarrisonMission, "UpdateMissionData", function(_, missionPage)
		local buffsFrame = missionPage.BuffsFrame
		if buffsFrame:IsShown() then
			buffsFrame.BuffsBG:Hide()
			for i = 1, #buffsFrame.Buffs do
				local buff = buffsFrame.Buffs[i]
				if not buff.styled then
					F.ReskinIcon(buff.Icon)

					buff.styled = true
				end
			end
		end
	end)

	hooksecurefunc(GarrisonMission, "MissionCompleteInitialize", function(self, missionList, index)
		local mission = missionList[index]
		if not mission then return end

		for i = 1, #mission.followers do
			local frame = self.MissionComplete.Stage.FollowersFrame.Followers[i]
			if frame.PortraitFrame then
				if not frame.bg then
					frame.PortraitFrame:ClearAllPoints()
					frame.PortraitFrame:SetPoint("TOPLEFT", 0, -10)
					F.ReskinGarrisonPortrait(frame.PortraitFrame)

					local oldBg = frame:GetRegions()
					oldBg:Hide()
					frame.bg = F.CreateBDFrame(oldBg, 0)
					frame.bg:SetPoint("TOPLEFT", frame.PortraitFrame, -C.mult, C.mult)
					frame.bg:SetPoint("BOTTOMRIGHT", -10, 8)
				end

				local quality = select(4, C_Garrison.GetFollowerMissionCompleteInfo(mission.followers[i]))
				if quality then
					local color = BAG_ITEM_QUALITY_COLORS[quality or 1]
					frame.PortraitFrame.squareBG:SetBackdropBorderColor(color.r, color.g, color.b)
					frame.PortraitFrame.squareBG:Show()
				end

				if frame.XP then
					F.ReskinStatusBar(frame.XP, true)
				end

				if frame.Class then
					F.ReskinClassIcon(frame, 40, "RIGHT", -17, -1)
				end

				frame.DurabilityFrame:ClearAllPoints()
				frame.DurabilityFrame:SetPoint("BOTTOM", frame.PortraitFrame, "BOTTOM", 1, 12)
				frame.DurabilityBackground:Hide()
			end
		end
	end)

	hooksecurefunc(GarrisonMission, "ShowMission", function(self)
		local envIcon = self:GetMissionPage().Stage.MissionEnvIcon
		if envIcon.bg then
			envIcon.bg:SetShown(envIcon.Texture:GetTexture())
		end
	end)

	-- [[ Recruiter frame ]]

	local GarrisonRecruiterFrame = GarrisonRecruiterFrame
	F.ReskinFrame(GarrisonRecruiterFrame)

	-- Pick

	local Pick = GarrisonRecruiterFrame.Pick

	F.ReskinButton(Pick.ChooseRecruits)
	F.ReskinDropDown(Pick.ThreatDropDown)
	F.ReskinRadio(Pick.Radio1)
	F.ReskinRadio(Pick.Radio2)

	-- Unavailable frame

	local UnavailableFrame = GarrisonRecruiterFrame.UnavailableFrame

	F.ReskinButton(UnavailableFrame:GetChildren())

	-- [[ Recruiter select frame ]]

	local GarrisonRecruitSelectFrame = GarrisonRecruitSelectFrame
	F.ReskinFrame(GarrisonRecruitSelectFrame)

	GarrisonRecruitSelectFrame.TitleText:Show()
	GarrisonRecruitSelectFrame.GarrCorners:Hide()

	-- Follower list

	local FollowerList = GarrisonRecruitSelectFrame.FollowerList

	FollowerList:DisableDrawLayer("BORDER")
	F.ReskinScroll(FollowerList.listScroll.scrollBar)
	F.ReskinInput(FollowerList.SearchBox)

	hooksecurefunc(FollowerList, "UpdateData", onUpdateData)
	hooksecurefunc(FollowerList, "ShowFollower", onShowFollower)

	-- Follower selection

	local FollowerSelection = GarrisonRecruitSelectFrame.FollowerSelection

	FollowerSelection:DisableDrawLayer("BORDER")
	for i = 1, 3 do
		local recruit = FollowerSelection["Recruit"..i]
		F.ReskinGarrisonPortrait(recruit.PortraitFrame)
		F.ReskinButton(recruit.HireRecruits)
	end

	hooksecurefunc("GarrisonRecruitSelectFrame_UpdateRecruits", function(waiting)
		if waiting then return end

		for i = 1, 3 do
			local recruit = FollowerSelection["Recruit"..i]
			local portrait = recruit.PortraitFrame
			portrait.squareBG:SetBackdropBorderColor(portrait.LevelBorder:GetVertexColor())
		end
	end)

	-- [[ Monuments ]]

	local GarrisonMonumentFrame = GarrisonMonumentFrame

	GarrisonMonumentFrame.Background:Hide()
	F.SetBDFrame(GarrisonMonumentFrame, 6, -10, -6, 4)

	do
		local left = GarrisonMonumentFrame.LeftBtn
		local right = GarrisonMonumentFrame.RightBtn

		left.Texture:Hide()
		right.Texture:Hide()
		F.ReskinArrow(left, "left")
		F.ReskinArrow(right, "right")
		left:SetSize(35, 35)
		left.bgTex:SetSize(16, 16)
		right:SetSize(35, 35)
		right.bgTex:SetSize(16, 16)
	end

	-- [[ Shipyard ]]

	local GarrisonShipyardFrame = GarrisonShipyardFrame
	F.StripTextures(GarrisonShipyardFrame.BorderFrame)
	F.ReskinFrame(GarrisonShipyardFrame)

	GarrisonShipyardFrame.BorderFrame.TitleText:Show()
	GarrisonShipyardFrame.BorderFrame.GarrCorners:Hide()
	GarrisonShipyardFrame.BackgroundTile:Hide()

	F.ReskinInput(GarrisonShipyardFrameFollowers.SearchBox)
	F.ReskinScroll(GarrisonShipyardFrameFollowersListScrollFrameScrollBar)
	GarrisonShipyardFrameFollowers:GetRegions():Hide()
	select(2, GarrisonShipyardFrameFollowers:GetRegions()):Hide()
	GarrisonShipyardFrameFollowers:DisableDrawLayer("BORDER")
	F.ReskinGarrMaterial(GarrisonShipyardFrameFollowers)

	local shipyardTab = GarrisonShipyardFrame.FollowerTab
	shipyardTab:DisableDrawLayer("BORDER")
	F.ReskinXPBar(shipyardTab)
	F.ReskinFollowerTab(shipyardTab)

	F.ReskinClose(GarrisonShipyardFrame.BorderFrame.CloseButton2)
	F.SetupTabStyle(GarrisonShipyardFrame, 2)

	local shipyardMission = GarrisonShipyardFrame.MissionTab.MissionPage
	F.StripTextures(shipyardMission)
	F.ReskinClose(shipyardMission.CloseButton)
	F.ReskinButton(shipyardMission.StartMissionButton)
	local smbg = F.CreateBDFrame(shipyardMission.Stage, 0)
	smbg:SetPoint("TOPLEFT", 4, 1)
	smbg:SetPoint("BOTTOMRIGHT", -4, -1)

	for i = 1, 10 do
		select(i, shipyardMission.RewardsFrame:GetRegions()):Hide()
	end
	F.CreateBDFrame(shipyardMission.RewardsFrame, 0)

	GarrisonShipyardFrame.MissionCompleteBackground:GetRegions():Hide()
	GarrisonShipyardFrame.MissionTab.MissionList.CompleteDialog:GetRegions():Hide()
	F.ReskinButton(GarrisonShipyardFrame.MissionTab.MissionList.CompleteDialog.BorderFrame.ViewButton)
	select(11, GarrisonShipyardFrame.MissionComplete.BonusRewards:GetRegions()):SetTextColor(1, .8, 0)
	F.ReskinButton(GarrisonShipyardFrame.MissionComplete.NextMissionButton)

	-- [[ Orderhall UI]]

	local OrderHallMissionFrame = OrderHallMissionFrame
	F.ReskinMissionFrame(OrderHallMissionFrame)
	F.ReskinClassIcon(OrderHallMissionFrame.FollowerTab, 50, "TOPRIGHT", 0, -3)

	-- Ally
	local combatAlly = OrderHallMissionFrameMissions.CombatAllyUI
	F.ReskinButton(combatAlly.InProgress.Unassign)
	combatAlly:GetRegions():Hide()
	F.CreateBDFrame(combatAlly, 0)

	local ipas = combatAlly.InProgress.CombatAllySpell.iconTexture
	F.ReskinIcon(ipas)

	local allyPortrait = combatAlly.InProgress.PortraitFrame
	F.ReskinGarrisonPortrait(allyPortrait)
	OrderHallMissionFrame:HookScript("OnShow", function()
		if allyPortrait:IsShown() then
			allyPortrait.squareBG:SetBackdropBorderColor(allyPortrait.PortraitRingQuality:GetVertexColor())
		end
		combatAlly.Available.AddFollowerButton.EmptyPortrait:SetAlpha(0)
		combatAlly.Available.AddFollowerButton.PortraitHighlight:SetAlpha(0)
	end)

	hooksecurefunc(OrderHallCombatAllyMixin, "UnassignAlly", function(self)
		if self.InProgress.PortraitFrame.squareBG then
			self.InProgress.PortraitFrame.squareBG:Hide()
		end
	end)

	-- Zone support
	local ZoneSupportMissionPage = OrderHallMissionFrame.MissionTab.ZoneSupportMissionPage
	F.ReskinFrame(ZoneSupportMissionPage)
	F.ReskinButton(ZoneSupportMissionPage.StartMissionButton)
	ZoneSupportMissionPage.Follower1:GetRegions():Hide()
	F.CreateBDFrame(ZoneSupportMissionPage.Follower1, 0)
	F.ReskinGarrisonPortrait(ZoneSupportMissionPage.Follower1.PortraitFrame)

	local zsas = ZoneSupportMissionPage.CombatAllySpell.iconTexture
	F.ReskinIcon(zsas)

	local cost = ZoneSupportMissionPage.CostFrame
	F.ReskinIcon(cost.CostIcon)

	-- [[ BFA Mission UI]]

	local BFAMissionFrame = BFAMissionFrame
	BFAMissionFrame.OverlayElements.Topper:Hide()
	F.ReskinMissionFrame(BFAMissionFrame)
	F.ReskinClassIcon(BFAMissionFrame.FollowerTab, 50, "TOPRIGHT", 0, -3)

	-- [[ Addon supports ]]

	local function buttonOnUpdate(MissionList)
		local buttons = MissionList.listScroll.buttons
		for i = 1, #buttons do
			local bu = select(3, buttons[i]:GetChildren())
			if bu and bu:GetObjectType() == "Button" and not bu.styled then
				F.ReskinButton(bu)
				bu:SetSize(60, 45)
				bu.styled = true
			end
		end
	end

	local function buttonOnShow(MissionPage)
		for i = 18, 26 do
			local bu = select(i, MissionPage:GetChildren())
			if bu and bu:GetObjectType() == "Button" and not bu.styled then
				F.ReskinButton(bu)
				bu:SetSize(50, 45)
				bu.styled = true
			end
		end
	end

	local f = CreateFrame("Frame")
	f:RegisterEvent("ADDON_LOADED")
	f:SetScript("OnEvent", function(_, event, addon)
		if addon == "GarrisonMissionManager" then
			for _, frame in pairs({GarrisonMissionFrame, OrderHallMissionFrame, BFAMissionFrame}) do
				hooksecurefunc(frame.MissionTab.MissionList, "Update", buttonOnUpdate)
				frame.MissionTab.MissionPage:HookScript("OnShow", buttonOnShow)
			end

			f:UnregisterEvent(event)
		end
	end)
end