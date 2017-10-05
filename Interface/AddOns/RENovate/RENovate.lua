local _G = _G
_G.RENovateNamespace = {}
local RE = RENovateNamespace
local LAP = LibStub("LibArtifactPower-1.0")
local LAD = LibStub("LibArtifactData-1.0")

--GLOBALS: PARENS_TEMPLATE, GARRISON_LONG_MISSION_TIME, GARRISON_LONG_MISSION_TIME_FORMAT, RED_FONT_COLOR_CODE, YELLOW_FONT_COLOR_CODE, FONT_COLOR_CODE_CLOSE, ITEM_LEVEL_ABBR, ORDER_HALL_MISSIONS, ORDER_HALL_FOLLOWERS, WINTERGRASP_IN_PROGRESS, Fancy18Font, Game13Font
local string, tostring, abs, format, tsort, strcmputf8i, select, pairs, hooksecurefunc = _G.string, _G.tostring, _G.abs, _G.format, _G.table.sort, _G.strcmputf8i, _G.select, _G.pairs, _G.hooksecurefunc
local GetTime = _G.GetTime
local CreateFrame = _G.CreateFrame
local GetMissionInfo = _G.C_Garrison.GetMissionInfo
local GetFollowerAbilityCountersForMechanicTypes = _G.C_Garrison.GetFollowerAbilityCountersForMechanicTypes
local HybridScrollFrame_GetOffset = _G.HybridScrollFrame_GetOffset
local ElvUI = _G.ElvUI

RE.Version = 110
RE.ThreatAnchors = {"LEFT", "CENTER", "RIGHT"}
RE.RewardCache = {}
RE.UpdateTimer = -1

function RE:OnLoad(self)
	self:RegisterEvent("ADDON_LOADED")
end

