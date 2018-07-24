local _, ns = ...
local B, C, L, DB = unpack(ns)
if not C.Infobar.Location then return end

local module = B:GetModule("Infobar")
local info = module:RegisterInfobar(C.Infobar.LocationPos)
local mapModule = B:GetModule("Maps")

local zoneInfo = {
	sanctuary = {SANCTUARY_TERRITORY, {.41, .8, .94}},
	arena = {FREE_FOR_ALL_TERRITORY, {1, .1, .1}},
	friendly = {FACTION_CONTROLLED_TERRITORY, {.1, 1, .1}},
	hostile = {FACTION_CONTROLLED_TERRITORY, {1, .1, .1}},
	contested = {CONTESTED_TERRITORY, {1, .7, 0}},
	combat = {COMBAT_ZONE, {1, .1, .1}},
	neutral = {format(FACTION_CONTROLLED_TERRITORY, FACTION_STANDING_LABEL4), {1, .93, .76}}
}

local subzone, zone, pvp, coordX, coordY

local function UpdateCoords(self, elapsed)
	self.elapsed = (self.elapsed or 0) + elapsed
	if self.elapsed > .1 then
		coordX, coordY = mapModule:PlayerCoords(C_Map.GetBestMapForUnit("player"))
		self:GetScript("onEvent")(self)
		self.elapsed = 0
	end
end

local function FormatCoords()
	local coords = ""
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
		if (not coordX) or (not coordY) or (orcoordX == 0) or (coordY == 0) then
			coords = "-- , --"
		else
			coords = format("%.1f , %.1f", coordX * 100, coordY * 100)
		end
	end
	return coords
end

local function CurrentZone()
	local currentzone = ""
	if subzone and subzone ~= "" and subzone ~= zone then
		currentzone = subzone
	else
		currentzone = zone
	end
	return currentzone
end

local function TotalZone()
	local totalzone = ""
	if subzone and subzone ~= "" and subzone ~= zone then
		totalzone = zone.." - "..subzone
	else
		totalzone = zone
	end
	return totalzone
end

info.eventList = {
	"ZONE_CHANGED",
	"ZONE_CHANGED_INDOORS",
	"ZONE_CHANGED_NEW_AREA",
	"PLAYER_ENTERING_WORLD",
}

info.onEvent = function(self)
	self:SetScript("OnUpdate", UpdateCoords)

	subzone, zone, pvp = GetSubZoneText(), GetZoneText(), {GetZonePVPInfo()}
	if not pvp[1] then pvp[1] = "neutral" end
	local r, g, b = unpack(zoneInfo[pvp[1]][2])

	self.text:SetFormattedText("%s <%s>", CurrentZone(), FormatCoords())
	self.text:SetTextColor(r, g, b)
	self.text:SetJustifyH("LEFT")
end

local function isInvasionPoint()
	local mapID = C_Map.GetBestMapForUnit("player")
	local invaName = C_Scenario.GetInfo()
	if mapID and mapID >= 921 and mapID <= 926 and invaName then
		return true
	end
end

info.onEnter = function(self)
	GameTooltip:SetOwner(self, "ANCHOR_BOTTOM", 0, -15)
	GameTooltip:ClearLines()

	if not pvp[1] then pvp[1] = "neutral" end
	local r, g, b = unpack(zoneInfo[pvp[1]][2])

	GameTooltip:AddLine(format("%s", zone), r, g, b)
	GameTooltip:AddDoubleLine(" ", DB.LineString)
	GameTooltip:AddDoubleLine(" ", DB.LeftButton..L["WorldMap"].." ", 1,1,1, .6,.8,1)

	if isInvasionPoint() then
		GameTooltip:AddDoubleLine(" ", DB.ScrollButton..L["Search Invasion Group"].." ", 1,1,1, .6,.8,1)
	end

	GameTooltip:AddDoubleLine(" ", DB.RightButton..L["Send My Pos"].." ", 1,1,1, .6,.8,1)
	GameTooltip:Show()
end

info.onLeave = function()
	GameTooltip:Hide()
end

info.onMouseUp = function(_, btn)
	if btn == "LeftButton" then
		ToggleFrame(WorldMapFrame)
	elseif btn == "MiddleButton" and isInvasionPoint() then
		PVEFrame_ShowFrame("GroupFinderFrame", LFGListPVEStub)
		LFGListCategorySelection_SelectCategory(LFGListFrame.CategorySelection, 6, 0)
		LFGListCategorySelection_StartFindGroup(LFGListFrame.CategorySelection, zone)
	elseif btn == "RightButton" then
		ChatFrame_OpenChat(format("%s %s <%s>", L["My Position"], TotalZone(), FormatCoords()), SELECTED_DOCK_FRAME)
	end
end