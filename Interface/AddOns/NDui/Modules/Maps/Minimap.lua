local _, ns = ...
local B, C, L, DB = unpack(ns)
local MAP = B:GetModule("Maps")

local _G = _G
local select, pairs, unpack, next, tinsert = select, pairs, unpack, next, tinsert
local strmatch, strfind, strupper = strmatch, strfind, strupper
local UIFrameFadeOut, UIFrameFadeIn = UIFrameFadeOut, UIFrameFadeIn
local C_Timer_After = C_Timer.After
local LE_GARRISON_TYPE_6_0 = Enum.GarrisonType.Type_6_0
local LE_GARRISON_TYPE_7_0 = Enum.GarrisonType.Type_7_0
local LE_GARRISON_TYPE_8_0 = Enum.GarrisonType.Type_8_0
local LE_GARRISON_TYPE_9_0 = Enum.GarrisonType.Type_9_0

local cr, cg, cb, color
local tL, tR, tT, tB = unpack(DB.TexCoord)

function MAP:CreatePulse()
	if not C.db["Map"]["CombatPulse"] then return end

	local bg = B.CreateBDFrame(Minimap, 0, -C.mult)
	bg:SetFrameStrata("BACKGROUND")

	local anim = bg:CreateAnimationGroup()
	anim:SetLooping("BOUNCE")
	anim.fader = anim:CreateAnimation("Alpha")
	anim.fader:SetFromAlpha(.8)
	anim.fader:SetToAlpha(.2)
	anim.fader:SetDuration(1)
	anim.fader:SetSmoothing("OUT")

	local function updateMinimapAnim(event)
		if event == "PLAYER_REGEN_DISABLED" then
			bg:SetBackdropBorderColor(1, 0, 0)
			anim:Play()
		elseif not InCombatLockdown() then
			if C_Calendar.GetNumPendingInvites() > 0 or MiniMapMailFrame:IsShown() then
				bg:SetBackdropBorderColor(1, 1, 0)
				anim:Play()
			else
				anim:Stop()
				bg:SetBackdropBorderColor(0, 0, 0)
			end
		end
	end
	B:RegisterEvent("PLAYER_REGEN_ENABLED", updateMinimapAnim)
	B:RegisterEvent("PLAYER_REGEN_DISABLED", updateMinimapAnim)
	B:RegisterEvent("CALENDAR_UPDATE_PENDING_INVITES", updateMinimapAnim)
	B:RegisterEvent("UPDATE_PENDING_MAIL", updateMinimapAnim)

	MiniMapMailFrame:HookScript("OnHide", function()
		if InCombatLockdown() then return end
		anim:Stop()
		bg:SetBackdropBorderColor(0, 0, 0)
	end)
end

local function ToggleLandingPage(_, ...)
	if InCombatLockdown() then UIErrorsFrame:AddMessage(DB.InfoColor..ERR_NOT_IN_COMBAT) return end
	if not C_Garrison.HasGarrison(...) then
		UIErrorsFrame:AddMessage(DB.InfoColor..CONTRIBUTION_TOOLTIP_UNLOCKED_WHEN_ACTIVE)
		return
	end
	ShowGarrisonLandingPage(...)
end

