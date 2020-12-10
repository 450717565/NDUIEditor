local _, ns = ...
local B, C, L, DB = unpack(ns)
if not C.Infobar.Latency then return end

local Infobar = B:GetModule("Infobar")
local info = Infobar:RegisterInfobar("Latency", C.Infobar.LatencyPos)

local max, format = max, format
local GetNetStats, GetNetIpTypes, GetCVarBool = GetNetStats, GetNetIpTypes, GetCVarBool
local GetAvailableBandwidth, GetDownloadedPercentage = GetAvailableBandwidth, GetDownloadedPercentage
local GetFileStreamingStatus, GetBackgroundLoadingStatus = GetFileStreamingStatus, GetBackgroundLoadingStatus
local UNKNOWN = UNKNOWN
local entered

local function colorLatency(latency)
	if latency < 250 then
		return "|cff00FF00"..latency.."|r"
	elseif latency < 500 then
		return "|cffFFFF00"..latency.."|r"
	else
		return "|cffFF0000"..latency.."|r"
	end
end

local function setLatency(self)
	local _, _, latencyHome, latencyWorld = GetNetStats()
	local latency = max(latencyHome, latencyWorld)
	self.text:SetFormattedText("%s：%s", L["Latency"], colorLatency(latency))
end

info.onUpdate = function(self, elapsed)
	self.timer = (self.timer or 0) + elapsed
	if self.timer > 1 then
		setLatency(self)
		if entered then self:onEnter() end

		self.timer = 0
	end
end

local ipTypes = {"IPv4", "IPv6"}
info.onEnter = function(self)
	entered = true

	GameTooltip:SetOwner(self, "ANCHOR_BOTTOM", 0, -15)
	GameTooltip:ClearLines()
	GameTooltip:AddLine(L["Latency"], 0,.6,1)
	GameTooltip:AddLine(" ")

	local _, _, latencyHome, latencyWorld = GetNetStats()
	GameTooltip:AddDoubleLine(L["Home Latency"], colorLatency(latencyHome).."|r MS", .6,.8,1, 1,1,1)
	GameTooltip:AddDoubleLine(L["World Latency"], colorLatency(latencyWorld).."|r MS", .6,.8,1, 1,1,1)

	if GetCVarBool("useIPv6") then
		local ipTypeHome, ipTypeWorld = GetNetIpTypes()
		GameTooltip:AddLine(" ")
		GameTooltip:AddDoubleLine(L["Home Protocol"], ipTypes[ipTypeHome or 0] or UNKNOWN, .6,.8,1, 1,1,1)
		GameTooltip:AddDoubleLine(L["World Protocol"], ipTypes[ipTypeWorld or 0] or UNKNOWN, .6,.8,1, 1,1,1)
	end

	local downloading = GetFileStreamingStatus() ~= 0 or GetBackgroundLoadingStatus() ~= 0
	if downloading then
		GameTooltip:AddLine(" ")
		GameTooltip:AddDoubleLine(L["Bandwidth"], format("%.2f Mbps", GetAvailableBandwidth()), .6,.8,1, 1,1,1)
		GameTooltip:AddDoubleLine(L["Download"], format("%.2f%%", GetDownloadedPercentage()*100), .6,.8,1, 1,1,1)
	end

	GameTooltip:Show()
end

info.onLeave = function()
	entered = false
	GameTooltip:Hide()
end