local _, T = ...
local Nine = T.Nine or _G
local EV, L, W, C = T.Evie, T.L, T.WrappedAPI, Nine.C_Garrison

local function ShowReportMissionExpirationTime()
	if GarrisonLandingPage.garrTypeID ~= 9 then return end
	local items, buttons = GarrisonLandingPageReport.List.AvailableItems, GarrisonLandingPageReport.List.listScroll.buttons
	for i=1,#buttons do
		local item = buttons[i]:IsShown() and items[buttons[i].id]
		if item and item.offerTimeRemaining and item.offerEndTime then
			if item.offerEndTime - 8640000 <= GetTime() then
				buttons[i].MissionType:SetFormattedText("%s |cffa0a0a0(%s %s)|r",
					item.durationSeconds >= GARRISON_LONG_MISSION_TIME and (GARRISON_LONG_MISSION_TIME_FORMAT):format(item.duration) or item.duration,
					L"Expires in:", item.offerTimeRemaining)
			end
		end
	end
end
function EV:I_LOAD_MAINUI()
	hooksecurefunc("GarrisonLandingPageReportList_UpdateAvailable", ShowReportMissionExpirationTime)
	if GarrisonLandingPageReport:IsVisible() then
		ShowReportMissionExpirationTime()
	end
end

local function Tooltip_AddGarrisonStatus(self, mt, prefixLine)
	local am, nextExpire = C.GetAvailableMissions(mt) or {}
	local im, inProgressCount, nextComplete = C.GetInProgressMissions(mt) or {}, 0
	local cm = C.GetCompleteMissions(mt) or {}
	
	if prefixLine and (#am + #im + #cm) > 0 then
		self:AddLine(prefixLine)
	end
	
	for i=1,#am do
		local et = am[i].offerEndTime
		nextExpire = nextExpire and et and nextExpire > et and nextExpire or et or nextExpire
	end
	if #am > 0 then
		local tl = nextExpire and "|A:worldquest-icon-clock:16:17:0:0|a" .. W.GetLazyTimeStringFromSeconds(nextExpire - GetTime(), false) or ""
		self:AddDoubleLine((L"%d |4mission:missions; available"):format(#am), tl, 1,1,1, 0.85, 0.35,0)
	end

	for i=1, #im do
		local e = im[i]
		if e.timeLeftSeconds > 0 then
			inProgressCount, nextComplete = inProgressCount + 1, nextComplete and nextComplete <= e.timeLeftSeconds and nextComplete or e.timeLeftSeconds
		end
	end
	if inProgressCount > 0 then
		local tl = nextComplete and "|A:GarrMission_MissionTooltipAway:14:14:-1.5:0|a" .. W.GetLazyTimeStringFromSeconds(nextComplete, true) or ""
		self:AddDoubleLine((L"%d |4mission:missions; in progress"):format(inProgressCount), tl, 0.65, 0.65, 0.65, 0.45, 0.65, 0.85)
	end

	if #cm > 0 then
		self:AddLine((L"%d |4mission:missions; complete"):format(#cm), 0.25,0.8,0.25)
	end
	self:Show()
end
local function Tooltip_OnSetUnit(self)
	local _, unit = self:GetUnit()
	local guid = unit == "mouseover" and UnitGUID("mouseover")
	local cid = guid and guid:match("^Creature%-%d+%-%d+%-%d+%-%d+%-(%d+)")
	if cid == "138704" or cid == "138706" then
		return Tooltip_AddGarrisonStatus(self, 22)
	end
end
local function Tooltip_OnLandingEnter(self)
	if GameTooltip:IsOwned(self) and C.GetLandingPageGarrisonType() == 9 then
		Tooltip_AddGarrisonStatus(GameTooltip, 22, " ")
		GameTooltip:ClearAllPoints()
		GameTooltip:SetPoint("TOPRIGHT", self, "TOPLEFT", -2, 2)
	end
end

function EV:I_LOAD_HOOKS()
	GameTooltip:HookScript("OnTooltipSetUnit", Tooltip_OnSetUnit)
	GarrisonLandingPageMinimapButton:HookScript("OnEnter", Tooltip_OnLandingEnter)
	if IsAddOnLoaded("MasterPlanA") then
		return
	end
	local function ShowLanding(_, page)
		HideUIPanel(GarrisonLandingPage)
		local b = GarrisonLandingPageFollowerList.listScroll.buttons
		if ((page or C_Garrison.GetLandingPageGarrisonType()) == 111) ~= (b and b[1] and not b[1].DownArrow) then
			for i=1,#b do
				b[i]:Hide()
			end
			GarrisonLandingPageFollowerList.listScroll.buttons = nil
		end
		ShowGarrisonLandingPage(page)
	end
	local function MaybeStopSound(sound)
		return sound and StopSound(sound)
	end
	local landingChoiceMenu, landingChoices
	GarrisonLandingPageMinimapButton:RegisterForClicks("LeftButtonUp", "RightButtonUp")
	GarrisonLandingPageMinimapButton:HookScript("PreClick", function(self, b)
		self.landingVisiblePriorToClick = GarrisonLandingPage and GarrisonLandingPage:IsVisible() and GarrisonLandingPage.garrTypeID
		if b == "RightButton" then
			local openOK, openID = PlaySound(SOUNDKIT.UI_GARRISON_GARRISON_REPORT_OPEN)
			local closeOK, closeID = PlaySound(SOUNDKIT.UI_GARRISON_GARRISON_REPORT_CLOSE)
			self.openSoundID = openOK and openID
			self.closeSoundID = closeOK and closeID
			local openOK, openID = PlaySound(SOUNDKIT.UI_GARRISON_9_0_OPEN_LANDING_PAGE)
			local closeOK, closeID = PlaySound(SOUNDKIT.UI_GARRISON_9_0_CLOSE_LANDING_PAGE)
			self.openSoundID2 = openOK and openID
			self.closeSoundID2 = closeOK and closeID
		end
	end)
	GarrisonLandingPageMinimapButton:HookScript("OnClick", function(self, b)
		if b == "LeftButton" then
			if GarrisonLandingPage.garrTypeID ~= C.GetLandingPageGarrisonType() then
				ShowLanding(nil, C.GetLandingPageGarrisonType())
			end
			return
		elseif b == "RightButton" then
			if (C.GetLandingPageGarrisonType() or 0) > 3 then
				if self.landingVisiblePriorToClick then
					ShowLanding(nil, self.landingVisiblePriorToClick)
				else
					HideUIPanel(GarrisonLandingPage)
				end
				MaybeStopSound(self.openSoundID)
				MaybeStopSound(self.closeSoundID)
				MaybeStopSound(self.openSoundID2)
				MaybeStopSound(self.closeSoundID2)
				if not landingChoiceMenu then
					landingChoiceMenu = CreateFrame("Frame", "WPLandingChoicesDrop", UIParent, "UIDropDownMenuTemplate")
				end
				landingChoices = wipe(landingChoices or {})
				landingChoices[#landingChoices+1] = C.GetNumFollowers(1) > 0 and {text=GARRISON_LANDING_PAGE_TITLE, func=ShowLanding, arg1=2, notCheckable=true} or nil
				landingChoices[#landingChoices+1] = C.GetNumFollowers(4) > 0 and {text=ORDER_HALL_LANDING_PAGE_TITLE, func=ShowLanding, arg1=3, notCheckable=true} or nil
				landingChoices[#landingChoices+1] = C.GetNumFollowers(22) > 0 and {text=WAR_CAMPAIGN, func=ShowLanding, arg1=9, notCheckable=true} or nil
				landingChoices[#landingChoices+1] = C.GetNumFollowers(123) > 0 and {text=COVENANT_MISSIONS_TITLE, func=ShowLanding, arg1=111, notCheckable=true} or nil
				GameTooltip:Hide()
				EasyMenu(landingChoices, landingChoiceMenu, "cursor", 0, 0, "MENU", 4)
				DropDownList1:ClearAllPoints()
				local x, y = self:GetCenter()
				local w, h = UIParent:GetSize()
				local u, r = y*2 > h, x*2 > w
				local p1 = (u and "TOP" or "BOTTOM") .. (r and "RIGHT" or "LEFT")
				local p2 = (u and "TOP" or "BOTTOM") .. (r and "LEFT" or "RIGHT")
				DropDownList1:SetPoint(p1, self, p2, r and 10 or -10, u and -8 or 8)
			elseif GarrisonLandingPage.garrTypeID == 3 then
				ShowLanding(nil, 2)
				MaybeStopSound(self.closeSoundID)
				MaybeStopSound(self.closeSoundID2)
			end
		end
	end)
	GarrisonLandingPageMinimapButton:HookScript("PostClick", function(self)
		self.closeSoundID, self.openSoundID, self.closeSoundID2, self.openSoundID2 = nil
	end)
end