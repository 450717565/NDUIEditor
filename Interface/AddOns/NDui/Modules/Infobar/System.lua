local _, ns = ...
local B, C, L, DB, F = unpack(ns)
if not C.Infobar.System then return end

local module = B:GetModule("Infobar")
local info = module:RegisterInfobar("System", C.Infobar.SystemPos)
local min, max, floor, mod, format, sort, select = math.min, math.max, math.floor, mod, string.format, table.sort, select
local GetFramerate, GetNetStats, GetTime, GetCVarBool, SetCVar = GetFramerate, GetNetStats, GetTime, GetCVarBool, SetCVar
local GetNumAddOns, GetAddOnInfo, IsShiftKeyDown, IsAddOnLoaded = GetNumAddOns, GetAddOnInfo, IsShiftKeyDown, IsAddOnLoaded
local UpdateAddOnCPUUsage, GetAddOnCPUUsage, ResetCPUUsage = UpdateAddOnCPUUsage, GetAddOnCPUUsage, ResetCPUUsage
local VIDEO_OPTIONS_ENABLED, VIDEO_OPTIONS_DISABLED, FRAMERATE_LABEL = VIDEO_OPTIONS_ENABLED, VIDEO_OPTIONS_DISABLED, FRAMERATE_LABEL

local usageTable, startTime, showMode, entered = {}, 0, 0
local usageString = "%.3f Ms"

local framerate, latencyHome, latencyWorld, latency = 0, 0, 0, 0

local function updateValue()
	framerate = floor(GetFramerate())
	latencyHome = select(3, GetNetStats())
	latencyWorld = select(4, GetNetStats())
	latency = max(latencyHome, latencyWorld)
end

local function colorLatency(latency)
	if latency < 250 then
		return "|cff00C000"..latency.."|r"
	elseif latency < 500 then
		return "|cffC0C000"..latency.."|r"
	else
		return "|cffC00000"..latency.."|r"
	end
end

local function colorFPS(framerate)
	if framerate < 30 then
		return "|cffC00000"..framerate.."|r"
	elseif framerate < 60 then
		return "|cffC0C000"..framerate.."|r"
	else
		return "|cff00C000"..framerate.."|r"
	end
end

local function setFrameRate(self)
	self.text:SetFormattedText(L["Fps: %s"], colorFPS(framerate))
end

local function setLatency(self)
	self.text:SetFormattedText(L["Ms: %s"], colorLatency(latency))
end

local function setBothShow(self)
	self.text:SetFormattedText(L["Fps: %s"]..DB.Separator..L["Ms: %s"], colorFPS(framerate), colorLatency(latency))
end

info.onUpdate = function(self, elapsed)
	self.timer = (self.timer or 0) + elapsed
	if self.timer > 1 then
		updateValue()

		if NDuiADB["SystemInfoType"] == 1 then
			setFrameRate(self)
		elseif NDuiADB["SystemInfoType"] == 2 then
			setLatency(self)
		elseif NDuiADB["SystemInfoType"] == 3 then
			setBothShow(self)
		else
			showMode = mod(showMode + 1, 10)
			if showMode > 4 then
				setFrameRate(self)
			else
				setLatency(self)
			end
		end
		if entered then self:onEnter() end

		self.timer = 0
	end
end

local function updateUsageTable()
	local numAddons = GetNumAddOns()
	if numAddons == #usageTable then return end

	wipe(usageTable)
	for i = 1, numAddons do
		usageTable[i] = {i, select(2, GetAddOnInfo(i)), 0}
	end
end

local function sortUsage(a, b)
	if a and b then
		return a[3] > b[3]
	end
end

local function updateUsage()
	UpdateAddOnCPUUsage()

	local total = 0
	for i = 1, #usageTable do
		local value = usageTable[i]
		value[3] = GetAddOnCPUUsage(value[1])
		total = total + value[3]
	end
	sort(usageTable, sortUsage)

	return total
end

local systemText = {
	[0] = DB.MyColor..L["Rotation"],
	[1] = DB.MyColor..L["FPS"],
	[2] = DB.MyColor..L["Latency"],
	[3] = DB.MyColor..L["FPS"].." | "..L["Latency"],
}

