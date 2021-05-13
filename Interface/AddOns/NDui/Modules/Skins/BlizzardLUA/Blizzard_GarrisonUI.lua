local _, ns = ...
local B, C, L, DB = unpack(ns)
local S = B:GetModule("Skins")

local cr, cg, cb = DB.cr, DB.cg, DB.cb
local tL, tR, tT, tB = unpack(DB.TexCoord)

local function Reskin_FollowerTooltipTemplate(tooltipFrame)
	-- Abilities
	if tooltipFrame.numAbilitiesStyled == nil then
		tooltipFrame.numAbilitiesStyled = 1
	end

	local numAbilitiesStyled = tooltipFrame.numAbilitiesStyled
	local abilities = tooltipFrame.Abilities
	local ability = abilities[numAbilitiesStyled]
	while ability do
		B.ReskinIcon(ability.Icon)

		numAbilitiesStyled = numAbilitiesStyled + 1
		ability = abilities[numAbilitiesStyled]
	end

	tooltipFrame.numAbilitiesStyled = numAbilitiesStyled

	-- Traits
	if tooltipFrame.numTraitsStyled == nil then
		tooltipFrame.numTraitsStyled = 1
	end

	local numTraitsStyled = tooltipFrame.numTraitsStyled
	local traits = tooltipFrame.Traits
	local trait = traits[numTraitsStyled]
	while trait do
		B.ReskinIcon(trait.Icon)

		numTraitsStyled = numTraitsStyled + 1
		trait = traits[numTraitsStyled]
	end

	tooltipFrame.numTraitsStyled = numTraitsStyled
end

tinsert(C.XMLThemes, function()
	hooksecurefunc("GarrisonFollowerTooltipTemplate_SetGarrisonFollower", Reskin_FollowerTooltipTemplate)
end)

local function Reskin_MaterialFrame(self)
	self:GetRegions():Hide()

	B.CreateBDFrame(self, 0, 5)
	B.ReskinIcon(self.Icon)
end

local function Reskin_CompleteDialog(self)
	B.StripTextures(self)
	B.ReskinButton(self.BorderFrame.ViewButton)
	B.CreateBGFrame(self.BorderFrame.Stage, 2, 1, -2, -1)
end

local function Reskin_FollowerTab(self, isShip)
	B.StripTextures(self)

	if self.XPBar then
		B.ReskinStatusBar(self.XPBar, true)
	end

	if isShip then
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
end

local function Reskin_FollowerList(self)
	B.StripTextures(self)
	B.ReskinScroll(self.listScroll.scrollBar)

	if self.SearchBox then
		B.ReskinInput(self.SearchBox)
	end
	if self.MaterialFrame then
		Reskin_MaterialFrame(self.MaterialFrame)
	end
end

local function Reskin_MissionTab(self)
	local frameName = self:GetDebugName()
	for i = 1, 2 do
		local tab = _G[frameName.."Tab"..i]
		if tab then
			B.StripTextures(tab)

			local bg = B.CreateBDFrame(tab)
			tab.bg = bg

			if i == 1 then
				bg:SetBackdropColor(cr, cg, cb, .5)
			end
		end
	end
end

local function Reskin_MissionComplete(self)
	if self.NextMissionButton then
		B.ReskinButton(self.NextMissionButton)
	end

	if self.MissionInfo then
		B.StripTextures(self.MissionInfo)
	end

	if self.BonusRewards then
		local BonusRewards = self.BonusRewards
		B.StripTextures(BonusRewards)
		B.StripTextures(BonusRewards.Saturated)
		B.ReskinText(select(11, BonusRewards:GetRegions()), 1, .8, 0)
	end

	if self.CompleteFrame then
		B.StripTextures(self, 0)
		B.CreateBGFrame(self, 3, 2, -3, -10)

		local FinalRewardsPanel = self.RewardsScreen.FinalRewardsPanel
		B.ReskinButton(FinalRewardsPanel.ContinueButton)
		FinalRewardsPanel.RewardsBanner:Hide()

		local CompleteFrame = self.CompleteFrame
		B.StripTextures(CompleteFrame)
		B.ReskinButton(CompleteFrame.ContinueButton)
		B.ReskinButton(CompleteFrame.SpeedButton)
	end
end

local function Reskin_MissionPage(self, isShop)
	B.StripTextures(self, 0)
	B.StripTextures(self.Stage)

	B.ReskinButton(self.StartMissionButton)
	B.CreateBGFrame(self, 0, 5, 0, -15)

	local bg = B.CreateBDFrame(self.Stage)
	bg:SetOutside(self.Stage.LocBack)
	bg:SetShown(self.Stage.LocBack and self.Stage.LocBack:IsShown())

	local CloseButton = self.CloseButton
	B.ReskinClose(CloseButton, bg)
	CloseButton.SetPoint = B.Dummy

	local EnvIcon = self.Stage.MissionEnvIcon
	EnvIcon.Texture:SetDrawLayer("ARTWORK")

	local icbg = B.ReskinIcon(EnvIcon.Texture)
	icbg:SetFrameLevel(EnvIcon:GetFrameLevel())
	EnvIcon.icbg = icbg

	if self.StartMissionFrame then
		B.StripTextures(self.StartMissionFrame)
	end

	if self.CostFrame then
		B.ReskinIcon(self.CostFrame.CostIcon)
	end

	if self.Stage.EnvironmentEffectFrame then
		B.ReskinIcon(self.Stage.EnvironmentEffectFrame.Icon)
	end

	if self.RewardsFrame then
		B.StripTextures(self.RewardsFrame, 11)

		local OvermaxItem = self.RewardsFrame.OvermaxItem
		local icbg = B.ReskinIcon(OvermaxItem.Icon)
		B.ReskinBorder(OvermaxItem.IconBorder, icbg)
	end

	if not isShop and self.Followers then
		for i = 1, 3 do
			local Followers = self.Followers[i]
			B.StripTextures(Followers)
			B.CreateBDFrame(Followers)
			S.ReskinFollowerPortrait(Followers.PortraitFrame)

			Followers.PortraitFrame:ClearAllPoints()
			Followers.PortraitFrame:SetPoint("TOPLEFT", 3, -3)
			Followers.Durability:ClearAllPoints()
			Followers.Durability:SetPoint("BOTTOM", Followers.PortraitFrame, "BOTTOM", 1, 12)
			Followers.DurabilityBackground:SetAlpha(0)

			if Followers.Class then
				S.ReskinFollowerClass(Followers.Class, 40, "RIGHT", -10, 0)
			end
		end
	end
