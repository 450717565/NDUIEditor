local _G = getfenv(0)
local FOLDER_NAME, private = ...
private.addon_name = "HandyNotes_TravelGuide"

local LibStub = _G.LibStub
local L = LibStub("AceLocale-3.0"):GetLocale(private.addon_name)

local constants = {}
private.constants = constants

constants.defaults = {
	profile = {
		icon_scale = 1.5,
		icon_alpha = 1.0,
		query_server = true,
		show_portal = true,
		show_boat = true,
		show_zeplin = true,
		show_others = true,
		show_note = true,
		show_valliance = true,
		show_vhorde = true,
	},
	char = {
		hidden = {
			['*'] = {},
		},
	},
}

constants.icon_texture = {
	vehicle 		= "Interface\\MINIMAP\\Vehicle-Air-Occupied",
	-- customized or extracted icons
	portal 		= {
			icon = "Interface\\MINIMAP\\OBJECTICONS",
			tCoordLeft = 0.125, tCoordRight = 0.25, tCoordTop = 0.875, tCoordBottom = 1 },
	valliance	= "Interface\\MINIMAP\\Vehicle-Air-Alliance",
	vhorde		= "Interface\\MINIMAP\\Vehicle-Air-Horde",
	boat 		= "Interface\\AddOns\\HandyNotes_TravelGuide\\Images\\boat",
	zeplin 		= "Interface\\AddOns\\HandyNotes_TravelGuide\\Images\\zeplin",
}