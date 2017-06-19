-- $Id: DB.lua 27 2017-05-14 14:37:20Z arith $
-----------------------------------------------------------------------
-- Upvalued Lua API.
-----------------------------------------------------------------------
-- Functions
local _G = getfenv(0)
local pairs = _G.pairs;
-- Libraries
-- ----------------------------------------------------------------------------
-- AddOn namespace.
-- ----------------------------------------------------------------------------
local FOLDER_NAME, private = ...
local LibStub = _G.LibStub
local L = LibStub("AceLocale-3.0"):GetLocale(private.addon_name);

local function GetLocaleLibBabble(typ)
	local rettab = {}
	local tab = LibStub(typ):GetBaseLookupTable()
	local loctab = LibStub(typ):GetUnstrictLookupTable()
	for k,v in pairs(loctab) do
		rettab[k] = v;
	end
	for k,v in pairs(tab) do
		if not rettab[k] then
			rettab[k] = v;
		end
	end
	return rettab;
end
local BZ = GetLocaleLibBabble("LibBabble-SubZone-3.0");
local function mapFile(mapID)
	return HandyNotes:GetMapIDtoMapFile(mapID)
end

local DB = {}

private.DB = DB

DB.points = {
	--[[ structure:
	[mapFile] = { -- "_terrain1" etc will be stripped from attempts to fetch this
		[coord] = {
			label = [string], 		-- label: text that'll be the label, optional
			npc = [id], 				-- related npc id, used to display names in tooltip
			type = [string], 			-- the pre-define icon type which can be found in Constant.lua
			class = [CLASS NAME],		-- specified the class name so that this node will only be available for this class
			note=[string],			-- additional notes for this node
		},
	},
	--]]
	["Suramar"] = { -- Suramar
		-- Class specified nodes
		[33084820] = { -- Warrior
			spell = 192085,
			type = "portal", 
			scale = 0.8,
			class = "WARRIOR", 
		},
		[33435044] = { -- Mage
			label = L["Teleportation Nexus"],
			note = format(L["Portal to %s"], BZ["Hall of the Guardian"]), 
			type = "portal", 
			scale = 0.8,
			class = "MAGE" 
		},
		[70207105] = { -- Hunter
			label = L["Great Eagle"], 
			npc = 109572, 
			type = "flight", 
			class = "HUNTER" 
		},
		[41328282] = { -- Hunter
			label = L["Great Eagle"], 
			npc = 109572, 
			type = "flight", 
			class = "HUNTER" 
		},
		-- Common nodes
		-- Ruins of Elune'eth
		[36094727] = {  
			quest = 40956, 
			label = BZ["Ruins of Elune'eth"], 
			type = "portal", 
			hide_before = 40956, 
			hide_indoor = true, -- Ruins of Elune'eth node is a bit overlaped with Shal'Aran, so hide indoor would be better
		},
		[36344493] = {  
			quest = 40956, 
			label = format(L["Portal to %s"], BZ["Ruins of Elune'eth"]), 
			type = "portal", 
			shalaran = true,
			hide_before = 40956, 
			hide_outdoor = true,
			scale = 0.6,
		},
		-- Falanaar
		[22903580] = { -- Falanaar has another map, so this is the entrance in Suramar map
			quest = 42230, 
			type = "door",
			label = BZ["Falanaar"],
			note = L["Entrance"].." - "..BZ["Falanaar"].."\n"..format(L["Portal to %s"], BZ["Shal'Aran"]), 
			hide_before = 42228, 
			--hide_indoor = true,
		}, 
		[35894555] = { 
			quest = 42230, 
			label = format(L["Portal to %s"], BZ["Falanaar"]), 
			type = "portal", 
			shalaran = true,
			hide_before = 42228, 
			hide_outdoor = true, 
			scale = 0.6,
		}, 
		-- Waning Crescent
		[47748138] = { 
			quest = 42487, 
			label = BZ["The Waning Crescent"], 
			type = "portal", 
			hide_after = 43569, 
			hide_before = 42486, 
		}, 
		[36504474] = { 
			quest = 42487, 
			label = format(L["Portal to %s"], BZ["The Waning Crescent"]), 
			type = "portal", 
			shalaran = true,
			hide_after = 43569, 
			hide_before = 42486, 
			hide_outdoor = true, 
			scale = 0.6,
		}, 
		-- Twilight Vineyards
		[64006043] = { 
			quest = 44084, 
			label = BZ["Twilight Vineyards"], 
			type = "portal", 
			hide_before = 42838, 
		}, 
		[36944500] = {
			quest = 44084, 
			label = format(L["Portal to %s"], BZ["Twilight Vineyards"]), 
			type = "portal", 
			shalaran = true,
			hide_before = 42838, 
			hide_outdoor = true,
			scale = 0.6,
		}, 
		-- Evermoon Terrace
		[51997875] = { 
			quest = 42889, 
			label = BZ["Evermoon Terrace"], 
			type = "portal", 
			hide_before = 43569, 
		}, 
		[36504475] = {
			quest = 42889, 
			label = format(L["Portal to %s"], BZ["Evermoon Terrace"]), 
			type = "portal", 
			shalaran = true,
			hide_before = 43569, 
			hide_outdoor = true,
			scale = 0.6,
		}, 
		-- Astravar Harbor
		[54486944] = { 
			quest = 44740, 
			label = BZ["Astravar Harbor"], 
			type = "portal", 
			hide_before = 44738, 
		}, 
		[36764504] = { 
			quest = 44740, 
			label = format(L["Portal to %s"], BZ["Astravar Harbor"]), 
			type = "portal", 
			shalaran = true,
			hide_before = 44738, 
			hide_outdoor = true,
			scale = 0.6,
		}, 
		-- Moon Guard Stronghold
		[30831103] = { 
			quest = 43808, 
			label = BZ["Moonfall Overlook"], 
			type = "portal", 
			hide_before = 40956, 
		}, 
		[36004524] = {
			quest = 43808, 
			label = format(L["Portal to %s"], BZ["Moonfall Overlook"]), 
			type = "portal", 
			shalaran = true,
			hide_before = 40956, 
			hide_outdoor = true,
			scale = 0.6,
		}, 
		-- Moon Guard (entrance)
		[27802230] = { 
			quest = 43808, 
			type = "door",
			label = BZ["Moonfall Overlook"], 
			note = L["Entrance"],
			hide_before = 40956, 
		}, 
		-- Tel'anor
		[42023523] = { 
			quest = 43809, 
			label = BZ["Tel'anor"], 
			type = "portal", 
			hide_before = 40956, 
		},
		[36924466] = { 
			quest = 43809, 
			label = format(L["Portal to %s"], BZ["Tel'anor"]), 
			type = "portal", 
			shalaran = true,
			hide_before = 40956, 
			hide_outdoor = true,
			scale = 0.6,
		},
		-- Sanctum of Order
		[43406057] = { 
			quest = 43813, 
			label = BZ["Sanctum of Order"], 
			type = "portal", 
			hide_before = 40956, 
			hide_outdoor = true, -- hide outdoor as we will show the entrance to Sanctum of Order
		}, 
		[36694465] = { 
			quest = 43813, 
			label = format(L["Portal to %s"], BZ["Sanctum of Order"]), 
			type = "portal", 
			shalaran = true,
			hide_before = 40956, 
			hide_outdoor = true,
			scale = 0.6,
		}, 
		[43366232] = {
			quest = 43813, 
			type = "door",
			label = BZ["Sanctum of Order"], 
			note = L["Entrance"].." - "..BZ["The Grand Promenade"].."\n"..format(L["Portal to %s"], BZ["Shal'Aran"]),
			hide_before = 40956, 
			hide_indoor = true,
		}, 
		[45856450] = {
			quest = 43813, 
			type = "door",
			label = BZ["Sanctum of Order"], 
			note = L["Entrance"].." - "..BZ["Sanctum of Order"].."\n"..format(L["Portal to %s"], BZ["Shal'Aran"]),
			hide_before = 40956, 
			hide_indoor = true,
		}, 
		-- Lunastre Estate
		[43697924] = { 
			quest = 43811, 
			label = BZ["Lunastre Estate"], 
			type = "portal", 
			hide_before = 40956, 
		}, 
		[36154504] = { 
			quest = 43811, 
			label = format(L["Portal to %s"], BZ["Lunastre Estate"]), 
			type = "portal", 
			shalaran = true,
			hide_before = 40956, 
			hide_outdoor = true,
			scale = 0.6,
		}, 
		-- Felsoul Hold
		[35808210] = { -- Felsoul Hold has another map, so here we show the entrance of Felsoul Hold
			quest = 41575, 
			type = "door",
			label = BZ["Felsoul Hold"], 
			note = L["Entrance"].." - "..BZ["Felsoul Hold"].."\n"..format(L["Portal to %s"], BZ["Shal'Aran"]), 
			hide_before = 40956, 
		}, 
		[36104574] = { 
			quest = 41575, 
			label = format(L["Portal to %s"], BZ["Felsoul Hold"]), 
			type = "portal", 
			shalaran = true,
			hide_before = 40956, 
			hide_outdoor = true,
			scale = 0.6,
		}, 
		-- Oculeth's related telemancies
		[49414689] = {
			quest = 40011, -- quest: Oculeth's Workshop
			label = BZ["Oculeth's Workshop"],
			type = "portal",
			note = L["Telemancy to: \n  o Garden\n  - Test Chamber"],
			hide_before = 42229, -- quest: Shal'Aran
			isTelemetryLabRelated = true,
		},
		[55793973] = {
			quest = 40011, -- quest: The Delicate Art of Telemancy. The actual quest ID is 40747 but this node should be useful and available once completed 40011.
			label = BZ["Warpwind Cliffs"].." - "..L["Garden"],
			note = L["Telemancy to: \n  o Fountain\n  o Warp Lab\n  - Library"],
			type = "portal",
			hide_before = 40011, -- quest: Shal'Aran. 
			isTelemetryLabRelated = true,
		},
		[54244446] = {
			quest = 40011, -- quest: The Delicate Art of Telemancy. The actual quest ID is 40747 but this node should be useful and available once completed 40011.
			label = BZ["Warpwind Cliffs"].." - "..L["Fountain"],
			note = L["Telemancy to: \n  o Telemetry Lab\n  o Garden\n  x Breakfast Nook"],
			type = "portal",
			hide_before = 40011, -- quest: Shal'Aran. 
			isTelemetryLabRelated = true,
		},
		[53083682] = {
			quest = 40011, -- quest: The Delicate Art of Telemancy. The actual quest ID is 40747 but this node should be useful and available once completed 40011.
			label = BZ["Warpwind Cliffs"].." - "..L["Telemetry Lab"],
			note = L["Telemancy to: \n  o Fountain"],
			type = "portal",
			hide_before = 40011, -- quest: Shal'Aran. 
			isTelemetryLabRelated = true,
		},
		[52134511] = {
			quest = 40011, -- quest: The Delicate Art of Telemancy. The actual quest ID is 40747 but this node should be useful and available once completed 40011.
			label = BZ["Warpwind Cliffs"].." - "..L["Warp Lab"],
			note = L["Telemancy to: \n  o Workshop"],
			type = "portal",
			hide_before = 40011, -- quest: Shal'Aran. 
			isTelemetryLabRelated = true,
		},
		[59733667] = {
			quest = 40011, -- quest: The Delicate Art of Telemancy. The actual quest ID is 40747 but this node should be useful and available once completed 40011.
			label = BZ["Oculeth's Test Chamber"],
			note = L["Telemancy to: \n  o Workshop"],
			type = "portal",
			hide_before = 40011, -- quest: Shal'Aran. 
			isTelemetryLabRelated = true,
		},
		[56342741] = {
			quest = 40011, -- quest: The Delicate Art of Telemancy. The actual quest ID is 40747 but this node should be useful and available once completed 40011.
			label = BZ["The Drift"].." - "..L["Library"],
			type = "yellowButton",
			hide_before = 40011, -- quest: Shal'Aran. 
			isTelemetryLabRelated = true,
		},
		[55383549] = {
			quest = 40011, -- quest: The Delicate Art of Telemancy. The actual quest ID is 40747 but this node should be useful and available once completed 40011.
			label = BZ["Warpwind Cliffs"].." - "..L["Outside of The Drift"],
			note = L["Telemancy to: \n  - Storage"],
			type = "portal",
			hide_before = 40011, -- quest: Shal'Aran. 
			isTelemetryLabRelated = true,
		},
		[57973505] = {
			quest = 40011, -- quest: The Delicate Art of Telemancy. The actual quest ID is 40747 but this node should be useful and available once completed 40011.
			label = BZ["Warpwind Cliffs"].." - "..L["Storage"],
			note = L["Telemancy to: \n  - Garden"],
			type = "portal",
			hide_before = 40011, -- quest: Shal'Aran. 
			isTelemetryLabRelated = true,
		},
		-- End of Oculeth's related telemancies
		[55333463] = {
			label = BZ["The Drift"],
			note = L["Entrance"],
			type = "door",
			isTelemetryLabRelated = true,
		},
		-- Entrance of caves or special indoor space
		-- Leyline related entrance
		[41733894] = { -- Anora Hollow
			type = "door",
			leyline = true,
			label = format(L["Entrance of %s"], BZ["Ley Station Anora"]), 
		}, 
		[35632405] = { -- Moonwhisper Gulch
			type = "door",
			leyline = true,
			label = format(L["Entrance of %s"], BZ["Ley Station Moonfall"]), 
		}, 
		[24231934] = { -- Moon Guard
			type = "door",
			leyline = true,
			label = format(L["Entrance of %s"], BZ["Ley Station Aethenar"]), 
		}, 
		[59234273] = { -- Kel'balor
			type = "door",
			leyline = true,
			label = format(L["Entrance of %s"], BZ["Kel'balor"]), 
		}, 
		[65854188] = { -- Elor'shan
			type = "door",
			leyline = true,
			label = format(L["Entrance of %s"], BZ["Elor'shan"]), 
		}, 
		[29068463] = { 
			type = "door",
			leyline = true,
			label = format(L["Entrance of %s"], BZ["Halls of the Eclipse"]), 
		}, 
		[20555049] = { 
			type = "door",
			leyline = true,
			label = format(L["Entrance of %s"], BZ["Falanaar Tunnels"]), 
		}, 
		[21374317] = { 
			type = "door",
			leyline = true,
			label = format(L["Entrance of %s"], BZ["Falanaar Tunnels"]), 
		}, 
		[34678438] = { 
			type = "door",
			label = format(L["Entrance of %s"], BZ["The Arcway Vaults"]), 
		}, 
		[34437382] = { 
			type = "door",
			label = format(L["Entrance of %s"], BZ["Felmaw Cavern"]), 
		}, 
		[36587675] = { 
			type = "door",
			label = format(L["Entrance of %s"], BZ["The Fel Breach"]), 
		}, 
		[27167251] = { 
			type = "door",
			label = format(L["Entrance of %s"], BZ["Den of the Demented"]), 
		}, 
		[54714602] = { 
			type = "door",
			label = format(L["Entrance of %s"], BZ["Teloth'aran"]), 
		}, 
		[73046779] = { 
			type = "door",
			label = format(L["Entrance of %s"], BZ["Azuregale Cove"]), 
		}, 
		[35114753] = { 
			type = "door",
			label = format(L["Entrance of %s"], BZ["Shal'Aran"]), 
			scale = 0.8,
			alpha = 0.8,
		}, 
		-- Entrances of undefined places
		[49613380] = { 
			type = "door",
			label = L["Entrance"], 
			isUnspecifiedEntrance = true,
		}, 
		[35903449] = { 
			type = "door",
			label = L["Entrance"], 
			isUnspecifiedEntrance = true,
		}, 
		[23755104] = { 
			type = "door",
			label = L["Entrance"], 
			isUnspecifiedEntrance = true,
		}, 
		[24365092] = { 
			type = "door",
			label = L["Entrance"], 
			isUnspecifiedEntrance = true,
		}, 
		[30235497] = { 
			type = "door",
			label = L["Entrance"], 
			isUnspecifiedEntrance = true,
		}, 
		[38139062] = { 
			type = "door",
			label = L["Entrance"], 
			isUnspecifiedEntrance = true,
		}, 
		[42372999] = { 
			type = "door",
			label = L["Entrance"], 
			isUnspecifiedEntrance = true,
		}, 
		[40412933] = { 
			type = "door",
			label = L["Entrance"], 
			isUnspecifiedEntrance = true,
		}, 
		[19301895] = { 
			type = "door",
			label = L["Entrance"], 
			isUnspecifiedEntrance = true,
		}, 
		[25326382] = { 
			type = "door",
			label = L["Entrance"], 
			isUnspecifiedEntrance = true,
		}, 
		[28495615] = { 
			type = "door",
			label = L["Entrance"], 
			isUnspecifiedEntrance = true,
		}, 
		[61643958] = { 
			type = "door",
			label = L["Entrance"], 
			isUnspecifiedEntrance = true,
		}, 
	},
	["FalanaarTunnels"] = { -- Falanaar / Fal'adore
		[40941368] = { 
			quest = 42230, 
			label = format(L["Portal to %s"], BZ["Shal'Aran"]),
			dungeonLevel = 32, 
			type = "portal", 
			hide_before = 42228,
			hide_outdoor = true,
		}, 
	},
	["SuramarLegionScar"] = { -- Felsoul Hold / The Fel Breach
		[53733676] = { 
			quest = 41575, 
			label = format(L["Portal to %s"], BZ["Shal'Aran"]),
			dungeonLevel = 23,
			type = "portal", 
			hide_before = 40956,
			hide_outdoor = true,
		}, 
		[24609004] = { 
			type = "door",
			label = format(L["Entrance of %s"], BZ["Felsoul Hold"]), 
		}, 
		[29514112] = { 
			type = "door",
			label = format(L["Entrance of %s"], BZ["The Fel Breach"]), 
		}, 
	},
}
