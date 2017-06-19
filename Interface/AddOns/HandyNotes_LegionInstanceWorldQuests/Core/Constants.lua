-- $Id: Constants.lua 28 2017-05-24 15:30:01Z arith $
-----------------------------------------------------------------------
-- Upvalued Lua API.
-----------------------------------------------------------------------
-- Functions
local _G = getfenv(0)
-- Libraries
-- ----------------------------------------------------------------------------
-- AddOn namespace.
-- ----------------------------------------------------------------------------
local FOLDER_NAME, private = ...
private.addon_name = "HandyNotes_LegionInstanceWorldQuests"

local LibStub = _G.LibStub
local L = LibStub("AceLocale-3.0"):GetLocale(private.addon_name)
private.descName = L["HandyNotes - Legion Instance World Quests"]
private.description = L["Shows the World Quest related rare bosses' locations and quests in Legion instances."]
private.pluginName = L["Legion Instance World Quests"]

local constants = {}
private.constants = constants

constants.defaults = {
	profile = {
		show_npcs = true,
		icon_scale = 1.5,
		icon_alpha = 1.0,
		query_server = true,
		show_note = true,
	},
	char = {
		hidden = {
			['*'] = {},
		},
	},
}

constants.icon_texture = {
	door = "Interface\\MINIMAP\\Suramar_Door_Icon",
	yellowButton 	= {
		icon = "Interface\\MINIMAP\\OBJECTICONS",
		tCoordLeft = 0.125, tCoordRight = 0.25, tCoordTop = 0.5, tCoordBottom = 0.625 },
	portal 		= {
		icon = "Interface\\MINIMAP\\OBJECTICONS",
		tCoordLeft = 0.125, tCoordRight = 0.25, tCoordTop = 0.875, tCoordBottom = 1 },
	skull 		= {
		icon = "Interface\\MINIMAP\\OBJECTICONS",
		tCoordLeft = 0.875, tCoordRight = 1, tCoordTop = 0.75, tCoordBottom = 0.875 },
}

-- Define the default icon here
constants.defaultIcon = constants.icon_texture["skull"]

constants.events = {
	"CLOSE_WORLD_MAP",
};
