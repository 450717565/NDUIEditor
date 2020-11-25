local ADDON, T = ...
local EV, Nine, W, L, CreateObject = T.Evie, T.Nine or _G, T.WrappedAPI, T.L, T.CreateObject
local C = Nine.C_Garrison

local manualMemberSet, manualMemberCount = {}, 0
local function toggleFollowerFocus(followerID, removeOnly, audible)
	if manualMemberSet[followerID] then
		manualMemberCount, manualMemberSet[followerID] = manualMemberCount - 1
		if audible then
			PlaySound(43938)
		end
	elseif followerID and manualMemberCount < 3 and not removeOnly then
		manualMemberCount, manualMemberSet[followerID] = manualMemberCount+1, 1
		if audible then
			PlaySound(43938)
		end
	else
		return
	end
	local TaskBoard = WarPlanFrame.TaskBoard
	for j=1,2 do
		local a = j == 1 and TaskBoard.Champions or TaskBoard.Troops.Units
		for i=1,#a do
			local w = a[i]
			local fid = w.followerID
			w.Highlight3:SetShown(manualMemberSet[fid])
		end
	end
	return true
end
function EV:I_TOGGLE_FOLLOWER_FOCUS(followerID, removeOnly)
	if toggleFollowerFocus(followerID, removeOnly, true) then
		EV("I_UPDATE_MISSION_SUGGESTIONS")
	end
end
local function manualGroupFilter(g)
	if manualMemberCount == 0 then
		return true
	end
	local f1, f2, f3 = W.GetGroupMembers(g)
	local n = (manualMemberSet[f1] and 1 or 0)
	        + (manualMemberSet[f2] and 1 or 0)
	        + (manualMemberSet[f3] and 1 or 0)
	return n == manualMemberCount
end
local function GetManualGroupFilter()
	return manualMemberCount > 0 and manualGroupFilter or nil
end
local function IsFollowerInFocusGroup(fid)
	return not not manualMemberSet[fid]
end

local function ConfigureAbilityButton(w, id, isSpecialization, isLocked)
	if id == 0 or not id or not w then
		return 0
	end
	w.abilityID = id
	local isEquipment = C.GetFollowerAbilityIsTrait(id)
	w.Icon:SetTexture(C.GetFollowerAbilityIcon(id))
	w.SpecBorder:SetShown(isSpecialization)
	w:SetEquipment(isEquipment, isLocked, id)
	w.ThreatBorder:SetShown(not (isSpecialization or isEquipment))
	w.LockIcon:SetShown(isLocked)
	w:Show()
	return 1
end
local function ConfigureReward(w, rew, isOvermax, pw)
	w:SetShown(not not rew)
	if not rew then
		return
	end
	local q, tooltipTitle, tooltipText, cq = rew.quantity, rew.title
	if rew.icon then
		w.Icon:SetTexture(rew.icon)
	elseif rew.itemID then
		w.Icon:SetTexture(GetItemIcon(rew.itemID))
	end
	if rew.currencyID then
		w.RarityBorder:SetAtlas("loottoast-itemborder-gold")
		if rew.currencyID == 0 then
			q = math.floor(rew.quantity / 1e4)
			tooltipText = GetMoneyString(rew.quantity)
		else
			local ci = C_CurrencyInfo.GetCurrencyContainerInfo(rew.currencyID, rew.quantity)
			if ci then
				w.Icon:SetTexture(ci.icon)
				tooltipTitle = (ci.quality and "|c" .. (select(4,GetItemQualityColor(ci.quality)) or "ff00ffff") or "") .. ci.name
				tooltipText = NORMAL_FONT_COLOR_CODE .. (ci.description or "")
				local lb = LOOT_BORDER_BY_QUALITY[ci.quality]
				if lb then
					w.RarityBorder:SetAtlas(lb)
				end
			end
			cq = (isOvermax and pw and pw.currencyID == rew.currencyID and pw.currencyQ or 0) + q
		end
	elseif rew.itemID then
		q = rew.quantity == 1 and "" or rew.quantity or ""
		local _,_,r = GetItemInfo(rew.itemID)
		w.RarityBorder:SetAtlas(
			((r or 2) <= 2) and "loottoast-itemborder-green"
			or r == 3 and "loottoast-itemborder-blue"
			or r == 4 and "loottoast-itemborder-purple"
			or "loottoast-itemborder-orange"
		)
	end
	local overfullText = isOvermax and "|cffff8000" .. L"Bonus roll reward" .. "|r" or nil
	w.OvermaxRewardIcon:SetShown(isOvermax)
	w.currencyID, w.currencyAmount, w.itemID, w.tooltipExtra, w.tooltipHeader, w.tooltipText = rew.currencyID, rew.quantity, rew.itemID, overfullText, tooltipTitle, tooltipText
	w.currencyQ = cq
	w.Quantity:SetText(q or "")
