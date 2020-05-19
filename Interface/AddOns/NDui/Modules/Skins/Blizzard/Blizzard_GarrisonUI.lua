local B, C, L, DB = unpack(select(2, ...))

C.themes["Blizzard_GarrisonUI"] = function()
	local cr, cg, cb = DB.r, DB.g, DB.b

	-- [[ Shared codes ]]

	GARRISON_FOLLOWER_ITEM_LEVEL = "iLvl %d"

	function B:ReskinMissionPage()
		B.StripTextures(self)
		self.StartMissionButton.Flash:SetTexture("")
		B.ReskinButton(self.StartMissionButton)
		B.ReskinClose(self.CloseButton)

		self.CloseButton:ClearAllPoints()
		self.CloseButton:SetPoint("TOPRIGHT", -10, -5)
		select(4, self.Stage:GetRegions()):Hide()
		select(5, self.Stage:GetRegions()):Hide()

		local bg = B.CreateBGFrame(self.Stage, 4, 1, -4, -1)

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
			B.CreateBDFrame(follower, 0)
			B.ReskinGarrisonPortrait(follower.PortraitFrame)
			follower.PortraitFrame:ClearAllPoints()
			follower.PortraitFrame:SetPoint("TOPLEFT", 0, -3)

			follower.Durability:ClearAllPoints()
			follower.Durability:SetPoint("BOTTOM", follower.PortraitFrame, "BOTTOM", 1, 12)
			follower.DurabilityBackground:SetAlpha(0)

			if follower.Class then
				B.ReskinClassIcon(follower, 40, "RIGHT", -17, -1)
			end
		end

		for i = 1, 10 do
			select(i, self.RewardsFrame:GetRegions()):Hide()
		end
		B.CreateBDFrame(self.RewardsFrame, 0)

		local env = self.Stage.MissionEnvIcon
		env.bg = B.ReskinIcon(env.Texture)

		local cost = self.CostFrame
		B.ReskinIcon(cost.CostIcon)
	end

	function B:ReskinMissionTabs()
		for i = 1, 2 do
			local tab = _G[self:GetName().."Tab"..i]
			B.StripTextures(tab)
			B.CreateBDFrame(tab, 0)
			if i == 1 then
				tab:SetBackdropColor(cr, cg, cb, .25)
			end
		end
	end

	function B:ReskinXPBar()
		local xpBar = self.XPBar
		B.ReskinStatusBar(xpBar, true)
	end

	function B:ReskinGarrMaterial()
		self.MaterialFrame:GetRegions():Hide()

		B.CreateBDFrame(self.MaterialFrame, 0, -5)
		B.ReskinIcon(self.MaterialFrame.Icon)
	end

	function B:ReskinMissionList()
		local buttons = self.listScroll.buttons
		for i = 1, #buttons do
			local button = buttons[i]
			if not button.styled then
				B.StripTextures(button)

				local bg = B.CreateBDFrame(button, 0, -2)

				local locBG = button.LocBG
				locBG:ClearAllPoints()
				locBG:SetPoint("TOPLEFT", bg, 1, 0)
				locBG:SetPoint("BOTTOMRIGHT", bg, -1, -2)

				local lists = {button.RareOverlay, button.Overlay.Overlay}
				for _, list in pairs(lists) do
					list:SetDrawLayer("BACKGROUND")
					list:SetTexture(DB.bdTex)
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

	function B:ReskinMissionComplete()
		local missionComplete = self.MissionComplete
		local bonusRewards = missionComplete.BonusRewards
		select(11, bonusRewards:GetRegions()):SetTextColor(1, .8, 0)
		B.StripTextures(bonusRewards.Saturated)
		for i = 1, 9 do
			select(i, bonusRewards:GetRegions()):SetAlpha(0)
		end
		B.ReskinButton(missionComplete.NextMissionButton)
	end

	function B:ReskinFollowerTab()
		for i = 1, 2 do
			local trait = self.Traits[i]
			trait.Border:Hide()
			B.ReskinIcon(trait.Portrait)

			local equipment = self.EquipmentFrame.Equipment[i]
			equipment.BG:Hide()
			equipment.Border:Hide()
			B.ReskinIcon(equipment.Icon)
		end
	end

	function B:ReskinClassIcon(size, point, x, y)
		local class = self.Class
		class:SetSize(size, size)
		class:ClearAllPoints()
		class:SetPoint(point, x, y)
		class:SetTexCoord(.18, .92, .08, .92)
		B.CreateBDFrame(class, 0)
	end

	local function onUpdateData(self)
		local followerFrame = self:GetParent()
		local scrollFrame = followerFrame.FollowerList.listScroll
		local buttons = scrollFrame.buttons

		for i = 1, #buttons do
			local button = buttons[i].Follower
			local portrait = button.PortraitFrame

			if not button.styled then
				button.BG:Hide()
				button.Selection:SetTexture("")
				button.AbilitiesBG:SetTexture("")
				button.BusyFrame:SetAllPoints()

				local bg = B.CreateBDFrame(button, 0)
				B.ReskinHighlight(button, bg, true)

				if portrait then
					B.ReskinGarrisonPortrait(portrait)
					portrait:ClearAllPoints()
					portrait:SetPoint("TOPLEFT", 4, -1)
				end

				if button.Class then
					B.ReskinClassIcon(button, 40, "RIGHT", -9, 0)
				end

				button.bg = bg

				button.styled = true
			end

			if button.Selection:IsShown() then
				button.bg:SetBackdropColor(cr, cg, cb, .25)
			else
				button.bg:SetBackdropColor(0, 0, 0, 0)
			end

			if portrait and portrait.quality then
				local r, g, b = GetItemQualityColor(portrait.quality or 1)
				portrait.squareBG:SetBackdropBorderColor(r, g, b)
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
			B.ReskinIcon(icon)

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
					equip.bg = B.ReskinIcon(equip.Icon)
					equip.bg:SetBackdropColor(1, 1, 1, .25)
				end
			end
		end

		local allySpell = self.AbilitiesFrame.CombatAllySpell
		for i = 1, #allySpell do
			if not allySpell.styled then
				local iconTexture = allySpell[i].iconTexture
				B.ReskinIcon(iconTexture)

				allySpell.styled = true
			end
		end
	end

	function B:ReskinMissionFrame()
		B.ReskinFrame(self)
		B.SetupTabStyle(self, 3)

		self.GarrCorners:Hide()
		if self.ClassHallIcon then self.ClassHallIcon:Hide() end
		if self.TitleScroll then
			B.StripTextures(self.TitleScroll)
			select(4, self.TitleScroll:GetRegions()):SetTextColor(1, .8, 0)
		end
		if self.MapTab then self.MapTab.ScrollContainer.Child.TiledBackground:Hide() end

		B.ReskinMissionComplete(self)
		B.ReskinMissionPage(self.MissionTab.MissionPage)
		B.StripTextures(self.FollowerTab)
		B.ReskinXPBar(self.FollowerTab)

		for _, item in pairs({self.FollowerTab.ItemWeapon, self.FollowerTab.ItemArmor}) do
			if item then
				local icon = item.Icon
				item.Border:Hide()
				B.ReskinIcon(icon)
				B.CreateBGFrame(item, 41, -1, 0, 1)
			end
		end

		local missionList = self.MissionTab.MissionList
		B.StripTextures(missionList)
		B.ReskinScroll(missionList.listScroll.scrollBar)
		B.ReskinGarrMaterial(missionList)
		B.ReskinMissionTabs(missionList)
		B.ReskinButton(missionList.CompleteDialog.BorderFrame.ViewButton)
		hooksecurefunc(missionList, "Update", B.ReskinMissionList)

		local FollowerList = self.FollowerList
		B.StripTextures(FollowerList)
		B.ReskinInput(FollowerList.SearchBox)
		B.ReskinScroll(FollowerList.listScroll.scrollBar)
		B.ReskinGarrMaterial(FollowerList)
		hooksecurefunc(FollowerList, "UpdateData", onUpdateData)
		hooksecurefunc(FollowerList, "ShowFollower", onShowFollower)
	end

	-- [[ Garrison system ]]

	-- Building frame
	local GarrisonBuildingFrame = GarrisonBuildingFrame
	B.ReskinFrame(GarrisonBuildingFrame)
	GarrisonBuildingFrame.GarrCorners:Hide()

	-- Tutorial button

	local MainHelpButton = GarrisonBuildingFrame.MainHelpButton
	MainHelpButton.Ring:Hide()
	MainHelpButton:SetPoint("TOPLEFT", GarrisonBuildingFrame, "TOPLEFT", -12, 12)

	-- Building list

	local BuildingList = GarrisonBuildingFrame.BuildingList

	BuildingList:DisableDrawLayer("BORDER")
	B.ReskinGarrMaterial(BuildingList)

	for i = 1, GARRISON_NUM_BUILDING_SIZES do
		local tab = BuildingList["Tab"..i]
		tab:GetNormalTexture():SetAlpha(0)

		local bg = B.CreateBGFrame(tab, 6, -7, -6, 7)
		B.ReskinHighlight(tab, bg, true)

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

				B.ReskinIcon(button.Icon)

				local bg = B.CreateBGFrame(button, 44, -5, 0, 6)
				B.ReskinHighlight(button, bg, true)
				B.ReskinHighlight(button.SelectedBG, bg, true)

				button.styled = true
			end
		end
	end)

	-- Follower list

	local FollowerList = GarrisonBuildingFrame.FollowerList

	FollowerList:DisableDrawLayer("BACKGROUND")
	FollowerList:DisableDrawLayer("BORDER")
	B.ReskinScroll(FollowerList.listScroll.scrollBar)

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

	B.CreateBDFrame(InfoBox, 0)
	B.CreateBDFrame(TownHallBox, 0)
	B.ReskinButton(InfoBox.UpgradeButton)
	B.ReskinButton(TownHallBox.UpgradeButton)
	GarrisonBuildingFrame.MapFrame.TownHall.TownHallName:SetTextColor(1, .8, 0)

	do
		local FollowerPortrait = InfoBox.FollowerPortrait

		B.ReskinGarrisonPortrait(FollowerPortrait)

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
	B.ReskinFrame(Confirmation)
	B.ReskinButton(Confirmation.CancelButton)
	B.ReskinButton(Confirmation.BuildButton)
	B.ReskinButton(Confirmation.UpgradeButton)
	B.ReskinButton(Confirmation.UpgradeGarrisonButton)
	B.ReskinButton(Confirmation.ReplaceButton)
	B.ReskinButton(Confirmation.SwitchButton)

	-- [[ Capacitive display frame ]]

	local GarrisonCapacitiveDisplayFrame = GarrisonCapacitiveDisplayFrame
	GarrisonCapacitiveDisplayFrameLeft:Hide()
	GarrisonCapacitiveDisplayFrameMiddle:Hide()
	GarrisonCapacitiveDisplayFrameRight:Hide()
	GarrisonCapacitiveDisplayFrame.Count:SetWidth(38)
	GarrisonCapacitiveDisplayFrame.Count:SetTextInsets(3, 0, 0, 0)

	B.ReskinFrame(GarrisonCapacitiveDisplayFrame)
	B.ReskinButton(GarrisonCapacitiveDisplayFrame.StartWorkOrderButton)
	B.ReskinButton(GarrisonCapacitiveDisplayFrame.CreateAllWorkOrdersButton)
	B.ReskinArrow(GarrisonCapacitiveDisplayFrame.DecrementButton, "left")
	B.ReskinArrow(GarrisonCapacitiveDisplayFrame.IncrementButton, "right")
	B.CreateBDFrame(GarrisonCapacitiveDisplayFrame.Count, 0)

	-- Capacitive display

	local CapacitiveDisplay = GarrisonCapacitiveDisplayFrame.CapacitiveDisplay
	CapacitiveDisplay.IconBG:Hide()
	B.ReskinGarrisonPortrait(CapacitiveDisplay.ShipmentIconFrame.Follower)

	local reagentIndex = 1
	hooksecurefunc("GarrisonCapacitiveDisplayFrame_Update", function()
		local reagents = CapacitiveDisplay.Reagents

		local reagent = reagents[reagentIndex]
		while reagent do
			reagent.NameFrame:SetAlpha(0)

			local ic = B.ReskinIcon(reagent.Icon)
			B.CreateBGFrame(reagent, 2, 0, -5, 0, ic)

			reagentIndex = reagentIndex + 1
			reagent = reagents[reagentIndex]
		end
	end)

	-- [[ Landing page ]]

	local GarrisonLandingPage = GarrisonLandingPage
	B.ReskinFrame(GarrisonLandingPage)

	for i = 1, 3 do
		B.ReskinTab(_G["GarrisonLandingPageTab"..i])
	end

	GarrisonLandingPageTab1:ClearAllPoints()
	GarrisonLandingPageTab1:SetPoint("TOPLEFT", GarrisonLandingPage, "BOTTOMLEFT", 70, 2)

	-- Report

	local Report = GarrisonLandingPage.Report

	select(2, Report:GetRegions()):Hide()
	Report.List:GetRegions():Hide()

	local scrollFrame = Report.List.listScroll
	B.ReskinScroll(scrollFrame.scrollBar)

	local buttons = scrollFrame.buttons
	for i = 1, #buttons do
		local button = buttons[i]
		button.BG:Hide()
		B.CreateBDFrame(button, 0, -C.mult*2)

		for _, reward in pairs(button.Rewards) do
			reward:GetRegions():Hide()
			reward.IconBorder:SetAlpha(0)
			reward:ClearAllPoints()
			reward:SetPoint("TOPRIGHT", -5, -4.5)
			B.ReskinIcon(reward.Icon)
		end
	end

	for _, tab in pairs({Report.InProgress, Report.Available}) do
		B.CleanTextures(tab)
		tab.Text:ClearAllPoints()
		tab.Text:SetPoint("CENTER")
		local bg = B.CreateBDFrame(tab, 0)

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
		B.CleanTextures(unselectedTab)
		unselectedTab:SetHeight(36)
		unselectedTab.selectedTex:Hide()

		B.CleanTextures(self)
		self.selectedTex:Show()
	end)

	-- Follower list

	local FollowerList = GarrisonLandingPage.FollowerList
	FollowerList:GetRegions():Hide()
	select(2, FollowerList:GetRegions()):Hide()
	B.ReskinInput(FollowerList.SearchBox)

	local scrollFrame = FollowerList.listScroll
	B.ReskinScroll(scrollFrame.scrollBar)

	hooksecurefunc(GarrisonLandingPageFollowerList, "UpdateData", onUpdateData)
	hooksecurefunc(GarrisonLandingPageFollowerList, "ShowFollower", onShowFollower)

	-- Ship follower list

	local FollowerList = GarrisonLandingPage.ShipFollowerList
	FollowerList:GetRegions():Hide()
	select(2, FollowerList:GetRegions()):Hide()
	B.ReskinInput(FollowerList.SearchBox)

	local scrollFrame = FollowerList.listScroll
	B.ReskinScroll(scrollFrame.scrollBar)

	-- Follower tab

	local FollowerTab = GarrisonLandingPage.FollowerTab
	B.ReskinXPBar(FollowerTab)
	B.ReskinClassIcon(FollowerTab, 50, "TOPRIGHT", 0, -3)

	-- Ship follower tab

	local FollowerTab = GarrisonLandingPage.ShipFollowerTab
	B.ReskinXPBar(FollowerTab)
	B.ReskinFollowerTab(FollowerTab)

	-- [[ Mission UI ]]

	local GarrisonMissionFrame = GarrisonMissionFrame
	B.ReskinMissionFrame(GarrisonMissionFrame)

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
			B.ReskinIcon(icon)

			ability.styled = true
		end
	end)

	hooksecurefunc("GarrisonFollowerButton_SetCounterButton", function(button, _, index)
		local counter = button.Counters[index]
		if counter and not counter.styled then
			B.ReskinIcon(counter.Icon)

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
			B.ReskinIcon(reward.Icon)
		end
	end)

	hooksecurefunc("GarrisonMissionPortrait_SetFollowerPortrait", function(portraitFrame, followerInfo)
		if not portraitFrame.styled then
			B.ReskinGarrisonPortrait(portraitFrame)

			portraitFrame.styled = true
		end

		local r, g, b = GetItemQualityColor(followerInfo.quality or 1)
		portraitFrame.squareBG:SetBackdropBorderColor(r, g, b)
		portraitFrame.squareBG:Show()
	end)

	hooksecurefunc("GarrisonMissionPage_SetReward", function(frame)
		if not frame.styled then
			frame.BG:Hide()
			frame.IconBorder:SetAlpha(0)
			B.ReskinIcon(frame.Icon)

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
						B.ReskinIcon(counter.Icon)

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
					B.ReskinIcon(mechanic.Icon)
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
					B.ReskinIcon(buff.Icon)

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
					B.ReskinGarrisonPortrait(frame.PortraitFrame)

					local oldBg = frame:GetRegions()
					oldBg:Hide()
					frame.bg = B.CreateBDFrame(oldBg, 0)
					frame.bg:SetPoint("TOPLEFT", frame.PortraitFrame, -C.mult, C.mult)
					frame.bg:SetPoint("BOTTOMRIGHT", -10, 8)
				end

				local quality = select(4, C_Garrison.GetFollowerMissionCompleteInfo(mission.followers[i]))
				if quality then
					local r, g, b = GetItemQualityColor(quality or 1)
					frame.PortraitFrame.squareBG:SetBackdropBorderColor(r, g, b)
					frame.PortraitFrame.squareBG:Show()
				end

				if frame.XP then
					B.ReskinStatusBar(frame.XP, true)
				end

				if frame.Class then
					B.ReskinClassIcon(frame, 40, "RIGHT", -17, -1)
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
	B.ReskinFrame(GarrisonRecruiterFrame)

	-- Pick

	local Pick = GarrisonRecruiterFrame.Pick

	B.ReskinButton(Pick.ChooseRecruits)
	B.ReskinDropDown(Pick.ThreatDropDown)
	B.ReskinRadio(Pick.Radio1)
	B.ReskinRadio(Pick.Radio2)

	-- Unavailable frame

	local UnavailableFrame = GarrisonRecruiterFrame.UnavailableFrame

	B.ReskinButton(UnavailableFrame:GetChildren())

	-- [[ Recruiter select frame ]]

	local GarrisonRecruitSelectFrame = GarrisonRecruitSelectFrame
	B.ReskinFrame(GarrisonRecruitSelectFrame)

	GarrisonRecruitSelectFrame.TitleText:Show()
	GarrisonRecruitSelectFrame.GarrCorners:Hide()

	-- Follower list

	local FollowerList = GarrisonRecruitSelectFrame.FollowerList

	FollowerList:DisableDrawLayer("BORDER")
	B.ReskinScroll(FollowerList.listScroll.scrollBar)
	B.ReskinInput(FollowerList.SearchBox)

	hooksecurefunc(FollowerList, "UpdateData", onUpdateData)
	hooksecurefunc(FollowerList, "ShowFollower", onShowFollower)

	-- Follower selection

	local FollowerSelection = GarrisonRecruitSelectFrame.FollowerSelection

	FollowerSelection:DisableDrawLayer("BORDER")
	for i = 1, 3 do
		local recruit = FollowerSelection["Recruit"..i]
		B.ReskinGarrisonPortrait(recruit.PortraitFrame)
		B.ReskinButton(recruit.HireRecruits)
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
	B.CreateBG(GarrisonMonumentFrame, 6, -10, -6, 4)

	do
		local left = GarrisonMonumentFrame.LeftBtn
		local right = GarrisonMonumentFrame.RightBtn

		left.Texture:Hide()
		right.Texture:Hide()
		B.ReskinArrow(left, "left")
		B.ReskinArrow(right, "right")
		left:SetSize(35, 35)
		left.bgTex:SetSize(16, 16)
		right:SetSize(35, 35)
		right.bgTex:SetSize(16, 16)
	end

	-- [[ Shipyard ]]

	local GarrisonShipyardFrame = GarrisonShipyardFrame
	B.StripTextures(GarrisonShipyardFrame.BorderFrame)
	B.ReskinFrame(GarrisonShipyardFrame)

	GarrisonShipyardFrame.BorderFrame.TitleText:Show()
	GarrisonShipyardFrame.BorderFrame.GarrCorners:Hide()
	GarrisonShipyardFrame.BackgroundTile:Hide()

	B.ReskinInput(GarrisonShipyardFrameFollowers.SearchBox)
	B.ReskinScroll(GarrisonShipyardFrameFollowersListScrollFrameScrollBar)
	GarrisonShipyardFrameFollowers:GetRegions():Hide()
	select(2, GarrisonShipyardFrameFollowers:GetRegions()):Hide()
	GarrisonShipyardFrameFollowers:DisableDrawLayer("BORDER")
	B.ReskinGarrMaterial(GarrisonShipyardFrameFollowers)

	local shipyardTab = GarrisonShipyardFrame.FollowerTab
	shipyardTab:DisableDrawLayer("BORDER")
	B.ReskinXPBar(shipyardTab)
	B.ReskinFollowerTab(shipyardTab)

	B.ReskinClose(GarrisonShipyardFrame.BorderFrame.CloseButton2)
	B.SetupTabStyle(GarrisonShipyardFrame, 2)

	local shipyardMission = GarrisonShipyardFrame.MissionTab.MissionPage
	B.StripTextures(shipyardMission)
	B.ReskinClose(shipyardMission.CloseButton)
	B.ReskinButton(shipyardMission.StartMissionButton)
	B.CreateBGFrame(shipyardMission.Stage, 4, 1, -4, -1)

	for i = 1, 10 do
		select(i, shipyardMission.RewardsFrame:GetRegions()):Hide()
	end
	B.CreateBDFrame(shipyardMission.RewardsFrame, 0)

	GarrisonShipyardFrame.MissionCompleteBackground:GetRegions():Hide()
	GarrisonShipyardFrame.MissionTab.MissionList.CompleteDialog:GetRegions():Hide()
	B.ReskinButton(GarrisonShipyardFrame.MissionTab.MissionList.CompleteDialog.BorderFrame.ViewButton)
	select(11, GarrisonShipyardFrame.MissionComplete.BonusRewards:GetRegions()):SetTextColor(1, .8, 0)
	B.ReskinButton(GarrisonShipyardFrame.MissionComplete.NextMissionButton)

	-- [[ Orderhall UI]]

	local OrderHallMissionFrame = OrderHallMissionFrame
	B.ReskinMissionFrame(OrderHallMissionFrame)
	B.ReskinClassIcon(OrderHallMissionFrame.FollowerTab, 50, "TOPRIGHT", 0, -3)

	-- Ally
	local combatAlly = OrderHallMissionFrameMissions.CombatAllyUI
	B.ReskinButton(combatAlly.InProgress.Unassign)
	combatAlly:GetRegions():Hide()
	B.CreateBDFrame(combatAlly, 0)

	local ipas = combatAlly.InProgress.CombatAllySpell.iconTexture
	B.ReskinIcon(ipas)

	local allyPortrait = combatAlly.InProgress.PortraitFrame
	B.ReskinGarrisonPortrait(allyPortrait)
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
	B.ReskinFrame(ZoneSupportMissionPage)
	B.ReskinButton(ZoneSupportMissionPage.StartMissionButton)
	ZoneSupportMissionPage.Follower1:GetRegions():Hide()
	B.CreateBDFrame(ZoneSupportMissionPage.Follower1, 0)
	B.ReskinGarrisonPortrait(ZoneSupportMissionPage.Follower1.PortraitFrame)

	local zsas = ZoneSupportMissionPage.CombatAllySpell.iconTexture
	B.ReskinIcon(zsas)

	local cost = ZoneSupportMissionPage.CostFrame
	B.ReskinIcon(cost.CostIcon)

	-- [[ BFA Mission UI]]

	local BFAMissionFrame = BFAMissionFrame
	BFAMissionFrame.OverlayElements.Topper:Hide()
	B.ReskinMissionFrame(BFAMissionFrame)
	B.ReskinClassIcon(BFAMissionFrame.FollowerTab, 50, "TOPRIGHT", 0, -3)

	-- [[ Addon supports ]]

	local function buttonOnUpdate(MissionList)
		local buttons = MissionList.listScroll.buttons
		for i = 1, #buttons do
			local bu = select(3, buttons[i]:GetChildren())
			if bu and bu:GetObjectType() == "Button" and not bu.styled then
				B.ReskinButton(bu)
				bu:SetSize(60, 45)

				bu.styled = true
			end
		end
	end

	local function buttonOnShow(MissionPage)
		for i = 18, 26 do
			local bu = select(i, MissionPage:GetChildren())
			if bu and bu:GetObjectType() == "Button" and not bu.styled then
				B.ReskinButton(bu)
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