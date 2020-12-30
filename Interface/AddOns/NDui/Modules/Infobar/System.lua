﻿local _, ns = ...
local B, C, L, DB = unpack(ns)
local oUF = ns.oUF
if not C.Infobar.System then return end

local Infobar = B:GetModule("Infobar")
local info = Infobar:RegisterInfobar("System", C.Infobar.SystemPos)

local ipairs, tinsert, wipe, sort = ipairs, tinsert, wipe, sort
local format, floor, min, max = format, floor, min, max
local GetFramerate, GetTime = GetFramerate, GetTime
local GetNumAddOns, GetAddOnInfo, GetCVarBool, SetCVar = GetNumAddOns, GetAddOnInfo, GetCVarBool, SetCVar
local UpdateAddOnCPUUsage, GetAddOnCPUUsage = UpdateAddOnCPUUsage, GetAddOnCPUUsage
local UpdateAddOnMemoryUsage, GetAddOnMemoryUsage = UpdateAddOnMemoryUsage, GetAddOnMemoryUsage
local IsShiftKeyDown, IsAddOnLoaded = IsShiftKeyDown, IsAddOnLoaded
local ResetCPUUsage, collectgarbage, gcinfo = ResetCPUUsage, collectgarbage, gcinfo

local maxAddOns = C.Infobar.MaxAddOns
local showMoreString = "%d %s (%s)"
local usageString = "%.3f MS"
local scriptProfileStatus = GetCVarBool("scriptProfile")
local entered

local function formatMemory(value)
	if value > 1024 then
		return format("%.1f MB", value / 1024)
	else
		return format("%.0f KB", value)
	end
end

local function sortByMemory(a, b)
	if a and b then
		return (a[3] == b[3] and a[2] < b[2]) or a[3] > b[3]
	end
end

local function sortByCPU(a, b)
	if a and b then
		return (a[4] == b[4] and a[2] < b[2]) or a[4] > b[4]
	end
end

local infoTable = {}
local function BuildAddonList()
	local numAddons = GetNumAddOns()
	if numAddons == #infoTable then return end

	wipe(infoTable)
	for i = 1, numAddons do
		local _, title, _, loadable = GetAddOnInfo(i)
		if loadable then
			tinsert(infoTable, {i, title, 0, 0})
		end
	end
end

local function UpdateMemory()
	UpdateAddOnMemoryUsage()

	local total = 0
	for _, data in ipairs(infoTable) do
		if IsAddOnLoaded(data[1]) then
			local mem = GetAddOnMemoryUsage(data[1])
			data[3] = mem
			total = total + mem
		end
	end
	sort(infoTable, sortByMemory)

	return total
end

local function UpdateCPU()
	UpdateAddOnCPUUsage()

	local total = 0
	for _, data in ipairs(infoTable) do
		if IsAddOnLoaded(data[1]) then
			local addonCPU = GetAddOnCPUUsage(data[1])
			data[4] = addonCPU
			total = total + addonCPU
		end
	end
	sort(infoTable, sortByCPU)

	return total
end

local function colorFPS(fps)
	if fps < 30 then
		return "|cffFF0000"..fps.."|r"
	elseif fps < 60 then
		return "|cffFFFF00"..fps.."|r"
	else
		return "|cff00FF00"..fps.."|r"
	end
end

local function setFrameRate(self)
	local fps = floor(GetFramerate())
	self.text:SetFormattedText("%s：%s", L["Framerate"], colorFPS(fps))
end

info.onUpdate = function(self, elapsed)
	self.timer = (self.timer or 0) + elapsed
	if self.timer > 1 then
		setFrameRate(self)
		if entered then self:onEnter() end

		self.timer = 0
	end
end

local switchList = {
	[false] = "|cffFF0000"..VIDEO_OPTIONS_DISABLED,
	[true] = "|cff00FF00"..VIDEO_OPTIONS_ENABLED,
}