end

local function Reskin_MissionList(self)
	local buttons = self.listScroll.buttons
	for i = 1, #buttons do
		local button = buttons[i]
		if not button.bubg then
			B.StripTextures(button)

			button.bubg = B.CreateBDFrame(button, 0, 2)

			local LocBG = button.LocBG
			local RareOverlay = button.RareOverlay
			local Overlay = button.Overlay.Overlay
			if LocBG and RareOverlay and Overlay then
				LocBG:ClearAllPoints()
				LocBG:SetPoint("TOPLEFT", button.bubg, 1, 0)
				LocBG:SetPoint("BOTTOMRIGHT", button.bubg, -1, -2)

				for _, overlay in pairs {RareOverlay, Overlay} do
					overlay:SetDrawLayer("BACKGROUND")
					overlay:SetTexture(DB.bdTex)
					overlay:ClearAllPoints()
					overlay:SetPoint("TOPLEFT", LocBG, 0, -1)
					overlay:SetPoint("BOTTOMRIGHT", LocBG, 0, 3)
				end

				RareOverlay:SetVertexColor(.1, .5, .9, .25)
				Overlay:SetVertexColor(.1, .1, .1, .25)
			end

			if button.ButtonBG then
				button.ButtonBG:Hide()
			end

			if button.CompleteCheck then
				button.CompleteCheck:SetAtlas("Adventures-Checkmark")
			end

			if button.Level then
				local levelText = button.Level
				levelText:SetJustifyH("LEFT")
				levelText:ClearAllPoints()
				levelText:SetPoint("LEFT", button, 10, 0)
			end

			if button.RareText then
				local rareText = button.RareText
				rareText:SetJustifyH("LEFT")
				rareText:ClearAllPoints()
				rareText:SetPoint("LEFT", button, 85, 0)
			end

			if button.ItemLevel then
				local itemText = button.ItemLevel
				itemText:SetJustifyH("LEFT")
				itemText:ClearAllPoints()
				itemText:SetPoint("LEFT", button.Summary, "RIGHT", 8, 0)
			end
		end

		B.ReskinHighlight(button.Highlight, button.bubg, true)
	end
end

local function Update_FollowerQuality(self, followerInfo)
	if followerInfo and self.squareBG then
		local r, g, b = GetItemQualityColor(followerInfo.quality or 1)
		self.squareBG:SetBackdropBorderColor(r, g, b)
	end
end

local function Reskin_UpdateData(self)
	local followerFrame = self:GetParent()
	local scrollFrame = followerFrame.FollowerList.listScroll
	local buttons = scrollFrame.buttons
	if not buttons then return end

	for i = 1, #buttons do
		local button = buttons[i].Follower
		local portrait = button.PortraitFrame

		if not button.styled then
			B.StripTextures(button)

			local bubg = B.CreateBDFrame(button)
			B.ReskinHighlight(button, bubg, true)
			B.ReskinHighlight(button.Selection, bubg, true)
			button.BusyFrame:SetAllPoints(bubg)

			if portrait then
				S.ReskinFollowerPortrait(portrait)
				hooksecurefunc(portrait, "SetupPortrait", Update_FollowerQuality)
			end

			if button.Class then
				S.ReskinFollowerClass(button.Class, 40, "RIGHT", -9, 0)
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

		if portrait then
			portrait:ClearAllPoints()
			portrait:SetPoint("TOPLEFT", 4, 0)
		end

		if portrait.quality then
			S.UpdateFollowerQuality(portrait)
		end
	end
end

local function Reskin_ShowFollower(followerList)
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
				equip.icbg:SetBackdropColor(1, 1, 1, .5)
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

local function Reskin_CombatantStats(self, followerInfo)
	local autoSpellInfo = followerInfo.autoSpellAbilities
	for _ in pairs(autoSpellInfo) do
		local abilityFrame = self.autoSpellPool:Acquire()
		if not abilityFrame.styled then
			B.ReskinIcon(abilityFrame.Icon)

			if abilityFrame.IconMask then abilityFrame.IconMask:Hide() end
			if abilityFrame.SpellBorder then abilityFrame.SpellBorder:Hide() end

			abilityFrame.styled = true
		end
	end
end

local function Reskin_MissionFrame(self)
	B.ReskinFrame(self)
	B.ReskinFrameTab(self, 3)

	self.MissionCompleteBackground:SetAlpha(0)
	if self.RaisedBorder then self.RaisedBorder:Hide() end
	if self.ClassHallIcon then self.ClassHallIcon:Hide() end
	if self.OverlayElements then self.OverlayElements:Hide() end
	if self.MapTab then self.MapTab.ScrollContainer.Child.TiledBackground:Hide() end
	if self.TitleScroll then
		B.StripTextures(self.TitleScroll)
		B.ReskinText(select(4, self.TitleScroll:GetRegions()), 1, .8, 0)
	end

	Reskin_MissionComplete(self.MissionComplete)
	Reskin_MissionPage(self.MissionTab.MissionPage)

	local MissionList = self.MissionTab.MissionList
	Reskin_FollowerList(MissionList)
	Reskin_MissionTab(MissionList)
	Reskin_CompleteDialog(MissionList.CompleteDialog)
	hooksecurefunc(MissionList, "Update", Reskin_MissionList)

	local FollowerList = self.FollowerList
	Reskin_FollowerList(FollowerList)
	hooksecurefunc(FollowerList, "UpdateData", Reskin_UpdateData)
	hooksecurefunc(FollowerList, "ShowFollower", Reskin_ShowFollower)

	local FollowerTab = self.FollowerTab
	Reskin_FollowerTab(FollowerTab)
	hooksecurefunc(self.FollowerTab, "UpdateCombatantStats", Reskin_CombatantStats)

	for _, item in pairs {FollowerTab.ItemWeapon, FollowerTab.ItemArmor} do
		if item then
			B.StripTextures(item)
			B.ReskinIcon(item.Icon)
		end
	end
end

