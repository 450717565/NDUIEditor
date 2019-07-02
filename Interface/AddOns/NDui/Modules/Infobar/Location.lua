local _, ns = ...
local B, C, L, DB = unpack(ns)
if not C.Infobar.Location then return end

local module = B:GetModule("Infobar")
local info = module:RegisterInfobar("Location", C.Infobar.LocationPos)
local mapModule = B:GetModule("Maps")

local format, unpack = string.format, unpack
local WorldMapFrame, SELECTED_DOCK_FRAME, ChatFrame_OpenChat = WorldMapFrame, SELECTED_DOCK_FRAME, ChatFrame_OpenChat
local GetSubZoneText, GetZoneText, GetZonePVPInfo, IsInInstance = GetSubZoneText, GetZoneText, GetZonePVPInfo, IsInInstance
local C_Map_GetBestMapForUnit = C_Map.GetBestMapForUnit

local zoneInfo = {
	arena = {FREE_FOR_ALL_TERRITORY, {1, .1, .1}},
	combat = {COMBAT_ZONE, {1, .1, .1}},
	contested = {CONTESTED_TERRITORY, {1, .7, 0}},
	friendly = {FACTION_CONTROLLED_TERRITORY, {.1, 1, .1}},
	hostile = {FACTION_CONTROLLED_TERRITORY, {1, .1, .1}},
	sanctuary = {SANCTUARY_TERRITORY, {.41, .8, .94}},
	neutral = {format(FACTION_CONTROLLED_TERRITORY, FACTION_NEUTRAL), {1, .93, .76}}
}

local pvpType, zone, subZone, currentZone, totalZone, coordX, coordY, coords, r, g, b

local function UpdateZones()
	if subZone and subZone ~= "" and subZone ~= zone then
		currentZone = subZone
		totalZone = zone.." - "..subZone
	else
		currentZone = zone
		totalZone = zone
	end
end

local function UpdateCoords(self, elapsed)
	self.elapsed = (self.elapsed or 0) + elapsed
	if self.elapsed > .1 then
		coordX, coordY = mapModule:GetPlayerMapPos(C_Map_GetBestMapForUnit("player"))
		self:GetScript("onEvent")(self)

		self.elapsed = 0
	end
end

local function FormatCoords()
	if IsInInstance() then
		local name, instanceType, difficultyID, difficultyName = GetInstanceInfo()
		if instanceType == "arena" then
			coords = ARENA
		elseif instanceType == "pvp" then
			coords = BATTLEGROUND
		else
			coords = difficultyName
		end
	else
		if coordX and coordY then
			coords = format("%.1f , %.1f", coordX * 100, coordY * 100)
		else
			coords = "-- , --"
		end
	end
end

info.eventList = {
	"ZONE_CHANGED",
	"ZONE_CHANGED_INDOORS",
	"ZONE_CHANGED_NEW_AREA",
	"PLAYER_ENTERING_WORLD",
}

info.onEvent = function(self)
	self:SetScript("OnUpdate", UpdateCoords)

	zone, subZone, pvpType = GetZoneText(), GetSubZoneText(), {GetZonePVPInfo()}

	UpdateZones()
	FormatCoords()

	if not pvpType[1] then pvpType[1] = "neutral" end
	r, g, b = unpack(zoneInfo[pvpType[1]][2])

	self.text:SetFormattedText("%s <%s>", currentZone, coords)
	self.text:SetTextColor(r, g, b)
end

info.onEnter = function(self)
	GameTooltip:SetOwner(self, "ANCHOR_BOTTOM", 0, -15)
	GameTooltip:ClearLines()
	GameTooltip:AddLine(ZONE, 0,.6,1)
	GameTooltip:AddLine(" ")

	GameTooltip:AddDoubleLine(zone, format(zoneInfo[pvpType[1]][1], pvpType[3] or ""), r,g,b, r,g,b)
	GameTooltip:AddDoubleLine(" ", DB.LineString)
	GameTooltip:AddDoubleLine(" ", DB.LeftButton..L["WorldMap"].." ", 1,1,1, .6,.8,1)
	GameTooltip:AddDoubleLine(" ", DB.RightButton..L["Send My Pos"].." ", 1,1,1, .6,.8,1)
	GameTooltip:Show()
end

info.onLeave = function()
	GameTooltip:Hide()
end

info.onMouseUp = function(_, btn)
	if btn == "LeftButton" then
		if InCombatLockdown() then UIErrorsFrame:AddMessage(DB.InfoColor..ERR_NOT_IN_COMBAT) return end
		ToggleFrame(WorldMapFrame)
	elseif btn == "RightButton" then
		ChatFrame_OpenChat(format("%s%s <%s>", L["My Position"], totalZone, coords), SELECTED_DOCK_FRAME)
	end
end