info.onEnter = function(self)
	entered = true

	if not next(infoTable) then BuildAddonList() end
	local maxShown = IsShiftKeyDown() and #infoTable or min(maxAddOns, #infoTable)

	GameTooltip:SetOwner(self, "ANCHOR_BOTTOM", 0, -15)
	GameTooltip:ClearLines()

	if self.showMemory or not scriptProfileStatus then
		local totalMemory = UpdateMemory()
		GameTooltip:AddDoubleLine(SYSTEMOPTIONS_MENU, formatMemory(totalMemory), 0,.6,1, .6,.8,1)
		GameTooltip:AddLine(" ")

		local numEnabled = 0
		for _, data in ipairs(infoTable) do
			if IsAddOnLoaded(data[1]) then
				numEnabled = numEnabled + 1
				if numEnabled <= maxShown then
					local r, g, b = B.SmoothColor(data[3], totalMemory, true)
					GameTooltip:AddDoubleLine(data[2], formatMemory(data[3]), 1,1,1, r,g,b)
				end
			end
		end

		if not IsShiftKeyDown() and (numEnabled > maxAddOns) then
			local hiddenMemory = 0
			for i = (maxAddOns + 1), numEnabled do
				hiddenMemory = hiddenMemory + infoTable[i][3]
			end
			GameTooltip:AddDoubleLine(format(showMoreString, numEnabled - maxAddOns, L["Hidden"], L["Hold Shift"]), formatMemory(hiddenMemory), .6,.8,1, .6,.8,1)
		end
	else
		local totalCPU = UpdateCPU()
		local passedTime = max(1, GetTime() - Infobar.loginTime)
		GameTooltip:AddDoubleLine(SYSTEMOPTIONS_MENU, format(usageString, totalCPU / passedTime, 0,.6,1, .6,.8,1))
		GameTooltip:AddLine(" ")

		local numEnabled = 0
		for _, data in ipairs(infoTable) do
			if IsAddOnLoaded(data[1]) then
				numEnabled = numEnabled + 1
				if numEnabled <= maxShown then
					local r, g, b = B.SmoothColor(data[4], totalCPU, true)
					GameTooltip:AddDoubleLine(data[2], format(usageString, data[4] / passedTime), 1,1,1, r,g,b)
				end
			end
		end

		if not IsShiftKeyDown() and (numEnabled > maxAddOns) then
			local hiddenUsage = 0
			for i = (maxAddOns + 1), numEnabled do
				hiddenUsage = hiddenUsage + infoTable[i][4]
			end
			GameTooltip:AddDoubleLine(format(showMoreString, numEnabled - maxAddOns, L["Hidden"], L["Hold Shift"]), format(usageString, hiddenUsage / passedTime), .6,.8,1, .6,.8,1)
		end
	end

	GameTooltip:AddDoubleLine(" ", DB.LineString)
	GameTooltip:AddDoubleLine(" ", DB.LeftButton..L["Collect Memory"].." ", 1,1,1, .6,.8,1)
	if scriptProfileStatus then
		GameTooltip:AddDoubleLine(" ", DB.RightButton..L["SwitchSystemInfo"].." ", 1,1,1, .6,.8,1)
	end
	GameTooltip:AddDoubleLine(" ", DB.ScrollButton..L["CPU Usage"]..switchList[GetCVarBool("scriptProfile")].." ", 1,1,1, .6,.8,1)
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

info.onMouseUp = function(self, btn)
	if btn == "LeftButton" then
		if scriptProfileStatus then
			ResetCPUUsage()
			Infobar.loginTime = GetTime()
		end
		local before = gcinfo()
		collectgarbage("collect")
		print(format("|cff66C6FF%s：|r%s", L["Collect Memory"], formatMemory(before - gcinfo())))
		self:onEnter()
	elseif btn == "RightButton" and scriptProfileStatus then
		self.showMemory = not self.showMemory
		self:onEnter()
	elseif btn == "MiddleButton" then
		if GetCVarBool("scriptProfile") then
			SetCVar("scriptProfile", 0)
		else
			SetCVar("scriptProfile", 1)
		end

		if GetCVarBool("scriptProfile") == scriptProfileStatus then
			StaticPopup_Hide("CPUUSAGE")
		else
			StaticPopup_Show("CPUUSAGE")
		end
		self:onEnter()
	end
end