local function Reskin_AbilityIcon(self, anchor, yOffset)
	self:ClearAllPoints()
	self:SetPoint(anchor, self:GetParent().squareBG, "LEFT", -3, yOffset)
	self.Border:SetAlpha(0)
	self.CircleMask:Hide()
	B.ReskinIcon(self.Icon)
end

local function Update_FollowerQualityOnBorder(self, _, info)
	if self.squareBG then
		local r, g, b = GetItemQualityColor(info.quality or 1)
		self.squareBG:SetBackdropBorderColor(r, g, b)
	end
end

local function Reset_FollowerQualityOnBorder(self)
	if self.squareBG then
		self.squareBG:SetBackdropBorderColor(0, 0, 0)
	end
end

local function Reskin_FollowerBoard(self, group)
	for socketTexture in self[group.."SocketFramePool"]:EnumerateActive() do
		socketTexture:DisableDrawLayer("BACKGROUND") -- we need the bufficons
	end
	for frame in self[group.."FramePool"]:EnumerateActive() do
		if not frame.styled then
			S.ReskinFollowerPortrait(frame)
			frame.PuckShadow:SetAlpha(0)
			Reskin_AbilityIcon(frame.AbilityOne, "BOTTOMRIGHT", 1)
			Reskin_AbilityIcon(frame.AbilityTwo, "TOPRIGHT", -1)
			if frame.SetFollowerGUID then
				hooksecurefunc(frame, "SetFollowerGUID", Update_FollowerQualityOnBorder)
			end
			if frame.SetEmpty then
				hooksecurefunc(frame, "SetEmpty", Reset_FollowerQualityOnBorder)
			end

			frame.styled = true
		end
	end
end

local function Reskin_MissionBoard(self)
	Reskin_FollowerBoard(self, "enemy")
	Reskin_FollowerBoard(self, "follower")
end

--- Hook
local function Reskin_SetReward(frame)
	if frame and not frame.icbg then
		frame:GetRegions():Hide()
		frame.icbg = B.ReskinIcon(frame.Icon)
		frame.icbg:SetFrameLevel(frame:GetFrameLevel())
		B.ReskinBorder(frame.IconBorder, frame.icbg, nil, true)

		if frame.BG then frame.BG:SetAlpha(0) end
	end
end

local function Reskin_FollowerButtonAddAbility(self, index)
	local ability = self.Abilities[index]
	if ability and not ability.styled then
		ability.Icon:SetSize(19, 19)
		B.ReskinIcon(ability.Icon)

		ability.styled = true
	end
end

local function Reskin_FollowerButtonSetCounterButton(button, _, index)
	local counter = button.Counters[index]
	if counter and not counter.styled then
		B.ReskinIcon(counter.Icon)

		counter.styled = true
	end
end

local function Reskin_MissonListTabSetSelected(tab, isSelected)
	if isSelected then
		tab.bg:SetBackdropColor(cr, cg, cb, .5)
	else
		tab.bg:SetBackdropColor(0, 0, 0, 0)
	end
end

local function Reskin_MissionPortraitSetFollowerPortrait(portraitFrame, followerInfo)
	if not portraitFrame.styled then
		S.ReskinFollowerPortrait(portraitFrame)

		portraitFrame.styled = true
	end

	local r, g, b = GetItemQualityColor(followerInfo.quality or 1)
	portraitFrame.squareBG:SetBackdropBorderColor(r, g, b)
	portraitFrame.squareBG:Show()
end

local function Reskin_MissionSetEnemies(_, missionPage, enemies)
	for i = 1, #enemies do
		local enemy = missionPage.Enemies[i]
		if enemy:IsShown() and not enemy.styled then
			for j = 1, #enemy.Mechanics do
				local mechanic = enemy.Mechanics[j]
				B.ReskinIcon(mechanic.Icon)
			end

			enemy.styled = true
		end
	end
end

local function Reskin_MissionShowMission(self)
	local envIcon = self:GetMissionPage().Stage.MissionEnvIcon
	if envIcon.icbg then
		envIcon.icbg:SetShown(envIcon.Texture:GetTexture())
	end
end

local function Reskin_MissionUpdateMissionData(_, missionPage)
	local buffsFrame = missionPage.BuffsFrame
	if buffsFrame and buffsFrame:IsShown() then
		buffsFrame.BuffsBG:Hide()
		for i = 1, #buffsFrame.Buffs do
			local buff = buffsFrame.Buffs[i]
			if not buff.styled then
				B.ReskinIcon(buff.Icon)

				buff.styled = true
			end
		end
	end
end

local function Reskin_MissionUpdateMissionParty(_, followers)
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
end

local function Reskin_MissionRemoveFollowerFromMission(_, frame)
	local portrait = frame.PortraitFrame
	if portrait and portrait.squareBG then
		portrait.squareBG:Hide()
	end
end

local function Reskin_MissionCompleteInitialize(self, missionList, index)
	local mission = missionList[index]
	if not mission then return end

	for i = 1, #mission.followers do
		local follower = self.MissionComplete.Stage.FollowersFrame.Followers[i]
		local portrait = follower.PortraitFrame
		if portrait then
			if not follower.bg then
				portrait:ClearAllPoints()
				portrait:SetPoint("TOPLEFT", 0, -10)
				S.ReskinFollowerPortrait(portrait)

				local oldBg = follower:GetRegions()
				oldBg:Hide()
				follower.bg = B.CreateBDFrame(oldBg)
				follower.bg:SetPoint("TOPLEFT", portrait, -1, 1)
				follower.bg:SetPoint("BOTTOMRIGHT", -10, 8)
			end

			local quality = select(4, C_Garrison.GetFollowerMissionCompleteInfo(mission.followers[i]))
			if quality then
				local r, g, b = GetItemQualityColor(quality or 1)
				portrait.squareBG:SetBackdropBorderColor(r, g, b)
				portrait.squareBG:Show()
			end
		end
	end
end

local function Reskin_BuildingListSelectTab(tab)
	local BuildingList = GarrisonBuildingFrame.BuildingList

	for i = 1, GARRISON_NUM_BUILDING_SIZES do
		local otherTab = BuildingList["Tab"..i]
		if i ~= tab:GetID() then
			otherTab.bg:SetBackdropColor(0, 0, 0, 0)
		end
	end
	tab.bg:SetBackdropColor(cr, cg, cb, .5)

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
end