function MAP:ReskinRegions()
	-- Garrison
	hooksecurefunc("GarrisonLandingPageMinimapButton_UpdateIcon", function(self)
		B.UpdatePoint(self, "BOTTOMRIGHT", Minimap, "BOTTOMRIGHT", 6, -6)

		self:GetNormalTexture():SetTexture(DB.garrTex)
		self:GetPushedTexture():SetTexture(DB.garrTex)
		self:GetHighlightTexture():SetTexture(DB.garrTex)
		self:SetSize(30, 30)
	end)

	local menuList = {
		{text =	GARRISON_TYPE_9_0_LANDING_PAGE_TITLE, func = ToggleLandingPage, arg1 = LE_GARRISON_TYPE_9_0, notCheckable = true},
		{text =	WAR_CAMPAIGN, func = ToggleLandingPage, arg1 = LE_GARRISON_TYPE_8_0, notCheckable = true},
		{text =	ORDER_HALL_LANDING_PAGE_TITLE, func = ToggleLandingPage, arg1 = LE_GARRISON_TYPE_7_0, notCheckable = true},
		{text =	GARRISON_LANDING_PAGE_TITLE, func = ToggleLandingPage, arg1 = LE_GARRISON_TYPE_6_0, notCheckable = true},
	}
	GarrisonLandingPageMinimapButton:HookScript("OnMouseDown", function(self, btn)
		if btn == "RightButton" then
			HideUIPanel(GarrisonLandingPage)
			EasyMenu(menuList, B.EasyMenu, self, -80, 0, "MENU", 1)
		end
	end)
	GarrisonLandingPageMinimapButton:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_LEFT")
		GameTooltip:SetText(self.title, 1, 1, 1)
		GameTooltip:AddLine(self.description, nil, nil, nil, true)
		GameTooltip:AddLine(L["SwitchGarrisonType"], nil, nil, nil, true)
		GameTooltip:Show();
	end)

	-- QueueStatus Button
	QueueStatusMinimapButtonBorder:Hide()
	QueueStatusMinimapButtonIconTexture:SetTexture("")
	B.UpdatePoint(QueueStatusMinimapButton, "BOTTOMLEFT", Minimap, "BOTTOMLEFT", -5, -5)

	local queueIcon = Minimap:CreateTexture(nil, "ARTWORK")
	queueIcon:SetPoint("CENTER", QueueStatusMinimapButton)
	queueIcon:SetSize(50, 50)
	queueIcon:SetTexture(DB.eyeTex)
	local anim = queueIcon:CreateAnimationGroup()
	anim:SetLooping("REPEAT")
	anim.rota = anim:CreateAnimation("Rotation")
	anim.rota:SetDuration(2)
	anim.rota:SetDegrees(360)
	hooksecurefunc("QueueStatusFrame_Update", function()
		queueIcon:SetShown(QueueStatusMinimapButton:IsShown())
	end)
	hooksecurefunc("EyeTemplate_StartAnimating", function() anim:Play() end)
	hooksecurefunc("EyeTemplate_StopAnimating", function() anim:Stop() end)

	-- Difficulty Flags
	local flags = {"MiniMapInstanceDifficulty", "GuildInstanceDifficulty", "MiniMapChallengeMode"}
	for _, name in pairs(flags) do
		local flag = _G[name]
		flag:SetScale(.9)
		B.UpdatePoint(flag, "TOPRIGHT", Minimap, "TOPRIGHT", 2, 2)
	end

	-- Mail icon
	MiniMapMailIcon:SetTexture(DB.mailTex)
	MiniMapMailIcon:SetSize(21, 21)
	MiniMapMailIcon:SetVertexColor(1, 1, 0)
	B.UpdatePoint(MiniMapMailFrame, "TOPLEFT", Minimap, "TOPLEFT", -3, 3)

	-- Invites Icon
	GameTimeCalendarInvitesTexture:SetParent("Minimap")
	B.UpdatePoint(GameTimeCalendarInvitesTexture, "TOPRIGHT", Minimap, "TOPRIGHT", 0, 0)

	local Invt = CreateFrame("Button", nil, UIParent)
	Invt:SetPoint("TOPRIGHT", Minimap, "BOTTOMLEFT", -20, -20)
	Invt:SetSize(250, 80)
	Invt:Hide()
	B.ReskinButton(Invt)
	B.CreateFS(Invt, 16, DB.InfoColor..GAMETIME_TOOLTIP_CALENDAR_INVITES)

	local function updateInviteVisibility()
		Invt:SetShown(C_Calendar.GetNumPendingInvites() > 0)
	end
	B:RegisterEvent("CALENDAR_UPDATE_PENDING_INVITES", updateInviteVisibility)
	B:RegisterEvent("PLAYER_ENTERING_WORLD", updateInviteVisibility)

	Invt:SetScript("OnClick", function(_, btn)
		Invt:Hide()
		if btn == "LeftButton" and not InCombatLockdown() then
			ToggleCalendar()
		end
		B:UnregisterEvent("CALENDAR_UPDATE_PENDING_INVITES", updateInviteVisibility)
		B:UnregisterEvent("PLAYER_ENTERING_WORLD", updateInviteVisibility)
	end)
end