info.onEnter = function(self)
	entered = true
	GameTooltip:SetOwner(self, "ANCHOR_BOTTOM", 0, -15)
	GameTooltip:ClearLines()
	GameTooltip:AddLine(SYSTEMOPTIONS_MENU, 0,.6,1)
	GameTooltip:AddLine(" ")

	local scriptProfile = GetCVarBool("scriptProfile")
	if scriptProfile then
		updateUsageTable()
		local totalCPU = updateUsage()
		if totalCPU > 0 then
			local maxAddOns = C.Infobar.MaxAddOns
			local isShiftKeyDown = IsShiftKeyDown()
			local maxShown = isShiftKeyDown and #usageTable or min(maxAddOns, #usageTable)
			local numEnabled = 0
			for i = 1, #usageTable do
				local value = usageTable[i]
				if value and IsAddOnLoaded(value[1]) then
					numEnabled = numEnabled + 1
					if numEnabled <= maxShown then
						local r = value[3] / totalCPU
						local g = 1.5 - r
						GameTooltip:AddDoubleLine(value[2], format(usageString, value[3] / max(1, GetTime() - module.loginTime)), 1,1,1, r,g,0)
					end
				end
			end

			if not isShiftKeyDown and (numEnabled > maxAddOns) then
				local hiddenUsage = 0
				for i = (maxAddOns + 1), numEnabled do
					hiddenUsage = hiddenUsage + usageTable[i][3]
				end
				GameTooltip:AddDoubleLine(format("%d %s (%s)", numEnabled - maxAddOns, L["Hidden"], L["Hold Shift"]), format(usageString, hiddenUsage), .6,.8,1, .6,.8,1)
			end
			GameTooltip:AddLine(" ")
		end
	end

	GameTooltip:AddDoubleLine(L["Home Latency"], colorLatency(latencyHome), .6,.8,1, 1,1,1)
	GameTooltip:AddDoubleLine(L["World Latency"], colorLatency(latencyWorld), .6,.8,1, 1,1,1)
	GameTooltip:AddDoubleLine(L["Frame Rate"], colorFPS(framerate), .6,.8,1, 1,1,1)
	GameTooltip:AddDoubleLine(" ", DB.LineString)
	if scriptProfile then
		GameTooltip:AddDoubleLine(" ", DB.LeftButton..L["ResetCPUUsage"].." ", 1,1,1, .6,.8,1)
	end
	GameTooltip:AddDoubleLine(" ", DB.RightButton..L["SystemInfoType"]..systemText[NDuiADB["SystemInfoType"]].." ", 1,1,1, .6,.8,1)
	GameTooltip:AddDoubleLine(" ", DB.ScrollButton..L["CPU Usage"]..(scriptProfile and "|cff55ff55"..VIDEO_OPTIONS_ENABLED or "|cffff5555"..VIDEO_OPTIONS_DISABLED).." ", 1,1,1, .6,.8,1)
	GameTooltip:Show()
end

info.onLeave = function()
	entered = false
	GameTooltip:Hide()
end

StaticPopupDialogs["CPUUSAGE"] = {
	text = L["ReloadUI Required"],
	button1 = APPLY,
	button2 = CLASS_TRIAL_THANKS_DIALOG_CLOSE_BUTTON,
	OnAccept = function() ReloadUI() end,
	whileDead = 1,
}

local status = GetCVarBool("scriptProfile")
info.onMouseUp = function(self, btn)
	local scriptProfile = GetCVarBool("scriptProfile")
	if btn == "LeftButton" and scriptProfile then
		ResetCPUUsage()
		module.loginTime = GetTime()
	elseif btn == "RightButton" then
		NDuiADB["SystemInfoType"] = mod(NDuiADB["SystemInfoType"] + 1, 4)
	elseif btn == "MiddleButton" then
		if scriptProfile then
			SetCVar("scriptProfile", 0)
		else
			SetCVar("scriptProfile", 1)
		end

		if GetCVarBool("scriptProfile") == status then
			StaticPopup_Hide("CPUUSAGE")
		else
			StaticPopup_Show("CPUUSAGE")
		end
	end
	self:onEnter()
end