local function Reskin_BuildingInfoBoxShowFollowerPortrait(_, _, infoBox)
	local portrait = infoBox.FollowerPortrait
	if portrait:IsShown() then
		portrait.squareBG:SetBackdropBorderColor(portrait.PortraitRing:GetVertexColor())
	end
end

local function Reskin_RecruitSelectFrameUpdateRecruits(waiting)
	if waiting then return end

	for i = 1, 3 do
		local recruit = FollowerSelection["Recruit"..i]
		local portrait = recruit.PortraitFrame
		portrait.squareBG:SetBackdropBorderColor(portrait.LevelBorder:GetVertexColor())

		if recruit:IsShown() then
			local traits = recruit.Traits.Entries
			if traits then
				for index = 1, #traits do
					local trait = traits[index]
					if not trait.icbg then
						trait.icbg = B.ReskinIcon(trait.Icon)
					end
				end
			end
			local abilities = recruit.Abilities.Entries
			if abilities then
				for index = 1, #abilities do
					local ability = abilities[index]
					if not ability.icbg then
						ability.icbg = B.ReskinIcon(ability.Icon)
					end
				end
			end
		end
	end
end

local function Reskin_CapacitiveDisplayFrameUpdate(self)
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
end

local function Reskin_SetupTabs(self)
	self.MapTab:SetShown(not self.Tab2:IsShown())
end

local function Reskin_LandingPageReport(self)
	local unselectedTab = GarrisonLandingPage.Report.unselectedTab
	B.CleanTextures(unselectedTab)
	unselectedTab:SetHeight(36)
	unselectedTab.selectedTex:Hide()

	B.CleanTextures(self)
	self.selectedTex:Show()
end

-- Blizzard didn't set color for currency reward, incorrect color presents after scroll
local function Update_CurrencyRewardBorder(self)
	local reward = self:GetParent()
	if reward and not reward.itemID then
		reward.icbg:SetBackdropBorderColor(0, 0, 0)
	end
end

local function Reskin_OrderHallMissionFrame()
	local portrait = OrderHallMissionFrameMissions.CombatAllyUI.InProgress.PortraitFrame
	if portrait:IsShown() then
		S.UpdateFollowerQuality(portrait)
	end

	CombatAllyUI.Available.AddFollowerButton.EmptyPortrait:SetAlpha(0)
	CombatAllyUI.Available.AddFollowerButton.PortraitHighlight:SetAlpha(0)
end

local function Update_HealthValueWidth(self, missionPage)
	missionPage.Board.AllyHealthValue:SetWidth(70)
	missionPage.Stage.EnemyHealthValue:SetWidth(70)
end

