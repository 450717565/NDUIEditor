--[[--------------------------------------------------------------------
	HandyNotes: Ever-Shifting Mirror
	Shows the portals between Draenor and Outland accessed with the Ever-Shifting Mirror.
	Copyright (c) 2014-2015 Shinigami <doomkaster@gmail.com>. All rights reserved.
	http://www.curse.com/addons/wow/handynotes-ever-shifting-mirror
----------------------------------------------------------------------]]


------------------------------------------------------------------------

local portals = {}
portals["NagrandDraenor"] = {
	[50355721] = { 950,	"Nagrand",			"Oshugun Spirit Fields" },
	[88302284] = { 950,	"Zangarmarsh",	"Umbrafen Lake" },
	[71412194] = { 950,	"Nagrand",			"Throne of the Elements" },
	[81100900] = { 950, "Zangarmarsh", 	"Twin Spire Ruins"},
}
portals["FrostfireRidge"] = {
	[21824531] = { 941,	"Blade's Edge Mountains", "Bloodmaul Bridge" },
	[37536071] = { 941,	"Blade's Edge Mountains", "Bloodmaul Ravine" },
}
portals["Gorgrond"] = {
	[49417366] = { 949,	"Blade's Edge Mountains", "Razor Ridge" },
	[50823143] = { 949,	"Blade's Edge Mountains", "Gruul's Lair" },
}
portals["TanaanJungle"] = {
	[70305453] = { 945,	"Hellfire Peninsula", "The Dark Portal" },
	[49565073] = { 945,	"Hellfire Peninsula", "Hellfire Citadel" },
	-- [56312683] = { 945,	"Hellfire Peninsula", "Throne of Kil'jaeden" },
}
portals["ShadowmoonValleyDR"] = {
	[60024837] = { 947,	"Shadowmoon Valley", "The Warden's Cage" },
	[32332876] = { 947,	"Shadowmoon Valley", "Legion Hold" },
}
portals["SpiresOfArak"] = {
	[47401245] = { 948,	"Terokkar Forest", "Skettis" },
}
portals["Talador"] = {
	[57858053] = { 946,	"Terokkar Forest", "The Bone Wastes" },
	[50413519] = { 946,	"Terokkar Forest", "Shattrath City" },
	[68420932] = { 946,	"Zangarmash", "The Path of Glory" },
}


portals["Nagrand"] = {
	[41275904] = { 477,	"Nagrand", "Oshugun Spirit Woods" },
	[60362556] = { 477,	"Nagrand", "Throne of the Elements" },
}
portals["Zangarmarsh"] = {
	[68208846] = { 467,	"Nagrand", "Zangar Shore" },
	[49195537] = { 467,	"Zangar Sea", "Nagrand Coast" },
	[82596613] = { 467,	"Talador", "The Path of Glory" },
}
portals["BladesEdgeMountains"] = {
	[46406460] = { 475,	"Frostfire Ridge", "Gormaul Tower" },
	[39637739] = { 475,	"Frostfire Ridge", "The Burning Glacier" },
	[59117169] = { 475,	"Gorgrond", "Razor Bloom" },
	[66082620] = { 475,	"Gorgrond", "Blackrock Foundry" },
}
portals["Hellfire"] = {
	[80385160] = { 465,	"Tanaan Jungle", "The Dark Portal" },
	[54974890] = { 465,	"Tanaan Jungle", "Hellfire Citadel" },
	[64042173] = { 465,	"Tanaan Jungle", "Throne of Kil'jaeden" },
}
portals["ShadowmoonValley"] = {
	[61534607] = { 473,	"Shadowmoon Valley", "Path of Light" },
	[27103336] = { 473,	"Shadowmoon Valley", "Moonflower Valley" },
}
portals["TerokkarForest"] = {
	[70787588] = { 478,	"Spires of Arak", "Talador Border" },
	[45374753] = { 478,	"Talador", "Deathweb Hollow" },
	[35271251] = { 478,	"Talador", "Shattrath City" },
}

local ADDON_NAME = ...
local PLUGIN = "Ever-Shifting Mirror"
local HEADER = "Ever-Shifting Mirror Portal"
local ICON = "Interface\\ICONS\\trade_archaeology_highbornesoulmirror"
local ADDON_TITLE = GetAddOnMetadata(ADDON_NAME, "Title")
local HandyNotes = LibStub("AceAddon-3.0"):GetAddon("HandyNotes")

------------------------------------------------------------------------

local pluginHandler = {}

function pluginHandler:OnEnter(mapFile, coord)
	local tooltip = self:GetParent() == WorldMapButton and WorldMapTooltip or GameTooltip
	if self:GetCenter() > UIParent:GetCenter() then
		tooltip:SetOwner(self, "ANCHOR_LEFT")
	else
		tooltip:SetOwner(self, "ANCHOR_RIGHT")
	end
	local portal = portals[mapFile][coord]
	if portal then
		tooltip:AddLine(HEADER)
		tooltip:AddLine("Leads to " .. portal[3] .. " in " .. portal[2], 1, 1, 1)
		if TomTom and tooltip:GetOwner():GetParent() ~= Minimap then
			tooltip:AddLine("Ctrl + Right-click to set a waypoint in TomTom")
			tooltip:AddLine("Shift + Right-click to set waypoints for all portals")
		end
		tooltip:Show()
	end
end

function pluginHandler:OnLeave(mapFile, coord)
	local tooltip = self:GetParent() == WorldMapButton and WorldMapTooltip or GameTooltip
	tooltip:Hide()
end
waypoints = {}
do
	local function setWaypoint(mapFile, coord)
		if not waypoints[mapFile] then waypoints[mapFile] = {} end
		local portal = portals[mapFile][coord]
		if not portal then return end
		local x, y = HandyNotes:getXY(coord)
		waypoints[mapFile][coord] = TomTom:AddMFWaypoint(portal[1], nil, x, y, {
			title = "Portal to " .. portal[3],
			persistent = nil,
			minimap = true,
			world = true
		})
	end

	local function setAllWaypoints()
		for mapFile in pairs(portals) do
			for coord in pairs(portals[mapFile]) do
				setWaypoint(mapFile, coord)
			end
		end
		TomTom:SetClosestWaypoint()
	end

	function pluginHandler:OnClick(button, down, mapFile, coord)
		if button ~= "RightButton" or not TomTom then
			return
		end
		if IsShiftKeyDown() then
			setAllWaypoints()
		elseif IsControlKeyDown() then
			setWaypoint(mapFile, coord)
		end
	end
end
do
	local function iterator(t, last)
		if not t then return end
		local k, v = next(t, last)
		while k do
			if v then
				-- coord, mapFile2, iconpath, scale, alpha, level2
				return k, nil, ICON, 1, 1
			end
			k, v = next(t, k)
		end
	end

	function pluginHandler:GetNodes(mapFile, minimap, dungeonLevel)
		return iterator, portals[mapFile]
	end
end

------------------------------------------------------------------------

local Addon = CreateFrame("Frame")
Addon:RegisterEvent("PLAYER_LOGIN")
Addon:SetScript("OnEvent", function(self, event, ...) return self[event](self, ...) end)

function Addon:PLAYER_LOGIN()
	--print("PLAYER_LOGIN")
	HandyNotes:RegisterPluginDB(PLUGIN, pluginHandler)
end