function MAP:RecycleBin()
	if not C.db["Map"]["ShowRecycleBin"] then return end

	local blackList = {
		["GameTimeFrame"] = true,
		["MiniMapLFGFrame"] = true,
		["BattlefieldMinimap"] = true,
		["MinimapBackdrop"] = true,
		["TimeManagerClockButton"] = true,
		["FeedbackUIButton"] = true,
		["MiniMapBattlefieldFrame"] = true,
		["QueueStatusMinimapButton"] = true,
		["GarrisonLandingPageMinimapButton"] = true,
		["MinimapZoneTextButton"] = true,
		["RecycleBinFrame"] = true,
		["RecycleBinToggleButton"] = true,
	}

	local bu = CreateFrame("Button", "RecycleBinToggleButton", Minimap)
	bu:SetSize(22, 22)
	bu:SetPoint("LEFT", 0, 0)
	bu.Icon = bu:CreateTexture(nil, "ARTWORK")
	bu.Icon:SetAllPoints()
	bu.Icon:SetTexture(DB.binTex)
	bu:SetHighlightTexture(DB.binTex)
	B.AddTooltip(bu, "ANCHOR_LEFT", L["Minimap RecycleBin"], "white")

	local width, height = 220, 40
	local bin = CreateFrame("Frame", "RecycleBinFrame", UIParent)
	bin:SetPoint("RIGHT", bu, "LEFT", -5, 0)
	bin:SetSize(width, height)
	bin:SetFrameStrata("TOOLTIP")
	bin:Hide()

	local topLine = B.CreateGA(bin, "H", cr, cg, cb, 0, C.alpha, width, C.mult*2)
	topLine:SetPoint("BOTTOM", bin, "TOP")
	local bottomLine = B.CreateGA(bin, "H", cr, cg, cb, 0, C.alpha, width, C.mult*2)
	bottomLine:SetPoint("TOP", bin, "BOTTOM")
	local rightLine = B.CreateGA(bin, "V", cr, cg, cb, C.alpha, C.alpha, C.mult*2, height + C.mult*4)
	rightLine:SetPoint("LEFT", bin, "RIGHT")

	local function hideBinButton()
		bin:Hide()
	end
	local function clickFunc()
		UIFrameFadeOut(bin, .5, 1, 0)
		C_Timer_After(.5, hideBinButton)
	end

	local ignoredButtons = {
		["GatherMatePin"] = true,
		["HandyNotes.-Pin"] = true,
	}
	local function isButtonIgnored(name)
		for addonName in pairs(ignoredButtons) do
			if strmatch(name, addonName) then
				return true
			end
		end
	end

	local isGoodLookingIcon = {
		["Narci_MinimapButton"] = true,
	}

	local iconsPerRow = 10
	local rowMult = iconsPerRow/2 - 1
	local currentIndex, pendingTime, timeThreshold = 0, 5, 12
	local buttons, numMinimapChildren = {}, 0
	local removedTextures = {
		[136430] = true,
		[136467] = true,
	}

	local function KillMinimapButton(child, name)
		local regions = {child:GetRegions()}
		for _, region in pairs(regions) do
			if region:IsObjectType("Texture") then
				local texture = region:GetTexture() or ""
				if removedTextures[texture] or strfind(texture, "Interface\\CharacterFrame") or strfind(texture, "Interface\\Minimap") then
					region:SetTexture("")
				end
				region:ClearAllPoints()
				region:SetAllPoints()
				if not isGoodLookingIcon[name] then
					region:SetTexCoord(tL, tR, tT, tB)
				end
			end

			child:SetSize(34, 34)
		end

		tinsert(buttons, child)
	end

	local function ReskinMinimapButtons()
		for _, child in pairs(buttons) do
			if child and not child.styled then
				child:SetParent(bin)

				if child:HasScript("OnDragStop") then child:SetScript("OnDragStop", nil) end
				if child:HasScript("OnDragStart") then child:SetScript("OnDragStart", nil) end
				if child:HasScript("OnClick") then child:HookScript("OnClick", clickFunc) end

				local bubg = B.CreateBDFrame(child, 0, -C.mult)
				if child:IsObjectType("Button") then
					B.ReskinHLTex(child, bubg)
				elseif child:IsObjectType("Frame") then
					child.highlight = child:CreateTexture(nil, "HIGHLIGHT")
					B.ReskinHLTex(child.highlight, bubg)
				end

				-- Naughty Addons
				local name = child:GetDebugName()
				if name == "DBMMinimapButton" then
					child:SetScript("OnMouseDown", nil)
					child:SetScript("OnMouseUp", nil)
				elseif name == "BagSync_MinimapButton" then
					child:HookScript("OnMouseUp", clickFunc)
				end

				child.styled = true
			end
		end
	end

	local function CollectRubbish()
		local numChildren = Minimap:GetNumChildren()
		if numChildren ~= numMinimapChildren then
			for i = 1, numChildren do
				local child = select(i, Minimap:GetChildren())
				local name = child and child:GetDebugName()
				if name and not child.isExamed and not blackList[name] then
					if (child:IsObjectType("Button") or strmatch(strupper(name), "BUTTON")) and not isButtonIgnored(name) then
						KillMinimapButton(child, name)
					end
					child.isExamed = true
				end
			end

			numMinimapChildren = numChildren
		end

		ReskinMinimapButtons()

		currentIndex = currentIndex + 1
		if currentIndex < timeThreshold then
			C_Timer_After(pendingTime, CollectRubbish)
		end
	end

	local shownButtons = {}
	local function SortRubbish()
		if #buttons == 0 then return end

		wipe(shownButtons)
		for index, button in pairs(buttons) do
			if next(button) and button:IsShown() then -- fix for fuxking AHDB
				tinsert(shownButtons, button)
			end
		end

		local lastbutton
		for index, button in pairs(shownButtons) do
			if not lastbutton then
				B.UpdatePoint(button, "RIGHT", bin, "RIGHT", -3, 0)
			elseif mod(index, iconsPerRow) == 1 then
				B.UpdatePoint(button, "BOTTOM", shownButtons[index - iconsPerRow], "TOP", 0, 3)
			else
				B.UpdatePoint(button, "RIGHT", lastbutton, "LEFT", -3, 0)
			end
			lastbutton = button
		end

		local numShown = #shownButtons
		local row = numShown == 0 and 1 or B:Round((numShown + rowMult) / iconsPerRow)
		local newHeight = row*37 + 3
		bin:SetHeight(newHeight)
		rightLine:SetHeight(newHeight + 2*C.mult)
	end

	bu:SetScript("OnClick", function()
		if bin:IsShown() then
			clickFunc()
		else
			SortRubbish()
			UIFrameFadeIn(bin, .5, 0, 1)
		end
	end)

	CollectRubbish()