C.LUAThemes["Blizzard_GarrisonUI"] = function()
	GARRISON_FOLLOWER_ITEM_LEVEL = "iLvl %d"

	hooksecurefunc("GarrisonFollowerButton_AddAbility", Reskin_FollowerButtonAddAbility)
	hooksecurefunc("GarrisonFollowerButton_SetCounterButton", Reskin_FollowerButtonSetCounterButton)
	hooksecurefunc("GarrisonMissionButton_SetReward", Reskin_SetReward)
	hooksecurefunc("GarrisonMissionPage_SetReward", Reskin_SetReward)
	hooksecurefunc("GarrisonMissionPortrait_SetFollowerPortrait", Reskin_MissionPortraitSetFollowerPortrait)
	hooksecurefunc("GarrisonMissonListTab_SetSelected", Reskin_MissonListTabSetSelected)

	hooksecurefunc(GarrisonMission, "MissionCompleteInitialize", Reskin_MissionCompleteInitialize)
	hooksecurefunc(GarrisonMission, "RemoveFollowerFromMission", Reskin_MissionRemoveFollowerFromMission)
	hooksecurefunc(GarrisonMission, "SetEnemies", Reskin_MissionSetEnemies)
	hooksecurefunc(GarrisonMission, "ShowMission", Reskin_MissionShowMission)
	hooksecurefunc(GarrisonMission, "UpdateMissionData", Reskin_MissionUpdateMissionData)
	hooksecurefunc(GarrisonMission, "UpdateMissionParty", Reskin_MissionUpdateMissionParty)

	-- [[GarrisonLandingPage]]
	local GarrisonLandingPage = GarrisonLandingPage
	B.ReskinFrame(GarrisonLandingPage)
	B.ReskinFrameTab(GarrisonLandingPage, 3)
	Reskin_FollowerList(GarrisonLandingPage.FollowerList)
	Reskin_FollowerTab(GarrisonLandingPage.FollowerTab)
	Reskin_FollowerList(GarrisonLandingPage.ShipFollowerList)
	Reskin_FollowerTab(GarrisonLandingPage.ShipFollowerTab, true)

	hooksecurefunc(GarrisonLandingPage.FollowerTab, "UpdateCombatantStats", Reskin_CombatantStats)
	hooksecurefunc(GarrisonLandingPageFollowerList, "UpdateData", Reskin_UpdateData)
	hooksecurefunc(GarrisonLandingPageFollowerList, "ShowFollower", Reskin_ShowFollower)

	-- Report
	local Report = GarrisonLandingPage.Report
	B.StripTextures(Report, 0)
	B.StripTextures(Report.List)

	for _, tab in pairs {Report.InProgress, Report.Available} do
		B.CleanTextures(tab)
		tab.Text:ClearAllPoints()
		tab.Text:SetPoint("CENTER")

		local bg = B.CreateBDFrame(tab)
		local selectedTex = bg:CreateTexture(nil, "BACKGROUND")
		selectedTex:SetAllPoints()
		selectedTex:SetColorTexture(cr, cg, cb, .5)
		selectedTex:Hide()
		tab.selectedTex = selectedTex
	end

	hooksecurefunc("GarrisonLandingPageReport_SetTab", Reskin_LandingPageReport)

	local scrollFrame = Report.List.listScroll
	B.ReskinScroll(scrollFrame.scrollBar)

	local buttons = scrollFrame.buttons
	for i = 1, #buttons do
		local button = buttons[i]
		button.BG:Hide()
		B.CreateBDFrame(button, 0, 1)

		for _, reward in pairs(button.Rewards) do
			reward:GetRegions():Hide()
			reward:ClearAllPoints()
			reward:SetPoint("TOPRIGHT", -5, -4.5)

			reward.icbg = B.ReskinIcon(reward.Icon)
			B.ReskinBorder(reward.IconBorder, reward.icbg)
			hooksecurefunc(reward.Icon, "SetTexture", Update_CurrencyRewardBorder)
		end
	end

	-- [[BFAMissionFrame]]
	local BFAMissionFrame = BFAMissionFrame
	Reskin_MissionFrame(BFAMissionFrame)

	-- [[OrderHallMissionFrame]]
	local OrderHallMissionFrame = OrderHallMissionFrame
	Reskin_MissionFrame(OrderHallMissionFrame)

	-- CombatAllyUI
	local CombatAllyUI = OrderHallMissionFrameMissions.CombatAllyUI
	B.StripTextures(CombatAllyUI)
	B.CreateBDFrame(CombatAllyUI)
	B.ReskinButton(CombatAllyUI.InProgress.Unassign)
	B.ReskinIcon(CombatAllyUI.InProgress.CombatAllySpell.iconTexture)

	local PortraitFrame = CombatAllyUI.InProgress.PortraitFrame
	S.ReskinFollowerPortrait(PortraitFrame)
	OrderHallMissionFrame:HookScript("OnShow", Reskin_OrderHallMissionFrame)

	-- ZoneSupportMissionPage
	local ZoneSupportMissionPage = OrderHallMissionFrame.MissionTab.ZoneSupportMissionPage
	B.ReskinButton(ZoneSupportMissionPage.StartMissionButton)
	B.ReskinIcon(ZoneSupportMissionPage.CombatAllySpell.iconTexture)
	B.ReskinIcon(ZoneSupportMissionPage.CostFrame.CostIcon)

	local bg = B.ReskinFrame(ZoneSupportMissionPage)
	bg:SetFrameLevel(OrderHallMissionFrame.MissionTab:GetFrameLevel()+1)

	local Follower1 = ZoneSupportMissionPage.Follower1
	B.StripTextures(Follower1)
	B.CreateBDFrame(Follower1)
	S.ReskinFollowerPortrait(Follower1.PortraitFrame)
	S.ReskinFollowerClass(Follower1.Class, 40, "RIGHT", -10, 0)
	Follower1.PortraitFrame:ClearAllPoints()
	Follower1.PortraitFrame:SetPoint("TOPLEFT", 3, -3)

	-- [[GarrisonMissionFrame]]
	local GarrisonMissionFrame = GarrisonMissionFrame
	Reskin_MissionFrame(GarrisonMissionFrame)

	-- [[GarrisonShipyardFrame]]
	local GarrisonShipyardFrame = GarrisonShipyardFrame
	GarrisonShipyardFrame.MissionCompleteBackground:SetAlpha(0)

	local shipyardBG = B.ReskinFrame(GarrisonShipyardFrame)
	B.ReskinFrameTab(GarrisonShipyardFrame, 2)
	Reskin_FollowerList(GarrisonShipyardFrame.FollowerList)
	Reskin_FollowerTab(GarrisonShipyardFrame.FollowerTab, true)
	Reskin_MissionPage(GarrisonShipyardFrame.MissionTab.MissionPage, true)
	Reskin_MissionComplete(GarrisonShipyardFrame.MissionComplete)

	-- BorderFrame
	local BorderFrame = GarrisonShipyardFrame.BorderFrame
	B.StripTextures(BorderFrame)
	B.ReskinClose(BorderFrame.CloseButton2)

	-- MissionList
	local MissionList = GarrisonShipyardFrame.MissionTab.MissionList
	Reskin_CompleteDialog(MissionList.CompleteDialog)
	MissionList.MapTexture:SetInside(shipyardBG)

	-- [[GarrisonBuildingFrame]]
	local GarrisonBuildingFrame = GarrisonBuildingFrame
	B.ReskinFrame(GarrisonBuildingFrame)
	B.ReskinText(GarrisonBuildingFrame.MapFrame.TownHall.TownHallName, 1, .8, 0)

	-- MainHelpButton
	local MainHelpButton = GarrisonBuildingFrame.MainHelpButton
	MainHelpButton.Ring:Hide()
	MainHelpButton:ClearAllPoints()
	MainHelpButton:SetPoint("TOPLEFT", GarrisonBuildingFrame, "TOPLEFT", -12, 12)

	-- BuildingList
	local BuildingList = GarrisonBuildingFrame.BuildingList
	B.StripTextures(BuildingList)
	Reskin_MaterialFrame(BuildingList.MaterialFrame)

	for i = 1, GARRISON_NUM_BUILDING_SIZES do
		local tab = BuildingList["Tab"..i]
		B.StripTextures(tab, 0)

		local bg = B.CreateBGFrame(tab, 6, -7, -6, 7)
		tab.bg = bg
	end

	hooksecurefunc("GarrisonBuildingList_SelectTab", Reskin_BuildingListSelectTab)

	-- Followers
	local Followers = GarrisonBuildingFrameFollowers
	Followers:ClearAllPoints()
	Followers:SetPoint("BOTTOMLEFT", 20, 34)

	-- FollowerList
	local FollowerList = GarrisonBuildingFrame.FollowerList
	Reskin_FollowerList(FollowerList)
	hooksecurefunc(FollowerList, "UpdateData", Reskin_UpdateData)
	hooksecurefunc(FollowerList, "ShowFollower", Reskin_ShowFollower)

	-- InfoBox and TownHallBox
	for _, boxs in pairs {"TownHallBox", "InfoBox"} do
		local box = GarrisonBuildingFrame[boxs]
		B.StripTextures(box)
		B.CreateBDFrame(box)
		B.ReskinButton(box.UpgradeButton)
	end

	local InfoBox = GarrisonBuildingFrame.InfoBox
	InfoBox.AddFollowerButton.EmptyPortrait:SetAlpha(0)
	InfoBox.AddFollowerButton.PortraitHighlight:SetAlpha(0)

	local FollowerPortrait = InfoBox.FollowerPortrait
	S.ReskinFollowerPortrait(FollowerPortrait)

	FollowerPortrait:ClearAllPoints()
	FollowerPortrait:SetPoint("BOTTOMLEFT", InfoBox.DragArea, "BOTTOMRIGHT", 10, 0)
	FollowerPortrait.FollowerName:ClearAllPoints()
	FollowerPortrait.FollowerName:SetPoint("BOTTOMLEFT", FollowerPortrait, "RIGHT", 4, 4)
	FollowerPortrait.FollowerStatus:ClearAllPoints()
	FollowerPortrait.FollowerStatus:SetPoint("TOPLEFT", FollowerPortrait, "RIGHT", 4, 4)
	FollowerPortrait.RemoveFollowerButton:ClearAllPoints()
	FollowerPortrait.RemoveFollowerButton:SetPoint("TOPRIGHT", 4, 4)

	hooksecurefunc("GarrisonBuildingInfoBox_ShowFollowerPortrait", Reskin_BuildingInfoBoxShowFollowerPortrait)

	-- Confirmation
	local Confirmation = GarrisonBuildingFrame.Confirmation
	B.ReskinFrame(Confirmation)

	for _, buttons in pairs {"CancelButton", "BuildButton", "UpgradeButton", "UpgradeGarrisonButton", "ReplaceButton", "SwitchButton"} do
		local button = Confirmation[buttons]
		B.ReskinButton(button)
	end

	-- [[GarrisonMonumentFrame]]
	local GarrisonMonumentFrame = GarrisonMonumentFrame
	B.ReskinFrame(GarrisonMonumentFrame)

	local LeftBtn = GarrisonMonumentFrame.LeftBtn
	B.ReskinArrow(LeftBtn, "left")
	LeftBtn:SetSize(36, 36)
	local RightBtn = GarrisonMonumentFrame.RightBtn
	B.ReskinArrow(RightBtn, "right")
	RightBtn:SetSize(36, 36)

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
	Reskin_FollowerList(FollowerList)
	hooksecurefunc(FollowerList, "UpdateData", Reskin_UpdateData)
	hooksecurefunc(FollowerList, "ShowFollower", Reskin_ShowFollower)

	-- FollowerSelection
	local FollowerSelection = GarrisonRecruitSelectFrame.FollowerSelection
	B.StripTextures(FollowerSelection)

	for i = 1, 3 do
		local Recruit = FollowerSelection["Recruit"..i]
		local bg = B.CreateBDFrame(Recruit, 0, 1)

		S.ReskinFollowerPortrait(Recruit.PortraitFrame)
		B.ReskinButton(Recruit.HireRecruits)
		S.ReskinFollowerClass(Recruit.Class, 40, "TOPRIGHT", -8, -8, bg)

		Recruit.PortraitFrame:ClearAllPoints()
		Recruit.PortraitFrame:SetPoint("TOPLEFT", bg, 4, -4)

		local Counter = Recruit.Counter
		Counter:ClearAllPoints()
		Counter:SetPoint("CENTER", bg, "TOP", 0, 0)
	end

	hooksecurefunc("GarrisonRecruitSelectFrame_UpdateRecruits", Reskin_RecruitSelectFrameUpdateRecruits)

	-- [[GarrisonCapacitiveDisplayFrame]]
	local GarrisonCapacitiveDisplayFrame = GarrisonCapacitiveDisplayFrame
	B.ReskinFrame(GarrisonCapacitiveDisplayFrame)
	B.ReskinButton(GarrisonCapacitiveDisplayFrame.StartWorkOrderButton)
	B.ReskinButton(GarrisonCapacitiveDisplayFrame.CreateAllWorkOrdersButton)
	B.ReskinArrow(GarrisonCapacitiveDisplayFrame.DecrementButton, "left")
	B.ReskinArrow(GarrisonCapacitiveDisplayFrame.IncrementButton, "right")
	B.CreateBDFrame(GarrisonCapacitiveDisplayFrame.Count)

	-- CapacitiveDisplay
	local CapacitiveDisplay = GarrisonCapacitiveDisplayFrame.CapacitiveDisplay
	CapacitiveDisplay.IconBG:Hide()

	local icbg = B.ReskinIcon(CapacitiveDisplay.ShipmentIconFrame.Icon)
	B.CreateBGFrame(CapacitiveDisplay.IconBG, 2, 0, 0, 0, icbg)

	local Follower = CapacitiveDisplay.ShipmentIconFrame.Follower
	S.ReskinFollowerPortrait(Follower)
	Follower:ClearAllPoints()
	Follower:SetPoint("CENTER", icbg, 0, -3.5)

	hooksecurefunc("GarrisonCapacitiveDisplayFrame_Update", Reskin_CapacitiveDisplayFrameUpdate)

	-- [[CovenantMissionFrame]]
	local CovenantMissionFrame = CovenantMissionFrame
	Reskin_MissionFrame(CovenantMissionFrame)
	CovenantMissionFrameMissions.RaisedFrameEdges:SetAlpha(0)
	hooksecurefunc(CovenantMissionFrame, "SetupTabs", Reskin_SetupTabs)
	hooksecurefunc(CovenantMissionFrame, "UpdateEnemyPower", Update_HealthValueWidth)
	hooksecurefunc(CovenantMissionFrame, "UpdateAllyPower", Update_HealthValueWidth)

	B.StripTextures(CombatLog)
	B.StripTextures(CombatLog.ElevatedFrame)
	B.StripTextures(CombatLog.CombatLogMessageFrame)
	B.CreateBDFrame(CombatLog.CombatLogMessageFrame)
	B.ReskinScroll(CombatLog.CombatLogMessageFrame.ScrollBar)

	B.ReskinButton(HealFollowerButtonTemplate)

	local FollowerTab = CovenantMissionFrame.FollowerTab
	B.StripTextures(FollowerTab)
	B.CreateBGFrame(FollowerTab, 3, 2, -3, -10)

	B.StripTextures(FollowerTab.RaisedFrameEdges)
	B.StripTextures(FollowerTab.HealFollowerFrame)
	B.ReskinIcon(FollowerTab.HealFollowerFrame.CostFrame.CostIcon)

	CovenantMissionFrameFollowers.ElevatedFrame:SetAlpha(0)
	B.ReskinButton(CovenantMissionFrameFollowers.HealAllButton)

	CovenantMissionFrame.MissionTab.MissionPage.Board:HookScript("OnShow", Reskin_MissionBoard)
	CovenantMissionFrame.MissionComplete.Board:HookScript("OnShow", Reskin_MissionBoard)

	-- Addon supports
	local function Reskin_OnUpdate(self)
		local buttons = self.listScroll.buttons
		for i = 1, #buttons do
			local button = select(3, buttons[i]:GetChildren())
			if button and button:IsObjectType("Button") and not button.styled then
				B.ReskinButton(button)
				button:SetSize(60, 45)

				button.styled = true
			end
		end
	end

	local function Reskin_OnShow(self)
		for i = 18, 27 do
			local button = select(i, self:GetChildren())
			if button and button:IsObjectType("Button") and not button.styled then
				B.ReskinButton(button)
				button:SetSize(50, 45)

				button.styled = true
			end
		end
	end

	local function Reskin_OnEvent(event, addon)
		if addon == "GarrisonMissionManager" then
			for _, frame in pairs {GarrisonMissionFrame, OrderHallMissionFrame, BFAMissionFrame} do
				if frame then
					hooksecurefunc(frame.MissionTab.MissionList, "Update", Reskin_OnUpdate)
					frame.MissionTab.MissionPage:HookScript("OnShow", Reskin_OnShow)
				end
			end

			B:UnregisterEvent(event)
		end
	end

	B:RegisterEvent("ADDON_LOADED", Reskin_OnEvent)

	-- WarPlan
	if IsAddOnLoaded("WarPlan") then
		local function Reskin_WarPlan(self)
			B.StripTextures(self.TaskBoard.List)

			local Missions = self.TaskBoard.Missions
			for i = 1, #Missions do
				local button = Missions[i]
				if not button.styled then
					B.ReskinText(button.XPReward, 0, 1, 1)
					B.ReskinText(button.Description, 1, 1, 1)
					B.ReskinText(button.CDTDisplay, 1, 1, 0)

					local Groups = button.Groups
					if Groups then
						for j = 1, #Groups do
							local group = Groups[j]
							B.ReskinButton(group)
							B.ReskinText(group.Features, 0, 1, 0)
						end
					end

					local Rewards = button.Rewards
					if Rewards then
						for j = 1, #Rewards do
							local reward = Rewards[j]
							reward.RarityBorder:Hide()
							reward.Quantity:SetJustifyH("RIGHT")
							reward.Quantity:ClearAllPoints()
							reward.Quantity:SetPoint("BOTTOMRIGHT", reward, "BOTTOMRIGHT", -1, 1)

							local r, g, b = 1, 1, 1
							if reward.currencyID then
								if reward.currencyID == 0 then
									r, g, b = 1, 1, 0
								else
									local ci_1 = C_CurrencyInfo.GetCurrencyContainerInfo(reward.currencyID, reward.quantity or 1)
									r, g, b = GetItemQualityColor(ci_1.quality or 1)
								end
							elseif reward.itemID then
								local itemQuality = select(3,GetItemInfo(reward.itemLink or reward.itemID))
								r, g, b = GetItemQualityColor(itemQuality or 1)
							end

							if reward.Icon then
								if not reward.icbg then
									reward.icbg = B.ReskinIcon(reward.Icon)
								end

								reward.icbg:SetBackdropBorderColor(r, g, b)
							end
						end
					end

					button.styled = true
				end
			end
		end

		C_Timer.After(.1, function()
			local WarPlanFrame = _G.WarPlanFrame
			if not WarPlanFrame then return end

			B.ReskinFrame(WarPlanFrame)

			local ArtFrame = WarPlanFrame.ArtFrame
			B.StripTextures(ArtFrame)
			B.ReskinClose(ArtFrame.CloseButton)
			B.ReskinText(ArtFrame.TitleText, 1, .8, 0)

			Reskin_WarPlan(WarPlanFrame)
			WarPlanFrame:HookScript("OnShow", Reskin_WarPlan)
			B.ReskinButton(WarPlanFrame.TaskBoard.AllPurposeButton)

			local Entries = WarPlanFrame.HistoryFrame.Entries
			for i = 1, #Entries do
				local entry = Entries[i]
				entry:DisableDrawLayer("BACKGROUND")
				entry.Name:SetFontObject("Number12Font")
				entry.Detail:SetFontObject("Number12Font")

				B.ReskinIcon(entry.Icon)
			end
		end)
	end

	-- VenturePlan
	if IsAddOnLoaded("VenturePlan") then
		local function Reskin_RewardFrame(self, rew)
			if not rew then return end

			if not self.styled then
				self.RarityBorder:Hide()

				self.Quantity:SetJustifyH("RIGHT")
				self.Quantity:ClearAllPoints()
				self.Quantity:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", -1, 1)

				self.styled = true
			end

			local r, g, b = 1, 1, 1
			if rew == "xp" then
				r, g, b = 1, 0, 1	-- 基础经验
			elseif rew.followerXP then
				r, g, b = 0, 1, 0	-- 奖励经验
			elseif rew.currencyID then
				if rew.currencyID == 0 then
					r, g, b = 1, 1, 0	-- 金币奖励
				else
					local ci_1 = C_CurrencyInfo.GetCurrencyContainerInfo(rew.currencyID, rew.quantity)	-- 声望奖章
					local ci_2 = C_CurrencyInfo.GetCurrencyInfo(rew.currencyID)	-- 其他货币
					r, g, b = GetItemQualityColor((ci_1 and ci_1.quality) or (ci_2 and ci_2.quality))
				end
			elseif rew.itemID then
				if C_Item.IsAnimaItemByID(rew.itemID) then
					self.Icon:SetTexture(3528288)

					local mult = B.GetAnimaMultiplier(rew.itemID)
					if mult then
						local total = rew.quantity * mult
						self.Quantity:SetText(total)
					end
				else
					local itemSolt = B.GetItemSlot(rew.itemLink or rew.itemID)
					self.Quantity:SetText(itemSolt or "")
				end

				local itemQuality = select(3,GetItemInfo(rew.itemLink or rew.itemID))
				r, g, b = GetItemQualityColor(itemQuality or 1)
			end

			if self.Icon then
				if not self.icbg then
					self.icbg = B.ReskinIcon(self.Icon)
				end

				self.icbg:SetBackdropBorderColor(r, g, b)
			end
		end

		function VPEX_OnUIObjectCreated(otype, widget, peek)
			if widget:IsObjectType("Frame") then
				if otype == "CopyBoxUI" then
					B.ReskinButton(widget.ResetButton)
					B.ReskinClose(widget.CloseButton2, nil, -12, -12)
					B.ReskinInput(widget.FirstInputBox)
					B.ReskinInput(widget.SecondInputBox)
					B.ReskinText(widget.Intro, 1, 1, 1)
					B.ReskinText(widget.FirstInputBoxLabel, 1, .8, 0)
					B.ReskinText(widget.SecondInputBoxLabel, 1, .8, 0)
					B.ReskinText(widget.VersionText, 1, 1, 1)
				elseif otype == "FollowerList" then
					B.StripTextures(widget)
					B.CreateBDFrame(widget)
				elseif otype == "FollowerListButton" then
					peek("TextLabel"):SetFontObject("Game12Font")
				elseif otype == "IconButton" then
					local icbg = B.ReskinIcon(widget:GetNormalTexture())
					B.ReskinHighlight(widget, icbg)
					B.ReskinPushed(widget, icbg)
					widget.Icon:SetTexCoord(tL, tR, tT, tB)
				elseif otype == "ILButton" then
					widget:DisableDrawLayer("BACKGROUND")
					B.CreateBGFrame(widget, -4, 2, 2, -2)
					B.ReskinIcon(widget.Icon)
				elseif otype == "MissionButton" then
					B.ReskinText(peek("Description"), 1, 1, 1)
					B.ReskinText(peek("enemyHP"), 0, 1, 0)
					B.ReskinText(peek("enemyATK"), 0, 1, 0)
					B.ReskinText(peek("animaCost"), 0, 1, 0)
					B.ReskinText(peek("duration"), 1, 1, 0)
					B.ReskinText(widget.CDTDisplay:GetFontString(), 1, 1, 0)

					local ViewButton = peek("ViewButton")
					B.ReskinButton(ViewButton)
					local DoomRunButton = peek("DoomRunButton")
					B.ReskinButton(DoomRunButton)
					DoomRunButton:SetSize(24, 24)
					DoomRunButton:ClearAllPoints()
					DoomRunButton:SetPoint("RIGHT", ViewButton, "LEFT", -1, 0)
					local TentativeClear = peek("TentativeClear")
					B.ReskinButton(TentativeClear)
					TentativeClear:SetSize(24, 24)
					TentativeClear:ClearAllPoints()
					TentativeClear:SetPoint("RIGHT", ViewButton, "LEFT", -1, 0)
				elseif otype == "MissionList" then
					B.StripTextures(widget)
					local background = widget:GetChildren()
					B.StripTextures(background)
				elseif otype == "MissionPage" then
					B.StripTextures(widget)
					B.ReskinButton(peek("UnButton"))
				elseif otype == "MissionToast" then
					widget.Background:Hide()
					widget.Detail:SetFontObject("Game13Font")
					B.CreateBG(widget)
				elseif otype == "ProgressBar" then
					B.StripTextures(widget)
					B.CreateBDFrame(widget, 0, -C.mult)
				elseif otype == "RewardFrame" then
					hooksecurefunc(widget, "SetReward", Reskin_RewardFrame)
				end
			end
		end
	end

	-- CovenantMissionHelper
	if IsAddOnLoaded("CovenantMissionHelper") then
		for i = 1, 2 do
			local tab = _G["MissionHelperTab"..i]
			B.StripTextures(tab)
			tab.bg = B.CreateBGFrame(tab, 3, 0, -3, 0)
		end
		MissionHelperTab2:ClearAllPoints()
		MissionHelperTab2:SetPoint("LEFT", MissionHelperTab1.bg, "RIGHT", 0, 0)

		local frame = MissionHelperFrame
		frame:ClearAllPoints()
		frame:SetPoint("LEFT", CovenantMissionFrame, "RIGHT", 3, 0)

		B.ReskinFrame(frame)
		B.StripTextures(frame.RaisedFrameEdges)
		B.StripTextures(frame.resultHeader)
		B.StripTextures(frame.missionHeader)
		B.CreateBDFrame(frame.missionHeader)

		local resultInfo = frame.resultInfo
		B.StripTextures(resultInfo)
		B.StripTextures(resultInfo.RaisedFrameEdges)
		B.CreateBDFrame(resultInfo)

		local combatLogFrame = frame.combatLogFrame
		B.StripTextures(combatLogFrame)
		B.StripTextures(combatLogFrame.RaisedFrameEdges)
		B.CreateBDFrame(combatLogFrame)
		B.ReskinScroll(combatLogFrame.scrollBar)

		local buttonsFrame = frame.buttonsFrame
		B.StripTextures(buttonsFrame)
		B.ReskinButton(buttonsFrame.BestDispositionButton)
		B.ReskinButton(buttonsFrame.predictButton)
	end

	-- MissionReports
	if IsAddOnLoaded("MissionReports") then
		for index = 11, 14 do
			local tab = select(index, GarrisonLandingPage:GetChildren())
			if tab and not tab.styled then
				B.ReskinSideTab(tab)

				tab:ClearAllPoints()
				if index == 11 then
					tab:SetPoint("TOPLEFT", GarrisonLandingPage, "TOPRIGHT", 2, -25)
				else
					tab:SetPoint("TOP", select((index-1), GarrisonLandingPage:GetChildren()), "BOTTOM", 0, -25)
				end

				tab.styled = true
			end
		end
	end
end

local function Reskin_OrderHallTalentFrame(self)
	B.StripTextures(self)

	if self.CurrencyBG then self.CurrencyBG:SetAlpha(0) end

	for _, button in pairs {self:GetChildren()} do
		if button and button.talent then
			button.Border:SetAlpha(0)

			if not button.icbg then
				button.icbg = B.ReskinIcon(button.Icon)
				B.ReskinHighlight(button.Highlight, button.icbg)
			end

			if button.talent.selected then
				button.icbg:SetBackdropBorderColor(cr, cg, cb)
			else
				button.icbg:SetBackdropBorderColor(0, 0, 0)
			end
		end
	end
end

C.LUAThemes["Blizzard_OrderHallUI"] = function()
	OrderHallTalentFrame.OverlayElements:Hide()

	B.ReskinFrame(OrderHallTalentFrame)
	B.ReskinIcon(OrderHallTalentFrame.Currency.Icon)
	B.ReskinButton(OrderHallTalentFrame.BackButton)

	hooksecurefunc(OrderHallTalentFrame, "RefreshAllData", Reskin_OrderHallTalentFrame)
end