end
local function ConfigureMechanic(w, mech, mechID, enemyName)
	local isSpecializationCounter = W.MECHANIC_ISSPEC[mechID]
	w.Icon:SetTexture(W.MECHANIC_ICONS[mechID] or mech.icon)
	w.PenaltyIcon:SetTexture(mech.ability.icon)
	w.SpecBorder:SetShown(isSpecializationCounter)
	w.ThreatBorder:SetShown(not isSpecializationCounter)
	w.mechanicID, w.mechanicInfo, mech.enemy, w.tooltipHeader, w.tooltipText = mechID, mech, enemyName
	w:Show()
	return 1
end
local function ConfigureEnvironmentMechanic(w, envN, envD, envI)
	w.Icon:SetTexture(envI)
	w.PenaltyIcon:SetColorTexture(0,0,0,0)
	w.SpecBorder:Hide()
	w.ThreatBorder:Show()
	w.tooltipHeader, w.tooltipText, w.mechanicID, w.mechanicInfo = envN, envD
	w:Show()
	return 1
end
local function ConfigureMission(me, mi, isAvailable)
	local mid = mi.missionID
	me.missionID, me.isAvailable, me.offerEndTime = mid, isAvailable, mi.offerEndTime
	me.baseCost, me.baseCostCurrency = mi.basecost, mi.costCurrencyTypesID
	me.hasOvermaxRewards = not not (mi.overmaxRewards and mi.overmaxRewards[1])
	me.hasUsefulOvermaxRewards = mi.overmaxRewardScore ~= 0
	me.Name:SetText(mi.name)
	if mi.isRare then
		me.Name:SetTextColor(0x99/255, 0xDD/255, 0xFF/255)
	else
		me.Name:SetTextColor(0.973, 0.902, 0.581)
	end
	if (mi.description or "") ~= "" then
		me.Description:SetText(mi.description)
	end
	
	local _, baseXP, envN, envD, envI, _, _, enemies = C.GetMissionInfo(mid)
	
	local timeNow = GetTime()
	local expirePrefix, expireAt, expireRoundUp = false, nil, nil, false
	me.completableAfter = nil
	if mi.offerEndTime then
		expirePrefix = "|A:worldquest-icon-clock:0:0:0:0|a"
		expireAt = mi.offerEndTime
	elseif mi.timeLeftSeconds then
		local sc = C.GetMissionSuccessChance(mid)
		expirePrefix = "|A:GarrMission_MissionTooltipAway:0:0:0:0|a"
		expireAt = timeNow+mi.timeLeftSeconds
		expireRoundUp = true
		me.completableAfter = expireAt
		me.ProgressBar.Text:SetText("")
		me.ProgressBar:SetProgressCountdown(mi.timeLeftSeconds+timeNow, mi.durationSeconds, L"Click to complete", true)
		me.ProgressBar.ChanceText:SetText(sc and sc .. "%" or "")
	elseif mi.completed then
		local sc = C.GetMissionSuccessChance(mid)
		me.completableAfter = timeNow-1
		me.ProgressBar:SetProgress(1)
		me.ProgressBar.Text:SetText(L"Click to complete")
		me.ProgressBar.ChanceText:SetText(sc and sc .. "%" or "")
	end
	me.ProgressBar:SetMouseMotionEnabled(me.completableAfter and me.completableAfter <= timeNow)
	
	me:SetCountdown(expirePrefix, expireAt, nil, nil, false, expireRoundUp)
	me.XPReward:SetText(baseXP .. " XP")
	
	ConfigureReward(me.Rewards[1], mi.rewards and mi.rewards[1])
	ConfigureReward(me.Rewards[2], mi.overmaxRewards and mi.overmaxRewards[1], true, me.Rewards[1])
	me.Rewards.Container:SetWidth(me.hasOvermaxRewards and 104 or 48)
	local  nm = 1
	for i=1,#enemies do
		local en, mech = enemies[i].name, enemies[i].mechanics
		for i=1,#mech do
			local v = mech[i]
			nm = nm + ConfigureMechanic(me.Mechanics[nm], v, v.mechanicTypeID, en)
		end
	end
	if envN and envI and envI > 0 then
		nm = nm + ConfigureEnvironmentMechanic(me.Mechanics[nm], envN, envD, envI)
	end
	for i=nm,#me.Mechanics do
		me.Mechanics[i]:Hide()
	end
	me.AchievementReward.assetID = mi.missionID
	me.AchievementReward.achievementID = mi.achievementID
	me.AchievementReward:SetShown(mi.achievementID and not mi.achievementComplete)
	me.MechanicsContainer:SetWidth(38*nm -44)
	
	for i=1,#me.Groups do
		me.Groups[i]:Hide()
	end
	
	local isMissionActive = not not (mi.completed or mi.timeLeftSeconds)
	local veilShade = mi.timeLeftSeconds and 0.65 or 1
	me.Veil:SetShown(isMissionActive)
	me.ProgressBar:SetShown(isMissionActive and not mi.isFakeStart)
	me.Rewards[1].RarityBorder:SetVertexColor(veilShade, veilShade, veilShade)
	me.Rewards[2].RarityBorder:SetVertexColor(veilShade, veilShade, veilShade)
	
	me:Show()