function RE:OnEvent(self, event, name)
  if event == "ADDON_LOADED" and name == "RENovate" then
	if not _G.RENovateSettings then
		_G.RENovateSettings = {["IgnoredMissions"] = {}}
	end
		RE.Settings = _G.RENovateSettings
	LAD:ForceUpdate()

	RE.F = _G.OrderHallMissionFrame
	RE.MissionList = RE.F.MissionTab.MissionList
	RE.OriginalUpdate = RE.MissionList.Update
	RE.OriginalTooltip = _G.GarrisonMissionList_UpdateMouseOverTooltip
	RE.OriginalSort = _G.Garrison_SortMissions

	ORDER_HALL_MISSIONS = ORDER_HALL_MISSIONS.." - RENovate "..tostring(RE.Version):gsub(".", "%1."):sub(1,-2)
	ORDER_HALL_FOLLOWERS = ORDER_HALL_FOLLOWERS.." - RENovate "..tostring(RE.Version):gsub(".", "%1."):sub(1,-2)

		-- Force refresh of "In Progress" tab when needed
		hooksecurefunc("GarrisonMissionListTab_SetTab", function() RE.UpdateTimer = 0 end)
		RE.MissionList:HookScript("OnHide", function() RE.UpdateTimer = 0 end)

		-- Replaced original OnUpdate to implement throttling and "In Progress" sorting
		RE.MissionList:SetScript("OnUpdate", function (self, elapsed)
			if RE.UpdateTimer < 0 then
				if self.showInProgress then
					_G.C_Garrison.GetInProgressMissions(self.inProgressMissions, RE.F.followerTypeID)
					RE.MissionSortInProgress()
					self.Tab2:SetText(WINTERGRASP_IN_PROGRESS.." - "..#self.inProgressMissions)
					self:Update()
				else
					local timeNow = GetTime()
					for i = 1, #self.availableMissions do
						if self.availableMissions[i].offerEndTime and self.availableMissions[i].offerEndTime <= timeNow then
							self:UpdateMissions()
							break
						end
					end
				end
				self:UpdateCombatAllyMission()
				RE.UpdateTimer = 10
			else
				RE.UpdateTimer = RE.UpdateTimer - elapsed
			end
	end)

		-- Pre-hook to inject button skinning function
		function RE.MissionList:Update()
			RE.OriginalUpdate(self)
			RE:MissionUpdate(self)
		end

		-- Pre-hook to disable tooltips in Order Hall mission table
	function _G.GarrisonMissionList_UpdateMouseOverTooltip(self)
	  if not RE.F:IsShown() then
		RE.OriginalTooltip(self)
	  end
	end

		-- Pre-hook to inject available missions sorting function
	function _G.Garrison_SortMissions(missionsList)
	  if not RE.F:IsShown() then
		RE.OriginalSort(missionsList)
	  else
		RE.MissionSort()
	  end
	end
  end
end

function RE:OnClick(button)
  if button == "RightButton" and not RE.MissionList.showInProgress then
	if RE.Settings.IgnoredMissions[self.info.missionID] then
	  RE.Settings.IgnoredMissions[self.info.missionID] = nil
	else
	  RE.Settings.IgnoredMissions[self.info.missionID] = true
	end
	RE.MissionList:UpdateMissions()
  else
	_G.GarrisonMissionButton_OnClick(self, button)
  end
end

function RE:GetMissionThreats(missionID, parentFrame)
  if not RE.F.abilityCountersForMechanicTypes then
	RE.F.abilityCountersForMechanicTypes = GetFollowerAbilityCountersForMechanicTypes(RE.F.followerTypeID)
  end

  local enemies = select(8, GetMissionInfo(missionID))
  local counterableThreats = _G.GarrisonMission_DetermineCounterableThreats(missionID, RE.F.followerTypeID)
  local numThreats = 0

  for i = 1, 3 do
	parentFrame.Threat[i]:Hide()
  end
  for i = 1, #enemies do
	 local enemy = enemies[i]
	 for mechanicID, _ in pairs(enemy.mechanics) do
	   numThreats = numThreats + 1
	   local threatFrame = parentFrame.Threat[numThreats]
	   local ability = RE.F.abilityCountersForMechanicTypes[mechanicID]
	   threatFrame.Border:SetShown(_G.ShouldShowFollowerAbilityBorder(RE.F.followerTypeID, ability))
	   threatFrame.Icon:SetTexture(ability.icon)
	   threatFrame:Show()
	   _G.GarrisonMissionButton_CheckTooltipThreat(threatFrame, missionID, mechanicID, counterableThreats)
	 end
   end
end

function RE:GetMissonSlowdown(missionID)
  local enemies = select(8, GetMissionInfo(missionID))
  local slowicons = " "
  for i = 1, #enemies do
	 local enemy = enemies[i]
	 for _, mechanic in pairs(enemy.mechanics) do
	   if mechanic.ability and mechanic.ability.id == 428 then
		 slowicons = slowicons.."|TInterface\\Garrison\\orderhall-missions-mechanic5:0|t"
	   end
	 end
  end
  if #slowicons == 1 then
	return ""
  else
	return slowicons
  end
end

function RE:GetRewardCache(mission)
	if not RE.RewardCache[mission.missionID] then
		local allRewards = {}
		if mission.overmaxRewards then
			for j = 1, #mission.overmaxRewards do
				allRewards[#allRewards + 1] = mission.overmaxRewards[j]
			end
		end
		if mission.rewards then
			for j = 1, #mission.rewards do
				allRewards[#allRewards + 1] = mission.rewards[j]
			end
		end
		RE.RewardCache[mission.missionID] = allRewards
	end
	return RE.RewardCache[mission.missionID]
end

function RE:ShortValue(v)
	if abs(v) >= 1e8 then
		return format("%.2f亿", v / 1e8)
	elseif abs(v) >= 1e4 then
		return format("%.0f万", v / 1e4)
	else
		return format("%d", v)
	end
end

function RE:MissionUpdate(self)
  if not RE.F or not RE.F:IsShown() then return end

  local missions = self.showInProgress and self.inProgressMissions or self.availableMissions
	local buttons = self.listScroll.buttons
	local offset = HybridScrollFrame_GetOffset(self.listScroll)

  for i = 1, #buttons do
	local button = buttons[i]
	local index = offset + i
	if index <= #missions then
	  local mission = missions[index]

	  if not button.Renovate then
		button.Renovate = true
		button:RegisterForClicks("LeftButtonUp", "RightButtonUp")
		button:SetScript("OnClick", RE.OnClick)
		button:SetScript("OnEnter", nil)
		button:SetScript("OnLeave", nil)
		if ElvUI then
		  ElvUI[1]:GetModule('Skins'):HandleButton(button)
		else
		  button.Title:SetFontObject(GameFontHighlight)
		  button.Summary:SetFontObject(GameFontHighlight)
		end
		button.Threats = CreateFrame("Frame", nil, button)
		button.Threats:SetPoint("RIGHT", button, "RIGHT", -145, 0)
		button.Threats:SetWidth(80)
		button.Threats:SetHeight(30)
		button.Threats.Threat = {[1] = CreateFrame("Frame", nil, button.Threats, "GarrisonAbilityCounterWithCheckTemplate"),
								 [2] = CreateFrame("Frame", nil, button.Threats, "GarrisonAbilityCounterWithCheckTemplate"),
								 [3] = CreateFrame("Frame", nil, button.Threats, "GarrisonAbilityCounterWithCheckTemplate")}
		for i = 1, 3 do
		 button.Threats.Threat[i]:SetPoint(RE.ThreatAnchors[i])
		end
	  end

	  if not mission.inProgress then
		if RE.Settings.IgnoredMissions[mission.missionID] then
		  button.Overlay.Overlay:SetColorTexture(0, 0, 0, 0.8)
		  button.Overlay:Show()
		  button.Threats:Hide()
		else
		  button.Overlay.Overlay:SetColorTexture(0, 0, 0, 0.4)
		  button.Overlay:Hide()
		  RE:GetMissionThreats(mission.missionID, button.Threats)
		  button.Threats:Show()
		end

		local originalText = (mission.durationSeconds < GARRISON_LONG_MISSION_TIME) and mission.duration or string.format(GARRISON_LONG_MISSION_TIME_FORMAT, mission.duration)
		if mission.offerEndTime then
		  local timeRemaining = mission.offerEndTime - GetTime()
		  local colorCode, colorCodeEnd = "", ""
		  if timeRemaining < 8 * 3600 then
			colorCode, colorCodeEnd = RED_FONT_COLOR_CODE, FONT_COLOR_CODE_CLOSE
		  elseif timeRemaining < 24 * 3600 then
			colorCode, colorCodeEnd = YELLOW_FONT_COLOR_CODE, FONT_COLOR_CODE_CLOSE
		  end
		  button.Summary:SetText(originalText..RE:GetMissonSlowdown(mission.missionID).." / "..colorCode..mission.offerTimeRemaining..colorCodeEnd)
		else
		  button.Summary:SetText(originalText..RE:GetMissonSlowdown(mission.missionID))
		end
	  else
		button.Overlay.Overlay:SetColorTexture(0, 0, 0, 0.4)
		button.Overlay:Show()
		button.Threats:Hide()
	  end

	  button.Summary:ClearAllPoints()
	  if ElvUI then
		button.Summary:SetPoint("BOTTOMLEFT", button.Title, "BOTTOMRIGHT", 5, 3)
	  else
		button.Summary:SetPoint("BOTTOMLEFT", button.Title, "BOTTOMRIGHT", 5, 0)
	  end
	  button.Level:ClearAllPoints()
	  button.Level:SetPoint("CENTER", button, "TOPLEFT", 42, -32)
	  button.RareText:Hide()
	  if mission.isMaxLevel and mission.iLevel > 0 then
		button.Level:SetText(mission.iLevel)
		button.ItemLevel:SetText(ITEM_LEVEL_ABBR)
	  end
	  if mission.isRare then
		button.Level:SetTextColor(0.098, 0.537, 0.969, 1.0)
		button.ItemLevel:SetTextColor(0.098, 0.537, 0.969, 1.0)
	  else
		button.Level:SetTextColor(0.84, 0.72, 0.57, 1.0)
		button.ItemLevel:SetTextColor(0.84, 0.72, 0.57, 1.0)
	  end

			local rewards = RE:GetRewardCache(mission)
	  _G.GarrisonMissionButton_SetRewards(button, rewards, #rewards)

	  for j = 1, #button.Rewards do
		local itemID = button.Rewards[j].itemID
		if itemID and LAP:DoesItemGrantArtifactPower(itemID) then
		  button.Rewards[j].Quantity:SetFormattedText("|cffe5cc7f%s|r", RE:ShortValue(LAP:GetArtifactPowerGrantedByItem(itemID)))
		  button.Rewards[j].Quantity:Show()
		end
	  end
	end
  end
end

function RE:MissionSort()
	if RE.MissionList.showInProgress then return end

	tsort(RE.MissionList.availableMissions, function (mission1, mission2)
	if RE.Settings.IgnoredMissions[mission1.missionID] and not RE.Settings.IgnoredMissions[mission2.missionID] then
	  return false
	elseif RE.Settings.IgnoredMissions[mission2.missionID] and not RE.Settings.IgnoredMissions[mission1.missionID] then
	  return true
	end

	if mission1.isRare ~= mission2.isRare then
		return mission1.isRare
	end

	if mission1.level ~= mission2.level then
		return mission1.level > mission2.level
	end

	if mission1.isMaxLevel then
		if mission1.iLevel ~= mission2.iLevel then
			return mission1.iLevel > mission2.iLevel
		end
	end

	if mission1.durationSeconds ~= mission2.durationSeconds then
		return mission1.durationSeconds < mission2.durationSeconds
	end

	return strcmputf8i(mission1.name, mission2.name) < 0
  end)
end

function RE:MissionSortInProgress()
	if not RE.MissionList.showInProgress then return end

	tsort(RE.MissionList.inProgressMissions, function (mission1, mission2)
	if mission1.timeLeftSeconds ~= mission2.timeLeftSeconds then
		return mission1.timeLeftSeconds < mission2.timeLeftSeconds
	end

	return strcmputf8i(mission1.name, mission2.name) < 0
  end)
end
