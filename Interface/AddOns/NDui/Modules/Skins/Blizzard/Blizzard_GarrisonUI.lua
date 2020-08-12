local B, C, L, DB = unpack(select(2, ...))

C.themes["Blizzard_GarrisonUI"] = function()
	local cr, cg, cb = DB.r, DB.g, DB.b

	-- [[Functions]]
	GARRISON_FOLLOWER_ITEM_LEVEL = "iLvl %d"

	function B:ReskinMaterialFrame()
		self:GetRegions():Hide()

		B.CreateBDFrame(self, 0, -5)
		B.ReskinIcon(self.Icon)
	end

	function B:ReskinCompleteDialog()
		B.StripTextures(self)
		B.ReskinButton(self.BorderFrame.ViewButton)
		B.CreateBGFrame(self.BorderFrame.Stage, 2, 1, -2, -1)
	end

	function B:ReskinFollowerClass(size, point, x, y, relativeTo)
		relativeTo = relativeTo or self:GetParent()

		self:SetSize(size, size)
		self:ClearAllPoints()
		self:SetPoint(point, relativeTo, x, y)
		self:SetTexCoord(.18, .92, .08, .92)
		B.CreateBDFrame(self, 0)
	end

	function B:ReskinShipFollowerTab()
		for i = 1, 2 do
			local trait = self.Traits[i]
			if trait and not trait.icbg then
				trait.Border:Hide()
				trait.icbg = B.ReskinIcon(trait.Portrait)
			end

			local equip = self.EquipmentFrame.Equipment[i]
			if equip and not equip.icbg then
				equip.BG:Hide()
				equip.Border:Hide()
				equip.icbg = B.ReskinIcon(equip.Icon)
			end

			local counter = equip.Counter
			if counter and not counter.icbg then
				counter.Border:Hide()
				counter.icbg = B.ReskinIcon(counter.Icon)
			end
		end
	end

	function B:ReskinFollowerTab(isShip)
		B.StripTextures(self)
		B.ReskinStatusBar(self.XPBar, true)

		if self.Class then
			B.ReskinFollowerClass(self.Class, 50, "TOPRIGHT", 0, -3)
		end

		if isShip then
			B.ReskinShipFollowerTab(self)
		end
	end

	function B:ReskinFollowerList()
		B.StripTextures(self)
		B.ReskinScroll(self.listScroll.scrollBar)

		if self.SearchBox then
			B.ReskinInput(self.SearchBox)
		end
		if self.MaterialFrame then
			B.ReskinMaterialFrame(self.MaterialFrame)
		end
	end

	function B:ReskinMissionTab()
		local frameName = B.GetFrameName(self)
		for i = 1, 2 do
			local tab = _G[frameName.."Tab"..i]
			B.StripTextures(tab)

			local bg = B.CreateBDFrame(tab, 0)
			tab.bg = bg

			if i == 1 then
				bg:SetBackdropColor(cr, cg, cb, .25)
			end
		end
	end

	function B:ReskinMissionComplete()
		B.ReskinButton(self.NextMissionButton)

		local BonusRewards = self.BonusRewards
		B.StripTextures(BonusRewards)
		B.StripTextures(BonusRewards.Saturated)
		select(11, BonusRewards:GetRegions()):SetTextColor(1, .8, 0)
	end

	function B:ReskinMissionPage(isShip)
		B.StripTextures(self)
		B.StripTextures(self.Stage)
		B.StripTextures(self.RewardsFrame, 11)

		B.ReskinButton(self.StartMissionButton)
		B.CreateBGFrame(self, 0, 5, 0, -15)

		local bg = B.CreateBGFrame(self.Stage, 4, 1, -4, -1)
		B.ReskinClose(self.CloseButton, "TOPRIGHT", bg, "TOPRIGHT", -6, -6)

		local MissionEnvIcon = self.Stage.MissionEnvIcon
		MissionEnvIcon.Texture:SetDrawLayer("ARTWORK")

		local icbg = B.ReskinIcon(MissionEnvIcon.Texture)
		icbg:SetFrameLevel(MissionEnvIcon:GetFrameLevel())
		MissionEnvIcon.icbg = icbg

		local CostFrame = self.CostFrame
		B.ReskinIcon(CostFrame.CostIcon)

		if not isShip then
			for i = 1, 3 do
				local Followers = self.Followers[i]
				B.StripTextures(Followers)
				B.CreateBDFrame(Followers, 0)
				B.ReskinPortrait(Followers.PortraitFrame)

				Followers.PortraitFrame:ClearAllPoints()
				Followers.PortraitFrame:SetPoint("TOPLEFT", 3, -3)
				Followers.Durability:ClearAllPoints()
				Followers.Durability:SetPoint("BOTTOM", Followers.PortraitFrame, "BOTTOM", 1, 12)
				Followers.DurabilityBackground:SetAlpha(0)

				if Followers.Class then
					B.ReskinFollowerClass(Followers.Class, 40, "RIGHT", -10, 0)
				end
			end
		end
	end

	function B:ReskinMissionList()
		local buttons = self.listScroll.buttons
		for i = 1, #buttons do
			local button = buttons[i]
			if not button.styled then
				B.StripTextures(button)

				local bubg = B.CreateBDFrame(button, 0, -2)
				B.ReskinHighlight(button.Highlight, bubg, true)

				local LocBG = button.LocBG
				LocBG:ClearAllPoints()
				LocBG:SetPoint("TOPLEFT", bubg, 1, 0)
				LocBG:SetPoint("BOTTOMRIGHT", bubg, -1, -2)

				for _, overlay in pairs({button.RareOverlay, button.Overlay.Overlay}) do
					overlay:SetDrawLayer("BACKGROUND")
					overlay:SetTexture(DB.bdTex)
					overlay:ClearAllPoints()
					overlay:SetPoint("TOPLEFT", LocBG, 0, -1)
					overlay:SetPoint("BOTTOMRIGHT", LocBG, 0, 3)
				end

				local RareOverlay = button.RareOverlay
				RareOverlay:SetVertexColor(.1, .5, .9, .25)

				local Overlay = button.Overlay.Overlay
				Overlay:SetVertexColor(.1, .1, .1, .25)

				local levelText = button.Level
				levelText:SetJustifyH("LEFT")
				levelText:ClearAllPoints()
				levelText:SetPoint("LEFT", button, 10, 0)

				local rareText = button.RareText
				rareText:SetJustifyH("LEFT")
				rareText:ClearAllPoints()
				rareText:SetPoint("LEFT", button, 85, 0)

				local itemText = button.ItemLevel
				itemText:SetJustifyH("LEFT")
				itemText:ClearAllPoints()
				itemText:SetPoint("LEFT", button.Summary, "RIGHT", 8, 0)

				button.styled = true
			end
		end
	end

	local function onUpdateData(self)
		local followerFrame = self:GetParent()
		local scrollFrame = followerFrame.FollowerList.listScroll
		local buttons = scrollFrame.buttons
		if not buttons then return end

		for i = 1, #buttons do
			local button = buttons[i].Follower
			local PortraitFrame = button.PortraitFrame

			if not button.styled then
				B.StripTextures(button)

				local bubg = B.CreateBDFrame(button, 0)
				B.ReskinHighlight(button, bubg, true)
				B.ReskinHighlight(button.Selection, bubg, true)
				button.BusyFrame:SetAllPoints(bubg)

				if PortraitFrame then
					B.ReskinPortrait(PortraitFrame)
					PortraitFrame:ClearAllPoints()
					PortraitFrame:SetPoint("TOPLEFT", 4, -2)
				end

				if button.Class then
					B.ReskinFollowerClass(button.Class, 40, "RIGHT", -9, 0)
				end

				if button.XPBar then
					button.XPBar:SetTexture(DB.bdTex)
					button.XPBar:SetVertexColor(cr, cg, cb, .25)
					button.XPBar:SetPoint("TOPLEFT", bubg, C.mult, -C.mult)
					button.XPBar:SetPoint("BOTTOMLEFT", bubg, C.mult, C.mult)
				end

				button.styled = true
			end

			if button.Counters then
				for i = 1, #button.Counters do
					local counter = button.Counters[i]
					if counter and not counter.icbg then
						counter.icbg = B.ReskinIcon(counter.Icon)
					end
				end
			end

			if PortraitFrame and PortraitFrame.quality then
				B.UpdatePortraitColor(PortraitFrame)
			end
		end
	end

	local function onShowFollower(followerList)
		local self = followerList.followerTab
		local AbilitiesFrame = self.AbilitiesFrame
		if not AbilitiesFrame then return end

		local Abilities = AbilitiesFrame.Abilities
		if Abilities then
			for i = 1, #Abilities do
				local button = Abilities[i].IconButton
				if button and not button.icbg then
					button.Border:Hide()
					button.icbg = B.ReskinIcon(button.Icon)
				end
			end
		end

		local Equipment = AbilitiesFrame.Equipment
		if Equipment then
			for i = 1, #Equipment do
				local equip = Equipment[i]
				if equip and not equip.icbg then
					equip.BG:Hide()
					equip.Border:Hide()
					equip.icbg = B.ReskinIcon(equip.Icon)
					equip.icbg:SetBackdropColor(1, 1, 1, .25)
				end
			end
		end

		local CombatAllySpell = AbilitiesFrame.CombatAllySpell
		if CombatAllySpell then
			for i = 1, #CombatAllySpell do
				local spell = CombatAllySpell[i]
				if spell and not spell.icbg then
					spell.icbg = B.ReskinIcon(spell.iconTexture)
				end
			end
		end
	end

	function B:ReskinMissionFrame()
		B.ReskinFrame(self)
		B.ReskinFrameTab(self, 3)

		self.MissionCompleteBackground:SetAlpha(0)
		if self.ClassHallIcon then self.ClassHallIcon:Hide() end
		if self.OverlayElements then self.OverlayElements:Hide() end
		if self.MapTab then self.MapTab.ScrollContainer.Child.TiledBackground:Hide() end
		if self.TitleScroll then
			B.StripTextures(self.TitleScroll)
			select(4, self.TitleScroll:GetRegions()):SetTextColor(1, .8, 0)
		end

		B.ReskinMissionComplete(self.MissionComplete)
		B.ReskinMissionPage(self.MissionTab.MissionPage)

		local MissionList = self.MissionTab.MissionList
		B.ReskinFollowerList(MissionList)
		B.ReskinMissionTab(MissionList)
		B.ReskinCompleteDialog(MissionList.CompleteDialog)
		hooksecurefunc(MissionList, "Update", B.ReskinMissionList)

		local FollowerList = self.FollowerList
		B.ReskinFollowerList(FollowerList)
		hooksecurefunc(FollowerList, "UpdateData", onUpdateData)
		hooksecurefunc(FollowerList, "ShowFollower", onShowFollower)

		local FollowerTab = self.FollowerTab
		B.ReskinFollowerTab(FollowerTab)
		for _, item in pairs({FollowerTab.ItemWeapon, FollowerTab.ItemArmor}) do
			if item then
				B.StripTextures(item)
				B.ReskinIcon(item.Icon)
			end
		end
	end

	hooksecurefunc("GarrisonFollowerButton_AddAbility", function(self, index)
		local Abilities = self.Abilities[index]

		if not Abilities.styled then
			local icon = Abilities.Icon
			icon:SetSize(19, 19)
			B.ReskinIcon(icon)

			Abilities.styled = true
		end
	end)

	hooksecurefunc("GarrisonMissionButton_SetRewards", function(self, rewards)
		if not self.numRewardsStyled then self.numRewardsStyled = 0 end

		while self.numRewardsStyled < #rewards do
			self.numRewardsStyled = self.numRewardsStyled + 1
			local reward = self.Rewards[self.numRewardsStyled]
			reward:GetRegions():Hide()

			local icbg = B.ReskinIcon(reward.Icon)
			B.ReskinBorder(reward.IconBorder, icbg)
			icbg:SetFrameLevel(reward:GetFrameLevel())
		end
	end)

	hooksecurefunc("GarrisonMissionPage_SetReward", function(frame)
		if not frame.styled then
			frame.BG:Hide()

			local icbg = B.ReskinIcon(frame.Icon)
			B.ReskinBorder(frame.IconBorder, icbg)

			frame.styled = true
		end
	end)

	hooksecurefunc("GarrisonMissionPortrait_SetFollowerPortrait", function(portraitFrame)
		if not portraitFrame.styled then
			B.ReskinPortrait(portraitFrame)

			portraitFrame.styled = true
		end

		B.UpdatePortraitColor(portraitFrame)
	end)

	hooksecurefunc("GarrisonMissonListTab_SetSelected", function(tab, isSelected)
		if isSelected then
			tab.bg:SetBackdropColor(cr, cg, cb, .25)
		else
			tab.bg:SetBackdropColor(0, 0, 0, 0)
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

	hooksecurefunc(GarrisonMission, "ShowMission", function(self)
		local MissionEnvIcon = self:GetMissionPage().Stage.MissionEnvIcon
		if MissionEnvIcon.icbg then
			MissionEnvIcon.icbg:SetShown(MissionEnvIcon.Texture:GetTexture())
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

	hooksecurefunc(GarrisonMissionComplete, "ShowRewards", function(self)
		local currentMission = self.currentMission

		for _, reward in pairs(currentMission.rewards) do
			if reward and not reward.icbg then
				reward.icbg = B.ReskinIcon(reward.Icon)
			end

			B.ReskinBorder(reward.IconBorder, reward.icbg)
		end
	end)

	-- [[GarrisonLandingPage]]
	local GarrisonLandingPage = GarrisonLandingPage
	B.ReskinFrame(GarrisonLandingPage)
	B.ReskinFrameTab(GarrisonLandingPage, 3)
	B.ReskinFollowerList(GarrisonLandingPage.FollowerList)
	B.ReskinFollowerTab(GarrisonLandingPage.FollowerTab)
	B.ReskinFollowerList(GarrisonLandingPage.ShipFollowerList)
	B.ReskinFollowerTab(GarrisonLandingPage.ShipFollowerTab, true)

	hooksecurefunc(GarrisonLandingPageFollowerList, "UpdateData", onUpdateData)
	hooksecurefunc(GarrisonLandingPageFollowerList, "ShowFollower", onShowFollower)

	-- Report
	local Report = GarrisonLandingPage.Report
	B.StripTextures(Report, 0)
	B.StripTextures(Report.List)

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
	end

	hooksecurefunc("GarrisonLandingPageReport_SetTab", function(self)
		local unselectedTab = Report.unselectedTab
		B.CleanTextures(unselectedTab)
		unselectedTab:SetHeight(36)
		unselectedTab.selectedTex:Hide()

		B.CleanTextures(self)
		self.selectedTex:Show()
	end)

	local scrollFrame = Report.List.listScroll
	B.ReskinScroll(scrollFrame.scrollBar)

	local buttons = scrollFrame.buttons
	for i = 1, #buttons do
		local button = buttons[i]
		button.BG:Hide()
		B.CreateBDFrame(button, 0, -C.mult*2)

		for _, reward in pairs(button.Rewards) do
			reward:GetRegions():Hide()
			reward:ClearAllPoints()
			reward:SetPoint("TOPRIGHT", -5, -4.5)

			local icbg = B.ReskinIcon(reward.Icon)
			B.ReskinBorder(reward.IconBorder, icbg)
		end
	end

	-- [[BFAMissionFrame]]
	local BFAMissionFrame = BFAMissionFrame
	B.ReskinMissionFrame(BFAMissionFrame)

	-- [[OrderHallMissionFrame]]
	local OrderHallMissionFrame = OrderHallMissionFrame
	B.ReskinMissionFrame(OrderHallMissionFrame)

	-- CombatAllyUI
	local CombatAllyUI = OrderHallMissionFrameMissions.CombatAllyUI
	B.StripTextures(CombatAllyUI)
	B.CreateBDFrame(CombatAllyUI, 0)
	B.ReskinButton(CombatAllyUI.InProgress.Unassign)
	B.ReskinIcon(CombatAllyUI.InProgress.CombatAllySpell.iconTexture)

	local PortraitFrame = CombatAllyUI.InProgress.PortraitFrame
	B.ReskinPortrait(PortraitFrame)
	OrderHallMissionFrame:HookScript("OnShow", function()
		if PortraitFrame:IsShown() then
			B.UpdatePortraitColor(PortraitFrame)
		end
		CombatAllyUI.Available.AddFollowerButton.EmptyPortrait:SetAlpha(0)
		CombatAllyUI.Available.AddFollowerButton.PortraitHighlight:SetAlpha(0)
	end)

	-- ZoneSupportMissionPage
	local ZoneSupportMissionPage = OrderHallMissionFrame.MissionTab.ZoneSupportMissionPage
	B.ReskinButton(ZoneSupportMissionPage.StartMissionButton)
	B.ReskinIcon(ZoneSupportMissionPage.CombatAllySpell.iconTexture)
	B.ReskinIcon(ZoneSupportMissionPage.CostFrame.CostIcon)

	local bg = B.ReskinFrame(ZoneSupportMissionPage)
	bg:SetFrameLevel(OrderHallMissionFrame.MissionTab:GetFrameLevel()+1)

	local Follower1 = ZoneSupportMissionPage.Follower1
	B.StripTextures(Follower1)
	B.CreateBDFrame(Follower1, 0)
	B.ReskinPortrait(Follower1.PortraitFrame)
	B.ReskinFollowerClass(Follower1.Class, 40, "RIGHT", -10, 0)
	Follower1.PortraitFrame:ClearAllPoints()
	Follower1.PortraitFrame:SetPoint("TOPLEFT", 3, -3)

	-- [[GarrisonMissionFrame]]
	local GarrisonMissionFrame = GarrisonMissionFrame
	B.ReskinMissionFrame(GarrisonMissionFrame)

	-- [[GarrisonShipyardFrame]]
	local GarrisonShipyardFrame = GarrisonShipyardFrame
	GarrisonShipyardFrame.MissionCompleteBackground:SetAlpha(0)

	local shipyardBG = B.ReskinFrame(GarrisonShipyardFrame)
	B.ReskinFrameTab(GarrisonShipyardFrame, 2)
	B.ReskinFollowerList(GarrisonShipyardFrame.FollowerList)
	B.ReskinFollowerTab(GarrisonShipyardFrame.FollowerTab, true)
	B.ReskinMissionPage(GarrisonShipyardFrame.MissionTab.MissionPage, true)
	B.ReskinMissionComplete(GarrisonShipyardFrame.MissionComplete)

	-- BorderFrame
	local BorderFrame = GarrisonShipyardFrame.BorderFrame
	B.StripTextures(BorderFrame)
	B.ReskinClose(BorderFrame.CloseButton2)

	-- MissionList
	local MissionList = GarrisonShipyardFrame.MissionTab.MissionList
	B.ReskinCompleteDialog(MissionList.CompleteDialog)
	MissionList.MapTexture:SetInside(shipyardBG)

	-- [[GarrisonBuildingFrame]]
	local GarrisonBuildingFrame = GarrisonBuildingFrame
	B.ReskinFrame(GarrisonBuildingFrame)
	GarrisonBuildingFrame.MapFrame.TownHall.TownHallName:SetTextColor(1, .8, 0)

	-- MainHelpButton
	local MainHelpButton = GarrisonBuildingFrame.MainHelpButton
	MainHelpButton.Ring:Hide()
	MainHelpButton:ClearAllPoints()
	MainHelpButton:SetPoint("TOPLEFT", GarrisonBuildingFrame, "TOPLEFT", -12, 12)

	-- BuildingList
	local BuildingList = GarrisonBuildingFrame.BuildingList
	B.StripTextures(BuildingList)
	B.ReskinMaterialFrame(BuildingList.MaterialFrame)

	for i = 1, GARRISON_NUM_BUILDING_SIZES do
		local tab = BuildingList["Tab"..i]
		B.StripTextures(tab, 0)

		local bg = B.CreateBGFrame(tab, 6, -7, -6, 7)
		tab.bg = bg
	end

	hooksecurefunc("GarrisonBuildingList_SelectTab", function(tab)
		for i = 1, GARRISON_NUM_BUILDING_SIZES do
			local otherTab = BuildingList["Tab"..i]
			if i ~= tab:GetID() then
				otherTab.bg:SetBackdropColor(0, 0, 0, 0)
			end
		end
		tab.bg:SetBackdropColor(cr, cg, cb, .25)

		for _, button in pairs(BuildingList.Buttons) do
			if not button.styled then
				button.BG:Hide()

				local icbg = B.ReskinIcon(button.Icon)
				local bg = B.CreateBGFrame(button, 2, 0, 0, 0, icbg)
				B.ReskinHighlight(button, bg, true)
				B.ReskinHighlight(button.SelectedBG, bg, true)

				button.styled = true
			end
		end
	end)

	-- Followers
	local Followers = GarrisonBuildingFrameFollowers
	Followers:ClearAllPoints()
	Followers:SetPoint("BOTTOMLEFT", 20, 34)

	-- FollowerList
	local FollowerList = GarrisonBuildingFrame.FollowerList
	B.ReskinFollowerList(FollowerList)
	hooksecurefunc(FollowerList, "UpdateData", onUpdateData)
	hooksecurefunc(FollowerList, "ShowFollower", onShowFollower)

	-- InfoBox and TownHallBox
	for _, boxs in pairs({"TownHallBox", "InfoBox"}) do
		local box = GarrisonBuildingFrame[boxs]
		B.StripTextures(box)
		B.CreateBDFrame(box, 0)
		B.ReskinButton(box.UpgradeButton)
	end

	local InfoBox = GarrisonBuildingFrame.InfoBox
	InfoBox.AddFollowerButton.EmptyPortrait:SetAlpha(0)
	InfoBox.AddFollowerButton.PortraitHighlight:SetAlpha(0)

	local FollowerPortrait = InfoBox.FollowerPortrait
	B.ReskinPortrait(FollowerPortrait)

	FollowerPortrait:ClearAllPoints()
	FollowerPortrait:SetPoint("BOTTOMLEFT", InfoBox.DragArea, "BOTTOMRIGHT", 10, 0)
	FollowerPortrait.FollowerName:ClearAllPoints()
	FollowerPortrait.FollowerName:SetPoint("BOTTOMLEFT", FollowerPortrait, "RIGHT", 4, 4)
	FollowerPortrait.FollowerStatus:ClearAllPoints()
	FollowerPortrait.FollowerStatus:SetPoint("TOPLEFT", FollowerPortrait, "RIGHT", 4, 4)
	FollowerPortrait.RemoveFollowerButton:ClearAllPoints()
	FollowerPortrait.RemoveFollowerButton:SetPoint("TOPRIGHT", 4, 4)

	hooksecurefunc("GarrisonBuildingInfoBox_ShowFollowerPortrait", function(_, _, infoBox)
		local FollowerPortrait = infoBox.FollowerPortrait

		if FollowerPortrait:IsShown() then
			B.UpdatePortraitColor(FollowerPortrait)
		end
	end)

	-- Confirmation
	local Confirmation = GarrisonBuildingFrame.Confirmation
	B.ReskinFrame(Confirmation)

	for _, buttons in pairs({"CancelButton", "BuildButton", "UpgradeButton", "UpgradeGarrisonButton", "ReplaceButton", "SwitchButton"}) do
		local button = Confirmation[buttons]
		B.ReskinButton(button)
	end

	-- [[GarrisonMonumentFrame]]
	local GarrisonMonumentFrame = GarrisonMonumentFrame
	B.ReskinFrame(GarrisonMonumentFrame)

	local LeftBtn = GarrisonMonumentFrame.LeftBtn
	B.ReskinArrow(LeftBtn, "left")
	LeftBtn:SetSize(36, 36)
	LeftBtn.arrowTex:SetSize(18, 18)
	local RightBtn = GarrisonMonumentFrame.RightBtn
	B.ReskinArrow(RightBtn, "right")
	RightBtn:SetSize(36, 36)
	RightBtn.arrowTex:SetSize(18, 18)

	-- [[GarrisonRecruiterFrame]]
	local GarrisonRecruiterFrame = GarrisonRecruiterFrame
	B.ReskinFrame(GarrisonRecruiterFrame)

	-- Pick
	local Pick = GarrisonRecruiterFrame.Pick
	B.ReskinButton(Pick.ChooseRecruits)
	B.ReskinDropDown(Pick.ThreatDropDown)
	B.ReskinRadio(Pick.Radio1)
	B.ReskinRadio(Pick.Radio2)

	-- [[GarrisonRecruitSelectFrame]]
	local GarrisonRecruitSelectFrame = GarrisonRecruitSelectFrame
	B.ReskinFrame(GarrisonRecruitSelectFrame)

	-- FollowerList
	local FollowerList = GarrisonRecruitSelectFrame.FollowerList
	B.ReskinFollowerList(FollowerList)
	hooksecurefunc(FollowerList, "UpdateData", onUpdateData)
	hooksecurefunc(FollowerList, "ShowFollower", onShowFollower)

	-- FollowerSelection
	local FollowerSelection = GarrisonRecruitSelectFrame.FollowerSelection
	B.StripTextures(FollowerSelection)

	for i = 1, 3 do
		local Recruit = FollowerSelection["Recruit"..i]
		local bg = B.CreateBDFrame(Recruit, 0, -C.mult)

		B.ReskinPortrait(Recruit.PortraitFrame)
		B.ReskinButton(Recruit.HireRecruits)
		B.ReskinFollowerClass(Recruit.Class, 40, "TOPRIGHT", -8, -8, bg)

		Recruit.PortraitFrame:ClearAllPoints()
		Recruit.PortraitFrame:SetPoint("TOPLEFT", bg, 4, -4)

		local Counter = Recruit.Counter
		Counter:ClearAllPoints()
		Counter:SetPoint("CENTER", bg, "TOP", 0, 0)
	end

	hooksecurefunc("GarrisonRecruitSelectFrame_UpdateRecruits", function(waiting)
		if waiting then return end

		for i = 1, 3 do
			local Recruit = FollowerSelection["Recruit"..i]

			local PortraitFrame = Recruit.PortraitFrame
			B.UpdatePortraitColor(PortraitFrame)

			local Counter = Recruit.Counter
			if Counter and not Counter.styled then
				B.StripTextures(Counter)

				Counter.Icon:SetMask("")
				B.ReskinIcon(Counter.Icon)

				Counter.styled = true
			end

			local abilities = C_Garrison.GetRecruitAbilities(i)
			local abilityIndex = 0
			local traitIndex = 0
			for _, ability in pairs(abilities) do
				local uiEntry

				if ability.isTrait then
					traitIndex = traitIndex + 1
					uiEntry = GarrisonRecruitSelectFrame_GetAbilityUIEntry(Recruit.Traits, traitIndex)
				else
					abilityIndex = abilityIndex + 1
					uiEntry = GarrisonRecruitSelectFrame_GetAbilityUIEntry(Recruit.Abilities, abilityIndex)
				end

				if uiEntry and not uiEntry.styled then
					B.ReskinIcon(uiEntry.Icon)

					uiEntry.styled = true
				end
			end
		end
	end)

	-- [[GarrisonCapacitiveDisplayFrame]]
	local GarrisonCapacitiveDisplayFrame = GarrisonCapacitiveDisplayFrame
	B.ReskinFrame(GarrisonCapacitiveDisplayFrame)
	B.ReskinButton(GarrisonCapacitiveDisplayFrame.StartWorkOrderButton)
	B.ReskinButton(GarrisonCapacitiveDisplayFrame.CreateAllWorkOrdersButton)
	B.ReskinArrow(GarrisonCapacitiveDisplayFrame.DecrementButton, "left")
	B.ReskinArrow(GarrisonCapacitiveDisplayFrame.IncrementButton, "right")
	B.CreateBDFrame(GarrisonCapacitiveDisplayFrame.Count, 0)

	-- CapacitiveDisplay
	local CapacitiveDisplay = GarrisonCapacitiveDisplayFrame.CapacitiveDisplay
	CapacitiveDisplay.IconBG:Hide()

	local icbg = B.ReskinIcon(CapacitiveDisplay.ShipmentIconFrame.Icon)
	B.CreateBGFrame(CapacitiveDisplay.IconBG, 2, 0, 0, 0, icbg)

	local Follower = CapacitiveDisplay.ShipmentIconFrame.Follower
	B.ReskinPortrait(Follower)
	Follower:ClearAllPoints()
	Follower:SetPoint("CENTER", icbg, 0, -3.5)

	hooksecurefunc("GarrisonCapacitiveDisplayFrame_Update", function(self)
		local index = 1
		local reagents = self.CapacitiveDisplay.Reagents

		while true do
			local reagent = reagents[index]
			if not reagent then return end

			if not reagent.styled then
				reagent.NameFrame:Hide()

				local icbg = B.ReskinIcon(reagent.Icon)
				B.CreateBGFrame(reagent, 2, 0, -5, 0, icbg)

				reagent.styled = true
			end

			index = index + 1
		end
	end)
end