end

function MAP:WhoPingsMyMap()
	if not C.db["Map"]["WhoPings"] then return end

	local ping = B.CreateParentFrame(Minimap)
	ping.text = B.CreateFS(ping, 12, "", false, "TOP", 0, -3)

	local anim = ping:CreateAnimationGroup()
	anim:SetScript("OnPlay", function() ping:SetAlpha(1) end)
	anim:SetScript("OnFinished", function() ping:SetAlpha(0) end)
	anim.fader = anim:CreateAnimation("Alpha")
	anim.fader:SetFromAlpha(1)
	anim.fader:SetToAlpha(0)
	anim.fader:SetDuration(3)
	anim.fader:SetSmoothing("OUT")
	anim.fader:SetStartDelay(3)

	B:RegisterEvent("MINIMAP_PING", function(_, unit)
		if unit == "player" then return end -- ignore player ping

		local class = select(2, UnitClass(unit))
		local r, g, b = B.GetClassColor(class)
		local name = GetUnitName(unit)

		anim:Stop()
		ping.text:SetText(name)
		ping.text:SetTextColor(r, g, b)
		anim:Play()
	end)
end

function MAP:UpdateMinimapScale()
	local size = Minimap:GetWidth()
	local scale = C.db["Map"]["MinimapScale"]
	Minimap:SetScale(scale)
	Minimap.mover:SetSize(size*scale, size*scale)
end

function MAP:ShowMinimapClock()
	if C.db["Map"]["Clock"] then
		if not TimeManagerClockButton then LoadAddOn("Blizzard_TimeManager") end
		if not TimeManagerClockButton.styled then
			TimeManagerClockButton:DisableDrawLayer("BORDER")
			TimeManagerClockButton:SetPoint("BOTTOM", Minimap, "BOTTOM", 0, -8)
			TimeManagerClockTicker:SetFont(unpack(DB.Font))
			B.ReskinText(TimeManagerClockTicker, 1, 1, 1)

			TimeManagerClockButton.styled = true
		end
		TimeManagerClockButton:Show()
	else
		if TimeManagerClockButton then TimeManagerClockButton:Hide() end
	end
end

function MAP:ShowCalendar()
	if C.db["Map"]["Calendar"] then
		if not GameTimeFrame.styled then
			GameTimeFrame:SetSize(18, 18)
			GameTimeFrame:SetParent(Minimap)
			GameTimeFrame:SetHitRectInsets(0, 0, 0, 0)
			B.CleanTextures(GameTimeFrame)
			B.UpdatePoint(GameTimeFrame, "BOTTOMRIGHT", Minimap, "BOTTOMRIGHT", 1, 18)

			local regions = {GameTimeFrame:GetRegions()}
			for _, region in pairs(regions) do
				if region and region.SetTextColor then
					region:SetFont(unpack(DB.Font))
					B.ReskinText(region, cr, cg, cb)

					break
				end
			end

			GameTimeFrame.styled = true
		end
		GameTimeFrame:Show()
	else
		GameTimeFrame:Hide()
	end
