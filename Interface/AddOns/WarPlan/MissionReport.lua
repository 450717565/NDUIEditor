local _, T = ...
local EV, L, W, C = T.Evie, T.L, T.WrappedAPI, C_Garrison

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
	local am, nextExpire = C.GetAvailableMissions(mt), math.huge
	local im, inProgressCount, inProgressNext = C.GetInProgressMissions(mt), 0, math.huge
	local cm = C.GetCompleteMissions(mt)
	
	if not (im and im and cm) then
		return
	end
	
	if prefixLine and (#am + #im + #cm) > 0 then
		self:AddLine(prefixLine)
	end
	
	for i=1,#am do
		local et = am[i].offerEndTime
		nextExpire = et and et < nextExpire and et or nextExpire
	end
	if #am > 0 then
		local tl = "|A:worldquest-icon-clock:16:17:0:0|a" .. W.GetLazyTimeStringFromSeconds(nextExpire - GetTime(), false)
		self:AddDoubleLine((L"%d |4mission:missions; available"):format(#am), tl, 1,1,1, 0.85, 0.35,0)
	end

	for i=1, #im do
		local e = im[i]
		if e.timeLeftSeconds > 0 then
			inProgressCount, inProgressNext = inProgressCount + 1, inProgressNext > e.timeLeftSeconds and e.timeLeftSeconds or inProgressNext
		end
	end
	if inProgressCount > 0 then
		local tl = "|A:GarrMission_MissionTooltipAway:14:14:-1.5:0|a" .. W.GetLazyTimeStringFromSeconds(inProgressNext, true)
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
	local function ShowLanding(page)
		HideUIPanel(GarrisonLandingPage)
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
		end
	end)
	GarrisonLandingPageMinimapButton:HookScript("OnClick", function(self, b)
		if b == "LeftButton" then
			if GarrisonLandingPage.garrTypeID ~= C.GetLandingPageGarrisonType() then
				ShowLanding(C.GetLandingPageGarrisonType())
			end
			return
		elseif b == "RightButton" then
			if (C.GetLandingPageGarrisonType() or 0) > 3 then
				if self.landingVisiblePriorToClick then
					ShowLanding(self.landingVisiblePriorToClick)
				else
					HideUIPanel(GarrisonLandingPage)
				end
				MaybeStopSound(self.openSoundID)
				MaybeStopSound(self.closeSoundID)
				if not landingChoiceMenu then
					landingChoiceMenu = CreateFrame("Frame", "WPLandingChoicesDrop", UIParent, "UIDropDownMenuTemplate")
					local function ShowLanding_(_, ...)
						return ShowLanding(...)
					end
					landingChoices = {
						{text=GARRISON_LANDING_PAGE_TITLE, func=ShowLanding_, arg1=2, notCheckable=true},
						{text=ORDER_HALL_LANDING_PAGE_TITLE, func=ShowLanding_, arg1=3, notCheckable=true},
						{text=WAR_CAMPAIGN, func=ShowLanding_, arg1=C.GetLandingPageGarrisonType(), notCheckable=true},
					}
				end
				EasyMenu(landingChoices, landingChoiceMenu, "cursor", 0, 0, "MENU", 4)
				DropDownList1:ClearAllPoints()
				DropDownList1:SetPoint("TOPRIGHT", self, "TOPLEFT", 10, -4)
			elseif GarrisonLandingPage.garrTypeID == 3 then
				ShowLanding(2)
				MaybeStopSound(self.closeSoundID)
			end
		end
	end)
	GarrisonLandingPageMinimapButton:HookScript("PostClick", function(self)
		self.closeSoundID, self.openSoundID = nil, nil
	end)
end