end
function EV:I_UPDATE_MISSION_SUGGESTIONS()
	local TaskBoard = WarPlanFrame.TaskBoard
	if not TaskBoard:IsVisible() then
		return
	end

	W.PrepareAllMissionGroups(22)
	local curResources = select(2, Nine.GetCurrencyInfo(1560))
	local followers = W.GetFollowers(22)
	
	local Missions = TaskBoard.Missions
	for i=1,#Missions do
		local me = Missions[i]
		if me:IsShown() and me.missionID and me.isAvailable then
			local mid = me.missionID
			W.PrepareSuggestedGroups(mid, followers)
			local tg = W.GetTentativeGroup(mid)
			local s1, s2, s3, s4 = W.SuggestMissionGroups(mid, W.GetMissionGroups(mid, true), GetManualGroupFilter(), me.offerEndTime and (me.offerEndTime - GetTime() - 15) or nil, curResources, me.hasUsefulOvermaxRewards)
			if not (s1 or s2 or s3 or s4) then
				local costString = ""
				if me.baseCost and me.baseCostCurrency then
					costString = ("|n|r" .. L"Base mission cost: %s"):format(("%s |T%d:16|t"):format(me.baseCost, select(3, Nine.GetCurrencyInfo(me.baseCostCurrency)) or 136235))
				end
				me.NoGroupLabel:SetText("|cff990000" .. L"No viable groups." .. costString)
				me.NoGroupLabel:Show()
			else
				me.NoGroupLabel:Hide()
			end
			for i=1,#me.Groups do
				local g, gw = s1, me.Groups[i]
				if g then
					local deadTroop = "|TInterface\\EncounterJournal\\UI-EJ-Icons:12:12:0:0:256:64:134:154:6:24|t"
					local troop = "|A:GarrisonTroops-Health:11:11:0:-1|a"
					local champ = "|TInterface\\FriendsFrame\\UI-Toast-FriendOnlineIcon:11:11:0:-1:32:32:8:24:8:24:"
					local gcomp, f1,f2,f3 = "", W.GetGroupMembers(g)
					local success, _baseXP, _chestXP, groupTime, cost, _tag, isLethal = W.GetGroupInfo(g)
					for _=1,3 do
						local fid = f1
						if not fid then
						elseif C.GetFollowerIsTroop(fid) then
							gcomp = gcomp .. (isLethal and C.GetFollowerInfo(fid).durability > 1 and deadTroop or troop)
						else
							local qc = select(C.GetFollowerQuality(fid), nil, "100:180:50", "50:100:255", "220:130:255") or "214:155:33"
							gcomp = gcomp .. champ .. qc .. "|t"
						end
						f1,f2,f3 = f2,f3
					end
					local restInfo = W.GetTimeStringFromSeconds(groupTime, true) .. "\n|T2032600:0:0:-2:0:64:64:4:60:4:60|t" .. cost .. "\n" .. gcomp
					local prefix = ""
					gw:SetEnabled(g.wt < 0)
					if g.wt >= 0 then
						gw:SetCountdown("|A:GarrMission_MissionTooltipAway:0:0:0:0|a", GetTime()+g.wt, "\n", restInfo, true, true)
						prefix = "|cffa0a0a0"
						gw:Disable()
					else
						gw:SetCountdown(nil, nil, nil, restInfo)
						gw:Enable()
					end
					if g == tg then
						prefix = "|cff66D9FF"
					end
					gw:SetText(prefix .. success .. "%")
					gw.group = g
				end
				gw:SetShown(not not g)
				s1, s2, s3, s4 = s2, s3, s4
			end
		elseif me:IsShown() then
			me.NoGroupLabel:Hide()
		end
	end