end

function MAP:Minimap_OnMouseWheel(zoom)
	if zoom > 0 then
		Minimap_ZoomIn()
	else
		Minimap_ZoomOut()
	end
end

local NDuiMiniMapTrackingDropDown = CreateFrame("Frame", "NDuiMiniMapTrackingDropDown", _G.UIParent, "UIDropDownMenuTemplate")
NDuiMiniMapTrackingDropDown:SetID(1)
NDuiMiniMapTrackingDropDown:SetClampedToScreen(true)
NDuiMiniMapTrackingDropDown:Hide()
NDuiMiniMapTrackingDropDown.noResize = true
_G.UIDropDownMenu_Initialize(NDuiMiniMapTrackingDropDown, _G.MiniMapTrackingDropDown_Initialize, "MENU")

function MAP:Minimap_OnMouseUp(btn)
	if btn == "MiddleButton" then
		if InCombatLockdown() then UIErrorsFrame:AddMessage(DB.InfoColor..ERR_NOT_IN_COMBAT) return end
		ToggleCalendar()
	elseif btn == "RightButton" then
		ToggleDropDownMenu(1, nil, NDuiMiniMapTrackingDropDown, "cursor")
	else
		Minimap_OnClick(self)
	end
end

function MAP:SetupHybridMinimap()
	HybridMinimap.CircleMask:SetTexture("Interface\\BUTTONS\\WHITE8X8")
end

function MAP:HybridMinimapOnLoad(addon)
	if addon == "Blizzard_HybridMinimap" then
		MAP:SetupHybridMinimap()
		B:UnregisterEvent(self, MAP.HybridMinimapOnLoad)
	end
end

local minimapInfo = {
	text = L["MinimapHelp"],
	buttonStyle = HelpTip.ButtonStyle.GotIt,
	targetPoint = HelpTip.Point.LeftEdgeBottom,
	onAcknowledgeCallback = B.HelpInfoAcknowledge,
	callbackArg = "MinimapInfo",
	alignment = 3,
}

function MAP:ShowMinimapHelpInfo()
	Minimap:HookScript("OnEnter", function()
		if not NDuiADB["Help"]["MinimapInfo"] then
			HelpTip:Show(MinimapCluster, minimapInfo)
		end
	end)
end

function MAP:SetupMinimap()
	cr, cg, cb = DB.cr, DB.cg, DB.cb
	color = C.db["Skins"]["LineColor"]
	if not C.db["Skins"]["ClassLine"] then cr, cg, cb = color.r, color.g, color.b end

	-- Shape and Position
	Minimap:SetFrameLevel(10)
	Minimap:SetMaskTexture("Interface\\Buttons\\WHITE8X8")
	DropDownList1:SetClampedToScreen(true)

	local mover = B.Mover(Minimap, L["Minimap"], "Minimap", C.Minimap.MinimapPos)
	B.UpdatePoint(Minimap, "TOPRIGHT", mover, "TOPRIGHT")
	Minimap.mover = mover

	self:UpdateMinimapScale()
	self:ShowMinimapClock()
	self:ShowCalendar()

	-- Minimap clicks
	Minimap:EnableMouseWheel(true)
	Minimap:SetScript("OnMouseWheel", MAP.Minimap_OnMouseWheel)
	Minimap:SetScript("OnMouseUp", MAP.Minimap_OnMouseUp)

	-- Hide Blizz
	local frames = {
		"MinimapBorderTop",
		"MinimapNorthTag",
		"MinimapBorder",
		"MinimapZoneTextButton",
		"MinimapZoomOut",
		"MinimapZoomIn",
		"MiniMapWorldMapButton",
		"MiniMapMailBorder",
		"MiniMapTracking",
	}

	for _, v in pairs(frames) do
		B.HideObject(_G[v])
	end
	MinimapCluster:EnableMouse(false)
	Minimap:SetArchBlobRingScalar(0)
	Minimap:SetQuestBlobRingScalar(0)

	-- Add Elements
	self:CreatePulse()
	self:ReskinRegions()
	self:RecycleBin()
	self:WhoPingsMyMap()
	self:ShowMinimapHelpInfo()

	-- HybridMinimap
	B:RegisterEvent("ADDON_LOADED", MAP.HybridMinimapOnLoad)
end