end
function EV:I_HIGHLIGHT_GROUP(group)
	local TaskBoard, m1, m2, m3 = WarPlanFrame.TaskBoard
	if group then
		m1, m2, m3 = W.GetGroupMembers(group)
	end
	for j=1,2 do
		local a = j == 1 and TaskBoard.Champions or TaskBoard.Troops.Units
		for i=1,#a do
			local w = a[i]
			local fid = w.followerID
			w.Highlight2:SetShown(fid and (fid == m1 or fid == m2 or fid == m3))
		end
	end
end

local function filterChampionName(name, fid)
	if GetLocale() == "enUS" and fid == 1182 then
		name = name:match(" (.+)")
	end
	return name
end
local function syncUI()
	local TaskBoard = WarPlanFrame.TaskBoard
	local availableMissions, inProgressMissions, completeMissions, followers, followerMissionInfo = W.GetMissionTableInfo(22)
	local troopArray = {}
	
	local Champions, cn = TaskBoard.Champions, 1
	for i=1,#followers do
		local fi = followers[i]
		local fid = fi.followerID
		if fi.status == GARRISON_FOLLOWER_ON_MISSION and IsFollowerInFocusGroup(fid) then
			EV("I_TOGGLE_FOLLOWER_FOCUS", fid, true)
		end
		local ce = Champions[cn]
		if fi.isTroop then
			troopArray[#troopArray+1] = fi
		elseif fi.isCollected and ce then
			local fid, gfid = fi.followerID, fi.garrFollowerID
			local tmid = W.GetFollowerTentativeGroup(fid)
			local onMission = fi.status == GARRISON_FOLLOWER_ON_MISSION or followerMissionInfo[fid] ~= nil or nil
			ce.followerID = fid
			cn = cn + 1
			ce.Name:SetText(filterChampionName(fi.name, fi.garrFollowerID))
			ce.Portrait:SetTexture(fi.portraitIconID)
			ce.selectDisabled = (onMission or tmid) and true or nil
			ce.Veil:SetShown(ce.selectDisabled)
			ce.Veil:SetAlpha(onMission and 0.8 or 0.4)
			local na = 1
			na = na + ConfigureAbilityButton(ce.Abilities[1], C.GetFollowerSpecializationAtIndex(fid, 1), true)
			for j=1,3 do
				if ConfigureAbilityButton(ce.Abilities[na], C.GetFollowerAbilityAtIndex(fid, j)) == 0 then
					na = na + ConfigureAbilityButton(ce.Abilities[na], C.GetFollowerAbilityAtIndexByID(gfid, j+1), false, true)
				else
					na = na + 1
				end
			end
			for j=1,3 do
				if ConfigureAbilityButton(ce.Abilities[na], C.GetFollowerTraitAtIndex(fid, j), false) == 1 then
					na = na + 1
				else
					na = na + ConfigureAbilityButton(ce.Abilities[na], C.GetFollowerTraitAtIndexByID(gfid, j), false, true)
				end
			end
			for j=na,#ce.Abilities do
				ce.Abilities[j]:Hide()
			end
			local sbar = ce.StatusBar
			local fmi = followerMissionInfo[fid]
			if fi.status == GARRISON_FOLLOWER_ON_MISSION then
				local mtl = C.GetFollowerMissionTimeLeftSeconds(fid)
				sbar.Fill:SetAtlas("UI-Frame-Bar-Fill-Blue")
				if fmi then
					local mi = followerMissionInfo[fid]
					local md = mi.durationSeconds
					sbar:SetProgressCountdown(GetTime()+mtl, md)
					sbar.Text:SetText(mi.name)
				else
					sbar:SetProgress(1)
					sbar.Text:SetText(GARRISON_FOLLOWER_ON_MISSION)
				end
			elseif tmid then
				sbar:SetProgress(0)
				sbar.Text:SetText("|cff66D9FF" .. C.GetMissionName(tmid))
			elseif fi.levelXP == 0 then
				sbar:SetProgress(1)
				sbar.Fill:SetAtlas("_honorsystem-bar-fill-rested")
				sbar.Text:SetText("")
			else
				sbar.Fill:SetAtlas("_honorsystem-bar-fill-rested")
				sbar:SetProgress(fi.xp/fi.levelXP)
				sbar.Text:SetText((fi.levelXP-fi.xp) .. " XP")
			end
			sbar:Show()
			ce:Show()
		end
	end
	for i=cn,#Champions do
		Champions[i]:Hide()
	end
	TaskBoard.ChampionContainer:Update()

	local x, ot, nu, nh, Troops = 4, 0, 1, 1, TaskBoard.Troops
	for i=1,#troopArray do
		local te, e, fid = troopArray[i]
		if te.troopAbility ~= ot then
			ot, e, nh = te.troopAbility, Troops.Headers[nh], nh + 1
			e:SetPoint("LEFT", x+2, 0)
			e:SetTexture(C.GetFollowerAbilityIcon(ot))
			e:Show()
			x = x + e:GetWidth()+6
		end
		e, nu, fid = Troops.Units[nu], nu + 1, te.followerID
		e.followerID, e.gfollowerID, e.missionID, e.isEffectivelyDead = fid, te.garrFollowerID, followerMissionInfo[fid] and followerMissionInfo[fid].missionID, te.isEffectivelyDead
		local tmid = W.GetFollowerTentativeGroup(fid)
		e.selectDisabled = (followerMissionInfo[fid] or tmid) and true or nil
		e:SetPoint("LEFT", x, 0)
		local returnDurability = te.isEffectivelyDead and 0 or (te.durability - (te.missionID and 1 or 0))
		e:SetDurability(te.maxDurability, returnDurability)
		e:SetAlpha(followerMissionInfo[fid] and 0.40 or tmid and 0.75 or 1)
		e:Show()
		x = x + e:GetWidth()+4
	end
	Troops:SetShown(#troopArray > 0)
	Troops:SetWidth(x-2)
	for j=nu, #Troops.Units do
		Troops.Units[j]:Hide()
	end
	for j=nh, #Troops.Headers do
		Troops.Headers[j]:Hide()
	end
	
	local Missions, cn = TaskBoard.Missions, 1
	for i=1,#availableMissions do
		ConfigureMission(Missions[cn], availableMissions[i], true)
		cn = cn + 1
	end
	for i=1,#inProgressMissions do
		ConfigureMission(Missions[cn], inProgressMissions[i], false)
		cn = cn + 1
	end
	TaskBoard.List.numMissions = cn-1
	for i=cn,#Missions do
		Missions[i]:Hide()
	end
	EV("I_UPDATE_MISSION_SUGGESTIONS")

	local apb = TaskBoard.AllPurposeButton
	apb.completeMissions = #completeMissions > 0 and completeMissions or nil
	apb:UpdateState()
	WarPlanFrame.syncSoon = nil
end
local function checkTableSync()
	local self = WarPlanFrame
	local mut = self.missionListUpdateTime
	if not mut then
		return
	end
	if mut < GetTime() then
		self.missionListUpdateTime, self.UpdateTimerCount = nil
		if self:IsShown() then
			self:Sync()
		end
	elseif self.UpdateTimerCount == 1 then
		C_Timer.After(0.1, checkTableSync)
	else
		self.UpdateTimerCount = self.UpdateTimerCount and (self.UpdateTimerCount - 1)
	end
end
local function queueTableSync()
	local self = WarPlanFrame
	if self:IsShown() then
		self.missionListUpdateTime, self.UpdateTimerCount = GetTime()+0.05, (self.UpdateTimerCount or 0) + 1
		C_Timer.After(0.10, checkTableSync)
	end
end
local function CompleteMission_Callback(event)
	local apb = WarPlanFrame.TaskBoard.AllPurposeButton
	apb:UpdateState()
	if event == "DONE" or event == "ABORT" then
		apb.completeMissions = nil
		queueTableSync()
	end
end

function EV:I_LOAD_HOOKS()
	UIParent:UnregisterEvent("ADVENTURE_MAP_OPEN")
	UIParent:UnregisterEvent("GARRISON_MISSION_NPC_OPENED")
	function EV:ADVENTURE_MAP_OPEN(followerTypeID)
		if followerTypeID ~= 22 or not C.IsAtGarrisonMissionNPC() then
			UIParent:GetScript("OnEvent")(UIParent, "ADVENTURE_MAP_OPEN", followerTypeID)
			return
		end
		Garrison_LoadUI()
		WarPlanFrame:Show()
	end
	function EV:GARRISON_MISSION_NPC_OPENED(followerTypeID)
		if followerTypeID ~= 22 then
			UIParent:GetScript("OnEvent")(UIParent, "GARRISON_MISSION_NPC_OPENED", followerTypeID)
			return
		end
		Garrison_LoadUI()
		WarPlanFrame:Show()
	end
	return "remove"
end
function EV:I_LOAD_MAINUI()
	local frame = CreateObject("MissionTable", "WarPlanFrame")
	frame:RegisterEvent("GARRISON_MISSION_LIST_UPDATE")
	frame:RegisterEvent("GARRISON_MISSION_FINISHED")
	frame:SetScript("OnShow", function()
		BFAMissionFrame:Hide()
		PlaySound(SOUNDKIT.UI_GARRISON_COMMAND_TABLE_OPEN)
		syncUI()
	end)
	frame:SetScript("OnHide", function(self)
		self.TaskBoard.List:ReturnToTop()
		PlaySound(SOUNDKIT.UI_GARRISON_COMMAND_TABLE_CLOSE)
		W.ClearTentativeGroups()
		C.CloseMissionNPC()
		C_AdventureMap.Close()
		EV("I_RELEASE_CACHES")
	end)
	frame:SetScript("OnUpdate", function(self)
		if self.syncSoon and self.TaskBoard:IsShown() then
			self.syncSoon, self.missionListUpdateTime = nil
			syncUI()
		end
	end)
	frame:SetScript("OnEvent", queueTableSync)
	frame.Sync = syncUI
	local reset = frame.ResetButton
	reset.tooltipHeader = L"Revert to Blizzard UI"
	reset.tooltipText = (L"Reload the interface and do not activate %s until next reload."):format(ADDON)
	reset:RegisterForClicks("LeftButtonUp", "RightButtonUp")
	reset:SetScript("OnClick", function(_, button)
		if button == "LeftButton" then
			PlaySound(43861)
			W.SuspendAndReload()
		elseif button == "RightButton" then
			local toast = frame.TaskBoard:AcquireToast()
			toast.Icon:SetTexture(877477)
			toast.Icon:SetTexCoord(60/64, 4/64, 4/64, 60/64)
			toast.Outcome:SetFormattedText("|cffff8000%s|r |cffffffff%s", GetAddOnMetadata(ADDON, "Title") or ADDON, GetAddOnMetadata(ADDON, "Version"))
			toast.Detail:SetText("|cff00aaffMy wishes over their airspace|r")
			toast.PreGlow:SetVertexColor(1, 0.8, 0.2)
			toast.Sheen:SetVertexColor(1, 0.5, 0)
		end
	end)
	local history = frame.TaskBoard.HistoryButton
	history.tooltipHeader = L"Mission History"
	history.tooltipText = ""

	local apb = frame.TaskBoard.AllPurposeButton
	apb:RegisterForClicks("LeftButtonUp", "RightButtonUp")
	apb:SetScript("OnClick", function(self, button)
		local sm = W.IsStartingMissions()
		if sm and sm > 0 then
			W.StopStartingMissions()
		elseif W.IsCompletingMissions() then
			W.StopCompletingMissions()
		elseif self.completeMissions then
			local cm = self.completeMissions
			self.completeMissions = nil
			W.CompleteMissions(cm, CompleteMission_Callback)
		elseif W.HasTentantiveGroups() then
			if button == "RightButton" then
				W.ClearTentativeGroups()
			else
				W.StartTentativeGroups()
			end
		else
			return
		end
		PlaySound(SOUNDKIT.U_CHAT_SCROLL_BUTTON)
		self:UpdateState()
	end)
	apb:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
		local NC, sm = NORMAL_FONT_COLOR, W.IsStartingMissions()
		if sm and sm > 0 then
			return GameTooltip:Hide()
		elseif W.IsCompletingMissions() then
			return GameTooltip:Hide()
		elseif self.completeMissions then
			GameTooltip:SetText(L"Complete All")
			for i=1,#self.completeMissions do
				local mi = self.completeMissions[i]
				GameTooltip:AddDoubleLine(mi.name, (C.GetMissionSuccessChance(mi.missionID) or "?") .. "%", 1,1,1, NC.r, NC.g, NC.b)
			end
		elseif W.HasTentantiveGroups() then
			GameTooltip:SetText(L"Send Tentative Parties")
			for mid, sc in W.TentativeGroups do
				GameTooltip:AddDoubleLine(C.GetMissionName(mid), sc .. "%", 1,1,1, NC.r, NC.g, NC.b)
			end
			GameTooltip:AddLine("|n|TInterface\\TUTORIALFRAME\\UI-TUTORIAL-FRAME:14:12:0:-1:512:512:10:70:330:410|t " .. L"Clear all tentative parties", 0.5, 0.8, 1)
		else
			return GameTooltip:Hide()
		end
		GameTooltip:Show()
	end)
	function apb:UpdateState()
		self.tooltipHeader, self.tooltipText = nil
		local sm, cm = W.IsStartingMissions(), W.IsCompletingMissions()
		if sm and sm > 0 then
			self:SetFormattedText(L"%d |4party:parties; remaining...", sm)
		elseif cm then
			self:SetFormattedText(L"%d |4mission:missions; remaining...", cm)
		elseif self.completeMissions then
			self:SetText(L"Complete All")
		elseif W.HasTentantiveGroups() then
			self:SetText(L"Send Tentative Parties")
		else
			self:Hide()
			return
		end
		self:Show()
	end
	function frame.TaskBoard:CompleteMission(mid)
		W.CompleteMission(mid, CompleteMission_Callback)
		apb:UpdateState()
	end
	function EV:I_ABILITY_BONUS_LOOT(_mid, packedRewardInfo)
		local text, rk, tid, quant, ico = "", W.UnpackHistoryReward(packedRewardInfo)
		if rk == "item" then
			text = select(2,GetItemInfo(tid)) or ""
		end
		if quant > 1 and text ~= "" then
			text = quant .. " " .. text
		end
		local toast = frame.TaskBoard:AcquireToast()
		toast.Icon:SetTexture(ico)
		toast.Icon:SetTexCoord(60/64, 4/64, 4/64, 60/64)
		toast.Outcome:SetText(BONUS_ROLL_TOOLTIP_TITLE)
		toast.Detail:SetText(text)
		toast.PreGlow:SetVertexColor(0.15, 0.8, 1)
		toast.Sheen:SetVertexColor(0, 0.75, 1)
	end
	function EV:GARRISON_MISSION_NPC_CLOSED()
		if frame:IsShown() then
			frame:Hide()
		end
	end

	local function syncOnce()
		WarPlanFrame.syncSoon = true
		return "remove"
	end
	local function syncAndClearFocus(_, _mid, f1, f2, f3)
		toggleFollowerFocus(f1, true)
		toggleFollowerFocus(f2, true)
		toggleFollowerFocus(f3, true)
		WarPlanFrame.syncSoon = true
	end
	EV.I_UPDATE_TENTATIVE_GROUP = syncAndClearFocus
	EV.I_MANUAL_MISSION_START = syncAndClearFocus
	function EV:I_MISSION_START_QUEUE()
		apb:UpdateState()
		queueTableSync()
	end
	function EV:I_MISSION_LOG_UPDATED()
		local baseOK, bonusOK = frame.TaskBoard:AcquireToast():SetMissionHistory(1)
		if not baseOK then
			PlaySound(43503)
		elseif bonusOK then
			PlaySound(44332)
		else
			PlaySound(43502)
		end
	end
	function EV:I_ARM_FOLLOWER_UPDATE()
		EV.GARRISON_FOLLOWER_LIST_UPDATE = syncOnce
	end

	BFAMissionFrame:SetScript("OnHide", function(self)
		AdventureMapMixin.OnHide(self.MapTab)
	end)
	BFAMissionFrame:UnregisterEvent("GARRISON_FOLLOWER_XP_CHANGED")
	BFAMissionFrame:UnregisterEvent("GARRISON_MISSION_LIST_UPDATE")
	BFAMissionFrame:UnregisterEvent("CURRENCY_DISPLAY_UPDATE")
	BFAMissionFrame:UnregisterEvent("GARRISON_MISSION_STARTED")
	BFAMissionFrame:UnregisterEvent("GARRISON_MISSION_FINISHED")
	BFAMissionFrame:UnregisterEvent("GARRISON_RANDOM_MISSION_ADDED")
	BFAMissionFrame:UnregisterEvent("CURRENT_SPELL_CAST_CHANGED")
	BFAMissionFrame:UnregisterEvent("GARRISON_FOLLOWER_XP_CHANGED")

	frame.SelectTab = function() end
	C_Timer.After(0, function()
		GarrisonFollowerOptions[22].missionFrame = "WarPlanFrame"
	end)
	
	return "remove"
end